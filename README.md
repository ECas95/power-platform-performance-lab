# Power Platform Performance Lab

[![Test benchmark utilities](https://github.com/ECas95/power-platform-performance-lab/actions/workflows/python-tools.yml/badge.svg)](https://github.com/ECas95/power-platform-performance-lab/actions/workflows/python-tools.yml)
[![Validate benchmark results](https://github.com/ECas95/power-platform-performance-lab/actions/workflows/validate-results.yml/badge.svg)](https://github.com/ECas95/power-platform-performance-lab/actions/workflows/validate-results.yml)
[![Validate PowerShell bootstrap](https://github.com/ECas95/power-platform-performance-lab/actions/workflows/powershell-static.yml/badge.svg)](https://github.com/ECas95/power-platform-performance-lab/actions/workflows/powershell-static.yml)

Reproducible experiments, benchmarks, and engineering patterns for Microsoft Power Platform performance.

The repository is intentionally **public-only**. Maintaining it does not require a private Microsoft tenant, Dataverse environment, Entra application, tenant ID, client ID, secret, or production account.

## Project status

The **public v1 baseline is complete**: experiment definitions, methodology, public tooling, validation CI, generic Power Platform build specifications, synthetic data, privacy rules, and community contribution workflows are in place.

Real Power Platform runtime results are a separate evidence phase. They must come from authorized environments and are accepted only as sanitized contributions. The repository never fabricates measurements to make an experiment appear complete.

See [Project Status](docs/PROJECT_STATUS.md) and [Roadmap](ROADMAP.md).

## Principles

- Measure before recommending.
- Validate correctness before comparing speed.
- Preserve raw observations.
- Separate documented platform behavior from repository measurements.
- Use synthetic/public data only.
- Publish limitations and non-identifying environment context.
- Never expose customer, company, tenant, user, or production identifiers.
- Keep maintainer CI independent of private Microsoft infrastructure.

See [Public-only project model](docs/PUBLIC_ONLY_MODEL.md), [Evidence Levels](docs/EVIDENCE_LEVELS.md), and [Public Anonymization Standard](docs/ANONYMIZATION.md).

## Benchmark catalog

| ID | Experiment | Evidence |
|---|---|---|
| B001 | Delegable query vs local collection filtering | L0 |
| B002 | Eager startup loading vs lazy loading | L0 |
| B003 | Sequential vs `Concurrent()` independent calls | L0 |
| B004 | Multi-record update patterns | L0 |
| B005 | `StartScreen` vs startup navigation logic | L0 |
| B006 | Dataverse query payload shape | L0 |
| B007 | Power Automate controlled concurrency | L0 |
| B008 | Data row limit = 1 delegation guardrail | L0 |
| B009 | Client-generated sequential IDs vs server-managed identity | L0 |
| B010 | Large-volume pagination and checkpointing | L0 |

L0 here means the experiment is designed but has not yet earned repeated runtime evidence. See the [Benchmark Catalog](benchmarks/README.md).

## Repository structure

```text
.
├── benchmarks/            B001-B010 experiment definitions and result schemas
├── community-validation/ Sanitized real-result contribution workflow
├── data/                  Synthetic-data guidance
├── docs/                  Methodology, architecture, privacy, evidence rules
├── lab/                   Environment-neutral benchmark harness design
├── power-platform/        Public schemas, Canvas build spec, optional bootstrap
├── research/              Pattern catalog and research backlog
├── samples/               Reusable Power Fx examples
├── tools/                 Data generation, validation, privacy scan, statistics
├── tests/                 Unit tests for repository tooling
└── .github/               Issue templates, CODEOWNERS, public CI
```

## Public benchmark harness

The lab defines a generic architecture using:

- a Canvas App benchmark runner specification;
- synthetic Dataverse table definitions;
- structured correlation IDs;
- Power Fx `Trace()`;
- Power Apps Live Monitor;
- optional Application Insights telemetry;
- Power Automate synthetic workloads.

No service is required merely to clone, inspect, maintain, or contribute to the repository.

See [Repository Architecture](docs/ARCHITECTURE.md).

## Quick start

Generate deterministic synthetic data:

```bash
python tools/generate_synthetic_data.py \
  --rows 10000 \
  --seed 42 \
  --output data/generated/benchmark-10000.csv
```

Validate a result file:

```bash
python tools/validate_results.py \
  benchmarks/B001-delegation-vs-local-filtering/results/raw.csv
```

Scan evidence for obvious privacy risks:

```bash
python tools/privacy_scan.py \
  path/to/raw.csv \
  path/to/summary.md
```

Summarize real measurements:

```bash
python tools/summarize_results.py \
  path/to/raw.csv \
  --group-by pattern \
  --metric duration_ms
```

All Python utilities use the standard library only.

## Power Platform reference workspace

[power-platform/](power-platform/README.md) contains:

- generic Dataverse schema definitions;
- a Canvas App benchmark-runner build specification;
- optional Dataverse bootstrap, seeding, and validation scripts.

Those scripts are contributor conveniences only. No Microsoft account or private environment is required from the repository owner.

## Contributing real measurements

A contributor with authorized access to a suitable non-production environment can reproduce a benchmark and submit sanitized evidence.

Use:

- [Benchmark Authoring Guide](docs/BENCHMARK_AUTHORING.md)
- [Community Validation](community-validation/README.md)
- [Result Review Checklist](docs/RESULT_REVIEW_CHECKLIST.md)
- [Result Summary Template](community-validation/summary-template.md)

A local simulation is not treated as Power Platform runtime evidence.

## Security and privacy

Do not publish credentials, private environment URLs, user identities, customer data, tenant details, or proprietary schemas.

See [SECURITY.md](SECURITY.md) and [docs/ANONYMIZATION.md](docs/ANONYMIZATION.md).

## References

Microsoft documentation used as platform context is indexed in [docs/REFERENCES.md](docs/REFERENCES.md). Documentation is not treated as a measured result produced by this project.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT. See [LICENSE](LICENSE).
