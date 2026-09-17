import 'package:drift/drift.dart' hide Column;
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/cardio_data.dart';
import 'package:flexify/graph/flex_line.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/l10n/locale_preferences.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Widget> getAppearanceSettings(
  BuildContext context,
  String term,
  SettingsState settings,
) {
  final l10n = context.l10n;
  final normalizedTerm = term.trim().toLowerCase();
  bool matches(Iterable<String> values) =>
      values.join(' ').toLowerCase().contains(normalizedTerm);
  final languageSearchText = [
    l10n.settingsLanguage,
    l10n.settingsLanguageDescription,
    l10n.languageSystemDefault,
    ...selectableLocales.map((locale) => localeDisplayName(l10n, locale)),
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
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.settingsLanguage),
              items: [
                DropdownMenuItem(
                  value: '',
                  child: Text(l10n.languageSystemDefault),
                ),
                ...selectableLocales.map(
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
    if (matches([
      l10n.themeLabel,
      l10n.themeSystem,
      l10n.themeDark,
      l10n.themeLight,
    ]))
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        child: SegmentedButton<String>(
          segments: [
            ButtonSegment(
              value: 'ThemeMode.system',
              label: Text(l10n.themeSystem),
              icon: const Icon(Icons.brightness_auto),
            ),
            ButtonSegment(
              value: 'ThemeMode.dark',
              label: Text(l10n.themeDark),
              icon: const Icon(Icons.dark_mode),
            ),
            ButtonSegment(
              value: 'ThemeMode.light',
              label: Text(l10n.themeLight),
              icon: const Icon(Icons.light_mode),
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
    if (matches([l10n.pureBlackAmoled, l10n.pureBlackAmoledDescription]))
      Tooltip(
        message: l10n.pureBlackAmoledDescription,
        child: ListTile(
          leading: settings.value.themeMode == 'ThemeMode.amoled'
              ? const Icon(Icons.contrast)
              : const Icon(Icons.contrast_outlined),
          title: Text(l10n.pureBlackAmoled, textAlign: TextAlign.center),
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
    if (matches([l10n.systemColorScheme, l10n.systemColorSchemeDescription]))
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Tooltip(
          message: l10n.systemColorSchemeDescription,
          child: ListTile(
            title: Text(l10n.systemColorScheme, textAlign: TextAlign.center),
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
    if (matches([l10n.showImages, l10n.showImagesDescription]))
      Tooltip(
        message: l10n.showImagesDescription,
        child: ListTile(
          title: Text(l10n.showImages, textAlign: TextAlign.center),
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
    if (matches([l10n.showGlobalProgress, l10n.showGlobalProgressDescription]))
      Tooltip(
        message: l10n.showGlobalProgressDescription,
        child: ListTile(
          title: Text(l10n.showGlobalProgress, textAlign: TextAlign.center),
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
    if (matches([l10n.peekGraph, l10n.peekGraphDescription]))
      Tooltip(
        message: l10n.peekGraphDescription,
        child: ListTile(
          title: Text(l10n.peekGraph, textAlign: TextAlign.center),
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
    if (matches([l10n.curveLineGraphs, l10n.curveLineGraphsDescription]))
      Tooltip(
        message: l10n.curveLineGraphsDescription,
        child: ListTile(
          title: Text(l10n.curveLineGraphs, textAlign: TextAlign.center),
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
    if (matches([l10n.curveSmoothness]))
      Column(
        children: [
          Text(
            l10n.curveSmoothness,
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
    if (matches([l10n.inputStyle, l10n.inputStyleDescription]))
      Tooltip(
        message: l10n.inputStyleDescription,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: 'underline',
                    label: Text(l10n.inputStyleLine),
                    icon: const Icon(Icons.format_underlined),
                  ),
                  ButtonSegment(
                    value: 'outlined',
                    label: Text(l10n.inputStyleOutlined),
                    icon: const Icon(Icons.border_all),
                  ),
                  ButtonSegment(
                    value: 'filled',
                    label: Text(l10n.inputStyleFilled),
                    icon: const Icon(Icons.format_color_fill),
                  ),
                ],
                selected: {settings.value.inputStyle},
                onSelectionChanged: (selection) => db.settings.update().write(
                  SettingsCompanion(inputStyle: Value(selection.first)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(labelText: l10n.inputStyle),
                readOnly: true,
              ),
            ],
          ),
        ),
      ),
    if (matches([l10n.navGraphs]))
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
                      formatDisplayNumber(
                        context,
                        spot.y,
                        minimumFractionDigits: 2,
                      ),
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
      appBar: AppBar(title: Text(context.l10n.appearance)),
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
