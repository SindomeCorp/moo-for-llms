# Near-Family Duplicate Review

The duplicate report currently shows zero exact duplicate clusters and six
near-family clusters. The near-family clusters are intentionally retained for
v1 because they teach related patterns in different topics or generated-family
variants that exports can cap.

## Retained Clusters

- `$code_scanner` matcher examples: retained because each matcher documents a
  different code-quality rule even though the scanning skeleton is similar.
- Command/no-args versus repair/string-comment examples: retained because one
  is command-parser guidance and the other is repair guidance.
- Guidance fragments: retained because each topic needs a small valid MOO
  fragment carrying topic-specific metadata and comments.
- Generated task families: retained but downweightable. The split exporter can
  exclude generated expansions or cap generated families.

## Maintenance Rule

Exact duplicate clusters should stay at zero. Near-family clusters are allowed
only when they serve distinct training purposes or are generated examples that
export tooling can downweight or exclude.
