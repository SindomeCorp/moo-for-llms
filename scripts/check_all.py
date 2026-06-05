#!/usr/bin/env python3
"""Run all repository checks in the right order."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
COMMANDS = (
    ("Build example index", [sys.executable, "scripts/build_example_index.py"]),
    ("Validate examples", [sys.executable, "scripts/validate_examples.py"]),
    ("Validate JSONL", [sys.executable, "scripts/validate_jsonl.py"]),
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
