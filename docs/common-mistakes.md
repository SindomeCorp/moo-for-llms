# Common MOO Mistakes

These are high-value failure modes for language models.

## Lists And Maps

Portable LambdaMOO lists use braces:

```moo
names = {"Ada", "Grace"};
```

ToastStunt/Stunt maps use square brackets:

```moo
scores = ["Ada" -> 10, "Grace" -> 12];
```

Do not confuse empty maps and empty lists. In ToastStunt, `[]` is an empty map;
`{}` is an empty list.

## Empty Containers Are Falsey

Do not use `if (!container)` to mean "uninitialized" when empty lists or maps
are valid values. Prefer explicit type checks.

```moo
if (typeof(cache) != MAP)
  cache = [];
endif
```

## Object Truthiness Is Not Validity

Do not treat an object number as proof that the object still exists.

```moo
if (valid(obj))
  obj:tell("Ready.");
endif
```

On LambdaCore-style cores with `$recycler`, server validity is not always enough
to prove an object is usable. A soft-recycled garbage object can still satisfy
`valid(obj)`. Use `$recycler:valid(obj)` when the target core provides it and
the code needs a non-garbage object:

```moo
if ($recycler:valid(obj))
  obj:tell("Ready.");
endif
```

## Lifecycle Mutations Need Permission And Side-Effect Awareness

`create`, `recycle`, `chparent`, `chparents`, and `move` mutate persistent
object state. They can raise `E_PERM`, `E_INVARG`, `E_QUOTA`, `E_RECMOVE`, or
movement-specific errors depending on the operation and target core.

Do not recycle a value just because it was passed in:

```moo
if (!valid(target))
  return E_INVARG;
elseif (!$perm_utils:controls(caller_perms(), target))
  return E_PERM;
endif
```

Do not assign `.location` or `.contents` directly. Use `move(...)` so server and
core movement behavior can run:

```moo
result = `move(what, where) ! E_PERM, E_NACC, E_RECMOVE, E_INVARG';
```

Do not assume object ownership is the same as property mutation authority.
Inherited properties have their own owners and permission bits, and setting them
can still raise `E_PERM`.

Do not generate verb-editing code with `set_verb_code(...)` unless the user
explicitly asks for a verb mutation API. For normal editing guidance, describe
`.program` as a server-level programming command and `@program` / `@list` as
common LambdaCore-style core commands.

## Optional Args Need Defaults

When destructuring optional args, provide defaults.

```moo
{required, ?limit = 10} = args;
```

Do not leave optional scatter variables without defaults:

```moo
{name, ?count = 1} = args;
```

## Guard Indexed Access

Check list length before indexing. The server-populated `args` variable is
already a list unless your verb has reassigned it, so guard `args` indexing with
`length(args)`. For values passed inside `args` that should be lists, check the
value's type before iterating or indexing into it.

```moo
if (length(args) >= 2)
  value = args[2];
else
  value = 0;
endif
```

## Error Handling Uses MOO Syntax

MOO does not use JavaScript-style `try { ... } catch (...) { ... }` blocks.
Use `try`/`except`/`endtry`:

```moo
try
  value = toint(args[1]);
except (E_INVARG, E_TYPE)
  value = 0;
endtry
```

Inline error-catching expressions use backtick-apostrophe delimiters:

```moo
value = `toint(args[1]) ! E_INVARG, E_TYPE => 0';
```

## Error Flow Should Match Call Mode

Command verbs should usually tell the player what failed and return:

```moo
if (!valid(dobj))
  player:tell("Choose a valid target.");
  return;
endif
```

Programmatic helpers should usually return an error value, raise an error, or
return a documented structured result. Do not mix command UI feedback into API
helpers unless the helper is intentionally notifying a player.

```moo
if (!valid(target))
  return E_INVARG;
endif
```

Avoid broad catches in public examples:

