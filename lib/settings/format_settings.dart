import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final List<String> long = [
  'timeago',
  'dd/MM/yy',
  'dd/MM/yy h:mm a',
  'dd/MM/yy H:mm',
  'dd.MM.yyyy H:mm',
  'EEE h:mm a',
  'yyyy-MM-dd',
  'yyyy-MM-dd h:mm a',
  'yyyy-MM-dd H:mm',
  'yyyy.MM.dd',
  'yyyy.MM.dd h:mm a',
  'yyyy.MM.dd H:mm',
  'MMM d (EEE) h:mm a',
  'EEE, dd.MM.yyyy H:mm',
];

final List<String> short = [
  'd/M/yy',
  'M/d/yy',
  'd-M-yy',
  'M-d-yy',
  'd.M.yy',
  'M.d.yy',
  'dd.MM.yy',
];

List<Widget> getFormatSettings(
  BuildContext context,
  String term,
  Setting settings,
) {
  final l10n = context.l10n;
  final normalizedTerm = term.trim().toLowerCase();
  bool matches(Iterable<String> values) =>
      values.join(' ').toLowerCase().contains(normalizedTerm);
  return [
    if (matches([
      l10n.strengthUnit,
      l10n.lastEntry,
      l10n.kilogramsUnit,
      l10n.poundsUnit,
      l10n.stoneUnit,
    ]))
      Padding(
        padding: kSettingsInputPadding,
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: l10n.strengthUnit),
          initialValue: settings.strengthUnit,
          items: [
            DropdownMenuItem(value: "last-entry", child: Text(l10n.lastEntry)),
            ...strengthUnitMenuItems(l10n),
          ],
          onChanged: (value) {
            db.settings.update().write(
              SettingsCompanion(strengthUnit: Value(value!)),
            );
          },
        ),
      ),
    if (matches([
      l10n.cardioUnit,
      l10n.lastEntry,
      l10n.kilometersUnit,
      l10n.milesUnit,
      l10n.metersUnit,
      l10n.kilocaloriesUnit,
    ]))
      Padding(
        padding: kSettingsInputPadding,
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: l10n.cardioUnit),
          initialValue: settings.cardioUnit,
          items: [
            DropdownMenuItem(value: "last-entry", child: Text(l10n.lastEntry)),
            ...cardioUnitMenuItems(l10n),
          ],
          onChanged: (value) {
            db.settings.update().write(
              SettingsCompanion(cardioUnit: Value(value!)),
            );
          },
        ),
      ),
    if (matches([l10n.longDateFormat(''), l10n.longDateFormatDescription]))
      Padding(
        padding: kSettingsInputPadding,
        child: Tooltip(
          message: l10n.longDateFormatDescription,
          child: Builder(
            builder: (context) {
              var format = formatRelativeTime(context, DateTime.now());

              if (settings.longDateFormat != 'timeago') {
                format = formatDisplayDate(
                  context,
                  DateTime.now(),
                  settings.longDateFormat,
                );
              }

              return DropdownButtonFormField<String>(
                initialValue: settings.longDateFormat,
                menuMaxHeight: 300,
                items: long.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => db.settings.update().write(
                  SettingsCompanion(longDateFormat: Value(value!)),
                ),
                decoration: InputDecoration(
                  labelText: l10n.longDateFormat(format),
                ),
              );
            },
          ),
        ),
      ),
    if (matches([l10n.shortDateFormat(''), l10n.shortDateFormatDescription]))
      Padding(
        padding: kSettingsInputPadding,
        child: Tooltip(
          message: l10n.shortDateFormatDescription,
          child: DropdownButtonFormField<String>(
            initialValue: settings.shortDateFormat,
            items: short.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (value) => db.settings.update().write(
              SettingsCompanion(shortDateFormat: Value(value!)),
            ),
            decoration: InputDecoration(
              labelText: l10n.shortDateFormat(
                formatDisplayDate(
                  context,
                  DateTime.now(),
                  settings.shortDateFormat,
                ),
              ),
            ),
          ),
        ),
      ),
  ];
}

class FormatSettings extends StatelessWidget {
  const FormatSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(context.l10n.formats)),
      body: ListView(
        children: [
          ...getFormatSettings(context, '', settings.value),
          const SizedBox(height: 116),
        ],
      ),
    );
  }
}
