# Examples

Examples are small teaching snippets. They are not full core replacements.
Repair examples may show bad snippets inside valid MOO string comments; the
executable body should be the corrected version.

Each example should include:

- title
- dialect
- source
- license
- topic
- provenance, when the source is not original

Dialects: `portable`, `lambdamoo`, `stunt`, `toaststunt`, `core-specific`,
`patch-specific`.

Header lines are MOO string comments and must be valid statements:

```moo
" title: guarded-indexing";
" dialect: portable";
" source: original";
" license: MIT";
" topic: lists";
```

Optional metadata fields are `provenance`, `setup`, `dialect_reason`, `args`,
`returns`, `notes`, and `callable`. See `schemas/example.schema.json`.
`callable` may be `programmatic`, `command`, or `fragment`.
`dialect_reason` is required for `stunt`, `toaststunt`, `core-specific`, and
`patch-specific` examples.

Programmatically called verbs should begin with signature and usage string
comments. See `docs/verb-doc-comments.md`.

Direct Sindome-derived examples are included with permission from Sindome
(https://www.sindome.org/) and should use `source: approved-generic-sindome`.
Strip trailing VMS note/version/last-modified comments from imported verbs;
those are commit metadata, not teaching content.

When importing MOO code, expand short utility refs before committing examples:
`$ou` -> `$object_utils`, `$lu` -> `$list_utils`, `$su` -> `$string_utils`, and
`$cu` -> `$command_utils`.

Validate examples before adding more:

```bash
python3 scripts/validate_examples.py
```

To inspect builtin portability, compare the documented LambdaMOO and ToastStunt
builtin lists:

```bash
python3 scripts/diff_builtins.py
```
