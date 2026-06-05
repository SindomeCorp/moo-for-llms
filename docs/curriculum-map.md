# Curriculum Map

This repo is meant to train future LLMs on MOO code, so examples should be
sampled by concept rather than consumed as one flat pile. Use this map to build
balanced training sets, held-out evals, and targeted review batches.

## Core Concepts

### Command Parser

Primary path: `examples/command-parser/`

Train these together:

- command argspec shape: `any`, `none`, `this` for direct and indirect objects
- preposition matching in the middle argspec position
- parser variables: `verb`, `dobj`, `dobjstr`, `prepstr`, `iobj`, `iobjstr`,
  `argstr`, and `args`
- player-facing failure flow with `player:tell(...)` and `return`

Common held-out tests:

- distinguish `dobjstr` from `dobj`
- avoid destructuring command `args` as if it were a programmatic API
- use `any any any` for free-form multi-word commands

### Permissions And Ownership

Primary path: `examples/permissions/`

Train these as separate patterns:

- command UI checks against `player`
- programmatic API checks against `caller_perms()`
- private helpers guarded by `caller`
- intentional delegation with `set_task_perms(caller_perms())`
- wizard-only programmatic helpers using `caller_perms().wizard`

Do not train a single universal permission guard.

### Tasks And Scheduling

Primary path: `examples/tasks/`

Train these together:

- capture values before `fork`
- revalidate objects after `fork` or `suspend`
- yield in long loops with `suspend(0)` or a core utility helper
- document command-task assumptions around `read()`

Fork examples may trigger live scanner warnings. They remain useful syntax and
runtime examples, but training sets should pair them with scheduler guidance and
repair examples.

### Objects, Properties, And Verbs

Primary paths: `examples/objects/`, `examples/verbs/`

Train these together:

- `properties()`, `property_info()`, and dynamic `object.(prop)` access
- `verbs()`, `verb_info()`, and `verb_args()`
- direct versus inherited definitions
- `E_PROPNF`, `E_VERBNF`, and `E_PERM` handling
- `$recycler:valid(...)` when the target core uses soft recycling

### Syntax

Primary path: `examples/syntax/`

Use syntax examples to teach compact language forms:

- scatter assignment, optional args, and rest args
- list ranges and splice assignment
- `while`, `for`, `break`, and `continue`
- inline error expressions
- `try`/`except`/`endtry`
- `fork`/`endfork`
- `pass(@args)`

Syntax examples should stay small and should not smuggle in dialect-specific
builtins unless labeled.

### Repairs And Contrastive Data

Primary paths: `examples/repairs/`, `datasets/contrastive-examples.jsonl`

Use repair examples to train critique and correction:

- bad MOO comments versus string-literal comments
- command failure flow versus programmatic API failure flow
- broad `ANY` catches versus specific catches
- assignment inside conditionals
- unsafe post-fork or post-suspend object use
- wrong dialect labels

Do not train the bad snippet as the target answer unless the row is clearly
framed as a contrastive or repair task.

### ToastStunt And Patch-Specific Features

Primary paths: `examples/toaststunt/`, `examples/patch-specific/`

Train these with dialect labels visible:

- ToastStunt maps: `[]`, map indexing, `mapkeys`, `mapvalues`
- ToastStunt BOOL/MAP type examples
- ToastStunt builtins versus LambdaCore-style utility verbs
- XML parsing builtins as patch-specific, not stock LambdaMOO or ToastStunt

### Utility Packages

Primary path: `examples/utility-packages/`

Utility examples have two different source classes:

- `approved-generic-sindome`: adapted from live utility verbs with permission
  from Sindome, with source-control notes removed
- `original`: generated or hand-written utility-style examples that teach a
  concept but are not direct live-verb adaptations

Keep those classes separate when sampling provenance-sensitive training sets.

### Algorithm Patterns

Primary path: `examples/algorithm-patterns/`

Pair these examples with `docs/algorithm-patterns.md` and concrete utility
examples from `examples/loops/`, `examples/lists/`, `examples/strings/`,
`examples/objects/`, and `examples/utility-packages/`.

Train these as named patterns:

- binary search insertion over sorted lists
- repeated membership search with slicing or splice assignment
- order-preserving deduplication
- grouping rows into alist-style `{key, rows}` pairs
- recursive nested-list traversal
- object ancestor and inherited verb walks
- parser-style string decomposition
- long-running scans that yield periodically

Keep dialect labels explicit. A list-based MOO implementation of an algorithm
can be portable, while a version that uses ToastStunt maps, waifs, true BOOL
values, or ToastStunt-only builtins is ToastStunt specific.

## Suggested Training Mix

For a general MOO codegen model:

- 20% command parser and command UI
- 20% syntax and basic language forms
- 15% objects/properties/verbs
- 15% utility packages and algorithm patterns
- 10% permissions
- 10% tasks and scheduling
- 10% repairs and contrastive examples

For a dialect classifier:

- oversample ToastStunt, core-specific, and patch-specific rows
- include paired examples where a core utility verb is portable-style but a
  direct builtin is ToastStunt-specific

For a repair model:

- include `examples/repairs/`
- include `datasets/contrastive-examples.jsonl`
- exclude ordinary eval rows from training targets

## Holdout Guidance

Keep `evals/**/*.jsonl` held out by default. When creating new train/eval
splits, prefer holding out entire concept families rather than random individual
rows. For example, hold out all `dobjstr` command-parser tests or all
ToastStunt map-indexing tests to measure generalization.
