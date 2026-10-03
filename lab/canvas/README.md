# Canvas Benchmark Harness

The Canvas App acts as a controlled runner rather than a production application.

## Suggested screens

### Home
Lists available benchmarks and shows the current environment-neutral configuration.

### Benchmark Runner
Inputs: benchmark ID, pattern, dataset size, repetitions, and warm-up runs. Actions: prepare, execute, validate, and export/copy sanitized results.

### Diagnostics
Shows correlation ID, current run, last duration, record count, validation outcome, and last error.

## Suggested state

- `varBenchmarkId`
- `varPattern`
- `varRunId`
- `varStartedAt`
- `varFinishedAt`
- `varDurationMs`
- `varRunNumber`
- `varExpectedCount`
- `varActualCount`
- `varValidationPassed`

## Instrumentation

Every measured run should emit structured `Trace()` start/end events and optionally persist a sanitized Benchmark Run record.

See [powerfx/benchmark-harness.md](powerfx/benchmark-harness.md).

## Startup

Keep benchmark setup separate from app startup wherever possible so a test does not accidentally measure unrelated initialization work. B002 and B005 intentionally test startup behavior and therefore use separate app variants or controlled configurations.
