# Flexify color redesign concepts

These five alternatives add color without changing Flexify's identity or navigation. They are based on the existing Material 3 deepPurple seed and the current dark screenshots in fastlane/metadata/android/en-US/images/phoneScreenshots.

## Shared constraints

- Keep the near-black Material 3 dark background and existing deep-purple/lavender family.
- Do not introduce blue, teal, green, pink, orange, or a second brand color.
- Preserve the Plans / Graphs / Timer information architecture, typography, search, cards, FABs, and bottom navigation.
- Keep color semantic: purple means selection, progress, action, or hierarchy, not decoration on every surface.
- Maintain readable contrast and avoid replacing text labels with color alone.

## Concepts

### 1. Tinted surfaces

A low-risk evolution of the current UI. App bars, search, cards, and navigation receive progressively stronger purple tints while the page background stays near-black.

### 2. Accent rails

Mostly neutral surfaces with a strong lavender rail on the active workout card and stronger selected navigation. Color becomes a structural cue, so dense lists stay calm while active content is immediately scannable.

### 3. Filled sections

Uses deeper purple containers for section headers and card headers, with lavender content surfaces beneath. This creates the strongest hierarchy and works well on Plans and workout-session screens.

### 4. Lavender outline

Keeps surfaces almost black and moves color to outlines, icons, progress, and focus states. This is the most restrained AMOLED-friendly option.

### 5. Gradient focus

Uses subtle deep-purple-to-surface gradients only on the currently important region: selected workout card, active graph panel, or running timer.

## Suggested screen mapping

| Screen | Tinted surfaces | Accent rails | Filled sections | Lavender outline | Gradient focus |
| --- | --- | --- | --- | --- | --- |
| Plans | Purple-tinted cards | Active-plan rail | Filled plan headers | Outlined plan cards | Selected plan gradient |
| Workout | Tinted set rows | Current-set rail | Exercise headers | Outlined set controls | Current exercise gradient |
| Graphs | Tinted graph panel | Active metric rail | Filled metric header | Lavender axes/border | Graph-panel gradient |
| Timer | Tinted timer card | Active timer rail | Filled timer header | Ring + outline accents | Timer focus gradient |
| Navigation | Tinted bar | Strong selected pill | Filled selected item | Outline emphasis | Subtle selected gradient |

The five SVGs are design references, not production assets. They intentionally preserve Flexify's existing component structure so any selected direction can be implemented incrementally with ColorScheme roles rather than hard-coded per-widget colors.
