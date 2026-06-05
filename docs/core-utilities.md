# Core Utilities Versus Server Builtins

LambdaMOO-family databases often provide utility objects such as
`$object_utils`, `$list_utils`, `$string_utils`, `$command_utils`, and
`$recycler`. These are core objects and verbs, not MOO language syntax and not
server builtins. They are common on LambdaCore-derived cores, including many
ToastCore-style cores, but names and signatures can vary by database.

## Long Refs And Short Refs

Public examples should prefer long corified names:

```moo
$object_utils:isa(obj, parent);
$list_utils:slice(items, 2, 4);
$string_utils:trim(text);
$command_utils:suspend_if_needed(0);
```

Some cores provide short aliases such as `$ou`, `$lu`, `$su`, and `$cu`. These
are convenient locally but less portable as public training examples.

## Utility Verbs Are Not Builtins

Calling a utility object verb is a MOO verb call:

```moo
return $list_utils:slice(items, 2, 4);
```

Calling a server builtin is a direct function call:

```moo
return slice(items, 2, 4);
```

The first pattern depends on a core utility object. The second pattern depends
on the server implementing that builtin. ToastStunt provides many fast builtins
that older LambdaMOO servers do not.

## Portability Examples

Portable-style utility calls:

```moo
return $object_utils:isa(obj, parent);
return $list_utils:sort(items);
return $string_utils:trim(text);
```

ToastStunt-specific builtin calls:

```moo
return isa(obj, parent);
return sort(items);
return slice(items, 2, 4);
```

If an example uses ToastStunt builtins, label it `toaststunt` and include a
`dialect_reason`. If an example uses utility objects, label it based on the
target core assumption and explain that utility objects are core conventions.

## `$command_utils`

`$command_utils` is a core utility object. Helpers such as
`$command_utils:suspend_if_needed(0)` are useful in long loops on cores that
provide them, but they are not language syntax and not server builtins.

## `$recycler`

`$recycler` is a LambdaCore-style core convention for recycler-aware object
validity and object reuse. On cores that use soft-recycled garbage objects,
`valid(obj)` can still be true while `$recycler:valid(obj)` is false. Use the
recycler-aware helper when code needs a usable non-garbage object.

ToastStunt also provides server-level recycling/recreate builtins such as
`recreate()`, `recycled_objects()`, and `next_recycled_object()`. Those are
ToastStunt-specific builtins, distinct from a core `$recycler` object.

## Training Guidance

- Prefer long utility refs in public examples.
- Do not describe utility object verbs as language syntax.
- Do not label ToastStunt builtin calls as portable.
- Use `$recycler:valid(obj)` when a LambdaCore-style core's garbage-object
  distinction matters.
- Treat utility-object availability as a core assumption, not a server dialect
  guarantee.
