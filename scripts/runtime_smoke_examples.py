#!/usr/bin/env python3
"""Run opt-in runtime smoke tests against a live MOO scratch verb.

This script intentionally uses interactive @program saves and single-line eval
commands. It never uses set_verb_code().
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any

from live_compile_examples import (
    DEFAULT_ARGSPEC,
    DEFAULT_PERMS,
    DEFAULT_TARGET,
    ROOT,
    MooSession,
    connect_session,
    is_successful_compile,
    load_env_file,
    read_config,
    timestamp,
)


def main() -> int:
    parser = argparse.ArgumentParser(description="Run opt-in MOO runtime smoke tests")
    parser.add_argument("--manifest", type=Path, default=Path("docs/runtime-smoke-manifest.json"), help="Runtime smoke manifest JSON")
    parser.add_argument("--target", default=DEFAULT_TARGET, help="Scratch verb target, e.g. me:llm_syntax_test")
    parser.add_argument("--argspec", default=DEFAULT_ARGSPEC, help="Scratch verb argspec used when creating the target")
    parser.add_argument("--perms", default=DEFAULT_PERMS, help="Scratch verb permissions")
    parser.add_argument("--env-file", type=Path, help="Optional env file containing MOO_HOSTNAME, MOO_PORT, MOO_USER, MOO_PASSWORD")
    parser.add_argument("--output", type=Path, default=Path("tmp/runtime-smoke-report.json"), help="JSON report path")
    parser.add_argument("--idle-ms", type=int, default=2500, help="Idle milliseconds that mark command completion")
    parser.add_argument("--first-timeout-ms", type=int, default=5000, help="Timeout for first response line")
    args = parser.parse_args()

    manifest_path = resolve(args.manifest)
    rows = json.loads(manifest_path.read_text(encoding="utf-8"))
    load_env_file(args.env_file)
    config = read_config()

    started_at = timestamp()
    results: list[dict[str, Any]] = []
    session: MooSession | None = None
    try:
        session = connect_session(config, args)
        for index, row in enumerate(rows, 1):
            result = run_row(session, args, row, index)
            results.append(result)
            print(f"[{index:03d}/{len(rows):03d}] {'ok' if result['ok'] else 'FAIL'} {row['id']}", flush=True)
    finally:
        if session is not None:
            session.close()

    report = {
        "target": args.target,
        "argspec": args.argspec,
        "perms": args.perms,
        "started_at": started_at,
        "finished_at": timestamp(),
        "total": len(results),
        "ok": sum(1 for result in results if result["ok"]),
        "failed": sum(1 for result in results if not result["ok"]),
        "results": results,
    }
    output_path = resolve(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    if report["failed"]:
        print(f"{report['failed']} runtime smoke failure(s). Report: {output_path}", file=sys.stderr)
        return 1
    print(f"Runtime smoke passed for {report['ok']} of {report['total']} row(s). Report: {output_path}")
    return 0


def run_row(session: MooSession, args: argparse.Namespace, row: dict[str, Any], index: int) -> dict[str, Any]:
    source_path = resolve(Path(row["path"]))
    source = source_path.read_text(encoding="utf-8").rstrip() + "\n"
    note = f"runtime smoke {row['id']}"
    compile_command = f"@program {args.target}\n{source}.\n{note}"
    compile_output = session.command(compile_command)
    compiled = is_successful_compile(compile_output)
    eval_command = str(row["eval"]).replace(DEFAULT_TARGET, args.target)
    eval_output = session.command(eval_command) if compiled else ""
    missing = [text for text in row.get("expected_contains", []) if text not in eval_output]
    return {
        "id": row["id"],
        "index": index,
        "path": source_path.relative_to(ROOT).as_posix(),
        "compiled": compiled,
        "ok": compiled and not missing,
        "missing": missing,
        "eval": eval_command,
        "output_tail": eval_output.strip().splitlines()[-10:],
    }


def resolve(path: Path) -> Path:
    return path if path.is_absolute() else ROOT / path


if __name__ == "__main__":
    raise SystemExit(main())
