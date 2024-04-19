import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
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
  final _searchNode = FocusNode();
  final _searchController = TextEditingController();
  final _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    (db.gymSets.selectOnly(distinct: true)..addColumns([db.gymSets.name]))
        .get()
        .then((results) => setState(() {
              _exercises =
                  results.map((e) => e.read(db.gymSets.name)!).toList();
            }));

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

  @override
  void dispose() {
    _searchNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) _search = '';
    });
    _searchNode.requestFocus();
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];

    if (_search == '')
      actions.add(
        IconButton(
          onPressed: toggleSearch,
          icon: const Icon(Icons.search),
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

    List<Widget> getChildren() {
      final List<Widget> children = [
        material.TextField(
          decoration:
              const material.InputDecoration(labelText: 'Title (optional)'),
          controller: _titleController,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(
          height: 16.0,
        )
      ];

      if (_search == '')
        children.add(
          Text('Days', style: Theme.of(context).textTheme.headlineSmall),
        );

      final days = List.generate(7, (index) {
        return SwitchListTile(
          title: Text(weekdays[index]),
          value: _daySwitches[index],
          onChanged: (value) {
            setState(() {
              _daySwitches[index] = value;
            });
          },
        );
      });

      final tiles = _exercises
          .where((exercise) =>
              exercise.toLowerCase().contains(_search.toLowerCase()))
          .toList()
          .asMap()
          .entries
          .map(
            (entry) => SwitchListTile(
              title: Text(entry.value),
              value: _exerciseSelections.contains(entry.value),
              onChanged: (value) {
                setState(() {
                  if (value)
                    _exerciseSelections.add(entry.value);
                  else
                    _exerciseSelections.remove(entry.value);
                });
              },
            ),
          );

      if (_search == '') children.addAll(days);
      children.add(
        Text('Exercises', style: Theme.of(context).textTheme.headlineSmall),
      );
      children.addAll(tiles);

      return [
        Expanded(
          child: ListView.builder(
            itemCount: children.length,
            itemBuilder: (context, index) => children[index],
          ),
        ),
      ];
    }

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
        child: material.Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getChildren(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
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

          var newPlan = widget.plan.copyWith(
            days: Value(days.join(',')),
            exercises: Value(_exerciseSelections
                .where((element) => element.isNotEmpty)
                .join(',')),
            title: Value(_titleController.text),
          );

          if (widget.plan.id.present)
            await db.update(db.plans).replace(newPlan);
          else {
            final id = await db.into(db.plans).insert(newPlan);
            newPlan = newPlan.copyWith(id: Value(id));
          }

          if (!context.mounted) return;
          Navigator.pop(context);
        },
        tooltip: "Save this plan",
        child: const Icon(Icons.save),
      ),
    );
  }
}
