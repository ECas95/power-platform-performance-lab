#!/usr/bin/env python3
"""Validate benchmark result CSV files without requiring external packages."""

from __future__ import annotations

import argparse
import csv
from datetime import date
from pathlib import Path


NON_NEGATIVE_INTEGER_FIELDS = {
    "run_number",
    "request_count",
    "records_returned",
    "dataset_size",
    "batch_size",
    "item_count",
    "succeeded",
    "failed",
    "skipped",
    "retries",
    "throttles",
    "conflicts",
    "attempted_creates",
    "duplicate_business_ids",
    "missing_records",
    "duplicate_records",
    "expected_count",
    "actual_count",
    "source_size",
    "row_count",
    "intended_records",
    "succeeded_records",
    "failed_records",
    "startup_requests",
    "total_requests",
}

NON_NEGATIVE_NUMBER_FIELDS = {
    "duration_ms",
    "screen_visible_ms",
    "screen_usable_ms",
    "primary_data_ms",
    "secondary_feature_ms",
    "initial_usable_ms",
    "time_to_first_batch_ms",
    "items_per_minute",
    "bytes_observed",
}

BOOLEAN_FIELDS = {
    "delegation_warning",
    "defect_detected",
    "duplicate_effects",
}


def _parse_non_negative_int(value: str) -> bool:
    try:
        return int(value) >= 0 and str(int(value)) == value.strip()
    except ValueError:
        return False


def _parse_non_negative_number(value: str) -> bool:
    try:
        return float(value) >= 0
    except ValueError:
        return False


def validate(path: Path) -> list[str]:
    errors: list[str] = []

    with path.open(newline="", encoding="utf-8-sig") as handle:
        reader = csv.DictReader(handle)
        if not reader.fieldnames:
            return ["CSV has no header"]

        if "run_number" not in reader.fieldnames:
            errors.append("Missing run_number column")

        rows = list(reader)
        if not rows:
            return errors

        identity_fields = [
            field
            for field in (
                "test_date",
                "pattern",
                "variant",
                "concurrency",
                "formula_id",
                "subtest",
                "run_number",
            )
            if field in reader.fieldnames
        ]
        seen: set[tuple[str, ...]] = set()

        for row_number, row in enumerate(rows, start=2):
            run_number = (row.get("run_number") or "").strip()
            if "run_number" in reader.fieldnames and not run_number:
                errors.append(f"Row {row_number}: run_number is blank")

            raw_date = (row.get("test_date") or "").strip()
            if raw_date:
                try:
                    date.fromisoformat(raw_date)
                except ValueError:
                    errors.append(
                        f"Row {row_number}: test_date must use ISO YYYY-MM-DD format"
                    )

            for field in NON_NEGATIVE_INTEGER_FIELDS.intersection(reader.fieldnames):
                raw = (row.get(field) or "").strip()
                if raw and not _parse_non_negative_int(raw):
                    errors.append(
                        f"Row {row_number}: {field} must be a non-negative integer"
                    )

            for field in NON_NEGATIVE_NUMBER_FIELDS.intersection(reader.fieldnames):
                raw = (row.get(field) or "").strip()
                if raw and not _parse_non_negative_number(raw):
                    errors.append(
                        f"Row {row_number}: {field} must be a non-negative number"
                    )

            for field in BOOLEAN_FIELDS.intersection(reader.fieldnames):
                raw = (row.get(field) or "").strip().lower()
                if raw and raw not in {"true", "false", "0", "1", "yes", "no"}:
                    errors.append(
                        f"Row {row_number}: {field} must be boolean-like "
                        "(true/false, yes/no, or 1/0)"
                    )

            if identity_fields:
                identity = tuple((row.get(field) or "").strip() for field in identity_fields)
                if identity in seen:
                    errors.append(
                        f"Row {row_number}: duplicate run identity across {identity_fields}"
                    )
                seen.add(identity)

    return errors


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("paths", nargs="+", type=Path)
    args = parser.parse_args()

    failed = False
    for path in args.paths:
        problems = validate(path)
        if problems:
            failed = True
            print(f"{path}:")
            for problem in problems:
                print(f"  - {problem}")
        else:
            print(f"{path}: OK")

    raise SystemExit(1 if failed else 0)


if __name__ == "__main__":
    main()
