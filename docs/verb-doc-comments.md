# Verb Doc Comments

Programmatically called verbs should start with two MOO string-literal comments:
a signature line and a usage line. These comments are executable string
statements, so they must be quoted and end with semicolons.

## Signature Line

The first comment documents the verb name, argument types, optional arguments,
and return type:

```moo
":verb_name(STR name, INT agent, LIST skills, MAP traits, BOOL status) => INT";
```

Use `=> TYPE` for the return value. Use `=> MIXED` when the verb may return
different kinds of values, such as an integer on success and a string error
message on failure.

Optional arguments are marked with `?` before the type:

```moo
":filter_types(LIST types, ?STR filter) => LIST";
```

This means the first argument is required and the second argument is optional.
The verb body should still provide a default when destructuring:

```moo
{types, ?filter = ""} = args;
```

## Usage Line

The second comment explains who calls the verb and what the return values mean:

```moo
"Called by @stats to generate the status page for the player. Returns 0 for failure, 1 for success.";
```

Prefer concrete caller/context information over vague descriptions. Good usage
comments answer:

- Is this called by a command verb, another utility verb, a task, or an external
  integration?
- What does it return on success?
- What does it return on failure?
- Are there important side effects?

## Example

```moo
":format_status(OBJ who, LIST stats, ?STR filter) => STR";
"Called by status display verbs to build one line of status text for `who`.";
{who, stats, ?filter = ""} = args;
return tostr(who.name, ": ", $string_utils:from_list(stats, ", "));
```
