import 'package:duration_picker/duration_picker.dart';
import 'package:flexify/app_state.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: <Widget>[
            DropdownButtonFormField(
              value: settingsState.themeMode,
              decoration: const InputDecoration(
                  labelStyle: TextStyle(), labelText: 'Theme'),
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text("System"),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text("Dark"),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text("Light"),
                ),
              ],
              onChanged: (value) {
                settingsState.setTheme(value!);
              },
            ),
            const SizedBox(
              height: 8.0,
            ),
            Row(children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Rest minutes'),
                  controller: TextEditingController(
                      text: settingsState.timerDuration.inMinutes.toString()),
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  onTap: () async {
                    final result = await showDurationPicker(
                        context: context,
                        initialTime: Duration(
                            minutes: settingsState.timerDuration.inMinutes));
                    if (result == null) return;
                    settingsState.setDuration(Duration(
                        minutes: result.inMinutes,
                        seconds: settingsState.timerDuration.inSeconds % 60));
                  },
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Rest seconds'),
                  controller: TextEditingController(
                      text: (settingsState.timerDuration.inSeconds % 60).toString()),
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  onTap: () async {
                    final result = await showDurationPicker(
                        context: context,
                        baseUnit: BaseUnit.second,
                        initialTime: Duration(
                            seconds: settingsState.timerDuration.inSeconds % 60));
                    if (result == null) return;
                    settingsState.setDuration(Duration(
                        seconds: result.inSeconds,
                        minutes: settingsState.timerDuration.inMinutes.floor()));
                  },
                ),
              ),
            ]),
            ListTile(
              title: const Text('Rest timers'),
              onTap: () {
                settingsState.setTimers(!settingsState.restTimers);
              },
              trailing: Switch(
                value: settingsState.restTimers,
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: const Text('Re-order items'),
              onTap: () {
                settingsState.setReorder(!settingsState.showReorder);
              },
              trailing: Switch(
                value: settingsState.showReorder,
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
