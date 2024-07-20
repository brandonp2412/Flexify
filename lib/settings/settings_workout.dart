import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

List<Widget> getWorkouts(
  String term,
  Setting settings,
  TextEditingController maxSets,
  TextEditingController warmupSets,
) {
  return [
    if ('warmup sets'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: warmupSets,
          decoration: const InputDecoration(
            labelText: 'Warmup sets',
            hintText: '0',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          onTap: () => selectAll(warmupSets),
          onChanged: (value) => db.settings.update().write(
                SettingsCompanion(
                  warmupSets: Value(int.parse(value)),
                ),
              ),
        ),
      ),
    if ('sets per exercise'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: maxSets,
          decoration: const InputDecoration(
            labelText: 'Sets per exercise',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          onTap: () => selectAll(maxSets),
          onChanged: (value) => db.settings.update().write(
                SettingsCompanion(
                  maxSets: Value(int.parse(value)),
                ),
              ),
        ),
      ),
    if ('plan trailing display'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: DropdownButtonFormField<PlanTrailing>(
          value: PlanTrailing.values
              .byName(settings.planTrailing.replaceFirst('PlanTrailing.', '')),
          decoration: const InputDecoration(
            labelStyle: TextStyle(),
            labelText: 'Plan trailing display',
          ),
          items: const [
            DropdownMenuItem(
              value: PlanTrailing.reorder,
              child: Row(
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
          onChanged: (value) => db.settings.update().write(
                SettingsCompanion(
                  planTrailing: Value(value.toString()),
                ),
              ),
        ),
      ),
    if ('group history'.contains(term.toLowerCase()))
      ListTile(
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
    if ('show units'.contains(term.toLowerCase()))
      ListTile(
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
    if ('show weight'.contains(term.toLowerCase()))
      ListTile(
        title: const Text('Show weight'),
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
    if ('show history tab'.contains(term.toLowerCase()))
      ListTile(
        title: const Text('Show history tab'),
        leading: const Icon(Icons.history),
        onTap: () => db.settings.update().write(
              SettingsCompanion(
                showHistoryTab: Value(!settings.showHistoryTab),
              ),
            ),
        trailing: Switch(
          value: settings.showHistoryTab,
          onChanged: (value) => db.settings
              .update()
              .write(SettingsCompanion(showHistoryTab: Value(value))),
        ),
      ),
    if ('rep estimation'.contains(term.toLowerCase()))
      ListTile(
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
    if ('duration estimation'.contains(term.toLowerCase()))
      ListTile(
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
  ];
}

class SettingsWorkout extends StatefulWidget {
  const SettingsWorkout({super.key});

  @override
  State<SettingsWorkout> createState() => _SettingsWorkoutState();
}

class _SettingsWorkoutState extends State<SettingsWorkout> {
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
        children: getWorkouts('', settings, maxSets, warmupSets),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    maxSets.dispose();
  }
}
