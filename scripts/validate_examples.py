#!/usr/bin/env python3
"""Validate embedded metadata and hygiene rules for MOO examples."""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
EXAMPLES_DIR = ROOT / "examples"
LAMBDAMOO_BUILTINS_DOC = ROOT / "docs" / "lambdamoo-builtins.md"
TOASTSTUNT_BUILTINS_DOC = ROOT / "docs" / "toaststunt-builtins.md"

REQUIRED_FIELDS = {"title", "dialect", "source", "license", "topic"}
OPTIONAL_FIELDS = {"provenance", "setup", "dialect_reason", "args", "returns", "notes", "callable"}
ALLOWED_FIELDS = REQUIRED_FIELDS | OPTIONAL_FIELDS
ALLOWED_DIALECTS = {"portable", "lambdamoo", "stunt", "toaststunt", "core-specific", "patch-specific"}
NON_PORTABLE_DIALECTS = {"stunt", "toaststunt", "core-specific", "patch-specific"}
ALLOWED_SOURCES = {"original", "manual-summary", "curated-public", "approved-generic-sindome"}
ALLOWED_CALLABLE = {"programmatic", "command", "fragment"}

HEADER_RE = re.compile(r'^"\s*([a-z_]+):\s*(.*?)";\s*$')
STRING_COMMENT_RE = re.compile(r'^\s*"')
RAW_OBJECT_RE = re.compile(r"(?<![\w$])#\d+")
SHORT_UTILITY_REF_RE = re.compile(r"\$(ou|lu|su|cu)\b")
TYPEOF_ARGS_RE = re.compile(r"\btypeof\s*\(\s*args\s*\)")
PLAYER_WIZARD_RE = re.compile(r"\bplayer\s*\.\s*wizard\b")
PLAYER_OWNER_CHECK_RE = re.compile(r"\bplayer\s*(!=|==)\s*this\s*\.\s*owner\b")
SET_TASK_CALLER_PERMS_RE = re.compile(r"\bset_task_perms\s*\(\s*caller_perms\s*\(\s*\)\s*\)")
SET_VERB_CODE_RE = re.compile(r"(?<![\w:$])set_verb_code\s*\(")
PLAYER_TELL_RE = re.compile(r"\bplayer\s*:\s*tell(?:_lines)?\s*\(")
RAISE_ERROR_RE = re.compile(r"(?<![\w:$])raise\s*\(\s*E_[A-Z0-9_]+")
BROAD_INLINE_CATCH_RE = re.compile(r"!\s*ANY\s*=>")
BROAD_EXCEPT_RE = re.compile(r"\bexcept\s*\(\s*ANY\s*\)")
TITLE_RE = re.compile(r"^[a-z0-9-]+$")
VMS_PATTERNS = ("VMS NOTE", "VMS VERSION", "Last modified")
SINDOME_SPECIFIC_BUILTINS = (
    "sql_query",
    "sql_connections",
    "sql_open",
    "sql_close",
    "sql_info",
)
PATCH_SPECIFIC_BUILTINS = (
    "xml_parse_tree",
    "xml_parse_document",
)
TOASTSTUNT_MARKERS = (
    "[]",
    " -> ",
)
TOASTSTUNT_TYPE_MARKERS = (
    "ANON",
    "BOOL",
    "MAP",
    "WAIF",
)


@dataclass
class Problem:
    path: Path
    line: int
    message: str

    def format(self) -> str:
        rel = self.path.relative_to(ROOT)
        return f"{rel}:{self.line}: {self.message}"


def read_lines(path: Path) -> list[str]:
    return path.read_text(encoding="utf-8").splitlines()


def parse_header(path: Path, lines: list[str]) -> tuple[dict[str, str], list[Problem]]:
    metadata: dict[str, str] = {}
    problems: list[Problem] = []
    saw_header = False

    for index, line in enumerate(lines, start=1):
        if not line.strip():
            if saw_header:
                break
            problems.append(Problem(path, index, "example must start with metadata string comments"))
            break

        match = HEADER_RE.match(line)
        if not match:
            if saw_header:
                break
            problems.append(Problem(path, index, 'expected header line like `" title: value";`'))
            break

        saw_header = True
        key, value = match.groups()
        if key in metadata:
            problems.append(Problem(path, index, f"duplicate metadata field `{key}`"))
        metadata[key] = value

    if not saw_header:
        problems.append(Problem(path, 1, "missing metadata header"))

    return metadata, problems


