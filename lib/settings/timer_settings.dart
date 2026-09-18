import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:flexify/audio/safe_audio_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/logging.dart';
import 'package:flexify/native_timer_wrapper.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Widget> getTimerSettings(
  String term,
  Setting settings,
  TextEditingController minCtrl,
  TextEditingController secCtrl,
  SafeAudioPlayer player,
  BuildContext context,
) {
  final l10n = context.l10n;
  final normalizedTerm = term.trim().toLowerCase();
  bool matches(Iterable<String> values) =>
      values.join(' ').toLowerCase().contains(normalizedTerm);
  return [
    if (matches([l10n.restTimers, l10n.restTimersDescription]))
      Tooltip(
        message: l10n.restTimersDescription,
        child: ListTile(
          title: Text(l10n.restTimers, textAlign: TextAlign.center),
          leading: settings.restTimers
              ? const Icon(Icons.timer)
              : const Icon(Icons.timer_outlined),
          onTap: () async {
            final newValue = !settings.restTimers;

            if (newValue &&
                !kIsWeb &&
                defaultTargetPlatform == TargetPlatform.android) {
              await androidChannel.invokeMethod('requestTimerPermissions', {
                'batteryOptimizationRequestUnavailable':
                    l10n.batteryOptimizationRequestUnavailable,
              });
            }

            db.settings.update().write(
              SettingsCompanion(restTimers: Value(newValue)),
            );
          },
          trailing: Switch(
            value: settings.restTimers,
            onChanged: (value) async {
              if (value &&
                  !kIsWeb &&
                  defaultTargetPlatform == TargetPlatform.android) {
                await androidChannel.invokeMethod('requestTimerPermissions', {
                  'batteryOptimizationRequestUnavailable':
                      l10n.batteryOptimizationRequestUnavailable,
                });
              }

              db.settings.update().write(
                SettingsCompanion(restTimers: Value(value)),
              );
            },
          ),
        ),
      ),
    if (matches([l10n.vibrate, l10n.vibrateDescription]))
      Tooltip(
        message: l10n.vibrateDescription,
        child: ListTile(
          title: Text(l10n.vibrate, textAlign: TextAlign.center),
          leading: settings.vibrate
              ? const Icon(Icons.vibration)
              : const Icon(Icons.vibration_outlined),
          onTap: () async {
            final newValue = !settings.vibrate;
            await db.settings.update().write(
              SettingsCompanion(vibrate: Value(newValue)),
            );
            if (newValue &&
                !kIsWeb &&
                defaultTargetPlatform == TargetPlatform.android) {
              try {
                await androidChannel.invokeMethod('previewVibration');
              } catch (error, stackTrace) {
                talker.handle(error, stackTrace, 'Failed to preview vibration');
              }
            }
          },
          trailing: Switch(
            value: settings.vibrate,
            onChanged: (value) async {
              await db.settings.update().write(
                SettingsCompanion(vibrate: Value(value)),
              );
              if (value &&
                  !kIsWeb &&
                  defaultTargetPlatform == TargetPlatform.android) {
                try {
                  await androidChannel.invokeMethod('previewVibration');
                } catch (error, stackTrace) {
                  talker.handle(
                    error,
                    stackTrace,
                    'Failed to preview vibration',
                  );
                }
              }
            },
          ),
        ),
      ),
    if (matches([l10n.enableSound, l10n.enableSoundDescription]))
      Tooltip(
        message: l10n.enableSoundDescription,
        child: ListTile(
          title: Text(l10n.enableSound, textAlign: TextAlign.center),
          leading: settings.enableSound
              ? const Icon(Icons.music_note)
              : const Icon(Icons.music_note_outlined),
          onTap: () => db.settings.update().write(
            SettingsCompanion(enableSound: Value(!settings.enableSound)),
          ),
          trailing: Switch(
            value: settings.enableSound,
            onChanged: (value) => db.settings.update().write(
              SettingsCompanion(enableSound: Value(value)),
            ),
          ),
        ),
      ),
    if (matches([l10n.keepScreenOn, l10n.keepScreenOnDescription]))
      Tooltip(
        message: l10n.keepScreenOnDescription,
        child: ListTile(
          title: Text(l10n.keepScreenOn, textAlign: TextAlign.center),
          leading: settings.keepScreenOn
              ? const Icon(Icons.light_mode)
              : const Icon(Icons.light_mode_outlined),
          onTap: () {
            final newValue = !settings.keepScreenOn;
            db.settings.update().write(
              SettingsCompanion(keepScreenOn: Value(newValue)),
            );
            context.read<TimerState>().setKeepScreenOn(newValue);
          },
          trailing: Switch(
            value: settings.keepScreenOn,
            onChanged: (value) {
              db.settings.update().write(
                SettingsCompanion(keepScreenOn: Value(value)),
              );
              context.read<TimerState>().setKeepScreenOn(value);
            },
          ),
        ),
      ),
    if (matches([
      l10n.restMinutes,
      l10n.secondsLabel,
      l10n.restDurationDescription,
      l10n.globalDefault,
    ]))
      Padding(
        padding: const EdgeInsets.all(16),
        child: Tooltip(
          message: l10n.restDurationDescription,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.public),
                  const SizedBox(width: 8),
                  Text(
                    l10n.globalDefault,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: l10n.restMinutes),
                      controller: minCtrl,
                      keyboardType: TextInputType.number,
                      onTap: () => selectAll(minCtrl),
                      onChanged: (value) => db.settings.update().write(
                        SettingsCompanion(
                          timerDuration: Value(
                            Duration(
                              minutes: int.tryParse(value) ?? 0,
                              seconds:
                                  Duration(
                                    milliseconds: settings.timerDuration,
                                  ).inSeconds %
                                  60,
                            ).inMilliseconds,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: l10n.secondsLabel),
                      controller: secCtrl,
                      keyboardType: TextInputType.number,
                      onTap: () => selectAll(secCtrl),
                      onChanged: (value) => db.settings.update().write(
                        SettingsCompanion(
                          timerDuration: Value(
                            Duration(
                              seconds: int.tryParse(value) ?? 0,
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
    if (matches([
      l10n.progressBarPosition,
      l10n.progressBarPositionDescription,
    ]))
      _ProgressPositionSetting(settings: settings),
    if (matches([l10n.alarmSound, l10n.alarmSoundDescription]))
      Tooltip(
        message: l10n.alarmSoundDescription,
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () async {
                final result = await FilePicker.pickFiles(type: FileType.audio);
                if (result == null || result.files.single.path == null) return;
                db.settings.update().write(
                  SettingsCompanion(
                    alarmSound: Value(result.files.single.path!),
                  ),
                );
                await player.playFile(result.files.single.path!);
              },
              icon: const Icon(Icons.music_note),
              label: settings.alarmSound.isEmpty
                  ? Text(l10n.alarmSound)
                  : Text(settings.alarmSound.split('/').last),
            ),
            if (settings.alarmSound.isNotEmpty)
              TextButton.icon(
                onPressed: () {
                  db.settings.update().write(
                    const SettingsCompanion(alarmSound: Value('')),
                  );
                },
                label: Text(l10n.actionDelete),
                icon: const Icon(Icons.delete),
              ),
          ],
        ),
      ),
  ];
}

/// Displays the progress-bar-position picker and triggers the real
/// [TimerProgressIndicator] in the home page for 3 seconds as a preview
/// whenever the user changes the setting.
class _ProgressPositionSetting extends StatefulWidget {
  final Setting settings;

  const _ProgressPositionSetting({required this.settings});

  @override
  State<_ProgressPositionSetting> createState() =>
      _ProgressPositionSettingState();
}

class _ProgressPositionSettingState extends State<_ProgressPositionSetting> {
  Timer? _previewTimer;
  TimerState? _previewTimerState;

  void _triggerPreview() {
    final timerState = context.read<TimerState>();
    if (timerState.timer.isRunning() &&
        timerState.timer.getRemaining() > Duration.zero) {
      return;
    }

    _previewTimer?.cancel();
    _previewTimerState = timerState;
    const previewDuration = Duration(seconds: 3);
    timerState.updateTimer(
      NativeTimerWrapper(
        previewDuration,
        Duration.zero,
        DateTime.now(),
        NativeTimerState.running,
      ),
    );
    _previewTimer = Timer(previewDuration, () {
      if (!mounted) return;
      timerState.updateTimer(NativeTimerWrapper.emptyTimer());
      _previewTimerState = null;
      _previewTimer = null;
    });
  }

  @override
  void dispose() {
    _previewTimer?.cancel();
    if (_previewTimerState != null) {
      _previewTimerState!.updateTimer(NativeTimerWrapper.emptyTimer());
      _previewTimerState = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: context.l10n.progressBarPositionDescription,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                context.l10n.progressBarPosition,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Center(
              child: SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: 'top',
                    label: Text(context.l10n.top),
                    icon: const Icon(Icons.vertical_align_top),
                  ),
                  ButtonSegment(
                    value: 'bottom',
                    label: Text(context.l10n.bottom),
                    icon: const Icon(Icons.vertical_align_bottom),
                  ),
                  ButtonSegment(
                    value: 'none',
                    label: Text(context.l10n.none),
                    icon: const Icon(Icons.block),
                  ),
                ],
                selected: {widget.settings.progressPosition},
                onSelectionChanged: (selection) {
                  db.settings.update().write(
                    SettingsCompanion(progressPosition: Value(selection.first)),
                  );
                  if (selection.first != 'none') _triggerPreview();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimerSettings extends StatefulWidget {
  const TimerSettings({super.key});

  @override
  State<TimerSettings> createState() => _TimerSettingsState();
}

class _TimerSettingsState extends State<TimerSettings> {
  late final SettingsState _settings = context.read<SettingsState>();
  late final _minCtrl = TextEditingController(
    text: (Duration(
      milliseconds: _settings.value.timerDuration,
    )).inMinutes.toString(),
  );
  late final _secCtrl = TextEditingController(
    text:
        ((Duration(milliseconds: _settings.value.timerDuration)).inSeconds % 60)
            .toString(),
  );

  final SafeAudioPlayer _player = SafeAudioPlayer(enabled: !kIsWeb);
  List<GymSetsCompanion> _exercisesWithCustomTimers = [];
  final Map<String, TextEditingController> _minuteControllers = {};
  final Map<String, TextEditingController> _secondControllers = {};

  @override
  void initState() {
    super.initState();
    _loadExercisesWithCustomTimers();
  }

  Future<void> _loadExercisesWithCustomTimers() async {
    final exercises =
        await (db.selectOnly(db.gymSets)
              ..addColumns([db.gymSets.name, db.gymSets.restMs])
              ..where(db.gymSets.restMs.isNotNull())
              ..groupBy([db.gymSets.name]))
            .get();
    if (!mounted) return;

    setState(() {
      _exercisesWithCustomTimers = exercises
          .map(
            (result) => GymSetsCompanion(
              name: Value(result.read(db.gymSets.name)!),
              restMs: Value(result.read(db.gymSets.restMs)),
            ),
          )
          .toList();

      for (final result in exercises) {
        final exerciseName = result.read(db.gymSets.name)!;
        final restMs = result.read(db.gymSets.restMs);
        if (restMs != null) {
          final duration = Duration(milliseconds: restMs);
          _minuteControllers[exerciseName] = TextEditingController(
            text: duration.inMinutes.toString(),
          );
          _secondControllers[exerciseName] = TextEditingController(
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
        .write(GymSetsCompanion(restMs: Value(duration?.inMilliseconds)));

    if (!mounted) return;
    if (duration == null) {
      _minuteControllers.remove(exerciseName)?.dispose();
      _secondControllers.remove(exerciseName)?.dispose();
      setState(() {
        _exercisesWithCustomTimers.removeWhere(
          (e) => e.name.value == exerciseName,
        );
      });
    }
  }

  Future<void> _removeCustomTimer(String exerciseName) async {
    await (db.gymSets.update()..where((tbl) => tbl.name.equals(exerciseName)))
        .write(const GymSetsCompanion(restMs: Value(null)));
    if (!mounted) return;

    _minuteControllers.remove(exerciseName)?.dispose();
    _secondControllers.remove(exerciseName)?.dispose();
    setState(() {
      _exercisesWithCustomTimers.removeWhere(
        (e) => e.name.value == exerciseName,
      );
    });
  }

  Widget _buildPerExerciseSection() {
    if (_exercisesWithCustomTimers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(Icons.fitness_center),
              const SizedBox(width: 8),
              Text(
                context.l10n.perExerciseRestTimes,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.perExerciseRestTimesDescription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          ..._exercisesWithCustomTimers.map((exercise) {
            final exerciseName = exercise.name.value;
            if (_minuteControllers[exerciseName] == null ||
                _secondControllers[exerciseName] == null)
              return const SizedBox();
            final minController = _minuteControllers[exerciseName]!;
            final secController = _secondControllers[exerciseName]!;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                          tooltip: context.l10n.removeCustomTimer,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: context.l10n.minutesLabel,
                              border: const OutlineInputBorder(),
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
                            decoration: InputDecoration(
                              labelText: context.l10n.secondsLabel,
                              border: const OutlineInputBorder(),
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(context.l10n.timers)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 116),
        children: _player.isAvailable
            ? [
                ...getTimerSettings(
                  '',
                  settings.value,
                  _minCtrl,
                  _secCtrl,
                  _player,
                  context,
                ),
                _buildPerExerciseSection(),
              ]
            : [
                ListTile(
                  title: Text(
                    context.l10n.timerSettings,
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Text(
                    context.l10n.audioFeaturesUnavailable,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
      ),
    );
  }

  @override
  void dispose() {
    _minCtrl.dispose();
    _secCtrl.dispose();

    for (final controller in _minuteControllers.values) {
      controller.dispose();
    }
    for (final controller in _secondControllers.values) {
      controller.dispose();
    }

    _player.stop();
    _player.dispose();
    super.dispose();
  }
}
