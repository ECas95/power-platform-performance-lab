# Optional Dataverse bootstrap scripts

These scripts are public reference tooling for contributors who already have authorized access to a non-production Dataverse environment.

They are **not required** by the repository maintainer and are **not run by CI**.

## What they do

- create the generic publisher/solution;
- create Benchmark Record and Benchmark Run tables;
- create generic benchmark columns;
- publish metadata;
- seed deterministic synthetic records;
- validate the expected metadata.

## Local use by a contributor

Prerequisites:

- Power Platform CLI (`pac`);
- authorized access to a non-production Dataverse environment;
- permission to create solution components.

Authenticate locally:

```powershell
pac auth create --environment "https://<environment>.crm.dynamics.com"
```

Bootstrap:

```powershell
./power-platform/bootstrap/Bootstrap-PerformanceLab.ps1 \
  -EnvironmentUrl "https://<environment>.crm.dynamics.com"
```

Validate:

```powershell
./power-platform/bootstrap/Test-PerformanceLab.ps1 \
  -EnvironmentUrl "https://<environment>.crm.dynamics.com"
```

Seed deterministic synthetic data:

```powershell
./power-platform/bootstrap/Seed-PerformanceLab.ps1 \
  -EnvironmentUrl "https://<environment>.crm.dynamics.com" \
  -Count 10000 \
  -Seed 42
```

## Public-repository rule

Do not commit:

- environment URLs;
- tenant/client IDs;
- app registration details;
- access tokens;
- user identifiers;
- organization names;
- production data.

Only sanitized benchmark outputs should be contributed back to the repository.

See [../../community-validation/README.md](../../community-validation/README.md).
