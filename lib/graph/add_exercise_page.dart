import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flexify/animated_fab.dart';
import 'package:flexify/database/exercise_catalog.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/logging.dart';
import 'package:flexify/database/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExercisePage extends StatefulWidget {
  final String? name;

  const AddExercisePage({super.key, this.name});

  @override
  createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  bool _hasUnsavedChanges = false;
  bool _allowPop = false;

  void _markDirty() {
    if (_hasUnsavedChanges) return;
    setState(() => _hasUnsavedChanges = true);
  }

  Future<void> _confirmDiscard(Object? result) async {
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(context.l10n.unsavedChanges),
        content: Text(context.l10n.discardUnsavedChanges),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.actionDiscard),
          ),
        ],
      ),
    );
    if (discard != true || !mounted) return;
    setState(() => _allowPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context).pop(result);
    });
  }

  final TextEditingController _nameCtrl = TextEditingController();
  bool _cardio = false;

  late var settings = context.watch<Setting>();
  late String _unit = settings.strengthUnit == 'last-entry'
      ? 'kg'
      : settings.strengthUnit;
  String? _image;
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.name != null) _nameCtrl.text = widget.name!;
  }

  @override
  Widget build(BuildContext context) {
    settings = context.watch<Setting>();

    return PopScope(
      canPop: _allowPop || !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop || _allowPop || !_hasUnsavedChanges) return;
        unawaited(_confirmDiscard(result));
      },
      child: Scaffold(
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
                  decoration: InputDecoration(
                    labelText: context.l10n.nameLabel,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  autofocus: true,
                  onChanged: (_) => _markDirty(),
                  validator: (value) => value?.isNotEmpty == true
                      ? null
                      : context.l10n.requiredField,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  key: ValueKey(_unit),
                  decoration: InputDecoration(
                    labelText: context.l10n.unitLabel,
                  ),
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
                    _markDirty();
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
                  visible: settings.showImages,
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
                                _markDirty();
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
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _setCardio(bool value) {
    _markDirty();
    setState(() {
      _cardio = value;
      if (value && _isWeightUnit(_unit)) {
        _unit = settings.cardioUnit == 'last-entry'
            ? 'km'
            : settings.cardioUnit;
      } else if (!value && !_isWeightUnit(_unit)) {
        _unit = settings.strengthUnit == 'last-entry'
            ? 'kg'
            : settings.strengthUnit;
      }
    });
  }

  bool _isWeightUnit(String value) =>
      value == 'kg' || value == 'lb' || value == 'stone';

  void pick() async {
    final result = await FilePicker.pickFiles();
    final path = result?.files.single.path;
    if (path == null || !mounted) return;

    _markDirty();
    setState(() {
      _image = path;
    });
  }

  Future<void> save(String unit) async {
    if (!_key.currentState!.validate()) return;

    if (settings.strengthUnit != 'last-entry' && !_cardio)
      _unit = settings.strengthUnit;
    else if (settings.cardioUnit != 'last-entry' && _cardio)
      _unit = settings.cardioUnit;

    final exercise = await createExerciseDefinition(
      name: _nameCtrl.text,
      cardio: _cardio,
      displayUnit: _unit,
      image: _image,
    );
    talker.info('Created exercise definition');
    if (!mounted) return;

    _allowPop = true;
    Navigator.pop(context, exercise);
  }
}
