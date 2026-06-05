#!/usr/bin/env python3
"""Export deterministic train/heldout splits from reviewed corpus rows."""

from __future__ import annotations

import argparse
import hashlib
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
DOCS_DIR = ROOT / "docs"


def main() -> int:
    parser = argparse.ArgumentParser(description="Export deterministic train/heldout JSONL splits")
    parser.add_argument("--output-dir", type=Path, default=Path("datasets/splits/default"), help="Directory for train.jsonl, heldout.jsonl, and manifest.json")
    parser.add_argument("--heldout-fraction", type=float, default=0.15, help="Fraction of normal rows assigned to heldout by stable hash")
    parser.add_argument("--seed", default="moo-for-llms-v1", help="Stable split seed")
    parser.add_argument("--dialect", action="append", help="Include rows matching this dialect; may be repeated")
    parser.add_argument("--source", action="append", help="Include rows matching this source; may be repeated")
    parser.add_argument("--topic", action="append", help="Include rows matching this topic; may be repeated")
    parser.add_argument("--callable", action="append", help="Include examples matching this callable kind; may be repeated")
    parser.add_argument("--include-repairs", action="store_true", help="Include topic=repairs examples in normal train/heldout splitting")
    parser.add_argument("--include-contrastive-heldout", action="store_true", help="Add contrastive rows to heldout only")
    parser.add_argument("--include-docs", action="store_true", help="Add docs as trainable reference rows")
    parser.add_argument("--max-heldout-per-topic", type=int, default=0, help="Optional cap for normal heldout rows per topic; 0 means no cap")
    parser.add_argument("--exclude-generated-expansion", action="store_true", help="Exclude generated expansion examples such as utility-expanded-* and numbered expansion families")
    parser.add_argument("--max-generated-family-examples", type=int, default=0, help="Optional cap for near-family generated expansion examples; 0 means no cap")
    parser.add_argument("--downweight-generated", type=float, default=1.0, help="Manifest-only sampling weight recommendation for generated expansion examples")
    args = parser.parse_args()

    if not 0 <= args.heldout_fraction < 1:
        parser.error("--heldout-fraction must be >= 0 and < 1")

    ensure_example_index()

    train: list[dict[str, Any]] = []
    heldout: list[dict[str, Any]] = []
    heldout_topic_counts: dict[str, int] = {}

    normal_rows: list[dict[str, Any]] = []
    normal_rows.extend(tagged_rows(load_jsonl(EXAMPLE_INDEX_PATH), "example"))
    normal_rows.extend(tagged_rows(load_jsonl(INSTRUCTION_PATH), "instruction"))
    if args.include_docs:
        normal_rows.extend(doc_rows())

    generated_family_counts: dict[str, int] = {}
    for row in normal_rows:
        if not row_matches(row, args):
            continue
        if row["corpus_kind"] == "example" and row.get("topic") == "repairs" and not args.include_repairs:
            continue
        if args.exclude_generated_expansion and is_generated_expansion(row):
            continue
        if generated_family_over_cap(row, generated_family_counts, args.max_generated_family_examples):
            continue

        topic = row.get("topic", row.get("corpus_kind", "unspecified"))
        if is_heldout(row, args.seed, args.heldout_fraction) and under_topic_cap(topic, heldout_topic_counts, args.max_heldout_per_topic):
            heldout.append(row)
            heldout_topic_counts[topic] = heldout_topic_counts.get(topic, 0) + 1
        else:
            train.append(row)

    if args.include_contrastive_heldout:
        for row in tagged_rows(load_jsonl(CONTRASTIVE_PATH), "contrastive"):
            if row_matches(row, args):
                heldout.append(row)

    output_dir = args.output_dir if args.output_dir.is_absolute() else ROOT / args.output_dir
    output_dir.mkdir(parents=True, exist_ok=True)
    write_jsonl(output_dir / "train.jsonl", train)
    write_jsonl(output_dir / "heldout.jsonl", heldout)
    (output_dir / "manifest.json").write_text(
        json.dumps(manifest(args, train, heldout), indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    try:
        display_dir = output_dir.relative_to(ROOT)
    except ValueError:
        display_dir = output_dir
    print(f"Wrote {len(train)} train row(s) and {len(heldout)} heldout row(s) to {display_dir}.")
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


def tagged_rows(rows: Iterable[dict[str, Any]], kind: str) -> list[dict[str, Any]]:
    return [{"corpus_kind": kind, **row} for row in rows]


def doc_rows() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for path in sorted(DOCS_DIR.glob("*.md")):
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


def is_heldout(row: dict[str, Any], seed: str, fraction: float) -> bool:
    if fraction <= 0:
        return False
    key = f"{seed}:{row.get('corpus_kind')}:{row.get('id', row.get('path', ''))}"
    bucket = int(hashlib.sha256(key.encode("utf-8")).hexdigest()[:8], 16) / 0xFFFFFFFF
    return bucket < fraction


def under_topic_cap(topic: str, counts: dict[str, int], cap: int) -> bool:
    return cap <= 0 or counts.get(topic, 0) < cap


def write_jsonl(path: Path, rows: list[dict[str, Any]]) -> None:
    path.write_text("".join(json.dumps(row, separators=(",", ":")) + "\n" for row in rows), encoding="utf-8")


def manifest(args: argparse.Namespace, train: list[dict[str, Any]], heldout: list[dict[str, Any]]) -> dict[str, Any]:
    return {
        "seed": args.seed,
        "heldout_fraction": args.heldout_fraction,
        "filters": {
            "dialect": args.dialect or [],
            "source": args.source or [],
            "topic": args.topic or [],
            "callable": args.callable or [],
            "include_repairs": args.include_repairs,
            "include_contrastive_heldout": args.include_contrastive_heldout,
            "include_docs": args.include_docs,
            "max_heldout_per_topic": args.max_heldout_per_topic,
            "exclude_generated_expansion": args.exclude_generated_expansion,
            "max_generated_family_examples": args.max_generated_family_examples,
            "downweight_generated": args.downweight_generated,
        },
        "counts": {
            "train": len(train),
            "heldout": len(heldout),
            "train_by_kind": counts_by(train, "corpus_kind"),
            "heldout_by_kind": counts_by(heldout, "corpus_kind"),
            "train_by_topic": counts_by(train, "topic"),
            "heldout_by_topic": counts_by(heldout, "topic"),
            "train_by_dialect": counts_by(train, "dialect"),
            "heldout_by_dialect": counts_by(heldout, "dialect"),
            "train_by_quality_tier": quality_counts(train),
            "heldout_by_quality_tier": quality_counts(heldout),
            "train_generated_expansion": sum(1 for row in train if is_generated_expansion(row)),
            "heldout_generated_expansion": sum(1 for row in heldout if is_generated_expansion(row)),
            "generated_family_count_train": len({generated_family_key(row) for row in train if is_generated_expansion(row)}),
            "generated_family_count_heldout": len({generated_family_key(row) for row in heldout if is_generated_expansion(row)}),
        },
        "notes": [
            "evals/**/*.jsonl are never included by this split exporter; keep them held out for benchmark use.",
            "contrastive rows are heldout-only when --include-contrastive-heldout is used.",
            "repair examples are excluded unless --include-repairs is used.",
            "max_generated_family_examples caps generated examples by normalized code shape before split assignment.",
            "downweight_generated is recorded in the manifest only; downstream samplers should apply it.",
        ],
    }


def counts_by(rows: list[dict[str, Any]], key: str) -> dict[str, int]:
    counts: dict[str, int] = {}
    for row in rows:
        value = str(row.get(key, "unspecified"))
        counts[value] = counts.get(value, 0) + 1
    return dict(sorted(counts.items()))


def is_generated_expansion(row: dict[str, Any]) -> bool:
    if row.get("corpus_kind") != "example":
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
    return any(title.startswith(prefix) for prefix in generated_prefixes) or "/utility-expanded-" in path


def generated_family_over_cap(row: dict[str, Any], counts: dict[str, int], cap: int) -> bool:
    if cap <= 0 or not is_generated_expansion(row):
        return False
    key = generated_family_key(row)
    counts[key] = counts.get(key, 0) + 1
    return counts[key] > cap


def generated_family_key(row: dict[str, Any]) -> str:
    if row.get("corpus_kind") != "example":
        return str(row.get("id", row.get("path", "")))
    body = str(row.get("body", ""))
    normalized = normalize_body(body)
    family = family_normalize(normalized)
    return hashlib.sha1(family.encode("utf-8")).hexdigest()


def normalize_body(body: str) -> str:
    code_lines = []
    comment_lines = []
    for line in body.splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith('"'):
            if stripped.startswith('"'):
                comment_lines.append(stripped)
            continue
        code_lines.append(stripped)
    return "\n".join(code_lines or comment_lines)


def family_normalize(body: str) -> str:
    body = re.sub(r"\b[a-zA-Z_]+_[0-9]+\b", "NAME_N", body)
    body = re.sub(r"\b[0-9]+\b", "N", body)
    body = re.sub(r'"[^"]*"', '"S"', body)
    return body


def quality_tier(row: dict[str, Any]) -> str:
    kind = row.get("corpus_kind")
    if kind == "contrastive":
        return "contrastive-heldout"
    if kind == "doc":
        return "documentation"
    if kind == "instruction":
        return "instruction"
    if kind != "example":
        return str(kind or "unknown")
    if row.get("topic") == "repairs":
        return "repair-example"
    if is_generated_expansion(row):
        return "generated-expansion"
    if row.get("source") == "approved-generic-sindome":
        return "curated-live-adaptation"
    return "original-handwritten"


def quality_counts(rows: list[dict[str, Any]]) -> dict[str, int]:
    counts: dict[str, int] = {}
    for row in rows:
        tier = quality_tier(row)
        counts[tier] = counts.get(tier, 0) + 1
    return dict(sorted(counts.items()))


if __name__ == "__main__":
    raise SystemExit(main())
