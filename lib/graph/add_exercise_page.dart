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
  final TextEditingController _nameController = TextEditingController();
  String? _unit;
  bool _cardio = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save(String unit) async {
    await db.gymSets.insertOne(
      GymSetsCompanion.insert(
        created: DateTime.now().toLocal(),
        reps: 0,
        weight: 0,
        name: _nameController.text,
        unit: unit,
        cardio: Value(_cardio),
        hidden: const Value(true),
      ),
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    var unit = _unit;
    if (unit == null && _cardio)
      unit = settings.cardioUnit ?? 'km';
    else if (unit == null && !_cardio) unit = settings.strengthUnit ?? 'kg';

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
            UnitSelector(
              value: unit!,
              cardio: _cardio,
              onChanged: (String? newValue) {
                setState(() {
                  _unit = newValue!;
                });
              },
            ),
            ListTile(
              title: const Text('Cardio'),
              leading: _cardio
                  ? const Icon(Icons.sports_gymnastics)
                  : const Icon(Icons.fitness_center),
              onTap: () {
                setState(() {
                  _cardio = !_cardio;
                  if (_cardio)
                    _unit = settings.cardioUnit ?? 'km';
                  else
                    _unit = settings.strengthUnit ?? 'kg';
                });
              },
              trailing: Switch(
                value: _cardio,
                onChanged: (value) => setState(() {
                  _cardio = value;
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _save(unit!),
        tooltip: 'Save',
        child: const Icon(Icons.save),
      ),
    );
  }
}
