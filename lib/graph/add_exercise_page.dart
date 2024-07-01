import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/unit_selector.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExercisePage extends StatefulWidget {
  const AddExercisePage({super.key});

  @override
  createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  final TextEditingController nameController = TextEditingController();
  bool cardio = false;

  late final settings = context.watch<SettingsState>();
  late String unit = settings.strengthUnit;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _save(String unit) async {
    await db.gymSets.insertOne(
      GymSetsCompanion.insert(
        created: DateTime.now().toLocal(),
        reps: 0,
        weight: 0,
        name: nameController.text,
        unit: unit,
        cardio: Value(cardio),
        hidden: const Value(true),
      ),
    );

    if (mounted) Navigator.pop(context);
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
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
            ),
            UnitSelector(
              value: unit,
              cardio: cardio,
              onChanged: (String? newValue) {
                setState(() {
                  unit = newValue!;
                });
              },
            ),
            ListTile(
              title: const Text('Cardio'),
              leading: cardio
                  ? const Icon(Icons.sports_gymnastics)
                  : const Icon(Icons.fitness_center),
              onTap: () {
                setState(() {
                  cardio = !cardio;
                  if (cardio)
                    unit = settings.cardioUnit;
                  else
                    unit = settings.strengthUnit;
                });
              },
              trailing: Switch(
                value: cardio,
                onChanged: (value) => setState(() {
                  cardio = value;
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _save(unit),
        tooltip: 'Save',
        child: const Icon(Icons.save),
      ),
    );
  }
}
