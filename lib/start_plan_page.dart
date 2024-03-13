import 'package:drift/drift.dart' as drift;
import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'exercise_tile.dart';

class StartPlanPage extends StatefulWidget {
  final Plan plan;
  final Stream<List<drift.TypedResult>> countStream;
  final Function onReorder;

  const StartPlanPage(
      {Key? key,
      required this.plan,
      required this.countStream,
      required this.onReorder})
      : super(key: key);

  @override
  createState() => _StartPlanPageState();
}

class _StartPlanPageState extends State<StartPlanPage> {
  late TextEditingController repsController;
  late TextEditingController weightController;
  late List<String> planExercises;

  int selectedIndex = 0;
  final repsNode = FocusNode();
  final weightNode = FocusNode();

  @override
  void initState() {
    super.initState();
    repsController = TextEditingController();
    weightController = TextEditingController();
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

  void getLast() async {
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    final startOfTomorrow = startOfToday.add(const Duration(days: 1));
    var last = await (database.gymSets.select()
          ..where((tbl) => database.gymSets.name.isIn(planExercises))
          ..where((tbl) =>
              database.gymSets.created.isBiggerOrEqualValue(startOfToday))
          ..where((tbl) =>
              database.gymSets.created.isSmallerThanValue(startOfTomorrow))
          ..orderBy([
            (u) => drift.OrderingTerm(
                expression: u.created, mode: drift.OrderingMode.desc),
          ])
          ..limit(1))
        .getSingleOrNull();
    last ??= await (database.gymSets.select()
          ..where((tbl) => database.gymSets.name.equals(planExercises[0]))
          ..orderBy([
            (u) => drift.OrderingTerm(
                expression: u.created, mode: drift.OrderingMode.desc),
          ])
          ..limit(1))
        .getSingleOrNull();
    repsController.text = "0";
    weightController.text = "0";
    if (!mounted) return;
    Provider.of<AppState>(context, listen: false)
        .selectExercise(planExercises[0]);
    setState(() {});
    if (last == null) return;
    repsController.text = last.reps.toString();
    weightController.text = last.weight.toString();
    final index = planExercises.indexOf(last.name);
    setState(() {
      selectedIndex = index;
    });
    Provider.of<AppState>(context, listen: false)
        .selectExercise(planExercises[index]);
  }

  void select(int index) async {
    setState(() {
      selectedIndex = index;
    });
    final exercise = planExercises.elementAt(index);
    Provider.of<AppState>(context, listen: false).selectExercise(exercise);
    final last = await (database.gymSets.select()
          ..where((tbl) => database.gymSets.name.equals(exercise))
          ..orderBy([
            (u) => drift.OrderingTerm(
                expression: u.created, mode: drift.OrderingMode.desc),
          ])
          ..limit(1))
        .getSingleOrNull();
    if (last == null) return;
    repsController.text = last.reps.toString();
    weightController.text = last.weight.toString();
  }

  Future save(AppState appState) async {
    final reps = double.parse(repsController.text);
    final weight = double.parse(weightController.text);
    final exercise = planExercises[selectedIndex];

    final gymSet = GymSetsCompanion.insert(
      name: exercise,
      reps: reps,
      weight: weight,
      unit: 'kg',
      created: DateTime.now(),
    );

    database.into(database.gymSets).insert(gymSet);
    await requestNotificationPermission();

    if (appState.restTimers) appState.startTimer(exercise);
  }

  @override
  Widget build(BuildContext context) {
    var title = widget.plan.days.replaceAll(",", ", ");
    title = title[0].toUpperCase() + title.substring(1).toLowerCase();
    final appState = context.watch<AppState>();
    final timerRunning = appState.nativeTimer.isRunning();

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
            weightController.text.isNotEmpty
                ? TextField(
                    controller: weightController,
                    focusNode: weightNode,
                    decoration: const InputDecoration(labelText: 'Weight (kg)'),
                    keyboardType: TextInputType.number,
                    onTap: () {
                      selectWeight();
                    },
                    onSubmitted: (value) {
                      repsNode.requestFocus();
                      repsController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: repsController.text.length,
                      );
                    },
                  )
                : const SizedBox(
                    height: 64,
                  ),
            repsController.text.isNotEmpty
                ? TextField(
                    controller: repsController,
                    focusNode: repsNode,
                    decoration: const InputDecoration(labelText: 'Reps'),
                    keyboardType: TextInputType.number,
                    onSubmitted: (value) async => await save(appState),
                    onTap: () {
                      repsController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: repsController.text.length,
                      );
                    },
                  )
                : const SizedBox(
                    height: 64,
                  ),
            Expanded(
              child: StreamBuilder(
                stream: widget.countStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox();

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        exerciseList(planExercises, snapshot),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            right: 0,
            bottom: 0,
            child: timerRunning
                ? FloatingActionButton(
                    onPressed: () => appState.stopTimer(),
                    child: const Icon(Icons.stop),
                  )
                : FloatingActionButton(
                    onPressed: () async => await save(appState),
                    tooltip: "Save this set",
                    child: const Icon(Icons.save),
                  ),
          ),
          Positioned(
            left: 32.0,
            bottom: 0,
            child: Visibility(
              visible: timerRunning,
              child: FloatingActionButton(
                tooltip: "Add 1 min",
                onPressed: () => appState.addOneMinute(),
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }

  exerciseList(List<String> planExercises,
      AsyncSnapshot<List<drift.TypedResult>> snapshot) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: planExercises.length,
      itemBuilder: (context, index) {
        final exercise = planExercises[index];
        final gymSets = snapshot.data?.where(
            (element) => element.read(database.gymSets.name) == exercise);
        var count = 0;
        if (gymSets != null && gymSets.isNotEmpty)
          count = gymSets.first.read(database.gymSets.name.count())!;
        return ExerciseTile(
          index: index,
          exercise: exercise,
          isSelected: index == selectedIndex,
          count: count,
          onTap: () {
            select(index);
          },
          key: Key(exercise),
        );
      },
      onReorder: (int oldIndex, int newIndex) async {
        if (oldIndex < newIndex) {
          newIndex--;
        }

        final temp = planExercises[oldIndex];
        planExercises.removeAt(oldIndex);
        planExercises.insert(newIndex, temp);
        setState(() {});

        final plan = widget.plan.copyWith(exercises: planExercises.join(','));
        await database.update(database.plans).replace(plan);
        widget.onReorder();
      },
    );
  }
}
