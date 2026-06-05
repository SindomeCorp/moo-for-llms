#!/usr/bin/env python3
"""Build datasets/example-index.jsonl from examples/**/*.moo."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
EXAMPLES_DIR = ROOT / "examples"
OUTPUT_PATH = ROOT / "datasets" / "example-index.jsonl"
HEADER_RE = re.compile(r'^"\s*([a-z_]+):\s*(.*?)";\s*$')


def main() -> int:
    parser = argparse.ArgumentParser(description="Build a machine-readable example index")
    parser.add_argument("--output", type=Path, default=OUTPUT_PATH, help="Output JSONL path")
    args = parser.parse_args()

    output = args.output if args.output.is_absolute() else ROOT / args.output
    rows = [build_row(path) for path in sorted(EXAMPLES_DIR.rglob("*.moo"))]
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text("".join(json.dumps(row, separators=(",", ":")) + "\n" for row in rows), encoding="utf-8")
    print(f"Wrote {len(rows)} example row(s) to {output.relative_to(ROOT)}.")
    return 0


def build_row(path: Path) -> dict[str, object]:
    lines = path.read_text(encoding="utf-8").splitlines()
    metadata, body_start = parse_header(lines)
    rel_path = path.relative_to(ROOT).as_posix()
    title = metadata["title"]

    row: dict[str, object] = {
        "id": title,
        "path": rel_path,
        **metadata,
        "code": "\n".join(lines),
        "body": "\n".join(lines[body_start:]).lstrip("\n"),
    }
    return row


def parse_header(lines: list[str]) -> tuple[dict[str, str], int]:
    metadata: dict[str, str] = {}
    body_start = 0

    for index, line in enumerate(lines):
        if not line.strip():
            body_start = index + 1
            break

        match = HEADER_RE.match(line)
        if not match:
            body_start = index
            break

        key, value = match.groups()
        metadata[key] = value
    else:
        body_start = len(lines)

    return metadata, body_start


if __name__ == "__main__":
    raise SystemExit(main())
