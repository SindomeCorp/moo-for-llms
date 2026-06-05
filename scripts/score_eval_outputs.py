#!/usr/bin/env python3
"""Score model outputs against eval rows with simple text checks.

Input rows should be JSONL objects with:

- id: eval id
- output: model answer text

This is intentionally lightweight. It catches missing exact expected strings
and expected-property phrases, then produces a review report for human followup.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
EVALS_DIR = ROOT / "evals"


def main() -> int:
    parser = argparse.ArgumentParser(description="Score model output JSONL against MOO eval rows")
    parser.add_argument("outputs", type=Path, help="JSONL with id and output fields")
    parser.add_argument("--evals", type=Path, default=EVALS_DIR, help="Eval JSONL file or directory")
    parser.add_argument("--output", type=Path, default=Path("tmp/eval-score-report.json"), help="JSON report path")
    args = parser.parse_args()

    eval_rows = load_eval_rows(args.evals)
    output_rows = load_jsonl(resolve(args.outputs))
    output_by_id = {row.get("id"): row for row in output_rows}

    results = []
    for eval_id, eval_row in sorted(eval_rows.items()):
        output_row = output_by_id.get(eval_id)
        answer = str(output_row.get("output", "")) if output_row else ""
        result = score_row(eval_row, answer)
        result["id"] = eval_id
        result["has_output"] = output_row is not None
        results.append(result)

    report = {
        "eval_rows": len(eval_rows),
        "output_rows": len(output_rows),
        "scored": len(results),
        "passed": sum(1 for row in results if row["passed"]),
        "missing_outputs": sum(1 for row in results if not row["has_output"]),
        "results": results,
    }
    output_path = resolve(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(f"Scored {report['scored']} eval row(s); {report['passed']} passed. Report: {output_path}")
    return 0 if report["passed"] == report["scored"] else 1


def load_eval_rows(path: Path) -> dict[str, dict[str, Any]]:
    resolved = resolve(path)
    files = sorted(resolved.rglob("*.jsonl")) if resolved.is_dir() else [resolved]
    rows: dict[str, dict[str, Any]] = {}
    for file in files:
        for row in load_jsonl(file):
            rows[str(row["id"])] = row
    return rows


def load_jsonl(path: Path) -> list[dict[str, Any]]:
    rows = []
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.strip():
            rows.append(json.loads(line))
    return rows


def score_row(eval_row: dict[str, Any], answer: str) -> dict[str, Any]:
    lowered = answer.lower()
    missing = []
    if "expected" in eval_row:
        expected = str(eval_row["expected"]).strip()
        if expected and expected.lower() not in lowered:
            missing.append({"type": "expected", "value": expected})
    for prop in eval_row.get("expected_properties", []):
        if phrase_tokens_missing(str(prop), lowered):
            missing.append({"type": "expected_property", "value": prop})
    return {
        "passed": not missing,
        "missing": missing,
    }


def phrase_tokens_missing(phrase: str, lowered_answer: str) -> bool:
    tokens = [token.lower() for token in phrase.replace("`", " ").replace("(", " ").replace(")", " ").split()]
    meaningful = [token.strip(".,:;") for token in tokens if len(token.strip(".,:;")) >= 4]
    if not meaningful:
        return phrase.lower() not in lowered_answer
    return not all(token in lowered_answer for token in meaningful[:5])


def resolve(path: Path) -> Path:
    return path if path.is_absolute() else ROOT / path


if __name__ == "__main__":
    raise SystemExit(main())
