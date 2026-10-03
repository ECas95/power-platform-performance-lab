# Power Fx benchmark harness

The snippets below are intended to be adapted inside a validated Canvas App.

## Start a measured run

```powerfx
Set(varRunId, Text(GUID()));
Set(varStartedAt, Now());

Trace(
    "benchmark.start",
    TraceSeverity.Information,
    {
        benchmarkId: varBenchmarkId,
        runId: varRunId,
        pattern: varPattern,
        runNumber: varRunNumber,
        datasetSize: varDatasetSize
    }
);
```

## Execute the pattern

Place only the operation under test between the start and finish instrumentation. Do not include unrelated navigation, notifications, screen rendering, or setup unless the benchmark explicitly tests them.

## Finish the run

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
        runId: varRunId,
        pattern: varPattern,
        runNumber: varRunNumber,
        datasetSize: varDatasetSize,
        durationMs: varDurationMs,
        actualCount: varActualCount,
        validationPassed: varValidationPassed
    }
);
```

## Local result collection

```powerfx
Collect(
    colBenchmarkResults,
    {
        BenchmarkId: varBenchmarkId,
        RunId: varRunId,
        Pattern: varPattern,
        DatasetSize: varDatasetSize,
        RunNumber: varRunNumber,
        DurationMs: varDurationMs,
        ActualCount: varActualCount,
        ValidationPassed: varValidationPassed
    }
);
```

## Error handling

Use the same error-handling behavior for every compared pattern. Failed executions should be marked invalid rather than treated as successful fast runs.
