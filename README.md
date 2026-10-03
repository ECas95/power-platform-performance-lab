# Power Platform Performance Lab

Reproducible experiments, benchmarks, and engineering patterns for improving the performance of Microsoft Power Platform solutions.

This repository is intended for makers, developers, architects, and platform teams who want evidence-driven guidance for Power Apps, Power Fx, Dataverse, and Power Automate instead of relying only on rules of thumb.

## Goals

- Build reproducible performance experiments.
- Compare common implementation patterns under controlled conditions.
- Document trade-offs, not just "best practices".
- Separate measured results from hypotheses and platform documentation.
- Provide samples that can be adapted to real enterprise solutions.
- Track changes in behavior as the Power Platform evolves.

## Scope

The lab currently focuses on:

- Canvas Apps and Power Fx
- Dataverse data access
- Delegation and query design
- App startup and lazy loading
- Collections and local state
- Bulk updates and write patterns
- Power Automate throughput and concurrency
- Connector call reduction
- Error handling and resilience
- Observability and performance diagnostics

Future work may include Copilot Studio, custom connectors, Power Pages, Model-driven Apps, PCF components, and API-backed architectures.

## Repository structure

```text
.
├── benchmarks/       Reproducible benchmark definitions
├── docs/             Methodology, terminology, and findings
├── research/         Research notes and experiment proposals
├── samples/          Reusable Power Fx and implementation samples
├── tools/            Utilities for measuring or generating test data
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
├── LICENSE
└── README.md
```

## Benchmark philosophy

A benchmark in this repository should answer a specific question and make the test repeatable.

Every benchmark should document:

1. Question being tested.
2. Hypothesis.
3. Environment and data source.
4. Dataset size.
5. Formula or flow being tested.
6. Number of test runs.
7. Warm-up behavior, if applicable.
8. Metrics collected.
9. Raw observations.
10. Interpretation and limitations.

Results should never be generalized beyond what the experiment supports.

## Initial benchmark roadmap

| ID | Experiment | Status |
|---|---|---|
| B001 | Delegable query vs local collection filtering | Planned |
| B002 | ClearCollect-heavy startup vs lazy loading | Planned |
| B003 | Sequential connector calls vs Concurrent | Planned |
| B004 | ForAll update patterns and server round-trips | Planned |
| B005 | StartScreen vs navigation logic performed during startup | Planned |
| B006 | Dataverse query shape and column selection | Planned |
| B007 | Power Automate concurrency and throughput | Planned |
| B008 | Large dataset paging and delegation limits | Planned |

See [benchmarks/README.md](benchmarks/README.md) for the experiment format.

## What this repository is not

This project is not an official Microsoft repository and does not replace Microsoft documentation.

Platform behavior can change. Each result must therefore include enough context to reproduce the experiment and should be revalidated when relevant platform capabilities change.

## Contribution model

Contributions are welcome when they are:

- reproducible;
- measurable;
- clearly documented;
- safe to run;
- based on publicly shareable examples and data.

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT. See [LICENSE](LICENSE).
