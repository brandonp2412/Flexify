#!/usr/bin/env python3
"""Generate Flexify launcher-icon concepts and optional comparison APKs."""

from __future__ import annotations

import argparse
import shutil
import subprocess
import tempfile
import zipfile
from dataclasses import dataclass
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
ASSET_DIR = ROOT / "assets" / "icon_redesigns"
ANDROID_SDK = Path("/opt/android-sdk")
BUILD_TOOLS = ANDROID_SDK / "build-tools" / "37.0.0"
ANDROID_JAR = ANDROID_SDK / "platforms" / "android-37.0" / "android.jar"


@dataclass(frozen=True)
class PathSpec:
    d: str
    fill: str = "none"
    stroke: str = "none"
    stroke_width: float = 0.0
    linecap: str = "round"
    linejoin: str = "round"


@dataclass(frozen=True)
class Design:
    slug: str
    title: str
    description: str
    paths: tuple[PathSpec, ...]
    scale: float = 0.74
    offset_x: float = 0.0
    offset_y: float = 0.0


CLASSIC = (
    "M29 81 C24 77 22 70 25 63 L35 39 "
    "C38 32 43 27 50 25 L56 23 C60 22 64 25 65 29 "
    "C66 33 64 37 60 39 L54 41 C51 42 49 44 48 48 L45 58 "
    "C51 53 58 50 65 50 C77 50 86 57 89 67 "
    "C92 77 85 86 75 87 C68 88 61 85 56 80 "
    "C49 86 40 88 33 84 Z"
)

SOFT = (
    "M29 80 C21 70 27 58 34 47 L45 28 "
    "C48 23 54 22 59 25 C63 28 63 33 59 36 L52 42 "
    "C49 45 47 50 46 56 C55 51 64 49 72 52 "
    "C82 55 88 64 87 73 C86 82 78 87 69 85 "
    "C63 84 58 80 54 76 C48 82 39 85 29 80 Z"
)

ANGULAR = (
    "M25 79 L34 52 L39 37 L49 24 L61 24 L66 31 "
    "L61 39 L52 41 L48 56 L60 51 L74 52 "
    "L87 61 L90 71 L84 81 L73 86 L63 84 "
    "L55 78 L45 85 L33 85 Z"
)

PEAK = (
    "M27 80 C24 73 26 65 31 56 L40 38 "
    "C44 29 50 22 58 20 C64 19 68 23 68 28 "
    "C68 33 64 37 59 38 L55 39 C51 40 49 43 48 48 L46 58 "
    "C54 51 63 47 72 49 C82 51 89 59 90 68 "
    "C91 77 84 85 75 86 C67 87 61 83 56 78 "
    "C50 85 39 88 31 84 Z"
)

BLOCK = (
    "M28 82 L22 69 L31 45 L42 27 L55 22 L66 29 "
    "L62 39 L52 42 L48 57 L62 49 L78 52 "
    "L89 65 L88 76 L77 87 L64 84 L55 77 L44 87 Z"
)

WIDE = (
    "M23 80 C19 72 22 62 28 52 L38 34 "
    "C42 27 48 23 55 22 C61 21 66 25 66 30 "
    "C66 35 62 39 57 40 L52 42 C49 44 48 49 47 55 "
    "C56 49 65 46 74 49 C85 52 92 61 92 71 "
    "C92 81 84 89 73 89 C65 89 58 85 53 80 "
    "C46 87 35 89 27 85 Z"
)

