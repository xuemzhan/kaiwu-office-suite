#!/usr/bin/env python3
"""Verify installer SHA256 against manifest/SHA256SUMS.txt.
Output: JSON to stdout (parseable by .bat) + human-readable to stderr.
Exit 0 if all match, 1 otherwise.
"""
import hashlib
import json
import sys
from pathlib import Path

BASE = Path(__file__).resolve().parent
SUMS = BASE / "manifest" / "SHA256SUMS.txt"
RAW = BASE / "packages" / "raw"


def sha256_of(p: Path) -> str:
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def parse_sums(p: Path) -> dict[str, str]:
    out = {}
    for line in p.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        parts = line.split()
        if len(parts) >= 2 and not parts[0].startswith("#") and len(parts[0]) == 64:
            out[parts[1]] = parts[0]
    return out


def main() -> int:
    if not SUMS.exists():
        print(json.dumps({"error": f"missing: {SUMS}"}))
        return 1
    if not RAW.exists():
        print(json.dumps({"error": f"missing: {RAW}"}))
        return 1

    sums = parse_sums(SUMS)
    results = []
    total = ok = mismatch = missing = 0
    for name in sorted(sums):
        total += 1
        expected = sums[name]
        path = RAW / name
        if path.exists():
            actual = sha256_of(path)
            if actual.lower() == expected.lower():
                results.append({"name": name, "status": "OK", "expected": expected, "actual": actual})
                ok += 1
            else:
                results.append({"name": name, "status": "FAIL", "expected": expected, "actual": actual})
                mismatch += 1
        else:
            results.append({"name": name, "status": "MISSING", "expected": expected})
            missing += 1

    summary = {"total": total, "ok": ok, "mismatch": mismatch, "missing": missing, "results": results}
    # JSON to stdout (parseable)
    print(json.dumps(summary, ensure_ascii=False, indent=2))

    # Human-readable to stderr
    for r in results:
        if r["status"] == "OK":
            print(f"  [OK]      {r['name']}", file=sys.stderr)
        elif r["status"] == "FAIL":
            print(f"  [FAIL]    {r['name']}", file=sys.stderr)
            print(f"            expected: {r['expected']}", file=sys.stderr)
            print(f"            actual:   {r['actual']}", file=sys.stderr)
        else:
            print(f"  [MISSING] {r['name']}", file=sys.stderr)
    print("", file=sys.stderr)
    print(f"Total: {total}  OK: {ok}  Mismatch: {mismatch}  Missing: {missing}", file=sys.stderr)

    return 0 if mismatch == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
