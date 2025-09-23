import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

final List<String> long = [
  'timeago',
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

final List<String> short = [
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
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Strength unit'),
          initialValue: settings.strengthUnit,
          items: const [
            DropdownMenuItem(
              value: "last-entry",
              child: Text("Last entry"),
            ),
            DropdownMenuItem(
              value: 'kg',
              child: Text("Kilograms (kg)"),
            ),
            DropdownMenuItem(
              value: 'lb',
              child: Text("Pounds (lb)"),
            ),
            DropdownMenuItem(
              value: 'stone',
              child: Text("Stone"),
            ),
          ],
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
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Cardio unit'),
          initialValue: settings.cardioUnit,
          items: const [
            DropdownMenuItem(
              value: "last-entry",
              child: Text("Last entry"),
            ),
            DropdownMenuItem(
              value: 'km',
              child: Text("Kilometers (km)"),
            ),
            DropdownMenuItem(
              value: 'mi',
              child: Text("Miles (mi)"),
            ),
            DropdownMenuItem(
              value: 'm',
              child: Text("Meters (m)"),
            ),
            DropdownMenuItem(
              value: 'kcal',
              child: Text("Kilocalories (kcal)"),
            ),
          ],
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
          child: Builder(
            builder: (context) {
              var format = timeago.format(DateTime.now());

              if (settings.longDateFormat != 'timeago')
                format =
                    DateFormat(settings.longDateFormat).format(DateTime.now());

              return DropdownButtonFormField<String>(
                initialValue: settings.longDateFormat,
                items: long.map((String value) {
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
                  labelText: 'Long date format ($format)',
                ),
              );
            },
          ),
        ),
      ),
    if ('short date format'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Tooltip(
          message: 'For where space is cramped (Graph lines)',
          child: DropdownButtonFormField<String>(
            initialValue: settings.shortDateFormat,
            items: short.map((String value) {
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Formats"),
      ),
      body: ListView(
        children: getFormatSettings('', settings.value),
      ),
    );
  }
}
