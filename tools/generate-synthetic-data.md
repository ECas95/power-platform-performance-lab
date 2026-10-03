# Synthetic dataset generator

`generate_synthetic_data.py` creates deterministic, non-sensitive CSV data for experiments.

## Usage

```bash
python tools/generate_synthetic_data.py --rows 10000 --output data/benchmark-10000.csv
```

Generate the same dataset again by using the same seed:

```bash
python tools/generate_synthetic_data.py --rows 10000 --seed 42 --output data/benchmark-10000.csv
```

The utility uses only the Python standard library.

## Columns

- `RecordId`
- `AgencyCode`
- `Category`
- `Status`
- `Amount`
- `CreatedDate`

The schema is deliberately generic so experiments do not need real business or customer data.
