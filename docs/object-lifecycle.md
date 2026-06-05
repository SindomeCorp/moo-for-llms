# Object Lifecycle And Mutation

Object lifecycle code changes persistent database state. Generated examples
should be explicit about permissions, object validity, containment side effects,
and whether code is using server builtins or core helper verbs.

## Creating Objects

`create(parent)` creates a new object with the given parent. In LambdaMOO-family
servers, creating under a parent can raise `E_PERM` if the active programmer
does not own the parent, the parent is not fertile, or the active programmer is
not a wizard. It may also raise `E_QUOTA` on cores that enforce ownership quota.

Use corified parent references in public examples:

```moo
child = create($thing);
child.owner = caller_perms();
```

Do not hard-code raw object numbers in generated code.

## Recycling Objects

`recycle(object)` permanently destroys an object. The active programmer must own
the target object or be a wizard. Before recycling, check that the object is
valid and that the caller is allowed to control it:

```moo
if (!valid(target))
  return E_INVARG;
elseif (!$perm_utils:controls(caller_perms(), target))
  return E_PERM;
endif

recycle(target);
return 1;
```

Do not recycle arbitrary `dobj` or `args[1]` values without checking validity
and authority.

## LambdaCore-Style `$recycler`

Many LambdaCore-derived databases provide a `$recycler` object. This is a core
convention, not MOO language syntax and not the same thing as the server's
`recycle()` builtin. The traditional LambdaCore recycler supports soft recycling
by changing discarded objects into garbage objects that can later be reused.
ToastCore and many other LambdaCore-derived cores include this style of
`$recycler`.

On cores with `$recycler`, `valid(object)` and `$recycler:valid(object)` answer
different questions:

- `valid(object)` asks whether the server object number currently exists.
- `$recycler:valid(object)` commonly asks whether the object exists and is not a
  recycled garbage object according to the core's recycler.

That means `valid(object)` can still be true for a garbage object on recycler
based cores. When code needs an object that is usable in the game database, not
merely an existing object number, prefer the target core's recycler-aware helper:

```moo
if (!$recycler:valid(target))
  return E_INVARG;
endif
```

ToastStunt also has better server-level support for recycling and recreating
objects, including builtins such as `recreate()`, `recycled_objects()`, and
`next_recycled_object()`. Those builtins are ToastStunt-specific, while
`$recycler` remains a LambdaCore-style core convention.

## Reparenting

`chparent(object, new_parent)` and `chparents(object, parents)` mutate the
inheritance hierarchy. The active programmer must be allowed to change the
target object and use the new parent. Parent fertility and wizard permissions
matter.

Generated examples should avoid casual reparenting. When it is necessary,
validate both the target and the intended parent, then rely on the builtin to
raise or return permission errors for server-enforced rules.

## Moving Objects

`move(what, where)` changes containment. It requires the active programmer to
own `what` or be a wizard. Movement can trigger `accept`, `enterfunc`, and
`exitfunc` behavior, so it is not just property assignment.

Before moving, validate both objects and avoid obvious containment loops:

```moo
if (!valid(what) || !valid(where))
  return E_INVARG;
elseif ($object_utils:contains(what, where))
  return E_RECMOVE;
endif

move(what, where);
return 1;
```

Do not assign `.location` or `.contents` directly. Use `move(...)`.

## Property Mutation

Inherited properties can have owners and permission bits that differ from the
object owner. The `c` property permission bit affects whether a newly created
child gets its own owner for that inherited property. Do not assume that owning
an object means every inherited property can be set by the same code.

Checking that a property exists is different from checking authority to mutate
it. Mutation can still raise `E_PERM`.

## Verb Mutation

Server builtins such as `add_verb`, `delete_verb`, `set_verb_info`,
`set_verb_args`, and `set_verb_code` mutate verb definitions. They are useful
APIs, but generated code should not edit verbs unless the user explicitly asks
for verb mutation.

For normal interactive editing:

- `.program` is the server-level programming command.
- `@program` is a common LambdaCore-style command verb available to programmers
  on many cores.
- `@list` is a common LambdaCore-style command verb for listing verb source.

These commands are not MOO language constructs; they are server or core
programming interfaces.
