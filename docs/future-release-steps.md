# Release Steps

This repo publishes annotated git tags such as `v1.0.0`, `v1.1.0`, and
`v1.2.0`. GitHub Release pages are published with `gh`.

```text
https://github.com/SindomeCorp/moo-for-llms/releases
```

## Create A Future GitHub Release Page

After committing, pushing, and confirming CI for a future release, create an
annotated tag and publish a release. For example:

```bash
git tag -a v1.3.0 -m "MOO for LLMs v1.3.0"
git push origin v1.3.0
gh release create v1.3.0 \
  --repo SindomeCorp/moo-for-llms \
  --title "MOO for LLMs v1.3.0" \
  --notes-file tmp/release-notes-v1.3.0.md
```

Use release notes shaped like:

```text
Validated public MOO training and evaluation corpus update.

- <N> live-compiled MOO examples
- <N> instruction rows
- <N> contrastive rows
- <N> eval rows
- <N> docs
- training package manifest: tmp/training-package/package-manifest.json
- release manifest: tmp/release-manifest.json
- 0 training-quality warnings
- 0 exact duplicate clusters
- CI validation green
```

## Repeat Full Local Verification

Run:

```bash
make verify
make clean-generated
```

Expected current results:

- current counts from `docs/coverage-report.md`
- `0` training-quality warnings
- `0` exact duplicate clusters

## Build Release Artifacts

Generate ready-made training packages and a structured release manifest:

```bash
make release-artifacts
```

This writes:

- `tmp/training-package/package-manifest.json`
- `tmp/training-package/openai-chat/train.jsonl`
- `tmp/training-package/openai-chat/heldout.jsonl`
- `tmp/training-package/anthropic-messages/train.jsonl`
- `tmp/training-package/anthropic-messages/heldout.jsonl`
- `tmp/training-package/prompt-completion/train.jsonl`
- `tmp/training-package/eval-prompts/*.jsonl`
- `tmp/release-manifest.json`

The package files are generated release artifacts, not tracked source files.
Attach them to the GitHub Release when useful, or regenerate them from the tag.

## Repeat Full Live Compile

Use a local env file containing `MOO_HOSTNAME`, `MOO_PORT`, `MOO_USER`, and
`MOO_PASSWORD`, then run:

```bash
python3 scripts/live_compile_examples.py \
  --env-file /path/to/moo.env \
  --output docs/live-compile-report.json
```

The compile harness uses the interactive save flow:

```text
@program me:llm_syntax_test
<full source>
.
compile check <path>
```

It does not use `set_verb_code()`.

## Check CI

If `gh` is available:

```bash
gh run list --repo SindomeCorp/moo-for-llms --limit 5
```

Without `gh`, query the public GitHub API:

```bash
python3 - <<'PY'
import json, urllib.request
url = "https://api.github.com/repos/SindomeCorp/moo-for-llms/actions/runs?per_page=5"
with urllib.request.urlopen(url, timeout=10) as response:
    data = json.load(response)
for run in data["workflow_runs"]:
    print(run["name"], run["head_sha"], run["status"], run["conclusion"], run["html_url"])
PY
```

## Score Model Outputs Against Evals

Prepare model output rows as JSONL:

```json
{"id":"eval-id","output":"model answer text"}
```

Then run:

```bash
python3 scripts/score_eval_outputs.py model-outputs.jsonl \
  --output tmp/eval-score-report.json
```

The scorer is a triage tool. It checks expected strings and expected-property
phrases, but generated MOO should still be reviewed by a human.

Rows with `checks`, `negative_patterns`, `forbidden_patterns`, `requires_code`,
or `compile_check` get stronger deterministic scoring. To compile rows marked
`compile_check` against a live scratch verb, add:

```bash
python3 scripts/score_eval_outputs.py model-outputs.jsonl \
  --live-compile \
  --env-file /path/to/moo.env \
  --output tmp/eval-score-report.json \
  --markdown-output tmp/eval-score-report.md
```

## Before The Next Release

1. Add new examples only when they teach a pattern not already represented.
2. Run `make verify`.
3. Run the full live compile pass.
4. Update `docs/compile-status.md`.
5. Update `docs/dataset-card.md` and `dataset-card.json` counts.
6. Review `docs/duplicate-example-report.md`.
7. Keep exact duplicate clusters at zero.
8. Commit, push, confirm CI, create an annotated tag, and create a GitHub
   Release page.
