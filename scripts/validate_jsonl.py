#!/usr/bin/env python3
"""Validate dataset and eval JSONL files."""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DATASETS_DIR = ROOT / "datasets"
EVALS_DIR = ROOT / "evals"

ALLOWED_DIALECTS = {"portable", "lambdamoo", "stunt", "toaststunt", "core-specific", "patch-specific"}
ALLOWED_SOURCES = {"original", "manual-summary", "curated-public", "approved-generic-sindome"}
ALLOWED_EVAL_KINDS = {"syntax", "bugfix", "codegen"}
ALLOWED_CALLABLE = {"programmatic", "command", "fragment"}
EXAMPLE_INDEX_PATH = DATASETS_DIR / "example-index.jsonl"
CONTRASTIVE_PATH = DATASETS_DIR / "contrastive-examples.jsonl"
ALLOWED_CONTRASTIVE_LABELS = {
    "valid_moo",
    "invalid_syntax",
    "bad_pattern",
    "wrong_dialect",
    "unsafe_permission",
    "command_parser_mistake",
    "bad_error_flow",
    "core_command_vs_language",
    "unsafe_lifecycle_mutation",
}

ID_RE = re.compile(r"^[a-z0-9-]+$")
RAW_OBJECT_RE = re.compile(r"(?<![\w$])#\d+")
TYPEOF_ARGS_RE = re.compile(r"\btypeof\s*\(\s*args\s*\)")
SHORT_UTILITY_REF_RE = re.compile(r"\$(ou|lu|su|cu)\b")
VMS_RE = re.compile(r"VMS NOTE|VMS VERSION|Last modified")


@dataclass
class Problem:
    path: Path
    line: int
    message: str

    def format(self) -> str:
        rel = self.path.relative_to(ROOT)
        return f"{rel}:{self.line}: {self.message}"


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate dataset and eval JSONL files")
    parser.add_argument("paths", nargs="*", type=Path, help="Optional JSONL files or directories")
    args = parser.parse_args()

    files = collect_files(args.paths) if args.paths else default_files()
    problems: list[Problem] = []
    for path in files:
        problems.extend(validate_jsonl(path))

    if problems:
        for problem in problems:
            print(problem.format(), file=sys.stderr)
        print(f"\n{len(problems)} problem(s) found in {len(files)} file(s).", file=sys.stderr)
        return 1

    print(f"Validated {len(files)} JSONL file(s).")
    return 0


def default_files() -> list[Path]:
    files = sorted(DATASETS_DIR.glob("*.jsonl"))
    files.extend(sorted(EVALS_DIR.rglob("*.jsonl")))
    return files


def collect_files(paths: list[Path]) -> list[Path]:
    files: list[Path] = []
    for raw in paths:
        path = raw if raw.is_absolute() else ROOT / raw
        if path.is_dir():
            files.extend(sorted(path.rglob("*.jsonl")))
        else:
            files.append(path)
    return sorted(set(files))


def validate_jsonl(path: Path) -> list[Problem]:
    problems: list[Problem] = []
    seen_ids: dict[str, int] = {}

    for line_number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), start=1):
        if not line.strip():
            problems.append(Problem(path, line_number, "blank lines are not allowed in JSONL files"))
            continue

        try:
            record = json.loads(line)
        except json.JSONDecodeError as exc:
            problems.append(Problem(path, line_number, f"invalid JSON: {exc.msg}"))
            continue

        if not isinstance(record, dict):
            problems.append(Problem(path, line_number, "JSONL row must be an object"))
            continue

        record_id = record.get("id")
        if isinstance(record_id, str):
            if record_id in seen_ids:
                problems.append(Problem(path, line_number, f"duplicate id `{record_id}` first seen on line {seen_ids[record_id]}"))
            seen_ids[record_id] = line_number

        if path == EXAMPLE_INDEX_PATH:
            problems.extend(validate_example_index_record(path, line_number, record))
        elif path == CONTRASTIVE_PATH:
            problems.extend(validate_contrastive_record(path, line_number, record))
        elif path.is_relative_to(DATASETS_DIR):
            problems.extend(validate_instruction_record(path, line_number, record))
        elif path.is_relative_to(EVALS_DIR):
            problems.extend(validate_eval_record(path, line_number, record))
        else:
            problems.append(Problem(path, line_number, "path is not under datasets/ or evals/"))

        problems.extend(validate_common_hygiene(path, line_number, record))

    return problems


def validate_instruction_record(path: Path, line: int, record: dict[str, Any]) -> list[Problem]:
    required = {"id", "instruction", "input", "output", "topic", "dialect", "source", "license", "reviewed"}
    problems = validate_shape(path, line, record, required, required)
    problems.extend(require_string(path, line, record, "instruction", min_length=1))
    problems.extend(require_string(path, line, record, "input"))
    problems.extend(require_string(path, line, record, "output", min_length=1))
    problems.extend(require_string(path, line, record, "topic", min_length=1))
    problems.extend(validate_common_fields(path, line, record))
    return problems


