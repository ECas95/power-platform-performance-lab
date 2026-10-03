# Community benchmark validation

Real Power Platform measurements can be contributed without exposing a tenant or organization.

## Contribution flow

1. Pick a benchmark from `benchmarks/`.
2. Reproduce it in a non-production environment you are authorized to use.
3. Use only synthetic/public data.
4. Run the required repetitions.
5. Validate functional correctness.
6. Remove identifying information.
7. Add raw observations to the benchmark's `results/` folder.
8. Add a `summary.md` describing the environment at a non-identifying level.
9. Open a pull request.

## Allowed environment metadata

Examples:

- test date;
- client type: browser/mobile;
- browser family/version;
- approximate geographic Azure/Power Platform region if already non-sensitive;
- dataset size;
- Dataverse vs another connector;
- app type;
- run count;
- cold/warm-run handling;
- relevant platform settings such as nondelegable row limit.

## Do not submit

- tenant IDs;
- environment IDs or URLs;
- organization names;
- user emails/names;
- subscription IDs;
- resource names;
- connection IDs;
- screenshots containing identifying metadata;
- customer schemas or production data;
- secrets or tokens.

## Minimum result package

A result contribution should include:

```text
benchmarks/Bxxx-.../
  results/
    raw.csv
    summary.md
```

The summary should include:

- evidence level;
- exact benchmark commit or version;
- number of runs;
- correctness outcome;
- summary statistics;
- limitations;
- sanitized environment description.

## Independent reproduction

Results from one contributor/environment can reach L3 when the benchmark methodology is satisfied.

Results independently reproduced across materially different environments can support L4, provided the datasets and test procedures remain comparable.
