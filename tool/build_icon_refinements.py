#!/usr/bin/env python3
"""Generate 5 refinements of Flexify icon #7 and 5 refinements of icon #8."""

from __future__ import annotations

import argparse
import shutil
import subprocess
import tempfile
import zipfile
from pathlib import Path

from PIL import Image, ImageDraw

from build_icon_redesigns import (
    ANDROID_JAR,
    BUILD_TOOLS,
    CLASSIC,
    SOFT,
    ANGULAR,
    Design,
    PathSpec,
    android_vector_for,
    ensure_debug_keystore,
    find_font,
    render_svg,
    run,
    svg_for,
)

ROOT = Path(__file__).resolve().parents[1]
ASSET_DIR = ROOT / "assets" / "icon_redesigns" / "refinements"

REFINEMENTS: tuple[tuple[str, Design], ...] = (
    (
        "07A",
        Design(
            "07a-taut-arc",
            "07A Taut Arc",
            "A cleaner, slightly lighter version of #7 with longer, tighter arcs.",
            (
                PathSpec(
                    "M34 77 C30 67 35 55 40 44 C44 35 49 30 57 29",
                    stroke="#FFFFFF",
                    stroke_width=8.3,
                ),
                PathSpec(
                    "M46 60 C57 51 70 52 81 61",
                    stroke="#FFFFFF",
                    stroke_width=8.3,
                ),
                PathSpec(
                    "M32 77 C40 85 52 84 60 76",
                    stroke="#FFFFFF",
                    stroke_width=8.3,
                ),
            ),
            scale=0.77,
        ),
    ),
    (
        "07B",
        Design(
            "07b-hook-arc",
            "07B Hook Arc",
            "A hooked wrist and rounder bicep, still reduced to three bold strokes.",
            (
                PathSpec(
                    "M32 78 C29 68 34 56 39 45 C43 36 48 31 55 29 "
                    "C59 28 62 30 63 33 C64 36 61 39 58 40",
                    stroke="#FFFFFF",
                    stroke_width=8.7,
                ),
                PathSpec(
                    "M45 61 C55 53 67 51 78 57 C82 59 85 62 87 66",
                    stroke="#FFFFFF",
                    stroke_width=8.7,
                ),
                PathSpec(
                    "M31 78 C39 86 50 86 59 79 C64 75 68 72 73 72",
                    stroke="#FFFFFF",
                    stroke_width=8.7,
                ),
            ),
            scale=0.75,
        ),
    ),
    (
        "07C",
        Design(
            "07c-compact-arc",
            "07C Compact Arc",
            "A shorter, thicker, more compact #7 tuned for small launcher sizes.",
            (
                PathSpec(
                    "M36 75 C33 65 37 55 42 46 C46 38 50 34 57 32",
                    stroke="#FFFFFF",
                    stroke_width=10.5,
                ),
                PathSpec(
                    "M48 60 C58 53 69 54 78 62",
                    stroke="#FFFFFF",
                    stroke_width=10.5,
                ),
                PathSpec(
                    "M35 76 C42 82 51 82 58 76",
                    stroke="#FFFFFF",
                    stroke_width=10.5,
                ),
            ),
            scale=0.76,
        ),
    ),
    (
        "07D",
        Design(
            "07d-sweep-arc",
            "07D Sweep Arc",
            "A longer lower sweep and more open negative space than #7.",
            (
                PathSpec(
                    "M31 78 C28 68 33 55 39 43 C43 35 49 30 57 28",
                    stroke="#FFFFFF",
                    stroke_width=8.2,
                ),
                PathSpec(
                    "M46 61 C58 51 72 52 83 61",
                    stroke="#FFFFFF",
                    stroke_width=8.2,
                ),
                PathSpec(
                    "M29 78 C40 88 54 87 65 78 C70 74 76 72 82 74",
                    stroke="#FFFFFF",
                    stroke_width=8.2,
                ),
            ),
            scale=0.75,
        ),
    ),
    (
        "07E",
        Design(
            "07e-two-stroke",
            "07E Two Stroke",
            "An ultra-minimal #7 reduced to only the arm contour and one muscle sweep.",
            (
                PathSpec(
                    "M31 79 C27 68 33 54 39 42 C43 34 49 29 57 28 "
                    "C61 28 64 30 64 34 C64 37 61 40 57 41 "
                    "C53 42 50 46 49 52 C48 58 48 63 50 68 "
                    "C55 58 64 53 73 54 C82 55 88 62 89 70 "
                    "C90 78 84 84 76 85",
                    stroke="#FFFFFF",
                    stroke_width=8.8,
                ),
                PathSpec(
                    "M31 79 C40 87 51 86 59 79 C65 73 72 70 79 73",
                    stroke="#FFFFFF",
                    stroke_width=8.8,
                ),
            ),
            scale=0.74,
        ),
    ),
    (
        "08A",
        Design(
            "08a-clean-contour",
            "08A Clean Contour",
            "A lighter, cleaner #8 with one restrained inner muscle accent.",
            (
                PathSpec(CLASSIC, stroke="#FFFFFF", stroke_width=5.2),
                PathSpec(
                    "M53 61 C61 57 70 58 77 64",
                    stroke="#FFFFFF",
                    stroke_width=3.1,
                ),
            ),
            scale=0.75,
        ),
    ),
    (
        "08B",
        Design(
            "08b-bold-contour",
            "08B Bold Contour",
            "A heavier #8 outline with a stronger inner accent for launcher readability.",
            (
                PathSpec(CLASSIC, stroke="#FFFFFF", stroke_width=7.2),
                PathSpec(
                    "M53 61 C61 57 70 58 77 64",
                    stroke="#FFFFFF",
                    stroke_width=4.6,
                ),
            ),
            scale=0.72,
        ),
    ),
    (
        "08C",
        Design(
            "08c-double-accent",
            "08C Double Accent",
            "Classic #8 outline with two small muscle accents for extra definition.",
            (
                PathSpec(CLASSIC, stroke="#FFFFFF", stroke_width=5.7),
                PathSpec(
                    "M52 60 C60 55 69 56 77 62",
                    stroke="#FFFFFF",
                    stroke_width=3.4,
                ),
                PathSpec(
                    "M41 68 C44 73 49 76 55 77",
                    stroke="#FFFFFF",
                    stroke_width=3.4,
                ),
            ),
            scale=0.74,
        ),
    ),
    (
        "08D",
        Design(
            "08d-soft-contour",
            "08D Soft Contour",
            "A rounder #8 based on the soft silhouette with a flowing inner accent.",
            (
                PathSpec(SOFT, stroke="#FFFFFF", stroke_width=5.8),
                PathSpec(
                    "M50 61 C58 55 68 55 77 62",
                    stroke="#FFFFFF",
                    stroke_width=3.6,
                ),
            ),
            scale=0.74,
        ),
    ),
    (
        "08E",
        Design(
            "08e-angular-contour",
            "08E Angular Contour",
            "A sharper geometric #8 that keeps the outline-and-accent language.",
            (
                PathSpec(ANGULAR, stroke="#FFFFFF", stroke_width=5.7),
                PathSpec(
                    "M53 61 L62 56 L72 58 L79 64",
                    stroke="#FFFFFF",
                    stroke_width=3.5,
                    linejoin="round",
                ),
            ),
            scale=0.71,
        ),
    ),
)


