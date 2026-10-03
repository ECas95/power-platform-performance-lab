# Results Publication Format

Every completed benchmark should publish both machine-readable raw observations and a human-readable interpretation.

## Required files

```text
results/
  raw.csv
  summary.md
```

Optional derived artifacts such as charts may be added, but they must not replace raw observations.

## Raw data

Each row should represent one measured execution whenever practical.

Avoid fields containing:

- tenant names;
- environment URLs;
- user emails;
- customer data;
- access tokens;
- connection identifiers that should not be public.

## Summary

A result summary should contain:

1. test date;
2. benchmark version or commit;
3. environment description;
4. number of runs;
5. summary statistics;
6. correctness outcome;
7. observed request behavior;
8. interpretation;
9. limitations.

## Performance claims

Use language proportional to the evidence.

Prefer:

> In this test environment, Pattern A had a lower median elapsed time across 20 measured runs.

Avoid:

> Pattern A is always faster.

A benchmark measures the tested conditions, not every possible tenant, connector, network, dataset, or future platform version.
