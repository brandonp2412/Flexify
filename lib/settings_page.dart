import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/about_page.dart';
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
  late SettingsState _settings = context.read<SettingsState>();
  late final _minutesController =
      TextEditingController(text: _settings.timerDuration.inMinutes.toString());
  late final _secondsController = TextEditingController(
    text: (_settings.timerDuration.inSeconds % 60).toString(),
  );
  late final _maxSetsController =
      TextEditingController(text: _settings.maxSets.toString());
  final _searchController = TextEditingController();

  AudioPlayer? _player;

  final List<String> _shortFormats = [
    'd/M/yy',
    'M/d/yy',
    'd-M-yy',
    'M-d-yy',
    'd.M.yy',
    'M.d.yy',
  ];

  final List<String> _longFormats = [
    'dd/MM/yy',
    'dd/MM/yy h:mm a',
    'dd/MM/yy H:mm',
    'EEE h:mm a',
    'yyyy-MM-dd',
    'yyyy-MM-dd h:mm a',
    'yyyy-MM-dd H:mm',
    'yyyy.MM.dd',
    'yyyy.MM.dd h:mm a',
    'yyyy.MM.dd H:mm',
    'MMM d (EEE) h:mm a',
  ];

  @override
  void initState() {
    super.initState();
    if (platformSupportsTimer()) _player = AudioPlayer();
  }

  @override
  void dispose() {
    if (platformSupportsTimer()) {
      _player?.stop();
      _player?.dispose();
    }

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
        key: 'strength unit',
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButtonFormField<String>(
            value: _settings.strengthUnit,
            decoration: const InputDecoration(labelText: 'Strength unit'),
            items: ['kg', 'lb'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) => _settings.setStrengthUnit(value!),
          ),
        ),
      ),
      SettingsLine(
        key: 'cardio unit',
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButtonFormField<String>(
            value: _settings.cardioUnit,
            decoration: const InputDecoration(labelText: 'Cardio unit'),
            items: ['km', 'mi'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) => _settings.setCardioUnit(value!),
          ),
        ),
      ),
      SettingsLine(
        key: 'long date format',
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButtonFormField<String>(
            value: _settings.longDateFormat,
            items: _longFormats.map((String value) {
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
            items: _shortFormats.map((String value) {
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
                child: material.Row(
                  children: [
                    Text("Re-order"),
                    SizedBox(width: 8),
                    Icon(Icons.menu, size: 18),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: PlanTrailing.count,
                child: Row(
                  children: [
                    Text("Count"),
                    SizedBox(width: 8),
                    Text("(5)"),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: PlanTrailing.percent,
                child: Row(
                  children: [
                    Text("Percent"),
                    SizedBox(width: 8),
                    Text("(50%)"),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: PlanTrailing.ratio,
                child: Row(
                  children: [
                    Text("Ratio"),
                    SizedBox(width: 8),
                    Text("(5 / 10)"),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: PlanTrailing.none,
                child: Text("None"),
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
            decoration: const InputDecoration(
              labelText: 'Maximum sets',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            onTap: () => selectAll(_maxSetsController),
            onChanged: (value) =>
                _settings.setMaxSets(int.tryParse(value) ?? 0),
          ),
        ),
      ),
      if (platformSupportsTimer())
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
                        decoration: const InputDecoration(
                          labelText: 'Rest minutes',
                        ),
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
                        decoration: const InputDecoration(
                          labelText: 'seconds',
                        ),
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
      if (platformSupportsTimer())
        SettingsLine(
          key: 'rest timers',
          widget: ListTile(
            title: const Text('Rest timers'),
            leading: _settings.restTimers
                ? const Icon(Icons.timer)
                : const Icon(Icons.timer_outlined),
            onTap: () {
              _settings.setTimers(!_settings.restTimers);
            },
            trailing: Switch(
              value: _settings.restTimers,
              onChanged: (value) => _settings.setTimers(value),
            ),
          ),
        ),
      if (platformSupportsTimer())
        SettingsLine(
          key: 'vibrate',
          widget: ListTile(
            title: const Text('Vibrate'),
            leading: const Icon(Icons.vibration),
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
        key: 'group history',
        widget: ListTile(
          title: const Text('Group history'),
          leading: const Icon(Icons.expand_more),
          onTap: () => _settings.setGroupHistory(!_settings.groupHistory),
          trailing: Switch(
            value: _settings.groupHistory,
            onChanged: (value) => _settings.setGroupHistory(value),
          ),
        ),
      ),
      SettingsLine(
        key: 'show units',
        widget: ListTile(
          title: const Text('Show units'),
          leading: const Icon(Icons.scale_sharp),
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
          leading: _settings.systemColors
              ? const Icon(Icons.color_lens)
              : const Icon(Icons.color_lens_outlined),
          onTap: () => _settings.setSystem(!_settings.systemColors),
          trailing: Switch(
            value: _settings.systemColors,
            onChanged: (value) => _settings.setSystem(value),
          ),
        ),
      ),
      if (platformSupportsTimer())
        SettingsLine(
          key: 'hide timer tab',
          widget: ListTile(
            title: const Text('Hide timer tab'),
            leading: _settings.hideTimerTab
                ? const Icon(Icons.timer_outlined)
                : const Icon(Icons.timer),
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
          leading: const Icon(Icons.history),
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
          leading: const Icon(Icons.scale_outlined),
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
          leading: const Icon(Icons.insights),
          onTap: () => _settings.setCurvedLines(!_settings.curveLines),
          trailing: Switch(
            value: _settings.curveLines,
            onChanged: (value) => _settings.setCurvedLines(value),
          ),
        ),
      ),
      if (platformSupportsTimer())
        SettingsLine(
          key: 'alarm sound',
          widget: material.TextButton.icon(
            onPressed: () async {
              final result =
                  await FilePicker.platform.pickFiles(type: FileType.audio);
              if (result == null || result.files.single.path == null) return;
              _settings.setAlarm(result.files.single.path!);
              _player?.play(DeviceFileSource(result.files.single.path!));
            },
            onLongPress: () {
              _settings.setAlarm('');
            },
            icon: const Icon(Icons.music_note),
            label: _settings.alarmSound.isEmpty
                ? const Text("Alarm sound")
                : Text(_settings.alarmSound.split('/').last),
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
        actions: [
          if (!Platform.isIOS && !Platform.isMacOS)
            IconButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
              icon: const Icon(Icons.info_outline_rounded),
            ),
        ],
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
