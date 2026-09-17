import 'package:drift/drift.dart';
import 'package:flexify/animated_fab.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  bool _schedule = false;
  bool _ignore = false;
  bool _notify = false;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(context.l10n.missingPermissions)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              ListTile(
                title: Text(context.l10n.restTimersPermissionsMissing),
                subtitle: Text(context.l10n.restTimersPermissionsOptional),
              ),
              ListTile(
                title: Text(context.l10n.restTimers),
                onTap: () {
                  db.settings.update().write(
                    SettingsCompanion(
                      restTimers: Value(!settings.value.restTimers),
                    ),
                  );
                },
                trailing: Switch(
                  value: settings.value.restTimers,
                  onChanged: (value) => db.settings.update().write(
                    SettingsCompanion(restTimers: Value(value)),
                  ),
                ),
              ),
              ListTile(
                title: Text(context.l10n.disableBatteryOptimizations),
                subtitle: Text(context.l10n.batteryOptimizationWarning),
                onTap: () async => await requestPermission(
                  Permission.ignoreBatteryOptimizations,
                ),
                trailing: Switch(
                  value: _ignore,
                  onChanged: (_) async => await requestPermission(
                    Permission.ignoreBatteryOptimizations,
                  ),
                ),
              ),
              ListTile(
                title: Text(context.l10n.scheduleExactAlarm),
                subtitle: Text(context.l10n.exactAlarmWarning),
                onTap: () async =>
                    await requestPermission(Permission.scheduleExactAlarm),
                trailing: Switch(
                  value: _schedule,
                  onChanged: (_) async =>
                      await requestPermission(Permission.scheduleExactAlarm),
                ),
              ),
              ListTile(
                title: Text(context.l10n.postNotifications),
                subtitle: Text(context.l10n.notificationBarDescription),
                onTap: () async =>
                    await requestPermission(Permission.notification),
                trailing: Switch(
                  value: _notify,
                  onChanged: (_) async =>
                      await requestPermission(Permission.notification),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedFab(
        onPressed: () {
          if ((!_ignore || !_schedule) && settings.value.restTimers)
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(context.l10n.invalidPermissions),
                  content: Text(
                    context.l10n.insufficientTimerPermissionsConfirmation,
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(context.l10n.actionCancel),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text(context.l10n.actionOk),
                      onPressed: () async {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        db.settings.update().write(
                          const SettingsCompanion(
                            explainedPermissions: Value(true),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          else {
            Navigator.pop(context);
            db.settings.update().write(
              const SettingsCompanion(explainedPermissions: Value(true)),
            );
          }
        },
        label: Text(context.l10n.actionConfirm),
        icon: const Icon(Icons.check),
      ),
    );
  }

  Future initPermissionStatus() async {
    _notify = await Permission.notification.isGranted;
    _ignore = await Permission.ignoreBatteryOptimizations.isGranted;
    _schedule = await Permission.scheduleExactAlarm.isGranted;
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPermissionStatus();
  }

  Future requestPermission(Permission permission) async {
    final value = await permission.request().isGranted;
    if (!mounted) return;
    setState(() {
      switch (permission) {
        case Permission.notification:
          _notify = value;
        case Permission.ignoreBatteryOptimizations:
          _ignore = value;
        case Permission.scheduleExactAlarm:
          _schedule = value;
        default:
          return;
      }
    });
  }
}
