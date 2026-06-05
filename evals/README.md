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
