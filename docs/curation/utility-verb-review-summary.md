# Utility Verb Review Summary

This summary preserves the durable results from the local utility-verb review
scratch export. The raw export artifacts are intentionally kept out of the
tracked corpus because they are bulky local review data, not polished training
targets.

## Export Summary

- Exported candidates: 641
- Useful by heuristic: 615
- Fetch failures: 1
- Portable candidates: 462
- Core-specific candidates: 179

## By Object

| Object | Candidate Count |
| --- | ---: |
| `$string_utils` | 150 |
| `$code_utils` | 90 |
| `$math_utils` | 60 |
| `$list_utils` | 56 |
| `$dispatcher` | 42 |
| `$object_utils` | 41 |
| `$fireworks` | 41 |
| `$command_utils` | 33 |
| `$time_utils` | 32 |
| `$xterm256` | 29 |
| `$reminder_utils` | 19 |
| `$code_scanner` | 17 |
| `$scheduler` | 16 |
| `$holiday_utils` | 10 |
| `$map_utils` | 5 |

## Highest-Value Remaining Areas

- Permissions and effective caller authority.
- Error flow and narrow error catches.
- Object lifecycle and recycler-aware validity.
- Command parser examples with realistic argspecs.
- ToastStunt-specific maps, BOOL values, WAIFs, and builtin classification.

## Curation Rule

Do not add raw exported verbs wholesale. Convert only selected verbs into
sanitized examples, docs, contrastive rows, or eval prompts. Strip VMS/history
notes and preserve source, dialect, and provenance metadata.
