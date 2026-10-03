# Result utilities

## Validate result CSV files

```bash
python tools/validate_results.py benchmarks/B001-delegation-vs-local-filtering/results/raw.csv
```

Empty result templates are allowed before a benchmark is executed.

## Summarize results

Example:

```bash
python tools/summarize_results.py path/to/raw.csv --group-by pattern --metric duration_ms
```

The summarizer reports count, mean, median, minimum, maximum, standard deviation, and p95 when at least 20 measurements are available.

These utilities never create synthetic benchmark measurements. Raw observations remain the source of truth.
