import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:flexify/database/database.dart';
import 'package:flexify/plan/edit_plan_page.dart';
import 'package:flexify/plan/exercise_list.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/main.dart';
import 'package:flexify/permissions_page.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flexify/unit_selector.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartPlanPage extends StatefulWidget {
  final Plan plan;
  final Future<void> Function() refresh;

  const StartPlanPage({super.key, required this.plan, required this.refresh});

  @override
  createState() => _StartPlanPageState();
}

class _StartPlanPageState extends State<StartPlanPage> {
  final _repsController = TextEditingController(text: "0.0");
  final _weightController = TextEditingController(text: "0.0");
  final _distanceController = TextEditingController(text: "0.0");
  final _durationController = TextEditingController(text: "0.0");
  final _inclineController = TextEditingController(text: "0");

  late List<String> _planExercises;
  late Stream<List<GymCount>> _countStream;
  late SettingsState _settings;

  PlanState? _planState;
  bool _first = true;
  String? _unit;
  int _selectedIndex = 0;
  bool _cardio = false;

  @override
  void initState() {
    super.initState();
    _planExercises = widget.plan.exercises.split(',');
    final planState = context.read<PlanState>();
    planState.addListener(_planChanged);
    _planState = planState;
    _select(0);
    _settings = context.read<SettingsState>();
    _countStream = watchCount(_planExercises);
  }

  @override
  void dispose() {
    _repsController.dispose();
    _weightController.dispose();
    _distanceController.dispose();
    _durationController.dispose();
    _inclineController.dispose();

    _planState?.removeListener(_planChanged);

    super.dispose();
  }

  void _planChanged() {
    final split = _planState?.plans
        .firstWhere((element) => element.id == widget.plan.id)
        .exercises
        .split(',');
    setState(() {
      if (split != null) _planExercises = split;
    });
  }

  Future<GymSet?> _getLast(String exercise) async {
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

  Future<void> _select(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    final last = await _getLast(_planExercises[index]);
    if (last == null) return;

    setState(() {
      _unit = last.unit;
      _repsController.text = toString(last.reps);
      _weightController.text = toString(last.weight);
      _distanceController.text = toString(last.distance);
      _durationController.text = toString(last.duration);
      _inclineController.text = last.incline?.toString() ?? "";
      _cardio = last.cardio;

      if (_cardio && (_unit == 'kg' || _unit == 'lb'))
        _unit = _settings.cardioUnit ?? 'km';
      else if (!_cardio && (_unit == 'km' || _unit == 'mi'))
        _unit = _settings.strengthUnit ?? 'kg';
    });
  }

  Future<void> _save(TimerState timerState) async {
    setState(() {
      _first = false;
    });
    final exercise = _planExercises[_selectedIndex];
    var bodyWeight = 0.0;
    if (!_settings.hideWeight)
      bodyWeight = (await getBodyWeight())?.weight ?? 0;

    if (platformSupportsTimer() &&
        !_settings.explainedPermissions &&
        _settings.restTimers &&
        mounted)
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PermissionsPage(),
        ),
      );

    final counts = await _countStream.first;
    final countIndex = counts.indexWhere((element) => element.name == exercise);

    int? max;
    int? restMs;
    if (countIndex != -1) {
      max = counts[countIndex].maxSets;
      restMs = counts[countIndex].restMs;
    }

    var unit = _unit;
    if (unit == null) {
      if (_cardio)
        unit = _settings.cardioUnit ?? 'km';
      else
        unit = _settings.strengthUnit ?? 'kg';
    }

    var gymSet = GymSetsCompanion.insert(
      name: exercise,
      reps: double.parse(_repsController.text),
      weight: double.parse(_weightController.text),
      unit: _unit!,
      created: DateTime.now().toLocal(),
      cardio: drift.Value(_cardio),
      duration: drift.Value(double.parse(_durationController.text)),
      distance: drift.Value(double.parse(_distanceController.text)),
      bodyWeight: drift.Value(bodyWeight),
      restMs: drift.Value(restMs),
      maxSets: drift.Value(max),
      incline: drift.Value(int.tryParse(_inclineController.text)),
    );

    if (_settings.restTimers && platformSupportsTimer()) {
      final countIndex =
          counts.indexWhere((element) => element.name == exercise);
      var count = 0;
      if (countIndex != -1) count = counts[countIndex].count;
      count++;

      final finishedPlan = count == (max ?? _settings.maxSets) &&
          _selectedIndex == _planExercises.length - 1;
      if (!finishedPlan)
        timerState.startTimer(
          "$exercise ($count)",
          restMs != null
              ? Duration(milliseconds: restMs)
              : _settings.timerDuration,
        );

      final finishedExercise = count == (max ?? _settings.maxSets) &&
          _selectedIndex < _planExercises.length - 1;
      if (finishedExercise) _select(_selectedIndex + 1);
    }

    db.into(db.gymSets).insert(gymSet);
  }

  @override
  Widget build(BuildContext context) {
    var title = widget.plan.days.replaceAll(",", ", ");
    if (widget.plan.title?.isNotEmpty == true) title = widget.plan.title!;
    title = title[0].toUpperCase() + title.substring(1).toLowerCase();

    final timerState = context.read<TimerState>();
    _settings = context.watch<SettingsState>();

    var unit = _unit;
    if (unit == null) {
      if (_cardio)
        unit = _settings.cardioUnit ?? 'km';
      else
        unit = _settings.strengthUnit ?? 'kg';
    }

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
              Navigator.pop(context);
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditPlanPage(plan: widget.plan.toCompanion(false)),
                ),
              );
              widget.refresh();
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            if (!_cardio) ...[
              TextField(
                controller: _repsController,
                decoration: const InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onSubmitted: (value) {
                  selectAll(_weightController);
                },
                onTap: () {
                  selectAll(_repsController);
                },
              ),
              TextField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'Weight ($_unit)',
                  suffixIcon: _settings.hideWeight
                      ? null
                      : IconButton(
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
                              _weightController.text =
                                  toString(weightSet!.weight);
                          },
                        ),
                ),
                keyboardType: TextInputType.number,
                onTap: () {
                  selectAll(_weightController);
                },
                onSubmitted: (value) async => await _save(timerState),
              ),
            ],
            if (_cardio) ...[
              TextField(
                controller: _durationController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Duration',
                ),
                keyboardType: TextInputType.number,
                onTap: () {
                  selectAll(_durationController);
                },
                onSubmitted: (value) {
                  selectAll(_distanceController);
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      controller: _distanceController,
                      decoration: const InputDecoration(
                        labelText: 'Distance',
                      ),
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) => selectAll(_inclineController),
                      onTap: () {
                        selectAll(_distanceController);
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: _inclineController,
                      decoration: const InputDecoration(labelText: 'Incline'),
                      keyboardType: TextInputType.number,
                      onTap: () => selectAll(_inclineController),
                      onSubmitted: (value) => _save(timerState),
                    ),
                  ),
                ],
              ),
            ],
            if (_settings.showUnits)
              UnitSelector(
                value: unit,
                cardio: _cardio,
                onChanged: (String? newValue) {
                  setState(() {
                    _unit = newValue!;
                  });
                },
              ),
            Expanded(
              child: StreamBuilder(
                stream: _countStream,
                builder: (context, snapshot) {
                  return ExerciseList(
                    exercises: _planExercises,
                    refresh: widget.refresh,
                    selected: _selectedIndex,
                    onSelect: _select,
                    counts: snapshot.data,
                    firstRender: _first,
                    plan: widget.plan,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await _save(timerState),
        tooltip: "Save",
        child: const Icon(Icons.save),
      ),
    );
  }
}
