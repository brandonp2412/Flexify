import 'package:drift/drift.dart' as drift;
import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/cardio_page.dart';
import 'package:flexify/graph/strength_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseModal extends StatefulWidget {
  final String exercise;
  final bool hasData;
  final Function() onSelect;
  final int planId;

  const ExerciseModal({
    super.key,
    required this.exercise,
    required this.hasData,
    required this.onSelect,
    required this.planId,
  });

  @override
  State<ExerciseModal> createState() => _ExerciseModalState();
}

class _ExerciseModalState extends State<ExerciseModal> {
  final maxSets = TextEditingController();
  final warmupSets = TextEditingController();

  @override
  void initState() {
    super.initState();

    (db.planExercises.select()
          ..where(
            (u) =>
                u.planId.equals(widget.planId) &
                u.exercise.equals(widget.exercise),
          ))
        .getSingle()
        .then((planExercise) {
      maxSets.text = planExercise.maxSets?.toString() ?? '';
      warmupSets.text = planExercise.warmupSets?.toString() ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () async {
            Navigator.pop(context);

            showDialog(
              context: context,
              builder: (context) => AlertDialog.adaptive(
                title: Text(widget.exercise),
                content: SingleChildScrollView(
                  child: material.Column(
                    children: [
                      Selector<SettingsState, int?>(
                        selector: (context, settings) =>
                            settings.value.warmupSets,
                        builder: (context, value, child) => TextField(
                          controller: warmupSets,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: false,
                          ),
                          onTap: () => selectAll(warmupSets),
                          onChanged: (value) {
                            (db.planExercises.update()
                                  ..where(
                                    (u) =>
                                        u.planId.equals(widget.planId) &
                                        u.exercise.equals(widget.exercise),
                                  ))
                                .write(
                              PlanExercisesCompanion(
                                warmupSets:
                                    Value(int.tryParse(warmupSets.text)),
                              ),
                            );
                          },
                          decoration: InputDecoration(
                            labelText: "Warmup sets",
                            border: const OutlineInputBorder(),
                            hintText: (value ?? 0).toString(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Selector<SettingsState, int>(
                        selector: (context, settings) => settings.value.maxSets,
                        builder: (context, value, child) => TextField(
                          controller: maxSets,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: false,
                          ),
                          onTap: () => selectAll(maxSets),
                          onChanged: (value) {
                            if (int.parse(maxSets.text) > 0 &&
                                int.parse(maxSets.text) <= 20) {
                              (db.planExercises.update()
                                    ..where(
                                      (u) =>
                                          u.planId.equals(widget.planId) &
                                          u.exercise.equals(widget.exercise),
                                    ))
                                  .write(
                                PlanExercisesCompanion(
                                  maxSets: Value(int.tryParse(maxSets.text)),
                                ),
                              );
                            }
                          },
                          decoration: InputDecoration(
                            labelText: "Working sets (max: 20)",
                            border: const OutlineInputBorder(),
                            hintText: value.toString(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: const Text("OK"),
                    icon: const Icon(Icons.check),
                  ),
                ],
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.insights),
          title: const Text('Graphs'),
          onTap: () async {
            Navigator.pop(context);

            final gymSet = await (db.gymSets.select()
                  ..where((tbl) => tbl.name.equals(widget.exercise))
                  ..limit(1))
                .getSingle();

            if (!context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => gymSet.cardio
                    ? CardioPage(name: widget.exercise, unit: gymSet.unit)
                    : StrengthPage(
                        name: widget.exercise,
                        unit: gymSet.unit,
                      ),
              ),
            );
          },
        ),
        if (widget.hasData)
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit'),
            onTap: () async {
              Navigator.pop(context);
              final gymSet = await (db.select(db.gymSets)
                    ..where((r) => db.gymSets.name.equals(widget.exercise))
                    ..orderBy([
                      (u) => drift.OrderingTerm(
                            expression: u.created,
                            mode: drift.OrderingMode.desc,
                          ),
                    ])
                    ..limit(1))
                  .getSingle();
              if (!context.mounted) return;
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditSetPage(gymSet: gymSet),
                ),
              );
              widget.onSelect();
            },
          ),
        if (widget.hasData)
          ListTile(
            leading: const Icon(Icons.undo),
            title: const Text('Undo'),
            onTap: () async {
              Navigator.pop(context);
              final gymSet = await (db.select(db.gymSets)
                    ..where((r) => db.gymSets.name.equals(widget.exercise))
                    ..orderBy([
                      (u) => drift.OrderingTerm(
                            expression: u.created,
                            mode: drift.OrderingMode.desc,
                          ),
                    ])
                    ..limit(1))
                  .getSingle();
              await db.gymSets.deleteOne(gymSet);
              widget.onSelect();
            },
          ),
      ],
    );
  }
}
