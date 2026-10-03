# Project Status

## Public v1 baseline

Status: **complete**

The repository now provides the full public infrastructure needed to design, review, reproduce, and accept Power Platform performance benchmarks without requiring the repository owner to connect private Microsoft infrastructure.

Completed areas:

- B001-B010 experiment definitions;
- benchmark methodology;
- evidence-level model;
- anonymization policy;
- community validation process;
- Canvas App benchmark runner specification;
- generic Dataverse schema;
- optional bootstrap/seed/validation scripts;
- deterministic local data generator;
- result validator;
- descriptive statistics summarizer;
- privacy guardrail scanner;
- Python unit tests;
- public GitHub Actions checks;
- PowerShell syntax validation;
- contribution, security, support, architecture, and roadmap documentation.

## Runtime evidence

Status: **open / community-driven**

B001-B010 intentionally remain at their current evidence levels until real Power Platform measurements are submitted.

This is not a missing implementation artifact. It is an evidence requirement.

The project will not:

- invent timings;
- use simulated local timings as Canvas/Dataverse/Power Automate evidence;
- require the repository owner to publish a tenant or environment;
- copy private client/project measurements into the public repository.

## Definition of done for a measured benchmark

A benchmark can be considered measured when it has:

1. real execution in an authorized environment;
2. synthetic/public test data;
3. repeated raw observations;
4. correctness validation;
5. sanitized environment metadata;
6. summary statistics derived from raw data;
7. limitations;
8. evidence-level justification.

## Current execution issues

Runtime-validation issues remain open so contributors can supply real evidence without blocking the public baseline.
