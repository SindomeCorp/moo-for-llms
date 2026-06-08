# Algorithm Patterns

This page catalogs MOO algorithms that are worth documenting and sampling for
LLM training. The goal is not to teach cleverness; it is to teach idiomatic MOO
solutions for common data-shaping, scanning, parsing, and runtime problems.

When adding algorithm examples, label the dialect based on the code actually
used. A MOO implementation of a sort, search, or grouping algorithm can be
portable even if it mirrors a ToastStunt builtin. Calling ToastStunt builtins
such as `sort()` or using ToastStunt-only maps makes the example ToastStunt
specific.

## High-Value Patterns

| Pattern | Existing Examples | Source Anchors | Portability Notes |
| --- | --- | --- | --- |
| Linear search and first match | `examples/loops/break-on-first-match.moo`, `examples/lists/assoc-index-adapted.moo` | utility assoc/find helpers | Portable when implemented with lists and ordinary loop syntax. |
| Binary search insertion | `examples/loops/binary-search-insert-adapted.moo`, `examples/utility-packages/list-utils-iassoc-sorted-adapted.moo` | `$list_utils:find_insert`, `$string_utils:common` | Portable as MOO code; do not replace with ToastStunt-only shortcuts in portable examples. |
| Count by repeated membership slicing | `examples/loops/count-membership-adapted.moo` | `$list_utils:count` | Portable; useful for teaching membership position plus list slicing. |
| Remove or replace all matches with splice assignment | `examples/lists/remove-all-values-adapted.moo`, `examples/loops/replace-all-splice-adapted.moo` | `$list_utils:setremove_all`, `$list_utils:setreplace_all` | Portable; highlights the difference between scalar replacement and splicing a list replacement. |
| Repeated-list construction by doubling | `examples/loops/make-list-doubling-adapted.moo` | `$list_utils:make` | Portable; useful for algorithms that avoid simple append-in-a-loop growth. |
| Group rows by a column without maps | `examples/utility-packages/list-utils-group-by-column-adapted.moo` | list utility grouping helpers | Portable when represented as `{key, rows}` pairs. A map version should be labeled ToastStunt specific. |
| Deduplicate while preserving order | `examples/lists/remove-duplicates.moo`, `examples/utility-packages/list-utils-remove-duplicates-adapted.moo` | list utility duplicate-removal helpers | Portable; teach set-like behavior with lists. |
| Random permutation | `examples/utility-packages/list-utils-randomly-permute-adapted.moo` | `$list_utils:randomly_permute` | Portable if it only uses `random()` and list operations. |
| Recursive nested-list traversal | `examples/utility-packages/list-utils-recursive-length-adapted.moo` | recursive list utility helpers | Portable; examples should mention task/yield risk for large structures. |
| Ancestor and inheritance walks | `examples/utility-packages/object-utils-ancestors-adapted.moo`, `examples/verbs/match-inherited-verb-adapted.moo`, `examples/objects/has-callable-verb-adapted.moo` | `$object_utils` and verb-inspection helpers | Portable language, but behavior depends on the core object model and available utility verbs. |
| Verb/property scanning with filters | `examples/loops/nested-continue-command-adapted.moo`, `examples/utility-packages/code-utils-get-verbs-json-adapted.moo`, `examples/utility-packages/object-utils-all-properties-adapted.moo` | `$root_class:examine_verbs`, `$code_utils`, `$object_utils` | Portable if it uses stock builtins; output conventions are core-specific. |
| String scanning and replacement | `examples/utility-packages/string-utils-index-all-adapted.moo`, `examples/algorithm-patterns/string-parallel-substitute-adapted.moo`, `examples/strings/split-key-value.moo` | `$string_utils` | Portable unless ANSI, xterm, PCRE, or patch-specific helpers are used. |
| Text wrapping and column formatting | `examples/utility-packages/string-utils-side-by-side-adapted.moo`, `examples/utility-packages/ansi-aware-wrap-adapted.moo` | `$string_utils:wrap`, `$string_utils:columnize` style helpers | Plain string formatting can be portable; ANSI-aware display helpers are often core-specific. |
| Parser-style decomposition | `examples/utility-packages/code-utils-parse-argspec-adapted.moo`, `examples/utility-packages/code-utils-parse-verbref-adapted.moo`, `examples/command-parser/` | command and string utility parsers | Portable when implemented in MOO; command-parser behavior still depends on argspec setup. |
| Queued-task scans | `examples/utility-packages/code-utils-is-verb-queued-adapted.moo`, `examples/utility-packages/command-utils-task-info-adapted.moo` | `$code_utils`, `$command_utils` task helpers | Usually core-specific because task display and helper APIs vary. |
| Map flattening and map validation | `examples/toaststunt/`, map utility examples if curated later | `$map_utils` style helpers | ToastStunt specific if maps or map builtins are used; Sindome map utilities are core-specific unless generalized. |
| Spatial path search | `examples/algorithm-patterns/spatial-depth-first-near-path-adapted.moo`, `examples/algorithm-patterns/spatial-breadth-first-frontier.moo` | `$dynamic_room:find_if_near`, `$elevator:find_if_near`, `$room:best_waypoint_path`, `$spatial:path_to` | The live Sindome pathing verbs are core-specific, but the extracted graph algorithms can be portable when represented as list/alist graphs. |

