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
  TextEditingController max,
  TextEditingController warmup,
) {
  return [
    if ('warmup sets'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Tooltip(
          message: 'Warmup sets have no rest timers',
          child: TextField(
            controller: warmup,
            decoration: const InputDecoration(
              labelText: 'Warmup sets',
              hintText: '0',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            onTap: () => selectAll(warmup),
            onChanged: (value) => db.settings.update().write(
                  SettingsCompanion(
                    warmupSets: Value(int.parse(value)),
                  ),
                ),
          ),
        ),
      ),
    if ('sets per exercise'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Tooltip(
          message: 'Default # of exercises in a plan',
          child: TextField(
            controller: max,
            decoration: const InputDecoration(
              labelText: 'Sets per exercise (max: 20)',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            onTap: () => selectAll(max),
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
      ),
    if ('plan trailing display'.contains(term.toLowerCase()))
      Tooltip(
        message: 'Right side of list displays in Plans + Plan view',
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
          child: SegmentedButton<PlanTrailing>(
            segments: const [
              ButtonSegment(
                value: PlanTrailing.reorder,
                label: Text('Order'),
                icon: Icon(Icons.menu),
              ),
              ButtonSegment(
                value: PlanTrailing.count,
                label: Text('Count'),
                icon: Icon(Icons.tag),
              ),
              ButtonSegment(
                value: PlanTrailing.percent,
                label: Text('%'),
                icon: Icon(Icons.percent),
              ),
              ButtonSegment(
                value: PlanTrailing.ratio,
                label: Text('Ratio'),
                icon: Icon(Icons.format_list_numbered),
              ),
              ButtonSegment(
                value: PlanTrailing.none,
                label: Text('None'),
                icon: Icon(Icons.block),
              ),
            ],
            selected: {
              PlanTrailing.values.byName(
                settings.planTrailing.replaceFirst('PlanTrailing.', ''),
              ),
            },
            onSelectionChanged: (selection) => db.settings.update().write(
                  SettingsCompanion(
                    planTrailing: Value(selection.first.toString()),
                  ),
                ),
          ),
        ),
      ),
  ];
}

class PlanSettings extends StatefulWidget {
  const PlanSettings({super.key});

  @override
  State<PlanSettings> createState() => _PlanSettingsState();
}

class _PlanSettingsState extends State<PlanSettings> {
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
        title: const Text("Plans"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 116),
          children: getPlanSettings('', settings, max, warmup),
        ),
      ),
    );
  }
}