def generate_assets() -> None:
    if ASSET_DIR.exists():
        shutil.rmtree(ASSET_DIR)
    preview_dir = ASSET_DIR / "previews"
    preview_dir.mkdir(parents=True)

    previews: list[tuple[str, Design, Path]] = []
    for code, design in REFINEMENTS:
        svg_path = ASSET_DIR / f"{code}-{design.slug}.svg"
        png_path = preview_dir / f"{code}-{design.slug}.png"
        svg_path.write_text(svg_for(design), encoding="utf-8")
        render_svg(svg_path, png_path, 512)
        previews.append((code, design, png_path))

    sheet = Image.new("RGB", (1500, 700), "white")
    draw = ImageDraw.Draw(sheet)
    title_font = find_font(20)
    code_font = find_font(24)
    for offset, (code, design, png_path) in enumerate(previews):
        row, col = divmod(offset, 5)
        x, y = col * 300, row * 350
        with Image.open(png_path) as icon:
            icon = icon.convert("RGB").resize((240, 240), Image.Resampling.LANCZOS)
            sheet.paste(icon, (x + 30, y + 18))
        draw.text((x + 30, y + 272), code, fill="black", font=code_font)
        draw.text((x + 90, y + 276), design.title[4:], fill="black", font=title_font)
    sheet.save(ASSET_DIR / "contact-sheet.png", quality=95)

    lines = [
        "# Flexify #7/#8 refinements",
        "",
        "Five refinements of icon #7 (Minimal Arc) followed by five refinements of",
        "icon #8 (Contour Accent). All artwork stays inside the adaptive-icon safe area.",
        "",
        "| Code | Design | Intent |",
        "|---|---|---|",
    ]
    for code, design in REFINEMENTS:
        lines.append(f"| {code} | {design.title} | {design.description} |")
    lines += [
        "",
        "Generate assets:",
        "",
        "    python tool/build_icon_refinements.py",
        "",
        "Build side-by-side comparison APKs:",
        "",
        "    python tool/build_icon_refinements.py --build-apks ~/Downloads/flexify-icon-refinements",
    ]
    (ASSET_DIR / "README.md").write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_project(work: Path, code: str, design: Design, preview: Path) -> tuple[str, Path]:
    suffix = code.lower()
    package = f"com.presley.flexify.icon{suffix}"
    label = f"Flexify {code}"
    res = work / "res"
    (res / "drawable").mkdir(parents=True)
    (res / "mipmap-anydpi-v26").mkdir(parents=True)
    for density in ("mdpi", "hdpi", "xhdpi", "xxhdpi", "xxxhdpi"):
        (res / f"mipmap-{density}").mkdir(parents=True)
    (res / "values").mkdir(parents=True)

    vector = android_vector_for(design)
    (res / "drawable" / "ic_launcher_foreground.xml").write_text(vector, encoding="utf-8")
    (res / "drawable" / "ic_launcher_monochrome.xml").write_text(vector, encoding="utf-8")
    (res / "values" / "colors.xml").write_text(
        '<resources><color name="icon_background">#000000</color></resources>\n',
        encoding="utf-8",
    )
    adaptive = (
        '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
        '  <background android:drawable="@color/icon_background"/>\n'
        '  <foreground android:drawable="@drawable/ic_launcher_foreground"/>\n'
        '  <monochrome android:drawable="@drawable/ic_launcher_monochrome"/>\n'
        '</adaptive-icon>\n'
    )
    (res / "mipmap-anydpi-v26" / "ic_launcher.xml").write_text(adaptive, encoding="utf-8")
    (res / "mipmap-anydpi-v26" / "ic_launcher_round.xml").write_text(adaptive, encoding="utf-8")

    sizes = {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}
    with Image.open(preview) as source:
        source = source.convert("RGBA")
        for density, size in sizes.items():
            source.resize((size, size), Image.Resampling.LANCZOS).save(
                res / f"mipmap-{density}" / "ic_launcher.png"
            )

    manifest = f"""<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="{package}">
    <uses-sdk android:minSdkVersion="26" android:targetSdkVersion="37"/>
    <application
        android:theme="@android:style/Theme.Material.Light.NoActionBar"
        android:label="{label}"
        android:icon="@mipmap/ic_launcher"
        android:roundIcon="@mipmap/ic_launcher_round">
        <activity android:name=".MainActivity" android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
    </application>
</manifest>
"""
    (work / "AndroidManifest.xml").write_text(manifest, encoding="utf-8")

    java_dir = work / "src" / Path(*package.split("."))
    java_dir.mkdir(parents=True)
    java_file = java_dir / "MainActivity.java"
    java_file.write_text(
        f"""package {package};

import android.app.Activity;
import android.os.Bundle;
import android.graphics.Color;
import android.view.Gravity;
import android.widget.TextView;

public final class MainActivity extends Activity {{
    @Override
    protected void onCreate(Bundle state) {{
        super.onCreate(state);
        TextView view = new TextView(this);
        view.setText("{label}\\n{design.title}");
        view.setTextSize(28);
        view.setTextColor(Color.WHITE);
        view.setBackgroundColor(Color.BLACK);
        view.setGravity(Gravity.CENTER);
        setContentView(view);
    }}
}}
""",
        encoding="utf-8",
    )
    return package, java_file


