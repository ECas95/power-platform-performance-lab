# Delegation Guardrails

Delegation is both a performance and correctness concern. A nondelegable query can produce a fast-looking but incomplete result because local processing is limited to a subset of source data.

## Development guardrail

For delegation-focused testing, temporarily set the Canvas App **Data row limit** to `1`. This intentionally makes accidental local processing obvious.

Do not treat this setting as a production optimization. It is a development/test technique for detecting hidden nondelegable logic.

## Benchmark correctness check

1. Define the expected matching primary keys.
2. Execute the candidate formula.
3. Compare primary-key sets, not only row counts.
4. Fail the benchmark if the sets differ.
5. Compare performance only after correctness passes.

## Collections

Collections are in-memory data. Once records are loaded into a collection, subsequent operations on that collection are local rather than delegated back to the original data source.

## Large datasets

Delegation benchmarks should include source sizes beyond nondelegable processing limits so incorrect formulas become visible.
