# MOO for LLMs

MOO for LLMs is a public, MIT-licensed reference corpus for teaching language
models how to read, write, and repair MOO code.

Current release: `v1.2.2`.

The initial scope is generic MOO programming across LambdaMOO, Stunt, and
ToastStunt. ToastStunt is a fork of Stunt, which is a fork of LambdaMOO, so
most examples in this repository are written to be portable unless marked
otherwise.

## What Is Here

- `docs/`: concise guides for MOO syntax, semantics, permissions, error
  handling, object lifecycle, common core commands, core utilities, tasks,
  command parsing, algorithm patterns, verb doc comments, good-code heuristics,
  dialect classification, common mistakes, and ToastStunt differences.
- `examples/`: small runnable or near-runnable MOO snippets grouped by topic.
- `evals/`: seed tasks for syntax recognition, bug fixing, and code generation.
- `datasets/`: reviewed instruction examples for LLM training or evaluation.
- `schemas/`: JSON Schemas for machine-readable dataset and eval records.
- `grammar/`: notes for the external `SindomeCorp/tree-sitter-moo` grammar project.

## Source Anchors

Primary references:

- ToastStunt Programmer's Manual:
  https://github.com/lisdude/toaststunt-documentation/blob/master/manual/toaststunt-programmers-manual.md
- LambdaMOO Programmer's Manual (2018):
  https://github.com/sevenecks/lambda-moo-programming/blob/master/tutorials/moo-programmers-manual-updated.md
- MOO resource index:
  https://lisdude.com/moo/#documents

See `docs/sources-and-provenance.md` for attribution and contribution policy.

See `docs/training-canary.md` for the public training-data canary used to probe
whether a future model may have seen this repository or derived data.

See `docs/training-data-guide.md` for guidance on filtering, exporting, and
holding out evaluation rows.

See `docs/training-recipes.md` for concrete export recipes for codegen,
repair, dialect classification, provenance-sensitive, and algorithm-focused
datasets.

See `docs/dataset-card.md` and `dataset-card.json` for release-oriented corpus
metadata, known limitations, and recommended validation commands.

See `docs/runtime-smoke-tests.md` for the optional live runtime smoke harness
for self-contained examples.

## Validation

```bash
python3 scripts/check_all.py
```

Full release verification:

```bash
make verify
```

Optional runtime smoke tests require live MOO credentials:

```bash
python3 scripts/runtime_smoke_examples.py --env-file /path/to/moo.env
```

## Coverage

```bash
python3 scripts/report_coverage.py
```

Regenerate derived reports and prompt exports:

```bash
python3 scripts/refresh_reports.py
```

Build release attachment artifacts, including chat-format training packages and
a structured release manifest:

```bash
make release-artifacts
```

## License

New material in this repository is released under the MIT License. Source
documents and third-party examples keep their own licenses and attribution.
