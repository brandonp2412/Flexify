import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/day_selector.dart';
import 'package:flexify/graph/add_exercise_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/exercise_tile.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditPlanPage extends StatefulWidget {
  final PlansCompanion plan;

  const EditPlanPage({required this.plan, super.key});

  @override
  createState() => _EditPlanPageState();
}

class _EditPlanPageState extends State<EditPlanPage> {
  late List<bool> daySwitches;

  bool showOff = true;
  String search = '';
  List<PlanExercisesCompanion> exercises = [];

  final searchNode = FocusNode();
  final searchController = TextEditingController();
  final titleController = TextEditingController();

  Iterable<Widget> get tiles => exercises
      .where(
        (pe) {
          if (showOff)
            return pe.exercise.value
                .toLowerCase()
                .contains(search.toLowerCase());
          if (pe.enabled.value)
            return pe.exercise.value
                .toLowerCase()
                .contains(search.toLowerCase());
          return false;
        },
      )
      .toList()
      .map(
        (planExercise) => ExerciseTile(
          planExercise: planExercise,
          onChange: (value) {
            final id = exercises
                .indexWhere((pe) => pe.exercise == planExercise.exercise);
            if (id == -1) return;
            setState(() {
              exercises[id] = value;
            });
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    var title = widget.plan.days.value.replaceAll(",", ", ");
    if (title.isNotEmpty)
      title = title[0].toUpperCase() + title.substring(1).toLowerCase();
    else
      title = "Add plan";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            TextField(
              decoration: const material.InputDecoration(
                labelText: 'Title (optional)',
              ),
              controller: titleController,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(
              height: 16.0,
            ),
            DaySelector(daySwitches: daySwitches),
            material.Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBar(
                leading: const material.Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.search),
                ),
                hintText: 'Search exercises...',
                trailing: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      await Navigator.of(context).push(
                        material.MaterialPageRoute(
                          builder: (context) => const AddExercisePage(),
                        ),
                      );
                      setExercises();
                    },
                    tooltip: 'Add exercise',
                  ),
                  IconButton(
                    icon: showOff
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        showOff = !showOff;
                      });
                    },
                    tooltip: 'Toggle visibility',
                  ),
                ],
                onChanged: (value) => setState(() {
                  search = value;
                }),
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(tiles.length, (index) => tiles.elementAt(index)),
            const SizedBox(height: 76),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: save,
        label: const Text("Save"),
        icon: const Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    searchNode.dispose();
    searchController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    setExercises();
    titleController.text = widget.plan.title.value ?? "";

    final dayList = widget.plan.days.value.split(',');
    daySwitches = weekdays.map((day) => dayList.contains(day)).toList();
  }

  void setExercises() {
    var query = db.gymSets.selectOnly()
      ..addColumns([db.gymSets.name])
      ..groupBy([db.gymSets.name])
      ..join([
        leftOuterJoin(
          db.planExercises,
          db.planExercises.planId
                  .equals(widget.plan.id.present ? widget.plan.id.value : 0) &
              db.planExercises.exercise.equalsExp(db.gymSets.name),
        ),
      ])
      ..addColumns(db.planExercises.$columns);

    query.get().then(
      (results) {
        List<PlanExercisesCompanion> enabledExercises = [];
        List<PlanExercisesCompanion> disabledExercises = [];

        for (final result in results) {
          final pe = PlanExercisesCompanion(
            planId: widget.plan.id,
            id: Value.absentIfNull(result.read(db.planExercises.id)),
            exercise: Value(result.read(db.gymSets.name)!),
            enabled: Value(result.read(db.planExercises.enabled) ?? false),
            maxSets: Value(result.read(db.planExercises.maxSets)),
            warmupSets: Value(result.read(db.planExercises.warmupSets)),
            timers: Value(result.read(db.planExercises.timers) ?? true),
          );
          if (pe.enabled.value)
            enabledExercises.add(pe);
          else
            disabledExercises.add(pe);
        }

        enabledExercises.sort(
          (a, b) => widget.plan.exercises.value
              .indexOf(a.exercise.value)
              .compareTo(widget.plan.exercises.value.indexOf(b.exercise.value)),
        );

        setState(() {
          exercises = enabledExercises + disabledExercises;
        });
      },
    );
  }

  Future<void> save() async {
    final days = [];
    for (int i = 0; i < daySwitches.length; i++)
      if (daySwitches[i]) days.add(weekdays[i]);

    if (days.isEmpty && titleController.text.isEmpty)
      return toast(context, 'Select days');

    if (exercises.where((exercise) => exercise.enabled.value).isEmpty)
      return toast(context, 'Select exercises');

    var newPlan = PlansCompanion.insert(
      days: days.join(','),
      exercises: exercises
          .where((element) => element.enabled.value)
          .map((element) => element.exercise.value)
          .join(','),
      title: Value(titleController.text),
    );

    if (widget.plan.id.present) {
      await db.update(db.plans).replace(newPlan.copyWith(id: widget.plan.id));
      await db.planExercises
          .deleteWhere((tbl) => tbl.planId.equals(widget.plan.id.value));
      await db.planExercises.insertAll(exercises);
    } else {
      final id = await db.into(db.plans).insert(newPlan);
      await db.planExercises
          .insertAll(exercises.map((pe) => pe.copyWith(planId: Value(id))));
    }

    if (!mounted) return;
    final planState = context.read<PlanState>();
    planState.updatePlans(null);
    Navigator.pop(context);
  }
}
