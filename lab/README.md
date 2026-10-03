# Performance Lab Harness

This directory defines the environment-neutral architecture used to execute repository benchmarks.

```text
Canvas App benchmark UI
        |
        v
Dataverse / connector synthetic test data
        |
        +--> Live Monitor
        +--> Trace events --> Application Insights (optional)
```

Power Automate benchmarks use the same synthetic identifiers and result format but execute through flows rather than the Canvas UI.

## Design goals

- No dependency on production data.
- Deterministic dataset generation.
- One correlation ID per measured run.
- Correctness validation before performance comparison.
- Raw result preservation.
- Environment metadata without tenant identifiers.
- Repeatable experiments across multiple environments.

## Components

- [Dataverse test schema](dataverse/README.md)
- [Canvas benchmark harness](canvas/README.md)
- [Power Automate harness](power-automate/README.md)

## Importable solution status

The repository deliberately does not claim hand-written solution metadata is importable. The first importable solution package will be committed only after it is created and validated in a real Power Platform environment and successfully round-tripped through supported ALM tooling.
