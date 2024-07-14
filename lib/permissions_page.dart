import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
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
  bool schedule = false;
  bool ignore = false;
  bool notify = false;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Missing permissions"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const ListTile(
                title: Text("Rest timers are on, but permissions are missing."),
                subtitle: Text(
                  "If you disable rest timers, then these permissions aren't needed.",
                ),
              ),
              ListTile(
                title: const Text('Rest timers'),
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
                        SettingsCompanion(
                          restTimers: Value(value),
                        ),
                      ),
                ),
              ),
              ListTile(
                title: const Text('Disable battery optimizations'),
                subtitle: const Text(
                  'Progress may pause if battery optimizations stay on.',
                ),
                onTap: () async => await requestPermission(
                  Permission.ignoreBatteryOptimizations,
                ),
                trailing: Switch(
                  value: ignore,
                  onChanged: (_) async => await requestPermission(
                    Permission.ignoreBatteryOptimizations,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Schedule exact alarm'),
                subtitle: const Text(
                  'Alarms cannot be accurate if this is disabled.',
                ),
                onTap: () async =>
                    await requestPermission(Permission.scheduleExactAlarm),
                trailing: Switch(
                  value: schedule,
                  onChanged: (_) async =>
                      await requestPermission(Permission.scheduleExactAlarm),
                ),
              ),
              ListTile(
                title: const Text('Post notifications'),
                subtitle: const Text(
                  'Timer progress is sent to the notification bar',
                ),
                onTap: () async =>
                    await requestPermission(Permission.notification),
                trailing: Switch(
                  value: notify,
                  onChanged: (_) async =>
                      await requestPermission(Permission.notification),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if ((!ignore || !schedule) && settings.value.restTimers)
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Invalid permissions'),
                  content: const Text(
                    'Rest timers are enabled without sufficient permissions. Are you sure?',
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Text('OK'),
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
                  const SettingsCompanion(
                    explainedPermissions: Value(true),
                  ),
                );
          }
        },
        tooltip: "Confirm",
        child: const Icon(Icons.check),
      ),
    );
  }

  Future initPermissionStatus() async {
    notify = await Permission.notification.isGranted;
    ignore = await Permission.ignoreBatteryOptimizations.isGranted;
    schedule = await Permission.scheduleExactAlarm.isGranted;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPermissionStatus();
  }

  Future requestPermission(Permission permission) async {
    final value = await permission.request().isGranted;
    setState(() {
      switch (permission) {
        case Permission.notification:
          notify = value;
        case Permission.ignoreBatteryOptimizations:
          ignore = value;
        case Permission.scheduleExactAlarm:
          schedule = value;
        default:
          return;
      }
    });
  }
}
