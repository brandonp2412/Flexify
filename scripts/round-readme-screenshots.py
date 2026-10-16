#!/usr/bin/env python3
"""Regenerate GitHub README screenshots, leaving store screenshots unchanged."""

from pathlib import Path
from PIL import Image, ImageChops, ImageDraw

root = Path(__file__).resolve().parents[1]
source = root / "fastlane/metadata/android/en-US/images/phoneScreenshots"
target = root / "docs/screenshots"
images = sorted(source.glob("*_en-US.png"))
if not images:
    raise SystemExit(f"No phone screenshots in {source}")
target.mkdir(parents=True, exist_ok=True)
for path in images:
    with Image.open(path) as screenshot:
        image = screenshot.convert("RGBA")
    width, height = image.size
    scale = 4
    mask = Image.new("L", (width * scale, height * scale))
    ImageDraw.Draw(mask).rounded_rectangle(
        (0, 0, width * scale - 1, height * scale - 1),
        radius=round(width * 0.08 * scale),
        fill=255,
    )
    image.putalpha(
        ImageChops.multiply(
            image.getchannel("A"), mask.resize(image.size, Image.Resampling.LANCZOS)
        )
    )
    image.save(target / path.name, optimize=True)
for stale in target.glob("*_en-US.png"):
    if stale.name not in {image.name for image in images}:
        stale.unlink()
print(f"Generated {len(images)} rounded README screenshots in {target}")
