import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flexify/animated_fab.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/main.dart';
import 'package:flexify/permissions_page.dart';
import 'package:flexify/plan/edit_plan_page.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/plan/start_list.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
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
  final reps = TextEditingController(text: "0.0");
  final weight = TextEditingController(text: "0.0");
  final notes = TextEditingController(text: "");
  final distance = TextEditingController(text: "0.0");
  final minutes = TextEditingController(text: "0.0");
  final seconds = TextEditingController(text: "0.0");
  final incline = TextEditingController(text: "0");
  final key = GlobalKey<FormState>();

  int selected = 0;
  bool cardio = false;
  DateTime? lastSaved;
  List<Rpm>? rpms;
  String? category;
  String? image;

  late List<String> exercises = [];
  late PlanState planState = context.read<PlanState>();
  late String unit = context.read<SettingsState>().value.strengthUnit;
  late String title = widget.plan.days.replaceAll(",", ", ");

  @override
  Widget build(BuildContext context) {
    if (widget.plan.title?.isNotEmpty == true) title = widget.plan.title!;
    title = title[0].toUpperCase() + title.substring(1).toLowerCase();
    planState = context.watch<PlanState>();
    final timerState = context.read<TimerState>();

    if (exercises.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final plan = await (db.plans.select()
                    ..whereSamePrimaryKey(widget.plan))
                  .getSingle();
              await planState.setExercises(plan.toCompanion(false));
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
        padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 104),
        child: Form(
          key: key,
          child: material.Column(
            children: [
              if (!cardio) ...strengthFields(timerState),
              if (cardio) ...cardioFields(timerState),
              unitSelector(),
              notesField(),
              Expanded(
                child: StartList(
                  exercises: exercises,
                  selected: selected,
                  onSelect: select,
                  plan: widget.plan,
                  onMax: () {
                    planState.updateGymCounts(widget.plan.id);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedFab(
        onPressed: () async => await save(timerState),
        label: const Text("Save"),
        icon: const Icon(Icons.save),
      ),
    );
  }

  List<Widget> strengthFields(TimerState timerState) {
    return [
      TextFormField(
        controller: reps,
        decoration: const InputDecoration(labelText: 'Reps'),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) => selectAll(weight),
        onTap: () => selectAll(reps),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Required';
          if (double.tryParse(value) == null) return 'Invalid number';
          return null;
        },
      ),
      TextFormField(
        controller: weight,
        decoration: InputDecoration(
          labelText: 'Weight ($unit)',
          suffixIcon: Selector<SettingsState, bool>(
            selector: (context, settings) => settings.value.showBodyWeight,
            builder: (context, showBodyWeight, child) => Visibility(
              visible: showBodyWeight,
              child: IconButton(
                tooltip: "Use body weight",
                icon: const Icon(Icons.scale),
                onPressed: useBodyWeight,
              ),
            ),
          ),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onTap: () => selectAll(weight),
        onFieldSubmitted: (value) async => await save(timerState),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Required';
          if (double.tryParse(value) == null) return 'Invalid number';
          return null;
        },
      ),
    ];
  }

  List<Widget> cardioFields(TimerState timerState) {
    return [
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: minutes,
              decoration: const InputDecoration(labelText: 'Minutes'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              onTap: () => selectAll(minutes),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) => selectAll(seconds),
              validator: (value) {
                if (value?.isNotEmpty == true && int.tryParse(value!) == null)
                  return 'Invalid number';
                return null;
              },
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: TextFormField(
              controller: seconds,
              decoration: const InputDecoration(labelText: 'Seconds'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              onTap: () => selectAll(seconds),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) => selectAll(distance),
              validator: (value) {
                if (value?.isNotEmpty == true && int.tryParse(value!) == null)
                  return 'Invalid number';
                return null;
              },
            ),
          ),
        ],
      ),
      Row(
        children: [
          if (unit == 'kg' || unit == 'lb' || unit == 'stone')
            material.Expanded(
              child: TextFormField(
                controller: weight,
                decoration: InputDecoration(
                  labelText: 'Weight ($unit)',
                  suffixIcon: Selector<SettingsState, bool>(
                    selector: (context, settings) =>
                        settings.value.showBodyWeight,
                    builder: (context, showBodyWeight, child) => Visibility(
                      visible: showBodyWeight,
                      child: IconButton(
                        tooltip: "Use body weight",
                        icon: const Icon(Icons.scale),
                        onPressed: useBodyWeight,
                      ),
                    ),
                  ),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onTap: () => selectAll(weight),
                onFieldSubmitted: (value) async => await save(timerState),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
            )
          else
            Expanded(
              child: TextFormField(
                textInputAction: TextInputAction.next,
                controller: distance,
                decoration: const InputDecoration(labelText: 'Distance'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onFieldSubmitted: (value) => selectAll(incline),
                onTap: () => selectAll(distance),
                validator: (value) {
                  if (value == null || value.isEmpty) return null;
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
            ),
          const SizedBox(width: 8.0),
          Expanded(
            child: TextFormField(
              controller: incline,
              decoration: const InputDecoration(labelText: 'Incline %'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onTap: () => selectAll(incline),
              onFieldSubmitted: (value) => save(timerState),
              validator: (value) {
                if (value == null || value.isEmpty) return null;
                if (double.tryParse(value) == null) return 'Invalid number';
                return null;
              },
            ),
          ),
        ],
      ),
    ];
  }

  Widget unitSelector() {
    return Selector<SettingsState, bool>(
      selector: (context, settings) => settings.value.showUnits,
      builder: (context, showUnits, child) => Visibility(
        visible: showUnits,
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Unit'),
          initialValue: unit,
          items: _getUnitItems(),
          onChanged: (String? newValue) {
            setState(() {
              unit = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget notesField() {
    return Selector<SettingsState, bool>(
      selector: (context, settings) => settings.value.showNotes,
      builder: (context, showNotes, child) => Visibility(
        visible: showNotes,
        child: TextFormField(
          controller: notes,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Notes'),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _getUnitItems() {
    return const [
      DropdownMenuItem(
        value: 'kg',
        child: Text("Kilograms (kg)"),
      ),
      DropdownMenuItem(
        value: 'lb',
        child: Text("Pounds (lb)"),
      ),
      DropdownMenuItem(
        value: 'stone',
        child: Text("Stone"),
      ),
      DropdownMenuItem(
        value: 'km',
        child: Text("Kilometers (km)"),
      ),
      DropdownMenuItem(
        value: 'mi',
        child: Text("Miles (mi)"),
      ),
      DropdownMenuItem(
        value: 'm',
        child: Text("Meters (m)"),
      ),
      DropdownMenuItem(
        value: 'kcal',
        child: Text("Kilocalories (kcal)"),
      ),
    ];
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state != AppLifecycleState.resumed) return;
    if (rpms == null || !mounted || lastSaved == null) return;

    final settings = context.read<SettingsState>().value;
    final difference = DateTime.now().difference(lastSaved!);

    if (cardio && settings.durationEstimation) {
      minutes.text = difference.inMinutes.toString();
      seconds.text = (difference.inSeconds % 60).toString();
    } else if (!cardio && settings.repEstimation) {
      final parsedWeight = double.parse(weight.text);
      final closestRpm =
          rpms!.where((rpm) => rpm.name == exercises[selected]).reduce(
                (rpm1, rpm2) => (rpm1.weight - parsedWeight).abs() <
                        (rpm2.weight - parsedWeight).abs()
                    ? rpm1
                    : rpm2,
              );

      final estimatedReps =
          (difference.inMinutes * closestRpm.rpm).clamp(1, 50);
      if (estimatedReps <= 0) return;

      reps.text = estimatedReps.toInt().toString();
    }
  }

  @override
  void dispose() {
    reps.dispose();
    weight.dispose();
    distance.dispose();
    minutes.dispose();
    incline.dispose();
    notes.dispose();
    seconds.dispose();

    WidgetsBinding.instance.removeObserver(this);
    planState.removeListener(planChanged);

    super.dispose();
  }

  Future<GymSet?> getLast(String exercise) async {
    return (db.gymSets.select()
          ..where((tbl) => db.gymSets.name.equals(exercise))
          ..orderBy([
            (u) => OrderingTerm(
                  expression: u.created,
                  mode: OrderingMode.desc,
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

    planState = context.read<PlanState>();
    unit = context.read<SettingsState>().value.strengthUnit;
    title = widget.plan.title?.isNotEmpty == true
        ? widget.plan.title!
        : widget.plan.days.replaceAll(",", ", ");

    _loadExercises();
  }

  Future<void> _loadExercises() async {
    List<String> temp = [];
    await planState.setExercises(widget.plan.toCompanion(false));
    temp = planState.exercises
        .where((pe) => pe.enabled.value)
        .map((exercise) => exercise.exercise.value)
        .toList();
    setState(() {
      exercises = temp;
    });

    if (!mounted) return;

    final lastIndex = planState.lastSets
        .indexWhere((element) => element.name == exercises[0]);
    if (lastIndex != -1) {
      final last = planState.lastSets[lastIndex];
      _updateGymSetTextFields(last);
    }

    final settings = context.read<SettingsState>().value;
    if (settings.repEstimation) {
      getRpms().then((value) => setState(() => rpms = value));
    }

    if (settings.strengthUnit != 'last-entry' && !cardio) {
      setState(() => unit = settings.strengthUnit);
    } else if (settings.cardioUnit != 'last-entry' && cardio) {
      setState(() => unit = settings.cardioUnit);
    }
  }

  void _updateGymSetTextFields(GymSet gymSet) {
    unit = gymSet.unit;
    reps.text = toString(gymSet.reps);
    weight.text = toString(gymSet.weight);
    distance.text = toString(gymSet.distance);
    minutes.text = gymSet.duration.floor().toString();
    seconds.text = ((gymSet.duration * 60) % 60).floor().toString();
    incline.text = gymSet.incline?.toString() ?? "";
    cardio = gymSet.cardio;
    category = gymSet.category;
    image = gymSet.image;
    notes.text = gymSet.notes ?? "";
  }

  void planChanged() {
    final index =
        planState.plans.indexWhere((plan) => plan.id == widget.plan.id);
    if (index == -1) return Navigator.pop(context);

    final plan = planState.plans[index];
    final split = planState.exercises
        .where((pe) => pe.enabled.value)
        .map((exercise) => exercise.exercise.value)
        .toList();

    if (!mounted) return;
    setState(() {
      exercises = split;
      title = plan.days.replaceAll(',', ', ');
    });
  }

  Future<void> save(TimerState timerState) async {
    if (!key.currentState!.validate()) return;

    final exercise = exercises[selected];
    double? bodyWeight;
    final settings = context.read<SettingsState>().value;
    if (settings.showBodyWeight) {
      bodyWeight = (await getBodyWeight())?.weight;
    }
    if (settings.showBodyWeight && bodyWeight == null) {
      final lastSet = await getLast(exercise);
      bodyWeight = lastSet?.bodyWeight;
    }

    if (!settings.explainedPermissions &&
        settings.restTimers &&
        !kIsWeb &&
        mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PermissionsPage(),
        ),
      );
    }

    if (!mounted) return;
    final counts = planState.gymCounts;
    final index = counts.indexWhere((element) => element.name == exercise);

    int? max;
    double? restMs;
    int? warmupSets;
    bool peTimers = true;
    if (index != -1) {
      max = counts[index].maxSets;
      restMs = counts[index].restMs?.toDouble();
      warmupSets = counts[index].warmupSets;
      peTimers = counts[index].timers;
    }

    var gymSetInsert = GymSetsCompanion.insert(
      name: exercise,
      unit: unit,
      created: DateTime.now().toLocal(),
      cardio: Value(cardio),
      duration: Value(
        (int.tryParse(seconds.text) ?? 0) / 60 +
            (int.tryParse(minutes.text) ?? 0),
      ),
      bodyWeight: Value.absentIfNull(bodyWeight),
      restMs: Value(restMs?.toInt()),
      planId: Value(widget.plan.id),
      category: Value(category),
      image: Value(image),
      reps: double.tryParse(reps.text) ?? 0,
      weight: double.tryParse(weight.text) ?? 0,
      incline: Value(int.tryParse(incline.text)),
      distance: Value(double.tryParse(distance.text) ?? 0),
      notes: Value(notes.text),
    );

    var count = 0;
    if (index != -1) count = counts[index].count;
    count++;

    final finishedPlan =
        count == (max ?? settings.maxSets) && selected == exercises.length - 1;
    final isWarmup = count <= (warmupSets ?? settings.warmupSets ?? 0);
    restMs ??= settings.timerDuration.toDouble();

    if (!finishedPlan && !isWarmup && settings.restTimers && peTimers) {
      timerState.startTimer(
        "$exercise ($count)",
        Duration(milliseconds: restMs.toInt()),
        settings.alarmSound,
        settings.vibrate,
      );
    }

    final finishedExercise =
        count == (max ?? settings.maxSets) && selected < exercises.length - 1;

    var gymSet = await db.into(db.gymSets).insertReturning(gymSetInsert);
    await planState.updateGymCounts(widget.plan.id);
    await planState.updateDefaults();
    if (!mounted) return;
    setState(() {
      _updateGymSetTextFields(gymSet);
      lastSaved = DateTime.now();
    });
    if (finishedExercise) await select(selected + 1);

    if (!settings.notifications) return;

    final best = await isBest(gymSet);
    if (!best) return;
    final random = Random();
    final randomMessage =
        positiveReinforcement[random.nextInt(positiveReinforcement.length)];
    if (mounted && random.nextDouble() < 0.3) toast(context, randomMessage);
  }

  Future<void> select(int index) async {
    setState(() => selected = index);
    final last = await getLast(exercises[index]);
    if (last == null) return;

    setState(() => _updateGymSetTextFields(last));
  }

  void useBodyWeight() async {
    final weightSet = await getBodyWeight();
    if (!mounted) return;
    if (weightSet == null) {
      toast(context, 'No weight entered yet');
    } else {
      weight.text = toString(weightSet.weight);
    }
  }
}
