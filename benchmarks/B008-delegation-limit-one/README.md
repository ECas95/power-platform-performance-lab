# B008 — Data row limit = 1 as a delegation test guardrail

## Question
How effective is setting the Canvas App nondelegable data row limit to `1` at exposing formulas that accidentally depend on local processing?

## Status
L0 — experiment design.

## Procedure

1. Prepare a source with matches beyond the first source row.
2. Set the app data row limit to `1`.
3. Execute a known-delegable query and validate expected keys.
4. Execute candidate formulas under review.
5. Record which formulas fail correctness validation.
6. Repeat with the normal development setting for comparison.

## Outcome

This benchmark is primarily about defect detection rather than speed. Record expected and actual keys/counts, delegation warnings, and whether the guardrail exposed the defect.

## Safety

Do not present the row-limit setting as a production performance recommendation.
