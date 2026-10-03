# Power Platform Performance Lab

Reproducible experiments, benchmarks, and engineering patterns for Microsoft Power Platform performance.

This project is for makers, developers, architects, and platform teams who want evidence-driven guidance for Power Apps, Power Fx, Dataverse, and Power Automate.

## Principles

- Measure before recommending.
- Validate correctness before comparing speed.
- Preserve raw observations.
- Separate vendor-documented behavior from repository measurements.
- Use synthetic/public data only.
- Publish limitations and environment context.
- Never expose customer, company, tenant, user, or production identifiers.

See [Evidence Levels](docs/EVIDENCE_LEVELS.md) and the [Public Anonymization Standard](docs/ANONYMIZATION.md).

## Scope

Current research areas include:

- Canvas Apps and Power Fx
- delegation and query correctness
- app startup and lazy loading
- collections and local state
- independent-call concurrency
- Dataverse query shape
- multi-record writes and bulk APIs
- concurrent identifier generation
- large-volume pagination and checkpointing
- Power Automate throughput, retries, and concurrency
- connector round-trips
- observability with Live Monitor, Trace, and Application Insights
- repeatable synthetic datasets
- performance-oriented ALM and source-control practices

## Repository structure

```text
.
├── benchmarks/       Experiment definitions and raw result schemas
├── data/             Synthetic-data guidance
├── docs/             Methodology, evidence rules, references, diagnostics
├── lab/              Environment-neutral benchmark harness design
├── research/         Pattern catalog and research backlog
├── samples/          Reusable Power Fx examples
├── tools/            Dataset generation, validation, summarization
├── tests/            Tests for repository utilities
├── .github/          Issue/PR templates and validation CI
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
└── LICENSE
```

## Benchmark roadmap

| ID | Experiment | Evidence |
|---|---|---|
| B001 | Delegable query vs local collection filtering | L0 |
| B002 | Eager startup loading vs lazy loading | L0 |
| B003 | Sequential vs Concurrent independent calls | L0 |
| B004 | Multi-record update patterns | L0 |
| B005 | StartScreen vs startup navigation logic | L0 |
| B006 | Dataverse query payload shape | L0 |
| B007 | Power Automate controlled concurrency | L0 |
| B008 | Data row limit = 1 delegation guardrail | L0 |
| B009 | Client-generated sequential IDs vs server-managed identity | L0 |
| B010 | Large-volume pagination and checkpointing | L0 |

See the [Benchmark Catalog](benchmarks/README.md).

## Benchmark harness

The [lab](lab/README.md) defines a generic test architecture using:

- a Canvas App benchmark runner;
- synthetic Dataverse tables;
- structured correlation IDs;
- Power Fx `Trace()`;
- Power Apps Live Monitor;
- optional Application Insights telemetry;
- Power Automate synthetic workloads.

The repository does not claim a hand-written Canvas/solution package is importable. A deployable solution will be published only after it is created and validated in a real Power Platform environment using supported ALM/source-control tooling.

## Quick start: synthetic data

```bash
python tools/generate_synthetic_data.py \
  --rows 10000 \
  --seed 42 \
  --output data/generated/benchmark-10000.csv
```

## Quick start: result validation

```bash
python tools/validate_results.py \
  benchmarks/B001-delegation-vs-local-filtering/results/raw.csv
```

## Quick start: result summary

After measurements exist:

```bash
python tools/summarize_results.py results/raw.csv \
  --group-by pattern \
  --metric duration_ms
```

The summarizer reports descriptive statistics only. It never creates benchmark observations.

## Observability

Use [Live Monitor capture guidance](docs/MONITOR_CAPTURE.md) to correlate runtime operations with benchmark runs.

Use one correlation ID per measured execution and sanitize telemetry before publishing it.

## Source control

Canvas Apps currently use supported `.pa.yaml` source in Power Platform source-control workflows. See [Canvas App Source Control Notes](docs/SOURCE_CONTROL.md).

## References

Microsoft documentation used as platform context is indexed in [docs/REFERENCES.md](docs/REFERENCES.md). Documentation is not treated as a measured result.

## Contributing

Contributions are welcome when they are reproducible, measurable, technically focused, and safe to publish.

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT. See [LICENSE](LICENSE).
