# Flexify #7/#8 refinements

Five refinements of icon #7 (Minimal Arc) followed by five refinements of
icon #8 (Contour Accent). All artwork stays inside the adaptive-icon safe area.

| Code | Design | Intent |
|---|---|---|
| 07A | 07A Taut Arc | A cleaner, slightly lighter version of #7 with longer, tighter arcs. |
| 07B | 07B Hook Arc | A hooked wrist and rounder bicep, still reduced to three bold strokes. |
| 07C | 07C Compact Arc | A shorter, thicker, more compact #7 tuned for small launcher sizes. |
| 07D | 07D Sweep Arc | A longer lower sweep and more open negative space than #7. |
| 07E | 07E Two Stroke | An ultra-minimal #7 reduced to only the arm contour and one muscle sweep. |
| 08A | 08A Clean Contour | A lighter, cleaner #8 with one restrained inner muscle accent. |
| 08B | 08B Bold Contour | A heavier #8 outline with a stronger inner accent for launcher readability. |
| 08C | 08C Double Accent | Classic #8 outline with two small muscle accents for extra definition. |
| 08D | 08D Soft Contour | A rounder #8 based on the soft silhouette with a flowing inner accent. |
| 08E | 08E Angular Contour | A sharper geometric #8 that keeps the outline-and-accent language. |

Generate assets:

    python tool/build_icon_refinements.py

Build side-by-side comparison APKs:

    python tool/build_icon_refinements.py --build-apks ~/Downloads/flexify-icon-refinements
