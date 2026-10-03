# B004 — Multi-record update patterns

## Question
How do functionally equivalent multi-record update patterns differ in duration, request behavior, and failure semantics?

## Status
L0 — experiment design.

## Initial Canvas comparison

Candidate patterns include a table-oriented `Patch` shape where supported and `ForAll(..., Patch(...))` row-oriented updates. Exact formulas will be fixed only after the Dataverse test schema is provisioned and both patterns are proven functionally equivalent.

## External-client extension

A separate subtest can compare Dataverse single-row operations with supported bulk messages such as `CreateMultiple`, `UpdateMultiple`, and `UpsertMultiple`. Do not combine Canvas timing and external Web API timing into one result.

## Suggested write sizes

- 10 records
- 100 records
- 500 records
- 1,000 records

## Metrics

- End-to-end duration.
- Records intended.
- Records successfully changed.
- Request count where observable.
- Errors and retries.
- Duplicate or missing effects.
- Recovery notes.

## Correctness

Every intended key must be changed exactly as expected. A partially successful fast operation is not a valid winning result.
