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
  List<bool>? daySwitches;
  List<bool>? exerciseSwitches;

  @override
  void initState() {
    super.initState();
    final dayList = widget.plan.days.value.split(',');
    daySwitches = weekdays.map((day) => dayList.contains(day)).toList();

    final splitExercises = widget.plan.exercises.value.split(',');
    exerciseSwitches =
        exercises.map((name) => splitExercises.contains(name)).toList();
  }

  @override
  dispose() {
    super.dispose();
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this plan?'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context, true); // showDialog() returns true
              },
            ),
            ElevatedButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context, false); // showDialog() returns false
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (widget.plan.id.present)
      actions.add(
        IconButton(
          onPressed: () async {
            bool? confirm = await _showConfirmationDialog(context);
            if (!confirm!) return;
            await database.plans.deleteOne(widget.plan);
            if (!mounted) return;
            Navigator.pop(context);
          },
          icon: const Icon(Icons.delete),
        ),
      );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Plan'), actions: actions),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: material.Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: getChildren,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final days = [];
            for (int i = 0; i < daySwitches!.length; i++) {
              if (daySwitches![i]) days.add(weekdays[i]);
            }
            if (days.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Select days first')),
              );
              return;
            }

            final selectedExercises = [];
            for (int i = 0; i < exerciseSwitches!.length; i++) {
              if (exerciseSwitches![i]) selectedExercises.add(exercises[i]);
            }
            if (selectedExercises.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Select exercises first')),
              );
              return;
            }

            var newPlan = widget.plan.copyWith(
              days: Value(days.join(',')),
              exercises: Value(selectedExercises.join(',')),
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
      ),
    );
  }

  List<Widget> get getChildren {
    final List<Widget> children = [
      Text('Days', style: Theme.of(context).textTheme.headlineSmall),
    ];

    final days = List.generate(7, (index) {
      return SwitchListTile(
        title: Text(weekdays[index]),
        value: daySwitches![index],
        onChanged: (value) {
          setState(() {
            daySwitches![index] = value;
          });
        },
      );
    });

    final tiles = List.generate(exercises.length, (index) {
      return SwitchListTile(
        title: Text(exercises[index]),
        value: exerciseSwitches![index],
        onChanged: (value) {
          setState(() {
            exerciseSwitches![index] = value;
          });
        },
      );
    });

    children.addAll(days);
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
}
