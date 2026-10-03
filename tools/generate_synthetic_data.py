#!/usr/bin/env python3
"""Generate deterministic synthetic CSV data for Power Platform benchmarks.

No external packages are required.
"""

from __future__ import annotations

import argparse
import csv
import random
from datetime import date, timedelta
from pathlib import Path


AGENCIES = ("A01", "A02", "A03", "A04", "A05", "A06", "A07", "A08")
CATEGORIES = ("Alpha", "Beta", "Gamma", "Delta")
STATUSES = ("Active", "Pending", "Closed", "Archived")


def generate(output: Path, rows: int, seed: int) -> None:
    rng = random.Random(seed)
    start = date(2024, 1, 1)

    output.parent.mkdir(parents=True, exist_ok=True)

    with output.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.writer(handle)
        writer.writerow(
            ["RecordId", "AgencyCode", "Category", "Status", "Amount", "CreatedDate"]
        )

        for index in range(1, rows + 1):
            writer.writerow(
                [
                    f"R{index:08d}",
                    rng.choice(AGENCIES),
                    rng.choice(CATEGORIES),
                    rng.choice(STATUSES),
                    f"{rng.uniform(10, 10000):.2f}",
                    (start + timedelta(days=rng.randrange(0, 1000))).isoformat(),
                ]
            )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rows", type=int, default=10000)
    parser.add_argument("--seed", type=int, default=42)
    parser.add_argument("--output", type=Path, default=Path("synthetic-data.csv"))
    args = parser.parse_args()

    if args.rows < 1:
        parser.error("--rows must be greater than zero")

    generate(args.output, args.rows, args.seed)
    print(f"Generated {args.rows} rows at {args.output}")


if __name__ == "__main__":
    main()
