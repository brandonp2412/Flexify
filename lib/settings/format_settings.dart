import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/unit_selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

final List<String> longFormats = [
  'dd/MM/yy',
  'dd/MM/yy h:mm a',
  'dd/MM/yy H:mm',
  'EEE h:mm a',
  'yyyy-MM-dd',
  'yyyy-MM-dd h:mm a',
  'yyyy-MM-dd H:mm',
  'yyyy.MM.dd',
  'yyyy.MM.dd h:mm a',
  'yyyy.MM.dd H:mm',
  'MMM d (EEE) h:mm a',
];

final List<String> shortFormats = [
  'd/M/yy',
  'M/d/yy',
  'd-M-yy',
  'M-d-yy',
  'd.M.yy',
  'M.d.yy',
];

List<Widget> getFormatSettings(String term, Setting settings) {
  return [
    if ('strength unit'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: UnitSelector(
          label: 'Strength unit',
          value: settings.strengthUnit,
          cardio: false,
          onChanged: (value) {
            db.settings.update().write(
                  SettingsCompanion(
                    strengthUnit: Value(value!),
                  ),
                );
          },
        ),
      ),
    if ('cardio unit'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: UnitSelector(
          label: 'Cardio unit',
          value: settings.cardioUnit,
          cardio: true,
          onChanged: (value) {
            db.settings.update().write(
                  SettingsCompanion(
                    cardioUnit: Value(value!),
                  ),
                );
          },
        ),
      ),
    if ('long date format'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Tooltip(
          message: 'Used where space is abundant',
          child: DropdownButtonFormField<String>(
            value: settings.longDateFormat,
            items: longFormats.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) => db.settings.update().write(
                  SettingsCompanion(
                    longDateFormat: Value(value!),
                  ),
                ),
            decoration: InputDecoration(
              labelText:
                  'Long date format (${DateFormat(settings.longDateFormat).format(DateTime.now())})',
            ),
          ),
        ),
      ),
    if ('short date format'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Tooltip(
          message: 'For where space is cramped (Graph lines)',
          child: DropdownButtonFormField<String>(
            value: settings.shortDateFormat,
            items: shortFormats.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) => db.settings.update().write(
                  SettingsCompanion(
                    shortDateFormat: Value(value!),
                  ),
                ),
            decoration: InputDecoration(
              labelText:
                  'Short date format (${DateFormat(settings.shortDateFormat).format(DateTime.now())})',
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
      appBar: AppBar(
        title: const Text("Formats"),
      ),
      body: ListView(
        children: getFormatSettings('', settings.value),
      ),
    );
  }
}
