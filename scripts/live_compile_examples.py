#!/usr/bin/env python3
"""Compile example MOO files against a live scratch verb.

This script intentionally uses the interactive @program save flow:

1. @program <obj>:<verb>
2. full source
3. .
4. one-line save note

It never uses set_verb_code().
"""

from __future__ import annotations

import argparse
import json
import os
import re
import socket
import sys
import time
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_TARGET = "me:llm_syntax_test"
DEFAULT_ARGSPEC = "this none this"
DEFAULT_PERMS = "rxd"
IAC = 255


def main() -> int:
    parser = argparse.ArgumentParser(description="Live-compile MOO examples with @program")
    parser.add_argument("paths", nargs="*", type=Path, help="Example files or directories; defaults to examples/**/*.moo")
    parser.add_argument("--target", default=DEFAULT_TARGET, help="Scratch verb target, e.g. me:llm_syntax_test")
    parser.add_argument("--argspec", default=DEFAULT_ARGSPEC, help="Scratch verb argspec used when creating the target")
    parser.add_argument("--perms", default=DEFAULT_PERMS, help="Scratch verb permissions")
    parser.add_argument("--env-file", type=Path, help="Optional env file containing MOO_HOSTNAME, MOO_PORT, MOO_USER, MOO_PASSWORD")
    parser.add_argument("--output", type=Path, default=Path("docs/live-compile-report.json"), help="JSON report path")
    parser.add_argument("--idle-ms", type=int, default=2500, help="Idle milliseconds that mark command completion")
    parser.add_argument("--first-timeout-ms", type=int, default=5000, help="Timeout for first response line")
    parser.add_argument("--limit", type=int, default=0, help="Optional max file count for smoke tests")
    parser.add_argument("--reconnect-every", type=int, default=25, help="Reconnect after this many compiles; 0 disables periodic reconnects")
    args = parser.parse_args()

    load_env_file(args.env_file)
    config = read_config()
    paths = collect_paths(args.paths)
    if args.limit:
        paths = paths[: args.limit]
    if not paths:
        print("No .moo files found.", file=sys.stderr)
        return 1

    started_at = timestamp()
    results: list[dict[str, Any]] = []
    output_path = args.output if args.output.is_absolute() else ROOT / args.output
    session: MooSession | None = None
    try:
        session = connect_session(config, args)
        for index, path in enumerate(paths, start=1):
            if args.reconnect_every and index > 1 and (index - 1) % args.reconnect_every == 0:
                session.close()
                session = connect_session(config, args)
            source = path.read_text(encoding="utf-8").rstrip() + "\n"
            note = f"compile check {path.relative_to(ROOT).as_posix()}"
            command = f"@program {args.target}\n{source}.\n{note}"
            output = session.command(command)
            ok = is_successful_compile(output)
            result = {
                "path": path.relative_to(ROOT).as_posix(),
                "ok": ok,
                "errors": extract_error_lines(output),
                "index": index,
            }
            results.append(result)
            write_report(output_path, args, started_at, results)
            status = "ok" if ok else "FAIL"
            print(f"[{index:04d}/{len(paths):04d}] {status} {result['path']}", flush=True)
            if not ok:
                session.close()
                session = connect_session(config, args)
    finally:
        if session is not None:
            session.close()

    report = write_report(output_path, args, started_at, results)

    if report["failed"]:
        print(f"{report['failed']} compile failure(s). Report: {output_path}", file=sys.stderr)
        return 1
    print(f"Compiled {report['ok']} of {report['total']} example(s). Report: {output_path}")
    return 0


def connect_session(config: dict[str, str | int], args: argparse.Namespace) -> "MooSession":
    session = MooSession(config, args.first_timeout_ms / 1000, args.idle_ms / 1000)
    session.connect()
    session.command(f"@verb {args.target} {args.argspec}\n@chmod {args.target} {args.perms}")
    return session


def write_report(output_path: Path, args: argparse.Namespace, started_at: str, results: list[dict[str, Any]]) -> dict[str, Any]:
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
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    return report


def load_env_file(path: Path | None) -> None:
    if not path:
        return
    env_path = path if path.is_absolute() else ROOT / path
    if not env_path.exists():
        raise SystemExit(f"Env file not found: {env_path}")
    for line in env_path.read_text(encoding="utf-8").splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith("#") or "=" not in stripped:
            continue
        key, value = stripped.split("=", 1)
        os.environ.setdefault(key.strip(), value.strip().strip("\"'"))


