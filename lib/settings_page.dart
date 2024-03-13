import 'package:duration_picker/duration_picker.dart';
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
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: <Widget>[
            DropdownButtonFormField(
              value: appState.themeMode,
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
                appState.setTheme(value!);
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
                      text: appState.timerDuration.inMinutes.toString()),
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  onTap: () async {
                    final result = await showDurationPicker(
                        context: context,
                        initialTime: Duration(
                            minutes: appState.timerDuration.inMinutes));
                    if (result == null) return;
                    appState.setDuration(Duration(
                        minutes: result.inMinutes,
                        seconds: appState.timerDuration.inSeconds % 60));
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
                      text: (appState.timerDuration.inSeconds % 60).toString()),
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  onTap: () async {
                    final result = await showDurationPicker(
                        context: context,
                        baseUnit: BaseUnit.second,
                        initialTime: Duration(
                            seconds: appState.timerDuration.inSeconds % 60));
                    if (result == null) return;
                    appState.setDuration(Duration(
                        seconds: result.inSeconds,
                        minutes: appState.timerDuration.inMinutes.floor()));
                  },
                ),
              ),
            ]),
            ListTile(
              title: const Text('Rest timers'),
              onTap: () {
                appState.setTimers(!appState.restTimers);
              },
              trailing: Switch(
                value: appState.restTimers,
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: const Text('Re-order items'),
              onTap: () {
                appState.setReorder(!appState.showReorder);
              },
              trailing: Switch(
                value: appState.showReorder,
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
