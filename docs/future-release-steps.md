# Future Release Steps

This repo has a pushed `v1.0.0` annotated git tag. The only release step that
was not completed from this environment was creating the GitHub Release page,
because no GitHub CLI or API token was available.

## Create The GitHub Release Page

Use the GitHub web UI:

1. Go to `https://github.com/SindomeCorp/moo-for-llms/releases/new`.
2. Choose tag `v1.0.0`.
3. Set release title to `MOO for LLMs v1.0.0`.
4. Use release notes like:

```text
Initial validated public seed corpus for MOO training and evaluation.

- 418 live-compiled MOO examples
- 78 instruction rows
- 92 contrastive rows
- 336 eval rows
- 37 docs
- 0 training-quality warnings
- 0 exact duplicate clusters
- CI validation green
```

If `gh` is installed and authenticated, this command can create the release:

```bash
gh release create v1.0.0 \
  --repo SindomeCorp/moo-for-llms \
  --title "MOO for LLMs v1.0.0" \
  --notes-file docs/future-release-steps.md
```

## Repeat Full Local Verification

Run:

```bash
make verify
make clean-generated
```

Expected current results:

- `418` examples
- `78` instruction rows
- `92` contrastive rows
- `336` eval rows
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
