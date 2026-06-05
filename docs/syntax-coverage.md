# MOO Syntax Coverage

This page tracks small, compile-focused examples for common MOO syntax forms.
The examples are intentionally narrow: each file should teach one or two syntax
features without turning into a full application.

All examples in `examples/syntax/` are original MIT-licensed examples. They
were compiled against a live MOO scratch verb using:

```text
@verb me:llm_syntax_test this none this
@chmod me:llm_syntax_test rxd
@program me:llm_syntax_test
```

The scratch verb uses the command-parser argspec `this none this` and `rxd`
permissions. The examples are compile checks, not runtime behavior guarantees.

## Portable Syntax

- `literals-and-values.moo`: integers, floats, strings, errors, objects, lists.
- `assignment-and-operators.moo`: assignment, arithmetic, comparisons, logical operators.
- `property-access.moo`: direct and computed property access.
- `verb-calls.moo`: normal calls, computed verb names, and argument splicing.
- `list-indexing-ranges.moo`: list indexing, ranges, and indexed assignment.
- `scatter-and-optional-args.moo`: scatter assignment, optional values, rest capture.
- `conditionals.moo`: `if`, `elseif`, `else`, and `endif`.
- `loops-break-continue.moo`: `for`, `while`, `break`, and `continue`.
- `error-expression.moo`: inline error-catching expression syntax.
- `try-except.moo`: block error handling with specific errors.
- `fork-block.moo`: background fork syntax.
- `pass-call.moo`: forwarding to an inherited verb with `pass(@args)`.
- `string-literal-comments.moo`: durable MOO comments as string statements.

## Coverage Matrix

| Syntax Form | Example Coverage | Eval Coverage | Notes |
| --- | --- | --- | --- |
| Literals and constants | `literals-and-values.moo` | `syntax-coverage-literals` | Includes INT, FLOAT, STR, ERR, OBJ-like values, and LIST. |
| Assignment and operators | `assignment-and-operators.moo` | basic syntax evals | Keep assignment-in-condition as repair data, not target syntax. |
| Direct property access | `property-access.moo` | `syntax-coverage-computed-property` | Pair with object/property docs for permission behavior. |
| Computed property access and assignment | `property-access.moo` | `syntax-coverage-computed-property-assignment` | Use `object.(prop)` and `object.(prop) = value`. |
| Direct verb calls | `verb-calls.moo` | syntax/codegen evals | Normal object verb call syntax. |
| Computed verb calls | `verb-calls.moo` | `syntax-coverage-computed-verb` | Use `object:(verb_name)(@args)` for dynamic dispatch examples. |
| Argument splicing | `verb-calls.moo`, `pass-call.moo` | `syntax-coverage-argument-splice` | Use `@args` only where a list should scatter into arguments. |
| List indexing and ranges | `list-indexing-ranges.moo`, range expansion examples | `syntax-coverage-list-splice`, `syntax-coverage-reverse-range` | Include forward and reverse ranges. |
| Splice insertion/deletion/replacement | `syntax-splice-replace-05.moo`, list examples | `syntax-coverage-splice-insert-delete` | Important for list algorithms and repairs. |
| Scatter assignment | `scatter-and-optional-args.moo`, scatter expansion examples | `syntax-coverage-scatter` | Include required, optional default, and rest capture. |
| Conditionals | `conditionals.moo` | basic syntax evals | Include `elseif`, `else`, and guard clauses. |
| Loops, break, continue | `loops-break-continue.moo`, loop expansion examples | syntax/codegen loop evals | Pair with task-yield examples for long loops. |
| Inline error expression | `error-expression.moo`, error examples | `syntax-coverage-inline-catch` | Backtick-apostrophe form must close with `'`. |
| `try`/`except`/`endtry` | `try-except.moo`, error examples | `syntax-coverage-try-except` | Prefer specific error lists over `ANY`. |
| `fork`/`endfork` | `fork-block.moo`, task examples | `syntax-coverage-fork` | Runtime examples should capture/revalidate objects. |
| `pass(@args)` | `pass-call.moo` | `syntax-coverage-pass-forwarding` | Inherited dispatch, not a generic function call. |
| String-literal comments | `string-literal-comments.moo`, repair examples | common-mistake evals | Durable comments must be quoted string statements ending in `;`. |
| Command parser variables | `examples/command-parser/` | command-parser evals | Parser variables are runtime variables, not syntax declarations. |
| ToastStunt maps | `toaststunt-map-literal.moo`, `toaststunt-map-iteration.moo` | map syntax evals | `[]` is a MAP literal, not a portable empty list. |
| ToastStunt type constants | `toaststunt-type-constants.moo` | `syntax-coverage-type-constants` | `MAP`, `WAIF`, `ANON`, and `BOOL` are dialect-specific here. |

## ToastStunt-Specific Syntax

- `toaststunt-map-literal.moo`: map literal, map indexing, and map assignment.
- `toaststunt-map-iteration.moo`: key/value iteration over a map.
- `toaststunt-type-constants.moo`: `MAP`, `WAIF`, `ANON`, and `BOOL` type constants.

These examples are marked ToastStunt-specific because maps, true BOOL values,
waifs, anonymous objects, and related type constants are not portable LambdaMOO
syntax.

## What Not To Include Here

Invalid syntax examples belong in contrastive repair examples, not in
`examples/syntax/`. Syntax coverage should train a model on valid forms first;
bad/fixed pairs can reference the same topic separately.
