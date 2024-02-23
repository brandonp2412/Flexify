import 'package:drift/drift.dart' as drift;
import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'exercise_tile.dart';

class StartPlanPage extends StatefulWidget {
  final Plan plan;

  const StartPlanPage({Key? key, required this.plan}) : super(key: key);

  @override
  createState() => _StartPlanPageState();
}

class _StartPlanPageState extends State<StartPlanPage> {
  late TextEditingController _repsController;
  late TextEditingController _weightController;
  late Stream<List<drift.TypedResult>> stream;

  int _selectedExerciseIndex = 0;
  String _selectedUnit = 'kg';

  @override
  void initState() {
    super.initState();
    _repsController = TextEditingController(text: "10");
    _weightController = TextEditingController(text: "20");

    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    final startOfTomorrow = startOfToday.add(const Duration(days: 1));
    stream = (database.selectOnly(database.gymSets)
          ..addColumns([database.gymSets.name.count(), database.gymSets.name])
          ..where(database.gymSets.created.isBiggerOrEqualValue(startOfToday))
          ..where(database.gymSets.created.isSmallerThanValue(startOfTomorrow))
          ..groupBy([database.gymSets.name]))
        .watch();
  }

  @override
  void dispose() {
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercises = widget.plan.exercises.split(',');

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              "Start ${widget.plan.days.replaceAll(',', ', ').toLowerCase()}"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _repsController,
                decoration: const InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Weight'),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                value: _selectedUnit,
                onChanged: (newValue) {
                  setState(() {
                    _selectedUnit = newValue!;
                  });
                },
                items: <String>['kg', 'lb']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox();

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: exercises.length,
                            itemBuilder: (context, index) {
                              final exercise = exercises[index];
                              final gymSet = snapshot.data?.where((element) =>
                                  element.read(database.gymSets.name) ==
                                  exercise);
                              var count = 0;
                              if (gymSet != null && gymSet.isNotEmpty)
                                count = gymSet.first
                                    .read(database.gymSets.name.count())!;
                              return ExerciseTile(
                                exercise: exercise,
                                isSelected: index == _selectedExerciseIndex,
                                progress: count / 5,
                                onTap: () {
                                  setState(() {
                                    _selectedExerciseIndex = index;
                                  });
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final reps = double.parse(_repsController.text);
            final weight = double.parse(_weightController.text);
            final unit = _selectedUnit;
            final exercise = exercises[_selectedExerciseIndex];

            final gymSet = GymSetsCompanion.insert(
              name: exercise,
              reps: reps,
              weight: weight,
              unit: unit,
              created: DateTime.now(),
            );

            database.into(database.gymSets).insert(gymSet);
            const platform = MethodChannel('com.flexify/android');
            platform.invokeMethod('timer', [210000, exercise]);
          },
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
