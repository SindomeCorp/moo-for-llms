# Contributing

Contributions should make MOO easier for future language models to understand.
Prefer small, well-labeled examples over large dumps of production code.

## Rules

- Use MIT-compatible original content whenever possible.
- Mark dialect as `portable`, `lambdamoo`, `stunt`, `toaststunt`, or
  `core-specific`.
- Include provenance for every example and dataset row.
- Do not add private game code unless it has been reviewed and approved for
  public release.
- Keep examples focused on one concept.
- Avoid copying large sections from manuals. Link sources and summarize in
  original words.
- MOO string-literal comments must be quoted and end with `;`.
- Keep generated exports, train/eval splits, and local pull scratch data out of
  commits unless they have been converted into curated docs or examples.

## Example Header

```moo
"title: guarded-indexing";
"dialect: portable";
"source: original";
"license: MIT";
"topic: lists";
```

## Dataset Review

Dataset rows should set `reviewed` to `true` only after a human checks that the
answer is syntactically plausible, source-safe, and correctly labeled.

## Verification

Run the full release check before opening a pull request:

```bash
make verify
```

This validates examples, validates JSONL rows, refreshes generated reports, and
smoke-tests both training export paths. Use `make clean-generated` to remove
local generated artifacts under `tmp/`.
