import 'dart:io';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/animated_fab.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExercisePage extends StatefulWidget {
  final String? name;

  const AddExercisePage({super.key, this.name});

  @override
  createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  final TextEditingController nameCtrl = TextEditingController();
  bool cardio = false;

  late var settings = context.watch<SettingsState>();
  late String unit = settings.value.strengthUnit == 'last-entry'
      ? 'kg'
      : settings.value.strengthUnit;
  String? image;
  final key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.name != null) nameCtrl.text = widget.name!;
  }

  @override
  Widget build(BuildContext context) {
    settings = context.watch<SettingsState>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add exercise'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: key,
          child: ListView(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
                validator: (value) =>
                    value?.isNotEmpty == true ? null : 'Required',
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Unit'),
                initialValue: unit,
                items: const [
                  DropdownMenuItem(
                    value: 'kg',
                    child: Text("Kilograms (kg)"),
                  ),
                  DropdownMenuItem(
                    value: 'lb',
                    child: Text("Pounds (lb)"),
                  ),
                  DropdownMenuItem(
                    value: 'stone',
                    child: Text("Stone"),
                  ),
                  DropdownMenuItem(
                    value: 'km',
                    child: Text("Kilometers (km)"),
                  ),
                  DropdownMenuItem(
                    value: 'mi',
                    child: Text("Miles (mi)"),
                  ),
                ],
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
                    material.Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: pick,
                          label: const Text('Image'),
                          icon: const Icon(Icons.image),
                        ),
                        if (image != null)
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                image = null;
                              });
                            },
                            label: const Text("Delete"),
                            icon: const Icon(Icons.delete),
                          ),
                      ],
                    ),
                    if (image != null) ...[
                      const SizedBox(height: 8),
                      Image.file(
                        File(image!),
                        errorBuilder: (context, error, stackTrace) =>
                            TextButton.icon(
                          label: const Text('Image error'),
                          icon: const Icon(Icons.error),
                          onPressed: () => pick(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedFab(
        onPressed: () => save(unit),
        label: const Text('Save'),
        icon: const Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    super.dispose();
  }

  void pick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result?.files.single == null) return;

    setState(() {
      image = result?.files.single.path;
    });
  }

  Future<void> save(String unit) async {
    if (!key.currentState!.validate()) return;

    if (settings.value.strengthUnit != 'last-entry' && !cardio)
      unit = settings.value.strengthUnit;
    else if (settings.value.cardioUnit != 'last-entry' && cardio)
      unit = settings.value.cardioUnit;

    final insert = GymSetsCompanion.insert(
      created: DateTime.now().toLocal(),
      reps: 0,
      weight: 0,
      name: nameCtrl.text,
      unit: unit,
      cardio: Value(cardio),
      hidden: const Value(true),
      image: Value(image),
    );
    await db.gymSets.insertOne(insert);
    if (!mounted) return;

    Navigator.pop(context, insert);
  }
}
