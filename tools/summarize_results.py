#!/usr/bin/env python3
"""Summarize numeric benchmark results from CSV using only the Python standard library."""

from __future__ import annotations

import argparse
import csv
import math
import statistics
from collections import defaultdict
from pathlib import Path


def percentile(values: list[float], p: float) -> float:
    if not values:
        raise ValueError("values must not be empty")
    ordered = sorted(values)
    if len(ordered) == 1:
        return ordered[0]
    rank = (len(ordered) - 1) * p
    lower = math.floor(rank)
    upper = math.ceil(rank)
    if lower == upper:
        return ordered[lower]
    weight = rank - lower
    return ordered[lower] * (1 - weight) + ordered[upper] * weight


def load_groups(path: Path, group_by: str, metric: str) -> dict[str, list[float]]:
    groups: dict[str, list[float]] = defaultdict(list)
    with path.open(newline="", encoding="utf-8-sig") as handle:
        reader = csv.DictReader(handle)
        if not reader.fieldnames:
            raise ValueError("CSV has no header")
        for required in (group_by, metric):
            if required not in reader.fieldnames:
                raise ValueError(f"Missing required column: {required}")
        for row_number, row in enumerate(reader, start=2):
            group = (row.get(group_by) or "").strip()
            raw = (row.get(metric) or "").strip()
            if not group or not raw:
                continue
            try:
                value = float(raw)
            except ValueError as exc:
                raise ValueError(f"Row {row_number}: {metric} is not numeric: {raw!r}") from exc
            groups[group].append(value)
    return dict(groups)


def summarize(values: list[float]) -> dict[str, float | int]:
    result: dict[str, float | int] = {
        "n": len(values),
        "mean": statistics.fmean(values),
        "median": statistics.median(values),
        "min": min(values),
        "max": max(values),
    }
    if len(values) >= 20:
        result["p95"] = percentile(values, 0.95)
    if len(values) >= 2:
        result["stdev"] = statistics.stdev(values)
    return result


def fmt(value: float | int | None) -> str:
    if value is None:
        return "-"
    if isinstance(value, int):
        return str(value)
    return f"{value:.2f}"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("csv_path", type=Path)
    parser.add_argument("--group-by", default="pattern")
    parser.add_argument("--metric", default="duration_ms")
    args = parser.parse_args()

    groups = load_groups(args.csv_path, args.group_by, args.metric)
    if not groups:
        raise SystemExit("No numeric observations found.")

    print(f"# Summary: {args.csv_path}")
    print()
    print(f"Metric: `{args.metric}`  ")
    print(f"Grouped by: `{args.group_by}`")
    print()
    print("| Group | n | Mean | Median | Min | Max | P95 | Stdev |")
    print("|---|---:|---:|---:|---:|---:|---:|---:|")
    for group in sorted(groups):
        stats = summarize(groups[group])
        print(
            f"| {group} | {fmt(stats['n'])} | {fmt(stats['mean'])} | "
            f"{fmt(stats['median'])} | {fmt(stats['min'])} | {fmt(stats['max'])} | "
            f"{fmt(stats.get('p95'))} | {fmt(stats.get('stdev'))} |"
        )


if __name__ == "__main__":
    main()