def validate_metadata(path: Path, metadata: dict[str, str]) -> list[Problem]:
    problems: list[Problem] = []

    for field in sorted(REQUIRED_FIELDS - metadata.keys()):
        problems.append(Problem(path, 1, f"missing required metadata field `{field}`"))

    for field in sorted(set(metadata) - ALLOWED_FIELDS):
        problems.append(Problem(path, 1, f"unknown metadata field `{field}`"))

    title = metadata.get("title")
    if title and not TITLE_RE.fullmatch(title):
        problems.append(Problem(path, 1, "`title` must use lowercase kebab-case"))

    dialect = metadata.get("dialect")
    if dialect and dialect not in ALLOWED_DIALECTS:
        problems.append(Problem(path, 1, f"invalid dialect `{dialect}`"))

    source = metadata.get("source")
    if source and source not in ALLOWED_SOURCES:
        problems.append(Problem(path, 1, f"invalid source `{source}`"))

    if source != "original" and "provenance" not in metadata:
        problems.append(Problem(path, 1, "non-original examples must include `provenance`"))

    if dialect in NON_PORTABLE_DIALECTS and "dialect_reason" not in metadata:
        problems.append(Problem(path, 1, f"`{dialect}` examples must include `dialect_reason`"))

    callable_kind = metadata.get("callable")
    if callable_kind and callable_kind not in ALLOWED_CALLABLE:
        problems.append(Problem(path, 1, f"invalid callable `{callable_kind}`"))

    return problems


def validate_hygiene(path: Path, lines: list[str], metadata: dict[str, str]) -> list[Problem]:
    problems: list[Problem] = []
    body = "\n".join(lines)
    code_body = "\n".join(line for line in lines if not is_string_literal_statement(line))

    for index, line in enumerate(lines, start=1):
        stripped = line.rstrip()
        if STRING_COMMENT_RE.match(stripped) and not stripped.endswith(";"):
            problems.append(Problem(path, index, "string-literal comment must end with `;`"))
        if not is_string_literal_statement(line) and RAW_OBJECT_RE.search(line):
            problems.append(Problem(path, index, "raw object id found; prefer corified refs in examples"))
        if not is_string_literal_statement(line) and SHORT_UTILITY_REF_RE.search(line):
            problems.append(Problem(path, index, "use long utility refs like $object_utils, $list_utils, $string_utils, or $command_utils"))
        if not is_string_literal_statement(line) and TYPEOF_ARGS_RE.search(line):
            problems.append(Problem(path, index, "`args` is server-populated as a list; check length(args) or validate values inside args"))
        for pattern in VMS_PATTERNS:
            if pattern in line:
                problems.append(Problem(path, index, f"trailing VMS metadata pattern `{pattern}` found"))

    dialect = metadata.get("dialect")
    toaststunt_specific_builtin = find_builtin_call(code_body, toaststunt_specific_builtins())
    has_toaststunt_marker = (
        any(marker in code_body for marker in TOASTSTUNT_MARKERS)
        or bool(find_word_marker(code_body, TOASTSTUNT_TYPE_MARKERS))
        or bool(toaststunt_specific_builtin)
    )
    sindome_builtin = find_builtin_call(code_body, SINDOME_SPECIFIC_BUILTINS)
    patch_builtin = find_builtin_call(code_body, PATCH_SPECIFIC_BUILTINS)

    if dialect == "toaststunt" and not has_toaststunt_marker:
        problems.append(Problem(path, 1, "toaststunt example lacks an obvious ToastStunt-specific marker"))
    elif dialect == "patch-specific" and not patch_builtin:
        problems.append(Problem(path, 1, "patch-specific example lacks an obvious patch-specific builtin call"))
    elif dialect == "portable" and (has_toaststunt_marker or sindome_builtin or patch_builtin):
        problems.append(Problem(path, 1, "portable example contains an obvious non-portable marker"))
    if sindome_builtin and dialect != "core-specific":
        problems.append(Problem(path, 1, f"`{sindome_builtin}()` is Sindome-specific; use dialect `core-specific`"))
    if patch_builtin and dialect != "patch-specific":
        problems.append(Problem(path, 1, f"`{patch_builtin}()` is patch-specific; use dialect `patch-specific`"))
    if metadata.get("callable") == "command" and re.search(r"(?<![\w.])args(?!\w)", code_body):
        setup = metadata.get("setup", "")
        if setup.endswith(" none none none"):
            problems.append(Problem(path, 1, "command examples using `args` should not use argspec `none none none`"))
        elif setup.endswith(" any none none"):
            problems.append(Problem(path, 1, "free-form command examples using `args` should prefer argspec `any any any` over `any none none`"))
    if metadata.get("callable") == "programmatic":
        if PLAYER_WIZARD_RE.search(code_body):
            problems.append(Problem(path, 1, "programmatic examples should use caller_perms().wizard, not player.wizard"))
        if PLAYER_OWNER_CHECK_RE.search(code_body):
            problems.append(Problem(path, 1, "programmatic examples should not use player as the authority check; use caller_perms() or a permission helper"))
        if PLAYER_TELL_RE.search(code_body):
            notify_text = " ".join(
                metadata.get(field, "").lower()
                for field in ("title", "provenance", "notes")
            )
            if "notif" not in notify_text and "player feedback" not in notify_text:
                problems.append(Problem(path, 1, "programmatic examples should not use player:tell unless intentional player notification is documented"))
    if metadata.get("callable") == "command" and RAISE_ERROR_RE.search(code_body):
        command_error_text = " ".join(
            metadata.get(field, "").lower()
            for field in ("title", "provenance", "notes")
        )
        if "propagat" not in command_error_text and "intentional" not in command_error_text:
            problems.append(Problem(path, 1, "command examples should usually use player:tell and return instead of raise(E_...)"))
    if SET_TASK_CALLER_PERMS_RE.search(code_body):
        permission_text = " ".join(
            metadata.get(field, "").lower()
            for field in ("title", "provenance", "notes")
        )
        if "delegat" not in permission_text:
            problems.append(Problem(path, 1, "`set_task_perms(caller_perms())` examples should document intentional delegation in title, provenance, or notes"))
    if SET_VERB_CODE_RE.search(code_body):
        mutation_text = " ".join(
            metadata.get(field, "").lower()
            for field in ("title", "topic", "provenance", "notes")
        )
        if "verb mutation" not in mutation_text and "verb api" not in mutation_text:
            problems.append(Problem(path, 1, "`set_verb_code(...)` should only appear in explicit verb mutation API examples"))
    if BROAD_INLINE_CATCH_RE.search(code_body) or BROAD_EXCEPT_RE.search(code_body):
        broad_text = " ".join(
            metadata.get(field, "").lower()
            for field in ("title", "provenance", "notes")
        )
        if "broad catch" not in broad_text and "intentional" not in broad_text:
            problems.append(Problem(path, 1, "broad ANY catches should be documented as intentional"))

    return problems


