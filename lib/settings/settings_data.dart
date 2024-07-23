import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/delete_records_button.dart';
import 'package:flexify/export_data.dart';
import 'package:flexify/import_data.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

void tapBackup(bool value) async {
  await db.settings.update().write(
        SettingsCompanion(
          automaticBackups: Value(value),
        ),
      );

  if (value) {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbFolder.path, 'flexify.sqlite');
    androidChannel.invokeMethod('pick', {'dbPath': dbPath});
  }
}

List<Widget> getDataSettings(
  String term,
  SettingsState settings,
  BuildContext context,
) {
  return [
    if ('automatic backup'.contains(term.toLowerCase()))
      ListTile(
        title: const Text('Automatic backup'),
        leading: settings.value.automaticBackups
            ? const Icon(Icons.timer)
            : const Icon(Icons.timer_outlined),
        onTap: () => tapBackup(!settings.value.automaticBackups),
        trailing: Switch(
          value: settings.value.automaticBackups,
          onChanged: (value) => tapBackup(value),
        ),
      ),
    if ('share database'.contains(term.toLowerCase()) && !Platform.isLinux)
      TextButton.icon(
        onPressed: () async {
          final dbFolder = await getApplicationDocumentsDirectory();
          final dbPath = p.join(dbFolder.path, 'flexify.sqlite');
          await Share.shareXFiles([XFile(dbPath)]);
        },
        label: const Text("Share database"),
        icon: const Icon(Icons.share),
      ),
    if ('export data'.contains(term.toLowerCase())) const ExportData(),
    if ('import data'.contains(term.toLowerCase()))
      ImportData(pageContext: context),
    if ('delete records'.contains(term.toLowerCase()))
      DeleteRecordsButton(pageContext: context),
  ];
}

class SettingsData extends StatelessWidget {
  const SettingsData({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Data management"),
      ),
      body: ListView(
        children: getDataSettings('', settings, context),
      ),
    );
  }
}