```moo
value = `toint(text) ! E_INVARG, E_TYPE => 0';
```

Do not use `! ANY => 0` or `except (ANY)` unless the broad catch is documented
and intentional.

```moo
if (length(args) >= 1 && typeof(args[1]) == LIST)
  for item in (args[1])
    player:tell(tostr(item));
  endfor
endif
```

## Permissions Are Part Of Behavior

Generated code should consider who owns the verb, whether it has programmer
permissions, and whether the target operation can raise `E_PERM`.

Permission checks should match the verb's call mode:

```text
command typed by a player       -> check player and give player:tell feedback
programmatic API/helper         -> check caller_perms() or $perm_utils:controls(...)
private same-object helper      -> check caller
delegation wrapper              -> set_task_perms(caller_perms()) intentionally
```

Do not use `player` as the authority check for programmatic helpers. `player` is
the player associated with the task, not necessarily the permissions used by the
verb that called the helper.

```moo
if (!$perm_utils:controls(caller_perms(), this))
  return E_PERM;
endif
```

Do not use `caller` when you actually need the caller's effective permissions.
`caller` tells you which object called the current verb; `caller_perms()` tells
you whose permissions that caller was running under.

Do not put `set_task_perms(caller_perms())` at the top of every helper. Use it
only when the helper is deliberately delegating authority so the operation
should run as though the caller performed it directly.

## Comments Are String Literals

Portable MOO comments are usually string-literal statements. They must be quoted
strings and must end with semicolons:

```moo
" This comment remains in stored verb code.";
```

Do not use JavaScript-style `//` comments or C-style `/* ... */` block comments
for public MOO examples. ToastStunt may accept some non-MOO comment syntax in
source input, but those comments are not parsed as MOO statements and are
dropped from stored verb code. A string literal without a trailing semicolon is
also not a complete MOO statement.

## Capture Player Before Forking

Forked tasks run later. If the task needs to notify the player who started it,
capture `player` before the `fork` and check the captured object is still valid
inside the task:

```moo
who = player;
fork (delay)
  if (valid(who))
    who:tell(message);
  endif
endfork
```

## Prefer Multi-Argument Tell When Available

Many common LambdaMOO-family cores implement `:tell` so that it applies `tostr`
to its arguments and joins them for output. ToastStunt cores commonly support
this style:

```moo
player:tell("You look at ", target.name, ".");
```

This is often clearer than manually concatenating strings:

```moo
player:tell("You look at " + target.name + ".");
```

Check the target core's `:tell` implementation when writing highly portable
code. If it only accepts one string argument, wrap the pieces with `tostr(...)`.

## Short Utility Refs Are Core-Specific

Some MOO cores define short corified names such as `$ou`, `$lu`, `$su`, and
`$cu`. Other cores only define the longer names. Public examples should prefer
the longer utility refs:

```moo
$object_utils:has_verb(obj, "look");
$list_utils:assoc(key, rows);
$string_utils:trim(text);
$command_utils:suspend_if_needed(0);
```

When importing code, expand short refs before publishing examples:

```text
$ou -> $object_utils
$lu -> $list_utils
$su -> $string_utils
$cu -> $command_utils
```

## Utility Verbs And Builtins Are Not The Same Portability Signal

LambdaMOO-family cores often provide utility verbs written in MOO code, such as
`$list_utils:slice`, `$list_utils:sort`, or `$object_utils:isa`. ToastStunt may
also provide faster server builtins with similar names, such as `slice()`,
`sort()`, `isa()`, or `ancestors()`, implemented in the server rather than in
MOO code.

Label examples by what the code actually calls:

```moo
return $object_utils:isa(obj, $thing);
```

This is a core utility call and may be portable-style if that utility object
exists in the target core.

```moo
return isa(obj, $thing);
```

This calls the ToastStunt builtin and should be labeled `toaststunt`.

Utility objects are core conventions, not language syntax. `$command_utils`,
`$string_utils`, `$list_utils`, `$object_utils`, and `$recycler` are common on
LambdaCore-derived cores, but generated code should not imply every MOO database
has the same utility object names or signatures.
