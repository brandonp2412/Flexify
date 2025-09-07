import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flexify/animated_fab.dart';
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
  late List<bool> days;
  late var exercises = context.read<PlanState>().exercises;

  bool showOff = true;
  String search = '';

  final node = FocusNode();
  final searchCtrl = TextEditingController();
  final titleCtrl = TextEditingController();

  Iterable<Widget> get tiles {
    final match = exercises.where(
      (pe) {
        if (showOff)
          return pe.exercise.value.toLowerCase().contains(search.toLowerCase());
        if (pe.enabled.value)
          return pe.exercise.value.toLowerCase().contains(search.toLowerCase());
        return false;
      },
    );

    if (match.isEmpty)
      return [
        ListTile(
          title: const Text("Nothing found"),
          subtitle: Text("Tap to create $search"),
          onTap: () async {
            GymSetsCompanion? gymSet = await Navigator.of(context).push(
              material.MaterialPageRoute(
                builder: (context) => AddExercisePage(
                  name: search,
                ),
              ),
            );
            if (gymSet == null || !mounted) return;

            final state = context.read<PlanState>();
            state.addExercise(gymSet);
            setState(() {
              exercises = state.exercises;
              search = '';
            });
            searchCtrl.text = '';
          },
        ),
      ];

    return match.toList().map(
          (pe) => ExerciseTile(
            planExercise: pe,
            onChange: (value) {
              final id = exercises
                  .indexWhere((exercise) => exercise.exercise == pe.exercise);
              if (id == -1) return;
              setState(() {
                exercises[id] = value;
              });
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    exercises = context.select<PlanState, List<PlanExercisesCompanion>>(
      (value) => value.exercises,
    );

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
              controller: titleCtrl,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(
              height: 16.0,
            ),
            DaySelector(daySwitches: days),
            const SizedBox(height: 8),
            material.Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBar(
                leading: const material.Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.search),
                ),
                textCapitalization: TextCapitalization.sentences,
                hintText: 'Search exercises...',
                trailing: [
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
      floatingActionButton: AnimatedFab(
        onPressed: save,
        label: const Text("Save"),
        icon: const Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    node.dispose();
    searchCtrl.dispose();
    titleCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    titleCtrl.text = widget.plan.title.value ?? "";
    final list = widget.plan.days.value.split(',');
    days = weekdays.map((day) => list.contains(day)).toList();
  }

  Future<void> save() async {
    final selected = [];
    for (int i = 0; i < days.length; i++)
      if (days[i]) selected.add(weekdays[i]);

    if (selected.isEmpty && titleCtrl.text.isEmpty)
      return toast(context, 'Select days');

    if (exercises.where((exercise) => exercise.enabled.value).isEmpty)
      return toast(context, 'Select exercises');

    var newPlan = PlansCompanion.insert(
      days: selected.join(','),
      exercises: exercises
          .where((element) => element.enabled.value)
          .map((element) => element.exercise.value)
          .join(','),
      title: Value(titleCtrl.text),
    );

    if (widget.plan.id.present) {
      await db.update(db.plans).replace(newPlan.copyWith(id: widget.plan.id));
      await db.planExercises
          .deleteWhere((tbl) => tbl.planId.equals(widget.plan.id.value));
      await db.planExercises.insertAll(
        exercises.map((pe) => pe.copyWith(planId: widget.plan.id)),
      );
    } else {
      final id = await db.into(db.plans).insert(newPlan);
      await db.planExercises
          .insertAll(exercises.map((pe) => pe.copyWith(planId: Value(id))));
    }

    if (!mounted) return;
    final state = context.read<PlanState>();
    state.updatePlans(null);
    Navigator.pop(context);
  }
}
