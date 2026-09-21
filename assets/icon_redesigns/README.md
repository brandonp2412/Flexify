# Flexify icon redesigns

Ten monochrome flexing-bicep launcher concepts. Each source SVG is 108x108 and
uses a black rounded-square preview background with white artwork. The artwork
is deliberately inset into the Android adaptive-icon safe area so it retains
breathing room under Samsung and other launcher masks.

| # | Design | Intent |
|---|---|---|
| 01 | Solid Swoop | Compact solid silhouette with a smooth elbow sweep. |
| 02 | Fine Outline | Light single-line contour for a very minimal launcher mark. |
| 03 | Angular Cut | Geometric faceted silhouette with crisp corners. |
| 04 | Soft Curve | Rounder organic silhouette with a gentler bicep peak. |
| 05 | Peak Flex | Higher bicep peak and narrow wrist for a more athletic profile. |
| 06 | Split Stroke | Two bold strokes that imply the arm without filling the silhouette. |
| 07 | Minimal Arc | Three heavy arcs reduced to the essential bicep gesture. |
| 08 | Contour Accent | Outlined arm with a short inner muscle accent. |
| 09 | Block Flex | Heavy squared silhouette tuned for tiny launcher sizes. |
| 10 | Wide Flex | Broad confident silhouette with the fullest bicep shape. |

Generate or refresh the assets:

    python tool/build_icon_redesigns.py

Build ten side-by-side comparison APKs:

    python tool/build_icon_redesigns.py --build-apks ~/Downloads/flexify-icon-redesigns

Each APK uses a unique package ID from com.presley.flexify.icon01 through
com.presley.flexify.icon10 and a launcher label from Flexify 01 through Flexify 10.
