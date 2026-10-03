# Delegation experiment

## Objective

Compare two functionally equivalent approaches where one attempts to perform filtering at the data source and the other first loads data into a local collection.

The exact formula depends on the connector and supported delegation capabilities, so this sample intentionally avoids presenting one expression as universally delegable.

## Candidate design

### Server-oriented pattern

Apply supported filters directly to the connected data source and retrieve only the required rows/columns.

### Local-processing baseline

Load a broader dataset into a collection and apply equivalent filtering locally.

## Required validation

- Confirm delegation support for the chosen data source and formula.
- Use a dataset large enough to expose correctness differences.
- Compare returned record identifiers, not only record counts.
- Record network activity where observable.
- Document any app data-row limits relevant to the experiment.

Use benchmark B001 for measured results.
