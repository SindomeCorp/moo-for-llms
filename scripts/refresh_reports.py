#!/usr/bin/env python3
"""Regenerate derived index and report artifacts."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]

COMMANDS = (
    ("Build example index", [sys.executable, "scripts/build_example_index.py"]),
    ("Coverage report", [sys.executable, "scripts/report_coverage.py", "--output", "docs/coverage-report.md"]),
    ("Duplicate report", [sys.executable, "scripts/report_duplicate_examples.py", "--json-output", "tmp/duplicate-example-report.json"]),
    ("Training quality report", [sys.executable, "scripts/report_training_quality.py", "--output", "docs/training-quality-report.md"]),
    ("Eval coverage", [sys.executable, "scripts/report_eval_coverage.py", "--output", "docs/eval-coverage-report.md", "--prompts-output", "tmp/evals/all-prompts.jsonl"]),
    ("Codegen eval prompts", [sys.executable, "scripts/report_eval_coverage.py", "--kind", "codegen", "--output", "tmp/evals/codegen-coverage.md", "--prompts-output", "tmp/evals/codegen-prompts.jsonl"]),
)


def main() -> int:
    for label, command in COMMANDS:
        print(f"== {label} ==", flush=True)
        result = subprocess.run(command, cwd=ROOT)
        if result.returncode:
            return result.returncode
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
