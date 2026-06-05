# Dialect Classification

Use this decision tree when labeling examples, dataset rows, and eval cases.
Label by what the code actually uses, not by what an equivalent implementation
could use in another server or core.

## Decision Tree

1. If the code uses ToastStunt-only datatypes, map syntax, or ToastStunt-only
   builtins, label it `toaststunt`.
2. If the code uses public non-stock patch builtins that are not part of stock
   LambdaMOO or ToastStunt, label it `patch-specific`.
3. If the code uses Sindome-only builtins or core conventions, label it
   `core-specific`.
4. If the code depends on LambdaMOO-only behavior, label it `lambdamoo`.
5. If the code uses common MOO syntax, common LambdaMOO-family builtins, and
   ordinary core utility verbs, label it `portable`.

## Common Distinctions

`{}` is a portable list literal:

```moo
return {};
```

`[]` is a ToastStunt/Stunt map literal:

```moo
return [];
```

Calling a core utility verb can be portable-style if that utility exists in the
target core:

```moo
return $object_utils:isa(obj, parent);
```

This is a core utility call, not a server builtin and not language syntax.

Calling a ToastStunt server builtin is ToastStunt-specific:

```moo
return isa(obj, parent);
```

The same distinction applies to helpers such as `$list_utils:slice(...)` versus
ToastStunt's `slice(...)` builtin, and `$list_utils:sort(...)` versus
ToastStunt's `sort(...)` builtin.

Patch-specific builtins should not be labeled Sindome-specific just because a
Sindome-derived codebase uses them:

```moo
return xml_parse_document(xml);
```

Sindome-only builtins are core-specific:

```moo
return sql_query(connection, query);
```

Core-specific utility packages should be labeled by the code shown:

```moo
return $spatial:path_to(from, to);
```

This is `core-specific` in this corpus because `$spatial` is a Sindome-specific
pathing utility package. An adapted example that rewrites the same graph-search
idea using only portable lists, loops, recursion, and ordinary helper arguments
can be labeled `portable`, but the provenance should still name the original
core-specific source.

ToastStunt builtins that resemble utility algorithms remain ToastStunt-specific
when called directly:

```moo
return descendants(object);
```

A portable-style traversal can be written in MOO using `children()` and an
explicit frontier. Do not label direct builtin calls as portable just because a
portable implementation of the same idea exists.

When a non-portable dialect is used, include a `dialect_reason` in examples.
