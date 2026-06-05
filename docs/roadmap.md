# Roadmap

This repo is v1-complete as a public seed corpus. Future work should improve
depth and scoring quality without turning the corpus into an uncurated dump.

## v1.1 Priorities

- Add a model-output scoring workflow around `scripts/score_eval_outputs.py`.
- Add 25 to 50 more examples in underrepresented but high-value areas:
  permissions, object lifecycle, verbs, strings/lists, and ToastStunt-specific
  APIs.
- Convert selected utility-verb review candidates into examples only when they
  teach a new pattern not already represented.
- Keep exact duplicate clusters at zero.
- Keep eval rows held out from normal training exports.

## v1.2 Priorities

- Add structured live compile manifests per release.
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
