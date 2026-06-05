# Generated Expansion Quality Review

The 200-example expansion was compile-tested on the live MOO with
`@program me:llm_syntax_test`, and all generated bodies compiled with `0
errors`. This review records quality caveats and corrections so downstream
dataset builders can sample the expansion responsibly.

## Corrections Made

- Corrected invalid property assignment syntax in
  `examples/command-parser/cp-dobj-this-use.moo` from `this:last_used = dobj`
  to `this.last_used = dobj`.
- Reclassified generated utility-style examples from `approved-generic-sindome`
  to `original`. They are useful training examples, but they are not direct live
  Sindome utility-verb adaptations.
- Updated generated utility curation-index rows to `deferred` so they do not
  inflate the count of live utility verbs that have been curated.

## Duplicate Families

The generated expansion intentionally includes repeated families with numbered
variants. These are valid MOO and can help reinforce syntax, but they should not
all be sampled at equal weight in small training sets.

High-duplication families include:

- task revalidation after suspend
- task command input with `read()`
- property-info and dynamic-property introspection
- verb-info and verb-args introspection
- repair examples for broad catches, command feedback, assignment in
  conditionals, deep nesting, and programmatic player feedback
- compact syntax forms such as scatter assignment, ranges, splice assignment,
  `pass(@args)`, and `try`/`except`
- ToastStunt map and BOOL variants
- generated utility-style helpers

Recommended sampling:

- In small training sets, take one or two examples per duplicate family.
- In large training sets, include all examples but downweight repeated generated
  families compared with hand-curated live utility adaptations.
- For evals, hold out at least one member of each duplicate family.

## Provenance Guidance

`approved-generic-sindome` should mean an example was adapted from an approved
live Sindome source with permission from Sindome and with source-control notes
removed. Generated examples that merely imitate a utility style must use
`source: original`.

The generated `utility-expanded-*` examples are now `source: original`; their
role is breadth coverage, not provenance-bearing live-source curation.

## Remaining Review Priorities

- Replace some generated duplicate families with hand-curated live examples
  when more source verbs are reviewed.
- Add more command examples from real command verbs where gameplay-specific
  details can be stripped safely.
- Add more non-generated `strings`, `errors`, `verb-docs`, and `code-scanner`
  examples.
- Continue logging compile or scanner mistakes in `mistakes.json`.
