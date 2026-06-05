# Command Parser

MOO has two related calling styles:

- Direct verb calls: `object:verb(args)`.
- Player command parsing: text input matched against command verbs.

Command verbs use direct object, preposition, and indirect object slots. Runtime
variables commonly include `dobj`, `dobjstr`, `prepstr`, `iobj`, `iobjstr`, and
`argstr`.

## Argspec Shape

Command verb argspecs have three slots:

```text
direct-object preposition indirect-object
```

For the direct-object and indirect-object slots, the common values are:

- `none`: no object in that slot.
- `any`: match any object or text phrase accepted by the parser.
- `this`: match the object defining the command verb.

For the middle preposition slot, use `none`, `any`, or a concrete preposition
such as `in`, `on`, `at`, or `with`.

`none none none` means the command takes no direct object, no preposition, and
no indirect object. Do not expect command text to populate `args` with this
setup.

```moo
" setup: @verb object:ping none none none";
player:tell("Pong.");
```

`any none none` is appropriate when the command expects one direct-object phrase
and no preposition or indirect object. This is useful for object commands like
`push crate`, where the parser should match `crate` as `dobj`.

```moo
" setup: @verb object:push any none none";
if (valid(dobj))
  player:tell("You push " + dobj.name + ".");
endif
```

`any any any` is better for free-form multi-word text, especially when the input
may contain words that the parser recognizes as prepositions. If the preposition
slot is `none`, a word parsed as a preposition can prevent the command from
matching.

```moo
" setup: @verb object:tag any any any";
for word in (args)
  player:tell("Tag: " + word);
endfor
```

Use a concrete preposition when the command grammar requires it:

```moo
" setup: @verb object:put any in any";
player:tell("You put " + dobjstr + " in " + iobjstr + ".");
```

For related forms like `look at John` and `look directly at John`, define both
shapes and treat the direct object text as a modifier:

```moo
" setup: @verb object:look none at any; @verb object:look any at any";
if (!valid(iobj))
  player:tell("Look at what?");
  return;
endif
modifier = dobjstr ? dobjstr + " " | "";
player:tell("You look ", modifier, "at ", iobj.name, ".");
```

## Example

```moo
" setup: @verb object:push any none none";
player:tell("You push " + dobjstr + ".");
```

## LLM Guidance

- Do not invent parser variables outside the LambdaMOO-family conventions.
- Distinguish command verbs from ordinary API-like verb calls.
- When generating command verbs, include expected argument spec in comments or
  surrounding text.
- Use `argstr` for the raw text after the command.
- Use `args` for parser-split words from `argstr`.
- Use `dobj`/`dobjstr`, `prepstr`, and `iobj`/`iobjstr` for command verbs with
  direct objects, prepositions, and indirect objects.
- Check `valid(dobj)` or `valid(iobj)` before using matched object values.
