from __future__ import annotations

import csv
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))

import summarize_results
import validate_results


class SummarizeResultsTests(unittest.TestCase):
    def test_summary_statistics(self):
        stats = summarize_results.summarize([10.0, 20.0, 30.0])
        self.assertEqual(stats["n"], 3)
        self.assertEqual(stats["median"], 20.0)
        self.assertEqual(stats["min"], 10.0)
        self.assertEqual(stats["max"], 30.0)

    def test_percentile_single_value(self):
        self.assertEqual(summarize_results.percentile([5.0], 0.95), 5.0)


class ValidateResultsTests(unittest.TestCase):
    def test_empty_template_is_valid_when_run_number_exists(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "raw.csv"
            path.write_text("test_date,pattern,run_number,duration_ms\n", encoding="utf-8")
            self.assertEqual(validate_results.validate(path), [])

    def test_duplicate_run_identity_is_detected(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "raw.csv"
            with path.open("w", newline="", encoding="utf-8") as handle:
                writer = csv.writer(handle)
                writer.writerow(["test_date", "pattern", "run_number", "duration_ms"])
                writer.writerow(["2026-01-01", "A", "1", "100"])
                writer.writerow(["2026-01-01", "A", "1", "110"])
            problems = validate_results.validate(path)
            self.assertTrue(any("duplicate run identity" in p for p in problems))


if __name__ == "__main__":
    unittest.main()
