# What Good MOO Code Looks Like

This checklist is adapted from live `$code_scanner` rules used during
programming on the MOO. The scanner is intentionally simple: it looks for
patterns that often indicate confusing, risky, or hard-to-maintain code. These
are lint-style warnings, not absolute language rules.

## Document Programmatic Verbs

For internal/programmatic verbs using the common `this none this` argspec,
start with a signature comment and a short usage comment:

```moo
":set_status(STR status) => INT|ERR";
"Called by setup helpers to update this.status; returns E_PERM if unauthorized.";
```

This makes the verb easier to call correctly and gives training data a clear
contract.

## Use Argument Scatter In The Right Context

`{a, b, ?c = 0} = args;` is appropriate for programmatic helper verbs where
callers pass positional arguments. Player-facing command verbs usually rely on
parser variables such as `dobj`, `dobjstr`, `prepstr`, `iobj`, `iobjstr`,
`argstr`, and sometimes parser-populated `args`.

Do not destructure command `args` unless the argspec and command behavior really
call for it.

## Prefer Corified References

Avoid raw object numbers in code. Prefer corified refs such as `$thing`,
`$player`, `$object_utils`, or a passed-in object argument.

Raw object numbers are brittle across databases and make training examples less
portable.

## Let `:tell` Convert Arguments

On common LambdaMOO-family cores, including ToastStunt-based cores, `:tell`
often applies `tostr` to its arguments. Prefer:

```moo
player:tell("Count: ", count);
```

over:

```moo
player:tell(tostr("Count: ", count));
```

Check the target core when writing highly portable code.

## Watch Assignment In Conditions

An assignment inside an `if` condition is easy to confuse with equality:

```moo
if (target = this.location)
```

Usually this should be:

```moo
if (target == this.location)
```

If assignment in a condition is intentional, keep it obvious and consider a
separate assignment before the condition.

## Treat `.location =` In Conditions As Suspicious

The scanner rule for `.location =` is specifically about catching assignment
inside conditions:

```moo
if (thing.location = room)
```

This usually meant:

```moo
if (thing.location == room)
```

This warning is mostly an assignment-versus-comparison check. For actual
movement, use the lifecycle guidance around `move(thing, room)`.

## Be Careful With Positive `$recycler:valid(...)`

`$recycler` is a LambdaCore-style core object used by many cores, including
ToastCore, to soft recycle objects into reusable garbage objects. It is not a
server builtin. On those cores, `valid(obj)` can be true even when `obj` is a
garbage object, while `$recycler:valid(obj)` can reject recycled garbage.

The scanner warns on:

```moo
if ($recycler:valid(obj))
```

because many guard clauses want the negative form:

```moo
if (!$recycler:valid(obj))
  return E_INVARG;
endif
```

Positive validity checks can be correct, but they are worth reviewing.

## Keep Nesting Shallow

The live scanner warns when combined `if`, `for`, and `while` nesting exceeds
two levels. Deep nesting makes MOO verbs hard to read and harder to safely
modify. Prefer early returns or extract a helper verb.

## Keep Verbs Focused

The live scanner warns when a verb exceeds roughly forty lines. This is a
heuristic, not a hard rule, but long verbs often hide multiple responsibilities.
Extract parsing, validation, formatting, or mutation into helpers.

## Treat Forks As Risky

The scanner warns whenever it sees `fork`. Forked tasks run later and can outlive
the assumptions present when the command started. Capture needed values before
forking, validate objects inside the fork, and consider a scheduler utility when
available.

## Scanner-Derived Rule List

- Programmatic verbs should start with top comments explaining signature and use.
- Do not use argument scatter casually in player-facing command verbs.
- Avoid raw object numbers; prefer corified refs.
- Avoid redundant `tostr(...)` inside `:tell(...)`.
- Review assignment inside `if (...)` conditions.
- Review `.location = ...` inside conditions; it likely meant `==`.
- Review positive `$recycler:valid(...)` checks.
- Keep nesting shallow, ideally two levels or less.
- Keep verbs focused; refactor long verbs.
- Treat `fork` as a deliberate task/scheduling choice.
