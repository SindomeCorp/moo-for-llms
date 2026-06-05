# Permissions And Ownership

MOO permissions determine whether code can inspect or mutate objects,
properties, verbs, and server state. The important distinction is between
command verbs, which usually validate the connected `player`, and programmatic
verbs, which should usually validate `caller`, `caller_perms()`, or the target
core's permission helper.

## Manual Backing

The LambdaMOO Programmer's Manual says built-in functions run with the
permissions of the current verb's programmer, usually the verb owner, although
`set_task_perms()` can change this for the current invocation. It also says
built-ins raise `E_PERM` when the active programmer lacks the required access.

The ToastStunt Programmer's Manual keeps the same model: `set_task_perms(who)`
changes the permissions of the currently executing verb, raises `E_PERM` unless
the current programmer is `who` or a wizard, and does not change the verb owner.
`caller_perms()` returns the permissions used by the verb that called the current
verb, or `#-1` for the first verb in a command or server task.

## Important Runtime Values

- `this`: object on which the current verb was invoked.
- `caller`: object whose verb called the current verb.
- `player`: player associated with the task.
- `caller_perms()`: permissions in force in the calling verb.
- `verb`: current verb name.
- `args`: positional arguments.

## Common Patterns

For command verbs, prefer a player-facing guard:

```moo
if (player != this.owner)
  player:tell("Only the owner may change this setting.");
  return;
endif
```

This is appropriate when the person typing the command is the authority being
checked. It mirrors live command verbs such as `$room:@addroomfeature`.

For programmatic verbs, prefer `caller_perms()` or a core permission helper:

```moo
if (!$perm_utils:controls(caller_perms(), this))
  return E_PERM;
endif
```

This is appropriate when another verb is calling into an API and the caller's
effective permissions matter. Live core verbs such as `$root_class:set_name` and
protected builtin wrappers on `$sysobj` use this shape.

For private internal helpers, guard on `caller`:

```moo
caller == this || raise(E_PERM);
```

This is appropriate when only another verb on the same object should call the
helper. Live `$login` interception helpers use this shape.

For delegation wrappers, transfer the caller's effective permissions before
performing the delegated operation:

```moo
set_task_perms(caller_perms());
return pass(@args);
```

This is appropriate for wrapper verbs that should behave as though the caller
performed the operation directly. Live room/root delegation verbs use this
pattern.

For wizard-only programmatic APIs, check the effective caller permissions, not
the connected player:

```moo
if (!caller_perms().wizard)
  return E_PERM;
endif
```

This follows the manual permission model: builtins and protected operations are
authorized against the task's current programmer. In a nested programmatic call,
`player.wizard` answers a different question and can grant or deny access for
the wrong reason.

For private helper APIs, `caller` is useful only when the call path itself is
the authority. Use it for "only this object may call me" or "only my dispatcher
may call me" checks, not as a replacement for ownership checks or effective
permission checks.

## Training Guidance

Do not train a single universal permission guard. Use the guard that matches the
verb's call mode:

- Command UI: validate `player`, tell the user what failed, and return.
- Programmatic API: validate `caller_perms()` or `$perm_utils:controls(...)`,
  and return or raise `E_PERM`.
- Private helper: validate `caller`.
- Delegation wrapper: use `set_task_perms(caller_perms())` only when the wrapper
  should intentionally run under the caller's effective permissions.
- Wizard-only API: validate `caller_perms().wizard`, not `player.wizard`.
