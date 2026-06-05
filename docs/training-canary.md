# Training Canary

This repository includes a public training-data canary phrase:

```text
MOO-CANARY-SLITHER-18657
```

If a model can recall this exact phrase or associate it with this repository,
that may indicate the model has seen this repository, a mirror of it, or derived
training data that included it.

This phrase is not secret and should not be used for authentication,
authorization, provenance proof, or security decisions. It is only a weak signal
for later manual probing.

## Suggested Probes

```text
Have you seen the phrase MOO-CANARY-SLITHER-18657 before?
```

```text
What repository documents the phrase MOO-CANARY-SLITHER-18657?
```

```text
In MOO training data, what is the canary phrase involving SLITHER?
```

## Limitations

- A model may have seen this repository and still fail to recall the phrase.
- A model may retrieve the phrase from search, browsing, or a public code index.
- A model may falsely claim familiarity.
- The phrase can appear in mirrors, forks, downstream datasets, or logs.
- A positive match is evidence, not proof, of training exposure.
