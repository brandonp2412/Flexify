import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin {
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
    super.build(context);
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
              onChanged: (value) async => await settingsState.setTheme(value!),
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
                      extentOffset: minutesController.text.length,
                    );
                  },
                  onChanged: (value) async => await settingsState.setDuration(
                    Duration(
                      minutes: int.parse(value),
                      seconds: settingsState.timerDuration.inSeconds % 60,
                    ),
                  ),
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
                  onChanged: (value) async => await settingsState.setDuration(
                    Duration(
                      seconds: int.parse(value),
                      minutes: settingsState.timerDuration.inMinutes.floor(),
                    ),
                  ),
                ),
              ),
            ]),
            ListTile(
              title: const Text('Rest timers'),
              onTap: () async =>
                  await settingsState.setTimers(!settingsState.restTimers),
              trailing: Switch(
                value: settingsState.restTimers,
                onChanged: (value) async =>
                    await settingsState.setTimers(value),
              ),
            ),
            ListTile(
              title: const Text('Re-order items'),
              onTap: () async =>
                  await settingsState.setReorder(!settingsState.showReorder),
              trailing: Switch(
                value: settingsState.showReorder,
                onChanged: (value) async =>
                    await settingsState.setReorder(value),
              ),
            ),
            ListTile(
              title: const Text('Show units'),
              onTap: () async =>
                  await settingsState.setUnits(!settingsState.showUnits),
              trailing: Switch(
                value: settingsState.showUnits,
                onChanged: (value) async => await settingsState.setUnits(value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
