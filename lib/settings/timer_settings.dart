import 'package:audioplayers/audioplayers.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Widget> getTimerSettings(
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
        child: Tooltip(
          message: 'How long before rest alarms go off?',
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
      ),
    if ('rest timers'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Alarm that goes off after completing a set',
        child: ListTile(
          title: const Text('Rest timers'),
          leading: settings.restTimers
              ? const Icon(Icons.timer)
              : const Icon(Icons.timer_outlined),
          onTap: () async {
            final newValue = !settings.restTimers;

            if (newValue) {
              await androidChannel.invokeMethod('requestTimerPermissions');
            }

            db.settings.update().write(
                  SettingsCompanion(
                    restTimers: Value(newValue),
                  ),
                );
          },
          trailing: Switch(
            value: settings.restTimers,
            onChanged: (value) async {
              if (value) {
                await androidChannel.invokeMethod('requestTimerPermissions');
              }

              db.settings.update().write(
                    SettingsCompanion(
                      restTimers: Value(value),
                    ),
                  );
            },
          ),
        ),
      ),
    if ('vibrate'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Should rest timers vibrate?',
        child: ListTile(
          title: const Text('Vibrate'),
          leading: const Icon(Icons.vibration),
          onTap: () async {
            final newValue = !settings.vibrate;
            await db.settings.update().write(
                  SettingsCompanion(
                    vibrate: Value(newValue),
                  ),
                );
            if (newValue) {
              try {
                await androidChannel.invokeMethod('previewVibration');
              } catch (e) {
                print('Failed to trigger preview vibration: $e');
              }
            }
          },
          trailing: Switch(
            value: settings.vibrate,
            onChanged: (value) async {
              await db.settings.update().write(
                    SettingsCompanion(
                      vibrate: Value(value),
                    ),
                  );
              if (value) {
                try {
                  await androidChannel.invokeMethod('previewVibration');
                } catch (e) {
                  print('Failed to trigger preview vibration: $e');
                }
              }
            },
          ),
        ),
      ),
    if ('enable sound'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Should rest timers play a sound?',
        child: ListTile(
          title: const Text('Enable sound'),
          leading: const Icon(Icons.music_note_outlined),
          onTap: () => db.settings.update().write(
                SettingsCompanion(
                  enableSound: Value(!settings.enableSound),
                ),
              ),
          trailing: Switch(
            value: settings.enableSound,
            onChanged: (value) => db.settings.update().write(
                  SettingsCompanion(
                    enableSound: Value(value),
                  ),
                ),
          ),
        ),
      ),
    if ('alarm sound'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Music to play at the end of a rest timer',
        child: TextButton.icon(
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
      ),
  ];
}

class TimerSettings extends StatefulWidget {
  const TimerSettings({super.key});

  @override
  State<TimerSettings> createState() => _TimerSettingsState();
}

class _TimerSettingsState extends State<TimerSettings> {
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

  AudioPlayer? player;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      try {
        player = AudioPlayer();
      } catch (e) {
        print('Failed to create AudioPlayer: $e');
        player = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Timers"),
      ),
      body: ListView(
        children: player != null
            ? getTimerSettings(
                '',
                settings.value,
                minutesController,
                secondsController,
                player!,
              )
            : [
                const ListTile(
                  title: Text("Timer settings"),
                  subtitle: Text("Audio features not available on web"),
                ),
              ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    minutesController.dispose();
    secondsController.dispose();
    player?.stop();
    player?.dispose();
  }
}
