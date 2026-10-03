# Dataverse Test Schema

The lab uses a generic table model so benchmarks can be reproduced without customer data.

## Core table

Suggested logical name: `pppl_benchmarkrecord`. See [schema/benchmark-record.md](schema/benchmark-record.md).

## Result table

Suggested logical name: `pppl_benchmarkrun`.

| Column | Type | Purpose |
|---|---|---|
| BenchmarkRunId | GUID primary key | Run identity |
| CorrelationId | Text | Correlates UI/flow/telemetry events |
| BenchmarkId | Text | B001, B002, etc. |
| Pattern | Text | Pattern under test |
| DatasetSize | Whole number | Source row count |
| RunNumber | Whole number | Repetition number |
| DurationMs | Whole number | End-to-end duration |
| RecordsReturned | Whole number | Functional validation |
| RequestCount | Whole number | Optional observed requests |
| Outcome | Choice/Text | Passed, Failed, Invalid |
| Notes | Multiline text | Sanitized observations |

Use a synthetic external key on Benchmark Record to support repeatable upsert experiments. The benchmark environment should contain synthetic data only.
