import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Widget> getWorkoutSettings(
  BuildContext context,
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
    if ('show body weight'.contains(term.toLowerCase()))
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
    if ('show categories'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Enable/disable workout categories',
        child: ListTile(
          title: const Text('Show categories'),
          leading: const Icon(Icons.category),
          onTap: () => db.settings.update().write(
                SettingsCompanion(
                  showCategories: Value(!settings.showCategories),
                ),
              ),
          trailing: Switch(
            value: settings.showCategories,
            onChanged: (value) => db.settings
                .update()
                .write(SettingsCompanion(showCategories: Value(value))),
          ),
        ),
      ),
    if ('show notes'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Record details of your lift in a text area',
        child: ListTile(
          title: const Text('Show notes'),
          leading: const Icon(Icons.note_alt_outlined),
          onTap: () => db.settings.update().write(
                SettingsCompanion(
                  showNotes: Value(!settings.showNotes),
                ),
              ),
          trailing: Switch(
            value: settings.showNotes,
            onChanged: (value) => db.settings
                .update()
                .write(SettingsCompanion(showNotes: Value(value))),
          ),
        ),
      ),
    if ('notifications'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Write nice messages when a new record is hit',
        child: ListTile(
          title: const Text('Notifications'),
          leading: const Icon(Icons.notifications),
          onTap: () {
            db.settings.update().write(
                  SettingsCompanion(
                    notifications: Value(!settings.notifications),
                  ),
                );
            if (!settings.notifications)
              toast('Positive messages appear now like this!');
          },
          trailing: Switch(
            value: settings.notifications,
            onChanged: (value) => db.settings
                .update()
                .write(SettingsCompanion(notifications: Value(value))),
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
    if ('show graph x axis'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Show time-based X axis toggle on graphs',
        child: ListTile(
          title: const Text('Show graph X axis toggle'),
          leading: const Icon(Icons.show_chart),
          onTap: () => db.settings.update().write(
                SettingsCompanion(
                  showGraphXAxis: Value(!settings.showGraphXAxis),
                ),
              ),
          trailing: Switch(
            value: settings.showGraphXAxis,
            onChanged: (value) => db.settings
                .update()
                .write(SettingsCompanion(showGraphXAxis: Value(value))),
          ),
        ),
      ),
    if ('show graph limit'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Show the limit slider on graphs',
        child: ListTile(
          title: const Text('Show graph limit'),
          leading: const Icon(Icons.tune),
          onTap: () => db.settings.update().write(
                SettingsCompanion(
                  showGraphLimit: Value(!settings.showGraphLimit),
                ),
              ),
          trailing: Switch(
            value: settings.showGraphLimit,
            onChanged: (value) => db.settings
                .update()
                .write(SettingsCompanion(showGraphLimit: Value(value))),
          ),
        ),
      ),
    if ('default graph metric'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Default graph metric'),
          initialValue: settings.defaultGraphMetric,
          items: const [
            DropdownMenuItem(value: 'bestWeight', child: Text("Best weight")),
            DropdownMenuItem(value: 'bestReps', child: Text("Best reps")),
            DropdownMenuItem(value: 'oneRepMax', child: Text("One rep max")),
            DropdownMenuItem(value: 'volume', child: Text("Volume")),
            DropdownMenuItem(value: 'pace', child: Text("Pace (cardio)")),
            DropdownMenuItem(
              value: 'distance',
              child: Text("Distance (cardio)"),
            ),
          ],
          onChanged: (value) => db.settings
              .update()
              .write(SettingsCompanion(defaultGraphMetric: Value(value!))),
        ),
      ),
    if ('default graph period'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Default graph period'),
          initialValue: settings.defaultGraphPeriod,
          items: const [
            DropdownMenuItem(value: 'day', child: Text("Daily")),
            DropdownMenuItem(value: 'week', child: Text("Weekly")),
            DropdownMenuItem(value: 'month', child: Text("Monthly")),
            DropdownMenuItem(value: 'year', child: Text("Yearly")),
          ],
          onChanged: (value) => db.settings
              .update()
              .write(SettingsCompanion(defaultGraphPeriod: Value(value!))),
        ),
      ),
    if ('default graph limit'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: DropdownButtonFormField<int>(
          decoration: const InputDecoration(labelText: 'Default graph limit'),
          initialValue: settings.defaultGraphLimit,
          items: const [
            DropdownMenuItem(value: 10, child: Text("10")),
            DropdownMenuItem(value: 20, child: Text("20")),
            DropdownMenuItem(value: 50, child: Text("50")),
            DropdownMenuItem(value: 100, child: Text("100")),
            DropdownMenuItem(value: 200, child: Text("200")),
          ],
          onChanged: (value) => db.settings
              .update()
              .write(SettingsCompanion(defaultGraphLimit: Value(value!))),
        ),
      ),
    if ('default time based x axis'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Use time-based X axis by default on graphs',
        child: ListTile(
          title: const Text('Default time-based X axis'),
          leading: const Icon(Icons.timeline),
          onTap: () => db.settings.update().write(
                SettingsCompanion(
                  defaultGraphTimeBasedXAxis:
                      Value(!settings.defaultGraphTimeBasedXAxis),
                ),
              ),
          trailing: Switch(
            value: settings.defaultGraphTimeBasedXAxis,
            onChanged: (value) => db.settings.update().write(
                  SettingsCompanion(
                    defaultGraphTimeBasedXAxis: Value(value),
                  ),
                ),
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

  late final max = TextEditingController(text: settings.maxSets.toString());
  late final warmup =
      TextEditingController(text: settings.warmupSets?.toString());

  @override
  Widget build(BuildContext context) {
    settings = context.watch<SettingsState>().value;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Workouts"),
      ),
      body: ListView(
        children: getWorkoutSettings(context, '', settings),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    max.dispose();
    warmup.dispose();
  }
}
