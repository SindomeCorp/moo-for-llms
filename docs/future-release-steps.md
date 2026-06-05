# Release Steps

This repo has pushed annotated git tags for `v1.0.0` and `v1.0.1`. The
`v1.0.1` GitHub Release page was created after `gh` was installed and
authenticated:

```text
https://github.com/SindomeCorp/moo-for-llms/releases/tag/v1.0.1
```

## Create A Future GitHub Release Page

After committing, pushing, and confirming CI for a future release, create an
annotated tag and publish a release. For example:

```bash
git tag -a v1.1.0 -m "MOO for LLMs v1.1.0"
git push origin v1.1.0
gh release create v1.1.0 \
  --repo SindomeCorp/moo-for-llms \
  --title "MOO for LLMs v1.1.0" \
  --notes-file tmp/release-notes-v1.1.0.md
```

Use release notes shaped like:

```text
Validated public MOO training and evaluation corpus update.

- <N> live-compiled MOO examples
- <N> instruction rows
- <N> contrastive rows
- <N> eval rows
- <N> docs
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
