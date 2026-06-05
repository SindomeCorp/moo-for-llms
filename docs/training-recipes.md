# Training Recipes

Use these recipes as starting points for downstream training and evaluation.
They assume `python3 scripts/check_all.py` and `python3 scripts/refresh_reports.py`
pass first.

## General Codegen

Use curated live adaptations and original handwritten examples. Exclude
generated expansion families for a smaller, higher-signal supervised set.

```bash
python3 scripts/export_train_eval_split.py \
  --output-dir datasets/splits/codegen-high-signal \
  --exclude-generated-expansion \
  --include-contrastive-heldout
```

Use `train.jsonl` for supervised examples and `heldout.jsonl` for internal
checks. Keep `evals/**/*.jsonl` separate as benchmark rows.

## Broad Pretraining-Style Exposure

Include repairs and a capped amount of generated expansion breadth. The manifest
records the recommended generated-example downweight.

```bash
python3 scripts/export_train_eval_split.py \
  --output-dir datasets/splits/broad-exposure \
  --include-repairs \
  --include-docs \
  --include-contrastive-heldout \
  --max-generated-family-examples 3 \
  --downweight-generated 0.35
```

Use this when the model needs broad familiarity with docs, repairs, utility
packages, syntax forms, and dialect notes.

## Portable-Only Code

Use this for models or evals that should avoid ToastStunt, patch-specific, and
core-specific dependencies.

```bash
python3 scripts/export_training_corpus.py \
  --dialect portable \
  --output datasets/exports/portable-only.jsonl
```

Portable examples may still call common core utility objects such as
`$list_utils` or `$object_utils`; that is a core assumption, not a ToastStunt
server dependency.

## ToastStunt-Specific Code

Use this when training or testing ToastStunt maps, true BOOL values, waifs,
ToastStunt type constants, and ToastStunt builtins.

```bash
python3 scripts/export_training_corpus.py \
  --dialect toaststunt \
  --include-contrastive \
  --output datasets/exports/toaststunt.jsonl
```

Do not mix this into portable-only training without preserving dialect labels.

## Dialect Classification

For classifiers, include non-portable dialects and contrastive rows.

```bash
python3 scripts/export_training_corpus.py \
  --dialect toaststunt \
  --dialect core-specific \
  --dialect patch-specific \
  --include-contrastive \
  --include-docs \
  --output datasets/exports/dialect-classification.jsonl
```

Hold out `evals/codegen/dialect-classification.jsonl` and related syntax evals.

## Repair And Critique

For repair models, include repair examples and contrastive rows. Keep ordinary
codegen examples mixed in so the model still sees correct target code.

```bash
python3 scripts/export_train_eval_split.py \
  --output-dir datasets/splits/repair-critique \
  --include-repairs \
  --include-contrastive-heldout \
  --max-generated-family-examples 2
```

When training from contrastive rows, do not treat `snippet` as the target code
unless the label is part of the task. Use `fixed` as the repaired target.

## Provenance-Sensitive Export

Use original-only data when the consumer cannot use approved Sindome-derived
adaptations.

```bash
python3 scripts/export_training_corpus.py \
  --source original \
  --output datasets/exports/original-only.jsonl
```

Use approved Sindome-derived examples when permission/provenance metadata is
acceptable:

```bash
python3 scripts/export_training_corpus.py \
  --source approved-generic-sindome \
  --output datasets/exports/approved-sindome-derived.jsonl
```

## Algorithm-Focused Training

Use this for search, sorting, pathing, parsing, and list transformation tasks.

```bash
python3 scripts/export_training_corpus.py \
  --topic algorithm-patterns \
  --topic loops \
  --topic lists \
  --topic utility-packages \
  --output datasets/exports/algorithms.jsonl
```

Keep `evals/codegen/algorithm-patterns.jsonl` held out so DFS/BFS, cache
validation, and dialect distinctions remain testable.

## Quality Gates

Before using any recipe, run:

```bash
python3 scripts/check_all.py
python3 scripts/refresh_reports.py
```

Review:

- `docs/coverage-report.md`
- `docs/duplicate-example-report.md`
- `docs/training-quality-report.md`
- `docs/eval-coverage-report.md`
