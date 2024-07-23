import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Widget> getPlanSettings(
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
            labelText: 'Sets per exercise (max: 20)',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          onTap: () => selectAll(maxSets),
          onChanged: (value) {
            if (int.parse(value) > 0 && int.parse(value) <= 20) {
              db.settings.update().write(
                    SettingsCompanion(
                      maxSets: Value(int.parse(value)),
                    ),
                  );
            }
          },
        ),
      ),
    if ('plan trailing display'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: DropdownButtonFormField<PlanTrailing>(
          value: PlanTrailing.values.byName(
            settings.planTrailing.replaceFirst('PlanTrailing.', ''),
          ),
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
  ];
}

class SettingsPlans extends StatefulWidget {
  const SettingsPlans({super.key});

  @override
  State<SettingsPlans> createState() => _SettingsPlansState();
}

class _SettingsPlansState extends State<SettingsPlans> {
  late var settings = context.read<SettingsState>().value;

  late final maxSets = TextEditingController(text: settings.maxSets.toString());

  late final warmupSets =
      TextEditingController(text: settings.warmupSets?.toString());

  @override
  Widget build(BuildContext context) {
    settings = context.watch<SettingsState>().value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Appearance"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: getPlanSettings('', settings, maxSets, warmupSets),
        ),
      ),
    );
  }
}
