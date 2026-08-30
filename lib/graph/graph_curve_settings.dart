import 'package:drift/drift.dart' hide Column;
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Controls the persisted line shape used by graph charts.
class GraphCurveSettings extends StatelessWidget {
  const GraphCurveSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsState>(
      builder: (context, settingsState, child) {
        final settings = settingsState.value;
        final smoothness = settings.curveSmoothness ?? 0.35;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Curve line graphs'),
              subtitle: const Text('Draw graph lines as smooth curves'),
              value: settings.curveLines,
              onChanged: (value) => db.settings.update().write(
                SettingsCompanion(curveLines: Value(value)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Curve smoothness',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text('${(smoothness * 100).round()}%'),
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
              onChanged: settings.curveLines
                  ? (value) => db.settings.update().write(
                      SettingsCompanion(curveSmoothness: Value(value)),
                    )
                  : null,
            ),
          ],
        );
      },
    );
  }
}
