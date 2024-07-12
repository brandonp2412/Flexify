import 'package:drift/drift.dart' as drift;
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/main.dart';
import 'package:flexify/permissions_page.dart';
import 'package:flexify/plan/edit_plan_page.dart';
import 'package:flexify/plan/exercise_list.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flexify/unit_selector.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartPlanPage extends StatefulWidget {
  final Plan plan;

  const StartPlanPage({super.key, required this.plan});

  @override
  createState() => _StartPlanPageState();
}

class _StartPlanPageState extends State<StartPlanPage> {
  final repsController = TextEditingController(text: "0.0");
  final weightController = TextEditingController(text: "0.0");
  final distanceController = TextEditingController(text: "0.0");
  final minutesController = TextEditingController(text: "0.0");
  final secondsController = TextEditingController(text: "0.0");
  final inclineController = TextEditingController(text: "0");

  bool first = true;
  int selectedIndex = 0;
  bool cardio = false;

  late List<String> planExercises = widget.plan.exercises.split(',');
  late final Stream<List<GymCount>> countStream =
      watchCount(widget.plan.id, planExercises);
  late final PlanState planState = context.read<PlanState>();
  late String unit = context.read<SettingsState>().strengthUnit;
  late String title = widget.plan.days.replaceAll(",", ", ");

