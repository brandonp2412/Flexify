import 'package:drift/drift.dart' hide Column;
import 'package:flexify/database/database.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/l10n/locale_preferences.dart';
import 'package:flexify/main.dart';
import 'package:flexify/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Widget> getAppearanceSettings(
  BuildContext context,
  String term,
  Setting settings,
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
      canonicalLocaleOverride(settings.localeOverride) ?? '';

  return [
    if (languageSearchText.contains(normalizedTerm))
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        child: Column(
          children: [
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
            settings.themeMode == 'ThemeMode.amoled'
                ? 'ThemeMode.dark'
                : settings.themeMode,
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
          leading: settings.themeMode == 'ThemeMode.amoled'
              ? const Icon(Icons.contrast)
              : const Icon(Icons.contrast_outlined),
          title: Text(
            l10n.pureBlackAmoled,
            textAlign: isDesktopLayout(context)
                ? TextAlign.start
                : TextAlign.center,
          ),
          onTap: () => db.settings.update().write(
            SettingsCompanion(
              themeMode: Value(
                settings.themeMode == 'ThemeMode.amoled'
                    ? 'ThemeMode.dark'
                    : 'ThemeMode.amoled',
              ),
            ),
          ),
          trailing: Switch(
            value: settings.themeMode == 'ThemeMode.amoled',
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
            title: Text(
              l10n.systemColorScheme,
              textAlign: isDesktopLayout(context)
                  ? TextAlign.start
                  : TextAlign.center,
            ),
            leading: settings.systemColors
                ? const Icon(Icons.color_lens)
                : const Icon(Icons.color_lens_outlined),
            onTap: () => db.settings.update().write(
              SettingsCompanion(
                systemColors: Value(!settings.systemColors),
              ),
            ),
            trailing: Switch(
              value: settings.systemColors,
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
          title: Text(
            l10n.showImages,
            textAlign: isDesktopLayout(context)
                ? TextAlign.start
                : TextAlign.center,
          ),
          leading: settings.showImages
              ? const Icon(Icons.image)
              : const Icon(Icons.image_outlined),
          onTap: () => db.settings.update().write(
            SettingsCompanion(showImages: Value(!settings.showImages)),
          ),
          trailing: Switch(
            value: settings.showImages,
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
          title: Text(
            l10n.showGlobalProgress,
            textAlign: isDesktopLayout(context)
                ? TextAlign.start
                : TextAlign.center,
          ),
          leading: settings.showGlobalProgress
              ? const Icon(Icons.public)
              : const Icon(Icons.public_outlined),
          onTap: () => db.settings.update().write(
            SettingsCompanion(
              showGlobalProgress: Value(!settings.showGlobalProgress),
            ),
          ),
          trailing: Switch(
            value: settings.showGlobalProgress,
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
          title: Text(
            l10n.peekGraph,
            textAlign: isDesktopLayout(context)
                ? TextAlign.start
                : TextAlign.center,
          ),
          leading: settings.peekGraph
              ? const Icon(Icons.visibility)
              : const Icon(Icons.visibility_outlined),
          onTap: () => db.settings.update().write(
            SettingsCompanion(peekGraph: Value(!settings.peekGraph)),
          ),
          trailing: Switch(
            value: settings.peekGraph,
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
          title: Text(
            l10n.curveLineGraphs,
            textAlign: isDesktopLayout(context)
                ? TextAlign.start
                : TextAlign.center,
          ),
          leading: settings.curveLines
              ? const Icon(Icons.insights)
              : const Icon(Icons.insights_outlined),
          onTap: () => db.settings.update().write(
            SettingsCompanion(curveLines: Value(!settings.curveLines)),
          ),
          trailing: Switch(
            value: settings.curveLines,
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
            textAlign: isDesktopLayout(context)
                ? TextAlign.start
                : TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Slider(
            value: settings.curveSmoothness ?? 0.35,
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
                selected: {settings.inputStyle},
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
  ];
}

class AppearanceSettings extends StatelessWidget {
  const AppearanceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<Setting>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(context.l10n.appearance)),
      body: ResponsiveSettingsList(
        children: getAppearanceSettings(context, '', settings),
      ),
    );
  }
}
