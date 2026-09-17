import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flexify/app_permissions_dialog.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/delete_records_button.dart';
import 'package:flexify/export_data.dart';
import 'package:flexify/import_data.dart';
import 'package:flexify/l10n/generated/app_localizations.dart';
import 'package:flexify/l10n/l10n.dart';
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

Future<void> notifyAutomaticBackupEnabled(AppLocalizations l10n) async {
  if (kIsWeb) return;

  if (Platform.isAndroid || Platform.isIOS) {
    final permission = await Permission.notification.request();
    if (!permission.isGranted) return;
  }

  const darwin = DarwinInitializationSettings();
  const android = AndroidInitializationSettings(
    '@drawable/baseline_arrow_downward_24',
  );
  final linux = LinuxInitializationSettings(
    defaultActionName: l10n.openNotification,
  );
  final init = InitializationSettings(
    android: android,
    iOS: darwin,
    macOS: darwin,
    linux: linux,
  );
  final plugin = FlutterLocalNotificationsPlugin();
  await plugin.initialize(settings: init);
  await plugin.show(
    id: 4,
    title: l10n.automaticBackupsEnabled,
    body: l10n.automaticBackupNotificationBody,
    notificationDetails: NotificationDetails(
      android: AndroidNotificationDetails(
        'backup-settings',
        l10n.backupSettingsChannel,
        channelDescription: l10n.backupSettingsChannelDescription,
      ),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
      linux: LinuxNotificationDetails(),
    ),
  );
}

Future<void> tapBackup(bool value, AppLocalizations l10n) async {
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
    await notifyAutomaticBackupEnabled(l10n);
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
  final l10n = context.l10n;
  final normalizedTerm = term.trim().toLowerCase();
  bool matches(Iterable<String> values) =>
      values.join(' ').toLowerCase().contains(normalizedTerm);
  return [
    if (matches([l10n.automaticBackup, l10n.automaticBackupNotificationBody]) &&
        !kIsWeb &&
        Platform.isAndroid)
      ListTile(
        key: const Key('automaticBackupTile'),
        title: Text(l10n.automaticBackup, textAlign: TextAlign.center),
        leading: settings.value.automaticBackups
            ? const Icon(Icons.timer)
            : const Icon(Icons.timer_outlined),
        onTap: () => tapBackup(!settings.value.automaticBackups, l10n),
        trailing: Switch(
          key: const Key('automaticBackupSwitch'),
          value: settings.value.automaticBackups,
          onChanged: (value) => tapBackup(value, l10n),
        ),
      ),
    if (matches([l10n.appPermissions, l10n.appPermissionsDescription]) &&
        !kIsWeb &&
        Platform.isAndroid)
      ListTile(
        title: Text(l10n.appPermissions, textAlign: TextAlign.center),
        subtitle: Text(
          l10n.appPermissionsDescription,
          textAlign: TextAlign.center,
        ),
        leading: const Icon(Icons.admin_panel_settings_outlined),
        onTap: () => showAppPermissionsDialog(context),
      ),
    if (matches([l10n.shareDatabase]) && !kIsWeb && !Platform.isLinux)
      TextButton.icon(
        onPressed: () async {
          final dbFolder = await getApplicationDocumentsDirectory();
          final dbPath = p.join(dbFolder.path, 'flexify.sqlite');
          await SharePlus.instance.share(ShareParams(files: [XFile(dbPath)]));
        },
        label: Text(l10n.shareDatabase),
        icon: const Icon(Icons.share),
      ),
    if (matches([l10n.exportData])) const ExportData(),
    if (matches([l10n.importData])) ImportData(ctx: context),
    if (matches([l10n.deleteRecords])) DeleteRecordsButton(ctx: context),
  ];
}

class DataSettings extends StatelessWidget {
  const DataSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(context.l10n.dataManagement)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 116),
        children: getDataSettings('', settings, context),
      ),
    );
  }
}