## Gaps To Fill

These are useful next targets when pulling fresh utility verbs:

- Merge sort over alists, especially `$list_utils:sort_alist`.
- Suspended or yielding variants of long-running sort and scan algorithms.
- Prefix/common-substring search patterns from string utilities.
- Histogram or frequency-table builders, both list-based portable versions and
  ToastStunt map-based versions.
- Pagination and windowing helpers for command output.
- Tree or graph traversals if clean examples exist in utility packages.
- Cache lookup and invalidation helpers, clearly marked core-specific or
  ToastStunt specific when they use maps, waifs, or server-specific builtins.

## Pulled Example Batch

The `examples/algorithm-patterns/` directory now includes a pulled batch of
valid, live-compiled examples adapted from Sindome utility verbs with
permission. These examples strip VMS notes and keep the algorithmic core rather
than copying gameplay, cache, or presentation policy wholesale.

| Example | Source Anchor | What It Teaches |
| --- | --- | --- |
| `list-bounded-recursive-reverse-adapted.moo` | `$list_utils:_reverse` | Divide-and-conquer recursion for large lists, plus front insertion for small lists. |
| `list-compress-runs-adapted.moo` | `$list_utils:compress` | Removing consecutive duplicate runs without removing later repeated values. |
| `list-insertion-sort-permutation-adapted.moo` | `$list_utils:sort` | Insertion sort over keys while applying the same permutation to values. |
| `list-suspended-insertion-sort-adapted.moo` | `$list_utils:sort_suspended` | Yielding during long insertion-sort scans. |
| `list-merge-sort-alist-adapted.moo` | `$list_utils:sort_alist` | Recursive merge sort over list rows by selected column. |
| `list-quicksort-property-adapted.moo` | `$list_utils:sort_by_property` | Quicksort partitioning by dynamic object property value. |
| `list-recursive-flatten-adapted.moo` | `$list_utils:flatten` | Recursive nested-list traversal. |
| `list-suspended-flatten-adapted.moo` | `$list_utils:flatten_suspended` | Recursive nested-list traversal with periodic yielding. |
| `list-extreme-by-length-adapted.moo` | `$list_utils:longest`, `$list_utils:shortest` | Selecting an extreme value by computed length with validation. |
| `list-stack-ops-adapted.moo` | `$list_utils:push`, `$list_utils:pop` | Stack behavior represented with plain list append and tail removal. |
| `list-queue-ops-adapted.moo` | `$list_utils:unshift`, `$list_utils:shift` | Queue/frontier behavior represented with front insertion and removal. |
| `string-columnize-adapted.moo` | `$string_utils:columnize` | Multi-column row layout from a one-column list. |
| `string-prefix-match-adapted.moo` | `$string_utils:find_prefix` | Prefix resolution with ambiguous-match and list-of-matches modes. |
| `string-index-delimited-adapted.moo` | `$string_utils:index_delimited` | Token-boundary matching with regular-expression match metadata. |
| `string-parallel-substitute-adapted.moo` | `$string_utils:substitute` | Parallel substitution with leftmost and longer-match precedence. |
| `string-explode-preserve-empty-adapted.moo` | `$string_utils:explode_all` | Splitting strings while preserving empty fields. |
| `string-sentence-segmenter-adapted.moo` | `$string_utils:sentences` | Word accumulation into punctuation-terminated sentences. |
| `string-progress-bar-adapted.moo` | `$string_utils:progress_bar` | Proportional gauge calculation and fixed-width rendering. |
| `object-descendants-breadth-first-adapted.moo` | `$object_utils:descendants` | Portable breadth-first descendant traversal using `children()`. |
| `object-leaves-splice-frontier-adapted.moo` | `$object_utils:leaves` | Frontier replacement until only leaf objects remain. |
| `object-branches-splice-frontier-adapted.moo` | `$object_utils:branches` | Removing leaves while keeping internal branch objects. |
| `object-descendants-with-property-adapted.moo` | `$object_utils:descendants_with_property_suspended` | Recursive object-tree filtering by property definition. |
| `math-factorial-iterative-adapted.moo` | `$math_utils:factorial` | Iterative multiplication with non-negative integer validation. |
| `math-fibonacci-sequence-adapted.moo` | `$math_utils:fibonacci` | Iterative sequence generation using previous list values. |
| `math-gcd-euclidean-adapted.moo` | `$math_utils:gcd` | Euclidean algorithm with explicit remainder loop state. |
| `math-base-conversion-adapted.moo` | `$math_utils:base_conversion` | Base conversion through an integer accumulator and repeated remainders. |
| `spatial-depth-first-near-path-adapted.moo` | `$dynamic_room:find_if_near`, `$elevator:find_if_near` | Recursive DFS/backtracking with exhausted-node tracking, depth cap, and shortest-path replacement. |
| `spatial-depth-first-waypoint-pruning-adapted.moo` | `$room:best_waypoint_path` | DFS waypoint search with branch pruning when the current path is already worse than the best path. |
| `spatial-breadth-first-frontier.moo` | original contrast example after reviewing `$spatial:path_to` and `:find_if_near` | FIFO frontier BFS for shortest unweighted paths. |
| `spatial-validate-cached-path-adapted.moo` | `$spatial:validate_cached_path` | Recursive validation of a cached route against current graph edges. |
| `spatial-remove-opposite-steps-adapted.moo` | `$spatial:remove_path_redundancies` | Repeated cleanup of adjacent opposite-direction path steps. |
| `spatial-neighbor-coordinate-scan-adapted.moo` | `$spatial:return_spatical_neighbors` | Coordinate-neighbor generation around a 3D point. |
| `scheduler-next-runtime-adapted.moo` | `$scheduler:next_runtime` | Calculating next runtime for fixed, daily-time, ranged-random, and callback repeat specs. |
| `scheduler-repeat-spec-validation-adapted.moo` | `$scheduler:check_repeat_args` | Validating repeat-spec shapes before accepting scheduled work. |
| `scheduler-duplicate-guard-adapted.moo` | `$scheduler:schedule_every` | Rejecting duplicate object/verb scheduled work and selecting active versus incoming queues. |
| `scheduler-remove-from-queues-adapted.moo` | `$scheduler:remove_scheduled` | Removing matching entries from both active and incoming task queues. |
| `dispatcher-filter-candidates-adapted.moo` | `$dispatcher:available_allies` | Filtering candidate rows by self, location, busy state, path availability, and limit. |
| `dispatcher-select-shortest-paths-adapted.moo` | `$dispatcher:dispatch_allies` | Repeatedly selecting candidates with the shortest available path. |
| `dispatcher-temporary-gate-adapted.moo` | `$dispatcher:passes_faction_aide_gate`, `$dispatcher:add_faction_aide_gate` | Temporary duplicate-suppression gates keyed by group and location. |
| `dispatcher-prune-expired-gates-adapted.moo` | `$dispatcher:_auto_prune` | Pruning expired timestamped gate rows. |

The object-descendants example intentionally uses the older MOO-code traversal
instead of the ToastStunt `descendants()` builtin. This is the distinction we
want models to learn: the portable algorithm and the faster ToastStunt builtin
solve similar problems but should receive different dialect labels when used
directly.

The spatial examples intentionally separate live core behavior from the
algorithmic shape. In the live system, `$spatial:path_to` orchestrates cache
lookup, direct near-path search, waypoint routing, last-mile routing, and path
cleanup. The recursive `:find_if_near`, `:find_waypoint`, and
`:best_waypoint_path` verbs are depth-first searches with pruning and visited
sets; they are not breadth-first searches. The BFS example in this repository is
therefore marked `original` and exists as a contrastive algorithm pattern.

## Review Rules

Prefer examples that demonstrate one algorithm clearly. If a live verb mixes an
algorithm with presentation, permission checks, or Sindome-specific policy,
adapt only the algorithmic core and describe what was removed.

Do not train portable examples to call ToastStunt-only builtins as replacements
for LambdaCore utility verbs. It is useful to document that `sort()` may be a
fast ToastStunt builtin while `$list_utils:sort` or `$list_utils:sort_alist`
may be ordinary MOO code on LambdaCore-derived cores, but keep those dialect
labels explicit.
