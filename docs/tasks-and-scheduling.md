# Tasks And Scheduling

MOO code runs in tasks. A normal player command starts a foreground task. A verb
can create background work with `fork` or suspend itself with builtins such as
`suspend()`.

## Foreground Work

Foreground tasks should finish quickly. Long loops should check remaining ticks
or suspend periodically when the server/core provides appropriate helpers.

```moo
for item in (items)
  this:process(item);
  if (ticks_left() < 1000)
    suspend(0);
  endif
endfor
```

## Forked Work

```moo
fork (5)
  this:expire_cache();
endfork
```

ToastStunt supports sub-second scheduling; portable examples should avoid
depending on that unless marked `toaststunt`.

## Common Mistakes

- Forgetting that forked code runs later.
- Assuming `player` still represents the same active connection.
- Writing loops that can exhaust ticks.
- Swallowing task errors without logging enough context.
