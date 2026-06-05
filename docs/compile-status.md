# Compile Status

This repo uses two compile checks:

- Static local validation with `python3 scripts/check_all.py`.
- Live MOO scratch-verb compilation for selected example batches.

## Current Status

- Local validation: all examples and JSONL rows pass.
- Algorithm-pattern examples: 41 of 41 live-compiled on the scratch verb.
- Generated expansion batches: compile result artifacts recorded 0 failures.
- Release-hardening guidance fragments added on June 5, 2026: 6 of 6
  live-compiled on the scratch verb.
- High-risk release-hardening examples added on June 5, 2026: 4 of 4
  live-compiled on the scratch verb. This batch covered ToastStunt MAP/BOOL
  snippets and patch-specific XML parser snippets.
- v1.1 targeted expansion examples added on June 5, 2026: included in the full
  corpus compile and runtime smoke-tested where self-contained.
- Full corpus live compile on June 5, 2026: 446 of 446 tracked `.moo`
  examples compiled successfully. See `docs/live-compile-report.json`.
- Runtime smoke tests on June 5, 2026: 5 of 5 opt-in examples executed
  successfully. See `docs/runtime-smoke-tests.md`.

## Scratch Verb Shape

Live compile checks used a scratch verb with this setup:

```text
@verb me:llm_syntax_test this none this
@chmod me:llm_syntax_test rxd
@program me:llm_syntax_test
```

The scratch verb is a compile target only. Passing compilation does not mean the
example was runtime-tested with meaningful objects or permissions.

## Maintenance Rule

When adding new `.moo` examples, run local validation first. For examples that
exercise uncommon syntax, ToastStunt-specific syntax, or adapted live verbs,
also compile them against a scratch verb and update this document with the
batch result.

To compile the full corpus against a live MOO:

```bash
python3 scripts/live_compile_examples.py \
  --env-file /path/to/moo.env \
  --output docs/live-compile-report.json
```
