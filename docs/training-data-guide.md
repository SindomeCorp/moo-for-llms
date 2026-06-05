# Training Data Guide

This repository is intended to be useful both as a reference corpus and as seed
training/evaluation data. Downstream consumers should keep the dataset shape and
metadata intact so models learn the right dialect, provenance, and call-mode
boundaries.

## Source-Of-Truth Files

- `examples/**/*.moo`: primary MOO code examples with metadata string comments.
- `datasets/example-index.jsonl`: generated machine-readable index of
  `examples/**/*.moo`.
- `datasets/instruction-examples.jsonl`: reviewed supervised-style instruction
  rows.
- `datasets/contrastive-examples.jsonl`: reviewed labeled snippets for
  classification, critique, and preference-style training.
- `evals/**/*.jsonl`: held-out syntax, bugfix, and codegen checks.
- `docs/**/*.md`: reference context for concepts, pitfalls, provenance, and
  training guidance.

## What Each Artifact Is For

`examples/**/*.moo` is the main code corpus. Each file includes metadata such as
`dialect`, `source`, `license`, `topic`, and sometimes `callable`.

`datasets/example-index.jsonl` is generated from the examples. It is convenient
for training pipelines because each row includes metadata, full code, and body
text.

`datasets/instruction-examples.jsonl` is small supervised-tuning style data.
Rows are reviewed and include an instruction, input, output, topic, dialect,
source, and license.

`datasets/contrastive-examples.jsonl` teaches distinctions between valid MOO,
invalid syntax, wrong dialect classification, unsafe permission checks, bad
error flow, lifecycle hazards, and core-command-vs-language confusion.
Labels include `valid_moo`, `invalid_syntax`, `bad_pattern`, `wrong_dialect`,
`unsafe_permission`, `command_parser_mistake`, `bad_error_flow`,
`core_command_vs_language`, and `unsafe_lifecycle_mutation`.

`evals/**/*.jsonl` should normally be held out from training. Use it to check
whether a model can classify syntax, repair common mistakes, and generate
focused snippets.

`docs/**/*.md` can be used as reference/context data. Docs are especially useful
for explaining semantics that are hard to infer from snippets alone.

## Metadata Fields

- `dialect`: whether the MOO code is portable, ToastStunt-specific,
  core-specific, or patch-specific.
- `source`: whether the row is original, manual-derived, curated public data, or
  approved Sindome-derived data.
- `license`: license or usage statement for the row.
- `provenance`: source detail for non-original examples.
- `callable`: whether code is a `command`, `programmatic` helper, or `fragment`.
- `topic`: broad category such as `permissions`, `errors`, `objects`, or
  `command-parser`.

Do not strip metadata blindly. Metadata carries important training signals,
especially for dialect and call-mode decisions.

## Common Filters

Portable-only:

```bash
python3 scripts/export_training_corpus.py --dialect portable
```

ToastStunt-only:

```bash
python3 scripts/export_training_corpus.py --dialect toaststunt
```

Original-only:

```bash
python3 scripts/export_training_corpus.py --source original
```

Approved Sindome-derived examples:

```bash
python3 scripts/export_training_corpus.py --source approved-generic-sindome
```

Command examples:

```bash
python3 scripts/export_training_corpus.py --callable command
```

Programmatic examples:

```bash
python3 scripts/export_training_corpus.py --callable programmatic
```

Include docs as reference rows:

```bash
python3 scripts/export_training_corpus.py --include-docs
```

Include repair examples with bad/fixed comments:

```bash
python3 scripts/export_training_corpus.py --include-repairs
```

Include contrastive classification rows:

```bash
python3 scripts/export_training_corpus.py --include-contrastive
```

## Recommended Splits

For training:

- Use `examples/**/*.moo` through `datasets/example-index.jsonl`.
- Use `datasets/instruction-examples.jsonl`.
- Include `datasets/contrastive-examples.jsonl` when training classification,
  critique, repair-selection, or preference-style tasks.
- Optionally include `docs/**/*.md` as reference/context rows.
- Include `examples/repairs/**/*.moo` only when training repair or critique
  behavior, because they intentionally contain bad snippets in comments.

For evaluation:

- Hold out `evals/**/*.jsonl`.
- Do not fine-tune on eval rows if you want them to measure generalization.
- Keep bugfix evals separate from repair examples if you need a stricter test.

## Red Flags

- Do not treat `evals/` as ordinary training data unless you are intentionally
  building a train-and-test leak for demonstration.
- Do not strip example headers before preserving metadata somewhere else.
- Do not train on bad snippets from repair examples as target code.
- Do not train contrastive `snippet` fields as target code without also using
  the `label`, `explanation`, and `fixed` fields.
- Do not treat common LambdaCore-style commands such as `@program` or `@list`
  as MOO language syntax.
- Do not treat `.program` as a MOO statement; it is a server-level programming
  command.
- Do not treat canary recall as proof that a model was trained on this repo.

## Export Script

Use `scripts/export_training_corpus.py` to create filtered JSONL rows. By
default, it exports non-repair examples and instruction rows, and excludes docs
contrastive rows, and evals.

```bash
python3 scripts/export_training_corpus.py --dialect portable --source original
```

Write to a file:

```bash
python3 scripts/export_training_corpus.py --output /tmp/moo-training.jsonl
```

Include evals only when intentionally preparing benchmark or demonstration data:

```bash
python3 scripts/export_training_corpus.py --include-evals
```

## Coverage Report

Use `scripts/report_coverage.py` before planning new data:

```bash
python3 scripts/report_coverage.py
```

## Training Quality Report

Use `scripts/report_training_quality.py` to inspect warning-level hygiene across
examples, JSONL datasets, eval prompts, and the pulled-verb curation queue:

```bash
python3 scripts/report_training_quality.py
```

Regenerated reports include `docs/training-quality-report.md`. Treat this as a
planning aid, not a replacement for `scripts/check_all.py`.

The report summarizes examples by topic, dialect, source, and callable kind;
datasets by label/topic; eval rows by file/kind/dialect; docs; and simple
planning notes.