DESIGNS = (
    Design("solid-swoop", "Solid Swoop", "Compact solid silhouette with a smooth elbow sweep.", (PathSpec(CLASSIC, fill="#FFFFFF"),), scale=0.72),
    Design("fine-outline", "Fine Outline", "Light single-line contour for a very minimal launcher mark.", (PathSpec(CLASSIC, stroke="#FFFFFF", stroke_width=5.2),), scale=0.76),
    Design("angular-cut", "Angular Cut", "Geometric faceted silhouette with crisp corners.", (PathSpec(ANGULAR, fill="#FFFFFF"),), scale=0.70),
    Design("soft-curve", "Soft Curve", "Rounder organic silhouette with a gentler bicep peak.", (PathSpec(SOFT, fill="#FFFFFF"),), scale=0.72),
    Design("peak-flex", "Peak Flex", "Higher bicep peak and narrow wrist for a more athletic profile.", (PathSpec(PEAK, fill="#FFFFFF"),), scale=0.72),
    Design(
        "split-stroke", "Split Stroke", "Two bold strokes that imply the arm without filling the silhouette.",
        (
            PathSpec(
                "M31 77 C28 67 33 56 38 44 C42 34 48 29 56 28 "
                "C62 27 66 30 67 34 C68 39 64 42 59 42 "
                "C54 42 51 45 50 50 L47 59",
                stroke="#FFFFFF", stroke_width=8.2,
            ),
            PathSpec(
                "M47 59 C54 54 61 52 68 53 C78 54 85 61 87 69 "
                "C89 77 84 84 76 85 C68 86 62 82 57 77 "
                "C51 83 40 85 31 77",
                stroke="#FFFFFF", stroke_width=8.2,
            ),
        ),
        scale=0.74,
    ),
    Design(
        "minimal-arc", "Minimal Arc", "Three heavy arcs reduced to the essential bicep gesture.",
        (
            PathSpec("M34 76 C31 66 36 56 40 46 C44 36 49 31 57 30", stroke="#FFFFFF", stroke_width=9.5),
            PathSpec("M47 60 C58 52 71 53 80 61", stroke="#FFFFFF", stroke_width=9.5),
            PathSpec("M32 77 C40 85 51 84 58 77", stroke="#FFFFFF", stroke_width=9.5),
        ),
        scale=0.76,
    ),
    Design(
        "contour-accent", "Contour Accent", "Outlined arm with a short inner muscle accent.",
        (
            PathSpec(CLASSIC, stroke="#FFFFFF", stroke_width=6.2),
            PathSpec("M53 61 C61 57 70 58 77 64", stroke="#FFFFFF", stroke_width=4.0),
        ),
        scale=0.74,
    ),
    Design("block-flex", "Block Flex", "Heavy squared silhouette tuned for tiny launcher sizes.", (PathSpec(BLOCK, fill="#FFFFFF"),), scale=0.70),
    Design("wide-flex", "Wide Flex", "Broad confident silhouette with the fullest bicep shape.", (PathSpec(WIDE, fill="#FFFFFF"),), scale=0.70),
)


def run(argv: list[str], cwd: Path | None = None) -> None:
    subprocess.run(argv, cwd=cwd, check=True)


def svg_for(design: Design) -> str:
    path_lines = []
    for path in design.paths:
        attrs = [f'd="{path.d}"', f'fill="{path.fill}"']
        if path.stroke != "none":
            attrs += [
                f'stroke="{path.stroke}"',
                f'stroke-width="{path.stroke_width}"',
                f'stroke-linecap="{path.linecap}"',
                f'stroke-linejoin="{path.linejoin}"',
            ]
        path_lines.append("    <path " + " ".join(attrs) + "/>")
    transform = (
        f"translate({54 + design.offset_x} {54 + design.offset_y}) "
        f"scale({design.scale}) translate(-54 -54)"
    )
    return (
        '<svg xmlns="http://www.w3.org/2000/svg" width="108" height="108" viewBox="0 0 108 108">\n'
        '  <rect width="108" height="108" rx="24" fill="#000000"/>\n'
        f'  <g transform="{transform}">\n'
        + "\n".join(path_lines)
        + "\n  </g>\n</svg>\n"
    )


