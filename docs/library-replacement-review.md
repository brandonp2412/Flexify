# Library replacement review

Reviewed 2026-10-11 against commit `25aa6895`. File sizes below count physical
lines, including whitespace, and exclude generated Dart code. Estimated savings
are judgments from inspection, not measured results from replacement prototypes.

There is one strong opportunity to replace hundreds of lines: chart rendering.
Forms are a second, smaller opportunity. Much of the remaining large code is
workout logic or compatibility handling that a general library cannot remove.

## 1. Chart rendering: largest opportunity, with a compatibility constraint

`lib/graph/flex_line_chart.dart` is 1,026 lines. It implements tooltip painting,
axis layout, label thinning, coordinate transforms, curves, gradient fills,
dashed trends, scene generation, hit regions, and gesture handling. Drafter is
already a dependency, but Flexify uses its low-level painting API to implement
its own renderer rather than delegating most of this work.

[Drafter](https://pub.dev/packages/drafter) provides line/grouped-line renderers
and an interactive wrapper. However, inspection of the installed 0.3.0 source
shows its stock line renderer uses evenly spaced categories and a zero-based
vertical scale, with a much narrower configuration surface. Flexify requires
timestamp spacing, tightly padded min/max bounds, configurable smoothing,
optional axes, sparse grouped columns, and dashed trend overlays. Its tests also
require long-press scrubbing to coexist with horizontal page swiping, selection
to survive parent rebuilds, and tooltips above the selected points. Stock
Drafter is therefore not a behavior-preserving drop-in replacement.

Two viable approaches:

- Extend or contribute configuration to Drafter and delegate the shared
  rendering machinery. This preserves the current dependency policy but moves
  some maintenance upstream; exact savings depend on which extensions land.
- Evaluate [fl_chart's line-chart API](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/line_chart.md).
  Its numeric spots, axis bounds, curve settings, fills, dash arrays, and touch
  configuration better match the custom renderer. A thin adapter could plausibly
  remove 400–700 net lines. Retain regression calculation and any necessary
  gesture/tooltip adaptation.

The repository deliberately switched from fl_chart to Drafter in `a429aa09`
on October 3, and `test/chart_dependency_test.dart` explicitly enforces Drafter
as the only chart dependency. A reversal needs a conscious policy decision and
an explanation of what the previous migration was intended to achieve. The
commit alone does not establish that rationale.

First prototype one strength chart and one sparse grouped chart. Use existing
`test/flex_line_chart_test.dart` cases as acceptance requirements, and check
dense-data performance and visual behavior before adopting either approach.

## 2. Set editor forms: medium opportunity

`lib/sets/edit_set_page.dart` and `lib/sets/edit_sets_page.dart` total 1,612 lines.
They repeat controller lifecycle management, numeric validators, dirty tracking,
field initialization, and value collection.

[reactive_forms](https://pub.dev/packages/reactive_forms) can consolidate form
state, validation, and dirty tracking; alternatively,
[flutter_form_builder](https://pub.dev/packages/flutter_form_builder) provides
named fields, common input widgets, validation, and value collection. Pick one
only after prototyping the bulk editor, where blank values mean leave unchanged
and mixed values must remain distinguishable from an explicit update.

Estimated net savings across the two editors: 150–350 lines. The library will
not remove exercise-kind rules, canonical unit conversion, rest timers, save
transactions, autocomplete behavior, or the localized numeric stepper. Preserve
locale-aware parsing, calculated one-rep-max updates, focus behavior, and discard
confirmation semantics. Reusable local fields may achieve comparable savings
with less migration cost, so compare that option in the prototype.

## 3. Android timer infrastructure: possible, but high risk

`TimerService.kt` (509 lines) and `FlexifyTimer.kt` (197 lines) own background
countdown execution, notification actions, exact alarms, sound, and vibration.
[flutter_foreground_task](https://pub.dev/packages/flutter_foreground_task) could
replace some service lifecycle and communication plumbing. Existing
`flutter_local_notifications` may absorb some notification construction.

Neither package by itself proves equivalent exact-alarm, idle-device, looping
audio, or add-a-minute behavior. A foreground task also introduces a Dart runtime
in the background. Savings are uncertain because alarm and media integration
may still need native code; do not count all 706 lines as replaceable. Consider
this only if native service maintenance is already a problem, and validate on
physical Android devices under screen-off, idle, permission denial, and service
restart conditions before any migration.

## Areas to retain

- Database migrations and analytics: Drift already supplies persistence. The
  1,100-line database class includes historical migration obligations, and the
  668-line analytics file contains workout-specific metrics and bucket semantics.
  Another ORM or statistics library would leave most of this logic in place.
- Import/export: CSV and archive encoding already use `csv` and `archive`.
  The substantial remaining code maps Flexify records, remaps identifiers,
  handles legacy units, and relocates image references. Serialization generators
  cannot eliminate these compatibility rules.
- Timer/progress UI: the 588-line progress-widget file largely contains layout,
  controls, and phase/lifecycle behavior. A circular countdown widget would only
  replace a fraction and still need integration with the authoritative timer.
- Search, selection, routing, and responsiveness: these are small wrappers or
  application-specific interactions. Adding routing or state-management packages
  would not remove a comparable amount of code.

Recommended order: resolve chart dependency intent, prototype chart delegation,
then compare a form-library prototype with shared local form components. Avoid
database or timer rewrites solely to reduce line counts.
