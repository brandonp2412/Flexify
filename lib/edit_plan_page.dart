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
  late List<bool> daySwitches;
  late List<String> exerciseSelections;
  bool showSearch = false;
  String search = '';
  List<String> exercises = [];
  final searchNode = FocusNode();
  final searchController = TextEditingController();
  final titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    (db.gymSets.selectOnly(distinct: true)..addColumns([db.gymSets.name]))
        .get()
        .then((results) => setState(() {
              exercises = results.map((e) => e.read(db.gymSets.name)!).toList();
            }));

    titleController.text = widget.plan.title.value ?? "";

    final dayList = widget.plan.days.value.split(',');
    daySwitches = weekdays.map((day) => dayList.contains(day)).toList();

    if (widget.plan.exercises.value.isEmpty)
      exerciseSelections = [];
    else {
      final splitExercises = widget.plan.exercises.value.split(',');
      exerciseSelections = splitExercises;
    }
  }

  @override
  void dispose() {
    searchNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  void toggleSearch() {
    setState(() {
      showSearch = !showSearch;
      if (!showSearch) search = '';
    });
    searchNode.requestFocus();
    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];

    if (search == '')
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
            searchController.clear();
            searchNode.unfocus();
            setState(() {
              search = '';
              showSearch = false;
            });
          },
          icon: const Icon(Icons.clear),
        ),
      );

    List<Widget> getChildren() {
      final List<Widget> children = [
        material.TextField(
          decoration: const material.InputDecoration(labelText: 'Title'),
          controller: titleController,
        ),
        const SizedBox(
          height: 16.0,
        )
      ];

      if (search == '')
        children.add(
          Text('Days', style: Theme.of(context).textTheme.headlineSmall),
        );

      final days = List.generate(7, (index) {
        return SwitchListTile(
          title: Text(weekdays[index]),
          value: daySwitches[index],
          onChanged: (value) {
            setState(() {
              daySwitches[index] = value;
            });
          },
        );
      });

      final tiles = exercises
          .where((exercise) =>
              exercise.toLowerCase().contains(search.toLowerCase()))
          .toList()
          .asMap()
          .entries
          .map(
            (entry) => SwitchListTile(
              title: Text(entry.value),
              value: exerciseSelections.contains(entry.value),
              onChanged: (value) {
                setState(() {
                  if (value)
                    exerciseSelections.add(entry.value);
                  else
                    exerciseSelections.remove(entry.value);
                });
              },
            ),
          );

      if (search == '') children.addAll(days);
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
        title: showSearch
            ? TextField(
                focusNode: searchNode,
                controller: searchController,
                onChanged: (value) => setState(() {
                  search = value;
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
          for (int i = 0; i < daySwitches.length; i++) {
            if (daySwitches[i]) days.add(weekdays[i]);
          }
          if (days.isEmpty && titleController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Select days/title first')),
            );
            return;
          }

          if (exerciseSelections.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Select exercises first')),
            );
            return;
          }

          var newPlan = widget.plan.copyWith(
            days: Value(days.join(',')),
            exercises: Value(exerciseSelections
                .where((element) => element.isNotEmpty)
                .join(',')),
            title: Value(titleController.text),
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
