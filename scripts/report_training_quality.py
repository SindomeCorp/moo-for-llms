#!/usr/bin/env python3
"""Report training-data hygiene warnings and curation queue state."""

from __future__ import annotations

import argparse
import json
import re
from collections import Counter
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable


ROOT = Path(__file__).resolve().parents[1]
EXAMPLES_DIR = ROOT / "examples"
DATASETS_DIR = ROOT / "datasets"
EVALS_DIR = ROOT / "evals"
DOCS_DIR = ROOT / "docs"
CURATION_INDEX = ROOT / "docs" / "curation" / "pulled-verbs-index.jsonl"

RAW_OBJECT_RE = re.compile(r"(?<![\w$])#\d+")
SHORT_UTILITY_REF_RE = re.compile(r"\$(ou|lu|su|cu)\b")
NON_MOO_COMMENT_RE = re.compile(r"(^|[^:])//|/\*|\*/")
VMS_RE = re.compile(r"\bVMS (NOTE|NOTES|VERSION)\b|Last modified", re.IGNORECASE)
TOASTSTUNT_MARKERS = ("[]", " -> ", " MAP", " BOOL", " WAIF", " ANON")


@dataclass(frozen=True)
class WarningRow:
    path: Path
    line: int
    kind: str
    detail: str

    def relative_path(self) -> str:
        return self.path.relative_to(ROOT).as_posix()


def main() -> int:
    parser = argparse.ArgumentParser(description="Report training-data hygiene warnings")
    parser.add_argument("--output", type=Path, help="Optional markdown report path")
    parser.add_argument("--fail-on-warnings", action="store_true", help="Exit nonzero if warnings are found")
    args = parser.parse_args()

    warnings: list[WarningRow] = []
    warnings.extend(scan_examples())
    warnings.extend(scan_jsonl(DATASETS_DIR / "contrastive-examples.jsonl", fields=("fixed",)))
    warnings.extend(scan_jsonl(DATASETS_DIR / "instruction-examples.jsonl", fields=("output",)))
    for path in sorted(EVALS_DIR.rglob("*.jsonl")):
        warnings.extend(scan_jsonl(path, fields=("expected",)))

    curation_rows = load_jsonl(CURATION_INDEX) if CURATION_INDEX.exists() else []
    warnings.extend(validate_curation_rows(CURATION_INDEX, curation_rows))

    report = render_report(warnings, curation_rows)
    if args.output:
        output = args.output if args.output.is_absolute() else ROOT / args.output
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(report, encoding="utf-8")
    else:
        print(report, end="")

    return 1 if args.fail_on_warnings and warnings else 0


def scan_examples() -> list[WarningRow]:
    warnings: list[WarningRow] = []
    for path in sorted(EXAMPLES_DIR.rglob("*.moo")):
        for line_number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            if is_string_literal_statement(line):
                if VMS_RE.search(line):
                    warnings.append(WarningRow(path, line_number, "vms-note", "VMS/history text appears in a preserved string comment"))
                continue
            if RAW_OBJECT_RE.search(line):
                warnings.append(WarningRow(path, line_number, "raw-object-id", "Raw object id in example code"))
            if SHORT_UTILITY_REF_RE.search(line):
                warnings.append(WarningRow(path, line_number, "short-utility-ref", "Short utility ref in example code"))
            if NON_MOO_COMMENT_RE.search(line):
                warnings.append(WarningRow(path, line_number, "non-moo-comment", "Non-MOO comment syntax in example code"))
            if VMS_RE.search(line):
                warnings.append(WarningRow(path, line_number, "vms-note", "VMS/history text appears in example code"))
    return warnings


def scan_jsonl(path: Path, fields: tuple[str, ...]) -> list[WarningRow]:
    warnings: list[WarningRow] = []
    if not path.exists():
        return warnings
    for line_number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        if not line.strip():
            continue
        row = json.loads(line)
        text = "\n".join(str(row.get(field, "")) for field in fields)
        lowered = text.lower()
        if VMS_RE.search(text) and not ("vms" in lowered and ("remove" in lowered or "removed" in lowered)):
            warnings.append(WarningRow(path, line_number, "vms-note", "VMS/history text appears in JSONL training text"))
        if RAW_OBJECT_RE.search(text):
            warnings.append(WarningRow(path, line_number, "raw-object-id", "Raw object id appears in JSONL training text"))
        if SHORT_UTILITY_REF_RE.search(text):
            warnings.append(WarningRow(path, line_number, "short-utility-ref", "Short utility ref appears in JSONL training text"))
        if contains_code_shaped_non_moo_comment(text):
            warnings.append(WarningRow(path, line_number, "non-moo-comment", "Non-MOO comment syntax appears in JSONL training text"))
        dialect = str(row.get("dialect", ""))
        if (
            dialect == "portable"
            and any(marker in text for marker in TOASTSTUNT_MARKERS)
            and "toaststunt" not in lowered
            and "not portable" not in lowered
        ):
            warnings.append(WarningRow(path, line_number, "portable-toaststunt-marker", "Portable JSONL row contains an obvious ToastStunt marker"))
    return warnings


