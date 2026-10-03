import 'package:drift/drift.dart' hide Column;
import 'package:flexify/database/database.dart';
import 'package:flexify/database/performed_sets.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/swap_workout.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flexify/utils.dart';
import 'package:flexify/platform_page_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseModal extends StatefulWidget {
  final int planExerciseId;
  final int exerciseId;
  final String exerciseName;
  final int? workoutId;
  final bool hasData;
  final Function() onSelect;

  const ExerciseModal({
    super.key,
    required this.planExerciseId,
    required this.exerciseId,
    required this.exerciseName,
    required this.workoutId,
    required this.hasData,
    required this.onSelect,
  });

  @override
  State<ExerciseModal> createState() => _ExerciseModalState();
}

class _ExerciseModalState extends State<ExerciseModal> {
  final _max = TextEditingController();
  final _warmup = TextEditingController();
  bool _timers = true;

  @override
  void dispose() {
    _max.dispose();
    _warmup.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    (db.planExercises.select()
          ..where((u) => u.id.equals(widget.planExerciseId))
          ..limit(1))
        .getSingle()
        .then((planExercise) {
          if (!mounted) return;
          _max.text = planExercise.maxSets?.toString() ?? '';
          _warmup.text = planExercise.warmupSets?.toString() ?? '';

          setState(() {
            _timers = planExercise.timers;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(context.l10n.navSettings),
          onTap: () async {
            final rootContext = Navigator.of(
              context,
              rootNavigator: true,
            ).context;
            final maxController = TextEditingController(text: _max.text);
            final warmupController = TextEditingController(text: _warmup.text);
            var timers = _timers;
            Navigator.pop(context);

            await showDialog(
              context: rootContext,
              builder: (dialogContext) {
                return AlertDialog.adaptive(
                  title: Text(widget.exerciseName),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        Selector<SettingsState, int?>(
                          selector: (context, settings) =>
                              settings.value.warmupSets,
                          builder: (context, value, child) => TextField(
                            controller: warmupController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false,
                            ),
                            onTap: () => selectAll(warmupController),
                            onChanged: changeWarmup,
                            decoration: InputDecoration(
                              labelText: dialogContext.l10n.warmupSets,
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
                            controller: maxController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false,
                            ),
                            onTap: () => selectAll(maxController),
                            onChanged: changeMax,
                            decoration: InputDecoration(
                              labelText: dialogContext.l10n.workingSetsMax,
                              border: const OutlineInputBorder(),
                              hintText: value.toString(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        StatefulBuilder(
                          builder: (context, setDialogState) => ListTile(
                            title: Text(dialogContext.l10n.restTimers),
                            trailing: Switch(
                              value: timers,
                              onChanged: (value) {
                                setDialogState(() {
                                  timers = value;
                                });
                                changeTimers(value);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton.icon(
                      onPressed: () => Navigator.pop(dialogContext),
                      label: Text(dialogContext.l10n.actionOk),
                      icon: const Icon(Icons.check),
                    ),
                  ],
                );
              },
            );
            maxController.dispose();
            warmupController.dispose();
          },
        ),
        if (widget.hasData)
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text(context.l10n.actionEdit),
            onTap: () async {
              Navigator.pop(context);
              final workoutId = widget.workoutId;
              if (workoutId == null) return;
              final performedSet = await getLatestWorkoutPerformedSet(
                db,
                workoutId: workoutId,
                exerciseId: widget.exerciseId,
              );
              if (performedSet == null) return;
              if (!context.mounted) return;
              await Navigator.of(context).push(
                FlexPageRoute(
                  builder: (context) => EditSetPage(performedSet: performedSet),
                ),
              );
              widget.onSelect();
            },
          ),
        if (widget.hasData)
          ListTile(
            leading: const Icon(Icons.undo),
            title: Text(context.l10n.actionUndo),
            onTap: () async {
              Navigator.pop(context);
              final workoutId = widget.workoutId;
              if (workoutId == null) return;
              final performedSet = await getLatestWorkoutPerformedSet(
                db,
                workoutId: workoutId,
                exerciseId: widget.exerciseId,
              );
              if (performedSet == null) return;
              await deletePerformedSets(db, [performedSet.id]);
              if (!context.mounted) return;
              widget.onSelect();
              final timerState = context.read<TimerState>();
              timerState.stopTimer();
            },
          ),
        if (!widget.hasData)
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: Text(context.l10n.actionSwap),
            onTap: () async {
              Navigator.pop(context);
              final result = await Navigator.of(context).push(
                FlexPageRoute(
                  builder: (context) =>
                      SwapWorkout(planExerciseId: widget.planExerciseId),
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
    (db.planExercises.update()
          ..where((u) => u.id.equals(widget.planExerciseId)))
        .write(PlanExercisesCompanion(timers: Value(value)));
  }

  void changeMax(String value) {
    (db.planExercises.update()
          ..where((u) => u.id.equals(widget.planExerciseId)))
        .write(PlanExercisesCompanion(maxSets: Value(int.tryParse(value))));
  }

  void changeWarmup(String value) {
    (db.planExercises.update()
          ..where((u) => u.id.equals(widget.planExerciseId)))
        .write(PlanExercisesCompanion(warmupSets: Value(int.tryParse(value))));
  }
}
