import 'package:drift/drift.dart' hide Column;
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

Future<void> showAppPermissionsDialog(
  BuildContext context, {
  bool required = false,
  Setting? settings,
}) async {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

  await showDialog<void>(
    context: context,
    barrierDismissible: !required,
    builder: (context) => PopScope(
      canPop: !required,
      child: _AppPermissionsDialog(settings: settings),
    ),
  );
}

class _AppPermissionsDialog extends StatefulWidget {
  final Setting? settings;

  const _AppPermissionsDialog({this.settings});

  @override
  State<_AppPermissionsDialog> createState() => _AppPermissionsDialogState();
}

class _AppPermissionsDialogState extends State<_AppPermissionsDialog> {
  bool _notificationGranted = false;
  bool _batteryOptimizationDisabled = false;
  bool _exactAlarmGranted = false;

  @override
  void initState() {
    super.initState();
    _refreshPermissionStatus();
  }

  Future<void> _refreshPermissionStatus() async {
    final notificationGranted = await Permission.notification.isGranted;
    final batteryOptimizationDisabled =
        await Permission.ignoreBatteryOptimizations.isGranted;
    final exactAlarmGranted = await Permission.scheduleExactAlarm.isGranted;
    if (!mounted) return;

    setState(() {
      _notificationGranted = notificationGranted;
      _batteryOptimizationDisabled = batteryOptimizationDisabled;
      _exactAlarmGranted = exactAlarmGranted;
    });
  }

  Future<void> _requestNotification() async {
    await db.settings.update().write(
      const SettingsCompanion(notificationPermissionRequested: Value(true)),
    );
    final status = await Permission.notification.request();
    if (status.isPermanentlyDenied) await openAppSettings();
    await _refreshPermissionStatus();
  }

  Future<void> _request(Permission permission) async {
    final status = await permission.request();
    if (status.isPermanentlyDenied) await openAppSettings();
    await _refreshPermissionStatus();
  }

  @override
  Widget build(BuildContext context) {
    final settings = widget.settings ?? context.watch<SettingsState>().value;
    final needsTimerAccess = settings.restTimers;
    final needsNotifications = settings.notifications || needsTimerAccess;
    final hasRequirements = needsNotifications || needsTimerAccess;

    return AlertDialog(
      title: const Text('App access', textAlign: TextAlign.center),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'These are the Android permissions required by the features you currently have enabled.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              if (needsNotifications)
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _notificationGranted,
                  title: const Text(
                    'Notifications on',
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Text(
                    needsTimerAccess
                        ? 'Required for timer progress and alerts.'
                        : 'Required for enabled app notifications.',
                    textAlign: TextAlign.center,
                  ),
                  onChanged: (_) => _requestNotification(),
                ),
              if (needsTimerAccess)
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _batteryOptimizationDisabled,
                  title: const Text(
                    'Battery optimization disabled',
                    textAlign: TextAlign.center,
                  ),
                  subtitle: const Text(
                    'Allows rest timers to keep running reliably in the background.',
                    textAlign: TextAlign.center,
                  ),
                  onChanged: (_) =>
                      _request(Permission.ignoreBatteryOptimizations),
                ),
              if (needsTimerAccess)
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _exactAlarmGranted,
                  title: const Text(
                    'Background timer alarms',
                    textAlign: TextAlign.center,
                  ),
                  subtitle: const Text(
                    'Allows timer alarms to fire at the requested time.',
                    textAlign: TextAlign.center,
                  ),
                  onChanged: (_) => _request(Permission.scheduleExactAlarm),
                ),
              if (!hasRequirements)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Your enabled settings do not currently require any additional Android access.',
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton(
          onPressed: () async {
            await db.settings.update().write(
              const SettingsCompanion(
                explainedPermissions: Value(true),
                notificationPermissionRequested: Value(true),
              ),
            );
            if (!context.mounted) return;
            Navigator.pop(context);
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}
