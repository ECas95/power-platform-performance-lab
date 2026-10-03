# B010 — Large-volume pagination and checkpointing

## Question
How do large-volume processing patterns differ when work is paginated and checkpointed instead of materializing the full source in the interactive client?

## Status
L0 — experiment design.

## Candidate approaches

- Interactive-client materialization baseline where technically possible.
- Power Automate connector pagination.
- Cursor/token-based processing where supported by the source.
- Checkpointed batches that persist progress after each chunk.

## Dataset sizes

- 2,000
- 10,000
- 30,000
- 100,000 records where the selected source supports a safe synthetic test.

## Metrics

- Total elapsed time.
- Time to first processed batch.
- Peak client-side record count where observable.
- Requests/pages.
- Retry count.
- Records processed.
- Missing/duplicate records.
- Restart point after an injected failure.

## Resilience subtest

Inject a controlled failure after one or more completed batches. Restart the workload and verify that checkpointing resumes safely without reprocessing completed work unless the design intentionally supports idempotent replay.
