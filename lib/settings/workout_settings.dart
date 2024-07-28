import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Widget> getWorkoutSettings(
  String term,
  Setting settings,
) {
  return [
    if ('group history'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Combine history entries by day',
        child: ListTile(
          title: const Text('Group history'),
          leading: const Icon(Icons.expand_more),
          onTap: () => db.settings.update().write(
                SettingsCompanion(
                  groupHistory: Value(!settings.groupHistory),
                ),
              ),
          trailing: Switch(
            value: settings.groupHistory,
            onChanged: (value) => db.settings.update().write(
                  SettingsCompanion(
                    groupHistory: Value(value),
                  ),
                ),
          ),
        ),
      ),
    if ('show units'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Show km/mi,kg/lb for graphs/history/plans',
        child: ListTile(
          title: const Text('Show units'),
          leading: const Icon(Icons.scale_sharp),
          onTap: () => db.settings
              .update()
              .write(SettingsCompanion(showUnits: Value(!settings.showUnits))),
          trailing: Switch(
            value: settings.showUnits,
            onChanged: (value) => db.settings
                .update()
                .write(SettingsCompanion(showUnits: Value(value))),
          ),
        ),
      ),
    if ('show weight'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Enable/disable tracking body weight',
        child: ListTile(
          title: const Text('Show body weight'),
          leading: const Icon(Icons.scale_outlined),
          onTap: () => db.settings.update().write(
                SettingsCompanion(
                  showBodyWeight: Value(!settings.showBodyWeight),
                ),
              ),
          trailing: Switch(
            value: settings.showBodyWeight,
            onChanged: (value) => db.settings
                .update()
                .write(SettingsCompanion(showBodyWeight: Value(value))),
          ),
        ),
      ),
    if ('rep estimation'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Try to predict the # of reps you just did',
        child: ListTile(
          title: const Text('Rep estimation'),
          leading: const Icon(Icons.repeat_outlined),
          onTap: () => db.settings.update().write(
                SettingsCompanion(
                  repEstimation: Value(!settings.repEstimation),
                ),
              ),
          trailing: Switch(
            value: settings.repEstimation,
            onChanged: (value) => db.settings
                .update()
                .write(SettingsCompanion(repEstimation: Value(value))),
          ),
        ),
      ),
    if ('duration estimation'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Try predict the duration of your cardio',
        child: ListTile(
          title: const Text('Duration estimation'),
          leading: const Icon(Icons.access_time),
          onTap: () => db.settings.update().write(
                SettingsCompanion(
                  durationEstimation: Value(!settings.durationEstimation),
                ),
              ),
          trailing: Switch(
            value: settings.durationEstimation,
            onChanged: (value) => db.settings
                .update()
                .write(SettingsCompanion(durationEstimation: Value(value))),
          ),
        ),
      ),
  ];
}

class WorkoutSettings extends StatefulWidget {
  const WorkoutSettings({super.key});

  @override
  State<WorkoutSettings> createState() => _WorkoutSettingsState();
}

class _WorkoutSettingsState extends State<WorkoutSettings> {
  late var settings = context.read<SettingsState>().value;

  late final maxSets = TextEditingController(text: settings.maxSets.toString());
  late final warmupSets =
      TextEditingController(text: settings.warmupSets?.toString());

  @override
  Widget build(BuildContext context) {
    settings = context.watch<SettingsState>().value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Workouts"),
      ),
      body: ListView(
        children: getWorkoutSettings('', settings),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    maxSets.dispose();
  }
}
