import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/delete_records_button.dart';
import 'package:flexify/export_data.dart';
import 'package:flexify/import_data.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class SettingsLine {
  final String key;
  final Widget widget;

  SettingsLine({required this.key, required this.widget});
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _searchController = TextEditingController();
  final _minutesController = TextEditingController(text: '3');
  final _secondsController = TextEditingController(text: '30');
  final _maxSetsController = TextEditingController(text: '3');

  late AudioPlayer _player;
  late SettingsState _settings;

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
    _settings = context.read<SettingsState>();
    _minutesController.text = _settings.timerDuration.inMinutes.toString();
    _secondsController.text =
        (_settings.timerDuration.inSeconds % 60).toString();
    _maxSetsController.text = _settings.maxSets.toString();
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    _searchController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    _maxSetsController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _settings = context.watch<SettingsState>();
    List<SettingsLine> lines = [
      SettingsLine(
        key: 'theme',
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButtonFormField<ThemeMode>(
            value: _settings.themeMode,
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
            onChanged: (value) => _settings.setTheme(value!),
          ),
        ),
      ),
      SettingsLine(
        key: 'long date format',
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButtonFormField<String>(
            value: _settings.longDateFormat,
            items: longFormats.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              _settings.setLong(newValue!);
            },
            decoration: InputDecoration(
              labelText:
                  'Long date format (${DateFormat(_settings.longDateFormat).format(DateTime.now())})',
            ),
          ),
        ),
      ),
      SettingsLine(
        key: 'short date format',
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButtonFormField<String>(
            value: _settings.shortDateFormat,
            items: shortFormats.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              _settings.setShort(newValue!);
            },
            decoration: InputDecoration(
              labelText:
                  'Short date format (${DateFormat(_settings.shortDateFormat).format(DateTime.now())})',
            ),
          ),
        ),
      ),
      SettingsLine(
        key: 'plan trailing',
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButtonFormField<PlanTrailing>(
            value: _settings.planTrailing,
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
            onChanged: (value) => _settings.setPlanTrailing(value!),
          ),
        ),
      ),
      SettingsLine(
        key: 'max sets',
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: _maxSetsController,
            decoration: const InputDecoration(labelText: 'Maximum sets'),
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            onTap: () => selectAll(_maxSetsController),
            onChanged: (value) =>
                _settings.setMaxSets(int.tryParse(value) ?? 0),
          ),
        ),
      ),
      SettingsLine(
        key: 'rest minutes seconds',
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: material.Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration:
                          const InputDecoration(labelText: 'Rest minutes'),
                      controller: _minutesController,
                      keyboardType: TextInputType.number,
                      onTap: () => selectAll(_minutesController),
                      onChanged: (value) => _settings.setDuration(
                        Duration(
                          minutes: int.parse(value),
                          seconds: _settings.timerDuration.inSeconds % 60,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(labelText: 'seconds'),
                      controller: _secondsController,
                      keyboardType: TextInputType.number,
                      onTap: () => selectAll(_secondsController),
                      onChanged: (value) => _settings.setDuration(
                        Duration(
                          seconds: int.parse(value),
                          minutes: _settings.timerDuration.inMinutes.floor(),
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
      SettingsLine(
        key: 'rest timers',
        widget: ListTile(
          title: const Text('Rest timers'),
          onTap: () {
            _settings.setTimers(!_settings.restTimers);
          },
          trailing: Switch(
            value: _settings.restTimers,
            onChanged: (value) => _settings.setTimers(value),
          ),
        ),
      ),
      SettingsLine(
        key: 'vibrate',
        widget: ListTile(
          title: const Text('Vibrate'),
          onTap: () {
            _settings.setVibrate(!_settings.vibrate);
          },
          trailing: Switch(
            value: _settings.vibrate,
            onChanged: (value) => _settings.setVibrate(value),
          ),
        ),
      ),
      SettingsLine(
        key: 'show units',
        widget: ListTile(
          title: const Text('Show units'),
          onTap: () => _settings.setUnits(!_settings.showUnits),
          trailing: Switch(
            value: _settings.showUnits,
            onChanged: (value) => _settings.setUnits(value),
          ),
        ),
      ),
      SettingsLine(
        key: 'system color',
        widget: ListTile(
          title: const Text('System color scheme'),
          onTap: () => _settings.setSystem(!_settings.systemColors),
          trailing: Switch(
            value: _settings.systemColors,
            onChanged: (value) => _settings.setSystem(value),
          ),
        ),
      ),
      SettingsLine(
        key: 'hide timer tab',
        widget: ListTile(
          title: const Text('Hide timer tab'),
          onTap: () => _settings.setHideTimer(!_settings.hideTimerTab),
          trailing: Switch(
            value: _settings.hideTimerTab,
            onChanged: (value) => _settings.setHideTimer(value),
          ),
        ),
      ),
      SettingsLine(
        key: 'hide history tab',
        widget: ListTile(
          title: const Text('Hide history tab'),
          onTap: () => _settings.setHideHistory(!_settings.hideHistoryTab),
          trailing: Switch(
            value: _settings.hideHistoryTab,
            onChanged: (value) => _settings.setHideHistory(value),
          ),
        ),
      ),
      SettingsLine(
        key: 'hide weight',
        widget: ListTile(
          title: const Text('Hide weight'),
          onTap: () => _settings.setHideWeight(!_settings.hideWeight),
          trailing: Switch(
            value: _settings.hideWeight,
            onChanged: (value) => _settings.setHideWeight(value),
          ),
        ),
      ),
      SettingsLine(
        key: 'curve line graphs',
        widget: ListTile(
          title: const Text('Curve line graphs'),
          onTap: () => _settings.setCurvedLines(!_settings.curveLines),
          trailing: Switch(
            value: _settings.curveLines,
            onChanged: (value) => _settings.setCurvedLines(value),
          ),
        ),
      ),
      SettingsLine(
        key: 'alarm sound',
        widget: material.TextButton.icon(
          onPressed: () async {
            final result =
                await FilePicker.platform.pickFiles(type: FileType.audio);
            if (result == null || result.files.single.path == null) return;
            _settings.setAlarm(result.files.single.path!);
            _player.play(DeviceFileSource(result.files.single.path!));
          },
          onLongPress: () {
            _settings.setAlarm(null);
          },
          icon: const Icon(Icons.music_note),
          label: _settings.alarmSound == null
              ? const Text("Alarm sound")
              : Text(_settings.alarmSound!.split('/').last),
        ),
      ),
      SettingsLine(
        key: 'share database',
        widget: TextButton.icon(
          onPressed: () async {
            final dbFolder = await getApplicationDocumentsDirectory();
            final dbPath = p.join(dbFolder.path, 'flexify.sqlite');
            await Share.shareXFiles([XFile(dbPath)]);
          },
          label: const Text("Share database"),
          icon: const Icon(Icons.share),
        ),
      ),
      SettingsLine(key: 'export data', widget: const ExportData()),
      SettingsLine(
        key: 'import data',
        widget: ImportData(
          pageContext: context,
        ),
      ),
      SettingsLine(
        key: 'delete records',
        widget: DeleteRecordsButton(
          pageContext: context,
        ),
      ),
    ];

    final filtered = lines
        .where(
          (element) =>
              element.key.contains(_searchController.text.toLowerCase()),
        )
        .map((e) => e.widget)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
            const SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => filtered[index],
                itemCount: filtered.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
