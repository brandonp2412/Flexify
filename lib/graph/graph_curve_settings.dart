import 'package:drift/drift.dart' hide Column;
import 'package:flexify/database/database.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Controls the persisted line shape used by graph charts.
class GraphCurveSettings extends StatelessWidget {
  final bool compact;

  const GraphCurveSettings({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsState>(
      builder: (context, settingsState, child) {
        final settings = settingsState.value;
        final smoothness = settings.curveSmoothness ?? 0.35;

        void onCurveChanged(bool value) => db.settings.update().write(
          SettingsCompanion(curveLines: Value(value)),
        );
        final onSmoothnessChanged = settings.curveLines
            ? (double value) => db.settings.update().write(
                SettingsCompanion(curveSmoothness: Value(value)),
              )
            : null;

        if (compact) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Tooltip(
                      message: context.l10n.curveLineGraphsDescription,
                      child: Text(
                        context.l10n.curveLineGraphs,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch(value: settings.curveLines, onChanged: onCurveChanged),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      context.l10n.curveSmoothness,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 30,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 7,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 14,
                          ),
                        ),
                        child: Slider(
                          value: smoothness,
                          min: 0,
                          max: 1,
                          divisions: 20,
                          inactiveColor: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.24),
                          onChanged: onSmoothnessChanged,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 38,
                    child: Text(
                      formatDisplayPercent(
                        context,
                        smoothness,
                        maximumFractionDigits: 0,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l10n.curveLineGraphs),
              subtitle: Text(context.l10n.curveLineGraphsDescription),
              value: settings.curveLines,
              onChanged: onCurveChanged,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.curveSmoothness,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  formatDisplayPercent(
                    context,
                    smoothness,
                    maximumFractionDigits: 0,
                  ),
                ),
              ],
            ),
            Slider(
              value: smoothness,
              min: 0,
              max: 1,
              divisions: 20,
              inactiveColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.24),
              onChanged: onSmoothnessChanged,
            ),
          ],
        );
      },
    );
  }
}
