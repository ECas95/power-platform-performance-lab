# B002 — Eager startup loading vs lazy loading

## Question

How does loading secondary datasets during app startup compare with loading them only when the user reaches the feature that needs them?

## Status

Planned — methodology defined, measurements not yet published.

## Scenario

Create equivalent Canvas App variants:

- **Eager**: secondary datasets are requested during startup.
- **Lazy**: startup loads only the data required for the initial experience; secondary datasets load on demand.

## Metrics

Measure separately:

- time until the initial screen is usable;
- time until primary data is usable;
- time until the secondary feature is usable;
- request count during startup;
- total requests after the secondary feature is opened.

Do not combine these into one metric because they represent different user experiences.

## Controls

Keep the same:

- data sources;
- dataset sizes;
- formulas performing the actual queries;
- client/device;
- permissions;
- network conditions as far as practical.

## Results

Use `results/raw.csv`.
