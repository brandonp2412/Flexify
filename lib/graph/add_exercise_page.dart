import 'dart:io';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
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

  late var settings = context.watch<SettingsState>();
  late String unit = settings.value.strengthUnit;
  String? image;

  @override
  Widget build(BuildContext context) {
    settings = context.watch<SettingsState>();

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
            const SizedBox(height: 8),
            ListTile(
              title: cardio ? const Text('Cardio') : const Text('Strength'),
              leading: cardio
                  ? const Icon(Icons.sports_gymnastics)
                  : const Icon(Icons.fitness_center),
              onTap: () {
                setState(() {
                  if (cardio)
                    unit = 'kg';
                  else
                    unit = 'km';
                  cardio = !cardio;
                });
              },
              trailing: Switch(
                value: cardio,
                onChanged: (value) => setState(() {
                  cardio = value;
                }),
              ),
            ),
            Visibility(
              visible: settings.value.showImages,
              child: material.Column(
                children: [
                  if (image == null)
                    TextButton.icon(
                      onPressed: pick,
                      label: const Text('Image'),
                      icon: const Icon(Icons.image),
                    ),
                  if (image != null) ...[
                    const SizedBox(height: 8),
                    Tooltip(
                      message: 'Long-press to delete',
                      child: GestureDetector(
                        onTap: () => pick(),
                        onLongPress: () => setState(() {
                          image = null;
                        }),
                        child: Image.file(
                          File(image!),
                          errorBuilder: (context, error, stackTrace) =>
                              TextButton.icon(
                            label: const Text('Image error'),
                            icon: const Icon(Icons.error),
                            onPressed: () => pick(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
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

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void pick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result?.files.single == null) return;

    setState(() {
      image = result?.files.single.path;
    });
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
        image: Value(image),
      ),
    );

    if (mounted) Navigator.pop(context);
  }
}