def android_vector_for(design: Design) -> str:
    path_lines = []
    for path in design.paths:
        fill = "#00000000" if path.fill == "none" else "#FFFFFFFF"
        attrs = [f'android:pathData="{path.d}"', f'android:fillColor="{fill}"']
        if path.stroke != "none":
            attrs += [
                'android:strokeColor="#FFFFFFFF"',
                f'android:strokeWidth="{path.stroke_width}"',
                f'android:strokeLineCap="{path.linecap}"',
                f'android:strokeLineJoin="{path.linejoin}"',
            ]
        path_lines.append("        <path\n            " + "\n            ".join(attrs) + "/>")
    return (
        '<vector xmlns:android="http://schemas.android.com/apk/res/android"\n'
        '    android:width="108dp"\n'
        '    android:height="108dp"\n'
        '    android:viewportWidth="108"\n'
        '    android:viewportHeight="108">\n'
        f'    <group android:pivotX="54" android:pivotY="54" '
        f'android:scaleX="{design.scale}" android:scaleY="{design.scale}" '
        f'android:translateX="{design.offset_x}" android:translateY="{design.offset_y}">\n'
        + "\n".join(path_lines)
        + "\n    </group>\n</vector>\n"
    )


def render_svg(svg_path: Path, png_path: Path, size: int) -> None:
    renderer = shutil.which("rsvg-convert")
    if renderer is None:
        raise RuntimeError("rsvg-convert is required")
    run([renderer, "-w", str(size), "-h", str(size), "-o", str(png_path), str(svg_path)])


def find_font(size: int):
    for path in (
        Path("/usr/share/fonts/TTF/DejaVuSans.ttf"),
        Path("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"),
        Path("/usr/share/fonts/noto/NotoSans-Regular.ttf"),
    ):
        if path.exists():
            return ImageFont.truetype(str(path), size)
    return ImageFont.load_default()


def generate_assets() -> None:
    ASSET_DIR.mkdir(parents=True, exist_ok=True)
    preview_dir = ASSET_DIR / "previews"
    preview_dir.mkdir(exist_ok=True)

    previews = []
    for index, design in enumerate(DESIGNS, start=1):
        svg_path = ASSET_DIR / f"{index:02d}-{design.slug}.svg"
        png_path = preview_dir / f"{index:02d}-{design.slug}.png"
        svg_path.write_text(svg_for(design), encoding="utf-8")
        render_svg(svg_path, png_path, 512)
        previews.append((index, design, png_path))

    sheet = Image.new("RGB", (1500, 700), "white")
    draw = ImageDraw.Draw(sheet)
    title_font = find_font(21)
    number_font = find_font(24)
    for offset, (index, design, png_path) in enumerate(previews):
        row, col = divmod(offset, 5)
        x, y = col * 300, row * 350
        with Image.open(png_path) as icon:
            icon = icon.convert("RGB").resize((240, 240), Image.Resampling.LANCZOS)
            sheet.paste(icon, (x + 30, y + 18))
        draw.text((x + 30, y + 272), f"{index:02d}", fill="black", font=number_font)
        draw.text((x + 74, y + 276), design.title, fill="black", font=title_font)
    sheet.save(ASSET_DIR / "contact-sheet.png", quality=95)

    readme = [
        "# Flexify icon redesigns", "",
        "Ten monochrome flexing-bicep launcher concepts. Each source SVG is 108x108 and",
        "uses a black rounded-square preview background with white artwork. The artwork",
        "is deliberately inset into the Android adaptive-icon safe area so it retains",
        "breathing room under Samsung and other launcher masks.", "",
        "| # | Design | Intent |", "|---|---|---|",
    ]
    for index, design in enumerate(DESIGNS, start=1):
        readme.append(f"| {index:02d} | {design.title} | {design.description} |")
    readme += [
        "", "Generate or refresh the assets:", "",
        "    python tool/build_icon_redesigns.py", "",
        "Build ten side-by-side comparison APKs:", "",
        "    python tool/build_icon_redesigns.py --build-apks ~/Downloads/flexify-icon-redesigns", "",
        "Each APK uses a unique package ID from com.presley.flexify.icon01 through",
        "com.presley.flexify.icon10 and a launcher label from Flexify 01 through Flexify 10.",
    ]
    (ASSET_DIR / "README.md").write_text("\n".join(readme) + "\n", encoding="utf-8")


