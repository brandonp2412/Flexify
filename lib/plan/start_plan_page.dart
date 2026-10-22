import 'dart:async';
import 'dart:math';

import 'package:flexify/app_fab.dart';
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/body_weight_repository.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/empty_state.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/permissions_page.dart';
import 'package:flexify/plan/edit_plan_page.dart';
import 'package:flexify/plan/plan_queries.dart';
import 'package:flexify/plan/session_sets.dart';
import 'package:flexify/plan/start_list.dart';
import 'package:flexify/plan/start_plan_data.dart';
import 'package:flexify/plan/workout_sessions.dart';
import 'package:flexify/platform_page_route.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/stepper_field.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartPlanPage extends StatefulWidget {
  final Plan plan;
  final List<PlanExerciseEntry>? initial;

  const StartPlanPage({super.key, required this.plan, this.initial});

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

  int? _selectedExerciseId;
  bool _saving = false;
  DateTime? _lastSavedAt;
  String _unit = 'kg';
  StartPlanData? _data;
  late Stream<StartPlanData> _stream;

  int get _selected {
    final exercises =
        _data?.exercises ?? widget.initial ?? const <PlanExerciseEntry>[];
    final index = exercises.indexWhere(
      (entry) => entry.exercise.id == _selectedExerciseId,
    );
    return index < 0 ? 0 : index;
  }

  Exercise? get _currentExercise =>
      _data?.exercises.elementAtOrNull(_selected)?.exercise ??
      widget.initial?.firstOrNull?.exercise;
  bool get _cardio => _currentExercise?.kind == 'cardio';
  String? get _image => _currentExercise?.image;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StartPlanData>(
      stream: _stream,
      builder: (context, snapshot) {
        final data = snapshot.data;
        final exercises = data?.exercises ?? widget.initial;
        final workout = data?.workout;
        if (exercises == null || snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_displayTitle(context)),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: snapshot.hasError
                  ? AppEmptyState(
                      icon: Icons.error_outline,
                      title: context.l10n.errorLabel,
                      message: snapshot.error.toString(),
                    )
                  : const CircularProgressIndicator(),
            ),
          );
        }

        final counts = <GymCount>[
          for (final entry in exercises)
            (
              exerciseId: entry.exercise.id,
              count: data?.sets[entry.exercise.id]?.length ?? 0,
              name: entry.exercise.name,
              maxSets: entry.planExercise.maxSets,
              restMs: entry.exercise.defaultRestDurationMs,
              warmupSets: entry.planExercise.warmupSets,
              timers: entry.planExercise.timers,
            ),
        ];
        final desktop = isDesktopLayout(context);
        final colors = Theme.of(context).colorScheme;

        Future<void> editPlan() async {
          final plan = data?.plan ?? widget.plan;
          if (!context.mounted) return;
          await Navigator.of(context).push(
            FlexPageRoute(
              builder: (context) => EditPlanPage(plan: plan.toCompanion(false)),
            ),
          );
          if (!mounted) return;
        }

        Widget exerciseList() => exercises.isEmpty
            ? AppEmptyState(
                icon: Icons.fitness_center_rounded,
                title: context.l10n.noExercisesYet,
                message: context.l10n.addExerciseToPlan,
                actionLabel: context.l10n.editPlan,
                actionIcon: Icons.edit_rounded,
                onAction: editPlan,
              )
            : StartList(
                exercises: exercises,
                selected: _selected,
                onSelect: (index) async => _select(index),
                counts: counts,
                plan: widget.plan,
                workoutId: workout?.id,
              );

        return Scaffold(
          floatingActionButtonAnimator:
              FloatingActionButtonAnimator.noAnimation,
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
              if (desktop && exercises.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: FilledButton.icon(
                    onPressed: () async => await _save(),
                    icon: const Icon(Icons.save_rounded),
                    label: Text(context.l10n.saveSet),
                  ),
                ),
            ],
          ),
          body: ResponsiveContent(
            maxWidth: wideMaxWidth,
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
                                    exercises.isNotEmpty &&
                                            _selected < exercises.length
                                        ? exercises[_selected].exercise.name
                                        : context.l10n.setDetails,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 16),
                                  if (!_cardio) ...strengthFields(),
                                  if (_cardio) ...cardioFields(),
                                  unitSelector(),
                                  notesField(),
                                  if (workout != null &&
                                      exercises.isNotEmpty &&
                                      _selected < exercises.length) ...[
                                    const SizedBox(height: 16),
                                    SessionSets(
                                      exerciseId:
                                          exercises[_selected].exercise.id,
                                      workoutId: workout.id,
                                      previous:
                                          data?.previous[exercises[_selected]
                                              .exercise
                                              .id],
                                      onPreviousSetTap: _fillPreviousSet,
                                      sets:
                                          data?.sets[_currentExercise?.id] ??
                                          const [],
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
                            clipBehavior: Clip.none,
                            child: exerciseList(),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        if (!_cardio) ...strengthFields(),
                        if (_cardio) ...cardioFields(),
                        unitSelector(),
                        notesField(),
                        Expanded(child: exerciseList()),
                      ],
                    ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton:
              desktop ||
                  workout == null ||
                  exercises.isEmpty ||
                  _selected >= exercises.length
              ? null
              : Padding(
                  key: const Key('start-plan-floating-row'),
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: max(
                      0,
                      bottomNavHeight - MediaQuery.viewInsetsOf(context).bottom,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: OverflowBox(
                            alignment: Alignment.center,
                            minHeight: 0,
                            maxHeight: double.infinity,
                            child: SessionSets(
                              key: const Key('start-plan-set-preview'),
                              exerciseId: exercises[_selected].exercise.id,
                              workoutId: workout.id,
                              previous: data
                                  ?.previous[exercises[_selected].exercise.id],
                              onPreviousSetTap: _fillPreviousSet,
                              sets:
                                  data?.sets[_currentExercise?.id] ?? const [],
                              compact: true,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AppFab(
                        onPressed: () async => await _save(),
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
  }

  List<Widget> strengthFields() {
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
      _weightField(),
    ];
  }

  List<Widget> cardioFields() {
    final showNotes = context.read<Setting>().showNotes;

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
            Expanded(child: _weightField())
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
                  await _save();
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

  StepperField _weightField() {
    final exerciseName = _currentExercise?.name ?? '';
    final showNotes = context.read<Setting>().showNotes;
    final hasNextField = _cardio || showNotes;

    return StepperField(
      controller: _weight,
      focusNode: _weightFocus,
      labelText: context.l10n.weightWithUnit(_unit),
      step: weightStep(exerciseName, _unit),
      suffixIcon: Selector<Setting, bool>(
        selector: (context, settings) => settings.showBodyWeight,
        builder: (context, showBodyWeight, child) => Visibility(
          visible: showBodyWeight,
          child: IconButton(
            tooltip: context.l10n.useBodyWeight,
            icon: const Icon(Icons.scale),
            onPressed: useBodyWeight,
          ),
        ),
      ),
      textInputAction: hasNextField
          ? TextInputAction.next
          : TextInputAction.done,
      onFieldSubmitted: (_) async {
        if (_cardio) {
          _focusAndSelect(_inclineFocus, _incline);
        } else if (showNotes) {
          _focusAndSelect(_notesFocus, _notes);
        } else {
          await _save();
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
    return Selector<Setting, bool>(
      selector: (context, settings) => settings.showUnits,
      builder: (context, showUnits, child) => Visibility(
        visible: showUnits,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(labelText: context.l10n.unitLabel),
              key: ValueKey(_unit),
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
    return Selector<Setting, bool>(
      selector: (context, settings) => settings.showNotes,
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
              onFieldSubmitted: (_) async => await _save(),
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
    if (!mounted || _lastSavedAt == null) return;

    final settings = context.read<Setting>();
    final difference = DateTime.now().difference(_lastSavedAt!);

    if (_cardio && settings.durationEstimation) {
      _minutes.text = difference.inMinutes.toString();
      _seconds.text = (difference.inSeconds % 60).toString();
    }
  }

  void _focusAndSelect(FocusNode focusNode, TextEditingController controller) {
    focusNode.requestFocus();
    selectAll(controller);
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
    _repsFocus.dispose();
    _weightFocus.dispose();
    _minutesFocus.dispose();
    _secondsFocus.dispose();
    _distanceFocus.dispose();
    _inclineFocus.dispose();
    _notesFocus.dispose();

    WidgetsBinding.instance.removeObserver(this);
    dbVersion.removeListener(_reloadDatabaseStreams);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    dbVersion.addListener(_reloadDatabaseStreams);
    _stream = _watchData();
    final initial = widget.initial;
    if (initial != null && initial.isNotEmpty)
      _unit = initial.first.exercise.displayUnit;
  }

  Stream<StartPlanData> _watchData() =>
      watchStartPlanData(db, widget.plan.id).map((data) {
        if (!mounted) return data;
        _data = data;
        if (data.plan == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) Navigator.of(context).maybePop();
          });
        }
        final index = data.exercises.indexWhere(
          (entry) => entry.exercise.id == _selectedExerciseId,
        );
        _select(index < 0 ? _selected : index, rebuild: false);
        return data;
      });

  void _reloadDatabaseStreams() {
    if (mounted) setState(() => _stream = _watchData());
  }

  String _displayTitle(BuildContext context) {
    final plan = _data?.plan ?? widget.plan;
    if (plan.title?.isNotEmpty == true) return plan.title!;
    return plan.days
        .split(',')
        .where((day) => day.trim().isNotEmpty)
        .map((day) => localizedWeekday(context.l10n, day.trim()))
        .join(', ');
  }

  void _fillPreviousSet(PreviousExerciseSet previous) {
    setState(() {
      _unit = previous.unit;
      _reps.text = toString(previous.reps);
      _weight.text = toString(previous.weight);
      _distance.text = toString(previous.distance);
      _minutes.text = previous.duration.floor().toString();
      _seconds.text = ((previous.duration * 60) % 60).floor().toString();
      _incline.text = previous.incline?.toString() ?? '0';
    });
  }

  void _update(ExerciseSetView exerciseSet) {
    final settings = context.read<Setting>();
    if (settings.strengthUnit == 'last-entry' && !exerciseSet.cardio ||
        settings.cardioUnit == 'last-entry' && exerciseSet.cardio)
      _unit = exerciseSet.unit;
    else if (exerciseSet.cardio)
      _unit = settings.cardioUnit;
    else
      _unit = settings.strengthUnit;

    _reps.text = toString(exerciseSet.reps);
    _weight.text = toString(exerciseSet.weight);
    _distance.text = toString(exerciseSet.distance);
    _minutes.text = exerciseSet.duration.floor().toString();
    _seconds.text = ((exerciseSet.duration * 60) % 60).floor().toString();
    _incline.text = exerciseSet.incline?.toString() ?? "0";
    _notes.text = exerciseSet.notes ?? "";
  }

  Future<void> _save() async {
    final data = _data;
    if (data == null) return;
    final exercises = data.exercises;
    if (_saving) return;
    _saving = true;
    try {
      if (!_key.currentState!.validate()) return;
      if (exercises.isEmpty) return;
      if (_selected >= exercises.length) return;

      final workout = _data?.workout;
      if (workout == null) return;
      if (!mounted) return;

      final entry = exercises[_selected];
      final exerciseId = entry.exercise.id;
      final exercise = entry.exercise.name;
      double? bodyWeight;
      double? bodyWeightKg;
      final settings = context.read<Setting>();
      final timerState = context.read<TimerState>();
      if (settings.showBodyWeight) {
        final weightEntry = await getLatestBodyWeight(db);
        if (weightEntry != null) {
          bodyWeightKg = weightEntry.weightKg;
          bodyWeight = displayBodyWeight(_unit, weightEntry.weightKg);
        }
      }
      if (settings.showBodyWeight && bodyWeight == null) {
        final lastSet = await getLatestExerciseSet(db, exerciseName: exercise);
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
        ).push(FlexPageRoute(builder: (context) => const PermissionsPage()));
      }

      if (!mounted) return;
      final max = entry.planExercise.maxSets;
      double? restMs = entry.exercise.defaultRestDurationMs?.toDouble();
      final warmupSets = entry.planExercise.warmupSets ?? 0;
      final peTimers = entry.planExercise.timers;

      final created = DateTime.now().toLocal();
      final category = _data?.categories[exerciseId];
      if (!mounted) return;
      final draft = ExerciseSetView(
        id: 0,
        bodyWeight: bodyWeight ?? 0,
        cardio: _cardio,
        category: category,
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

      final count = (data.sets[exerciseId]?.length ?? 0) + 1;

      restMs ??= settings.timerDuration.toDouble();

      if (settings.restTimers && count > warmupSets && peTimers) {
        timerState.startTimer(
          "$exercise ($count/${max ?? settings.maxSets})",
          Duration(milliseconds: restMs.toInt()),
          settings.alarmSound,
          settings.vibrate,
          settings.enableSound,
          "plan:${widget.plan.id}",
          settings.keepRinging,
        );
      }

      final finished =
          count == (max ?? settings.maxSets) &&
          _selected < exercises.length - 1;

      final exerciseSet = await insertExerciseSet(
        db,
        exerciseSet: draft,
        exerciseId: exerciseId,
        workoutId: workout.id,
        bodyWeightKg: bodyWeightKg,
      );
      if (!mounted) return;
      final messages = positiveReinforcementMessages(context.l10n);
      setState(() {
        _update(exerciseSet);
        _lastSavedAt = DateTime.now();
      });
      if (finished) _select(_selected + 1);

      if (!settings.notifications) return;

      final best = await isBestExerciseSet(db, exerciseSet);
      if (!best) return;

      final random = Random();
      final randomMessage = messages[random.nextInt(messages.length)];
      if (mounted && random.nextDouble() < 0.3)
        messengerKey.currentState!.showSnackBar(
          SnackBar(
            content: Text(randomMessage),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            duration: const Duration(seconds: 4),
            persist: false,
          ),
        );
    } finally {
      _saving = false;
    }
  }

  void _select(int index, {bool rebuild = true}) {
    final exercises =
        _data?.exercises ?? widget.initial ?? const <PlanExerciseEntry>[];
    void select() {
      if (exercises.isEmpty) {
        _selectedExerciseId = null;
        _clear();
        return;
      }
      final selected = index.clamp(0, exercises.length - 1);
      final exercise = exercises[selected].exercise;
      if (_selectedExerciseId == exercise.id) return;
      _selectedExerciseId = exercise.id;
      final defaults = _data?.defaults[exercise.id];
      if (defaults != null) {
        _update(defaults);
      } else {
        _clear();
        _unit = exercise.displayUnit;
      }
    }

    if (rebuild) {
      setState(select);
    } else {
      select();
    }
  }

  void _clear() {
    final settings = context.read<Setting>();
    _unit = settings.strengthUnit == 'last-entry'
        ? 'kg'
        : settings.strengthUnit;
    _reps.text = '0';
    _weight.text = '0';
    _distance.text = '0';
    _minutes.text = '0';
    _seconds.text = '0';
    _incline.text = '0';
    _notes.text = '';
  }

  void useBodyWeight() async {
    final weightSet = await getLatestBodyWeight(db);
    if (!mounted) return;
    if (weightSet == null) {
      messengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(context.l10n.noWeightEnteredYet),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          duration: const Duration(seconds: 4),
          persist: false,
        ),
      );
      return;
    }
    _weight.text = toString(displayBodyWeight(_unit, weightSet.weightKg));
  }
}
