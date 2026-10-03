# B009 — Client-generated sequential IDs vs server-managed identity

## Question
What correctness and throughput risks appear when multiple clients generate a business identifier using a read-current-maximum-plus-one pattern?

## Status
L0 — experiment design.

## Problem pattern

A client reads the current highest business sequence, adds one, and writes a new record. Under concurrency, two clients can read the same current value before either write commits.

## Candidate designs

- Client-side `max + 1` baseline.
- Server-managed unique identifier.
- Server-side sequence allocation pattern.
- Alternate-key/idempotent integration pattern where a sequential business number is not required.

## Metrics

- Successful creates.
- Duplicate-key conflicts.
- Duplicate business numbers.
- Retry count.
- End-to-end duration.
- Throughput.
- Recovery complexity.

## Concurrency profiles

Run with 1, 2, 5, 10, and 20 concurrent creators where the test environment permits it.

## Correctness

A design fails correctness if two records receive the same supposedly unique business identifier or if a retry can create an unintended duplicate effect.

## Scope

This benchmark is about concurrency behavior and operational correctness, not about prescribing a particular business numbering requirement.