def write_comparison_project(work: Path, index: int, design: Design, preview: Path) -> tuple[str, Path]:
    package = f"com.presley.flexify.icon{index:02d}"
    label = f"Flexify {index:02d}"
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
    java = f"""package {package};

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
"""
    java_file = java_dir / "MainActivity.java"
    java_file.write_text(java, encoding="utf-8")
    return package, java_file


def ensure_debug_keystore() -> Path:
    keystore = Path.home() / ".android" / "debug.keystore"
    if keystore.exists():
        return keystore
    keystore.parent.mkdir(parents=True, exist_ok=True)
    run([
        "keytool", "-genkeypair", "-v", "-keystore", str(keystore),
        "-storepass", "android", "-alias", "androiddebugkey", "-keypass", "android",
        "-dname", "CN=Android Debug,O=Android,C=US", "-keyalg", "RSA",
        "-keysize", "2048", "-validity", "10000",
    ])
    return keystore


def build_one_apk(output_dir: Path, index: int, design: Design) -> Path:
    preview = ASSET_DIR / "previews" / f"{index:02d}-{design.slug}.png"
    output_dir.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix=f"flexify-icon-{index:02d}-") as temp:
        work = Path(temp)
        package, java_file = write_comparison_project(work, index, design, preview)

        classes = work / "classes"
        classes.mkdir()
        run(["javac", "-source", "8", "-target", "8", "-classpath", str(ANDROID_JAR), "-d", str(classes), str(java_file)])

        dex_dir = work / "dex"
        dex_dir.mkdir()
        class_file = classes / Path(*package.split(".")) / "MainActivity.class"
        run([str(BUILD_TOOLS / "d8"), "--lib", str(ANDROID_JAR), "--output", str(dex_dir), str(class_file)])

        compiled = work / "compiled.zip"
        run([str(BUILD_TOOLS / "aapt2"), "compile", "--dir", str(work / "res"), "-o", str(compiled)])

        unsigned = work / "unsigned.apk"
        run([
            str(BUILD_TOOLS / "aapt2"), "link", "-o", str(unsigned), "-I", str(ANDROID_JAR),
            "--manifest", str(work / "AndroidManifest.xml"), "--min-sdk-version", "26",
            "--target-sdk-version", "37", "--version-code", str(100 + index), "--version-name", "2.0",
            str(compiled),
        ])

        with zipfile.ZipFile(unsigned, "a", compression=zipfile.ZIP_DEFLATED) as apk:
            apk.write(dex_dir / "classes.dex", "classes.dex")

        aligned = work / "aligned.apk"
        run([str(BUILD_TOOLS / "zipalign"), "-f", "4", str(unsigned), str(aligned)])

        destination = output_dir / f"Flexify-{index:02d}-{design.slug}.apk"
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
    apk_dir = output_root / "apks"
    if output_root.exists():
        shutil.rmtree(output_root)
    apk_dir.mkdir(parents=True)
    shutil.copy2(ASSET_DIR / "contact-sheet.png", output_root / "contact-sheet.png")
    for index, design in enumerate(DESIGNS, start=1):
        print(f"Building {index:02d} {design.title}", flush=True)
        build_one_apk(apk_dir, index, design)
    lines = [
        "Flexify icon comparison APKs", "============================", "",
        "These are tiny launcher-icon comparison apps, not full Flexify builds.",
        "They exist only so the ten icons can be installed side-by-side quickly.", "",
    ]
    for index, design in enumerate(DESIGNS, start=1):
        lines.append(
            f"{index:02d}. {design.title:<15}  com.presley.flexify.icon{index:02d}  "
            f"Flexify-{index:02d}-{design.slug}.apk"
        )
    (output_root / "README.txt").write_text("\n".join(lines) + "\n", encoding="utf-8")
    shutil.make_archive(str(output_root), "zip", root_dir=output_root)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--build-apks", type=Path, metavar="OUTPUT_DIR")
    args = parser.parse_args()
    generate_assets()
    if args.build_apks is not None:
        build_apks(args.build_apks.expanduser().resolve())


if __name__ == "__main__":
    main()
