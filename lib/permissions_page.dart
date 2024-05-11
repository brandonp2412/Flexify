import 'package:flexify/settings_state.dart';
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
  void initState() {
    super.initState();
    Permission.notification.isGranted.then(
      (value) => setState(() {
        _notify = value;
      }),
    );
    Permission.ignoreBatteryOptimizations.isGranted.then(
      (value) => setState(() {
        _ignore = value;
      }),
    );
    Permission.scheduleExactAlarm.isGranted.then(
      (value) => setState(() {
        _schedule = value;
      }),
    );
  }

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
                onTap: () => settings.setTimers(!settings.restTimers),
                trailing: Switch(
                  value: settings.restTimers,
                  onChanged: (value) => settings.setTimers(value),
                ),
              ),
              ListTile(
                title: const Text('Disable battery optimizations'),
                subtitle: const Text(
                  'Progress may pause if battery optimizations stay on.',
                ),
                onTap: () async {
                  final status =
                      await Permission.ignoreBatteryOptimizations.request();
                  setState(() {
                    _ignore = status.isGranted;
                  });
                },
                trailing: Switch(
                  value: _ignore,
                  onChanged: (value) {},
                ),
              ),
              ListTile(
                title: const Text('Schedule exact alarm'),
                subtitle: const Text(
                  'Alarms cannot be accurate if this is disabled.',
                ),
                onTap: () async {
                  final status = await Permission.scheduleExactAlarm.request();
                  setState(() {
                    _schedule = status.isGranted;
                  });
                },
                trailing: Switch(
                  value: _schedule,
                  onChanged: (value) {},
                ),
              ),
              ListTile(
                title: const Text('Post notifications'),
                subtitle: const Text(
                  'Timer progress is sent to the notification bar',
                ),
                onTap: () async {
                  final status = await Permission.notification.request();
                  setState(() {
                    _notify = status.isGranted;
                  });
                },
                trailing: Switch(
                  value: _notify,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if ((!_ignore || !_schedule) && settings.restTimers)
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
                        settings.setExplained(true);
                      },
                    ),
                  ],
                );
              },
            );
          else {
            Navigator.pop(context);
            settings.setExplained(true);
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
