import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:file_picker/file_picker.dart';
import 'package:flexify/animated_fab.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/logging.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExercisePage extends StatefulWidget {
  final String? name;

  const AddExercisePage({super.key, this.name});

  @override
  createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  final TextEditingController _nameCtrl = TextEditingController();
  bool _cardio = false;

  late var settings = context.watch<SettingsState>();
  late String _unit = settings.value.strengthUnit == 'last-entry'
      ? 'kg'
      : settings.value.strengthUnit;
  String? _image;
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.name != null) _nameCtrl.text = widget.name!;
  }

  @override
  Widget build(BuildContext context) {
    settings = context.watch<SettingsState>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Add exercise')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 116),
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
                validator: (value) =>
                    value?.isNotEmpty == true ? null : 'Required',
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Unit'),
                initialValue: _unit,
                items: const [
                  DropdownMenuItem(value: 'kg', child: Text("Kilograms (kg)")),
                  DropdownMenuItem(value: 'lb', child: Text("Pounds (lb)")),
                  DropdownMenuItem(value: 'stone', child: Text("Stone")),
                  DropdownMenuItem(value: 'km', child: Text("Kilometers (km)")),
                  DropdownMenuItem(value: 'mi', child: Text("Miles (mi)")),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _unit = newValue!;
                  });
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                title: _cardio ? const Text('Cardio') : const Text('Strength'),
                leading: _cardio
                    ? const Icon(Icons.sports_gymnastics)
                    : const Icon(Icons.fitness_center),
                onTap: () => _setCardio(!_cardio),
                trailing: Switch(value: _cardio, onChanged: _setCardio),
              ),
              Visibility(
                visible: settings.value.showImages,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: pick,
                          label: const Text('Image'),
                          icon: const Icon(Icons.image),
                        ),
                        if (_image != null)
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _image = null;
                              });
                            },
                            label: const Text("Delete"),
                            icon: const Icon(Icons.delete),
                          ),
                      ],
                    ),
                    if (_image != null) ...[
                      const SizedBox(height: 8),
                      Image.file(
                        File(_image!),
                        cacheWidth: 400,
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
        onPressed: () => save(_unit),
        label: const Text('Save'),
        icon: const Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _setCardio(bool value) {
    setState(() {
      _cardio = value;
      if (!value && !_isWeightUnit(_unit)) _unit = 'kg';
    });
  }

  bool _isWeightUnit(String value) =>
      value == 'kg' || value == 'lb' || value == 'stone';

  void pick() async {
    FilePickerResult? result = await FilePicker.pickFiles();
    if (result?.files.single == null || !mounted) return;

    setState(() {
      _image = result?.files.single.path;
    });
  }

  Future<void> save(String unit) async {
    if (!_key.currentState!.validate()) return;

    if (settings.value.strengthUnit != 'last-entry' && !_cardio)
      _unit = settings.value.strengthUnit;
    else if (settings.value.cardioUnit != 'last-entry' && _cardio)
      _unit = settings.value.cardioUnit;

    final insert = GymSetsCompanion.insert(
      created: DateTime.now().toLocal(),
      reps: 0,
      weight: 0,
      name: _nameCtrl.text,
      unit: _unit,
      cardio: Value(_cardio),
      hidden: const Value(true),
      image: Value(_image),
    );
    await db.gymSets.insertOne(insert);
    talker.info('Created exercise template');
    if (!mounted) return;

    Navigator.pop(context, insert);
  }
}
