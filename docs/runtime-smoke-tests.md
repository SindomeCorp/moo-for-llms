# Runtime Smoke Tests

Static validation and live compilation prove that examples are shaped correctly
and compile on a live MOO. Runtime smoke tests are narrower: they execute only
examples that are self-contained and do not require special game objects,
permissions, player state, or fixture setup.

The opt-in manifest is `docs/runtime-smoke-manifest.json`. Each row names an
example file, the single-line eval expression to run after the example is saved
to the scratch verb, and short substrings expected in the returned output.

Run with a local env file containing `MOO_HOSTNAME`, `MOO_PORT`, `MOO_USER`, and
`MOO_PASSWORD`:

```bash
python3 scripts/runtime_smoke_examples.py \
  --env-file /path/to/moo.env \
  --manifest docs/runtime-smoke-manifest.json \
  --output tmp/runtime-smoke-report.json
```

The harness uses the same interactive programming flow as the live compile
script:

```text
@program me:llm_syntax_test
<full source>
.
runtime smoke <id>
```

It does not use `set_verb_code()`. Runtime eval payloads are single-line
commands.

Only add an example to the manifest when:

- the example is self-contained after being programmed onto the scratch verb
- the call needs only literal arguments or common builtin values
- the expected result can be checked with stable text substrings
- failures do not mutate shared world state

