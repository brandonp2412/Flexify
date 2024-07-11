import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Widget> getTimers(
  String term,
  SettingsState settings,
  TextEditingController minutesController,
  TextEditingController secondsController,
  AudioPlayer player,
) {
  return [
    if ('rest minutes seconds'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.all(8.0),
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
      ),
    if ('rest timers'.contains(term.toLowerCase()))
      ListTile(
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
    if ('vibrate'.contains(term.toLowerCase()))
      ListTile(
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
    if ('hide timer tab'.contains(term.toLowerCase()))
      ListTile(
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
    if ('hide weight'.contains(term.toLowerCase()))
      ListTile(
        title: const Text('Hide weight'),
        leading: const Icon(Icons.scale_outlined),
        onTap: () => settings.setHideWeight(!settings.hideWeight),
        trailing: Switch(
          value: settings.hideWeight,
          onChanged: (value) => settings.setHideWeight(value),
        ),
      ),
    if ('hide history tab'.contains(term.toLowerCase()))
      ListTile(
        title: const Text('Hide history tab'),
        leading: const Icon(Icons.history),
        onTap: () => settings.setHideHistory(!settings.hideHistoryTab),
        trailing: Switch(
          value: settings.hideHistoryTab,
          onChanged: (value) => settings.setHideHistory(value),
        ),
      ),
    if ('alarm sound'.contains(term.toLowerCase()))
      TextButton.icon(
        onPressed: () async {
          final result =
              await FilePicker.platform.pickFiles(type: FileType.audio);
          if (result == null || result.files.single.path == null) return;
          settings.setAlarm(result.files.single.path!);
          player.play(DeviceFileSource(result.files.single.path!));
        },
        onLongPress: () {
          settings.setAlarm('');
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
  late final minutesController =
      TextEditingController(text: settings.timerDuration.inMinutes.toString());
  late final secondsController = TextEditingController(
    text: (settings.timerDuration.inSeconds % 60).toString(),
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
          settings,
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
