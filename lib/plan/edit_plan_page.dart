import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:flexify/animated_fab.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/day_selector.dart';
import 'package:flexify/empty_state.dart';
import 'package:flexify/graph/add_exercise_page.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/logging.dart';
import 'package:flexify/plan/exercise_tile.dart';
import 'package:flexify/plan/plan_queries.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';

class EditPlanPage extends StatefulWidget {
  final PlansCompanion plan;

  const EditPlanPage({required this.plan, super.key});

  @override
  createState() => _EditPlanPageState();
}

class _EditPlanPageState extends State<EditPlanPage> {
  late List<bool> _days;
  List<PlanExercisesCompanion> _exercises = [];
  bool _loadingExercises = true;

  String _search = '';

  final _node = FocusNode();
  final _searchCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();

  Future<void> addExercise() async {
    GymSetsCompanion? gymSet = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddExercisePage(name: _search)),
    );
    if (gymSet == null || !mounted) return;

    final name = gymSet.name.value;
    final category = gymSet.category.present ? gymSet.category.value : null;
    setState(() {
      final existing = _exercises.indexWhere(
        (exercise) =>
            exercise.exercise.value == name &&
            exercise.category.value == category,
      );
      if (existing >= 0) {
        _exercises[existing] = _exercises[existing].copyWith(
          enabled: const Value(true),
        );
      } else {
        _exercises.add(
          PlanExercisesCompanion(
            exercise: Value(name),
            category: Value(category),
            enabled: const Value(true),
          ),
        );
      }
      _exercises.sort((a, b) {
        if (a.enabled.value != b.enabled.value) {
          return b.enabled.value ? 1 : -1;
        }
        final byName = a.exercise.value.compareTo(b.exercise.value);
        if (byName != 0) return byName;
        return (a.category.value ?? '').compareTo(b.category.value ?? '');
      });
      _search = '';
    });
    _searchCtrl.text = '';
  }

  Iterable<Widget> get tiles {
    final search = _search.toLowerCase();
    final match = _exercises.where(
      (pe) =>
          pe.exercise.value.toLowerCase().contains(search) ||
          pe.category.value?.toLowerCase().contains(search) == true,
    );

    if (match.isEmpty)
      return [
        SizedBox(
          height: 260,
          child: AppEmptyState(
            icon: Icons.search_off_rounded,
            title: context.l10n.noExercisesFound,
            message: _search.isEmpty
                ? context.l10n.addExerciseToPlan
                : context.l10n.nothingMatchesExerciseSearch(_search),
            actionLabel: _search.isEmpty
                ? context.l10n.addExercise
                : context.l10n.addNamed(_search),
            actionIcon: Icons.add_rounded,
            onAction: addExercise,
          ),
        ),
      ];

    return match.toList().map(
      (pe) => ExerciseTile(
        planExercise: pe,
        onChange: (value) {
          final id = _exercises.indexWhere(
            (exercise) =>
                exercise.exercise == pe.exercise &&
                exercise.category == pe.category,
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
    final storedDays = widget.plan.days.value
        .split(',')
        .where((day) => day.isNotEmpty);
    final title = storedDays.isEmpty
        ? context.l10n.addPlan
        : storedDays
              .map((day) => localizedWeekday(context.l10n, day))
              .join(', ');

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
                label: Text(context.l10n.savePlan),
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
                context.l10n.planDetails,
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
                    decoration: InputDecoration(
                      labelText: context.l10n.titleOptional,
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
                  context.l10n.exercisesLabel,
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
              hintText: context.l10n.searchExercises,
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
                  _search.isEmpty
                      ? context.l10n.addExercise
                      : context.l10n.addNamed(_search),
                ),
                trailing: desktop
                    ? const Icon(Icons.chevron_right_rounded)
                    : null,
                onTap: addExercise,
              ),
            ),
            const SizedBox(height: 6),
            if (_loadingExercises)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              ...List.generate(tiles.length, (index) => tiles.elementAt(index)),
            SizedBox(height: desktop ? 40 : 176),
          ],
        ),
      ),
      floatingActionButton: desktop
          ? null
          : AnimatedFab(
              onPressed: save,
              label: Text(context.l10n.actionSave),
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
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final exercises = await loadPlanExerciseDrafts(widget.plan);
    if (!mounted) return;
    setState(() {
      _exercises = exercises;
      _loadingExercises = false;
    });
  }

  Iterable<PlanExercisesCompanion> _orderedExercises(int planId) sync* {
    var sequence = 0;
    for (final exercise in _exercises) {
      if (!exercise.enabled.value) continue;
      yield exercise.copyWith(
        planId: Value(planId),
        sequence: Value(sequence++),
      );
    }
    for (final exercise in _exercises) {
      if (exercise.enabled.value) continue;
      yield exercise.copyWith(
        planId: Value(planId),
        sequence: Value(sequence++),
      );
    }
  }

  Future<void> save() async {
    final selected = [];
    for (int i = 0; i < _days.length; i++)
      if (_days[i]) selected.add(weekdays[i]);

    if (selected.isEmpty && _titleCtrl.text.isEmpty)
      return toast(context.l10n.selectDays);

    if (_exercises.where((exercise) => exercise.enabled.value).isEmpty)
      return toast(context.l10n.selectExercises);

    var newPlan = PlansCompanion.insert(
      days: selected.join(','),
      title: Value(_titleCtrl.text),
    );

    if (widget.plan.id.present) {
      final planId = widget.plan.id.value;
      await db.update(db.plans).replace(newPlan.copyWith(id: widget.plan.id));
      await db.planExercises.deleteWhere((tbl) => tbl.planId.equals(planId));
      await db.planExercises.insertAll(_orderedExercises(planId).toList());
    } else {
      final id = await db.into(db.plans).insert(newPlan);
      await db.planExercises.insertAll(
        _orderedExercises(
          id,
        ).where((exercise) => exercise.enabled.value).toList(),
      );
    }

    talker.info(
      widget.plan.id.present ? 'Updated workout plan' : 'Created workout plan',
    );

    if (!mounted) return;
    Navigator.pop(context);
  }
}
