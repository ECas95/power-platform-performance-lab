# Repository Architecture

## Design objective

The repository separates three concerns:

1. **experiment design** — what question is being tested;
2. **execution harness** — how a contributor can reproduce the test;
3. **evidence** — what was actually measured.

This prevents implementation examples from being mistaken for benchmark results.

## Logical architecture

```text
                         ┌─────────────────────┐
                         │ Benchmark catalog   │
                         │ B001 ... B010       │
                         └──────────┬──────────┘
                                    │
                                    v
┌─────────────────────┐   ┌─────────────────────┐   ┌─────────────────────┐
│ Synthetic datasets  │──>│ Execution harness   │──>│ Raw observations    │
│ deterministic seeds │   │ Canvas / Flow / API │   │ CSV + notes         │
└─────────────────────┘   └──────────┬──────────┘   └──────────┬──────────┘
                                      │                         │
                                      v                         v
                            ┌─────────────────────┐    ┌─────────────────────┐
                            │ Monitor / Trace     │    │ Validation tools    │
                            │ request evidence    │    │ privacy + schema    │
                            └─────────────────────┘    └──────────┬──────────┘
                                                                  │
                                                                  v
                                                       ┌─────────────────────┐
                                                       │ Summary + evidence  │
                                                       │ L0 ... L4           │
                                                       └─────────────────────┘
```

## Public-only boundary

The repository owns:

- specifications;
- generic schemas;
- source-controlled scripts;
- local tooling;
- sanitized evidence.

The repository does not own or require:

- a Microsoft tenant;
- a production environment;
- an Entra application;
- persistent Power Platform credentials;
- customer datasets.

## Trust boundary

A contributor may execute a benchmark in an authorized non-production environment, but only sanitized artifacts cross into the public repository.

Raw exports from Live Monitor, browser tools, Dataverse, or Power Automate should be reviewed before publication because they may contain identifiers not required to reproduce the result.

## Tooling boundary

Local Python utilities validate and summarize evidence. They do not simulate Power Platform behavior and therefore cannot promote a benchmark's Power Platform evidence level by themselves.
