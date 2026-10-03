# Independent calls: sequential vs Concurrent

This sample defines an experiment rather than asserting a winner.

## Scenario

An app must obtain several independent datasets during the same operation. None of the calls depends on the result of another.

### Sequential baseline

```powerfx
ClearCollect(colA, DataSourceA);
ClearCollect(colB, DataSourceB);
ClearCollect(colC, DataSourceC)
```

### Concurrent candidate

```powerfx
Concurrent(
    ClearCollect(colA, DataSourceA),
    ClearCollect(colB, DataSourceB),
    ClearCollect(colC, DataSourceC)
)
```

## Validation

Before comparing elapsed time, confirm:

- all three datasets are independent;
- both implementations return equivalent data;
- errors are captured consistently;
- connector throttling or service limits are recorded.

The measured outcome belongs in a benchmark result, not in this sample.
