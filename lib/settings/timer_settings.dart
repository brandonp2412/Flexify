import 'package:audioplayers/audioplayers.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Widget> getTimerSettings(
  String term,
  Setting settings,
  TextEditingController minCtrl,
  TextEditingController secCtrl,
  AudioPlayer player,
  BuildContext context,
) {
  return [
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
    if ('rest minutes seconds'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.all(16),
        child: Tooltip(
          message: 'How long before rest alarms go off?',
          child: material.Column(
            children: [
              material.Row(
                children: [
                  const Icon(Icons.public),
                  const SizedBox(width: 8),
                  Text(
                    "Global default",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Rest minutes',
                      ),
                      controller: minCtrl,
                      keyboardType: TextInputType.number,
                      onTap: () => selectAll(minCtrl),
                      onChanged: (value) => db.settings.update().write(
                            SettingsCompanion(
                              timerDuration: Value(
                                Duration(
                                  minutes: int.parse(value),
                                  seconds: Duration(
                                        milliseconds: settings.timerDuration,
                                      ).inSeconds %
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
                      controller: secCtrl,
                      keyboardType: TextInputType.number,
                      onTap: () => selectAll(secCtrl),
                      onChanged: (value) => db.settings.update().write(
                            SettingsCompanion(
                              timerDuration: Value(
                                Duration(
                                  seconds: int.parse(value),
                                  minutes: Duration(
                                    milliseconds: settings.timerDuration,
                                  ).inMinutes.floor(),
                                ).inMilliseconds,
                              ),
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
  ];
}

class TimerSettings extends StatefulWidget {
  const TimerSettings({super.key});

  @override
  State<TimerSettings> createState() => _TimerSettingsState();
}

class _TimerSettingsState extends State<TimerSettings> {
  late SettingsState settings = context.read<SettingsState>();
  late final minCtrl = TextEditingController(
    text: (Duration(milliseconds: settings.value.timerDuration))
        .inMinutes
        .toString(),
  );
  late final secCtrl = TextEditingController(
    text:
        ((Duration(milliseconds: settings.value.timerDuration)).inSeconds % 60)
            .toString(),
  );

  AudioPlayer? player;
  List<GymSetsCompanion> exercisesWithCustomTimers = [];
  Map<String, TextEditingController> minuteControllers = {};
  Map<String, TextEditingController> secondControllers = {};

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

    _loadExercisesWithCustomTimers();
  }

  Future<void> _loadExercisesWithCustomTimers() async {
    final exercises = await (db.selectOnly(db.gymSets)
          ..addColumns([db.gymSets.name, db.gymSets.restMs])
          ..where(db.gymSets.restMs.isNotNull())
          ..groupBy([db.gymSets.name]))
        .get();

    setState(() {
      exercisesWithCustomTimers = exercises
          .map(
            (result) => GymSetsCompanion(
              name: Value(result.read(db.gymSets.name)!),
              restMs: Value(result.read(db.gymSets.restMs)),
            ),
          )
          .toList();

      // Initialize controllers for each exercise
      for (final result in exercises) {
        final exerciseName = result.read(db.gymSets.name)!;
        final restMs = result.read(db.gymSets.restMs);
        if (restMs != null) {
          final duration = Duration(milliseconds: restMs);
          minuteControllers[exerciseName] = TextEditingController(
            text: duration.inMinutes.toString(),
          );
          secondControllers[exerciseName] = TextEditingController(
            text: (duration.inSeconds % 60).toString(),
          );
        }
      }
    });
  }

  Future<void> _updateExerciseRestTime(
    String exerciseName,
    int? minutes,
    int? seconds,
  ) async {
    Duration? duration;
    final mins = minutes ?? 0;
    final secs = seconds ?? 0;

    if (mins > 0 || secs > 0) {
      duration = Duration(minutes: mins, seconds: secs);
    }

    await (db.gymSets.update()..where((tbl) => tbl.name.equals(exerciseName)))
        .write(
      GymSetsCompanion(
        restMs: Value(duration?.inMilliseconds),
      ),
    );

    // If duration is null (both minutes and seconds are 0), remove from list
    if (duration == null) {
      setState(() {
        exercisesWithCustomTimers
            .removeWhere((e) => e.name.value == exerciseName);
        minuteControllers.remove(exerciseName);
        secondControllers.remove(exerciseName);
      });
    }
  }

  Future<void> _removeCustomTimer(String exerciseName) async {
    await (db.gymSets.update()..where((tbl) => tbl.name.equals(exerciseName)))
        .write(
      const GymSetsCompanion(
        restMs: Value(null),
      ),
    );

    setState(() {
      exercisesWithCustomTimers.removeWhere((e) => e.name == exerciseName);
      minuteControllers.remove(exerciseName);
      secondControllers.remove(exerciseName);
    });
  }

  Widget _buildPerExerciseSection() {
    if (exercisesWithCustomTimers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: material.Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          material.Row(
            children: [
              const Icon(Icons.fitness_center),
              const SizedBox(width: 8),
              Text(
                "Per-exercise rest times",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "These exercises have custom rest durations",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.7),
                ),
          ),
          const SizedBox(height: 16),
          ...exercisesWithCustomTimers.map((exercise) {
            final exerciseName = exercise.name.value;
            if (minuteControllers[exerciseName] == null ||
                secondControllers[exerciseName] == null)
              return const SizedBox();
            final minController = minuteControllers[exerciseName]!;
            final secController = secondControllers[exerciseName]!;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: material.Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    material.Row(
                      children: [
                        Expanded(
                          child: Text(
                            exerciseName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _removeCustomTimer(exerciseName),
                          tooltip: 'Remove custom timer (use global default)',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Minutes',
                              border: OutlineInputBorder(),
                            ),
                            controller: minController,
                            keyboardType: TextInputType.number,
                            onTap: () => selectAll(minController),
                            onChanged: (value) {
                              final minutes = int.tryParse(value) ?? 0;
                              final seconds =
                                  int.tryParse(secController.text) ?? 0;
                              _updateExerciseRestTime(
                                exerciseName,
                                minutes,
                                seconds,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Seconds',
                              border: OutlineInputBorder(),
                            ),
                            controller: secController,
                            keyboardType: TextInputType.number,
                            onTap: () => selectAll(secController),
                            onChanged: (value) {
                              final minutes =
                                  int.tryParse(minController.text) ?? 0;
                              final seconds = int.tryParse(value) ?? 0;
                              _updateExerciseRestTime(
                                exercise.name.value,
                                minutes,
                                seconds,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
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
            ? [
                ...getTimerSettings(
                  '',
                  settings.value,
                  minCtrl,
                  secCtrl,
                  player!,
                  context,
                ),
                _buildPerExerciseSection(),
              ]
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

    minCtrl.dispose();
    secCtrl.dispose();

    // Dispose of all exercise controllers
    for (final controller in minuteControllers.values) {
      controller.dispose();
    }
    for (final controller in secondControllers.values) {
      controller.dispose();
    }

    player?.stop();
    player?.dispose();
  }
}
