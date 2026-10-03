# Synthetic benchmark data

Do not commit production or customer datasets to this repository.

Generate deterministic CSV data with:

```bash
python tools/generate_synthetic_data.py --rows 10000 --seed 42 --output data/generated/benchmark-10000.csv
```

Generated CSV files under `data/generated/` should remain local unless a small fixture is intentionally reviewed and committed.

Use the same seed and row count when reproducing a benchmark.
