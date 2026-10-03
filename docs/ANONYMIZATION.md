# Public Anonymization Standard

This repository is public. Examples must be technically useful without exposing the origin of a real implementation.

## Never publish

- Company, client, agency, department, program, or project names.
- Real user names, email addresses, employee IDs, account IDs, or security identifiers.
- Tenant IDs, subscription IDs, environment IDs, resource IDs, hostnames, IP addresses, database names, or storage account names.
- Connection strings, API keys, tokens, certificates, secrets, or credentials.
- Screenshots containing identifiable tenant or business information.
- Production schemas copied verbatim when they reveal business-specific structures.
- Proprietary business rules, report names, job names, file names, or internal workflow terminology.
- Real production data, even when individual fields appear harmless.

## Generalization rules

Translate real implementation experience into reusable technical patterns.

| Private implementation detail | Public pattern |
|---|---|
| Named internal role | `Admin`, `Operator`, `Viewer` |
| Production job/process name | `Job A`, `Job B`, `BatchExecution` |
| Real business unit | `BusinessUnitCode` |
| Real SQL/Dataverse table | `BenchmarkRecord` |
| Tenant URL | `https://<environment>.crm.dynamics.com` |
| Customer-specific status | `Pending`, `Running`, `Succeeded`, `Failed` |

## Synthetic data

Use generated data with deterministic seeds where possible. Avoid realistic personal names, real email domains, or identifiers that can accidentally match production values.

## Review checklist

- [ ] No identifiable organization or person is named.
- [ ] No tenant/environment/resource identifier is present.
- [ ] No secret or credential is present.
- [ ] Datasets are synthetic or public.
- [ ] Business-specific terminology has been generalized.
- [ ] Screenshots are sanitized or omitted.
- [ ] The example still explains the technical pattern without its original context.
