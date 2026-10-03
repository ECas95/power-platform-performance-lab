# B007 — Power Automate controlled concurrency

## Question
How does configured parallelism affect total processing time, throttling, retries, and correctness for independent synthetic work items?

## Status
L0 — experiment design.

## Candidate degrees

- 1
- 2
- 5
- 10

Do not assume the highest available setting is optimal.

## Metrics

- Total elapsed time.
- Items per minute.
- Succeeded, failed, and skipped counts.
- Retries.
- Throttling evidence.
- Duplicate effects.
- Downstream connector latency.

## Correctness
Every input ExternalKey must have exactly one expected final effect.

## Interpretation
Results are connector- and environment-sensitive. Publish the tested connector and workload characteristics without tenant identifiers.
