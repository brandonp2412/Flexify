import 'package:drift/drift.dart';
import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';

class AddExercisePage extends StatefulWidget {
  const AddExercisePage({super.key});

  @override
  createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  late TextEditingController _nameController;
  late String _unit;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _unit = 'kg';
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _save() async {
    Navigator.pop(context);
    db.gymSets.insertOne(GymSetsCompanion.insert(
        created: DateTime.now(),
        reps: 0,
        weight: 0,
        name: _nameController.text,
        unit: _unit,
        hidden: const Value(true)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add exercise'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: material.Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
            ),
            DropdownButtonFormField<String>(
              value: _unit,
              decoration: const InputDecoration(labelText: 'Default unit'),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _save,
        child: const Icon(Icons.save),
      ),
    );
  }
}
