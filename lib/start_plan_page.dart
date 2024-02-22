import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';

import 'exercise_tile.dart';

class StartPlanPage extends StatefulWidget {
  final Plan plan;

  const StartPlanPage({Key? key, required this.plan}) : super(key: key);

  @override
  _StartPlanPageState createState() => _StartPlanPageState();
}

class _StartPlanPageState extends State<StartPlanPage> {
  late TextEditingController _repsController;
  late TextEditingController _weightController;
  late TextEditingController _unitController;

  int _selectedExerciseIndex = 0;

  @override
  void initState() {
    super.initState();
    _repsController = TextEditingController();
    _weightController = TextEditingController();
    _unitController = TextEditingController();
  }

  @override
  void dispose() {
    _repsController.dispose();
    _weightController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercises = widget.plan.exercises.split(',');

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Start ${widget.plan.days.replaceAll(',', ', ').toLowerCase()}"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
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
          TextField(
            controller: _unitController,
            decoration: const InputDecoration(labelText: 'Unit'),
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return ExerciseTile(
                exercise: exercise,
                isSelected: index == _selectedExerciseIndex,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final reps = int.parse(_repsController.text);
          final weight = int.parse(_weightController.text);
          final unit = _unitController.text;
          final exercise = exercises[_selectedExerciseIndex];

          final gymSet = GymSetsCompanion.insert(
            name: exercise,
            reps: reps,
            weight: weight,
            unit: unit,
            created: DateTime.now(),
          );

          database.into(database.gymSets).insert(gymSet);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
