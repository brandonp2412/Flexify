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

class _StartPlanPageState extends State<StartPlanPage>
    with WidgetsBindingObserver {
  final repsController = TextEditingController(text: "0.0");
  final weightController = TextEditingController(text: "0.0");
  final distanceController = TextEditingController(text: "0.0");
  final minutesController = TextEditingController(text: "0.0");
  final secondsController = TextEditingController(text: "0.0");
  final inclineController = TextEditingController(text: "0");

  /// Used to show progress lines instantly on first render.
  bool first = true;

  int selectedIndex = 0;
  bool cardio = false;
  DateTime? lastSaved;
  List<Rpm>? rpms;
  String? category;

  late List<String> planExercises = widget.plan.exercises.split(',');
  late final Stream<List<GymCount>> countStream =
      watchCount(widget.plan.id, planExercises);
  late final PlanState planState = context.read<PlanState>();
  late String unit = context.read<SettingsState>().value.strengthUnit;
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
                    selector: (context, settings) => settings.value.hideWeight,
                    builder: (context, hideWeight, child) => Visibility(
                      visible: !hideWeight,
                      child: IconButton(
                        tooltip: "Use body weight",
                        icon: const Icon(Icons.scale),
                        onPressed: useBodyWeight,
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
                      decoration: const InputDecoration(labelText: 'Incline %'),
                      keyboardType: TextInputType.number,
                      onTap: () => selectAll(inclineController),
                      onSubmitted: (value) => save(timerState),
                    ),
                  ),
                ],
              ),
            ],
            Selector<SettingsState, bool>(
              selector: (context, settings) => settings.value.showUnits,
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state != AppLifecycleState.resumed) return;
    if (rpms == null || !mounted || lastSaved == null) return;

    final settings = context.read<SettingsState>().value;
    final difference = DateTime.now().difference(lastSaved!);

    if (cardio && settings.durationEstimation) {
      minutesController.text = difference.inMinutes.toString();
      secondsController.text = (difference.inSeconds % 60).toString();
    } else if (!cardio && settings.repEstimation) {
      final weight = double.parse(weightController.text);
      final closestRpm =
          rpms!.where((rpm) => rpm.name == planExercises[selectedIndex]).reduce(
                (rpm1, rpm2) =>
                    (rpm1.weight - weight).abs() < (rpm2.weight - weight).abs()
                        ? rpm1
                        : rpm2,
              );

      final reps = difference.inMinutes * closestRpm.rpm;
      if (reps <= 0) return;

      repsController.text = reps.toInt().toString();
    }
  }

  @override
  void dispose() {
    repsController.dispose();
    weightController.dispose();
    distanceController.dispose();
    minutesController.dispose();
    inclineController.dispose();

    WidgetsBinding.instance.removeObserver(this);
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
    WidgetsBinding.instance.addObserver(this);

    final settings = context.read<SettingsState>().value;
    if (settings.repEstimation)
      getRpms().then(
        (value) => setState(() {
          rpms = value;
        }),
      );

    select(0);
  }

  planChanged() {
    final index =
        planState.plans.indexWhere((plan) => plan.id == widget.plan.id);
    if (index == -1) return Navigator.pop(context);

    final plan = planState.plans[index];
    final split = plan.exercises.split(',');

    if (!mounted) return;
    setState(() {
      planExercises = split;
      title = plan.days.replaceAll(',', ', ');
    });
  }

  Future<void> save(TimerState timerState) async {
    setState(() {
      first = false;
    });
    final exercise = planExercises[selectedIndex];
    var bodyWeight = 0.0;
    final settings = context.read<SettingsState>().value;
    if (!settings.hideWeight) bodyWeight = (await getBodyWeight())?.weight ?? 0;

    if (!settings.explainedPermissions &&
        settings.restTimers &&
        platformIsMobile() &&
        mounted)
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PermissionsPage(),
        ),
      );

    final counts = await countStream.first;
    final countIndex = counts.indexWhere((element) => element.name == exercise);

    int? max;
    double? restMs;
    int? warmupSets;
    if (countIndex != -1) {
      max = counts[countIndex].maxSets;
      restMs = counts[countIndex].restMs?.toDouble();
      warmupSets = counts[countIndex].warmupSets;
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
      restMs: drift.Value(restMs?.toInt()),
      incline: drift.Value(int.tryParse(inclineController.text)),
      planId: drift.Value(widget.plan.id),
      category: drift.Value(category),
    );

    var count = 0;
    if (countIndex != -1) count = counts[countIndex].count;
    count++;

    final finishedPlan = count == (max ?? settings.maxSets) &&
        selectedIndex == planExercises.length - 1;
    final isWarmup = count <= (warmupSets ?? settings.warmupSets ?? 0);
    restMs ??= settings.timerDuration.toDouble();
    if (isWarmup) restMs *= 0.5;

    if (!finishedPlan && settings.restTimers)
      timerState.startTimer(
        "$exercise ($count)",
        Duration(milliseconds: restMs.toInt()),
        settings.alarmSound,
        settings.vibrate,
      );

    final finishedExercise = count == (max ?? settings.maxSets) &&
        selectedIndex < planExercises.length - 1;
    if (finishedExercise) select(selectedIndex + 1);

    db.into(db.gymSets).insert(gymSet);
    if (!mounted) return;
    setState(() {
      lastSaved = DateTime.now();
    });
  }

  Future<void> select(int index) async {
    setState(() {
      selectedIndex = index;
    });
    final settings = context.read<SettingsState>().value;
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
      category = last.category;

      if (cardio && (unit == 'kg' || unit == 'lb'))
        unit = settings.cardioUnit;
      else if (!cardio && (unit == 'km' || unit == 'mi'))
        unit = settings.strengthUnit;
    });
  }

  useBodyWeight() async {
    final weightSet = await getBodyWeight();
    if (weightSet == null && mounted)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No weight entered yet.'),
        ),
      );
    else
      weightController.text = toString(weightSet!.weight);
  }
}
