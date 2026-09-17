import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:file_picker/file_picker.dart';
import 'package:flexify/animated_fab.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  final TextEditingController _ctrl = TextEditingController();
  String _prev = "";
  String? _unit;
  String? _image;
  final _key = GlobalKey<FormState>();

  void pick() async {
    FilePickerResult? result = await FilePicker.pickFiles();
    if (result?.files.single == null || !mounted) return;

    setState(() {
      _image = result?.files.single.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(context.l10n.enterWeight)),
      body: Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 116),
            children: [
              TextFormField(
                controller: _ctrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: context.l10n.weightLabel,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.l10n.requiredField;
                  }
                  if (double.tryParse(value) == null) {
                    return context.l10n.invalidNumber;
                  }
                  return null;
                },
                autofocus: true,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: context.l10n.unitLabel),
                initialValue: _unit,
                items: strengthUnitMenuItems(context.l10n),
                onChanged: (String? newValue) {
                  setState(() {
                    _unit = newValue!;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _prev,
                decoration: InputDecoration(
                  labelText: context.l10n.previousWeight,
                ),
                enabled: false,
              ),
              const SizedBox(height: 12),
              Selector<SettingsState, bool>(
                builder: (context, showImages, child) {
                  return Visibility(
                    visible: showImages,
                    child: Column(
                      children: [
                        if (_image == null)
                          TextButton.icon(
                            onPressed: pick,
                            label: Text(context.l10n.imageLabel),
                            icon: const Icon(Icons.image),
                          ),
                        if (_image != null) ...[
                          const SizedBox(height: 8),
                          Tooltip(
                            message: context.l10n.longPressToDelete,
                            child: GestureDetector(
                              onTap: () => pick(),
                              onLongPress: () => setState(() {
                                _image = null;
                              }),
                              child: Image.file(
                                File(_image!),
                                cacheWidth: 400,
                                errorBuilder: (context, error, stackTrace) =>
                                    TextButton.icon(
                                      label: Text(context.l10n.imageError),
                                      icon: const Icon(Icons.error),
                                      onPressed: () => pick(),
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
                selector: (context, settings) => settings.value.showImages,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedFab(
        onPressed: () async {
          if (!_key.currentState!.validate()) return;

          final settings = context.read<SettingsState>().value;
          if (settings.strengthUnit != 'last-entry')
            _unit = settings.strengthUnit;

          final value = double.parse(_ctrl.text);
          await db.gymSets.insertOne(
            GymSetsCompanion.insert(
              created: DateTime.now().toLocal(),
              name: "Weight",
              reps: 1,
              unit: _unit ?? 'kg',
              weight: value,
              image: drift.Value(_image),
            ),
          );
          await (db.gymSets.update()..where((tbl) => tbl.bodyWeight.equals(0)))
              .write(GymSetsCompanion(bodyWeight: drift.Value(value)));

          if (context.mounted) Navigator.pop(context);
        },
        label: Text(context.l10n.actionSave),
        icon: const Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsState>().value;

    getBodyWeight().then((value) {
      if (!mounted) return;

      setState(() {
        _prev = "${value?.weight ?? 0} ${value?.unit ?? settings.strengthUnit}";

        if (settings.strengthUnit == 'last-entry')
          _unit = value?.unit;
        else
          _unit = settings.strengthUnit;
      });
    });
  }
}
