#!/usr/bin/env python3
"""Build ready-made training and eval export packages.

The package keeps the repo-native source split and adds common chat-message
JSONL shapes for downstream adapters. Eval rows are exported as prompt-only
records with expected fields preserved for scoring/review.
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
EVALS_DIR = ROOT / "evals"
DATASET_CARD_PATH = ROOT / "dataset-card.json"

SYSTEM_PROMPT = (
    "You are a careful MOO programming assistant. Write valid LambdaMOO-family "
    "MOO code, preserve dialect/provenance labels, avoid raw object numbers, and "
    "distinguish portable MOO from ToastStunt, core-specific, and patch-specific code."
)


def main() -> int:
    parser = argparse.ArgumentParser(description="Export MOO training packages in common JSONL formats")
    parser.add_argument("--output-dir", type=Path, default=Path("datasets/packages/high-signal"), help="Package output directory")
    parser.add_argument("--heldout-fraction", type=float, default=0.15, help="Stable heldout fraction for source split")
    parser.add_argument("--seed", default="moo-for-llms-v1", help="Stable split seed")
    parser.add_argument("--include-repairs", action="store_true", help="Include repair examples in train/heldout split")
    parser.add_argument("--include-docs", action="store_true", help="Include docs as trainable reference rows")
    parser.add_argument("--include-contrastive-heldout", action="store_true", default=True, help="Include contrastive rows in heldout")
    parser.add_argument("--no-contrastive-heldout", action="store_false", dest="include_contrastive_heldout", help="Do not include contrastive rows in heldout")
    parser.add_argument("--exclude-generated-expansion", action="store_true", default=True, help="Exclude generated expansion examples")
    parser.add_argument("--include-generated-expansion", action="store_false", dest="exclude_generated_expansion", help="Include generated expansion examples")
    parser.add_argument("--max-generated-family-examples", type=int, default=0, help="Cap generated examples by normalized family; 0 means no cap")
    parser.add_argument("--downweight-generated", type=float, default=1.0, help="Manifest-only generated sampling weight recommendation")
    args = parser.parse_args()

    output_dir = resolve(args.output_dir)
    source_dir = output_dir / "source-split"
    source_dir.mkdir(parents=True, exist_ok=True)

    run_split_export(args, source_dir)
    train_rows = load_jsonl(source_dir / "train.jsonl")
    heldout_rows = load_jsonl(source_dir / "heldout.jsonl")
    eval_rows = load_eval_rows()

    write_jsonl(output_dir / "openai-chat" / "train.jsonl", [openai_training_row(row) for row in train_rows])
    write_jsonl(output_dir / "openai-chat" / "heldout.jsonl", [openai_training_row(row) for row in heldout_rows])
    write_jsonl(output_dir / "anthropic-messages" / "train.jsonl", [anthropic_training_row(row) for row in train_rows])
    write_jsonl(output_dir / "anthropic-messages" / "heldout.jsonl", [anthropic_training_row(row) for row in heldout_rows])
    write_jsonl(output_dir / "prompt-completion" / "train.jsonl", [prompt_completion_row(row) for row in train_rows])
    write_jsonl(output_dir / "prompt-completion" / "heldout.jsonl", [prompt_completion_row(row) for row in heldout_rows])

    write_jsonl(output_dir / "eval-prompts" / "openai-chat.jsonl", [openai_eval_prompt(row) for row in eval_rows])
    write_jsonl(output_dir / "eval-prompts" / "anthropic-messages.jsonl", [anthropic_eval_prompt(row) for row in eval_rows])
    write_jsonl(output_dir / "eval-prompts" / "plain.jsonl", [plain_eval_prompt(row) for row in eval_rows])

    manifest = build_manifest(args, output_dir, train_rows, heldout_rows, eval_rows)
    (output_dir / "package-manifest.json").write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(f"Wrote training package to {display_path(output_dir)}.")
    return 0


def run_split_export(args: argparse.Namespace, source_dir: Path) -> None:
    command = [
        sys.executable,
        "scripts/export_train_eval_split.py",
        "--output-dir",
        str(source_dir.relative_to(ROOT) if source_dir.is_relative_to(ROOT) else source_dir),
        "--heldout-fraction",
        str(args.heldout_fraction),
        "--seed",
        args.seed,
        "--max-generated-family-examples",
        str(args.max_generated_family_examples),
        "--downweight-generated",
        str(args.downweight_generated),
    ]
    if args.include_repairs:
        command.append("--include-repairs")
    if args.include_docs:
        command.append("--include-docs")
    if args.include_contrastive_heldout:
        command.append("--include-contrastive-heldout")
    if args.exclude_generated_expansion:
        command.append("--exclude-generated-expansion")
    subprocess.run(command, cwd=ROOT, check=True)


def load_jsonl(path: Path) -> list[dict[str, Any]]:
    return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines() if line.strip()]


def load_eval_rows() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for path in sorted(EVALS_DIR.rglob("*.jsonl")):
        for row in load_jsonl(path):
            rows.append({"source_file": path.relative_to(ROOT).as_posix(), "topic": path.stem, **row})
    return rows


def openai_training_row(row: dict[str, Any]) -> dict[str, Any]:
    prompt, completion = training_pair(row)
    return {
        "messages": [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": prompt},
            {"role": "assistant", "content": completion},
        ],
        "metadata": metadata(row),
    }


def anthropic_training_row(row: dict[str, Any]) -> dict[str, Any]:
    prompt, completion = training_pair(row)
    return {
        "system": SYSTEM_PROMPT,
        "messages": [
            {"role": "user", "content": prompt},
            {"role": "assistant", "content": completion},
        ],
        "metadata": metadata(row),
    }


def prompt_completion_row(row: dict[str, Any]) -> dict[str, Any]:
    prompt, completion = training_pair(row)
    return {
        "prompt": prompt,
        "completion": completion,
        "metadata": metadata(row),
    }


def openai_eval_prompt(row: dict[str, Any]) -> dict[str, Any]:
    return {
        "id": row["id"],
        "messages": [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": eval_prompt(row)},
        ],
        "metadata": metadata(row),
        "expected": expected_fields(row),
    }


def anthropic_eval_prompt(row: dict[str, Any]) -> dict[str, Any]:
    return {
        "id": row["id"],
        "system": SYSTEM_PROMPT,
        "messages": [{"role": "user", "content": eval_prompt(row)}],
        "metadata": metadata(row),
        "expected": expected_fields(row),
    }


def plain_eval_prompt(row: dict[str, Any]) -> dict[str, Any]:
    return {
        "id": row["id"],
        "prompt": eval_prompt(row),
        "metadata": metadata(row),
        "expected": expected_fields(row),
    }


def training_pair(row: dict[str, Any]) -> tuple[str, str]:
    kind = row.get("corpus_kind")
    if kind == "instruction":
        prompt = str(row["instruction"])
        if row.get("input"):
            prompt += "\n\nInput:\n" + str(row["input"])
        return prompt, str(row["output"])
    if kind == "example":
        prompt = (
            f"Write a {row.get('dialect', 'portable')} MOO example for topic "
            f"`{row.get('topic', 'unknown')}` titled `{row.get('title', row.get('id'))}`. "
            "Preserve metadata string comments."
        )
        return prompt, str(row.get("code", row.get("body", "")))
    if kind == "contrastive":
        prompt = "Review this MOO snippet and explain the issue.\n\nSnippet:\n" + str(row["snippet"])
        if row.get("fixed"):
            completion = f"Issue: {row['explanation']}\n\nCorrected MOO:\n{row['fixed']}"
        else:
            completion = f"Label: {row['label']}\n\nExplanation: {row['explanation']}"
        return prompt, completion
    if kind == "doc":
        return f"Provide the MOO reference note `{row.get('id')}`.", str(row.get("text", ""))
    return json.dumps(metadata(row), sort_keys=True), json.dumps(row, sort_keys=True)


def eval_prompt(row: dict[str, Any]) -> str:
    prompt = str(row["prompt"])
    if row.get("input"):
        prompt += "\n\nInput:\n" + str(row["input"])
    return prompt


def expected_fields(row: dict[str, Any]) -> dict[str, Any]:
    fields = {}
    for key in (
        "expected",
        "expected_properties",
        "gold_answer",
        "checks",
        "negative_patterns",
        "forbidden_patterns",
        "requires_code",
        "compile_check",
    ):
        if key in row:
            fields[key] = row[key]
    return fields


def metadata(row: dict[str, Any]) -> dict[str, Any]:
    keys = (
        "id",
        "corpus_kind",
        "kind",
        "topic",
        "dialect",
        "source",
        "license",
        "path",
        "source_file",
        "callable",
        "reviewed",
    )
    return {key: row[key] for key in keys if key in row}


def build_manifest(
    args: argparse.Namespace,
    output_dir: Path,
    train_rows: list[dict[str, Any]],
    heldout_rows: list[dict[str, Any]],
    eval_rows: list[dict[str, Any]],
) -> dict[str, Any]:
    files = sorted(path for path in output_dir.rglob("*.jsonl"))
    return {
        "name": "moo-for-llms-training-package",
        "version": dataset_version(),
        "system_prompt": SYSTEM_PROMPT,
        "options": {
            "heldout_fraction": args.heldout_fraction,
            "seed": args.seed,
            "include_repairs": args.include_repairs,
            "include_docs": args.include_docs,
            "include_contrastive_heldout": args.include_contrastive_heldout,
            "exclude_generated_expansion": args.exclude_generated_expansion,
            "max_generated_family_examples": args.max_generated_family_examples,
            "downweight_generated": args.downweight_generated,
        },
        "counts": {
            "train": len(train_rows),
            "heldout": len(heldout_rows),
            "eval_prompts": len(eval_rows),
            "train_by_kind": counts_by(train_rows, "corpus_kind"),
            "heldout_by_kind": counts_by(heldout_rows, "corpus_kind"),
            "eval_by_kind": counts_by(eval_rows, "kind"),
            "train_by_dialect": counts_by(train_rows, "dialect"),
            "heldout_by_dialect": counts_by(heldout_rows, "dialect"),
            "eval_by_dialect": counts_by(eval_rows, "dialect"),
        },
        "files": {path.relative_to(output_dir).as_posix(): line_count(path) for path in files},
        "notes": [
            "OpenAI and Anthropic files are chat-message shaped adapter exports, not a substitute for provider-side validation.",
            "Eval prompt exports preserve expected fields for scoring and should not be mixed into training targets.",
            "source-split keeps the repo-native JSONL rows used to build the adapter formats.",
        ],
    }


def counts_by(rows: list[dict[str, Any]], key: str) -> dict[str, int]:
    counts: dict[str, int] = {}
    for row in rows:
        value = str(row.get(key, "unspecified"))
        counts[value] = counts.get(value, 0) + 1
    return dict(sorted(counts.items()))


def write_jsonl(path: Path, rows: list[dict[str, Any]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("".join(json.dumps(row, separators=(",", ":")) + "\n" for row in rows), encoding="utf-8")


def line_count(path: Path) -> int:
    return sum(1 for line in path.read_text(encoding="utf-8").splitlines() if line.strip())


def resolve(path: Path) -> Path:
    return path if path.is_absolute() else ROOT / path


def display_path(path: Path) -> Path:
    try:
        return path.relative_to(ROOT)
    except ValueError:
        return path


def dataset_version() -> str:
    if not DATASET_CARD_PATH.exists():
        return "unversioned"
    data = json.loads(DATASET_CARD_PATH.read_text(encoding="utf-8"))
    return str(data.get("version", "unversioned"))


if __name__ == "__main__":
    raise SystemExit(main())
