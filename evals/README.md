# Evals

These seed evals are intentionally small. They are designed to catch common LLM
mistakes before growing into a larger benchmark.

- `syntax/`: decide whether code is plausible MOO and identify dialect.
- `bugfix/`: repair small broken snippets.
- `codegen/`: produce focused snippets from natural-language prompts.

Validate eval rows with:

```bash
python3 scripts/validate_jsonl.py
```

Report benchmark coverage and export prompt rows with:

```bash
python3 scripts/report_eval_coverage.py --output docs/eval-coverage-report.md
python3 scripts/report_eval_coverage.py --kind codegen --prompts-output tmp/evals/codegen-prompts.jsonl
```

Do not include eval rows in normal training exports. The split exporter
`scripts/export_train_eval_split.py` intentionally excludes `evals/**/*.jsonl`.

Score model outputs in a lightweight review pass with:

```bash
python3 scripts/score_eval_outputs.py model-outputs.jsonl \
  --output tmp/eval-score-report.json \
  --markdown-output tmp/eval-score-report.md \
  --require-dialect-label
```

The scorer checks expected strings, expected-property phrases, empty outputs,
and optional non-portable dialect labels. It reports failure categories so a
reviewer can separate missing code shape, missing dialect classification, and
missing outputs. It is a triage tool, not a replacement for human review or
live compilation of generated MOO.

Eval rows may also include richer scoring metadata:

- `checks`: point-scored `contains`, `not_contains`, `regex`, and `not_regex`
  checks.
- `negative_patterns`: row-specific regex patterns that fail the answer when
  present.
- `forbidden_patterns`: stricter row-specific regex patterns for known-invalid
  output.
- `gold_answer`: a reviewed answer for human comparison and future scorer
  improvements.
- `requires_code`: require the model output to include MOO-looking code.
- `compile_check`: mark rows whose generated code should be live-compiled when
  the scorer is run with `--live-compile`.

The scorer also applies global MOO hygiene checks for common invalid patterns:
JavaScript comments, JavaScript try/catch, LambdaCore programming commands
inside verb source, short utility refs, raw object ids, unterminated
string-literal comments, and unbalanced MOO block delimiters.

For live compile checks, run:

```bash
python3 scripts/score_eval_outputs.py model-outputs.jsonl \
  --output tmp/eval-score-report.json \
  --markdown-output tmp/eval-score-report.md \
  --require-dialect-label \
  --live-compile \
  --env-file /path/to/moo.env
```

Use `--live-compile-all-code` only for small review batches. It attempts to
compile every answer where code can be extracted, not just rows marked
`compile_check`.
