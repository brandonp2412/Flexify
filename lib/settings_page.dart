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
  late SettingsState settings = context.read<SettingsState>();
  late final minutesController =
      TextEditingController(text: settings.timerDuration.inMinutes.toString());
  late final secondsController = TextEditingController(
    text: (settings.timerDuration.inSeconds % 60).toString(),
  );
  late final maxSetsController =
      TextEditingController(text: settings.maxSets.toString());
  final searchController = TextEditingController();

  AudioPlayer? player;

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
    if (platformSupportsTimer()) player = AudioPlayer();
  }

  @override
  void dispose() {
    if (platformSupportsTimer()) {
      player?.stop();
      player?.dispose();
    }

    searchController.dispose();
    minutesController.dispose();
    secondsController.dispose();
    maxSetsController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    settings = context.watch<SettingsState>();

    List<SettingsLine> lines = [
      SettingsLine(
        key: 'theme',
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
      SettingsLine(
        key: 'strength unit',
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButtonFormField<String>(
            value: settings.strengthUnit,
            decoration: const InputDecoration(labelText: 'Strength unit'),
            items: ['kg', 'lb'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) => settings.setStrengthUnit(value!),
          ),
        ),
      ),
      SettingsLine(
        key: 'cardio unit',
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButtonFormField<String>(
            value: settings.cardioUnit,
            decoration: const InputDecoration(labelText: 'Cardio unit'),
            items: ['km', 'mi'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) => settings.setCardioUnit(value!),
          ),
        ),
      ),
      SettingsLine(
        key: 'long date format',
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
      SettingsLine(
        key: 'short date format',
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
      SettingsLine(
        key: 'plan trailing',
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButtonFormField<PlanTrailing>(
            value: settings.planTrailing,
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
            onChanged: (value) => settings.setPlanTrailing(value!),
          ),
        ),
      ),
      SettingsLine(
        key: 'max sets',
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: maxSetsController,
            decoration: const InputDecoration(
              labelText: 'Sets per exercise',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            onTap: () => selectAll(maxSetsController),
            onChanged: (value) => settings.setMaxSets(int.tryParse(value) ?? 3),
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
                        controller: minutesController,
                        keyboardType: TextInputType.number,
                        onTap: () => selectAll(minutesController),
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
                        decoration: const InputDecoration(
                          labelText: 'seconds',
                        ),
                        controller: secondsController,
                        keyboardType: TextInputType.number,
                        onTap: () => selectAll(secondsController),
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
      if (platformSupportsTimer())
        SettingsLine(
          key: 'rest timers',
          widget: ListTile(
            title: const Text('Rest timers'),
            leading: settings.restTimers
                ? const Icon(Icons.timer)
                : const Icon(Icons.timer_outlined),
            onTap: () {
              settings.setTimers(!settings.restTimers);
            },
            trailing: Switch(
              value: settings.restTimers,
              onChanged: (value) => settings.setTimers(value),
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
              settings.setVibrate(!settings.vibrate);
            },
            trailing: Switch(
              value: settings.vibrate,
              onChanged: (value) => settings.setVibrate(value),
            ),
          ),
        ),
      SettingsLine(
        key: 'group history',
        widget: ListTile(
          title: const Text('Group history'),
          leading: const Icon(Icons.expand_more),
          onTap: () => settings.setGroupHistory(!settings.groupHistory),
          trailing: Switch(
            value: settings.groupHistory,
            onChanged: (value) => settings.setGroupHistory(value),
          ),
        ),
      ),
      SettingsLine(
        key: 'show units',
        widget: ListTile(
          title: const Text('Show units'),
          leading: const Icon(Icons.scale_sharp),
          onTap: () => settings.setUnits(!settings.showUnits),
          trailing: Switch(
            value: settings.showUnits,
            onChanged: (value) => settings.setUnits(value),
          ),
        ),
      ),
      SettingsLine(
        key: 'show images',
        widget: ListTile(
          title: const Text('Show images'),
          leading: settings.showImages
              ? const Icon(Icons.image)
              : const Icon(Icons.image_outlined),
          onTap: () => settings.setShowImages(!settings.showImages),
          trailing: Switch(
            value: settings.showImages,
            onChanged: (value) => settings.setShowImages(value),
          ),
        ),
      ),
      SettingsLine(
        key: 'system color',
        widget: ListTile(
          title: const Text('System color scheme'),
          leading: settings.systemColors
              ? const Icon(Icons.color_lens)
              : const Icon(Icons.color_lens_outlined),
          onTap: () => settings.setSystem(!settings.systemColors),
          trailing: Switch(
            value: settings.systemColors,
            onChanged: (value) => settings.setSystem(value),
          ),
        ),
      ),
      if (platformSupportsTimer())
        SettingsLine(
          key: 'hide timer tab',
          widget: ListTile(
            title: const Text('Hide timer tab'),
            leading: settings.hideTimerTab
                ? const Icon(Icons.timer_outlined)
                : const Icon(Icons.timer),
            onTap: () => settings.setHideTimer(!settings.hideTimerTab),
            trailing: Switch(
              value: settings.hideTimerTab,
              onChanged: (value) => settings.setHideTimer(value),
            ),
          ),
        ),
      SettingsLine(
        key: 'hide history tab',
        widget: ListTile(
          title: const Text('Hide history tab'),
          leading: const Icon(Icons.history),
          onTap: () => settings.setHideHistory(!settings.hideHistoryTab),
          trailing: Switch(
            value: settings.hideHistoryTab,
            onChanged: (value) => settings.setHideHistory(value),
          ),
        ),
      ),
      SettingsLine(
        key: 'hide weight',
        widget: ListTile(
          title: const Text('Hide weight'),
          leading: const Icon(Icons.scale_outlined),
          onTap: () => settings.setHideWeight(!settings.hideWeight),
          trailing: Switch(
            value: settings.hideWeight,
            onChanged: (value) => settings.setHideWeight(value),
          ),
        ),
      ),
      SettingsLine(
        key: 'curve line graphs',
        widget: ListTile(
          title: const Text('Curve line graphs'),
          leading: const Icon(Icons.insights),
          onTap: () => settings.setCurvedLines(!settings.curveLines),
          trailing: Switch(
            value: settings.curveLines,
            onChanged: (value) => settings.setCurvedLines(value),
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
              settings.setAlarm(result.files.single.path!);
              player?.play(DeviceFileSource(result.files.single.path!));
            },
            onLongPress: () {
              settings.setAlarm('');
            },
            icon: const Icon(Icons.music_note),
            label: settings.alarmSound.isEmpty
                ? const Text("Alarm sound")
                : Text(settings.alarmSound.split('/').last),
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
              element.key.contains(searchController.text.toLowerCase()),
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
              controller: searchController,
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
