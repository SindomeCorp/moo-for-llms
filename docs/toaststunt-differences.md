# ToastStunt Differences

ToastStunt extends Stunt and LambdaMOO with additional server features,
datatypes, builtins, and runtime behavior. Mark code as `toaststunt` when it
depends on these features.

## Common ToastStunt-Specific Features

- ToastStunt datatype constants such as `ANON`, `BOOL`, `WAIF`, and `MAP`.
- Native maps using square brackets.
- Boolean type support.
- WAIF improvements and WAIF property/index syntax.
- SQLite, PCRE, curl, spellcheck, JSON, crypto, and threading-related builtins.
- Sub-second `fork` and `suspend`.
- Additional task inspection and runtime diagnostics.
- Additional arguments to several builtins compared with older LambdaMOO.

## Portability Guidance

- Prefer portable examples unless the lesson is specifically about ToastStunt.
- Label map examples as ToastStunt/Stunt unless a target LambdaMOO fork supports
  maps.
- Label examples by the implementation they actually show. A call to
  `$object_utils:isa()` may be portable core code, but an implementation that
  calls ToastStunt's `isa()` builtin is ToastStunt-specific. The same applies to
  helpers such as `$list_utils:slice` versus ToastStunt's `slice()` builtin or
  `$list_utils:sort` versus ToastStunt's `sort()` builtin. ToastStunt builtins
  are implemented in the server and can be substantially faster than equivalent
  in-MOO utility verbs, but that speed comes with a dialect dependency.
- Avoid assuming ToastStunt-only builtins exist in LambdaMOO.
- When documenting a difference, cite the ToastStunt manual or server docs.
