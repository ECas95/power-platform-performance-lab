#!/usr/bin/env python3
"""Scan public benchmark evidence for obvious sensitive identifiers.

This is a guardrail, not a guarantee. Human review remains required.
"""

from __future__ import annotations

import argparse
import re
from pathlib import Path


EMAIL = re.compile(r"(?i)\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b")
POWER_PLATFORM_URL = re.compile(
    r"(?i)https?://[^\s/]+\.(?:crm\d*\.dynamics\.com|powerapps\.com|powerautomate\.com)(?:/[^\s]*)?"
)
JWT = re.compile(r"\beyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\b")
BEARER = re.compile(r"(?i)\bBearer\s+[A-Za-z0-9._~+/=-]{20,}")
SECRET_ASSIGNMENT = re.compile(
    r"(?i)\b(?:client[_ -]?secret|accountkey|sharedaccesssignature|password|access[_ -]?token)\s*[:=]\s*[^\s,;]{8,}"
)
GUID_NEAR_PRIVATE_ID = re.compile(
    r"(?i)\b(?:tenant|subscription|environment|client|application)[_ -]?(?:id)?\s*[:=]\s*"
    r"[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\b"
)

ALLOWED_EMAIL_DOMAINS = {"example.com", "example.org", "example.net"}


def scan_text(text: str) -> list[str]:
    findings: list[str] = []

    for match in EMAIL.finditer(text):
        email = match.group(0)
        domain = email.rsplit("@", 1)[-1].lower()
        if domain not in ALLOWED_EMAIL_DOMAINS:
            findings.append(f"email-like value: {email}")

    for label, pattern in (
        ("Power Platform environment URL", POWER_PLATFORM_URL),
        ("JWT-like token", JWT),
        ("Bearer token", BEARER),
        ("secret-like assignment", SECRET_ASSIGNMENT),
        ("private identifier assignment", GUID_NEAR_PRIVATE_ID),
    ):
        for match in pattern.finditer(text):
            value = match.group(0)
            if "<environment>" in value.lower():
                continue
            findings.append(f"{label}: {value[:160]}")

    return findings


def scan_file(path: Path) -> list[str]:
    text = path.read_text(encoding="utf-8", errors="replace")
    return scan_text(text)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("paths", nargs="+", type=Path)
    args = parser.parse_args()

    failed = False
    for path in args.paths:
        findings = scan_file(path)
        if findings:
            failed = True
            print(f"{path}:")
            for finding in findings:
                print(f"  - {finding}")
        else:
            print(f"{path}: OK")

    raise SystemExit(1 if failed else 0)


if __name__ == "__main__":
    main()