def find_builtin_call(body: str, names: tuple[str, ...]) -> str | None:
    for name in names:
        if re.search(rf"(?<![\w:$]){re.escape(name)}\s*\(", body):
            return name
    return None


def is_string_literal_statement(line: str) -> bool:
    return bool(STRING_COMMENT_RE.match(line.rstrip()))


def find_word_marker(body: str, names: tuple[str, ...]) -> str | None:
    for name in names:
        if re.search(rf"\b{re.escape(name)}\b", body):
            return name
    return None


def parse_builtin_doc(path: Path) -> set[str]:
    if not path.exists():
        return set()

    builtins: set[str] = set()
    in_block = False
    for line in path.read_text(encoding="utf-8").splitlines():
        stripped = line.strip()
        if stripped == "```text":
            in_block = True
            continue
        if stripped == "```":
            in_block = False
            continue
        if in_block and stripped:
            builtins.add(stripped)
    return builtins


def toaststunt_specific_builtins() -> tuple[str, ...]:
    lambdamoo = parse_builtin_doc(LAMBDAMOO_BUILTINS_DOC)
    toaststunt = parse_builtin_doc(TOASTSTUNT_BUILTINS_DOC)
    return tuple(sorted(toaststunt - lambdamoo))


def validate_file(path: Path) -> list[Problem]:
    lines = read_lines(path)
    metadata, problems = parse_header(path, lines)
    problems.extend(validate_metadata(path, metadata))
    problems.extend(validate_hygiene(path, lines, metadata))
    return problems


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate examples/**/*.moo")
    parser.add_argument("paths", nargs="*", type=Path, help="Optional files or directories to validate")
    args = parser.parse_args()

    roots = args.paths or [EXAMPLES_DIR]
    files: list[Path] = []
    for root in roots:
        path = root if root.is_absolute() else ROOT / root
        if path.is_dir():
            files.extend(sorted(path.rglob("*.moo")))
        else:
            files.append(path)

    problems: list[Problem] = []
    for path in sorted(set(files)):
        if path.suffix != ".moo":
            continue
        problems.extend(validate_file(path))

    if problems:
        for problem in problems:
            print(problem.format(), file=sys.stderr)
        print(f"\n{len(problems)} problem(s) found in {len(set(files))} file(s).", file=sys.stderr)
        return 1

    print(f"Validated {len(set(files))} example file(s).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
