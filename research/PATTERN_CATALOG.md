# Enterprise Pattern Catalog

This catalog converts recurring implementation problems into public research questions. No entry is a customer case study.

## Canvas Apps

### Delegation-first retrieval
Research whether the data source can perform filtering and sorting before records reach the client. Validate correctness beyond local processing limits. Related: B001, B008.

### Lazy secondary loading
Avoid making the initial user experience wait for datasets not needed on the first screen. Measure startup and later feature readiness separately. Related: B002.

### Parallel independent operations
When operations have no data dependency, compare sequential execution with `Concurrent()`. Related: B003.

### Bulk write shape
Compare table-oriented write operations with row-by-row approaches while preserving validation and error semantics. Related: B004.

### StartScreen vs startup navigation
Measure declarative initial-screen selection against navigation logic coupled to startup work. Related: B005.

### Narrow query payloads
Measure whether retrieving only required columns changes network behavior and readiness for wide Dataverse tables. Related: B006.

### Stable server-generated identifiers
Avoid client-side `max + 1` identifiers for concurrent workloads. Research server-side sequencing, Dataverse-native IDs, alternate keys, and idempotent integration patterns.

## Dataverse and integration

### Alternate-key upsert
Use deterministic external keys when integrating repeatable synthetic batches. Compare single-row upsert patterns with supported bulk APIs in an external-client benchmark.

### Bulk APIs
Research `CreateMultiple`, `UpdateMultiple`, and `UpsertMultiple` for supported tables. Compare throughput, failure behavior, and validation requirements.

### Minimize client/server round-trips
When a workflow repeatedly crosses the client/server boundary, test whether server-side processing or a purpose-built API reduces latency without hiding required business logic.

## Power Automate

### Controlled concurrency
Measure parallelism at several degrees rather than assuming more parallelism is always faster.

### Idempotent processing
Use stable keys and checkpoints so retries do not create duplicate effects.

### Try/Catch/Finally scopes
Separate success, failure, telemetry, and cleanup paths. Benchmark overhead independently from reliability benefits.

### Pagination and cursor-based workloads
For large sources, prefer supported pagination or cursor patterns over attempts to materialize arbitrarily large datasets in a Canvas App.

## Observability

### Correlation IDs
Carry one correlation value across UI action, flow/API call, persistence, and logs.

### Structured Trace
Log benchmark ID, run ID, pattern, and sanitized numeric measurements rather than concatenated free text.

### Operational history
Keep durable execution history separate from transient UI state.

## ALM

### Environment-neutral configuration
Use environment variables, connection references, and solution-aware deployment patterns rather than embedding environment-specific endpoints in formulas.

### Dev/Test/UAT/Prod validation
Performance measurements should state the environment class. A development-environment result should not be presented as production-capacity evidence.
