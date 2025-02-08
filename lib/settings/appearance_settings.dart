import 'package:drift/drift.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/cardio_data.dart';
import 'package:flexify/graph/flex_line.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Widget> getAppearanceSettings(
  BuildContext context,
  String term,
  SettingsState settings,
) {
  return [
    if ('theme'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: DropdownButtonFormField<ThemeMode>(
          value: ThemeMode.values
              .byName(settings.value.themeMode.replaceFirst('ThemeMode.', '')),
          decoration: const InputDecoration(
            labelStyle: TextStyle(),
            labelText: 'Theme',
          ),
          items: const [
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text("System"),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text("Dark"),
            ),
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text("Light"),
            ),
          ],
          onChanged: (value) => db.settings.update().write(
                SettingsCompanion(
                  themeMode: Value(value.toString()),
                ),
              ),
        ),
      ),
    if ('system color scheme'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Tooltip(
          message: 'Use the primary color of your device for the app',
          child: ListTile(
            title: const Text('System color scheme'),
            leading: settings.value.systemColors
                ? const Icon(Icons.color_lens)
                : const Icon(Icons.color_lens_outlined),
            onTap: () => db.settings.update().write(
                  SettingsCompanion(
                    systemColors: Value(!settings.value.systemColors),
                  ),
                ),
            trailing: Switch(
              value: settings.value.systemColors,
              onChanged: (value) => db.settings.update().write(
                    SettingsCompanion(
                      systemColors: Value(value),
                    ),
                  ),
            ),
          ),
        ),
      ),
    if ('show images'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Pick/display images on the history page',
        child: ListTile(
          title: const Text('Show images'),
          leading: settings.value.showImages
              ? const Icon(Icons.image)
              : const Icon(Icons.image_outlined),
          onTap: () => db.settings.update().write(
                SettingsCompanion(
                  showImages: Value(!settings.value.showImages),
                ),
              ),
          trailing: Switch(
            value: settings.value.showImages,
            onChanged: (value) => db.settings.update().write(
                  SettingsCompanion(
                    showImages: Value(value),
                  ),
                ),
          ),
        ),
      ),
    if ('peek graph'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Show the first line graph on graphs page',
        child: ListTile(
          title: const Text('Peek graph'),
          leading: const Icon(Icons.visibility_outlined),
          onTap: () => db.settings.update().write(
                SettingsCompanion(
                  peekGraph: Value(!settings.value.peekGraph),
                ),
              ),
          trailing: Switch(
            value: settings.value.peekGraph,
            onChanged: (value) => db.settings.update().write(
                  SettingsCompanion(
                    peekGraph: Value(value),
                  ),
                ),
          ),
        ),
      ),
    if ('curve line graphs'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Use wavy curves in the graphs page',
        child: ListTile(
          title: const Text('Curve line graphs'),
          leading: const Icon(Icons.insights),
          onTap: () => db.settings.update().write(
                SettingsCompanion(
                  curveLines: Value(!settings.value.curveLines),
                ),
              ),
          trailing: Switch(
            value: settings.value.curveLines,
            onChanged: (value) => db.settings.update().write(
                  SettingsCompanion(
                    curveLines: Value(value),
                  ),
                ),
          ),
        ),
      ),
    if ('curve smoothness'.contains(term.toLowerCase()))
      material.Column(
        children: [
          material.Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              "Curve smoothness",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Slider(
            value: settings.value.curveSmoothness ?? 0.35,
            inactiveColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.24),
            onChanged: (value) {
              db.settings.update().write(
                    SettingsCompanion(
                      curveSmoothness: Value(value),
                    ),
                  );
            },
          ),
        ],
      ),
    if ('graph'.contains(term.toLowerCase()))
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Padding(
          padding: const EdgeInsets.all(64),
          child: FlexLine(
            hideBottom: true,
            hideLeft: true,
            spots: const [FlSpot(0, 0.13), FlSpot(1, 5), FlSpot(2, 2)],
            tooltipData: () => const LineTouchTooltipData(),
            data: [
              CardioData(
                created: DateTime.parse('2024-05-19 14:54:17.000'),
                value: 0.13,
                unit: 'km',
              ),
              CardioData(
                created: DateTime.parse('2024-05-19 14:54:17.000'),
                value: 0.13,
                unit: 'km',
              ),
              CardioData(
                created: DateTime.parse('2024-05-19 14:54:17.000'),
                value: 0.13,
                unit: 'km',
              ),
            ],
          ),
        ),
      ),
  ];
}

class AppearanceSettings extends StatelessWidget {
  const AppearanceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Appearance"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: getAppearanceSettings(context, '', settings),
        ),
      ),
    );
  }
}
