import 'package:drift/drift.dart' as drift;
import 'package:flexify/app_state.dart';
import 'package:flexify/database.dart';
import 'package:flexify/exercise_list.dart';
import 'package:flexify/main.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartPlanPage extends StatefulWidget {
  final Plan plan;
  final Stream<List<drift.TypedResult>> countStream;
  final Future<void> Function() onReorder;

  const StartPlanPage(
      {super.key,
      required this.plan,
      required this.countStream,
      required this.onReorder});

  @override
  createState() => _StartPlanPageState();
}

class _StartPlanPageState extends State<StartPlanPage> {
  late TextEditingController repsController;
  late TextEditingController weightController;
  late List<String> planExercises;

  String unit = 'kg';
  int selectedIndex = 0;

  final repsNode = FocusNode();
  final weightNode = FocusNode();

  @override
  void initState() {
    super.initState();
    repsController = TextEditingController(text: "0.0");
    weightController = TextEditingController(text: "0.0");
    planExercises = widget.plan.exercises.split(',');
    getLast();
  }

  @override
  void dispose() {
    repsController.dispose();
    weightController.dispose();
    repsNode.dispose();
    weightNode.dispose();
    super.dispose();
  }

  void selectWeight() {
    weightController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: weightController.text.length,
    );
  }

  Future<void> getLast() async {
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    final startOfTomorrow = startOfToday.add(const Duration(days: 1));
    var last = await (db.gymSets.select()
          ..where((tbl) => db.gymSets.name.isIn(planExercises))
          ..where(
              (tbl) => db.gymSets.created.isBiggerOrEqualValue(startOfToday))
          ..where(
              (tbl) => db.gymSets.created.isSmallerThanValue(startOfTomorrow))
          ..where((tbl) => db.gymSets.hidden.equals(false))
          ..orderBy([
            (u) => drift.OrderingTerm(
                expression: u.created, mode: drift.OrderingMode.desc),
          ])
          ..limit(1))
        .getSingleOrNull();
    last ??= await (db.gymSets.select()
          ..where((tbl) => db.gymSets.name.equals(planExercises[0]))
          ..where((tbl) => db.gymSets.hidden.equals(false))
          ..orderBy([
            (u) => drift.OrderingTerm(
                expression: u.created, mode: drift.OrderingMode.desc),
          ])
          ..limit(1))
        .getSingleOrNull();

    if (last == null) return setState(() {});

    repsController.text = last.reps.toString();
    weightController.text = last.weight.toString();
    final index = planExercises.indexOf(last.name);

    setState(() {
      selectedIndex = index;
      unit = last!.unit;
    });
  }

  Future<void> select(int index) async {
    setState(() {
      selectedIndex = index;
    });
    final exercise = planExercises.elementAt(index);
    final last = await (db.gymSets.select()
          ..where((tbl) => db.gymSets.name.equals(exercise))
          ..where((tbl) => db.gymSets.hidden.equals(false))
          ..orderBy([
            (u) => drift.OrderingTerm(
                expression: u.created, mode: drift.OrderingMode.desc),
          ])
          ..limit(1))
        .getSingleOrNull();
    setState(() {
      repsController.text = last != null ? last.reps.toString() : "0.0";
      weightController.text = last != null ? last.weight.toString() : "0.0";
    });
  }

  Future<void> save(TimerState timerState, SettingsState settingsState) async {
    final reps = double.parse(repsController.text);
    final weight = double.parse(weightController.text);
    final exercise = planExercises[selectedIndex];

    final gymSet = GymSetsCompanion.insert(
      name: exercise,
      reps: reps,
      weight: weight,
      unit: unit,
      created: DateTime.now(),
    );

    db.into(db.gymSets).insert(gymSet);
    await requestNotificationPermission();

    if (!settingsState.restTimers) return;
    final counts = await widget.countStream.first;
    final countIndex = counts
        .indexWhere((element) => element.read(db.gymSets.name)! == exercise);
    var count = 0;
    if (countIndex != -1)
      count = counts[countIndex].read(db.gymSets.name.count())!;
    count++;

    await timerState.startTimer(
        "$exercise ($count)", settingsState.timerDuration);
  }

  @override
  Widget build(BuildContext context) {
    var title = widget.plan.days.replaceAll(",", ", ");
    if (widget.plan.title?.isNotEmpty == true) title = widget.plan.title!;
    title = title[0].toUpperCase() + title.substring(1).toLowerCase();

    final timerState = context.read<TimerState>();
    final settingsState = context.watch<SettingsState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            TextField(
              controller: repsController,
              focusNode: repsNode,
              decoration: const InputDecoration(labelText: 'Reps'),
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                weightNode.requestFocus();
                weightController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: weightController.text.length,
                );
              },
              onTap: () {
                repsController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: repsController.text.length,
                );
              },
            ),
            TextField(
              controller: weightController,
              focusNode: weightNode,
              decoration: InputDecoration(labelText: 'Weight ($unit)'),
              keyboardType: TextInputType.number,
              onTap: () {
                selectWeight();
              },
              onSubmitted: (value) async =>
                  await save(timerState, settingsState),
            ),
            Visibility(
              visible: settingsState.showUnits,
              child: DropdownButtonFormField<String>(
                value: unit,
                decoration: const InputDecoration(labelText: 'Unit'),
                items: ['kg', 'lb'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    unit = newValue!;
                  });
                },
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: widget.countStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox();

                  return ExerciseList(
                    planExercises: planExercises,
                    snapshot: snapshot,
                    selectedIndex: selectedIndex,
                    onTap: select,
                    onReorder: (oldIndex, newIndex) {
                      if (oldIndex < newIndex) {
                        newIndex--;
                      }

                      final temp = planExercises[oldIndex];
                      planExercises.removeAt(oldIndex);
                      planExercises.insert(newIndex, temp);
                      db.update(db.plans).replace(widget.plan
                          .copyWith(exercises: planExercises.join(',')));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await save(timerState, settingsState),
        tooltip: "Save this set",
        child: const Icon(Icons.save),
      ),
    );
  }
}