def validate_contrastive_record(path: Path, line: int, record: dict[str, Any]) -> list[Problem]:
    required = {"id", "snippet", "label", "explanation", "dialect", "source", "license", "reviewed"}
    allowed = required | {"fixed"}
    problems = validate_shape(path, line, record, required, allowed)

    problems.extend(require_string(path, line, record, "snippet", min_length=1))
    problems.extend(require_string(path, line, record, "explanation", min_length=1))
    if "fixed" in record:
        problems.extend(require_string(path, line, record, "fixed", min_length=1))

    label = record.get("label")
    if label not in ALLOWED_CONTRASTIVE_LABELS:
        problems.append(Problem(path, line, f"invalid label `{label}`"))

    if label != "valid_moo" and "fixed" not in record:
        problems.append(Problem(path, line, "non-valid contrastive rows should include `fixed` where applicable"))
    if label == "valid_moo" and "fixed" in record:
        problems.append(Problem(path, line, "valid_moo contrastive rows should not include `fixed`"))

    problems.extend(validate_common_fields(path, line, record))
    return problems


def validate_example_index_record(path: Path, line: int, record: dict[str, Any]) -> list[Problem]:
    required = {"id", "path", "title", "dialect", "source", "license", "topic", "code", "body"}
    allowed = required | {"provenance", "setup", "dialect_reason", "args", "returns", "notes", "callable"}
    problems = validate_shape(path, line, record, required, allowed)

    problems.extend(validate_id_dialect_source(path, line, record))
    problems.extend(require_string(path, line, record, "license", min_length=1))
    problems.extend(require_string(path, line, record, "path", min_length=1))
    problems.extend(require_string(path, line, record, "title", min_length=1))
    problems.extend(require_string(path, line, record, "topic", min_length=1))
    problems.extend(require_string(path, line, record, "code", min_length=1))
    problems.extend(require_string(path, line, record, "body"))

    if isinstance(record.get("id"), str) and isinstance(record.get("title"), str) and record["id"] != record["title"]:
        problems.append(Problem(path, line, "`id` must match `title` for example index rows"))

    rel_path = record.get("path")
    if isinstance(rel_path, str):
        example_path = ROOT / rel_path
        if not rel_path.startswith("examples/") or not rel_path.endswith(".moo"):
            problems.append(Problem(path, line, "`path` must point to examples/*.moo"))
        elif not example_path.exists():
            problems.append(Problem(path, line, f"indexed example path does not exist: {rel_path}"))

    callable_kind = record.get("callable")
    if callable_kind is not None and callable_kind not in ALLOWED_CALLABLE:
        problems.append(Problem(path, line, f"invalid callable `{callable_kind}`"))

    source = record.get("source")
    if source != "original" and "provenance" not in record:
        problems.append(Problem(path, line, "non-original example index rows must include `provenance`"))

    dialect = record.get("dialect")
    if dialect in {"stunt", "toaststunt", "core-specific", "patch-specific"} and "dialect_reason" not in record:
        problems.append(Problem(path, line, f"`{dialect}` example index rows must include `dialect_reason`"))

    return problems


def validate_eval_record(path: Path, line: int, record: dict[str, Any]) -> list[Problem]:
    required = {"id", "kind", "dialect", "prompt", "source", "license", "reviewed"}
    allowed = required | {
        "input",
        "expected",
        "expected_properties",
        "gold_answer",
        "checks",
        "negative_patterns",
        "forbidden_patterns",
        "requires_code",
        "compile_check",
    }
    problems = validate_shape(path, line, record, required, allowed)

    if record.get("kind") not in ALLOWED_EVAL_KINDS:
        problems.append(Problem(path, line, f"invalid kind `{record.get('kind')}`"))

    problems.extend(require_string(path, line, record, "prompt", min_length=1))
    if "input" in record:
        problems.extend(require_string(path, line, record, "input"))
    if "expected" in record:
        problems.extend(require_string(path, line, record, "expected"))
    if "expected_properties" in record:
        value = record["expected_properties"]
        if not isinstance(value, list) or not all(isinstance(item, str) and item for item in value):
            problems.append(Problem(path, line, "`expected_properties` must be a list of non-empty strings"))
    if "gold_answer" in record:
        problems.extend(require_string(path, line, record, "gold_answer", min_length=1))
    if "checks" in record:
        problems.extend(validate_scoring_checks(path, line, record["checks"]))
    for field in ("negative_patterns", "forbidden_patterns"):
        if field in record:
            value = record[field]
            if not isinstance(value, list) or not all(isinstance(item, str) and item for item in value):
                problems.append(Problem(path, line, f"`{field}` must be a list of non-empty strings"))
    for field in ("requires_code", "compile_check"):
        if field in record and not isinstance(record[field], bool):
            problems.append(Problem(path, line, f"`{field}` must be a boolean"))
    if "expected" not in record and "expected_properties" not in record:
        problems.append(Problem(path, line, "eval row must include `expected` or `expected_properties`"))

    problems.extend(validate_common_fields(path, line, record))
    return problems


