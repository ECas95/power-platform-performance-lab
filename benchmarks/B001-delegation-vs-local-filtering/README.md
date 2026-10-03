# B001 — Delegable query vs local collection filtering

## Question

For the same filtering task, how do correctness, elapsed time, and request behavior differ between a server-oriented delegable query and loading a broader dataset into a local collection before filtering?

## Status

Planned — methodology defined, measurements not yet published.

## Hypothesis

When the connector and formula support delegation, filtering at the data source should reduce unnecessary data transfer and avoid correctness risks associated with processing only a client-limited subset. The benchmark will test this rather than treating it as a measured result.

## Test matrix

Run both patterns at multiple source sizes:

- 500 records
- 2,000 records
- 10,000 records
- 50,000 records

Additional sizes may be added if the environment supports them.

## Patterns

### A — Server-oriented candidate

Use a filter expression verified as delegable for the selected Dataverse column types.

### B — Local-processing baseline

Load a broader source set into a collection, then apply equivalent local filtering.

The exact formulas will be committed after the test table and columns are finalized.

## Correctness check

For every run, compare the returned primary-key values. A duration comparison is invalid if the result sets are different.

## Metrics

- elapsed time;
- records returned;
- request count where observable;
- warnings/errors;
- result-set equality.

## Environment metadata

Record the test date, client, region, dataset size, selected column types, and any configured nondelegable data-row limit without publishing tenant identifiers.

## Results

Use `results/raw.csv`. Do not add conclusions before measured data exists.
