import 'package:audioplayers/audioplayers.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Widget> getTimers(
  String term,
  Setting settings,
  TextEditingController minutesController,
  TextEditingController secondsController,
  AudioPlayer player,
) {
  return [
    if ('rest minutes seconds'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Rest minutes',
                ),
                controller: minutesController,
                keyboardType: TextInputType.number,
                onTap: () => selectAll(minutesController),
                onChanged: (value) => db.settings.update().write(
                      SettingsCompanion(
                        timerDuration: Value(
                          Duration(
                            minutes: int.parse(value),
                            seconds:
                                Duration(milliseconds: settings.timerDuration)
                                        .inSeconds %
                                    60,
                          ).inMilliseconds,
                        ),
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
                onChanged: (value) => db.settings.update().write(
                      SettingsCompanion(
                        timerDuration: Value(
                          Duration(
                            seconds: int.parse(value),
                            minutes:
                                Duration(milliseconds: settings.timerDuration)
                                    .inMinutes
                                    .floor(),
                          ).inMilliseconds,
                        ),
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    if ('rest timers'.contains(term.toLowerCase()))
      ListTile(
        title: const Text('Rest timers'),
        leading: settings.restTimers
            ? const Icon(Icons.timer)
            : const Icon(Icons.timer_outlined),
        onTap: () => db.settings.update().write(
              SettingsCompanion(
                restTimers: Value(!settings.restTimers),
              ),
            ),
        trailing: Switch(
          value: settings.restTimers,
          onChanged: (value) => db.settings.update().write(
                SettingsCompanion(
                  restTimers: Value(value),
                ),
              ),
        ),
      ),
    if ('vibrate'.contains(term.toLowerCase()))
      ListTile(
        title: const Text('Vibrate'),
        leading: const Icon(Icons.vibration),
        onTap: () => db.settings.update().write(
              SettingsCompanion(
                vibrate: Value(!settings.vibrate),
              ),
            ),
        trailing: Switch(
          value: settings.vibrate,
          onChanged: (value) => db.settings.update().write(
                SettingsCompanion(
                  vibrate: Value(value),
                ),
              ),
        ),
      ),
    if ('hide timer tab'.contains(term.toLowerCase()))
      ListTile(
        title: const Text('Hide timer tab'),
        leading: settings.hideTimerTab
            ? const Icon(Icons.timer_outlined)
            : const Icon(Icons.timer),
        onTap: () => db.settings.update().write(
              SettingsCompanion(
                hideTimerTab: Value(!settings.hideTimerTab),
              ),
            ),
        trailing: Switch(
          value: settings.hideTimerTab,
          onChanged: (value) => db.settings.update().write(
                SettingsCompanion(
                  hideTimerTab: Value(value),
                ),
              ),
        ),
      ),
    if ('alarm sound'.contains(term.toLowerCase()))
      TextButton.icon(
        onPressed: () async {
          final result =
              await FilePicker.platform.pickFiles(type: FileType.audio);
          if (result == null || result.files.single.path == null) return;
          db.settings.update().write(
                SettingsCompanion(
                  alarmSound: Value(result.files.single.path!),
                ),
              );
          player.play(DeviceFileSource(result.files.single.path!));
        },
        onLongPress: () {
          db.settings.update().write(
                const SettingsCompanion(
                  alarmSound: Value(''),
                ),
              );
        },
        icon: const Icon(Icons.music_note),
        label: settings.alarmSound.isEmpty
            ? const Text("Alarm sound")
            : Text(settings.alarmSound.split('/').last),
      ),
  ];
}

class SettingsTimer extends StatefulWidget {
  const SettingsTimer({super.key});

  @override
  State<SettingsTimer> createState() => _SettingsTimerState();
}

class _SettingsTimerState extends State<SettingsTimer> {
  late SettingsState settings = context.read<SettingsState>();
  late final minutesController = TextEditingController(
    text: (Duration(milliseconds: settings.value.timerDuration))
        .inMinutes
        .toString(),
  );
  late final secondsController = TextEditingController(
    text:
        ((Duration(milliseconds: settings.value.timerDuration)).inSeconds % 60)
            .toString(),
  );

  AudioPlayer player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Timers"),
      ),
      body: ListView(
        children: getTimers(
          '',
          settings.value,
          minutesController,
          secondsController,
          player,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    minutesController.dispose();
    secondsController.dispose();
    player.stop();
    player.dispose();
  }
}