def validate_curation_rows(path: Path, rows: list[dict[str, Any]]) -> list[WarningRow]:
    warnings: list[WarningRow] = []
    required = {"id", "object", "verb", "tags", "portability", "decision", "example_paths", "notes"}
    seen: set[str] = set()
    for index, row in enumerate(rows, 1):
        missing = sorted(required - set(row))
        if missing:
            warnings.append(WarningRow(path, index, "curation-missing-field", "Missing fields: " + ", ".join(missing)))
        row_id = str(row.get("id", ""))
        if row_id in seen:
            warnings.append(WarningRow(path, index, "curation-duplicate-id", f"Duplicate curation id `{row_id}`"))
        seen.add(row_id)
        if row.get("decision") == "added" and not row.get("example_paths"):
            warnings.append(WarningRow(path, index, "curation-added-without-example", "Added row has no example_paths"))
    return warnings


def load_jsonl(path: Path) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.strip():
            rows.append(json.loads(line))
    return rows


def render_report(warnings: list[WarningRow], curation_rows: list[dict[str, Any]]) -> str:
    lines: list[str] = []
    lines.append("# Training Quality Report")
    lines.append("")
    lines.append("Generated by `python3 scripts/report_training_quality.py`.")
    lines.append("")
    lines.append("## Summary")
    lines.append("")
    lines.append(markdown_table(["Metric", "Count"], [
        ["warnings", len(warnings)],
        ["curation rows", len(curation_rows)],
        ["curation decisions", len({row.get("decision", "") for row in curation_rows})],
    ]))
    lines.append("")
    lines.append(counter_section("Warnings By Kind", Counter(warning.kind for warning in warnings)))
    lines.append("")
    lines.append(counter_section("Curation Decisions", Counter(str(row.get("decision", "")) for row in curation_rows)))
    lines.append("")
    lines.append(counter_section("Curation Tags", Counter(tag for row in curation_rows for tag in row.get("tags", []))))
    lines.append("")
    lines.append("## Warning Details")
    lines.append("")
    if warnings:
        rows = [[warning.relative_path(), warning.line, warning.kind, warning.detail] for warning in warnings[:200]]
        lines.append(markdown_table(["Path", "Line", "Kind", "Detail"], rows))
        if len(warnings) > 200:
            lines.append("")
            lines.append(f"Only the first 200 of {len(warnings)} warnings are shown.")
    else:
        lines.append("- No hygiene warnings found.")
    lines.append("")
    return "\n".join(lines) + "\n"


def counter_section(title: str, counter: Counter[str]) -> str:
    if not counter:
        return f"## {title}\n\n- None"
    rows = [[key or "unspecified", value] for key, value in sorted(counter.items(), key=lambda item: (-item[1], item[0]))]
    return "\n".join([f"## {title}", "", markdown_table(["Value", "Count"], rows)])


def markdown_table(headers: list[str], rows: Iterable[Iterable[Any]]) -> str:
    rows = [[str(cell) for cell in row] for row in rows]
    widths = [len(header) for header in headers]
    for row in rows:
        for index, cell in enumerate(row):
            widths[index] = max(widths[index], len(cell))

    def fmt(row: Iterable[Any]) -> str:
        cells = [str(cell) for cell in row]
        return "| " + " | ".join(cell.ljust(widths[index]) for index, cell in enumerate(cells)) + " |"

    separator = "| " + " | ".join("-" * width for width in widths) + " |"
    return "\n".join([fmt(headers), separator, *(fmt(row) for row in rows)])


def is_string_literal_statement(line: str) -> bool:
    return line.lstrip().startswith('"')


def contains_code_shaped_non_moo_comment(text: str) -> bool:
    for line in text.splitlines():
        stripped = line.strip()
        if not stripped:
            continue
        if NON_MOO_COMMENT_RE.search(line) and looks_like_moo_code_line(stripped):
            return True
    return False


def looks_like_moo_code_line(line: str) -> bool:
    if line.startswith(("//", "/*", "*/")):
        return True
    code_prefixes = (
        "if ",
        "elseif ",
        "else",
        "endif",
        "for ",
        "endfor",
        "while ",
        "endwhile",
        "try",
        "except",
        "finally",
        "endtry",
        "return",
        "player:tell",
        "this:",
        "$",
    )
    if line.startswith(code_prefixes):
        return True
    return any(token in line for token in (" = ", "(", ")", ";"))


if __name__ == "__main__":
    raise SystemExit(main())
