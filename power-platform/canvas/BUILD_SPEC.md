# Canvas Benchmark Runner — build specification

The app is intentionally generic. It must not contain customer-specific names, environment URLs, production data, or business terminology.

## App identity

Suggested display name:

`Power Platform Performance Lab`

Add the Canvas App to the `PowerPlatformPerformanceLab` solution.

## Data sources

Add:

- `Benchmark Records` — logical table `pppl_benchmarkrecord`
- `Benchmark Runs` — logical table `pppl_benchmarkrun`

Use only synthetic datasets generated for the lab.

## Screens

### scrHome

Purpose: benchmark catalog and environment-neutral entry point.

Controls:

- title
- benchmark gallery
- dataset tag input
- dataset size display
- Run Benchmark button
- Diagnostics button

The screen must not preload all benchmark records.

### scrBenchmarkRunner

Purpose: execute one selected pattern at a time.

Controls:

- benchmark ID
- pattern selector
- warm-up count
- measured-run count
- Execute button
- validation result
- latest duration
- current correlation ID
- result gallery

### scrDiagnostics

Purpose: surface information that helps correlate a run with Live Monitor.

Show:

- benchmark ID
- pattern
- correlation ID
- dataset tag
- expected count
- actual count
- validation passed
- duration
- last error

Do not show tenant IDs, environment URLs, current-user email addresses, connection IDs, or other identifiers in screenshots intended for the repository.

## App startup

Keep startup intentionally small.

Suggested `App.StartScreen`:

```powerfx
scrHome
```

Suggested `App.OnStart`:

```powerfx
Set(varAppVersion, "1.0.0");
Set(varBenchmarkId, Blank());
Set(varPattern, Blank());
Set(varRunId, Blank());
Clear(colBenchmarkResults)
```

Do not load Benchmark Records in `App.OnStart`. Startup-loading behavior belongs in B002/B005 test variants rather than in the neutral harness.

## Common instrumentation

Before the operation under test:

```powerfx
Set(varRunId, Text(GUID()));
Set(varStartedAt, Now());
Set(varLastError, Blank());

Trace(
    "benchmark.start",
    TraceSeverity.Information,
    {
        benchmarkId: varBenchmarkId,
        pattern: varPattern,
        runId: varRunId,
        datasetTag: txtDatasetTag.Text,
        runNumber: varRunNumber
    }
)
```

After the operation under test:

```powerfx
Set(varFinishedAt, Now());
Set(
    varDurationMs,
    DateDiff(varStartedAt, varFinishedAt, TimeUnit.Milliseconds)
);

Trace(
    "benchmark.end",
    TraceSeverity.Information,
    {
        benchmarkId: varBenchmarkId,
        pattern: varPattern,
        runId: varRunId,
        durationMs: varDurationMs,
        actualCount: varActualCount,
        validationPassed: varValidationPassed
    }
);

Collect(
    colBenchmarkResults,
    {
        BenchmarkId: varBenchmarkId,
        Pattern: varPattern,
        RunId: varRunId,
        RunNumber: varRunNumber,
        DurationMs: varDurationMs,
        ActualCount: varActualCount,
        ValidationPassed: varValidationPassed
    }
)
```

Persisting a `Benchmark Run` row should happen after the measured interval unless persistence itself is the operation under test.

## B001 implementation

### Pattern A — server-oriented filter

Use a Dataverse filter that is confirmed delegable for the selected column types.

Example test shape:

```powerfx
ClearCollect(
    colResult,
    Filter(
        'Benchmark Records',
        'Dataset Tag' = txtDatasetTag.Text &&
        Category = "Alpha"
    )
)
```

### Pattern B — broad local collection then filter

```powerfx
ClearCollect(
    colSource,
    Filter(
        'Benchmark Records',
        'Dataset Tag' = txtDatasetTag.Text
    )
);

ClearCollect(
    colResult,
    Filter(
        colSource,
        Category = "Alpha"
    )
)
```

The point is to validate both correctness and runtime behavior. Do not declare a winner before measurements exist.

For the delegation-guardrail run, temporarily set the app nondelegable data-row limit to `1` as documented in B008.

## B003 implementation

Use three independent queries against the same synthetic dataset.

### Sequential

```powerfx
ClearCollect(
    colAlpha,
    Filter('Benchmark Records', 'Dataset Tag' = txtDatasetTag.Text && Category = "Alpha")
);
ClearCollect(
    colBeta,
    Filter('Benchmark Records', 'Dataset Tag' = txtDatasetTag.Text && Category = "Beta")
);
ClearCollect(
    colGamma,
    Filter('Benchmark Records', 'Dataset Tag' = txtDatasetTag.Text && Category = "Gamma")
)
```

### Concurrent

```powerfx
Concurrent(
    ClearCollect(
        colAlpha,
        Filter('Benchmark Records', 'Dataset Tag' = txtDatasetTag.Text && Category = "Alpha")
    ),
    ClearCollect(
        colBeta,
        Filter('Benchmark Records', 'Dataset Tag' = txtDatasetTag.Text && Category = "Beta")
    ),
    ClearCollect(
        colGamma,
        Filter('Benchmark Records', 'Dataset Tag' = txtDatasetTag.Text && Category = "Gamma")
    )
)
```

Validate that all three result sets are equivalent to the sequential baseline before comparing duration.

## B006 implementation

Create a narrow and wide retrieval variant against the same keys.

The narrow variant should select only fields required by the benchmark UI. The wide variant intentionally includes `Payload Text` and other unused columns.

Capture request/data-volume evidence in Live Monitor where available.

## Error handling

Compared patterns must use the same error semantics.

A failed operation is an invalid performance measurement.

Suggested shape:

```powerfx
IfError(
    /* operation under test */,
    Set(varLastError, FirstError.Message);
    Set(varValidationPassed, false)
)
```

## Result persistence

After timing and validation:

```powerfx
Patch(
    'Benchmark Runs',
    Defaults('Benchmark Runs'),
    {
        Name: varBenchmarkId & " / " & varPattern & " / " & Text(varRunNumber),
        'Correlation ID': varRunId,
        'Benchmark ID': varBenchmarkId,
        Pattern: varPattern,
        'Dataset Size': varDatasetSize,
        'Run Number': varRunNumber,
        'Duration (ms)': varDurationMs,
        'Records Returned': varActualCount,
        Outcome: If(varValidationPassed, "Passed", "Invalid"),
        'Evidence Level': "L2"
    }
)
```

A single environment run remains L2. Promote a benchmark to L3 only after the repository's repeated-run methodology is satisfied.

## Source control

Publish the app before committing Canvas source through Power Platform Git Integration.

Do not generate a fake `.pa.yaml` tree from this specification.
