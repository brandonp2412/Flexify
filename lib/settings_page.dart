import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/delete_records_button.dart';
import 'package:flexify/export_data.dart';
import 'package:flexify/import_data.dart';
import 'package:flexify/settings_state.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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
  final _searchController = TextEditingController();
  late AudioPlayer _player;

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
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _player.stop();
    _player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();
    List<WidgetSettings> children = [
      WidgetSettings(
        key: 'theme',
        widget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<ThemeMode>(
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
              labelText:
                  'Long date format (${DateFormat(settings.longDateFormat).format(DateTime.now())})',
            ),
          ),
        ),
      ),
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
              labelText:
                  'Short date format (${DateFormat(settings.shortDateFormat).format(DateTime.now())})',
            ),
          ),
        ),
      ),
      WidgetSettings(
        key: 'plan trailing',
        widget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<PlanTrailing>(
            value: settings.planTrailing,
            decoration: const InputDecoration(
              labelStyle: TextStyle(),
              labelText: 'Plan trailing display',
            ),
            items: const [
              DropdownMenuItem(
                value: PlanTrailing.reorder,
                child: Text("Re-order"),
              ),
              DropdownMenuItem(
                value: PlanTrailing.count,
                child: Text("Count"),
              ),
            ],
            onChanged: (value) => settings.setPlanTrailing(value!),
          ),
        ),
      ),
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
        key: 'vibrate',
        widget: ListTile(
          title: const Text('Vibrate'),
          onTap: () {
            settings.setVibrate(!settings.vibrate);
          },
          trailing: Switch(
            value: settings.vibrate,
            onChanged: (value) => settings.setVibrate(value),
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
          onTap: () => settings.setHideTimer(!settings.hideTimerTab),
          trailing: Switch(
            value: settings.hideTimerTab,
            onChanged: (value) => settings.setHideTimer(value),
          ),
        ),
      ),
      WidgetSettings(
        key: 'hide history tab',
        widget: ListTile(
          title: const Text('Hide history tab'),
          onTap: () => settings.setHideHistory(!settings.hideHistoryTab),
          trailing: Switch(
            value: settings.hideHistoryTab,
            onChanged: (value) => settings.setHideHistory(value),
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
      WidgetSettings(
        key: 'automatic backups',
        widget: ListTile(
          title: const Text('Backup automatically'),
          onTap: () => settings.setAutomatic(!settings.automaticBackup),
          trailing: Switch(
            value: settings.automaticBackup,
            onChanged: (value) => settings.setAutomatic(value),
          ),
        ),
      ),
      WidgetSettings(
        key: 'alarm sound',
        widget: material.TextButton.icon(
          onPressed: () async {
            final result =
                await FilePicker.platform.pickFiles(type: FileType.audio);
            if (result == null || result.files.single.path == null) return;
            settings.setAlarm(result.files.single.path!);
            _player.play(DeviceFileSource(result.files.single.path!));
          },
          onLongPress: () {
            settings.setAlarm(null);
          },
          icon: const Icon(Icons.music_note),
          label: settings.alarmSound == null
              ? const Text("Alarm sound")
              : Text(settings.alarmSound!.split('/').last),
        ),
      ),
      WidgetSettings(
        key: 'share database',
        widget: TextButton.icon(
          onPressed: () async {
            final dbFolder = await getApplicationDocumentsDirectory();
            final dbPath = join(dbFolder.path, 'flexify.sqlite');
            await Share.shareXFiles([XFile(dbPath)]);
          },
          label: const Text("Share database"),
          icon: const Icon(Icons.share),
        ),
      ),
      WidgetSettings(key: 'export data', widget: const ExportData()),
      WidgetSettings(
        key: 'import data',
        widget: ImportData(
          pageContext: context,
        ),
      ),
      WidgetSettings(
        key: 'delete records',
        widget: DeleteRecordsButton(
          pageContext: context,
        ),
      ),
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
                  controller: _searchController,
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                  leading: const Icon(Icons.search),
                ),
              ] +
              children
                  .where(
                    (element) => element.key
                        .contains(_searchController.text.toLowerCase()),
                  )
                  .map((e) => e.widget)
                  .toList(),
        ),
      ),
    );
  }
}
