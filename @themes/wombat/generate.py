#!/usr/bin/env python3
"""Render Wombat color files. Run with --check to detect stale generated files."""

import argparse
import json
from pathlib import Path
import re

theme_dir = Path(__file__).resolve().parent
repo = theme_dir.parent.parent
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--check", action="store_true")
args = parser.parse_args()
palette = json.loads((theme_dir / "palette.json").read_text())
for name, color in palette.items():
    if not re.fullmatch(r"#[0-9a-f]{6}", color):
        raise SystemExit(f"Invalid color for {name}: {color}")

# Resolve every template before writing, so a missing color never gives a partial update.
rendered = []
for template in sorted((theme_dir / "templates").rglob("*.in")):
    target = repo / template.relative_to(theme_dir / "templates").with_suffix("")
    content = re.sub(r"\{\{([a-z_]+)\}\}", lambda m: palette[m[1]], template.read_text())
    if "{{" in content or "}}" in content:
        raise SystemExit(f"Unresolved template expression: {template}")
    rendered.append((target, content))

stale = []
for target, content in rendered:
    if target.exists() and target.read_text() == content:
        continue
    stale.append(str(target.relative_to(repo)))
    if not args.check:
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(content)

if args.check and stale:
    raise SystemExit("Outdated Wombat files:\n" + "\n".join(stale))
print(f"Wombat: {len(rendered)} files checked" if args.check else f"Wombat: {len(stale)} files updated")
