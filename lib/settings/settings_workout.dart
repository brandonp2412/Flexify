import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

List<Widget> getWorkouts(
  String term,
  SettingsState settings,
  TextEditingController maxSetsController,
) {
  return [
    if ('sets per exercise'.contains(term.toLowerCase()))
      Padding(
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
    if ('plan trailing display'.contains(term.toLowerCase()))
      Padding(
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
          onChanged: (value) => settings.setPlanTrailing(value!),
        ),
      ),
    if ('group history'.contains(term.toLowerCase()))
      ListTile(
        title: const Text('Group history'),
        leading: const Icon(Icons.expand_more),
        onTap: () => settings.setGroupHistory(!settings.groupHistory),
        trailing: Switch(
          value: settings.groupHistory,
          onChanged: (value) => settings.setGroupHistory(value),
        ),
      ),
    if ('show units'.contains(term.toLowerCase()))
      ListTile(
        title: const Text('Show units'),
        leading: const Icon(Icons.scale_sharp),
        onTap: () => settings.setUnits(!settings.showUnits),
        trailing: Switch(
          value: settings.showUnits,
          onChanged: (value) => settings.setUnits(value),
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
  ];
}

class SettingsWorkout extends StatefulWidget {
  const SettingsWorkout({super.key});

  @override
  State<SettingsWorkout> createState() => _SettingsWorkoutState();
}

class _SettingsWorkoutState extends State<SettingsWorkout> {
  late var settings = context.read<SettingsState>();

  late final maxSetsController =
      TextEditingController(text: settings.maxSets.toString());

  @override
  void dispose() {
    super.dispose();

    maxSetsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    settings = context.watch<SettingsState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Workouts"),
      ),
      body: ListView(
        children: getWorkouts('', settings, maxSetsController),
      ),
    );
  }
}
