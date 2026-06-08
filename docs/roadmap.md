# Roadmap

This repo is v1.2-complete as a public seed corpus. Future work should improve
depth, dialect breadth, and runtime confidence without turning the corpus into
an uncurated dump.

## Completed Through v1.2.0

- Added model-output scoring around `scripts/score_eval_outputs.py`, including
  structured checks, forbidden-pattern checks, static MOO hygiene checks, grouped
  reports, partial-batch scoring, and optional live compile checks.
- Added ready-made package exports for repo-native splits, OpenAI-style chat,
  Anthropic-style messages, prompt/completion rows, and eval prompt bundles.
- Added structured release manifests and `make release-artifacts`.
- Kept exact duplicate clusters at zero.
- Kept eval rows held out from normal training exports.

## Next Priorities

- Add 25 to 50 more examples in underrepresented but high-value areas:
  permissions, object lifecycle, verbs, strings/lists, and ToastStunt-specific
  APIs.
- Convert selected utility-verb review candidates into examples only when they
  teach a new pattern not already represented.
- Add optional runtime smoke tests for examples that can run without special
  game objects or permissions.
- Expand dialect classification around Stunt versus ToastStunt versus patched
  LambdaMOO servers.
- Add a small grammar/parser integration once a maintained MOO grammar is
  available.

## Constraints

- Do not add raw source dumps.
- Preserve source, license, dialect, and provenance metadata.
- Strip VMS/history notes from adapted examples.
- Keep MOO string-literal comments quoted and semicolon-terminated.
