import 'dart:async';
import 'dart:math';

import 'package:drift/drift.dart' hide Column;
import 'package:flexify/animated_fab.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/empty_state.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/main.dart';
import 'package:flexify/permissions_page.dart';
import 'package:flexify/plan/edit_plan_page.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/plan/session_sets.dart';
import 'package:flexify/plan/start_list.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/stepper_field.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/foundation.dart';
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
  final _reps = TextEditingController(text: "0.0");
  final _weight = TextEditingController(text: "0.0");
  final _notes = TextEditingController(text: "");
  final _distance = TextEditingController(text: "0.0");
  final _minutes = TextEditingController(text: "0.0");
  final _seconds = TextEditingController(text: "0.0");
  final _incline = TextEditingController(text: "0");
  final _key = GlobalKey<FormState>();

  int _selected = 0;
  bool _cardio = false;
  DateTime? _lastSaved;
  List<Rpm>? _rpms;
  String? _category;
  String? _image;

  late Stream<List<PlanExercise>> _stream;
  StreamSubscription<void>? _gymSetsSub;
  late PlanState _planState = context.read<PlanState>();
  late String _unit = 'kg';
  late String _title = widget.plan.days.replaceAll(",", ", ");

  @override
  Widget build(BuildContext context) {
    _planState = context.watch<PlanState>();

    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.data == null) return SizedBox();

        final desktop = isDesktopLayout(context);
        final colors = Theme.of(context).colorScheme;

        Future<void> editPlan() async {
          final plan =
              await (db.plans.select()..whereSamePrimaryKey(widget.plan))
                  .getSingle();
          await _planState.setExercises(plan.toCompanion(false));
          if (!context.mounted) return;
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditPlanPage(plan: plan.toCompanion(false)),
            ),
          );
        }

        Widget exerciseList() => snapshot.data!.isEmpty
            ? AppEmptyState(
                icon: Icons.fitness_center_rounded,
                title: 'No exercises yet',
                message: 'Add exercises to this plan before starting it.',
                actionLabel: 'Edit plan',
                actionIcon: Icons.edit_rounded,
                onAction: editPlan,
              )
            : StartList(
                exercises: snapshot.data!,
                selected: _selected,
                onSelect: select,
                plan: widget.plan,
                onMax: () => _planState.updateGymCounts(widget.plan.id),
              );

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(_title),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                tooltip: 'Edit plan',
                onPressed: editPlan,
                icon: const Icon(Icons.edit),
              ),
              if (desktop && snapshot.data!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: FilledButton.icon(
                    onPressed: () async => await save(snapshot),
                    icon: const Icon(Icons.save_rounded),
                    label: const Text('Save set'),
                  ),
                ),
            ],
          ),
          body: ResponsiveContent(
            maxWidth: desktopWideContentMaxWidth,
            desktopPadding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
            mobilePadding: const EdgeInsets.all(8),
            child: Form(
              key: _key,
              child: desktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 420,
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: colors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    snapshot.data!.isNotEmpty &&
                                            _selected < snapshot.data!.length
                                        ? snapshot.data![_selected].exercise
                                        : 'Set details',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 16),
                                  if (!_cardio) ...strengthFields(snapshot),
                                  if (_cardio) ...cardioFields(snapshot),
                                  unitSelector(),
                                  notesField(),
                                  if (snapshot.data!.isNotEmpty &&
                                      _selected < snapshot.data!.length) ...[
                                    const SizedBox(height: 16),
                                    SessionSets(
                                      exercise:
                                          snapshot.data![_selected].exercise,
                                      planId: widget.plan.id,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: exerciseList(),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        if (!_cardio) ...strengthFields(snapshot),
                        if (_cardio) ...cardioFields(snapshot),
                        unitSelector(),
                        notesField(),
                        if (snapshot.data!.isNotEmpty &&
                            _selected < snapshot.data!.length)
                          SessionSets(
                            exercise: snapshot.data![_selected].exercise,
                            planId: widget.plan.id,
                          ),
                        Expanded(child: exerciseList()),
                      ],
                    ),
            ),
          ),
          floatingActionButton: desktop || snapshot.data!.isEmpty
              ? null
              : AnimatedFab(
                  onPressed: () async => await save(snapshot),
                  label: const Text("Save"),
                  icon: const Icon(Icons.save),
                ),
        );
      },
    );
  }

  List<Widget> strengthFields(AsyncSnapshot<List<PlanExercise>> snapshot) {
    return [
      StepperField(
        controller: _reps,
        labelText: 'Reps',
        step: 1,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) => selectAll(_weight),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Required';
          if (double.tryParse(value) == null) return 'Invalid number';
          return null;
        },
      ),
      const SizedBox(height: 8.0),
      _weightField(snapshot),
    ];
  }

  List<Widget> cardioFields(AsyncSnapshot<List<PlanExercise>> snapshot) {
    return [
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _minutes,
              decoration: const InputDecoration(labelText: 'Minutes'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              onTap: () => selectAll(_minutes),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) => selectAll(_seconds),
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
              controller: _seconds,
              decoration: const InputDecoration(labelText: 'Seconds'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              onTap: () => selectAll(_seconds),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) => selectAll(_distance),
              validator: (value) {
                if (value?.isNotEmpty == true && int.tryParse(value!) == null)
                  return 'Invalid number';
                return null;
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: 8.0),
      Row(
        children: [
          if (_unit == 'kg' || _unit == 'lb' || _unit == 'stone')
            Expanded(child: _weightField(snapshot))
          else
            Expanded(
              child: TextFormField(
                textInputAction: TextInputAction.next,
                controller: _distance,
                decoration: const InputDecoration(labelText: 'Distance'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onFieldSubmitted: (value) => selectAll(_incline),
                onTap: () => selectAll(_distance),
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
              controller: _incline,
              decoration: const InputDecoration(labelText: 'Incline %'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onTap: () => selectAll(_incline),
              onFieldSubmitted: (value) => save(snapshot),
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

  StepperField _weightField(AsyncSnapshot<List<PlanExercise>> snapshot) {
    final exerciseName =
        snapshot.data!.isNotEmpty && _selected < snapshot.data!.length
        ? snapshot.data![_selected].exercise
        : '';
    return StepperField(
      controller: _weight,
      labelText: 'Weight ($_unit)',
      step: weightStep(exerciseName, _unit),
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
      onFieldSubmitted: (value) async => await save(snapshot),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required';
        if (double.tryParse(value) == null) return 'Invalid number';
        return null;
      },
    );
  }

  Widget unitSelector() {
    return Selector<SettingsState, bool>(
      selector: (context, settings) => settings.value.showUnits,
      builder: (context, showUnits, child) => Visibility(
        visible: showUnits,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Unit'),
              initialValue: _unit,
              items: _unitItems,
              onChanged: (String? newValue) {
                setState(() {
                  _unit = newValue!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget notesField() {
    return Selector<SettingsState, bool>(
      selector: (context, settings) => settings.value.showNotes,
      builder: (context, showNotes, child) => Visibility(
        visible: showNotes,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _notes,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
          ],
        ),
      ),
    );
  }

  static const _unitItems = [
    DropdownMenuItem(value: 'kg', child: Text("Kilograms (kg)")),
    DropdownMenuItem(value: 'lb', child: Text("Pounds (lb)")),
    DropdownMenuItem(value: 'stone', child: Text("Stone")),
    DropdownMenuItem(value: 'km', child: Text("Kilometers (km)")),
    DropdownMenuItem(value: 'mi', child: Text("Miles (mi)")),
    DropdownMenuItem(value: 'm', child: Text("Meters (m)")),
    DropdownMenuItem(value: 'kcal', child: Text("Kilocalories (kcal)")),
  ];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state != AppLifecycleState.resumed) return;
    if (_rpms == null || !mounted || _lastSaved == null) return;

    final settings = context.read<SettingsState>().value;
    final difference = DateTime.now().difference(_lastSaved!);

    if (_cardio && settings.durationEstimation) {
      _minutes.text = difference.inMinutes.toString();
      _seconds.text = (difference.inSeconds % 60).toString();
    } else if (!_cardio && settings.repEstimation) {
      final parsedWeight = double.parse(_weight.text);
      _stream.first.then((planExercises) {
        if (!mounted) return;
        final matches = _rpms!.where(
          (rpm) => rpm.name == planExercises[_selected].exercise,
        );
        if (matches.isEmpty) return;

        final closestRpm = matches.reduce(
          (rpm1, rpm2) =>
              (rpm1.weight - parsedWeight).abs() <
                  (rpm2.weight - parsedWeight).abs()
              ? rpm1
              : rpm2,
        );

        final estimatedReps = (difference.inMinutes * closestRpm.rpm).clamp(
          1,
          50,
        );
        if (estimatedReps <= 0) return;

        _reps.text = estimatedReps.toInt().toString();
      });
    }
  }

  @override
  void dispose() {
    _reps.dispose();
    _weight.dispose();
    _distance.dispose();
    _minutes.dispose();
    _incline.dispose();
    _notes.dispose();
    _seconds.dispose();

    WidgetsBinding.instance.removeObserver(this);
    _planState.removeListener(planChanged);
    dbVersion.removeListener(_loadExercises);
    _gymSetsSub?.cancel();

    super.dispose();
  }

  Future<GymSet?> getLast(String exercise) async {
    return (db.gymSets.select()
          ..where((tbl) => db.gymSets.name.equals(exercise))
          ..orderBy([
            (u) => OrderingTerm(expression: u.created, mode: OrderingMode.desc),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Returns the first set from the most recent training session for [exercise].
  ///
  /// "Most recent session" = the calendar day of the latest recorded set.
  /// Showing the first set (rather than the last) gives a better baseline for
  /// progressive overload when weights decrease across sets.
  Future<GymSet?> getFirstOfLastSession(String exercise) async {
    final mostRecent = await getLast(exercise);
    if (mostRecent == null) return null;

    final date = mostRecent.created.toLocal();
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (db.gymSets.select()
          ..where(
            (tbl) =>
                tbl.name.equals(exercise) &
                tbl.created.isBiggerOrEqualValue(startOfDay.toUtc()) &
                tbl.created.isSmallerThanValue(endOfDay.toUtc()),
          )
          ..orderBy([
            (u) => OrderingTerm(expression: u.created, mode: OrderingMode.asc),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  @override
  void initState() {
    super.initState();
    _planState.addListener(planChanged);
    WidgetsBinding.instance.addObserver(this);
    dbVersion.addListener(_loadExercises);

    _planState = context.read<PlanState>();
    _title = widget.plan.title?.isNotEmpty == true
        ? widget.plan.title!
        : widget.plan.days.replaceAll(",", ", ");

    _loadExercises();
    _planState.updateGymCounts(widget.plan.id);
    _gymSetsSub = db.tableUpdates(TableUpdateQuery.onTable(db.gymSets)).listen((
      _,
    ) {
      if (!mounted) return;
      _planState.updateGymCounts(widget.plan.id);
    });
  }

  Future<void> _loadExercises() async {
    setState(() {
      _stream =
          (db.planExercises.select()
                ..where((pe) => pe.planId.equals(widget.plan.id) & pe.enabled)
                ..orderBy([
                  (u) => OrderingTerm(
                    expression: u.sequence,
                    mode: OrderingMode.asc,
                  ),
                ]))
              .watch();
    });

    select(0);
    if (!mounted) return;
    final settings = context.read<SettingsState>().value;
    if (settings.repEstimation) {
      getRpms().then((value) {
        if (!mounted) return;
        setState(() => _rpms = value);
      });
    }

    if (settings.strengthUnit != 'last-entry' && !_cardio) {
      setState(() => _unit = settings.strengthUnit);
    } else if (settings.cardioUnit != 'last-entry' && _cardio) {
      setState(() => _unit = settings.cardioUnit);
    }
  }

  void _updateGymSetTextFields(GymSet gymSet) {
    final settings = context.read<SettingsState>().value;
    if (settings.strengthUnit == 'last-entry' && !gymSet.cardio ||
        settings.cardioUnit == 'last-entry' && gymSet.cardio)
      _unit = gymSet.unit;
    else if (gymSet.cardio)
      _unit = settings.cardioUnit;
    else
      _unit = settings.strengthUnit;

    _reps.text = toString(gymSet.reps);
    _weight.text = toString(gymSet.weight);
    _distance.text = toString(gymSet.distance);
    _minutes.text = gymSet.duration.floor().toString();
    _seconds.text = ((gymSet.duration * 60) % 60).floor().toString();
    _incline.text = gymSet.incline?.toString() ?? "";
    _cardio = gymSet.cardio;
    _category = gymSet.category;
    _image = gymSet.image;
    _notes.text = gymSet.notes ?? "";
  }

  void planChanged() {
    final index = _planState.plans.indexWhere(
      (plan) => plan.id == widget.plan.id,
    );
    if (index == -1) return Navigator.pop(context);

    final plan = _planState.plans[index];
    if (!mounted) return;
    setState(() {
      _title = plan.title?.isNotEmpty == true
          ? plan.title!
          : plan.days.replaceAll(',', ', ');
    });
  }

  Future<void> save(AsyncSnapshot<List<PlanExercise>> snapshot) async {
    if (!_key.currentState!.validate()) return;
    if (snapshot.data == null || snapshot.data!.isEmpty) return;
    if (_selected >= snapshot.data!.length) return;

    if (!mounted) return;

    final exercise = snapshot.data![_selected].exercise;
    double? bodyWeight;
    final settings = context.read<SettingsState>().value;
    if (settings.showBodyWeight) {
      bodyWeight = (await getBodyWeight())?.weight;
    }
    if (settings.showBodyWeight && bodyWeight == null) {
      final lastSet = await getLast(exercise);
      bodyWeight = lastSet?.bodyWeight;
    }

    if (settings.notifications && !settings.notificationPermissionRequested) {
      await requestNotificationPermission();
    }

    if (!settings.explainedPermissions &&
        settings.restTimers &&
        !kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android &&
        mounted) {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const PermissionsPage()));
    }

    if (!mounted) return;
    final counts = _planState.gymCounts;
    final index = counts.indexWhere((element) => element.name == exercise);

    int? max;
    double? restMs;
    int warmupSets = 0;
    bool peTimers = true;
    if (index != -1) {
      max = counts[index].maxSets;
      restMs = counts[index].restMs?.toDouble();
      warmupSets = counts[index].warmupSets ?? 0;
      peTimers = counts[index].timers;
    }

    var gymSetInsert = GymSetsCompanion.insert(
      name: exercise,
      unit: _unit,
      created: DateTime.now().toLocal(),
      cardio: Value(_cardio),
      duration: Value(
        (int.tryParse(_seconds.text) ?? 0) / 60 +
            (int.tryParse(_minutes.text) ?? 0),
      ),
      bodyWeight: Value.absentIfNull(bodyWeight),
      restMs: Value(restMs?.toInt()),
      planId: Value(widget.plan.id),
      category: Value(_category),
      image: Value(_image),
      reps: double.tryParse(_reps.text) ?? 0,
      weight: double.tryParse(_weight.text) ?? 0,
      incline: Value(int.tryParse(_incline.text)),
      distance: Value(double.tryParse(_distance.text) ?? 0),
      notes: Value(_notes.text),
    );

    var count = 0;
    if (index != -1) count = counts[index].count;
    count++;

    restMs ??= settings.timerDuration.toDouble();

    final timerState = context.read<TimerState>();
    if (settings.restTimers && count > warmupSets && peTimers)
      timerState.startTimer(
        "$exercise ($count)",
        Duration(milliseconds: restMs.toInt()),
        settings.alarmSound,
        settings.vibrate,
        settings.enableSound,
      );

    final finishedExercise =
        count == (max ?? settings.maxSets) &&
        _selected < snapshot.data!.length - 1;

    var gymSet = await db.into(db.gymSets).insertReturning(gymSetInsert);
    await _planState.updateAfterSave(
      planId: widget.plan.id,
      updateCounts:
          settings.planTrailing == 'PlanTrailing.count' ||
          settings.planTrailing == 'PlanTrailing.ratio' ||
          settings.planTrailing == 'PlanTrailing.percent',
    );
    if (!mounted) return;
    setState(() {
      _updateGymSetTextFields(gymSet);
      _lastSaved = DateTime.now();
    });
    if (finishedExercise) await select(_selected + 1);

    if (!settings.notifications) return;

    final best = await isBest(gymSet);
    if (!best) return;
    final random = Random();
    final randomMessage =
        positiveReinforcement[random.nextInt(positiveReinforcement.length)];
    if (mounted && random.nextDouble() < 0.3) toast(randomMessage);
  }

  Future<void> select(int index) async {
    setState(() => _selected = index);
    final first = await _stream.first;
    if (first.isEmpty || index >= first.length) return;
    final last = await getFirstOfLastSession(first[index].exercise);
    if (last == null || !mounted) return;

    setState(() => _updateGymSetTextFields(last));
  }

  void useBodyWeight() async {
    final weightSet = await getBodyWeight();
    if (!mounted) return;
    if (weightSet == null) {
      toast('No weight entered yet');
    } else {
      _weight.text = toString(weightSet.weight);
    }
  }
}
