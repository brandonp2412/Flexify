import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/delete_records_button.dart';
import 'package:flexify/export_data.dart';
import 'package:flexify/import_data.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> notifyAutomaticBackupEnabled() async {
  if (kIsWeb) return;

  if (Platform.isAndroid || Platform.isIOS) {
    final permission = await Permission.notification.request();
    if (!permission.isGranted) return;
  }

  const darwin = DarwinInitializationSettings();
  const android = AndroidInitializationSettings(
    '@drawable/baseline_arrow_downward_24',
  );
  const linux = LinuxInitializationSettings(
    defaultActionName: 'Open notification',
  );
  const init = InitializationSettings(
    android: android,
    iOS: darwin,
    macOS: darwin,
    linux: linux,
  );
  final plugin = FlutterLocalNotificationsPlugin();
  await plugin.initialize(settings: init);
  await plugin.show(
    id: 4,
    title: 'Automatic backups enabled',
    body:
        'Flexify will automatically back up your data and images to the selected folder each day.',
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        'backup-settings',
        'Backup settings',
        channelDescription: 'Notifications explaining automatic backups',
      ),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
      linux: LinuxNotificationDetails(),
    ),
  );
}

Future<void> tapBackup(bool value) async {
  if (kIsWeb || !Platform.isAndroid) return;

  if (!value) {
    await db.settings.update().write(
      const SettingsCompanion(automaticBackups: Value(false)),
    );
    return;
  }

  try {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbFolder.path, 'flexify.sqlite');
    final selectedPath = await androidChannel.invokeMethod<String>('pick', {
      'dbPath': dbPath,
    });
    if (selectedPath == null) return;

    await db.settings.update().write(
      const SettingsCompanion(automaticBackups: Value(true)),
    );
    await notifyAutomaticBackupEnabled();
  } catch (_) {
    await db.settings.update().write(
      const SettingsCompanion(automaticBackups: Value(false)),
    );
    rethrow;
  }
}

List<Widget> getDataSettings(
  String term,
  SettingsState settings,
  BuildContext context,
) {
  return [
    if ('automatic backup'.contains(term.toLowerCase()) &&
        !kIsWeb &&
        Platform.isAndroid)
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
    if ('share database'.contains(term.toLowerCase()) &&
        !kIsWeb &&
        !Platform.isLinux)
      TextButton.icon(
        onPressed: () async {
          final dbFolder = await getApplicationDocumentsDirectory();
          final dbPath = p.join(dbFolder.path, 'flexify.sqlite');
          await SharePlus.instance.share(ShareParams(files: [XFile(dbPath)]));
        },
        label: const Text("Share database"),
        icon: const Icon(Icons.share),
      ),
    if ('export data'.contains(term.toLowerCase())) const ExportData(),
    if ('import data'.contains(term.toLowerCase())) ImportData(ctx: context),
    if ('delete records'.contains(term.toLowerCase()))
      DeleteRecordsButton(ctx: context),
  ];
}

class DataSettings extends StatelessWidget {
  const DataSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Data management")),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 116),
        children: getDataSettings('', settings, context),
      ),
    );
  }
}
