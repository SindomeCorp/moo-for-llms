#!/usr/bin/env python3
"""Diff documented builtin lists."""

from __future__ import annotations

from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def parse_builtin_doc(path: Path) -> set[str]:
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


def main() -> int:
    lambdamoo = parse_builtin_doc(ROOT / "docs" / "lambdamoo-builtins.md")
    toaststunt = parse_builtin_doc(ROOT / "docs" / "toaststunt-builtins.md")

    print("ToastStunt builtins not in LambdaMOO:")
    for name in sorted(toaststunt - lambdamoo):
        print(name)

    print()
    print("LambdaMOO builtins not in ToastStunt:")
    for name in sorted(lambdamoo - toaststunt):
        print(name)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
