# Contributing

Contributions should improve the quality, reproducibility, or coverage of Power Platform performance experiments.

## Ground rules

- Use only data and assets you are allowed to publish.
- Never commit tenant secrets, connection strings, access tokens, customer data, or proprietary project material.
- Separate measured observations from interpretation.
- Do not claim that a result applies universally unless the evidence supports it.
- Prefer small, reproducible experiments over anecdotal examples.

## Proposing a benchmark

Open an issue describing:

- the performance question;
- the patterns to compare;
- the expected data source;
- dataset sizes;
- proposed metrics;
- known variables that may affect the result.

## Adding a benchmark

Create a directory under `benchmarks/` using the next available identifier:

```text
benchmarks/
  B###-short-name/
    README.md
    formulas/
    data/
    results/
```

Use `benchmarks/_template/README.md` as the starting point.

## Results

Do not commit fabricated benchmark results.

When publishing results, include:

- date tested;
- Power Apps / Power Platform context that can be identified;
- browser or client where relevant;
- data source and approximate dataset size;
- number of repetitions;
- metric collection method;
- raw measurements when practical;
- limitations.

## Pull requests

Keep each pull request focused. Explain what changed, why it matters, and how it was validated.
