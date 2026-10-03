# Evidence Levels

The lab distinguishes documentation, hypothesis, observation, and measured evidence.

## Levels

### L0 — Proposal
A performance question or experiment design exists, but no execution has been performed.

### L1 — Platform-documented behavior
A statement is supported by current vendor documentation. It is useful context, but it is not a benchmark result produced by this repository.

### L2 — Single-environment observation
A behavior has been observed in one environment or a small number of runs. Treat it as directional evidence.

### L3 — Repeated benchmark
The experiment has repeated raw measurements, functional-equivalence checks, documented environment metadata, and a reproducible procedure.

### L4 — Cross-environment validation
The benchmark has been reproduced across materially different environments, datasets, clients, or contributors and the result remains consistent within documented limits.

## Rule for conclusions

Every result summary should declare its evidence level. Do not convert documentation into a measured result, one observation into a universal recommendation, or a fast implementation into a correct implementation without result validation.