def validate_scoring_checks(path: Path, line: int, checks: Any) -> list[Problem]:
    problems: list[Problem] = []
    allowed_types = {"contains", "not_contains", "regex", "not_regex"}
    if not isinstance(checks, list):
        return [Problem(path, line, "`checks` must be a list")]
    for index, check in enumerate(checks, start=1):
        if not isinstance(check, dict):
            problems.append(Problem(path, line, f"`checks[{index}]` must be an object"))
            continue
        allowed = {"type", "value", "points", "label"}
        for field in sorted({"type", "value"} - check.keys()):
            problems.append(Problem(path, line, f"`checks[{index}]` missing required field `{field}`"))
        for field in sorted(set(check) - allowed):
            problems.append(Problem(path, line, f"`checks[{index}]` has unknown field `{field}`"))
        if check.get("type") not in allowed_types:
            problems.append(Problem(path, line, f"`checks[{index}].type` must be one of {sorted(allowed_types)}"))
        if not isinstance(check.get("value"), str) or not check.get("value"):
            problems.append(Problem(path, line, f"`checks[{index}].value` must be a non-empty string"))
        if "label" in check and (not isinstance(check["label"], str) or not check["label"]):
            problems.append(Problem(path, line, f"`checks[{index}].label` must be a non-empty string"))
        points = check.get("points", 1)
        if not isinstance(points, (int, float)) or points <= 0:
            problems.append(Problem(path, line, f"`checks[{index}].points` must be a positive number"))
    return problems


def validate_shape(path: Path, line: int, record: dict[str, Any], required: set[str], allowed: set[str]) -> list[Problem]:
    problems: list[Problem] = []
    for field in sorted(required - record.keys()):
        problems.append(Problem(path, line, f"missing required field `{field}`"))
    for field in sorted(set(record) - allowed):
        problems.append(Problem(path, line, f"unknown field `{field}`"))
    return problems


def validate_common_fields(path: Path, line: int, record: dict[str, Any]) -> list[Problem]:
    problems: list[Problem] = []
    problems.extend(validate_id_dialect_source(path, line, record))
    problems.extend(require_string(path, line, record, "license", min_length=1))
    if not isinstance(record.get("reviewed"), bool):
        problems.append(Problem(path, line, "`reviewed` must be a boolean"))
    return problems


def validate_id_dialect_source(path: Path, line: int, record: dict[str, Any]) -> list[Problem]:
    problems: list[Problem] = []
    record_id = record.get("id")
    if not isinstance(record_id, str) or not ID_RE.fullmatch(record_id):
        problems.append(Problem(path, line, "`id` must use lowercase kebab-case"))

    dialect = record.get("dialect")
    if dialect not in ALLOWED_DIALECTS:
        problems.append(Problem(path, line, f"invalid dialect `{dialect}`"))

    source = record.get("source")
    if source not in ALLOWED_SOURCES:
        problems.append(Problem(path, line, f"invalid source `{source}`"))

    return problems


def require_string(path: Path, line: int, record: dict[str, Any], field: str, min_length: int = 0) -> list[Problem]:
    if field not in record:
        return []
    value = record[field]
    if not isinstance(value, str):
        return [Problem(path, line, f"`{field}` must be a string")]
    if len(value) < min_length:
        return [Problem(path, line, f"`{field}` must be non-empty")]
    return []


def validate_common_hygiene(path: Path, line: int, record: dict[str, Any]) -> list[Problem]:
    problems: list[Problem] = []
    guidance_fields = ["output", "expected", "expected_properties", "prompt", "instruction"]
    text = json.dumps({key: record[key] for key in guidance_fields if key in record}, ensure_ascii=False)
    all_text = json.dumps(record, ensure_ascii=False)
    raw_object_text = all_text
    if path == CONTRASTIVE_PATH:
        raw_object_text = json.dumps({key: value for key, value in record.items() if key != "snippet"}, ensure_ascii=False)

    if TYPEOF_ARGS_RE.search(text):
        problems.append(Problem(path, line, "avoid `typeof(args)` over-checks; args is server-populated as a list unless reassigned"))
    if RAW_OBJECT_RE.search(raw_object_text):
        problems.append(Problem(path, line, "raw object id found; prefer corified refs"))
    if SHORT_UTILITY_REF_RE.search(text):
        problems.append(Problem(path, line, "short utility ref found in guidance; use long refs like $object_utils or $list_utils"))
    if VMS_RE.search(all_text):
        problems.append(Problem(path, line, "VMS metadata should not appear in public training rows"))

    return problems


if __name__ == "__main__":
    raise SystemExit(main())
