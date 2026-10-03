from __future__ import annotations

import csv
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))

import generate_synthetic_data
import privacy_scan
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

    def test_p95_is_added_for_twenty_or_more_samples(self):
        stats = summarize_results.summarize([float(i) for i in range(1, 21)])
        self.assertIn("p95", stats)


class SyntheticDataTests(unittest.TestCase):
    def test_generation_is_deterministic_for_same_seed(self):
        with tempfile.TemporaryDirectory() as directory:
            first = Path(directory) / "first.csv"
            second = Path(directory) / "second.csv"

            generate_synthetic_data.generate(first, 20, 42)
            generate_synthetic_data.generate(second, 20, 42)

            self.assertEqual(first.read_bytes(), second.read_bytes())

    def test_different_seed_changes_generated_data(self):
        with tempfile.TemporaryDirectory() as directory:
            first = Path(directory) / "first.csv"
            second = Path(directory) / "second.csv"

            generate_synthetic_data.generate(first, 20, 42)
            generate_synthetic_data.generate(second, 20, 43)

            self.assertNotEqual(first.read_bytes(), second.read_bytes())


class ValidateResultsTests(unittest.TestCase):
    def test_empty_template_is_valid_when_run_number_exists(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "raw.csv"
            path.write_text(
                "test_date,pattern,run_number,duration_ms\n",
                encoding="utf-8",
            )
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

    def test_invalid_date_is_detected(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "raw.csv"
            path.write_text(
                "test_date,pattern,run_number,duration_ms\n"
                "01/31/2026,A,1,100\n",
                encoding="utf-8",
            )
            problems = validate_results.validate(path)
            self.assertTrue(any("ISO YYYY-MM-DD" in p for p in problems))

    def test_negative_duration_is_detected(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "raw.csv"
            path.write_text(
                "test_date,pattern,run_number,duration_ms\n"
                "2026-01-31,A,1,-5\n",
                encoding="utf-8",
            )
            problems = validate_results.validate(path)
            self.assertTrue(any("duration_ms" in p for p in problems))

    def test_non_integer_run_number_is_detected(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "raw.csv"
            path.write_text(
                "test_date,pattern,run_number,duration_ms\n"
                "2026-01-31,A,1.5,5\n",
                encoding="utf-8",
            )
            problems = validate_results.validate(path)
            self.assertTrue(any("run_number" in p for p in problems))


class PrivacyScanTests(unittest.TestCase):
    def test_normal_public_result_text_passes(self):
        text = "test_date,pattern,notes\n2026-01-01,A,synthetic dataset\n"
        self.assertEqual(privacy_scan.scan_text(text), [])

    def test_private_email_is_detected(self):
        findings = privacy_scan.scan_text("owner=person@private-company.test")
        self.assertTrue(any("email-like value" in finding for finding in findings))

    def test_example_email_is_allowed(self):
        self.assertEqual(privacy_scan.scan_text("owner=user@example.com"), [])

    def test_power_platform_environment_url_is_detected(self):
        findings = privacy_scan.scan_text(
            "https://contoso-dev.crm.dynamics.com/api/data/v9.2"
        )
        self.assertTrue(
            any("Power Platform environment URL" in finding for finding in findings)
        )

    def test_placeholder_environment_url_is_allowed(self):
        self.assertEqual(
            privacy_scan.scan_text("https://<environment>.crm.dynamics.com"),
            [],
        )

    def test_secret_like_assignment_is_detected(self):
        findings = privacy_scan.scan_text("client_secret=supersecretvalue123")
        self.assertTrue(
            any("secret-like assignment" in finding for finding in findings)
        )


if __name__ == "__main__":
    unittest.main()
