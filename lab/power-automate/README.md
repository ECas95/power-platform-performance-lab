# Power Automate Performance Harness

Power Automate benchmarks measure throughput and reliability without coupling results to a real business process.

## Generic workload

Use synthetic work items containing ExternalKey, WorkType, PayloadSize, SequenceNumber, and CorrelationId.

## Candidate dimensions

- Sequential vs controlled concurrency.
- Degree of parallelism.
- Pagination settings.
- Retry policy.
- Child-flow decomposition.
- Per-item persistence vs batched persistence.
- Idempotency checks.
- Connector/service throttling.

## Correctness

Throughput is invalid if the flow skips work items, processes an item more than intended, loses failures, creates duplicates, or reports success before required persistence completes.

## Resilience experiments

Retries, dead-letter/error queues, checkpoints, and manual replay patterns should be evaluated separately from raw throughput. A resilient design can intentionally trade maximum speed for recovery and traceability.
