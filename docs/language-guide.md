# MOO Language Guide

MOO is an object-oriented programming language embedded in LambdaMOO-family
servers. Programs are stored as verbs on objects and run as tasks.

## Values

Common portable value types include integers, floats, strings, object numbers,
errors, lists, and booleans where supported by the server/core. ToastStunt also
supports maps and additional server-side types and builtins.

```moo
count = 3;
name = "clock";
owner = player;
items = {"north", "south"};
```

ToastStunt/Stunt maps use square brackets:

```moo
counts = ["north" -> 2, "south" -> 1];
```

## Objects, Properties, And Verbs

Objects contain properties and verbs. A verb call has the form:

```moo
result = object:verb_name(arg1, arg2);
```

Inside a verb, common runtime variables include `this`, `player`, `caller`,
`args`, `argstr`, `verb`, `dobj`, `prepstr`, and `iobj`.

## Control Flow

```moo
if (condition)
  return value;
elseif (other_condition)
  return other_value;
else
  return fallback;
endif
```

```moo
for item in (items)
  player:tell(item);
endfor
```

```moo
while (ticks_left() > 1000)
  work = this:next_piece();
  if (!work)
    break;
  endif
endwhile
```

## Errors

MOO uses error values such as `E_TYPE`, `E_PERM`, `E_VERBNF`, and `E_INVARG`.
Use `try`/`except` when a failure is expected and recoverable.

```moo
try
  value = object.(prop);
except (E_PROPNF)
  value = 0;
endtry
```

## Dialect Notes

Most basic MOO examples work on LambdaMOO and ToastStunt. Mark examples as
ToastStunt-specific when they use maps, WAIF features, threaded builtins,
SQLite, PCRE, or ToastStunt-only builtin signatures.
