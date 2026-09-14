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
    final colors = Theme.of(context).colorScheme;

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.admin_panel_settings_outlined,
              color: colors.onPrimaryContainer,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App access',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Needed for enabled timers and notifications.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (needsNotifications)
                _AccessCard(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  description: needsTimerAccess
                      ? 'Timer progress and rest alerts'
                      : 'Notifications you have enabled',
                  granted: _notificationGranted,
                  onRequest: _requestNotification,
                ),
              if (needsNotifications && needsTimerAccess)
                const SizedBox(height: 10),
              if (needsTimerAccess)
                _AccessCard(
                  icon: Icons.battery_saver_outlined,
                  title: 'Background activity',
                  description: 'Keep timers reliable in the background',
                  granted: _batteryOptimizationDisabled,
                  onRequest: () =>
                      _request(Permission.ignoreBatteryOptimizations),
                ),
              if (needsTimerAccess) const SizedBox(height: 10),
              if (needsTimerAccess)
                _AccessCard(
                  icon: Icons.alarm_outlined,
                  title: 'Exact alarms',
                  description: 'Alert exactly when a rest timer ends',
                  granted: _exactAlarmGranted,
                  onRequest: () => _request(Permission.scheduleExactAlarm),
                ),
              if (!hasRequirements)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: colors.primary),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'No additional Android access is needed for your current settings.',
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      actions: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
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
        ),
      ],
    );
  }
}

class _AccessCard extends StatelessWidget {
  const _AccessCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.granted,
    required this.onRequest,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool granted;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: colors.onSurfaceVariant, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (granted)
            Tooltip(
              message: 'Allowed',
              child: Icon(Icons.check_circle, color: colors.primary),
            )
          else
            TextButton(onPressed: onRequest, child: const Text('Allow')),
        ],
      ),
    );
  }
}
