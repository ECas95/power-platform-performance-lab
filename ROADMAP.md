# Roadmap

The project is intentionally public-only: repository maintenance must not depend on a private Microsoft tenant.

## Public baseline — complete

- benchmark methodology and evidence levels;
- B001–B010 experiment definitions;
- deterministic synthetic-data generator;
- result validation and summarization utilities;
- Canvas benchmark-runner build specification;
- generic Dataverse benchmark schema;
- optional Dataverse bootstrap/seed/validation scripts;
- Live Monitor / Trace capture workflow;
- anonymization and community-validation rules;
- public CI for Python utilities, result files, and PowerShell syntax.

## Evidence phase — community driven

The next stage is execution, not additional unmeasured claims.

Priority order:

1. B001 — delegation vs local filtering;
2. B003 — sequential vs concurrent independent calls;
3. B006 — query payload width;
4. B004 — multi-record update patterns;
5. B009 — concurrent identifier generation;
6. B002/B005 — startup behavior;
7. B007 — flow concurrency;
8. B010 — pagination/checkpointing;
9. B008 — delegation guardrail effectiveness.

Each benchmark remains at its documented evidence level until real sanitized measurements are submitted.

## Future research candidates

Potential future benchmarks include:

- named formulas vs repeated computed expressions;
- component-boundary data access;
- repeated `LookUp` patterns;
- connector retry behavior;
- large collection memory pressure;
- Power Fx formula complexity and evaluation cost;
- custom API vs repeated client/server round trips;
- browser vs mobile client behavior.

New experiments should be added only when they answer a distinct measurable question.
