# Tools

Utilities in this directory make experiments repeatable without requiring private infrastructure.

All current utilities use the Python standard library only.

## Synthetic dataset generator

```bash
python tools/generate_synthetic_data.py \
  --rows 10000 \
  --seed 42 \
  --output data/generated/benchmark-10000.csv
```

The same row count and seed produce the same CSV.

## Result validator

```bash
python tools/validate_results.py benchmarks/B001-delegation-vs-local-filtering/results/raw.csv
```

Checks include:

- required `run_number`;
- duplicate run identities;
- ISO test dates;
- non-negative numeric/count fields;
- boolean-like result fields.

Empty result templates are allowed before a benchmark is executed.

## Result summarizer

```bash
python tools/summarize_results.py path/to/raw.csv \
  --group-by pattern \
  --metric duration_ms
```

Reports:

- n;
- mean;
- median;
- minimum;
- maximum;
- standard deviation when applicable;
- p95 when at least 20 observations exist.

It never invents or fills missing measurements.

## Privacy scanner

```bash
python tools/privacy_scan.py path/to/raw.csv path/to/summary.md
```

It flags obvious public-repository risks such as:

- email-like values;
- Power Platform environment URLs;
- bearer/JWT-like tokens;
- secret-like assignments;
- tenant/subscription/environment/client identifiers written as private ID assignments.

This is only a guardrail. Human review is still required.