def build_one(output_dir: Path, ordinal: int, code: str, design: Design) -> Path:
    preview = ASSET_DIR / "previews" / f"{code}-{design.slug}.png"
    output_dir.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix=f"flexify-{code.lower()}-") as temp:
        work = Path(temp)
        package, java_file = write_project(work, code, design, preview)

        classes = work / "classes"
        classes.mkdir()
        run([
            "javac", "-source", "8", "-target", "8", "-classpath", str(ANDROID_JAR),
            "-d", str(classes), str(java_file),
        ])

        dex_dir = work / "dex"
        dex_dir.mkdir()
        class_file = classes / Path(*package.split(".")) / "MainActivity.class"
        run([
            str(BUILD_TOOLS / "d8"), "--lib", str(ANDROID_JAR),
            "--output", str(dex_dir), str(class_file),
        ])

        compiled = work / "compiled.zip"
        run([
            str(BUILD_TOOLS / "aapt2"), "compile", "--dir", str(work / "res"),
            "-o", str(compiled),
        ])

        unsigned = work / "unsigned.apk"
        run([
            str(BUILD_TOOLS / "aapt2"), "link", "-o", str(unsigned),
            "-I", str(ANDROID_JAR), "--manifest", str(work / "AndroidManifest.xml"),
            "--min-sdk-version", "26", "--target-sdk-version", "37",
            "--version-code", str(300 + ordinal), "--version-name", "1.0",
            str(compiled),
        ])

        with zipfile.ZipFile(unsigned, "a", compression=zipfile.ZIP_DEFLATED) as apk:
            apk.write(dex_dir / "classes.dex", "classes.dex")

        aligned = work / "aligned.apk"
        run([str(BUILD_TOOLS / "zipalign"), "-f", "4", str(unsigned), str(aligned)])
        destination = output_dir / f"Flexify-{code}-{design.slug}.apk"
        shutil.copy2(aligned, destination)

        keystore = ensure_debug_keystore()
        run([
            str(BUILD_TOOLS / "apksigner"), "sign", "--ks", str(keystore),
            "--ks-key-alias", "androiddebugkey", "--ks-pass", "pass:android",
            "--key-pass", "pass:android", str(destination),
        ])
        run([str(BUILD_TOOLS / "apksigner"), "verify", "--verbose", str(destination)])
        return destination


