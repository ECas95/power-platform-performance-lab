# Benchmark Authoring Guide

A benchmark should answer one narrow performance question and be reproducible by someone who did not design it.

## Required structure

Use:

```text
benchmarks/
  B###-short-name/
    README.md
    results/
      raw.csv
      summary.md
```

Optional folders such as `formulas/`, `flows/`, `fixtures/`, or `scripts/` can be added when they materially improve reproduction.

## Before measuring

Define:

- the question;
- the hypothesis;
- the compared patterns;
- the dataset and sizes;
- the correctness check;
- timing boundaries;
- warm-up behavior;
- run count;
- runtime evidence to capture;
- known limitations.

Do not change the question after seeing results without recording that change.

## Functional equivalence

Compared patterns must produce equivalent intended outcomes.

Examples:

- read benchmarks compare expected primary keys;
- write benchmarks verify all intended records changed exactly once;
- flow benchmarks check missing and duplicate effects;
- delegation benchmarks validate results beyond local row limits.

If correctness fails, the run is invalid even if it is faster.

## Timing

Define exactly what starts and stops the timer.

Do not include setup work in one pattern but exclude it from another.

When user-perceived readiness matters, measure that separately from backend completion.

## Repetition

Use repeated measured runs.

Document:

- warm-up runs;
- measured runs;
- cold vs warm behavior;
- whether order was alternated/randomized to reduce sequence bias.

Raw observations are the source of truth.

## Runtime evidence

Capture only what supports the question:

- elapsed time;
- request count;
- request duration;
- retries/throttling;
- records read/written;
- correctness outcome;
- UI blocking/readiness;
- restart/checkpoint behavior.

## Publication

Before publishing:

1. run `tools/validate_results.py`;
2. run `tools/privacy_scan.py`;
3. derive summary statistics with `tools/summarize_results.py`;
4. complete the result review checklist;
5. declare the evidence level.

See [RESULT_REVIEW_CHECKLIST.md](RESULT_REVIEW_CHECKLIST.md).
