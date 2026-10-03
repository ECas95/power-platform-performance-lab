# Power Platform Performance Lab

Reproducible experiments, benchmarks, and engineering patterns for Microsoft Power Platform performance.

This is a public-only open-source project. The repository owner does not need to connect a private Microsoft tenant, Dataverse environment, Entra application, client ID, tenant ID, or secret.

## Principles

- Measure before recommending.
- Validate correctness before comparing speed.
- Preserve raw observations.
- Separate vendor-documented behavior from repository measurements.
- Use synthetic/public data only.
- Publish limitations and non-identifying environment context.
- Never expose customer, company, tenant, user, or production identifiers.
- Keep maintainer CI independent of private Microsoft infrastructure.

See [Public-only project model](docs/PUBLIC_ONLY_MODEL.md), [Evidence Levels](docs/EVIDENCE_LEVELS.md), and the [Public Anonymization Standard](docs/ANONYMIZATION.md).

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
├── benchmarks/            Experiment definitions and raw result schemas
├── community-validation/ Community process for real sanitized measurements
├── data/                  Synthetic-data guidance
├── docs/                  Methodology, evidence rules, references, diagnostics
├── lab/                   Environment-neutral benchmark harness design
├── power-platform/        Public schemas, build specs, optional bootstrap scripts
├── research/              Pattern catalog and research backlog
├── samples/               Reusable Power Fx examples
├── tools/                 Dataset generation, validation, summarization
├── tests/                 Tests for repository utilities
├── .github/               Issue/PR templates and public CI
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

## Public benchmark harness

The [lab](lab/README.md) defines a generic test architecture using:

- a Canvas App benchmark runner specification;
- synthetic Dataverse table definitions;
- structured correlation IDs;
- Power Fx `Trace()`;
- Power Apps Live Monitor;
- optional Application Insights telemetry;
- Power Automate synthetic workloads.

The repository does not require the maintainer to provision these services.

Contributors who already have authorized access to a suitable non-production Power Platform environment can reproduce a benchmark and submit sanitized results through [community validation](community-validation/README.md).

## Power Platform reference workspace

[power-platform/](power-platform/README.md) contains:

- the generic solution/table specification;
- a Canvas App build specification;
- optional Dataverse bootstrap/seed/validation scripts.

Those scripts are reference tooling only. No repository variable, secret, tenant ID, client ID, federated credential, or Microsoft account is required to maintain this repository.

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

After real measurements exist:

```bash
python tools/summarize_results.py results/raw.csv \
  --group-by pattern \
  --metric duration_ms
```

The summarizer reports descriptive statistics only. It never creates benchmark observations.

## Real runtime evidence

A local simulation is not treated as Power Platform runtime evidence.

Real benchmark results must come from an actual authorized Power Platform environment and be submitted in sanitized form. This keeps the project technically credible while remaining public-only.

## Source control

The project documents current Canvas source-control practices in [Canvas App Source Control Notes](docs/SOURCE_CONTROL.md).

## References

Microsoft documentation used as platform context is indexed in [docs/REFERENCES.md](docs/REFERENCES.md). Documentation is not treated as a measured result.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) and [community-validation/README.md](community-validation/README.md).

## License

MIT. See [LICENSE](LICENSE).
