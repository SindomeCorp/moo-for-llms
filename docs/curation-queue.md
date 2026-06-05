# Curation Queue

This repo should track pulled live verbs separately from final curated examples.
The queue lets reviewers see what was inspected, what was added, what was
skipped, and why.

Machine-readable queue rows live in `tmp/pulled-verbs/index.jsonl`.

## Row Fields

- `id`: stable row id for the pulled verb or original contrast example
- `object`: corified source object when available
- `verb`: source verb name or generated helper name
- `tags`: concept tags used for sampling and gap analysis
- `portability`: reviewer classification of the source/adaptation
- `decision`: curation result
- `example_paths`: examples produced from the source
- `notes`: concise review rationale

## Decisions

- `added`: adapted into one or more examples
- `added-original-contrast`: original example added to clarify a reviewed
  pattern or contrast with live code
- `documented-not-added`: reviewed and documented but not worth a standalone
  example yet
- `duplicate-skipped`: skipped because an equal or better example already
  exists
- `reviewed-supporting-source`: used to validate a pattern but not represented
  as a separate row in the corpus

## Current Queue Focus

The first queue batch records the algorithm and spatial pathing review:

- `$dynamic_room:find_if_near` and `$elevator:find_if_near` are recursive
  depth-first/backtracking searches with exhausted-node tracking.
- `$room:best_waypoint_path` is also depth-first and prunes branches when the
  current path is already worse than the best known path.
- `$spatial:path_to` is core-specific orchestration, not portable MOO language:
  it combines cache lookup, direct near search, waypoint routing, last-mile
  routing, and cleanup.
- The BFS example is original contrast data because the reviewed live pathing
  code did not implement a FIFO frontier search.

## Next Queue Targets

For the next cycles, prefer verbs that fill one of these gaps:

- scheduler queue algorithms and recurrence validation
- dispatcher selection and filtering
- cache invalidation, pruning, and refresh helpers
- pagination and output windowing
- histogram/frequency builders, both portable alist and ToastStunt MAP forms
- syntax-heavy examples that exercise less common MOO forms
