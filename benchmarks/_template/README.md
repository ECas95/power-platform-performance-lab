# B### — Benchmark title

## Question

State one specific performance question.

## Hypothesis

Describe the expected outcome before running the experiment.

## Patterns compared

### Pattern A

```powerfx
// Formula or pseudo-formula
```

### Pattern B

```powerfx
// Formula or pseudo-formula
```

## Environment

| Variable | Value |
|---|---|
| Test date | |
| Client | |
| Region | |
| Data source | |
| Dataset size | |
| App type | Canvas App |
| Network notes | |

Do not record tenant names, credentials, customer names, or other sensitive identifiers.

## Test procedure

1. Prepare the same dataset for every pattern.
2. Perform any documented warm-up runs.
3. Execute each pattern the same number of times.
4. Capture the selected metrics.
5. Store raw measurements in `results/`.
6. Calculate summary statistics only after preserving raw data.

## Metrics

At minimum consider:

- end-to-end elapsed time;
- connector or network requests where observable;
- records read/written;
- errors or throttling;
- perceived UI blocking where relevant.

## Results

| Run | Pattern | Duration ms | Requests | Records | Notes |
|---:|---|---:|---:|---:|---|

## Interpretation

State only conclusions supported by the measurements.

## Limitations

Document variables that were not controlled or that constrain generalization.

## Reproduction

List the exact steps required for another contributor to repeat the test.