def build_apks(output_root: Path) -> None:
    if output_root.exists():
        shutil.rmtree(output_root)
    apk_dir = output_root / "apks"
    apk_dir.mkdir(parents=True)
    shutil.copy2(ASSET_DIR / "contact-sheet.png", output_root / "contact-sheet.png")

    for ordinal, (code, design) in enumerate(REFINEMENTS, start=1):
        print(f"Building {code} {design.title}", flush=True)
        build_one(apk_dir, ordinal, code, design)

    lines = [
        "Flexify #7/#8 refinement APKs",
        "==============================",
        "",
        "Ten launcher-only comparison APKs:",
        "five variations of #7 and five variations of #8.",
        "",
    ]
    for code, design in REFINEMENTS:
        lines.append(
            f"{code}. {design.title:<20} com.presley.flexify.icon{code.lower()} "
            f"Flexify-{code}-{design.slug}.apk"
        )
    (output_root / "README.txt").write_text("\n".join(lines) + "\n", encoding="utf-8")
    shutil.make_archive(str(output_root), "zip", root_dir=output_root)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--build-apks", type=Path, metavar="OUTPUT_DIR")
    args = parser.parse_args()
    generate_assets()
    if args.build_apks:
        build_apks(args.build_apks.expanduser().resolve())


if __name__ == "__main__":
    main()
