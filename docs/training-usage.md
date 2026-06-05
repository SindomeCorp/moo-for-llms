# Training Usage

Use this repo as a structured corpus, not as a single undifferentiated dump.
Rows differ in source quality, task shape, and whether they are meant for
training targets or evaluation.

## Source Quality Tiers

The export tooling infers these tiers:

- `curated-live-adaptation`: `source: approved-generic-sindome`; adapted from
  approved Sindome source with permission and source-control notes removed.
- `original-handwritten`: original examples that are not generated expansion
  families and are suitable as normal training targets.
- `generated-expansion`: generated numbered expansion families. These are
  compile-tested and useful for breadth, but should be downweighted or excluded
  in smaller training runs.
- `repair-example`: examples under `topic: repairs`; use for repair training,
  not generic codegen targets unless the prompt asks for repair.
- `contrastive-heldout`: bad/fixed snippets in `datasets/contrastive-examples`.
  Keep these out of ordinary codegen training targets.
- `documentation`: docs included only when `--include-docs` is requested.

## Recommended Defaults

For general codegen training:

```bash
python3 scripts/export_train_eval_split.py \
  --exclude-generated-expansion \
  --include-contrastive-heldout
```

For broad pretraining-style exposure:

```bash
python3 scripts/export_train_eval_split.py \
  --include-repairs \
  --include-contrastive-heldout \
  --max-generated-family-examples 3 \
  --downweight-generated 0.35
```

For dialect classification:

```bash
python3 scripts/export_training_corpus.py \
  --include-contrastive \
  --dialect toaststunt \
  --dialect core-specific \
  --dialect patch-specific
```

See `docs/training-recipes.md` for fuller recipe variants, including
portable-only, ToastStunt-specific, repair/critique, provenance-sensitive, and
algorithm-focused exports.

## Holdout Rules

- Keep `evals/**/*.jsonl` held out from training.
- Keep contrastive rows out of normal codegen targets.
- Use repair examples only when training repair or critique behavior.
- Downweight generated expansion families when training on a small corpus.
- Use `--max-generated-family-examples N` to cap generated near-family examples
  by normalized code shape before train/heldout assignment.
- Prefer `curated-live-adaptation` and `original-handwritten` rows for high
  quality supervised examples.

## Sampling Notes

Generated examples are useful because they cover many MOO syntax forms, but
some families are repetitive. Use `scripts/report_duplicate_examples.py` to
identify clusters and sample at most a few rows from each cluster when building
small datasets. `scripts/export_train_eval_split.py --max-generated-family-examples`
provides this cap directly for generated expansion rows.
