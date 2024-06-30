import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/add_exercise_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';

class EditPlanPage extends StatefulWidget {
  final PlansCompanion plan;

  const EditPlanPage({required this.plan, super.key});

  @override
  createState() => _EditPlanPageState();
}

class _EditPlanPageState extends State<EditPlanPage> {
  late List<bool> _daySwitches;
  late List<String> _exerciseSelections;

  bool _showSearch = false;
  String _search = '';
  List<String> _exercises = [];
  List<TextEditingController> _controllers = [];

  final _searchNode = FocusNode();
  final _searchController = TextEditingController();
  final _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _setExercises();
    _titleController.text = widget.plan.title.value ?? "";

    final dayList = widget.plan.days.value.split(',');
    _daySwitches = weekdays.map((day) => dayList.contains(day)).toList();

    if (widget.plan.exercises.value.isEmpty)
      _exerciseSelections = [];
    else {
      final splitExercises = widget.plan.exercises.value.split(',');
      _exerciseSelections = splitExercises;
    }
  }

  void _setExercises() {
    (db.gymSets.selectOnly()
          ..addColumns([db.gymSets.name, db.planExercises.maxSets])
          ..join([
            leftOuterJoin(
              db.planExercises,
              db.planExercises.planId.equals(widget.plan.id.value) &
                  db.planExercises.exercise.equalsExp(db.gymSets.name),
            ),
          ])
          ..groupBy([db.gymSets.name]))
        .get()
        .then(
          (results) => setState(() {
            _exercises = [];
            _controllers = [];

            for (final result in results) {
              _exercises.add(result.read(db.gymSets.name)!);
              _controllers.add(
                TextEditingController(
                  text: result.read(db.planExercises.maxSets)?.toString(),
                ),
              );
            }
          }),
        );
  }

  @override
  void dispose() {
    _searchNode.dispose();
    _searchController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) _search = '';
    });
    _searchNode.requestFocus();
    _searchController.clear();
  }

  Future<void> _save() async {
    final days = [];
    for (int i = 0; i < _daySwitches.length; i++) {
      if (_daySwitches[i]) days.add(weekdays[i]);
    }
    if (days.isEmpty && _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select days/title first')),
      );
      return;
    }

    if (_exerciseSelections.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select exercises first')),
      );
      return;
    }

    var newPlan = PlansCompanion.insert(
      days: days.join(','),
      exercises:
          _exerciseSelections.where((element) => element.isNotEmpty).join(','),
      title: Value(_titleController.text),
    );

    int? id;
    if (widget.plan.id.value != -1) {
      await db.update(db.plans).replace(newPlan.copyWith(id: widget.plan.id));
      await db.planExercises
          .deleteWhere((tbl) => tbl.planId.equals(widget.plan.id.value));
      id = widget.plan.id.value;
    } else {
      id = await db.into(db.plans).insert(newPlan);
      newPlan = newPlan.copyWith(id: Value(id));
    }

    List<PlanExercisesCompanion> planExercises = [];
    for (var i = 0; i < _exercises.length; i++) {
      planExercises.add(
        PlanExercisesCompanion.insert(
          planId: id,
          exercise: _exercises[i],
          enabled: _exerciseSelections.contains(_exercises[i]),
          maxSets: Value(int.tryParse(_controllers[i].text)),
        ),
      );
    }

    await db.planExercises.insertAll(planExercises);

    if (!mounted) return;
    Navigator.pop(context);
  }

  Iterable<Widget> get tiles => _exercises
      .where(
        (exercise) => exercise.toLowerCase().contains(_search.toLowerCase()),
      )
      .toList()
      .asMap()
      .entries
      .map(
        (entry) => material.Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: material.Row(
            children: [
              SizedBox(
                width: 64,
                child: TextField(
                  controller: _controllers[entry.key],
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                  onTap: () => selectAll(_controllers[entry.key]),
                  onChanged: (value) {
                    if (value.isNotEmpty &&
                        !_exerciseSelections.contains(entry.value))
                      setState(() {
                        _exerciseSelections.add(entry.value);
                      });
                  },
                  decoration: const InputDecoration(
                    labelText: "Sets",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_exerciseSelections.contains(entry.value))
                        _exerciseSelections.remove(entry.value);
                      else
                        _exerciseSelections.add(entry.value);
                    });
                  },
                  child: Text(
                    entry.value,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              Switch(
                value: _exerciseSelections.contains(entry.value),
                onChanged: (value) {
                  setState(() {
                    if (_exerciseSelections.contains(entry.value))
                      _exerciseSelections.remove(entry.value);
                    else
                      _exerciseSelections.add(entry.value);
                  });
                },
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];

    if (_search == '')
      actions.add(
        IconButton(
          onPressed: _toggleSearch,
          icon: const Icon(Icons.search),
          tooltip: "Search",
        ),
      );
    else
      actions.add(
        IconButton(
          onPressed: () {
            _searchController.clear();
            _searchNode.unfocus();
            setState(() {
              _search = '';
              _showSearch = false;
            });
          },
          icon: const Icon(Icons.clear),
        ),
      );

    var title = widget.plan.days.value.replaceAll(",", ", ");
    if (title.isNotEmpty)
      title = title[0].toUpperCase() + title.substring(1).toLowerCase();
    else
      title = "Add plan";

    return Scaffold(
      appBar: AppBar(
        title: _showSearch
            ? TextField(
                focusNode: _searchNode,
                controller: _searchController,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) => setState(() {
                  _search = value;
                }),
                decoration: const InputDecoration(
                  hintText: "Search...",
                  border: InputBorder.none,
                ),
              )
            : Text(title),
        actions: actions,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            if (_search == '') ...[
              TextField(
                decoration: const material.InputDecoration(
                  labelText: 'Title (optional)',
                ),
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Text('Days', style: Theme.of(context).textTheme.headlineSmall),
              ...List.generate(
                7,
                (index) => SwitchListTile(
                  title: Text(weekdays[index]),
                  value: _daySwitches[index],
                  onChanged: (value) {
                    setState(() {
                      _daySwitches[index] = value;
                    });
                  },
                ),
              ),
            ],
            material.Row(
              children: [
                Text(
                  'Exercises',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      material.MaterialPageRoute(
                        builder: (context) => const AddExercisePage(),
                      ),
                    );
                    _setExercises();
                  },
                  tooltip: 'Add exercise',
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...List.generate(tiles.length, (index) => tiles.elementAt(index)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _save,
        tooltip: "Save",
        child: const Icon(Icons.save),
      ),
    );
  }
}
