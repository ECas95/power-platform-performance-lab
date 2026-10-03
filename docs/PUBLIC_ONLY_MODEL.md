# Public-only project model

This repository is designed so the maintainer does not need to connect a private Microsoft tenant, Dataverse environment, Entra application, client secret, tenant ID, or production account.

## What is public

Everything committed here is public and reusable:

- benchmark definitions;
- synthetic data generators;
- Power Fx snippets and app build specifications;
- generic Dataverse schemas;
- PowerShell bootstrap scripts;
- result-validation utilities;
- CI checks that do not require Microsoft credentials;
- community-submitted sanitized benchmark results.

## What is not required from the maintainer

The repository does **not** require the maintainer to configure:

- `POWERPLATFORM_TENANT_ID`;
- `POWERPLATFORM_CLIENT_ID`;
- GitHub OIDC/Federated Identity to Microsoft Entra;
- a Dataverse Application User;
- a private Power Platform environment;
- secrets or environment URLs.

## How real platform validation works

Power Platform is a hosted platform. A benchmark that claims real Canvas App, Dataverse, or Power Automate runtime behavior must eventually be executed in a Power Platform environment.

That execution is contributor-owned, not repository-owner-owned.

A contributor who already has access to a suitable non-production environment can:

1. use the public bootstrap scripts or recreate the generic schema manually;
2. execute one benchmark;
3. sanitize the measurements;
4. submit the raw CSV and methodology through a pull request;
5. include only non-identifying environment metadata.

The repository can therefore accumulate real evidence without the maintainer publishing or provisioning a Microsoft tenant.

## Evidence rule

Until a benchmark receives real sanitized runtime measurements, it remains L0 or L1/L2 as appropriate.

The project never substitutes local simulations for Power Platform runtime evidence.

## Optional bring-your-own-environment scripts

The scripts under `power-platform/bootstrap/` remain public reference tooling.

They are optional conveniences for contributors who already have legitimate access to a test Dataverse environment. They are not required for cloning, using, contributing to, or maintaining this repository.
