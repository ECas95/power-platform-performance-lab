# Benchmark Catalog

Benchmarks are numbered so results and discussions remain easy to reference. Status is expressed using the evidence model in [../docs/EVIDENCE_LEVELS.md](../docs/EVIDENCE_LEVELS.md).

| ID | Question | Area | Status |
|---|---|---|---|
| B001 | How does a delegable server-side filter compare with loading data locally and filtering a collection? | Canvas Apps / Dataverse | L0 |
| B002 | What is the startup cost of eagerly loading secondary datasets compared with lazy loading? | Canvas Apps | L0 |
| B003 | How do concurrent independent calls compare with sequential execution? | Canvas Apps / Connectors | L0 |
| B004 | How do multi-record update patterns differ in duration, request behavior, and failure semantics? | Power Fx / Dataverse | L0 |
| B005 | How does StartScreen compare with startup navigation logic? | Canvas Apps | L0 |
| B006 | How does Dataverse query payload width affect retrieval behavior? | Canvas Apps / Dataverse | L0 |
| B007 | How does controlled flow concurrency affect throughput, throttling, retries, and correctness? | Power Automate | L0 |
| B008 | How effective is data row limit = 1 at exposing accidental nondelegable logic? | Canvas Apps | L0 |
| B009 | What happens when concurrent clients allocate a sequential business ID with client-side max + 1? | Canvas Apps / Dataverse | L0 |
| B010 | How do pagination and checkpoints compare with full client-side materialization for large workloads? | Power Automate / Canvas Apps | L0 |

No benchmark becomes L3 until repeated raw measurements, correctness validation, environment metadata, and reproduction steps have been published.

## Execution order

Recommended first sequence:

B001 → B003 → B006 → B004 → B009 → B002/B005 → B007 → B010 → B008

This establishes data-access and instrumentation behavior before testing more environment-sensitive startup, concurrency, and large-volume scenarios.
