#!/usr/bin/env python3
"""Render Wombat color files. Run with --check to detect stale generated files."""

import argparse
import io
import json
from pathlib import Path
import re
import zipfile

theme_dir = Path(__file__).resolve().parent
repo = theme_dir.parent.parent
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--check", action="store_true")
args = parser.parse_args()
palette = json.loads((theme_dir / "palette.json").read_text())
for name, color in palette.items():
    if not re.fullmatch(r"#[0-9a-f]{6}", color):
        raise SystemExit(f"Invalid color for {name}: {color}")

# KDE/Qt palettes store RGB triplets instead of hex colors.
palette.update({name + "_rgb": ",".join(str(int(color[i:i + 2], 16)) for i in (1, 3, 5))
                for name, color in list(palette.items())})

# Resolve every template before writing, so a missing color never gives a partial update.
rendered = []
for template in sorted((theme_dir / "templates").rglob("*.in")):
    target = repo / template.relative_to(theme_dir / "templates").with_suffix("")
    content = re.sub(r"\{\{([a-z_]+)\}\}", lambda m: palette[m[1]], template.read_text())
    if "{{" in content or "}}" in content:
        raise SystemExit(f"Unresolved template expression: {template}")
    rendered.append((target, content.encode()))

# Vivaldi imports a ZIP with settings.json at its root. Keep it reproducible.
vivaldi_settings = theme_dir / "vivaldi/settings.json"
for target, content in list(rendered):
    if target == vivaldi_settings:
        json.loads(content)
        archive = io.BytesIO()
        member = zipfile.ZipInfo("settings.json", date_time=(1980, 1, 1, 0, 0, 0))
        member.compress_type = zipfile.ZIP_DEFLATED
        member.external_attr = 0o644 << 16
        with zipfile.ZipFile(archive, "w") as bundle:
            bundle.writestr(member, content)
        rendered.append((theme_dir / "vivaldi/Wombat-Blue.zip", archive.getvalue()))

stale = []
for target, content in rendered:
    if target.exists() and target.read_bytes() == content:
        continue
    stale.append(str(target.relative_to(repo)))
    if not args.check:
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(content)

if args.check and stale:
    raise SystemExit("Outdated Wombat files:\n" + "\n".join(stale))
print(f"Wombat: {len(rendered)} files checked" if args.check else f"Wombat: {len(stale)} files updated")
