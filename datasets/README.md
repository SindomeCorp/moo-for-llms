# Datasets

`instruction-examples.jsonl` is a small reviewed seed dataset. Add rows slowly
and keep each row source-safe.

`contrastive-examples.jsonl` contains small labeled snippets for classification
and critique tasks. Rows identify whether a snippet is valid, invalid, wrong for
the claimed dialect, unsafe, or confused about core commands versus language
syntax.

`example-index.jsonl` is generated from `examples/**/*.moo` for training
pipelines that need machine-readable metadata and code bodies.

Rows should conform to the matching schema in `schemas/`.

Validate rows with:

```bash
python3 scripts/build_example_index.py
python3 scripts/validate_jsonl.py
```

Export a filtered corpus with:

```bash
python3 scripts/export_training_corpus.py --dialect portable --source original
```

Create deterministic train/heldout splits with eval rows excluded:

```bash
python3 scripts/export_train_eval_split.py --include-contrastive-heldout
```

By default, repair examples are excluded from the normal training split and
contrastive snippets are excluded entirely. Use `--include-repairs` for repair
training and `--include-contrastive-heldout` when you want critique snippets in
the heldout file.

Generated expansion examples can be excluded or downweighted by downstream
samplers:

```bash
python3 scripts/export_training_corpus.py --exclude-generated-expansion
python3 scripts/export_train_eval_split.py --exclude-generated-expansion
python3 scripts/export_train_eval_split.py --downweight-generated 0.35
```

Inspect duplicate and near-duplicate example families with:

```bash
python3 scripts/report_duplicate_examples.py
```

See `docs/training-usage.md` for source-quality tiers and recommended export
profiles.
