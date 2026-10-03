# B006 — Dataverse query payload shape

## Question
For the same user-facing result, how does retrieving a narrow set of required columns compare with retrieving a wider record payload?

## Status
L0 — experiment design.

## Dataset
Use Benchmark Record with an optional large `PayloadText` field so row width can be controlled without production data.

## Variants

- Narrow projection: only columns required by the screen or operation.
- Wide projection: includes additional unused columns.

The selected Power Fx functions must be checked for delegation behavior before the run.

## Metrics

- Elapsed time.
- Request count.
- Response or data volume where observable.
- Records returned.
- UI readiness.
- Result equality for required fields.

## Scale
Test both row count and row width.
