import 'package:flexify/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController minutesController;
  late TextEditingController secondsController;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsState>();
    minutesController = TextEditingController(
        text: settings.timerDuration.inMinutes.toString());
    secondsController = TextEditingController(
        text: (settings.timerDuration.inSeconds % 60).toString());
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: <Widget>[
            DropdownButtonFormField(
              value: settings.themeMode,
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
                settings.setTheme(value!);
              },
            ),
            const SizedBox(
              height: 8.0,
            ),
            Row(children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Rest minutes'),
                  controller: minutesController,
                  keyboardType: TextInputType.number,
                  onTap: () async {
                    minutesController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: minutesController.text.length);
                  },
                  onChanged: (value) {
                    settings.setDuration(Duration(
                        minutes: int.parse(value),
                        seconds: settings.timerDuration.inSeconds % 60));
                  },
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Rest seconds'),
                  controller: secondsController,
                  keyboardType: TextInputType.number,
                  onTap: () async {
                    secondsController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: secondsController.text.length);
                  },
                  onChanged: (value) {
                    settings.setDuration(Duration(
                        seconds: int.parse(value),
                        minutes: settings.timerDuration.inMinutes.floor()));
                  },
                ),
              ),
            ]),
            ListTile(
              title: const Text('Rest timers'),
              onTap: () {
                settings.setTimers(!settings.restTimers);
              },
              trailing: Switch(
                value: settings.restTimers,
                onChanged: (value) {
                  settings.setTimers(value);
                },
              ),
            ),
            ListTile(
              title: const Text('Re-order items'),
              onTap: () {
                settings.setReorder(!settings.showReorder);
              },
              trailing: Switch(
                value: settings.showReorder,
                onChanged: (value) {
                  settings.setReorder(value);
                },
              ),
            ),
            ListTile(
              title: const Text('Show units'),
              onTap: () {
                settings.setUnits(!settings.showUnits);
              },
              trailing: Switch(
                value: settings.showUnits,
                onChanged: (value) {
                  settings.setUnits(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
