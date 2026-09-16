import 'package:drift/drift.dart' hide Column;
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/cardio_data.dart';
import 'package:flexify/graph/flex_line.dart';
import 'package:flexify/l10n/generated/app_localizations.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/l10n/locale_preferences.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Widget> getAppearanceSettings(
  BuildContext context,
  String term,
  SettingsState settings,
) {
  final l10n = context.l10n;
  final normalizedTerm = term.trim().toLowerCase();
  final languageSearchText = [
    l10n.settingsLanguage,
    l10n.settingsLanguageDescription,
    l10n.languageSystemDefault,
    ...AppLocalizations.supportedLocales.map(
      (locale) => localeDisplayName(l10n, locale),
    ),
  ].join(' ').toLowerCase();
  final selectedLocale =
      canonicalLocaleOverride(settings.value.localeOverride) ?? '';

  return [
    if (languageSearchText.contains(normalizedTerm))
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.language_rounded),
              title: Text(l10n.settingsLanguage, textAlign: TextAlign.center),
              subtitle: Text(
                l10n.settingsLanguageDescription,
                textAlign: TextAlign.center,
              ),
            ),
            DropdownButtonFormField<String>(
              key: const Key('language-setting-dropdown'),
              initialValue: selectedLocale,
              decoration: InputDecoration(labelText: l10n.settingsLanguage),
              items: [
                DropdownMenuItem(
                  value: '',
                  child: Text(l10n.languageSystemDefault),
                ),
                ...AppLocalizations.supportedLocales.map(
                  (locale) => DropdownMenuItem(
                    value: localeIdentifier(locale),
                    child: Text(localeDisplayName(l10n, locale)),
                  ),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                db.settings.update().write(
                  SettingsCompanion(
                    localeOverride: Value(value.isEmpty ? null : value),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    if ('theme'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        child: SegmentedButton<String>(
          segments: const [
            ButtonSegment(
              value: 'ThemeMode.system',
              label: Text('System'),
              icon: Icon(Icons.brightness_auto),
            ),
            ButtonSegment(
              value: 'ThemeMode.dark',
              label: Text('Dark'),
              icon: Icon(Icons.dark_mode),
            ),
            ButtonSegment(
              value: 'ThemeMode.light',
              label: Text('Light'),
              icon: Icon(Icons.light_mode),
            ),
          ],
          selected: {
            settings.value.themeMode == 'ThemeMode.amoled'
                ? 'ThemeMode.dark'
                : settings.value.themeMode,
          },
          onSelectionChanged: (selection) => db.settings.update().write(
            SettingsCompanion(themeMode: Value(selection.first)),
          ),
        ),
      ),
    if ('pure black amoled'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Use pure black colors for AMOLED displays',
        child: ListTile(
          leading: settings.value.themeMode == 'ThemeMode.amoled'
              ? const Icon(Icons.contrast)
              : const Icon(Icons.contrast_outlined),
          title: const Text('Pure black (AMOLED)', textAlign: TextAlign.center),
          onTap: () => db.settings.update().write(
            SettingsCompanion(
              themeMode: Value(
                settings.value.themeMode == 'ThemeMode.amoled'
                    ? 'ThemeMode.dark'
                    : 'ThemeMode.amoled',
              ),
            ),
          ),
          trailing: Switch(
            value: settings.value.themeMode == 'ThemeMode.amoled',
            onChanged: (value) => db.settings.update().write(
              SettingsCompanion(
                themeMode: Value(value ? 'ThemeMode.amoled' : 'ThemeMode.dark'),
              ),
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
            title: const Text(
              'System color scheme',
              textAlign: TextAlign.center,
            ),
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
                SettingsCompanion(systemColors: Value(value)),
              ),
            ),
          ),
        ),
      ),
    if ('show images'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Pick/display images on the history page',
        child: ListTile(
          title: const Text('Show images', textAlign: TextAlign.center),
          leading: settings.value.showImages
              ? const Icon(Icons.image)
              : const Icon(Icons.image_outlined),
          onTap: () => db.settings.update().write(
            SettingsCompanion(showImages: Value(!settings.value.showImages)),
          ),
          trailing: Switch(
            value: settings.value.showImages,
            onChanged: (value) => db.settings.update().write(
              SettingsCompanion(showImages: Value(value)),
            ),
          ),
        ),
      ),
    if ('show global progress'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Add a graph entry charting your progress by category',
        child: ListTile(
          title: const Text(
            'Show global progress',
            textAlign: TextAlign.center,
          ),
          leading: settings.value.showGlobalProgress
              ? const Icon(Icons.public)
              : const Icon(Icons.public_outlined),
          onTap: () => db.settings.update().write(
            SettingsCompanion(
              showGlobalProgress: Value(!settings.value.showGlobalProgress),
            ),
          ),
          trailing: Switch(
            value: settings.value.showGlobalProgress,
            onChanged: (value) => db.settings.update().write(
              SettingsCompanion(showGlobalProgress: Value(value)),
            ),
          ),
        ),
      ),
    if ('peek graph'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Show the first line graph on graphs page',
        child: ListTile(
          title: const Text('Peek graph', textAlign: TextAlign.center),
          leading: settings.value.peekGraph
              ? const Icon(Icons.visibility)
              : const Icon(Icons.visibility_outlined),
          onTap: () => db.settings.update().write(
            SettingsCompanion(peekGraph: Value(!settings.value.peekGraph)),
          ),
          trailing: Switch(
            value: settings.value.peekGraph,
            onChanged: (value) => db.settings.update().write(
              SettingsCompanion(peekGraph: Value(value)),
            ),
          ),
        ),
      ),
    if ('curve line graphs'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Use wavy curves in the graphs page',
        child: ListTile(
          title: const Text('Curve line graphs', textAlign: TextAlign.center),
          leading: settings.value.curveLines
              ? const Icon(Icons.insights)
              : const Icon(Icons.insights_outlined),
          onTap: () => db.settings.update().write(
            SettingsCompanion(curveLines: Value(!settings.value.curveLines)),
          ),
          trailing: Switch(
            value: settings.value.curveLines,
            onChanged: (value) => db.settings.update().write(
              SettingsCompanion(curveLines: Value(value)),
            ),
          ),
        ),
      ),
    if ('curve smoothness'.contains(term.toLowerCase()))
      Column(
        children: [
          Text(
            "Curve smoothness",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Slider(
            value: settings.value.curveSmoothness ?? 0.35,
            inactiveColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.24),
            onChanged: (value) {
              db.settings.update().write(
                SettingsCompanion(curveSmoothness: Value(value)),
              );
            },
          ),
        ],
      ),
    if ('input style'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Visual style of text input fields',
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'underline',
                    label: Text('Line'),
                    icon: Icon(Icons.format_underlined),
                  ),
                  ButtonSegment(
                    value: 'outlined',
                    label: Text('Outlined'),
                    icon: Icon(Icons.border_all),
                  ),
                  ButtonSegment(
                    value: 'filled',
                    label: Text('Filled'),
                    icon: Icon(Icons.format_color_fill),
                  ),
                ],
                selected: {settings.value.inputStyle},
                onSelectionChanged: (selection) => db.settings.update().write(
                  SettingsCompanion(inputStyle: Value(selection.first)),
                ),
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(labelText: 'Input style'),
                readOnly: true,
              ),
            ],
          ),
        ),
      ),
    if ('graph'.contains(term.toLowerCase()))
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Padding(
          padding: const EdgeInsets.only(right: 32, top: 16),
          child: FlexLine(
            hideBottom: true,
            hideLeft: true,
            spots: const [FlSpot(0, 0.13), FlSpot(1, 5), FlSpot(2, 2)],
            tooltipData: () => LineTouchTooltipData(
              getTooltipColor: (touchedSpot) =>
                  Theme.of(context).colorScheme.surface,
              getTooltipItems: (touchedSpots) => touchedSpots
                  .map(
                    (spot) => LineTooltipItem(
                      spot.y.toStringAsFixed(2),
                      TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                  )
                  .toList(),
            ),
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Appearance")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ...getAppearanceSettings(context, '', settings),
            const SizedBox(height: 116),
          ],
        ),
      ),
    );
  }
}
