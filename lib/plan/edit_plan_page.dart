import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/add_exercise_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/exercise_tile.dart';
import 'package:flexify/plan/plan_state.dart';
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
  late List<String> exerciseSelections;

  bool showOff = true;
  String search = '';
  List<String> exercises = [];
  List<TextEditingController> controllers = [];

  final searchNode = FocusNode();
  final searchController = TextEditingController();
  final titleController = TextEditingController();

  Iterable<Widget> get tiles => exercises
      .where(
        (exercise) {
          if (showOff)
            return exercise.toLowerCase().contains(search.toLowerCase());
          if (exerciseSelections.contains(exercise))
            return exercise.toLowerCase().contains(search.toLowerCase());
          return false;
        },
      )
      .toList()
      .asMap()
      .entries
      .map(
        (entry) => ExerciseTile(
          controllers: controllers,
          entry: entry,
          add: (value) {
            setState(() {
              exerciseSelections.add(value);
            });
          },
          remove: (value) {
            setState(() {
              exerciseSelections.remove(value);
            });
          },
          on: exerciseSelections.contains(entry.value),
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
            Text('Days', style: Theme.of(context).textTheme.headlineSmall),
            ...List.generate(
              7,
              (index) => SwitchListTile(
                title: Text(weekdays[index]),
                value: daySwitches[index],
                onChanged: (value) {
                  setState(() {
                    daySwitches[index] = value;
                  });
                },
              ),
            ),
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
            const SizedBox(height: 16),
            ...List.generate(tiles.length, (index) => tiles.elementAt(index)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _save,
        tooltip: "Save",
        child: const Icon(Icons.save),
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

    if (widget.plan.id.present) showOff = false;
    setExercises();
    titleController.text = widget.plan.title.value ?? "";

    final dayList = widget.plan.days.value.split(',');
    daySwitches = weekdays.map((day) => dayList.contains(day)).toList();

    if (widget.plan.exercises.value.isEmpty)
      exerciseSelections = [];
    else {
      final splitExercises = widget.plan.exercises.value.split(',');
      exerciseSelections = splitExercises;
    }
  }

  void setExercises() {
    var query = db.gymSets.selectOnly()
      ..addColumns([db.gymSets.name])
      ..groupBy([db.gymSets.name]);

    if (widget.plan.id.present)
      query = query
        ..join([
          leftOuterJoin(
            db.planExercises,
            db.planExercises.planId.equals(widget.plan.id.value) &
                db.planExercises.exercise.equalsExp(db.gymSets.name),
          ),
        ])
        ..addColumns([db.planExercises.maxSets]);

    query.get().then(
          (results) => setState(() {
            exercises = [];
            controllers = [];

            for (final result in results) {
              exercises.add(result.read(db.gymSets.name)!);
              String text = '';
              if (widget.plan.id.present)
                text = result.read(db.planExercises.maxSets)?.toString() ?? "";
              controllers.add(
                TextEditingController(
                  text: text,
                ),
              );
            }
          }),
        );
  }

  Future<void> _save() async {
    final days = [];
    for (int i = 0; i < daySwitches.length; i++) {
      if (daySwitches[i]) days.add(weekdays[i]);
    }
    if (days.isEmpty && titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select days/title first')),
      );
      return;
    }

    if (exerciseSelections.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select exercises first')),
      );
      return;
    }

    var newPlan = PlansCompanion.insert(
      days: days.join(','),
      exercises:
          exerciseSelections.where((element) => element.isNotEmpty).join(','),
      title: Value(titleController.text),
    );

    int? id;
    if (widget.plan.id.present) {
      await db.update(db.plans).replace(newPlan.copyWith(id: widget.plan.id));
      await db.planExercises
          .deleteWhere((tbl) => tbl.planId.equals(widget.plan.id.value));
      id = widget.plan.id.value;
    } else {
      id = await db.into(db.plans).insert(newPlan);
    }

    List<PlanExercisesCompanion> planExercises = [];
    for (var i = 0; i < exercises.length; i++) {
      planExercises.add(
        PlanExercisesCompanion.insert(
          planId: id,
          exercise: exercises[i],
          enabled: exerciseSelections.contains(exercises[i]),
          maxSets: Value(int.tryParse(controllers[i].text)),
        ),
      );
    }

    await db.planExercises.insertAll(planExercises);

    if (!mounted) return;
    final planState = context.read<PlanState>();
    planState.updatePlans(null);
    Navigator.pop(context);
  }
}
