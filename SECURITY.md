# Security Policy

## Scope

This repository contains public research material, benchmark tooling, synthetic-data generators, and optional Power Platform bootstrap scripts.

It must never contain live credentials, private tenant information, customer data, or proprietary implementation details.

## Reporting a security issue

Do not open a public issue containing:

- access tokens;
- connection strings;
- tenant or subscription identifiers tied to a private environment;
- private environment URLs;
- customer or user data;
- credentials or secrets of any kind.

If a problem can be described without exposing sensitive material, open a normal GitHub issue with a minimal reproduction.

If sensitive material was accidentally committed, rotate/revoke it first. Removing it from the latest commit does not invalidate a credential that has already been exposed.

## Supported branch

Security fixes target the default `main` branch.

## Public-data rule

Benchmark contributions must use synthetic or otherwise publishable data and follow:

- [Public Anonymization Standard](docs/ANONYMIZATION.md)
- [Community Validation](community-validation/README.md)
