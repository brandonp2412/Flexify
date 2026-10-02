import 'dart:async';
import 'dart:math';

import 'package:drift/drift.dart' hide Column;
import 'package:flexify/animated_fab.dart';
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/body_weight_repository.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_catalog.dart';
import 'package:flexify/empty_state.dart';
import 'package:flexify/database/exercise_analytics.dart';
import 'package:flexify/database/performed_sets.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/permissions_page.dart';
import 'package:flexify/plan/edit_plan_page.dart';
import 'package:flexify/plan/plan_queries.dart';
import 'package:flexify/plan/session_sets.dart';
import 'package:flexify/plan/start_list.dart';
import 'package:flexify/plan/workout_sessions.dart';
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
  final _repsFocus = FocusNode();
  final _weightFocus = FocusNode();
  final _minutesFocus = FocusNode();
  final _secondsFocus = FocusNode();
  final _distanceFocus = FocusNode();
  final _inclineFocus = FocusNode();
  final _notesFocus = FocusNode();
  final _key = GlobalKey<FormState>();

  int _selected = 0;
  bool _cardio = false;
  DateTime? _lastSaved;
  List<Rpm>? _rpms;
  String? _category;
  String? _image;

  Stream<List<PlanExerciseEntry>>? _stream;
  Stream<List<GymCount>>? _gymCountsStream;
  Workout? _workout;
  StreamSubscription<Plan?>? _planSub;
  late String _unit = 'kg';
  late String _title = widget.plan.days;
  late bool _titleFromDays = widget.plan.title?.isNotEmpty != true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.data == null) return SizedBox();

        return StreamBuilder<List<GymCount>>(
          stream: _gymCountsStream,
          builder: (context, countsSnapshot) {
            final counts = countsSnapshot.data ?? const <GymCount>[];
            final desktop = isDesktopLayout(context);
            final colors = Theme.of(context).colorScheme;

            Future<void> editPlan() async {
              final plan =
                  await (db.plans.select()..whereSamePrimaryKey(widget.plan))
                      .getSingle();
              if (!context.mounted) return;
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      EditPlanPage(plan: plan.toCompanion(false)),
                ),
              );
              if (!mounted) return;
              await select(_selected);
            }

            Widget exerciseList() => snapshot.data!.isEmpty
                ? AppEmptyState(
                    icon: Icons.fitness_center_rounded,
                    title: context.l10n.noExercisesYet,
                    message: context.l10n.addExerciseToPlan,
                    actionLabel: context.l10n.editPlan,
                    actionIcon: Icons.edit_rounded,
                    onAction: editPlan,
                  )
                : StartList(
                    exercises: snapshot.data!,
                    selected: _selected,
                    onSelect: select,
                    counts: counts,
                    plan: widget.plan,
                    workoutId: _workout!.id,
                  );

            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                title: Text(_displayTitle(context)),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    tooltip: context.l10n.editPlan,
                    onPressed: editPlan,
                    icon: const Icon(Icons.edit),
                  ),
                  if (desktop && snapshot.data!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: FilledButton.icon(
                        onPressed: () async => await save(snapshot, counts),
                        icon: const Icon(Icons.save_rounded),
                        label: Text(context.l10n.saveSet),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        snapshot.data!.isNotEmpty &&
                                                _selected <
                                                    snapshot.data!.length
                                            ? snapshot
                                                  .data![_selected]
                                                  .exercise
                                                  .name
                                            : context.l10n.setDetails,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(height: 16),
                                      if (!_cardio)
                                        ...strengthFields(snapshot, counts),
                                      if (_cardio)
                                        ...cardioFields(snapshot, counts),
                                      unitSelector(),
                                      notesField(snapshot, counts),
                                      if (snapshot.data!.isNotEmpty &&
                                          _selected <
                                              snapshot.data!.length) ...[
                                        const SizedBox(height: 16),
                                        SessionSets(
                                          exerciseId: snapshot
                                              .data![_selected]
                                              .exercise
                                              .id,
                                          workoutId: _workout!.id,
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
                            if (!_cardio) ...strengthFields(snapshot, counts),
                            if (_cardio) ...cardioFields(snapshot, counts),
                            unitSelector(),
                            notesField(snapshot, counts),
                            Expanded(child: exerciseList()),
                          ],
                        ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton:
                  desktop ||
                      snapshot.data!.isEmpty ||
                      _selected >= snapshot.data!.length
                  ? null
                  : Padding(
                      key: const Key('start-plan-floating-row'),
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: MediaQuery.viewInsetsOf(context).bottom > 0
                            ? 0
                            : bottomNavHeight,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SessionSets(
                              key: const Key('start-plan-set-preview'),
                              exerciseId: snapshot.data![_selected].exercise.id,
                              workoutId: _workout!.id,
                              compact: true,
                            ),
                          ),
                          const SizedBox(width: 8),
                          AnimatedFab(
                            onPressed: () async => await save(snapshot, counts),
                            label: Text(context.l10n.actionSave),
                            icon: const Icon(Icons.save),
                            bottomPadding: 0,
                          ),
                        ],
                      ),
                    ),
            );
          },
        );
      },
    );
  }

  List<Widget> strengthFields(
    AsyncSnapshot<List<PlanExerciseEntry>> snapshot,
    List<GymCount> counts,
  ) {
    return [
      StepperField(
        controller: _reps,
        focusNode: _repsFocus,
        labelText: context.l10n.repsLabel,
        step: 1,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => _focusAndSelect(_weightFocus, _weight),
        validator: (value) {
          if (value == null || value.isEmpty) return context.l10n.requiredField;
          if (parseDisplayNumber(context, value) == null)
            return context.l10n.invalidNumber;
          return null;
        },
      ),
      const SizedBox(height: 8.0),
      _weightField(snapshot, counts),
    ];
  }

  List<Widget> cardioFields(
    AsyncSnapshot<List<PlanExerciseEntry>> snapshot,
    List<GymCount> counts,
  ) {
    final showNotes = context.read<SettingsState>().value.showNotes;

    return [
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _minutes,
              focusNode: _minutesFocus,
              decoration: InputDecoration(labelText: context.l10n.minutesLabel),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              onTap: () => selectAll(_minutes),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _focusAndSelect(_secondsFocus, _seconds),
              validator: (value) {
                if (value?.isNotEmpty == true && int.tryParse(value!) == null)
                  return context.l10n.invalidNumber;
                return null;
              },
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: TextFormField(
              controller: _seconds,
              focusNode: _secondsFocus,
              decoration: InputDecoration(labelText: context.l10n.secondsLabel),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              onTap: () => selectAll(_seconds),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                if (_unit == 'kg' || _unit == 'lb' || _unit == 'stone') {
                  _focusAndSelect(_weightFocus, _weight);
                } else {
                  _focusAndSelect(_distanceFocus, _distance);
                }
              },
              validator: (value) {
                if (value?.isNotEmpty == true && int.tryParse(value!) == null)
                  return context.l10n.invalidNumber;
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
            Expanded(child: _weightField(snapshot, counts))
          else
            Expanded(
              child: TextFormField(
                textInputAction: TextInputAction.next,
                controller: _distance,
                focusNode: _distanceFocus,
                decoration: InputDecoration(
                  labelText: context.l10n.distanceLabel,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onFieldSubmitted: (_) =>
                    _focusAndSelect(_inclineFocus, _incline),
                onTap: () => selectAll(_distance),
                validator: (value) {
                  if (value == null || value.isEmpty) return null;
                  if (parseDisplayNumber(context, value) == null)
                    return context.l10n.invalidNumber;
                  return null;
                },
              ),
            ),
          const SizedBox(width: 8.0),
          Expanded(
            child: TextFormField(
              controller: _incline,
              focusNode: _inclineFocus,
              decoration: InputDecoration(
                labelText: context.l10n.inclinePercent,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onTap: () => selectAll(_incline),
              textInputAction: showNotes
                  ? TextInputAction.next
                  : TextInputAction.done,
              onFieldSubmitted: (_) async {
                if (showNotes) {
                  _focusAndSelect(_notesFocus, _notes);
                } else {
                  await save(snapshot, counts);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) return null;
                if (double.tryParse(value) == null)
                  return context.l10n.invalidNumber;
                return null;
              },
            ),
          ),
        ],
      ),
    ];
  }

  StepperField _weightField(
    AsyncSnapshot<List<PlanExerciseEntry>> snapshot,
    List<GymCount> counts,
  ) {
    final exerciseName =
        snapshot.data!.isNotEmpty && _selected < snapshot.data!.length
        ? snapshot.data![_selected].exercise.name
        : '';
    final showNotes = context.read<SettingsState>().value.showNotes;
    final hasNextTextField = _cardio || showNotes;

    return StepperField(
      controller: _weight,
      focusNode: _weightFocus,
      labelText: context.l10n.weightWithUnit(_unit),
      step: weightStep(exerciseName, _unit),
      suffixIcon: Selector<SettingsState, bool>(
        selector: (context, settings) => settings.value.showBodyWeight,
        builder: (context, showBodyWeight, child) => Visibility(
          visible: showBodyWeight,
          child: IconButton(
            tooltip: context.l10n.useBodyWeight,
            icon: const Icon(Icons.scale),
            onPressed: useBodyWeight,
          ),
        ),
      ),
      textInputAction: hasNextTextField
          ? TextInputAction.next
          : TextInputAction.done,
      onFieldSubmitted: (_) async {
        if (_cardio) {
          _focusAndSelect(_inclineFocus, _incline);
        } else if (showNotes) {
          _focusAndSelect(_notesFocus, _notes);
        } else {
          await save(snapshot, counts);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) return context.l10n.requiredField;
        if (parseDisplayNumber(context, value) == null)
          return context.l10n.invalidNumber;
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
              isExpanded: true,
              decoration: InputDecoration(labelText: context.l10n.unitLabel),
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

  Widget notesField(
    AsyncSnapshot<List<PlanExerciseEntry>> snapshot,
    List<GymCount> counts,
  ) {
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
              focusNode: _notesFocus,
              maxLines: 3,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: context.l10n.notesLabel),
              onFieldSubmitted: (_) async => await save(snapshot, counts),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> get _unitItems => [
    ...strengthUnitMenuItems(context.l10n),
    ...cardioUnitMenuItems(context.l10n),
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
      final parsedWeight = parseDisplayNumber(context, _weight.text);
      if (parsedWeight == null) return;
      _stream?.first.then((planExercises) {
        if (!mounted) return;
        final matches = _rpms!.where(
          (rpm) => rpm.name == planExercises[_selected].exercise.name,
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

  void _focusAndSelect(FocusNode focusNode, TextEditingController controller) {
    focusNode.requestFocus();
    selectAll(controller);
  }

  @override
  @override
  void dispose() {
    final workout = _workout;
    if (workout != null) {
      unawaited(finishWorkout(db, workout.id));
    }

    _reps.dispose();
    _weight.dispose();
    _distance.dispose();
    _minutes.dispose();
    _incline.dispose();
    _notes.dispose();
    _seconds.dispose();
    _repsFocus.dispose();
    _weightFocus.dispose();
    _minutesFocus.dispose();
    _secondsFocus.dispose();
    _distanceFocus.dispose();
    _inclineFocus.dispose();
    _notesFocus.dispose();

    WidgetsBinding.instance.removeObserver(this);
    dbVersion.removeListener(_reloadDatabaseStreams);
    _planSub?.cancel();

    super.dispose();
  }

  Future<GymSet?> getLast(String exercise) {
    return getLatestPerformedSet(db, exerciseName: exercise);
  }

  /// Returns the first set from the most recent training session for [exercise].
  ///
  /// "Most recent session" = the calendar day of the latest recorded set.
  /// Showing the first set (rather than the last) gives a better baseline for
  /// progressive overload when weights decrease across sets.
  Future<GymSet?> getFirstOfLastSession(int exerciseId) =>
      getStartPlanPrefillById(
        db,
        exerciseId: exerciseId,
        planId: widget.plan.id,
      );

  Future<Exercise?> getExerciseTemplate(PlanExerciseEntry entry) async =>
      entry.exercise;

  Future<void> _initializeWorkout() async {
    final workout = await resumeOrStartWorkout(db, widget.plan.id);
    if (!mounted) return;
    setState(() {
      _workout = workout;
      _gymCountsStream = watchGymCounts(widget.plan.id, workout.id);
    });
    _bindPlanStream();
    await _loadExercises();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    dbVersion.addListener(_reloadDatabaseStreams);

    _titleFromDays = widget.plan.title?.isNotEmpty != true;
    _title = _titleFromDays ? widget.plan.days : widget.plan.title!;

    unawaited(_initializeWorkout());
  }

  void _reloadDatabaseStreams() {
    if (!mounted || _workout == null) return;
    _bindPlanStream();
    unawaited(_loadExercises());
  }

  void _bindPlanStream() {
    _planSub?.cancel();
    _planSub = watchPlan(widget.plan.id).listen((plan) {
      if (!mounted) return;
      if (plan == null) {
        Navigator.of(context).maybePop();
        return;
      }
      setState(() {
        _titleFromDays = plan.title?.isNotEmpty != true;
        _title = _titleFromDays ? plan.days : plan.title!;
      });
    });
  }

  String _displayTitle(BuildContext context) {
    if (!_titleFromDays) return _title;
    return _title
        .split(',')
        .where((day) => day.trim().isNotEmpty)
        .map((day) => localizedWeekday(context.l10n, day.trim()))
        .join(', ');
  }

  Future<void> _loadExercises() async {
    if (_workout == null || !mounted) return;
    final stream = watchPlanExerciseEntries(db, widget.plan.id).asyncMap((
      exercises,
    ) async {
      await _selectFromEntries(exercises, _selected);
      return exercises;
    });
    setState(() {
      _stream = stream;
      _gymCountsStream = watchGymCounts(widget.plan.id, _workout!.id);
    });

    final settings = context.read<SettingsState>().value;
    if (settings.repEstimation) {
      getRpms().then((value) {
        if (!mounted) return;
        setState(() => _rpms = value);
      });
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

  Future<void> save(
    AsyncSnapshot<List<PlanExerciseEntry>> snapshot,
    List<GymCount> counts,
  ) async {
    if (!_key.currentState!.validate()) return;
    if (snapshot.data == null || snapshot.data!.isEmpty) return;
    if (_selected >= snapshot.data!.length) return;
    final workout = _workout;
    if (workout == null || !mounted) return;

    final entry = snapshot.data![_selected];
    final exerciseId = entry.exercise.id;
    final exercise = entry.exercise.name;
    double? bodyWeight;
    double? bodyWeightKg;
    final settings = context.read<SettingsState>().value;
    final timerState = context.read<TimerState>();
    if (settings.showBodyWeight) {
      final weightEntry = await getBodyWeight();
      if (weightEntry != null) {
        bodyWeightKg = weightEntry.weightKg;
        bodyWeight = displayBodyWeight(_unit, weightEntry.weightKg);
      }
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
    final index = counts.indexWhere(
      (element) => element.exerciseId == exerciseId,
    );

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

    final created = DateTime.now().toLocal();
    final gymSetDraft = GymSet(
      id: 0,
      bodyWeight: bodyWeight ?? 0,
      cardio: _cardio,
      category: _category,
      created: created,
      distance: parseDisplayNumber(context, _distance.text) ?? 0,
      duration:
          (int.tryParse(_seconds.text) ?? 0) / 60 +
          (int.tryParse(_minutes.text) ?? 0),
      image: _image,
      incline: int.tryParse(_incline.text),
      name: exercise,
      notes: _notes.text,
      planId: widget.plan.id,
      reps: parseDisplayNumber(context, _reps.text) ?? 0,
      restMs: restMs?.toInt(),
      unit: _unit,
      weight: parseDisplayNumber(context, _weight.text) ?? 0,
    );

    var count = 0;
    if (index != -1) count = counts[index].count;
    count++;

    restMs ??= settings.timerDuration.toDouble();

    if (settings.restTimers && count > warmupSets && peTimers) {
      timerState.startTimer(
        "$exercise ($count/${max ?? settings.maxSets})",
        Duration(milliseconds: restMs.toInt()),
        settings.alarmSound,
        settings.vibrate,
        settings.enableSound,
        "plan:${widget.plan.id}",
      );
    }

    final finishedExercise =
        count == (max ?? settings.maxSets) &&
        _selected < snapshot.data!.length - 1;

    final gymSet = await insertPerformedSet(
      db,
      gymSet: gymSetDraft,
      exerciseId: exerciseId,
      workoutId: workout.id,
      bodyWeightKg: bodyWeightKg,
    );
    if (!mounted) return;
    final messages = positiveReinforcementMessages(context.l10n);
    setState(() {
      _updateGymSetTextFields(gymSet);
      _lastSaved = DateTime.now();
    });
    if (finishedExercise) await select(_selected + 1);

    if (!settings.notifications) return;

    final best = await isBestPerformedSet(db, gymSet);
    if (!best) return;
    final random = Random();
    final randomMessage = messages[random.nextInt(messages.length)];
    if (mounted && random.nextDouble() < 0.3) toast(randomMessage);
  }

  Future<void> _selectFromEntries(
    List<PlanExerciseEntry> exercises,
    int index,
  ) async {
    if (!mounted) return;

    if (exercises.isEmpty) {
      setState(() {
        _selected = 0;
        _clearGymSetTextFields();
      });
      return;
    }

    final selected = index.clamp(0, exercises.length - 1);
    final entry = exercises[selected];
    final exercise = entry.exercise;
    final last = await getFirstOfLastSession(exercise.id);
    final template = last == null ? await getExerciseTemplate(entry) : null;
    final templateCategory = template == null
        ? null
        : await getExerciseCategoryName(template);
    if (!mounted) return;

    setState(() {
      _selected = selected;
      if (last != null) {
        _updateGymSetTextFields(last);
      } else if (template != null) {
        _clearGymSetTextFields();
        _cardio = template.kind == 'cardio';
        _unit = template.displayUnit;
        _category = templateCategory;
        _image = template.image;
      } else {
        _clearGymSetTextFields();
      }
    });
  }

  Future<void> select(int index) async {
    final exercises = await getPlanExerciseEntries(db, widget.plan.id);
    await _selectFromEntries(exercises, index);
  }

  void _clearGymSetTextFields() {
    final settings = context.read<SettingsState>().value;
    _unit = settings.strengthUnit == 'last-entry'
        ? 'kg'
        : settings.strengthUnit;
    _reps.text = '0';
    _weight.text = '0';
    _distance.text = '0';
    _minutes.text = '0';
    _seconds.text = '0';
    _incline.text = '';
    _cardio = false;
    _category = null;
    _image = null;
    _notes.text = '';
  }

  void useBodyWeight() async {
    final weightSet = await getBodyWeight();
    if (!mounted) return;
    if (weightSet == null) {
      toast(context.l10n.noWeightEnteredYet);
      return;
    }
    _weight.text = toString(displayBodyWeight(_unit, weightSet.weightKg));
  }
}
