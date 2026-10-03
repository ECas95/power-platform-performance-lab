# B### result summary

## Evidence level

L2 / L3 / L4

## Benchmark version

Repository commit:

## Test context

| Variable | Value |
|---|---|
| Test date | YYYY-MM-DD |
| Client | |
| Browser/client version | |
| Data source | |
| Dataset size | |
| Measured runs | |
| Warm-up runs | |
| Region | Optional, non-identifying |
| Relevant settings | |

Do not include tenant names, environment URLs, user identities, subscription IDs, or private resource names.

## Correctness

Describe how functional equivalence was verified.

Expected records/effects:

Actual records/effects:

Invalid/failed runs:

## Summary statistics

Generate from raw observations when possible:

```bash
python tools/summarize_results.py path/to/raw.csv --group-by pattern --metric duration_ms
```

Paste the generated table here.

## Request / runtime observations

Document sanitized request counts, retries, throttling, delegation indicators, or other runtime evidence relevant to the benchmark.

## Interpretation

State only what the measurements support.

## Limitations

List uncontrolled variables and reasons the result may not generalize.

## Reproduction notes

Describe anything another contributor needs to repeat the experiment.
