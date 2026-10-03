# B003 — Sequential vs concurrent independent calls

## Question

When several data operations are independent, how does executing them concurrently compare with executing them sequentially?

## Status

Planned — methodology defined, measurements not yet published.

## Baseline

```powerfx
ClearCollect(colA, DataSourceA);
ClearCollect(colB, DataSourceB);
ClearCollect(colC, DataSourceC)
```

## Candidate

```powerfx
Concurrent(
    ClearCollect(colA, DataSourceA),
    ClearCollect(colB, DataSourceB),
    ClearCollect(colC, DataSourceC)
)
```

## Preconditions

The operations must be independent. Do not use the concurrent candidate when one call requires the result of another.

## Metrics

- total elapsed time;
- individual request durations where observable;
- request count;
- throttling/retry evidence;
- result equality.

## Test variations

Repeat the experiment with controlled artificial workloads or data volumes so the result is not based on a single connector response profile.

## Results

Use `results/raw.csv`.
