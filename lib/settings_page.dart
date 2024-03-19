import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class WidgetSettings {
  final String key;
  final Widget widget;

  WidgetSettings({required this.key, required this.widget});
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController minutesController;
  late TextEditingController secondsController;
  TextEditingController searchController = TextEditingController();

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
    final settingsState = context.watch<SettingsState>();
    List<WidgetSettings> children = [
      WidgetSettings(
        key: 'theme',
        widget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            value: settingsState.themeMode,
            decoration: const InputDecoration(
              labelStyle: TextStyle(),
              labelText: 'Theme',
            ),
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
        ),
      ),
      WidgetSettings(
        key: 'rest minutes seconds',
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration:
                          const InputDecoration(labelText: 'Rest minutes'),
                      controller: minutesController,
                      keyboardType: TextInputType.number,
                      onTap: () async {
                        minutesController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: minutesController.text.length,
                        );
                      },
                      onChanged: (value) async =>
                          await settingsState.setDuration(
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
                      decoration:
                          const InputDecoration(labelText: 'Rest seconds'),
                      controller: secondsController,
                      keyboardType: TextInputType.number,
                      onTap: () async {
                        secondsController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: secondsController.text.length,
                        );
                      },
                      onChanged: (value) async =>
                          await settingsState.setDuration(
                        Duration(
                          seconds: int.parse(value),
                          minutes:
                              settingsState.timerDuration.inMinutes.floor(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      WidgetSettings(
        key: 'rest timers',
        widget: ListTile(
          title: const Text('Rest timers'),
          onTap: () async =>
              await settingsState.setTimers(!settingsState.restTimers),
          trailing: Switch(
            value: settingsState.restTimers,
            onChanged: (value) async => await settingsState.setTimers(value),
          ),
        ),
      ),
      WidgetSettings(
        key: 'reorder items',
        widget: ListTile(
          title: const Text('Re-order items'),
          onTap: () async =>
              await settingsState.setReorder(!settingsState.showReorder),
          trailing: Switch(
            value: settingsState.showReorder,
            onChanged: (value) async => await settingsState.setReorder(value),
          ),
        ),
      ),
      WidgetSettings(
        key: 'show units',
        widget: ListTile(
          title: const Text('Show units'),
          onTap: () async =>
              await settingsState.setUnits(!settingsState.showUnits),
          trailing: Switch(
            value: settingsState.showUnits,
            onChanged: (value) async => await settingsState.setUnits(value),
          ),
        ),
      ),
      WidgetSettings(
        key: 'system color',
        widget: ListTile(
          title: const Text('Use system color scheme'),
          onTap: () async =>
              await settingsState.setSystem(!settingsState.systemColors),
          trailing: Switch(
            value: settingsState.systemColors,
            onChanged: (value) async => await settingsState.setSystem(value),
          ),
        ),
      ),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
                SearchBar(
                  hintText: "Search...",
                  controller: searchController,
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                  leading: const Icon(Icons.search),
                )
              ] +
              children
                  .where((element) =>
                      element.key.contains(searchController.text.toLowerCase()))
                  .map((e) => e.widget)
                  .toList(),
        ),
      ),
    );
  }
}
