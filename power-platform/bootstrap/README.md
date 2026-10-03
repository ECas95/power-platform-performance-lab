# Bootstrap scripts

These scripts create and validate the Dataverse portion of the lab.

## Prerequisites

- Power Platform CLI (`pac`)
- access to a non-production Dataverse environment
- permission to create a publisher, unmanaged solution, tables, and columns

Authenticate first:

```powershell
pac auth create --environment "https://<environment>.crm.dynamics.com"
```

Then bootstrap:

```powershell
./power-platform/bootstrap/Bootstrap-PerformanceLab.ps1 \
  -EnvironmentUrl "https://<environment>.crm.dynamics.com"
```

Validate:

```powershell
./power-platform/bootstrap/Test-PerformanceLab.ps1 \
  -EnvironmentUrl "https://<environment>.crm.dynamics.com"
```

Seed 10,000 deterministic rows:

```powershell
./power-platform/bootstrap/Seed-PerformanceLab.ps1 \
  -EnvironmentUrl "https://<environment>.crm.dynamics.com" \
  -Count 10000 \
  -Seed 42
```

The default dataset tag becomes `seed-42-10000`.

The seed script refuses to intentionally seed the same tag twice unless `-AllowExisting` is supplied.

## Authentication in GitHub Actions

The repository workflow uses GitHub OIDC/Federated Identity rather than storing a Power Platform client secret.

Required repository variables:

- `POWERPLATFORM_TENANT_ID`
- `POWERPLATFORM_CLIENT_ID`

The Entra application must:

- have a federated credential for this repository/workflow context;
- exist as an application user in the target Dataverse environment;
- have sufficient privileges for the bootstrap operation.

The workflow takes the environment URL as a manual input so no real environment address needs to be committed to source control.
