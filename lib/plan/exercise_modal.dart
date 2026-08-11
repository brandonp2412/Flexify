import 'package:drift/drift.dart' hide Column;
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/plan/swap_workout.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseModal extends StatefulWidget {
  final String exercise;
  final bool hasData;
  final Function() onSelect;
  final Function() onMax;
  final int planId;

  const ExerciseModal({
    super.key,
    required this.exercise,
    required this.hasData,
    required this.onSelect,
    required this.planId,
    required this.onMax,
  });

  @override
  State<ExerciseModal> createState() => _ExerciseModalState();
}

class _ExerciseModalState extends State<ExerciseModal> {
  final max = TextEditingController();
  final warmup = TextEditingController();
  final incrementWeight = TextEditingController();
  final incrementReps = TextEditingController();
  final incrementDuration = TextEditingController();
  bool timers = true;

  @override
  void dispose() {
    max.dispose();
    warmup.dispose();
    incrementWeight.dispose();
    incrementReps.dispose();
    incrementDuration.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    (db.planExercises.select()
          ..where(
            (u) =>
                u.planId.equals(widget.planId) &
                u.exercise.equals(widget.exercise),
          )
          ..limit(1))
        .getSingle()
        .then((planExercise) {
          if (!mounted) return;
          max.text = planExercise.maxSets?.toString() ?? '';
          warmup.text = planExercise.warmupSets?.toString() ?? '';
          incrementWeight.text =
              planExercise.incrementWeight?.toString() ?? '';
          incrementReps.text = planExercise.incrementReps?.toString() ?? '';
          incrementDuration.text =
              planExercise.incrementDuration?.toString() ?? '';

          setState(() {
            timers = planExercise.timers;
          });
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
              builder: (context) {
                return AlertDialog.adaptive(
                  title: Text(widget.exercise),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        Selector<SettingsState, int?>(
                          selector: (context, settings) =>
                              settings.value.warmupSets,
                          builder: (context, value, child) => TextField(
                            controller: warmup,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false,
                            ),
                            onTap: () => selectAll(warmup),
                            onChanged: changeWarmup,
                            decoration: InputDecoration(
                              labelText: "Warmup sets",
                              border: const OutlineInputBorder(),
                              hintText: (value ?? 0).toString(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Selector<SettingsState, int>(
                          selector: (context, settings) =>
                              settings.value.maxSets,
                          builder: (context, value, child) => TextField(
                            controller: max,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false,
                            ),
                            onTap: () => selectAll(max),
                            onChanged: changeMax,
                            decoration: InputDecoration(
                              labelText: "Working sets (max: 20)",
                              border: const OutlineInputBorder(),
                              hintText: value.toString(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        StatefulBuilder(
                          builder: (context, setState) => ListTile(
                            title: const Text('Rest timers'),
                            trailing: Switch(
                              value: timers,
                              onChanged: (value) {
                                setState(() {
                                  timers = value;
                                });
                                changeTimers(value);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const Text(
                          "Progressive Session Goals",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: incrementWeight,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onTap: () => selectAll(incrementWeight),
                          onChanged: changeIncrementWeight,
                          decoration: const InputDecoration(
                            labelText: "Weight Increment (+)",
                            border: OutlineInputBorder(),
                            hintText: "0.0",
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: incrementReps,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onTap: () => selectAll(incrementReps),
                          onChanged: changeIncrementReps,
                          decoration: const InputDecoration(
                            labelText: "Reps Increment (+)",
                            border: OutlineInputBorder(),
                            hintText: "0.0",
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: incrementDuration,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onTap: () => selectAll(incrementDuration),
                          onChanged: changeIncrementDuration,
                          decoration: const InputDecoration(
                            labelText: "Time Increment (sec +)",
                            border: OutlineInputBorder(),
                            hintText: "0.0",
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
                );
              },
            );
          },
        ),
        if (widget.hasData)
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit'),
            onTap: () async {
              Navigator.pop(context);
              final gymSet =
                  await (db.select(db.gymSets)
                        ..where((r) => db.gymSets.name.equals(widget.exercise))
                        ..orderBy([
                          (u) => OrderingTerm(
                            expression: u.created,
                            mode: OrderingMode.desc,
                          ),
                        ])
                        ..limit(1))
                      .getSingleOrNull();
              if (gymSet == null) return;
              if (!context.mounted) return;
              await Navigator.of(context).push(
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
              final gymSet =
                  await (db.select(db.gymSets)
                        ..where((r) => db.gymSets.name.equals(widget.exercise))
                        ..orderBy([
                          (u) => OrderingTerm(
                            expression: u.created,
                            mode: OrderingMode.desc,
                          ),
                        ])
                        ..limit(1))
                      .getSingleOrNull();
              if (gymSet == null) return;
              await db.gymSets.deleteOne(gymSet);
              if (!context.mounted) return;
              final planState = context.read<PlanState>();
              planState.updateGymCounts(widget.planId);
              widget.onSelect();
              final timerState = context.read<TimerState>();
              timerState.stopTimer();
            },
          ),
        if (!widget.hasData)
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Swap'),
            onTap: () async {
              Navigator.pop(context);
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SwapWorkout(
                    exercise: widget.exercise,
                    planId: widget.planId,
                  ),
                ),
              );
              if (result == true) {
                widget.onSelect();
              }
            },
          ),
      ],
    );
  }

  void changeTimers(bool value) {
    (db.planExercises.update()..where(
          (u) =>
              u.planId.equals(widget.planId) &
              u.exercise.equals(widget.exercise),
        ))
        .write(PlanExercisesCompanion(timers: Value(value)));
  }

  void changeMax(String value) {
    (db.planExercises.update()..where(
          (u) =>
              u.planId.equals(widget.planId) &
              u.exercise.equals(widget.exercise),
        ))
        .write(PlanExercisesCompanion(maxSets: Value(int.tryParse(max.text))));
    widget.onMax();
  }

  void changeWarmup(String value) {
    (db.planExercises.update()..where(
          (u) =>
              u.planId.equals(widget.planId) &
              u.exercise.equals(widget.exercise),
        ))
        .write(
          PlanExercisesCompanion(warmupSets: Value(int.tryParse(warmup.text))),
        );
  }

  void changeIncrementWeight(String value) {
    (db.planExercises.update()..where(
          (u) =>
              u.planId.equals(widget.planId) &
              u.exercise.equals(widget.exercise),
        ))
        .write(
          PlanExercisesCompanion(
            incrementWeight: Value(double.tryParse(incrementWeight.text)),
          ),
        );
  }

  void changeIncrementReps(String value) {
    (db.planExercises.update()..where(
          (u) =>
              u.planId.equals(widget.planId) &
              u.exercise.equals(widget.exercise),
        ))
        .write(
          PlanExercisesCompanion(
            incrementReps: Value(double.tryParse(incrementReps.text)),
          ),
        );
  }

  void changeIncrementDuration(String value) {
    (db.planExercises.update()..where(
          (u) =>
              u.planId.equals(widget.planId) &
              u.exercise.equals(widget.exercise),
        ))
        .write(
          PlanExercisesCompanion(
            incrementDuration: Value(double.tryParse(incrementDuration.text)),
          ),
        );
  }
}
