import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:file_picker/file_picker.dart';
import 'package:flexify/animated_fab.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/l10n/l10n.dart';
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
      appBar: AppBar(title: Text(context.l10n.addExercise)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 116),
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(labelText: context.l10n.nameLabel),
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
                validator: (value) => value?.isNotEmpty == true
                    ? null
                    : context.l10n.requiredField,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: context.l10n.unitLabel),
                initialValue: _unit,
                items: [
                  DropdownMenuItem(
                    value: 'kg',
                    child: Text(context.l10n.kilogramsUnit),
                  ),
                  DropdownMenuItem(
                    value: 'lb',
                    child: Text(context.l10n.poundsUnit),
                  ),
                  DropdownMenuItem(
                    value: 'stone',
                    child: Text(context.l10n.stoneUnit),
                  ),
                  DropdownMenuItem(
                    value: 'km',
                    child: Text(context.l10n.kilometersUnit),
                  ),
                  DropdownMenuItem(
                    value: 'mi',
                    child: Text(context.l10n.milesUnit),
                  ),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _unit = newValue!;
                  });
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                title: Text(
                  _cardio ? context.l10n.cardio : context.l10n.strength,
                ),
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
                          label: Text(context.l10n.imageLabel),
                          icon: const Icon(Icons.image),
                        ),
                        if (_image != null)
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _image = null;
                              });
                            },
                            label: Text(context.l10n.actionDelete),
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
                              label: Text(context.l10n.imageError),
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
        label: Text(context.l10n.actionSave),
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
