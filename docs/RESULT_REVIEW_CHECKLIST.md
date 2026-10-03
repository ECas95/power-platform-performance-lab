# Benchmark Result Review Checklist

Use this checklist before accepting measured results.

## Reproducibility

- [ ] Benchmark ID and repository commit/version are identified.
- [ ] Dataset size and generation method are documented.
- [ ] Compared patterns are functionally equivalent.
- [ ] Warm-up/cold-run handling is documented.
- [ ] Number of measured runs is documented.
- [ ] Raw observations are preserved.

## Correctness

- [ ] Expected and actual records/effects were compared.
- [ ] Missing records were checked.
- [ ] Duplicate effects were checked where writes are involved.
- [ ] Failed runs are marked invalid rather than treated as fast successful runs.
- [ ] Delegation-related tests compare keys/results, not only elapsed time.

## Measurement quality

- [ ] Timing start/end boundaries are defined.
- [ ] Request/retry/throttling evidence is captured where relevant.
- [ ] Summary statistics are derived from raw data.
- [ ] P95 is only reported when the sample size supports it.
- [ ] Interpretation does not exceed the tested conditions.

## Privacy

- [ ] No organization/client name.
- [ ] No tenant or environment ID/URL.
- [ ] No private user name/email.
- [ ] No subscription/resource/connection identifier.
- [ ] No credential, token, connection string, or secret.
- [ ] No production/customer data.
- [ ] Screenshots/exports are sanitized or omitted.

## Evidence level

- [ ] L0: proposal only.
- [ ] L1: documented platform behavior only.
- [ ] L2: limited observation/single environment.
- [ ] L3: repeated benchmark with raw evidence and correctness validation.
- [ ] L4: independent cross-environment reproduction.

Only one level should be claimed, and the summary should explain why.
