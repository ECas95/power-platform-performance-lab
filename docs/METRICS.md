# Performance Metrics

Use metrics that match the question being tested.

## Duration

Measure end-to-end elapsed time for the operation being compared. Define precisely when timing starts and stops.

Useful summaries can include:

- median;
- mean;
- minimum;
- maximum;
- p95 when enough samples exist.

## Network and connector activity

Where tooling makes the information observable, record:

- request count;
- request duration;
- repeated calls;
- failed requests;
- throttling or retries.

## Data volume

Record:

- source record count;
- records returned;
- records written;
- selected columns where relevant.

This helps distinguish a formula optimization from simply processing less data.

## User-perceived responsiveness

For interactive Canvas App experiments, record whether the UI is blocked and when useful content becomes available.

"App start time" and "time until a secondary dataset is loaded" are different metrics and should not be merged.

## Correctness

Performance measurements are invalid if compared implementations do not produce equivalent outcomes.

Include correctness checks for:

- record counts;
- expected values;
- error handling;
- duplicate writes;
- missing records caused by nondelegable logic.

## Environment metadata

Capture enough metadata to reproduce the result without exposing private tenant information.
