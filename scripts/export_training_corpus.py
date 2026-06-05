#!/usr/bin/env python3
"""Export a filtered JSONL corpus for downstream training pipelines."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path
from typing import Any, Iterable


ROOT = Path(__file__).resolve().parents[1]
EXAMPLE_INDEX_PATH = ROOT / "datasets" / "example-index.jsonl"
INSTRUCTION_PATH = ROOT / "datasets" / "instruction-examples.jsonl"
CONTRASTIVE_PATH = ROOT / "datasets" / "contrastive-examples.jsonl"
EVALS_DIR = ROOT / "evals"
DOCS_DIR = ROOT / "docs"


def main() -> int:
    parser = argparse.ArgumentParser(description="Export filtered MOO training corpus JSONL")
    parser.add_argument("--dialect", action="append", help="Include rows matching this dialect; may be repeated")
    parser.add_argument("--source", action="append", help="Include rows matching this source; may be repeated")
    parser.add_argument("--topic", action="append", help="Include rows matching this topic; may be repeated")
    parser.add_argument("--callable", action="append", help="Include examples matching this callable kind; may be repeated")
    parser.add_argument("--include-repairs", action="store_true", help="Include topic=repairs examples")
    parser.add_argument("--include-contrastive", action="store_true", help="Include contrastive classification rows")
    parser.add_argument("--include-docs", action="store_true", help="Include docs/**/*.md reference rows")
    parser.add_argument("--include-evals", action="store_true", help="Include evals/**/*.jsonl rows; normally keep these held out")
    parser.add_argument("--examples-only", action="store_true", help="Only include example-index rows")
    parser.add_argument("--instructions-only", action="store_true", help="Only include instruction rows")
    parser.add_argument("--exclude-generated-expansion", action="store_true", help="Exclude generated expansion examples such as utility-expanded-* and numbered expansion families")
    parser.add_argument("--output", type=Path, help="Output JSONL path; defaults to stdout")
    args = parser.parse_args()

    if args.examples_only and args.instructions_only:
        parser.error("--examples-only and --instructions-only cannot be combined")

    ensure_example_index()

    rows: list[dict[str, Any]] = []
    if not args.instructions_only:
        rows.extend(filtered_rows(load_jsonl(EXAMPLE_INDEX_PATH), "example", args))
    if not args.examples_only:
        rows.extend(filtered_rows(load_jsonl(INSTRUCTION_PATH), "instruction", args))
    if args.include_contrastive and not args.examples_only and not args.instructions_only:
        rows.extend(filtered_rows(load_jsonl(CONTRASTIVE_PATH), "contrastive", args))
    if args.include_docs and not args.examples_only and not args.instructions_only:
        rows.extend(doc_rows(args))
    if args.include_evals and not args.examples_only and not args.instructions_only:
        for path in sorted(EVALS_DIR.rglob("*.jsonl")):
            rows.extend(filtered_rows(load_jsonl(path), "eval", args, path=path))

    output = "".join(json.dumps(row, separators=(",", ":")) + "\n" for row in rows)
    if args.output:
        path = args.output if args.output.is_absolute() else ROOT / args.output
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(output, encoding="utf-8")
    else:
        sys.stdout.write(output)

    return 0


def ensure_example_index() -> None:
    subprocess.run(
        [sys.executable, "scripts/build_example_index.py"],
        cwd=ROOT,
        check=True,
        stdout=subprocess.DEVNULL,
    )


def load_jsonl(path: Path) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.strip():
            rows.append(json.loads(line))
    return rows


def filtered_rows(rows: Iterable[dict[str, Any]], kind: str, args: argparse.Namespace, path: Path | None = None) -> list[dict[str, Any]]:
    exported: list[dict[str, Any]] = []
    for row in rows:
        if not row_matches(row, args):
            continue
        if kind == "example" and row.get("topic") == "repairs" and not args.include_repairs:
            continue
        if args.exclude_generated_expansion and is_generated_expansion(row, kind):
            continue

        exported_row = {
            "corpus_kind": kind,
            **row,
        }
        if path is not None:
            exported_row["source_path"] = path.relative_to(ROOT).as_posix()
        exported.append(exported_row)
    return exported


def row_matches(row: dict[str, Any], args: argparse.Namespace) -> bool:
    if args.dialect and row.get("dialect") not in set(args.dialect):
        return False
    if args.source and row.get("source") not in set(args.source):
        return False
    if args.topic and row.get("topic") not in set(args.topic):
        return False
    if args.callable and row.get("callable") not in set(args.callable):
        return False
    return True


def doc_rows(args: argparse.Namespace) -> list[dict[str, Any]]:
    if args.callable or args.dialect or args.topic:
        return []
    if args.source and "original" not in set(args.source):
        return []

    rows: list[dict[str, Any]] = []
    for path in sorted(DOCS_DIR.rglob("*.md")):
        rel_path = path.relative_to(ROOT).as_posix()
        rows.append(
            {
                "corpus_kind": "doc",
                "id": rel_path.removesuffix(".md").replace("/", "-"),
                "path": rel_path,
                "source": "original",
                "license": "MIT",
                "text": path.read_text(encoding="utf-8"),
            }
        )
    return rows


def is_generated_expansion(row: dict[str, Any], kind: str) -> bool:
    if kind != "example":
        return False
    path = str(row.get("path", ""))
    title = str(row.get("title", row.get("id", "")))
    generated_prefixes = (
        "cp-",
        "task-",
        "object-property-info-",
        "object-dynamic-property-",
        "object-defines-property-",
        "object-inherited-verb-scan-",
        "verb-info-flags-",
        "verb-args-summary-",
        "repair-",
        "syntax-",
        "toaststunt-map-bool-",
        "patch-specific-xml-",
        "utility-expanded-",
    )
    return any(title.startswith(prefix) for prefix in generated_prefixes) or "/utility-expanded-" in path or bool(re.search(r"-\d{2}$", title))


if __name__ == "__main__":
    raise SystemExit(main())
