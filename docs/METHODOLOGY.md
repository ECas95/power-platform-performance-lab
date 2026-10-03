# Benchmark Methodology

## Principle

Performance guidance is useful only when the test context is visible. A formula that performs well with 500 records, one connector, and a low-latency network may behave differently at another scale or in another environment.

The lab therefore treats each benchmark as an experiment, not as a universal rule.

## Required controls

Where practical, keep these variables stable between patterns:

- source data;
- number of records;
- selected columns;
- user permissions;
- browser/client;
- test device;
- network path;
- environment;
- connector configuration;
- cache/warm-up state.

If a variable cannot be controlled, document it.

## Repetition

One execution is not enough to characterize performance.

Use multiple repetitions and retain the individual measurements. Report the median at minimum; optionally report mean, minimum, maximum, percentiles, and standard deviation when the number of observations justifies them.

## Cold and warm behavior

Some tests may be affected by caching, connection establishment, formula initialization, or previously loaded data.

When this matters, explicitly distinguish:

- cold run;
- warm-up run;
- measured warm runs.

## Functional equivalence

Patterns should produce the same functional result before their performance is compared. A faster pattern is not a valid replacement when it returns different records, ignores errors, or changes business behavior.

## Scale

Whenever practical, test more than one dataset size. Example tiers can include small, medium, and large datasets, but the actual record counts must be recorded rather than relying on those labels.

## Reporting

A benchmark result should contain:

- raw observations;
- summarized metrics;
- interpretation;
- limitations;
- reproduction instructions.

Never replace raw observations with only a chart or a single averaged number.
