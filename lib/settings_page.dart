import 'package:flexify/main.dart';
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
    final appState = context.read<AppState>();
    minutesController = TextEditingController(
        text: appState.timerDuration.inMinutes.toString());
    secondsController = TextEditingController(
        text: (appState.timerDuration.inSeconds % 60).toString());
  }

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
                  controller: minutesController,
                  keyboardType: TextInputType.number,
                  onTap: () async {
                    minutesController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: minutesController.text.length);
                  },
                  onChanged: (value) {
                    appState.setDuration(Duration(
                        minutes: int.parse(value),
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
                  controller: secondsController,
                  keyboardType: TextInputType.number,
                  onTap: () async {
                    secondsController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: secondsController.text.length);
                  },
                  onChanged: (value) {
                    appState.setDuration(Duration(
                        seconds: int.parse(value),
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
                onChanged: (value) {
                  appState.setTimers(value);
                },
              ),
            ),
            ListTile(
              title: const Text('Re-order items'),
              onTap: () {
                appState.setReorder(!appState.showReorder);
              },
              trailing: Switch(
                value: appState.showReorder,
                onChanged: (value) {
                  appState.setReorder(value);
                },
              ),
            ),
            ListTile(
              title: const Text('Show units'),
              onTap: () {
                appState.setUnits(!appState.showUnits);
              },
              trailing: Switch(
                value: appState.showUnits,
                onChanged: (value) {
                  appState.setUnits(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
