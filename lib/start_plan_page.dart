import 'package:drift/drift.dart' as drift;
import 'package:flexify/database.dart';
import 'package:flexify/exercise_list.dart';
import 'package:flexify/main.dart';
import 'package:flexify/permissions_page.dart';
import 'package:flexify/plan_state.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/timer_state.dart';
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
  late TextEditingController _repsController;
  late TextEditingController _weightController;
  late List<String> _planExercises;
  late Stream<List<drift.TypedResult>> _countStream;

  PlanState? _planState;
  bool _first = true;
  String _unit = 'kg';
  int _selectedIndex = 0;

  final _repsNode = FocusNode();
  final _weightNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _repsController = TextEditingController(text: "0.0");
    _weightController = TextEditingController(text: "0.0");
    _planExercises = widget.plan.exercises.split(',');

    final planState = context.read<PlanState>();
    planState.addListener(_planChanged);
    _planState = planState;
    _select(0);

    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    final startOfTomorrow = startOfToday.add(const Duration(days: 1));
    _countStream = (db.selectOnly(db.gymSets)
          ..addColumns([
            db.gymSets.name.count(),
            db.gymSets.name,
          ])
          ..where(db.gymSets.created.isBiggerOrEqualValue(startOfToday))
          ..where(db.gymSets.created.isSmallerThanValue(startOfTomorrow))
          ..where(db.gymSets.name.isIn(_planExercises))
          ..where(db.gymSets.hidden.equals(false))
          ..groupBy([db.gymSets.name]))
        .watch();
  }

  @override
  void dispose() {
    _repsController.dispose();
    _weightController.dispose();
    _repsNode.dispose();
    _weightNode.dispose();
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

  void _selectWeight() {
    _weightController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _weightController.text.length,
    );
  }

  Future<void> _select(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    final exercise = _planExercises.elementAt(index);
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
      _repsController.text = last != null ? last.reps.toString() : "0.0";
      _weightController.text = last != null ? last.weight.toString() : "0.0";
    });
  }

  Future<void> _save(TimerState timerState, SettingsState settings) async {
    setState(() {
      _first = false;
    });
    final reps = double.parse(_repsController.text);
    final weight = double.parse(_weightController.text);
    final exercise = _planExercises[_selectedIndex];
    final weightSet = await getBodyWeight();

    final gymSet = GymSetsCompanion.insert(
      name: exercise,
      reps: reps,
      weight: weight,
      unit: _unit,
      created: DateTime.now(),
      bodyWeight: drift.Value(weightSet?.weight ?? 0.0),
    );

    if (!settings.explainedPermissions && settings.restTimers && mounted)
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PermissionsPage(),
          ));

    if (settings.restTimers) {
      final counts = await _countStream.first;
      final countIndex = counts
          .indexWhere((element) => element.read(db.gymSets.name)! == exercise);
      var count = 0;
      if (countIndex != -1)
        count = counts[countIndex].read(db.gymSets.name.count())!;
      count++;
      timerState.startTimer("$exercise ($count)", settings.timerDuration);
    }

    db.into(db.gymSets).insert(gymSet);
  }

  @override
  Widget build(BuildContext context) {
    var title = widget.plan.days.replaceAll(",", ", ");
    if (widget.plan.title?.isNotEmpty == true) title = widget.plan.title!;
    title = title[0].toUpperCase() + title.substring(1).toLowerCase();

    final timerState = context.read<TimerState>();
    final settings = context.watch<SettingsState>();

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
              controller: _repsController,
              focusNode: _repsNode,
              decoration: const InputDecoration(labelText: 'Reps'),
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                _weightNode.requestFocus();
                _weightController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _weightController.text.length,
                );
              },
              onTap: () {
                _repsController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _repsController.text.length,
                );
              },
            ),
            TextField(
              controller: _weightController,
              focusNode: _weightNode,
              decoration: InputDecoration(
                  labelText: 'Weight ($_unit)',
                  suffixIcon: IconButton(
                    tooltip: "Use body weight",
                    icon: const Icon(Icons.scale),
                    onPressed: () async {
                      final weightSet = await getBodyWeight();
                      if (weightSet == null && context.mounted)
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('No weight entered yet.')));
                      else
                        _weightController.text = weightSet!.weight.toString();
                    },
                  )),
              keyboardType: TextInputType.number,
              onTap: () {
                _selectWeight();
              },
              onSubmitted: (value) async => await _save(timerState, settings),
            ),
            Visibility(
              visible: settings.showUnits,
              child: DropdownButtonFormField<String>(
                value: _unit,
                decoration: const InputDecoration(labelText: 'Unit'),
                items: ['kg', 'lb'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _unit = newValue!;
                  });
                },
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: _countStream,
                builder: (context, snapshot) {
                  Map<String, int> counts = {};
                  for (final row in snapshot.data ?? []) {
                    counts[row.read(db.gymSets.name)!] =
                        row.read(db.gymSets.name.count())!;
                  }

                  return ExerciseList(
                    planExercises: _planExercises,
                    counts: counts,
                    selectedIndex: _selectedIndex,
                    selectAllReps: _select,
                    onReorder: (oldIndex, newIndex) async {
                      if (oldIndex < newIndex) {
                        newIndex--;
                      }

                      final temp = _planExercises[oldIndex];
                      _planExercises.removeAt(oldIndex);
                      _planExercises.insert(newIndex, temp);
                      await db.update(db.plans).replace(widget.plan
                          .copyWith(exercises: _planExercises.join(',')));
                      widget.refresh();
                    },
                    first: _first,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await _save(timerState, settings),
        tooltip: "Save this set",
        child: const Icon(Icons.save),
      ),
    );
  }
}
