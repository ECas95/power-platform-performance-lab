# Power Platform solution workspace

This folder contains public, environment-neutral reference material for the Power Platform Performance Lab.

## Public-only operating model

The repository maintainer does not need a private Microsoft tenant, Dataverse environment, Entra application, tenant ID, client ID, or stored credential.

See [../docs/PUBLIC_ONLY_MODEL.md](../docs/PUBLIC_ONLY_MODEL.md).

## Target reference solution

- Solution unique name: `PowerPlatformPerformanceLab`
- Publisher unique name: `ppplperformancepublisher`
- Publisher prefix: `pppl`
- Suggested ownership model for benchmark tables: organization-owned
- Data policy: synthetic data only

## Public reference components

The bootstrap scripts describe and can provision, for contributors who already have access to a suitable environment:

- `pppl_benchmarkrecord`
- `pppl_benchmarkrun`

They also define the initial columns required by the benchmark catalog.

These scripts are optional. They are not executed by repository CI and are not required for maintaining or using this project.

## Canvas App

The Canvas benchmark runner is documented as a build specification in [canvas/BUILD_SPEC.md](canvas/BUILD_SPEC.md).

The repository does not fabricate an importable `.pa.yaml` application. A contributor with legitimate Power Apps access may build the app from the public specification, publish it, export supported source, sanitize it, and submit it for review.

## Real benchmark evidence

Real Power Platform runtime measurements are accepted through the public community-validation workflow.

See [../community-validation/README.md](../community-validation/README.md).

This lets the project accumulate real evidence without tying the repository owner to a private Microsoft environment.
