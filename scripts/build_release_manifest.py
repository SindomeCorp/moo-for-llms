#!/usr/bin/env python3
"""Build a structured release manifest for corpus releases."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
import time
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DATASETS_DIR = ROOT / "datasets"
EVALS_DIR = ROOT / "evals"
DOCS_DIR = ROOT / "docs"
DATASET_CARD_PATH = ROOT / "dataset-card.json"


def main() -> int:
    parser = argparse.ArgumentParser(description="Build MOO corpus release manifest JSON")
    parser.add_argument("--output", type=Path, default=Path("tmp/release-manifest.json"), help="Manifest output path")
    parser.add_argument("--package-dir", type=Path, default=Path("tmp/training-package"), help="Optional training package directory to summarize")
    parser.add_argument("--run-verify", action="store_true", help="Run make verify before writing the manifest")
    args = parser.parse_args()

    verify_result = None
    if args.run_verify:
        verify_result = run_verify()
        if verify_result["returncode"] != 0:
            write_manifest(args, verify_result)
            print(f"make verify failed; manifest written to {display_path(resolve(args.output))}", file=sys.stderr)
            return verify_result["returncode"]

    manifest = build_manifest(args, verify_result)
    output_path = resolve(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(f"Wrote release manifest to {display_path(output_path)}.")
    return 0


def build_manifest(args: argparse.Namespace, verify_result: dict[str, Any] | None) -> dict[str, Any]:
    return {
        "name": "moo-for-llms",
        "version": dataset_version(),
        "generated_at": timestamp(),
        "git": git_summary(),
        "counts": corpus_counts(),
        "reports": report_summary(),
        "package": package_summary(resolve(args.package_dir)),
        "validation": verify_result or {"run": False, "recommended_command": "make verify"},
        "release_readiness": release_readiness(verify_result),
        "source_policy": "Preserve source, license, dialect, and provenance metadata in downstream exports.",
        "heldout_policy": "Keep evals/**/*.jsonl and eval-prompts package files out of normal training targets.",
    }


def corpus_counts() -> dict[str, Any]:
    examples = load_jsonl(DATASETS_DIR / "example-index.jsonl")
    instructions = load_jsonl(DATASETS_DIR / "instruction-examples.jsonl")
    contrastive = load_jsonl(DATASETS_DIR / "contrastive-examples.jsonl")
    evals = load_all_eval_rows()
    docs = sorted(path for path in DOCS_DIR.rglob("*.md") if path.name != "coverage-report.md")
    return {
        "examples": len(examples),
        "instruction_rows": len(instructions),
        "contrastive_rows": len(contrastive),
        "eval_rows": len(evals),
        "docs": len(docs),
        "examples_by_topic": counts_by(examples, "topic"),
        "examples_by_dialect": counts_by(examples, "dialect"),
        "examples_by_source": counts_by(examples, "source"),
        "evals_by_kind": counts_by(evals, "kind"),
        "evals_by_dialect": counts_by(evals, "dialect"),
    }


def report_summary() -> dict[str, Any]:
    duplicate_text = read_optional(DOCS_DIR / "duplicate-example-report.md")
    training_quality_text = read_optional(DOCS_DIR / "training-quality-report.md")
    compile_text = read_optional(DOCS_DIR / "compile-status.md")
    return {
        "coverage_report": "docs/coverage-report.md",
        "eval_coverage_report": "docs/eval-coverage-report.md",
        "duplicate_report": {
            "path": "docs/duplicate-example-report.md",
            "exact_duplicate_clusters": first_int_after(duplicate_text, r"exact duplicate clusters:\s*(\d+)"),
            "near_family_duplicate_clusters": first_int_after(duplicate_text, r"near-family duplicate clusters:\s*(\d+)"),
        },
        "training_quality_report": {
            "path": "docs/training-quality-report.md",
            "warnings": first_table_count(training_quality_text, "warnings"),
        },
        "compile_status": {
            "path": "docs/compile-status.md",
            "full_corpus_live_compile": first_match(compile_text, r"Full corpus live compile[^\n]+"),
            "runtime_smoke_tests": first_match(compile_text, r"Runtime smoke tests[^\n]+"),
        },
    }


def package_summary(package_dir: Path) -> dict[str, Any]:
    if not package_dir.exists():
        return {
            "present": False,
            "path": display_path(package_dir).as_posix(),
            "recommended_command": f"python3 scripts/export_training_packages.py --output-dir {display_path(package_dir)}",
        }
    files = sorted(path for path in package_dir.rglob("*") if path.is_file())
    manifest_path = package_dir / "package-manifest.json"
    return {
        "present": True,
        "path": display_path(package_dir).as_posix(),
        "manifest": json.loads(manifest_path.read_text(encoding="utf-8")) if manifest_path.exists() else None,
        "files": {
            path.relative_to(package_dir).as_posix(): {
                "bytes": path.stat().st_size,
                "nonblank_lines": line_count(path) if path.suffix == ".jsonl" else None,
            }
            for path in files
        },
    }


def release_readiness(verify_result: dict[str, Any] | None) -> dict[str, Any]:
    reports = report_summary()
    checks = {
        "verify_passed": verify_result is None or verify_result.get("returncode") == 0,
        "training_quality_warnings_zero": reports["training_quality_report"]["warnings"] == 0,
        "exact_duplicate_clusters_zero": reports["duplicate_report"]["exact_duplicate_clusters"] == 0,
        "git_commit_available": bool(git_summary().get("commit")),
    }
    return {
        "ready": all(checks.values()),
        "checks": checks,
    }


def run_verify() -> dict[str, Any]:
    started = timestamp()
    result = subprocess.run(["make", "verify"], cwd=ROOT, text=True, capture_output=True)
    return {
        "run": True,
        "command": "make verify",
        "started_at": started,
        "finished_at": timestamp(),
        "returncode": result.returncode,
        "stdout_tail": result.stdout.splitlines()[-80:],
        "stderr_tail": result.stderr.splitlines()[-80:],
    }


def write_manifest(args: argparse.Namespace, verify_result: dict[str, Any]) -> None:
    output_path = resolve(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(build_manifest(args, verify_result), indent=2, sort_keys=True) + "\n", encoding="utf-8")


def git_summary() -> dict[str, Any]:
    return {
        "commit": git_output("rev-parse", "HEAD"),
        "branch": git_output("branch", "--show-current"),
        "tag_exact": git_output("describe", "--tags", "--exact-match"),
        "describe": git_output("describe", "--tags", "--always", "--dirty"),
        "dirty_files": git_lines("status", "--short"),
    }


def git_output(*args: str) -> str | None:
    result = subprocess.run(["git", *args], cwd=ROOT, text=True, capture_output=True)
    if result.returncode:
        return None
    return result.stdout.strip() or None


def git_lines(*args: str) -> list[str]:
    result = subprocess.run(["git", *args], cwd=ROOT, text=True, capture_output=True)
    if result.returncode:
        return []
    return [line for line in result.stdout.splitlines() if line.strip()]


def load_jsonl(path: Path) -> list[dict[str, Any]]:
    return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines() if line.strip()]


def load_all_eval_rows() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for path in sorted(EVALS_DIR.rglob("*.jsonl")):
        rows.extend(load_jsonl(path))
    return rows


def counts_by(rows: list[dict[str, Any]], key: str) -> dict[str, int]:
    counts: dict[str, int] = {}
    for row in rows:
        value = str(row.get(key, "unspecified"))
        counts[value] = counts.get(value, 0) + 1
    return dict(sorted(counts.items()))


def read_optional(path: Path) -> str:
    return path.read_text(encoding="utf-8") if path.exists() else ""


def first_int_after(text: str, pattern: str) -> int | None:
    match = re.search(pattern, text, flags=re.IGNORECASE)
    return int(match.group(1)) if match else None


def first_table_count(text: str, label: str) -> int | None:
    match = re.search(rf"\|\s*{re.escape(label)}\s*\|\s*(\d+)\s*\|", text, flags=re.IGNORECASE)
    return int(match.group(1)) if match else None


def first_match(text: str, pattern: str) -> str | None:
    match = re.search(pattern, text)
    return match.group(0) if match else None


def line_count(path: Path) -> int:
    return sum(1 for line in path.read_text(encoding="utf-8").splitlines() if line.strip())


def resolve(path: Path) -> Path:
    return path if path.is_absolute() else ROOT / path


def display_path(path: Path) -> Path:
    try:
        return path.relative_to(ROOT)
    except ValueError:
        return path


def timestamp() -> str:
    return time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())


def dataset_version() -> str:
    if not DATASET_CARD_PATH.exists():
        return "unversioned"
    data = json.loads(DATASET_CARD_PATH.read_text(encoding="utf-8"))
    return str(data.get("version", "unversioned"))


if __name__ == "__main__":
    raise SystemExit(main())
