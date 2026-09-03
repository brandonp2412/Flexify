import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:flexify/animated_fab.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/day_selector.dart';
import 'package:flexify/graph/add_exercise_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/logging.dart';
import 'package:flexify/plan/exercise_tile.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditPlanPage extends StatefulWidget {
  final PlansCompanion plan;

  const EditPlanPage({required this.plan, super.key});

  @override
  createState() => _EditPlanPageState();
}

class _EditPlanPageState extends State<EditPlanPage> {
  late List<bool> _days;
  late var _exercises = context.read<PlanState>().exercises;

  String _search = '';

  final _node = FocusNode();
  final _searchCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();

  Future<void> addExercise() async {
    GymSetsCompanion? gymSet = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddExercisePage(name: _search)),
    );
    if (gymSet == null || !mounted) return;

    final state = context.read<PlanState>();
    state.addExercise(gymSet);
    setState(() {
      _exercises = state.exercises;
      _search = '';
    });
    _searchCtrl.text = '';
  }

  Iterable<Widget> get tiles {
    final match = _exercises.where(
      (pe) => pe.exercise.value.toLowerCase().contains(_search.toLowerCase()),
    );

    if (match.isEmpty)
      return [const ListTile(title: Text("No exercises found"))];

    return match.toList().map(
      (pe) => ExerciseTile(
        planExercise: pe,
        onChange: (value) {
          final id = _exercises.indexWhere(
            (exercise) => exercise.exercise == pe.exercise,
          );
          if (id == -1) return;
          setState(() {
            _exercises[id] = value;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _exercises = context.select<PlanState, List<PlanExercisesCompanion>>(
      (value) => value.exercises,
    );

    var title = widget.plan.days.value.replaceAll(",", ", ");
    if (title.isNotEmpty)
      title = title[0].toUpperCase() + title.substring(1).toLowerCase();
    else
      title = "Add plan";

    final desktop = isDesktopLayout(context);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (desktop)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: FilledButton.icon(
                onPressed: save,
                icon: const Icon(Icons.save_rounded),
                label: const Text('Save plan'),
              ),
            ),
        ],
      ),
      body: ResponsiveContent(
        maxWidth: 1040,
        desktopPadding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
        mobilePadding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            if (desktop)
              Text(
                'Plan details',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            if (desktop) const SizedBox(height: 12),
            Container(
              padding: desktop ? const EdgeInsets.all(20) : EdgeInsets.zero,
              decoration: desktop
                  ? BoxDecoration(
                      color: colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(20),
                    )
                  : null,
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Title (optional)',
                    ),
                    controller: _titleCtrl,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),
                  DaySelector(daySwitches: _days),
                ],
              ),
            ),
            SizedBox(height: desktop ? 24 : 8),
            if (desktop)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Exercises',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            SearchBar(
              controller: _searchCtrl,
              leading: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.search),
              ),
              textCapitalization: TextCapitalization.sentences,
              hintText: 'Search exercises...',
              onChanged: (value) => setState(() {
                _search = value;
              }),
            ),
            const SizedBox(height: 10),
            Material(
              color: desktop ? colors.surfaceContainerLow : Colors.transparent,
              borderRadius: desktop ? BorderRadius.circular(14) : null,
              child: ListTile(
                leading: const Icon(Icons.add_rounded),
                title: Text(
                  _search.isEmpty ? 'Add exercise' : 'Add "$_search"',
                ),
                trailing: desktop
                    ? const Icon(Icons.chevron_right_rounded)
                    : null,
                onTap: addExercise,
              ),
            ),
            const SizedBox(height: 6),
            ...List.generate(tiles.length, (index) => tiles.elementAt(index)),
            SizedBox(height: desktop ? 40 : 176),
          ],
        ),
      ),
      floatingActionButton: desktop
          ? null
          : AnimatedFab(
              onPressed: save,
              label: const Text("Save"),
              icon: const Icon(Icons.save),
            ),
    );
  }

  @override
  void dispose() {
    _node.dispose();
    _searchCtrl.dispose();
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _titleCtrl.text = widget.plan.title.value ?? "";
    final list = widget.plan.days.value.split(',');
    _days = weekdays.map((day) => list.contains(day)).toList();
  }

  Future<void> save() async {
    final selected = [];
    for (int i = 0; i < _days.length; i++)
      if (_days[i]) selected.add(weekdays[i]);

    if (selected.isEmpty && _titleCtrl.text.isEmpty)
      return toast('Select days');

    if (_exercises.where((exercise) => exercise.enabled.value).isEmpty)
      return toast('Select exercises');

    var newPlan = PlansCompanion.insert(
      days: selected.join(','),
      title: Value(_titleCtrl.text),
    );

    if (widget.plan.id.present) {
      await db.update(db.plans).replace(newPlan.copyWith(id: widget.plan.id));
      await db.planExercises.deleteWhere(
        (tbl) => tbl.planId.equals(widget.plan.id.value),
      );
      await db.planExercises.insertAll(
        _exercises.map((pe) => pe.copyWith(planId: widget.plan.id)),
      );
    } else {
      final id = await db.into(db.plans).insert(newPlan);
      await db.planExercises.insertAll(
        _exercises
            .where((element) => element.enabled.value)
            .map((pe) => pe.copyWith(planId: Value(id))),
      );
    }

    talker.info(
      widget.plan.id.present ? 'Updated workout plan' : 'Created workout plan',
    );

    if (!mounted) return;
    final state = context.read<PlanState>();
    state.updatePlans(null);
    Navigator.pop(context);
  }
}
