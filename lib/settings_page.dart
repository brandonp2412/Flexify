import 'package:flexify/delete_records_button.dart';
import 'package:flexify/import_data.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/export_data.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  final searchController = TextEditingController();

  final List<String> shortFormats = [
    'd/M/yy',
    'M/d/yy',
    'd-M-yy',
    'M-d-yy',
    'd.M.yy',
    'M.d.yy',
  ];

  final List<String> longFormats = [
    'dd/MM/yy',
    'dd/MM/yy h:mm a',
    'EEE h:mm a',
    'yyyy-MM-dd',
    'yyyy-MM-dd h:mm a',
    'yyyy.MM.dd',
  ];

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
    List<WidgetSettings> children = [
      WidgetSettings(
        key: 'theme',
        widget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            value: settings.themeMode,
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
            onChanged: (value) => settings.setTheme(value!),
          ),
        ),
      ),
      WidgetSettings(
        key: 'rest minutes seconds',
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: material.Column(
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
                      onChanged: (value) => settings.setDuration(
                        Duration(
                          minutes: int.parse(value),
                          seconds: settings.timerDuration.inSeconds % 60,
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
                      onChanged: (value) => settings.setDuration(
                        Duration(
                          seconds: int.parse(value),
                          minutes: settings.timerDuration.inMinutes.floor(),
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
          key: 'long date format',
          widget: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: DropdownButtonFormField<String>(
              value: settings.longDateFormat,
              items: longFormats.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                settings.setLong(newValue!);
              },
              decoration: InputDecoration(
                labelText: 'Long date format',
                helperText:
                    'Current date: ${DateFormat(settings.longDateFormat).format(DateTime.now())}',
              ),
            ),
          )),
      WidgetSettings(
          key: 'short date format',
          widget: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: DropdownButtonFormField<String>(
              value: settings.shortDateFormat,
              items: shortFormats.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                settings.setShort(newValue!);
              },
              decoration: InputDecoration(
                labelText: 'Short date format',
                helperText:
                    'Current date: ${DateFormat(settings.shortDateFormat).format(DateTime.now())}',
              ),
            ),
          )),
      WidgetSettings(
        key: 'rest timers',
        widget: ListTile(
          title: const Text('Rest timers'),
          onTap: () {
            settings.setTimers(!settings.restTimers);
          },
          trailing: Switch(
            value: settings.restTimers,
            onChanged: (value) => settings.setTimers(value),
          ),
        ),
      ),
      WidgetSettings(
        key: 'reorder items',
        widget: ListTile(
          title: const Text('Re-order items'),
          onTap: () => settings.setReorder(!settings.showReorder),
          trailing: Switch(
            value: settings.showReorder,
            onChanged: (value) => settings.setReorder(value),
          ),
        ),
      ),
      WidgetSettings(
        key: 'show units',
        widget: ListTile(
          title: const Text('Show units'),
          onTap: () => settings.setUnits(!settings.showUnits),
          trailing: Switch(
            value: settings.showUnits,
            onChanged: (value) => settings.setUnits(value),
          ),
        ),
      ),
      WidgetSettings(
        key: 'system color',
        widget: ListTile(
          title: const Text('System color scheme'),
          onTap: () => settings.setSystem(!settings.systemColors),
          trailing: Switch(
            value: settings.systemColors,
            onChanged: (value) => settings.setSystem(value),
          ),
        ),
      ),
      WidgetSettings(
        key: 'hide timer tab',
        widget: ListTile(
          title: const Text('Hide timer tab'),
          onTap: () => settings.setHideTimerTab(!settings.hideTimerTab),
          trailing: Switch(
            value: settings.hideTimerTab,
            onChanged: (value) => settings.setHideTimerTab(value),
          ),
        ),
      ),
      WidgetSettings(
        key: 'curve line graphs',
        widget: ListTile(
          title: const Text('Curve line graphs'),
          onTap: () => settings.setCurvedLines(!settings.curveLines),
          trailing: Switch(
            value: settings.curveLines,
            onChanged: (value) => settings.setCurvedLines(value),
          ),
        ),
      ),
      WidgetSettings(key: 'download csv', widget: const ImportData()),
      WidgetSettings(
          key: 'upload csv',
          widget: ExportData(
            pageContext: context,
          )),
      WidgetSettings(
          key: 'delete records',
          widget: DeleteRecordsButton(
            pageContext: context,
          )),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
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
