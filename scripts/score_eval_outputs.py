#!/usr/bin/env python3
"""Score model outputs against eval rows with review-oriented MOO checks.

Input rows should be JSONL objects with:

- id: eval id
- output: model answer text

The scorer is intentionally deterministic. It does not judge style or semantic
correctness on its own; it flags missing required shapes, known bad MOO patterns,
static syntax/hygiene problems, and optional live-compile failures.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable


ROOT = Path(__file__).resolve().parents[1]
EVALS_DIR = ROOT / "evals"

DEFAULT_TARGET = "me:llm_syntax_test"

GLOBAL_FORBIDDEN_PATTERNS = [
    {
        "id": "javascript-comment",
        "regex": r"(?m)^\s*(//|/\*)",
        "message": "uses JavaScript-style comments instead of MOO string-literal comments",
    },
    {
        "id": "javascript-try-catch",
        "regex": r"\btry\s*\{|\}\s*catch\s*\(",
        "message": "uses JavaScript-style try/catch instead of MOO try/except/endtry",
    },
    {
        "id": "normal-edit-set-verb-code",
        "regex": r"(?<![\w:$])set_verb_code\s*\(",
        "message": "uses set_verb_code() as a normal editing workflow",
    },
    {
        "id": "program-command-in-source",
        "regex": r"(?m)^\s*@(?:program|verb|args|list)\b",
        "message": "places LambdaCore programming commands inside MOO source",
    },
    {
        "id": "short-utility-ref",
        "regex": r"\$(ou|lu|su|cu)\b",
        "message": "uses short utility refs instead of long corified names",
    },
]

STATIC_CODE_PATTERNS = [
    {
        "id": "portable-empty-map-list-confusion",
        "regex": r"\breturn\s+\[\]\s*;",
        "message": "returns [] where portable code usually needs {}",
    },
    {
        "id": "routine-command-raise",
        "regex": r"(?<![\w:$])raise\s*\(\s*E_(INVARG|PERM|NACC|RECMOVE)\b",
        "message": "raises a routine command error where command UI usually tells and returns",
    },
    {
        "id": "args-type-overcheck",
        "regex": r"\btypeof\s*\(\s*args\s*\)",
        "message": "over-checks typeof(args); args is server-populated as a list unless reassigned",
    },
]

BLOCK_PAIRS = [
    ("if", "endif", r"\bif\s*\(", r"\bendif\b"),
    ("for", "endfor", r"\bfor\b", r"\bendfor\b"),
    ("while", "endwhile", r"\bwhile\s*\(", r"\bendwhile\b"),
    ("try", "endtry", r"\btry\b", r"\bendtry\b"),
    ("fork", "endfork", r"\bfork\s*\(", r"\bendfork\b"),
]


@dataclass
class LiveCompileContext:
    args: argparse.Namespace
    session: Any
    is_successful_compile: Any


def main() -> int:
    parser = argparse.ArgumentParser(description="Score model output JSONL against MOO eval rows")
    parser.add_argument("outputs", type=Path, help="JSONL with id and output fields")
    parser.add_argument("--evals", type=Path, default=EVALS_DIR, help="Eval JSONL file or directory")
    parser.add_argument("--output", type=Path, default=Path("tmp/eval-score-report.json"), help="JSON report path")
    parser.add_argument("--markdown-output", type=Path, help="Optional Markdown review report path")
    parser.add_argument("--require-dialect-label", action="store_true", help="Require non-portable answers to mention their dialect label")
    parser.add_argument("--min-score", type=float, default=1.0, help="Minimum non-blocking score ratio required to pass")
    parser.add_argument("--only-provided", action="store_true", help="Score only eval ids present in the outputs file")
    parser.add_argument("--live-compile", action="store_true", help="Compile outputs for eval rows marked compile_check=true")
    parser.add_argument("--live-compile-all-code", action="store_true", help="Compile every output where code can be extracted")
    parser.add_argument("--target", default=DEFAULT_TARGET, help="Scratch verb target for live compile")
    parser.add_argument("--argspec", default="this none this", help="Scratch verb argspec used when creating the target")
    parser.add_argument("--perms", default="rxd", help="Scratch verb permissions")
    parser.add_argument("--env-file", type=Path, help="Optional env file for live compile MOO credentials")
    parser.add_argument("--idle-ms", type=int, default=2500, help="Idle milliseconds that mark command completion")
    parser.add_argument("--first-timeout-ms", type=int, default=5000, help="Timeout for first response line")
    args = parser.parse_args()

    if not 0 <= args.min_score <= 1:
        print("--min-score must be between 0 and 1", file=sys.stderr)
        return 2

    eval_rows = load_eval_rows(args.evals)
    output_rows = load_jsonl(resolve(args.outputs))
    output_by_id = {row.get("id"): row for row in output_rows}

    live_context = None
    if args.live_compile or args.live_compile_all_code:
        live_context = connect_live_compile(args)

    results = []
    try:
        for eval_id, eval_row in selected_eval_rows(eval_rows, output_by_id, args.only_provided).items():
            output_row = output_by_id.get(eval_id)
            answer = str(output_row.get("output", "")) if output_row else ""
            result = score_row(eval_row, answer, args, live_context)
            result["id"] = eval_id
            result["kind"] = eval_row.get("kind")
            result["topic"] = eval_row.get("topic")
            result["dialect"] = eval_row.get("dialect")
            result["source_file"] = eval_row.get("source_file")
            result["has_output"] = output_row is not None
            results.append(result)
    finally:
        if live_context is not None:
            live_context.session.close()

    report = build_report(eval_rows, output_rows, results)
    output_path = resolve(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    if args.markdown_output:
        markdown_path = resolve(args.markdown_output)
        markdown_path.parent.mkdir(parents=True, exist_ok=True)
        markdown_path.write_text(render_markdown(report), encoding="utf-8")
    print(f"Scored {report['scored']} eval row(s); {report['passed']} passed. Report: {output_path}")
    return 0 if report["passed"] == report["scored"] else 1


def load_eval_rows(path: Path) -> dict[str, dict[str, Any]]:
    resolved = resolve(path)
    files = sorted(resolved.rglob("*.jsonl")) if resolved.is_dir() else [resolved]
    rows: dict[str, dict[str, Any]] = {}
    for file in files:
        for line_number, row in enumerate(load_jsonl(file), start=1):
            row = dict(row)
            row["source_file"] = file.relative_to(ROOT).as_posix()
            row["topic"] = file.stem
            row["line"] = line_number
            rows[str(row["id"])] = row
    return rows


def load_jsonl(path: Path) -> list[dict[str, Any]]:
    rows = []
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.strip():
            rows.append(json.loads(line))
    return rows


def selected_eval_rows(
    eval_rows: dict[str, dict[str, Any]],
    output_by_id: dict[Any, dict[str, Any]],
    only_provided: bool,
) -> dict[str, dict[str, Any]]:
    if not only_provided:
        return eval_rows
    return {eval_id: row for eval_id, row in eval_rows.items() if eval_id in output_by_id}


def score_row(
    eval_row: dict[str, Any],
    answer: str,
    args: argparse.Namespace,
    live_context: LiveCompileContext | None,
) -> dict[str, Any]:
    checks: list[dict[str, Any]] = []
    blocking: list[dict[str, str]] = []
    warnings: list[dict[str, str]] = []
    code_blocks = extract_code_blocks(answer)
    code_text = "\n\n".join(code_blocks)

    if not answer.strip():
        blocking.append(reason("empty_output", "model output is empty"))

    structured_checks = list(eval_row.get("checks", []))
    if structured_checks:
        checks.extend(score_structured_checks(structured_checks, answer))
    else:
        checks.extend(score_legacy_expectations(eval_row, answer))

    blocking.extend(find_row_patterns(eval_row.get("negative_patterns", []), answer, "negative_pattern"))
    blocking.extend(find_row_patterns(eval_row.get("forbidden_patterns", []), answer, "forbidden_pattern"))
    blocking.extend(find_global_forbidden(answer))

    if args.require_dialect_label:
        dialect = str(eval_row.get("dialect", ""))
        if dialect not in ("", "portable") and dialect not in answer.lower():
            blocking.append(reason("dialect_label", f"missing dialect label `{dialect}`"))

    requires_code = bool(eval_row.get("requires_code")) or bool(eval_row.get("compile_check"))
    if requires_code and not code_blocks and not looks_like_moo_code(answer):
        blocking.append(reason("missing_code", "eval row requires code but no MOO-looking code was found"))

    if code_blocks or requires_code or looks_like_moo_code(answer):
        candidate_code = code_text if code_blocks else answer
        blocking.extend(static_moo_hygiene(candidate_code))

    live_compile = maybe_live_compile(eval_row, answer, code_blocks, args, live_context)
    if live_compile and not live_compile["ok"]:
        blocking.append(reason("live_compile", "generated MOO did not compile"))

    earned = sum(check["points"] for check in checks if check["passed"])
    possible = sum(check["points"] for check in checks)
    score = earned / possible if possible else (0.0 if blocking else 1.0)
    passed = not blocking and score >= args.min_score

    return {
        "passed": passed,
        "score": round(score, 4),
        "points_earned": earned,
        "points_possible": possible,
        "blocking": blocking,
        "warnings": warnings,
        "checks": checks,
        "code_blocks": len(code_blocks),
        "live_compile": live_compile,
    }


def score_legacy_expectations(eval_row: dict[str, Any], answer: str) -> list[dict[str, Any]]:
    checks: list[dict[str, Any]] = []
    lowered = answer.lower()
    if "expected" in eval_row:
        expected = str(eval_row["expected"]).strip()
        if expected:
            checks.append(
                check_result(
                    "expected",
                    expected,
                    expected.lower() in lowered,
                    points=1,
                    label="expected text appears",
                )
            )
    for prop in eval_row.get("expected_properties", []):
        checks.append(
            check_result(
                "expected_property",
                str(prop),
                not phrase_tokens_missing(str(prop), lowered),
                points=1,
                label=str(prop),
            )
        )
    return checks


def score_structured_checks(checks: Iterable[dict[str, Any]], answer: str) -> list[dict[str, Any]]:
    results = []
    for check in checks:
        check_type = str(check.get("type"))
        value = str(check.get("value", ""))
        points = check.get("points", 1)
        label = str(check.get("label", value))
        passed = evaluate_check(check_type, value, answer)
        results.append(check_result(check_type, value, passed, points=points, label=label))
    return results


def evaluate_check(check_type: str, value: str, answer: str) -> bool:
    if check_type == "contains":
        return value.lower() in answer.lower()
    if check_type == "not_contains":
        return value.lower() not in answer.lower()
    if check_type == "regex":
        return re.search(value, answer, flags=re.IGNORECASE | re.MULTILINE) is not None
    if check_type == "not_regex":
        return re.search(value, answer, flags=re.IGNORECASE | re.MULTILINE) is None
    return False


def check_result(check_type: str, value: str, passed: bool, points: float, label: str) -> dict[str, Any]:
    return {
        "type": check_type,
        "value": value,
        "label": label,
        "points": points,
        "passed": passed,
    }


def phrase_tokens_missing(phrase: str, lowered_answer: str) -> bool:
    tokens = [token.lower() for token in phrase.replace("`", " ").replace("(", " ").replace(")", " ").split()]
    meaningful = [token.strip(".,:;") for token in tokens if len(token.strip(".,:;")) >= 4]
    if not meaningful:
        return phrase.lower() not in lowered_answer
    return not all(token in lowered_answer for token in meaningful[:5])


def find_row_patterns(patterns: Iterable[str], answer: str, kind: str) -> list[dict[str, str]]:
    failures = []
    for pattern in patterns:
        if re.search(pattern, answer, flags=re.IGNORECASE | re.MULTILINE):
            failures.append(reason(kind, pattern))
    return failures


def find_global_forbidden(answer: str) -> list[dict[str, str]]:
    failures = []
    for pattern in GLOBAL_FORBIDDEN_PATTERNS:
        if re.search(pattern["regex"], answer, flags=re.IGNORECASE | re.MULTILINE):
            failures.append(reason(pattern["id"], pattern["message"]))
    return failures


def static_moo_hygiene(code: str) -> list[dict[str, str]]:
    failures = []
    for index, line in enumerate(code.splitlines(), start=1):
        stripped = line.rstrip()
        if re.match(r'^\s*"', stripped) and not stripped.endswith(";"):
            failures.append(reason("string_comment_semicolon", f"line {index}: string-literal comment must end with `;`"))
        if re.search(r"(?<![\w$])#\d+", stripped):
            failures.append(reason("raw_object_id", f"line {index}: raw object id found; prefer corified refs"))
    for pattern in STATIC_CODE_PATTERNS:
        if re.search(pattern["regex"], code, flags=re.IGNORECASE | re.MULTILINE):
            failures.append(reason(pattern["id"], pattern["message"]))
    for open_name, close_name, open_re, close_re in BLOCK_PAIRS:
        opened = len(re.findall(open_re, code))
        closed = len(re.findall(close_re, code))
        if opened != closed:
            failures.append(reason("unbalanced_block", f"`{open_name}` count {opened} does not match `{close_name}` count {closed}"))
    if re.search(r"`[^'\n]*(?:\n|$)", code):
        failures.append(reason("inline_catch_apostrophe", "inline error-catching expression appears to be missing closing apostrophe"))
    return failures


def extract_code_blocks(answer: str) -> list[str]:
    blocks = []
    fence_re = re.compile(r"```(?:moo|text|[a-zA-Z0-9_-]+)?\s*\n(.*?)```", re.DOTALL)
    for match in fence_re.finditer(answer):
        block = match.group(1).strip()
        if block:
            blocks.append(block)
    return blocks


def looks_like_moo_code(answer: str) -> bool:
    markers = (
        "endif",
        "endfor",
        "endwhile",
        "endtry",
        "endfork",
        "player:tell",
        "return ",
        " = args",
        "{",
    )
    return any(marker in answer for marker in markers)


def maybe_live_compile(
    eval_row: dict[str, Any],
    answer: str,
    code_blocks: list[str],
    args: argparse.Namespace,
    live_context: LiveCompileContext | None,
) -> dict[str, Any] | None:
    if live_context is None:
        return None
    if not args.live_compile_all_code and not eval_row.get("compile_check"):
        return None
    source = "\n\n".join(code_blocks).strip() if code_blocks else answer.strip()
    if not source:
        return {"attempted": False, "ok": False, "output_tail": ["no source found"]}
    note = f"eval score {eval_row['id']}"
    compile_command = f"@program {args.target}\n{source.rstrip()}\n.\n{note}"
    output = live_context.session.command(compile_command)
    ok = bool(live_context.is_successful_compile(output))
    return {
        "attempted": True,
        "ok": ok,
        "output_tail": output.strip().splitlines()[-10:],
    }


def connect_live_compile(args: argparse.Namespace) -> LiveCompileContext:
    scripts_dir = ROOT / "scripts"
    sys.path.insert(0, str(scripts_dir))
    from live_compile_examples import connect_session, is_successful_compile, load_env_file, read_config

    load_env_file(args.env_file)
    config = read_config()
    session = connect_session(config, args)
    return LiveCompileContext(args=args, session=session, is_successful_compile=is_successful_compile)


def build_report(
    eval_rows: dict[str, dict[str, Any]],
    output_rows: list[dict[str, Any]],
    results: list[dict[str, Any]],
) -> dict[str, Any]:
    return {
        "eval_rows": len(eval_rows),
        "output_rows": len(output_rows),
        "scored": len(results),
        "passed": sum(1 for row in results if row["passed"]),
        "missing_outputs": sum(1 for row in results if not row["has_output"]),
        "failures_by_reason": failure_counts(results),
        "summary_by_kind": grouped_summary(results, "kind"),
        "summary_by_topic": grouped_summary(results, "topic"),
        "summary_by_dialect": grouped_summary(results, "dialect"),
        "results": results,
    }


def grouped_summary(results: list[dict[str, Any]], key: str) -> dict[str, dict[str, float]]:
    groups: dict[str, list[dict[str, Any]]] = {}
    for result in results:
        groups.setdefault(str(result.get(key, "unspecified")), []).append(result)
    summary = {}
    for group, rows in sorted(groups.items()):
        summary[group] = {
            "total": len(rows),
            "passed": sum(1 for row in rows if row["passed"]),
            "average_score": round(sum(float(row["score"]) for row in rows) / len(rows), 4),
        }
    return summary


def failure_counts(results: list[dict[str, Any]]) -> dict[str, int]:
    counts: dict[str, int] = {}
    for result in results:
        if not result["has_output"]:
            counts["missing_output"] = counts.get("missing_output", 0) + 1
        for item in result["blocking"]:
            kind = str(item["type"])
            counts[kind] = counts.get(kind, 0) + 1
        for check in result["checks"]:
            if not check["passed"]:
                kind = f"missing_{check['type']}"
                counts[kind] = counts.get(kind, 0) + 1
    return dict(sorted(counts.items()))


def render_markdown(report: dict[str, Any]) -> str:
    lines = [
        "# Eval Score Report",
        "",
        f"- eval rows: {report['eval_rows']}",
        f"- output rows: {report['output_rows']}",
        f"- passed: {report['passed']} / {report['scored']}",
        f"- missing outputs: {report['missing_outputs']}",
        "",
        "## Failures By Reason",
        "",
    ]
    append_counts(lines, report["failures_by_reason"])
    lines.extend(["", "## Summary By Dialect", ""])
    append_group_summary(lines, report["summary_by_dialect"])
    lines.extend(["", "## Summary By Topic", ""])
    append_group_summary(lines, report["summary_by_topic"])
    lines.extend(["", "## Failed Rows", ""])
    failed = [row for row in report["results"] if not row["passed"]]
    if not failed:
        lines.append("- None")
    else:
        for row in failed[:100]:
            reasons = failure_labels(row)
            lines.append(f"- `{row['id']}` ({row.get('kind')}, {row.get('dialect')}, score {row['score']}): {reasons}")
        if len(failed) > 100:
            lines.append(f"- ... {len(failed) - 100} more failed rows omitted")
    lines.append("")
    return "\n".join(lines)


def append_counts(lines: list[str], counts: dict[str, int]) -> None:
    if not counts:
        lines.append("- None")
        return
    for reason, count in counts.items():
        lines.append(f"- `{reason}`: {count}")


def append_group_summary(lines: list[str], summary: dict[str, dict[str, float]]) -> None:
    for key, value in summary.items():
        lines.append(f"- `{key}`: {value['passed']} / {value['total']} passed, avg score {value['average_score']}")


def failure_labels(row: dict[str, Any]) -> str:
    labels = [f"`{item['type']}`" for item in row["blocking"]]
    labels.extend(f"`missing_{check['type']}`" for check in row["checks"] if not check["passed"])
    return ", ".join(labels) if labels else "`score_below_threshold`"


def reason(kind: str, value: str) -> dict[str, str]:
    return {"type": kind, "value": value}


def resolve(path: Path) -> Path:
    return path if path.is_absolute() else ROOT / path


if __name__ == "__main__":
    raise SystemExit(main())