def read_config() -> dict[str, str | int]:
    aliases = {
        "host": ("MOO_HOSTNAME", "moo-hostname"),
        "port": ("MOO_PORT", "moo-port"),
        "user": ("MOO_USER", "moo-user"),
        "password": ("MOO_PASSWORD", "moo-password"),
    }
    values: dict[str, str] = {}
    for key, names in aliases.items():
        value = next((os.environ.get(name) for name in names if os.environ.get(name)), None)
        if value is None:
            raise SystemExit(f"Missing required environment value for {key}: one of {', '.join(names)}")
        values[key] = value
    return {"host": values["host"], "port": int(values["port"]), "user": values["user"], "password": values["password"]}


def collect_paths(raw_paths: list[Path]) -> list[Path]:
    if not raw_paths:
        return sorted((ROOT / "examples").rglob("*.moo"))
    paths: list[Path] = []
    for raw in raw_paths:
        path = raw if raw.is_absolute() else ROOT / raw
        if path.is_dir():
            paths.extend(sorted(path.rglob("*.moo")))
        else:
            paths.append(path)
    return sorted(dict.fromkeys(paths))


def is_successful_compile(output: str) -> bool:
    return "0 errors." in output and "Verb programmed." in output


def extract_error_lines(output: str) -> list[str]:
    lines = []
    for line in strip_ansi(output).splitlines():
        if re.search(r"\berrors?\b|syntax|parse|line \d+", line, re.IGNORECASE):
            lines.append(line.strip())
    return lines[-20:]


def strip_ansi(text: str) -> str:
    return re.sub(r"\x1b\[[0-9;]*m|\[00m", "", text)


def timestamp() -> str:
    return time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())


class MooSession:
    def __init__(self, config: dict[str, str | int], first_timeout: float, idle_timeout: float) -> None:
        self.config = config
        self.first_timeout = first_timeout
        self.idle_timeout = idle_timeout
        self.sock: socket.socket | None = None
        self.buffer = bytearray()

    def connect(self) -> None:
        self.sock = socket.create_connection((str(self.config["host"]), int(self.config["port"])), timeout=10)
        self.sock.settimeout(0.2)
        self.command(f"connect {self.config['user']} {self.config['password']}", login=True)

    def close(self) -> None:
        if self.sock is not None:
            try:
                self.sock.close()
            finally:
                self.sock = None

    def command(self, command: str, login: bool = False) -> str:
        if self.sock is None:
            raise RuntimeError("not connected")
        self.sock.sendall((command.rstrip("\n") + "\n").encode("utf-8"))
        output = self.read_until_idle()
        if login and re.search(r"incorrect|different password|no such player|invalid|denied|failed", output, re.IGNORECASE):
            raise SystemExit("MOO login failed")
        return output

    def read_until_idle(self) -> str:
        if self.sock is None:
            raise RuntimeError("not connected")
        chunks: list[bytes] = []
        first_deadline = time.monotonic() + self.first_timeout
        last_data_at: float | None = None
        while True:
            try:
                data = self.sock.recv(8192)
            except socket.timeout:
                now = time.monotonic()
                if not chunks and now > first_deadline:
                    break
                if chunks and last_data_at is not None and now - last_data_at >= self.idle_timeout:
                    break
                continue
            if not data:
                break
            chunks.append(filter_telnet(data))
            last_data_at = time.monotonic()
        return b"".join(chunks).decode("utf-8", errors="replace")


def filter_telnet(data: bytes) -> bytes:
    out = bytearray()
    i = 0
    while i < len(data):
        byte = data[i]
        if byte == IAC:
            if i + 1 < len(data):
                command = data[i + 1]
                if command in {251, 252, 253, 254} and i + 2 < len(data):
                    i += 3
                    continue
                if command == 250:
                    i += 2
                    while i + 1 < len(data) and not (data[i] == IAC and data[i + 1] == 240):
                        i += 1
                    i += 2
                    continue
                i += 2
                continue
        out.append(byte)
        i += 1
    return bytes(out)


if __name__ == "__main__":
    raise SystemExit(main())
