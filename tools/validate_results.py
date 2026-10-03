#!/usr/bin/env python3
"""Validate benchmark result CSV files without requiring external packages."""

from __future__ import annotations

import argparse
import csv
from pathlib import Path


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
            for field in ("test_date", "pattern", "variant", "concurrency", "formula_id", "run_number")
            if field in reader.fieldnames
        ]
        seen: set[tuple[str, ...]] = set()

        for row_number, row in enumerate(rows, start=2):
            if "run_number" in reader.fieldnames and not (row.get("run_number") or "").strip():
                errors.append(f"Row {row_number}: run_number is blank")
            if identity_fields:
                identity = tuple((row.get(field) or "").strip() for field in identity_fields)
                if identity in seen:
                    errors.append(f"Row {row_number}: duplicate run identity across {identity_fields}")
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
