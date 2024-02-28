import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;

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
  final searchNode = FocusNode();
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final dayList = widget.plan.days.value.split(',');
    daySwitches = weekdays.map((day) => dayList.contains(day)).toList();

    final splitExercises = widget.plan.exercises.value.split(',');
    exerciseSelections = splitExercises;
  }

  @override
  dispose() {
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
          IconButton(onPressed: toggleSearch, icon: const Icon(Icons.search)));
    else
      actions.add(IconButton(
          onPressed: () {
            searchController.clear();
            searchNode.unfocus();
            setState(() {
              search = '';
              showSearch = false;
            });
          },
          icon: const Icon(Icons.clear)));

    List<Widget> getChildren() {
      final List<Widget> children = [];

      print("getChildren search=$search");
      if (search == '')
        children.add(
            Text('Days', style: Theme.of(context).textTheme.headlineSmall));

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
          .map((entry) => SwitchListTile(
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
              ));

      if (search == '') children.addAll(days);
      children.add(
        Text('Exercises', style: Theme.of(context).textTheme.headlineSmall),
      );
      children.addAll(tiles);

      return [
        Expanded(
          child: ListView(
            children: children,
          ),
        ),
      ];
    }

    var title = widget.plan.days.value.replaceAll(",", ", ");
    if (title.isNotEmpty)
      title = title[0].toUpperCase() + title.substring(1).toLowerCase();
    else
      title = "Add new plan";

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
                      hintText: "Search...", border: InputBorder.none),
                )
              : Text(title),
          actions: actions),
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
          if (days.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Select days first')),
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
          );

          if (widget.plan.id.present)
            await database.update(database.plans).replace(newPlan);
          else {
            final id = await database.into(database.plans).insert(newPlan);
            newPlan = newPlan.copyWith(id: Value(id));
          }

          if (!mounted) return;
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