  @override
  Widget build(BuildContext context) {
    if (widget.plan.title?.isNotEmpty == true) title = widget.plan.title!;
    title = title[0].toUpperCase() + title.substring(1).toLowerCase();

    final timerState = context.read<TimerState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final plan = await (db.plans.select()
                    ..whereSamePrimaryKey(widget.plan))
                  .getSingle();
              if (!context.mounted) return;
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditPlanPage(plan: plan.toCompanion(false)),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            if (!cardio) ...[
              TextField(
                controller: repsController,
                decoration: const InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onSubmitted: (value) {
                  selectAll(weightController);
                },
                onTap: () {
                  selectAll(repsController);
                },
              ),
              TextField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: 'Weight ($unit)',
                  suffixIcon: Selector<SettingsState, bool>(
                    selector: (p0, p1) => p1.hideWeight,
                    builder: (context, hideWeight, child) => Visibility(
                      visible: !hideWeight,
                      child: IconButton(
                        tooltip: "Use body weight",
                        icon: const Icon(Icons.scale),
                        onPressed: () async {
                          final weightSet = await getBodyWeight();
                          if (weightSet == null && context.mounted)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No weight entered yet.'),
                              ),
                            );
                          else
                            weightController.text = toString(weightSet!.weight);
                        },
                      ),
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                onTap: () {
                  selectAll(weightController);
                },
                onSubmitted: (value) async => await save(timerState),
              ),
            ],
            if (cardio) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: minutesController,
                      decoration: const InputDecoration(labelText: 'Minutes'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      onTap: () => selectAll(minutesController),
                      textInputAction: TextInputAction.next,
                      onSubmitted: (value) => selectAll(secondsController),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: secondsController,
                      decoration: const InputDecoration(labelText: 'Seconds'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      onTap: () => selectAll(secondsController),
                      textInputAction: TextInputAction.next,
                      onSubmitted: (value) => selectAll(distanceController),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      controller: distanceController,
                      decoration: const InputDecoration(
                        labelText: 'Distance',
                      ),
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) => selectAll(inclineController),
                      onTap: () {
                        selectAll(distanceController);
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: inclineController,
                      decoration: const InputDecoration(labelText: 'Incline'),
                      keyboardType: TextInputType.number,
                      onTap: () => selectAll(inclineController),
                      onSubmitted: (value) => save(timerState),
                    ),
                  ),
                ],
              ),
            ],
            Selector<SettingsState, bool>(
              selector: (p0, p1) => p1.showUnits,
              builder: (context, showUnits, child) => Visibility(
                visible: showUnits,
                child: UnitSelector(
                  value: unit,
                  cardio: cardio,
                  onChanged: (String? newValue) {
                    setState(() {
                      unit = newValue!;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: countStream,
                builder: (context, snapshot) {
                  return ExerciseList(
                    exercises: planExercises,
                    selected: selectedIndex,
                    onSelect: select,
                    counts: snapshot.data,
                    firstRender: first,
                    plan: widget.plan,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await save(timerState),
        tooltip: "Save",
        child: const Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    repsController.dispose();
    weightController.dispose();
    distanceController.dispose();
    minutesController.dispose();
    inclineController.dispose();

    planState.removeListener(planChanged);

    super.dispose();
  }

  Future<GymSet?> getLast(String exercise) async {
    return (db.gymSets.select()
          ..where((tbl) => db.gymSets.name.equals(exercise))
          ..orderBy([
            (u) => drift.OrderingTerm(
                  expression: u.created,
                  mode: drift.OrderingMode.desc,
                ),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  @override
  void initState() {
    super.initState();
    planState.addListener(planChanged);
    select(0);
  }

  void planChanged() {
    final split = planState.plans
        .firstWhere((element) => element.id == widget.plan.id)
        .exercises
        .split(',');
    setState(() {
      planExercises = split;
      title = planState.plans
          .firstWhere((plan) => plan.id == widget.plan.id)
          .days
          .replaceAll(',', ', ');
    });
  }

  Future<void> save(TimerState timerState) async {
    setState(() {
      first = false;
    });
    final exercise = planExercises[selectedIndex];
    var bodyWeight = 0.0;
    final settings = context.read<SettingsState>();
    if (!settings.hideWeight) bodyWeight = (await getBodyWeight())?.weight ?? 0;

    if (!settings.explainedPermissions &&
        settings.restTimers &&
        mounted &&
        !platformIsDesktop())
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PermissionsPage(),
        ),
      );

    final counts = await countStream.first;
    final countIndex = counts.indexWhere((element) => element.name == exercise);

    int? max;
    int? restMs;
    if (countIndex != -1) {
      max = counts[countIndex].maxSets;
      restMs = counts[countIndex].restMs;
    }

    final minutes = int.tryParse(minutesController.text);
    final seconds = int.tryParse(secondsController.text);
    final duration = (seconds ?? 0) / 60 + (minutes ?? 0);

    var gymSet = GymSetsCompanion.insert(
      name: exercise,
      reps: double.parse(repsController.text),
      weight: double.parse(weightController.text),
      unit: unit,
      created: DateTime.now().toLocal(),
      cardio: drift.Value(cardio),
      duration: drift.Value(duration),
      distance: drift.Value(double.parse(distanceController.text)),
      bodyWeight: drift.Value(bodyWeight),
      restMs: drift.Value(restMs),
      incline: drift.Value(int.tryParse(inclineController.text)),
      planId: drift.Value(widget.plan.id),
    );

    if (settings.restTimers) {
      final countIndex =
          counts.indexWhere((element) => element.name == exercise);
      var count = 0;
      if (countIndex != -1) count = counts[countIndex].count;
      count++;

      final finishedPlan = count == (max ?? settings.maxSets) &&
          selectedIndex == planExercises.length - 1;
      if (!finishedPlan)
        timerState.startTimer(
          "$exercise ($count)",
          restMs != null
              ? Duration(milliseconds: restMs)
              : settings.timerDuration,
          settings.alarmSound,
          settings.vibrate,
        );

      final finishedExercise = count == (max ?? settings.maxSets) &&
          selectedIndex < planExercises.length - 1;
      if (finishedExercise) select(selectedIndex + 1);
    }

    db.into(db.gymSets).insert(gymSet);
  }

  Future<void> select(int index) async {
    setState(() {
      selectedIndex = index;
    });
    final settings = context.read<SettingsState>();
    final last = await getLast(planExercises[index]);
    if (last == null) return;

    setState(() {
      unit = last.unit;
      repsController.text = toString(last.reps);
      weightController.text = toString(last.weight);
      distanceController.text = toString(last.distance);
      minutesController.text = last.duration.floor().toString();
      secondsController.text = ((last.duration * 60) % 60).floor().toString();
      inclineController.text = last.incline?.toString() ?? "";
      cardio = last.cardio;

      if (cardio && (unit == 'kg' || unit == 'lb'))
        unit = settings.cardioUnit;
      else if (!cardio && (unit == 'km' || unit == 'mi'))
        unit = settings.strengthUnit;
    });
  }
}
