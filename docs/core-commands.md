# Common Core Commands

MOO language syntax, server commands, and core verbs are different things. LLM
training examples should not describe all of them as language constructs.

## Server-Level Programming Command

`.program` is a server-level verb programming command. It is part of the
LambdaMOO-family server programming interface, not a MOO expression or
statement. The ToastStunt Programmer's Manual documents `.program` as the
command that begins verb programming: after the command is entered, subsequent
input lines are treated as the MOO program until a line containing only `.` is
received.

Access to `.program` is restricted. In common server behavior, the saved program
is rejected if the player is not a programmer, lacks write permission on the
target verb, or the relevant server protection options block the write.

## Common LambdaCore-Style Verbs

Most LambdaCore-derived cores provide MOO verbs that make programming easier for
programmers. ToastCore is also LambdaCore-derived, so many of these command
verbs exist there too. These are core behavior, not language syntax:

- `@program <object>:<verb>`: common programmer-facing wrapper for programming
  a verb.
- `@list <object>:<verb>`: common command for listing verb source.
- `@verb <object>:<names> <dobj> <prep> <iobj>`: common command for adding a
  verb with parser argspecs.
- `@args <object>:<verb> <dobj> <prep> <iobj>`: common command for changing a
  verb's parser argspec.
- `@prop <object>.<property> <value>`: common command for adding or setting a
  property.
- `@chmod` / `@chown`: common commands for changing permissions or ownership,
  where provided by the core.

Because these are MOO verbs supplied by a database core, not server syntax, they
vary by core. Public examples can mention them as common LambdaCore-style
commands, but should avoid promising that every MOO has identical command names,
arguments, or permission checks.

## Training Guidance

- Use MOO code examples for language behavior.
- Use `.program` only when describing the server programming flow.
- Use `@program`, `@list`, `@verb`, and similar commands only as common
  LambdaCore-style core commands.
- Do not use `set_verb_code(...)` as the normal editing workflow in examples.
  Use it only in examples explicitly about verb mutation APIs.
