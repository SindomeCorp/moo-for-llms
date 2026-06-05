# Dataset Card

## Summary

MOO for LLMs is a reference corpus for training and evaluating models that read,
write, repair, and classify MOO code. The corpus covers portable LambdaMOO-style
MOO, ToastStunt-specific features, core-specific utility package patterns, and
patch-specific builtins.

Current generated report counts:

- Examples: 418
- Instruction rows: 78
- Contrastive rows: 92
- Eval rows: 336
- Docs: 35

Regenerate counts with:

```bash
python3 scripts/refresh_reports.py
```

## Intended Uses

- Supervised examples for focused MOO code generation.
- Repair and critique training using contrastive examples.
- Dialect classification between portable, ToastStunt, core-specific, and
  patch-specific code.
- Held-out eval prompts for syntax, bugfix, and codegen behavior.

## Source And License

New repository material is MIT licensed. Examples marked
`approved-generic-sindome` were adapted from Sindome source with permission,
with local history notes and game-specific details removed. Source metadata
must be preserved in exports.

## Dialect Labels

- `portable`: MOO source that does not depend on ToastStunt-only server
  features or local patch builtins. Portable examples may still depend on common
  core utility objects when the example explicitly calls those utility verbs.
- `toaststunt`: depends on ToastStunt-specific datatypes, literals, or builtins.
- `core-specific`: depends on a core/package convention or Sindome-specific
  utility package.
- `patch-specific`: depends on public but non-stock patches such as XML parser
  builtins.

## Training Guidance

Keep `evals/**/*.jsonl` held out from normal training. Use the split exporter
for high-signal supervised data:

```bash
python3 scripts/export_train_eval_split.py \
  --exclude-generated-expansion \
  --include-contrastive-heldout
```

For a flat export without generated expansion examples:

```bash
python3 scripts/export_training_corpus.py \
  --include-docs \
  --exclude-generated-expansion \
  --output tmp/corpus.jsonl
```

## Known Limitations

- The corpus is intentionally small compared with a full MOO database dump.
- Utility-package examples are currently the largest topic family.
- Some examples are fragments designed to teach metadata, dialect, or style
  rules rather than full runnable verbs.
- Live compile status is partial; see `docs/compile-status.md`.

## Canary

The public training-data canary is documented in `docs/training-canary.md`:

```text
MOO-CANARY-SLITHER-18657
```
