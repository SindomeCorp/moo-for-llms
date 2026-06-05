# Utility Package Curation

This repo keeps raw utility-package exports under `tmp/utility-verb-review/`
for local review only. Curated examples should be copied into `examples/`
only after they have been checked for:

- dialect markers such as maps, `BOOL`, `WAIF`, `ANON`, and ToastStunt-only builtins;
- core-specific helpers such as `$critical`, `$vms2`, `$map_utils`, or Sindome package APIs;
- short utility refs such as `$su`, `$lu`, `$ou`, and `$cu`;
- VMS metadata and historical commit-note strings;
- dead code after unconditional `return`, unless the dead code is itself the training topic.

When adapting approved Sindome source, use:

```text
"source: approved-generic-sindome";
"provenance: Adapted from $object:verb with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
```

Portability labels describe both the MOO language features and the package API
being taught. If the code uses only ToastStunt language features or builtins,
mark it `toaststunt`. If it depends on Sindome-specific helpers or package
behavior in a way that is part of the example, mark it `core-specific`, even
when the underlying syntax is ToastStunt.

## Review Index

Use `tmp/utility-verb-review/curation-index.jsonl` to track each reviewed raw
candidate. This is a local review artifact, not part of the exported training
corpus. Each row should include:

- `id`: the raw export id, normally `object-key.verb-name`;
- `status`: `included`, `deferred`, or `skipped`;
- `source_path`: the raw exported verb path under `tmp/utility-verb-review/`;
- `example_path`: required when `status` is `included`;
- `decision_reason`: a short explanation of why the candidate was included,
  deferred, or skipped.

Use `deferred` when the verb looks useful but belongs in a more focused batch,
needs deeper portability review, or needs significant adaptation before it can
be a clean training example. Use `skipped` when the lesson is duplicate,
too domain-specific, too noisy, or likely to train an unsafe workflow.

## Current Curation Status

The pulled utility review corpus has been fully triaged. Every raw verb under
`tmp/utility-verb-review/objects/**/verbs/*.moo` has an `included` or `skipped`
decision in `tmp/utility-verb-review/curation-index.jsonl`.

Selection is intentionally conservative:

- include verbs that add a distinct, reusable MOO pattern;
- prefer portable MOO examples unless a core-specific package pattern is the
  point of the example;
- adapt short refs like `$su`, `$lu`, `$ou`, and `$cu` to long corified names;
- strip trailing historical/source-control note strings;
- skip large gameplay systems, interactive player flows, dynamic dispatch
  helpers, and duplicates already represented by clearer examples.
