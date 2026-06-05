# Duplicate Policy

This corpus should favor breadth over repeated near-identical snippets. A small
number of related examples is useful when the surface syntax differs, but exact
generated clones should be removed.

## Keep

- Handwritten examples that teach the same topic from meaningfully different
  angles.
- Adapted live-code examples when each one demonstrates a different MOO pattern,
  permission shape, command argspec, or dialect boundary.
- Contrastive bad/fixed pairs, even when the bad and fixed snippets share most
  of their structure.

## Prune

- Exact generated duplicate bodies after stripping metadata and string-literal
  comments.
- Numbered expansion examples that differ only in names, string text, or small
  constants.
- VMS note/version/history tails from pulled Sindome examples.

## Export Controls

`scripts/export_train_eval_split.py` supports
`--max-generated-family-examples N` to cap near-family generated examples in a
training split. This is intended for generated expansion rows: keep enough
examples to show the pattern, but avoid letting repeated generated forms dominate
the split.

Use `scripts/report_duplicate_examples.py` to regenerate the review report:

```bash
python3 scripts/report_duplicate_examples.py --json-output tmp/duplicate-example-report.json
```
