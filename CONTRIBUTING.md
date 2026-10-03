# Contributing

Contributions should improve the quality, reproducibility, or coverage of Power Platform performance experiments.

## Ground rules

- Use only synthetic, public, or otherwise publishable data.
- Never commit tenant secrets, connection strings, access tokens, customer data, proprietary project material, private environment URLs, or user identifiers.
- Separate measured observations from interpretation.
- Do not claim that a result applies universally unless the evidence supports it.
- Prefer small, reproducible experiments over anecdotal examples.
- Do not fabricate benchmark measurements.

## Proposing a benchmark

Open an issue describing:

- the performance question;
- the patterns to compare;
- the expected data source;
- dataset sizes;
- proposed correctness check;
- proposed metrics;
- known variables that may affect the result.

Use [docs/BENCHMARK_AUTHORING.md](docs/BENCHMARK_AUTHORING.md) before adding a new benchmark.

## Adding a benchmark

Create a directory under `benchmarks/` using the next available identifier:

```text
benchmarks/
  B###-short-name/
    README.md
    results/
      raw.csv
      summary.md
```

Start from `benchmarks/_template/`.

## Publishing measured results

Real Power Platform runtime measurements must come from an environment you are authorized to use.

Before opening a pull request:

```bash
python tools/validate_results.py path/to/raw.csv
python tools/privacy_scan.py path/to/raw.csv path/to/summary.md
python tools/summarize_results.py path/to/raw.csv --group-by pattern --metric duration_ms
```

Then complete:

- [Community Validation](community-validation/README.md)
- [Benchmark Result Review Checklist](docs/RESULT_REVIEW_CHECKLIST.md)

## Pull requests

Keep each pull request focused.

Explain:

- what changed;
- why it matters;
- how correctness was validated;
- how the result was measured, when applicable;
- the claimed evidence level;
- known limitations.

Repository CI is intentionally public-only and does not require a private Microsoft tenant.
