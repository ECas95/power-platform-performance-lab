# Benchmark Record schema

Suggested logical name: `pppl_benchmarkrecord`.

| Column | Suggested type | Notes |
|---|---|---|
| BenchmarkRecordId | GUID primary key | Dataverse-generated |
| ExternalKey | Text, alternate key | Deterministic `R00000001` identifier |
| BusinessUnitCode | Text | Synthetic category |
| Category | Text/Choice | Synthetic classification |
| Status | Text/Choice | Active, Pending, Closed, Archived |
| Amount | Decimal/Currency | Synthetic numeric payload |
| EffectiveDate | Date only | Synthetic date |
| SequenceNumber | Whole number | Range/filter tests |
| PayloadText | Multiline text | Optional wide-row tests |
| IsSelected | Yes/No | Boolean filter tests |

## Dataset profiles

Generate at least 500, 2,000, 10,000, and 50,000 rows. Use dedicated datasets for destructive write-throughput tests.

Document any alternate key or table configuration that materially affects a test.
