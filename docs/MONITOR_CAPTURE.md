# Live Monitor Capture Workflow

Power Apps Live Monitor is a primary source of runtime evidence for Canvas App benchmarks.

## What to capture

For each measured run, correlate the benchmark identifier and run number with data operations, request duration where available, HTTP failures or throttling, delegation indicators, repeated evaluations, unexpected calls, and custom `Trace()` events.

## Correlation pattern

Start event:

```powerfx
Set(varRunId, Text(GUID()));
Set(varStartedAt, Now());
Trace(
    "benchmark.start",
    TraceSeverity.Information,
    { benchmarkId: "B003", runId: varRunId, pattern: "Concurrent", datasetSize: 10000 }
);
```

End event:

```powerfx
Trace(
    "benchmark.end",
    TraceSeverity.Information,
    { benchmarkId: "B003", runId: varRunId, durationMs: DateDiff(varStartedAt, Now(), TimeUnit.Milliseconds) }
);
```

## Capture procedure

1. Open the app in the intended test client.
2. Open Live Monitor.
3. Perform warm-up runs when required.
4. Start one measured run.
5. Locate `benchmark.start` and `benchmark.end` with the same `runId`.
6. Inspect the platform events between them.
7. Record request counts, errors, throttling, delegation indicators, and notable durations.
8. Store only sanitized measurements in this repository.

## Privacy

Do not export or publish user emails, tenant/environment identifiers, proprietary table names, or request payloads containing business data. Translate sensitive identifiers to generic labels before committing results.
