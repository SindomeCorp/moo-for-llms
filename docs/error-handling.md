# Error Handling And Return Conventions

MOO code can handle failure by printing feedback, returning error values,
raising errors, or returning structured data. The right choice depends on how
the verb is called.

## Command Verbs

Command verbs are typed by players. Prefer player-facing feedback and `return`
for ordinary command failures:

```moo
if (!valid(dobj))
  player:tell("You need to choose a valid target.");
  return;
endif
```

Do not raise `E_INVARG` or `E_PERM` for routine command-usage failures unless
the command intentionally wants the task to abort or a caller expects an error.

## Programmatic Verbs

Programmatic verbs are called by other verbs. They should communicate failures
in a way the caller can consume:

```moo
if (!valid(target))
  return E_INVARG;
elseif (!$perm_utils:controls(caller_perms(), target))
  return E_PERM;
endif
```

Use `return E_*` when callers commonly branch on error values. Use
`raise(E_*)` when failure should abort the operation unless explicitly caught.
Both are valid conventions, but a verb should be consistent and should document
which convention it uses.

## Specific Inline Catches

Inline error-catching expressions use backtick-apostrophe delimiters:

```moo
value = `toint(text) ! E_INVARG, E_TYPE => 0';
```

Catch the errors that are expected. Avoid `! ANY => ...` unless the example is
intentionally demonstrating a broad catch, because it can hide permission,
range, verb-not-found, and other real failures.

## Try/Except Blocks

Statement-level handling uses `try` / `except` / `endtry`:

```moo
try
  value = object.(prop);
except (E_PROPNF)
  value = fallback;
endtry
```

Avoid broad `except (ANY)` in public examples unless the broad catch is
documented and the handler preserves useful error information.

## Structured Results

For APIs that need to report both success/failure and a useful value, return a
small structured result:

```moo
return {1, value};
return {0, E_INVARG};
```

This is easier for callers to consume than mixing `player:tell`, error values,
and raised errors in one helper.

## Debug Flag Wrappers

Some core wrappers use the verb's debug flag or helper APIs to decide whether
to raise an error or return it. When adapting such code into training examples,
keep the convention explicit:

```moo
return typeof(result) == ERR ? result | 1;
```

or:

```moo
return typeof(result) == ERR && $code_utils:dflag_on() ? raise(result) | result;
```

The second pattern is core-specific because it relies on `$code_utils`.
