import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:file_picker/file_picker.dart';
import 'package:flexify/animated_fab.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditGraphPage extends StatefulWidget {
  final String name;

  const EditGraphPage({required this.name, super.key});

  @override
  createState() => _EditGraphPageState();
}

class _EditGraphPageState extends State<EditGraphPage> {
  late final TextEditingController name = TextEditingController(
    text: widget.name,
  );
  final TextEditingController minutes = TextEditingController();
  final TextEditingController seconds = TextEditingController();
  final key = GlobalKey<FormState>();

  bool? cardio;
  String? unit;
  String? image;
  String? category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Update all ${widget.name.toLowerCase()}")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: key,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 116),
            children: [
              TextField(
                controller: name,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "New name"),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: minutes,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: "Rest minutes",
                      ),
                      keyboardType: TextInputType.number,
                      onTap: () => selectAll(minutes),
                      validator: (value) {
                        if (value == null || value.isEmpty) return null;
                        if (int.tryParse(value) == null)
                          return 'Invalid number';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextFormField(
                      controller: seconds,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: "Rest seconds",
                      ),
                      keyboardType: TextInputType.number,
                      onTap: () {
                        selectAll(seconds);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) return null;
                        if (int.tryParse(value) == null)
                          return 'Invalid number';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Selector<SettingsState, bool>(
                selector: (p0, settings) => settings.value.showCategories,
                builder: (context, showCategories, child) {
                  if (!showCategories) return const SizedBox();
                  return StreamBuilder(
                    stream: getCategoriesStream(),
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          DropdownButtonFormField(
                            decoration: const InputDecoration(
                              labelText: 'Category',
                            ),
                            initialValue: category,
                            items: snapshot.data
                                ?.map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                category = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 8.0),
                        ],
                      );
                    },
                  );
                },
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Unit'),
                initialValue: unit,
                items: [
                  const DropdownMenuItem(value: null, child: Text("")),
                  ...strengthUnitMenuItems,
                  ...cardioUnitMenuItems,
                ],
                onChanged: (value) {
                  setState(() {
                    unit = value;
                  });
                },
              ),
              if (cardio != null) ...[
                const SizedBox(height: 8.0),
                ListTile(
                  leading: cardio!
                      ? const Icon(Icons.sports_gymnastics)
                      : const Icon(Icons.fitness_center),
                  title: cardio!
                      ? const Text('Cardio')
                      : const Text('Strength'),
                  onTap: () => _setCardio(!cardio!),
                  trailing: Switch(value: cardio!, onChanged: _setCardio),
                ),
                const SizedBox(height: 8.0),
              ] else
                const SizedBox(height: 8.0),
              Selector<SettingsState, bool>(
                builder: (context, showImages, child) {
                  return Visibility(
                    visible: showImages,
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
                  );
                },
                selector: (context, settings) => settings.value.showImages,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedFab(
        onPressed: save,
        label: const Text("Update"),
        icon: const Icon(Icons.sync),
      ),
    );
  }

  @override
  dispose() {
    name.dispose();
    minutes.dispose();
    seconds.dispose();
    super.dispose();
  }

  Future<void> doUpdate() async {
    Duration? duration;
    if (int.tryParse(minutes.text) != null && int.tryParse(minutes.text)! > 0 ||
        int.tryParse(seconds.text) != null && int.tryParse(seconds.text)! > 0)
      duration = Duration(
        minutes: int.tryParse(minutes.text) ?? 0,
        seconds: int.tryParse(seconds.text) ?? 0,
      );

    await (db.gymSets.update()..where((tbl) => tbl.name.equals(widget.name)))
        .write(
          GymSetsCompanion(
            name: name.text.isEmpty ? const Value.absent() : Value(name.text),
            cardio: Value.absentIfNull(cardio),
            unit: Value.absentIfNull(unit),
            restMs: Value(duration?.inMilliseconds),
            image: Value(image),
            category: Value.absentIfNull(category),
          ),
        );

    await (db.planExercises.update()
          ..where((tbl) => tbl.exercise.equals(widget.name)))
        .write(
          PlanExercisesCompanion(
            exercise: name.text.isEmpty
                ? const Value.absent()
                : Value(name.text),
          ),
        );

    if (name.text.isNotEmpty && name.text != widget.name) {
      await _migrateGraphPreferences(name.text);
    }

    if (!mounted) return;
    context.read<PlanState>().updatePlans(null);
  }

  Future<void> _migrateGraphPreferences(String newName) async {
    final oldPreference =
        await (db.graphPreferences.select()
              ..where((tbl) => tbl.name.equals(widget.name)))
            .getSingleOrNull();
    if (oldPreference == null) return;

    final targetPreference =
        await (db.graphPreferences.select()
              ..where((tbl) => tbl.name.equals(newName)))
            .getSingleOrNull();
    if (targetPreference != null) {
      await (db.graphPreferences.delete()
            ..where((tbl) => tbl.name.equals(widget.name)))
          .go();
      return;
    }

    await (db.graphPreferences.update()
          ..where((tbl) => tbl.name.equals(widget.name)))
        .write(GraphPreferencesCompanion(name: Value(newName)));
  }

  Future<int> getCount() async {
    final result =
        await (db.gymSets.selectOnly()
              ..addColumns([db.gymSets.name.count()])
              ..where(db.gymSets.name.equals(name.text)))
            .getSingle();
    return result.read(db.gymSets.name.count()) ?? 0;
  }

  @override
  void initState() {
    super.initState();

    (db.gymSets.select()
          ..where((tbl) => tbl.name.equals(widget.name))
          ..limit(1))
        .getSingle()
        .then(
          (gymSet) => setState(() {
            image = gymSet.image;
            cardio = gymSet.cardio;
            category = gymSet.category;

            if (gymSet.restMs != null) {
              final duration = Duration(milliseconds: gymSet.restMs!);
              minutes.text = duration.inMinutes.toString();
              seconds.text = (duration.inSeconds % 60).toString();
            }
          }),
        );
  }

  Future<List<String>> currentUnits() async {
    final result =
        await (db.gymSets.selectOnly(distinct: true)
              ..addColumns([db.gymSets.unit])
              ..where(db.gymSets.name.equals(widget.name)))
            .get();
    return result.map((row) => row.read(db.gymSets.unit)!).toList();
  }

  Future<bool> mixedUnits() async => (await currentUnits()).length > 1;

  Future<bool> needsUnitConversion() async {
    if (unit == null) return false;
    return (await currentUnits()).any((current) => current != unit);
  }

  void pick() async {
    FilePickerResult? result = await FilePicker.pickFiles();
    if (result?.files.single == null || !mounted) return;

    setState(() {
      image = result?.files.single.path;
    });
  }

  Future<bool> confirmUpdate(String title, String content) async {
    if (!mounted) return false;
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton.icon(
                label: const Text('Cancel'),
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(dialogContext, false),
              ),
              TextButton.icon(
                label: const Text('Confirm'),
                icon: const Icon(Icons.check),
                onPressed: () => Navigator.pop(dialogContext, true),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> save() async {
    if (!key.currentState!.validate()) return;

    final count = await getCount();
    if (count > 0 && widget.name != name.text) {
      final confirmed = await confirmUpdate(
        'Update conflict',
        'Your new name exists already for $count records. Are you sure?',
      );
      if (!confirmed) return;
    }

    final shouldConvert = await needsUnitConversion();
    if (shouldConvert && await mixedUnits()) {
      final confirmed = await confirmUpdate(
        'Units conflict',
        'Not all of your records have the same unit. This will convert all units to $unit. Are you sure?',
      );
      if (!confirmed) return;
    }

    if (shouldConvert) await convertUnits();
    await doUpdate();

    if (!mounted) return;
    Navigator.pop(context, name.text);
  }

  void _setCardio(bool value) {
    setState(() {
      cardio = value;
      if (!value && unit != null && !_isWeightUnit(unit!)) unit = 'kg';
    });
  }

  bool _isWeightUnit(String value) =>
      value == 'kg' || value == 'lb' || value == 'stone';

  bool _isDistanceUnit(String value) =>
      value == 'km' || value == 'mi' || value == 'm';

  double convertStrengthValue(double value, String source, String target) {
    if (source == target) return value;
    switch ('$source->$target') {
      case 'kg->lb':
        return value * 2.20462262185;
      case 'kg->stone':
        return value / 6.35029318;
      case 'lb->kg':
        return value * 0.45359237;
      case 'lb->stone':
        return value / 14;
      case 'stone->kg':
        return value * 6.35029318;
      case 'stone->lb':
        return value * 14;
    }
    return value;
  }

  double convertCardioValue(double value, String source, String target) {
    if (source == target) return value;
    switch ('$source->$target') {
      case 'km->mi':
        return value / 1.609344;
      case 'km->m':
        return value * 1000;
      case 'mi->km':
        return value * 1.609344;
      case 'mi->m':
        return value * 1609.344;
      case 'm->km':
        return value / 1000;
      case 'm->mi':
        return value / 1609.344;
    }
    return value;
  }

  Future<void> convertUnits() async {
    final target = unit;
    if (target == null) return;

    final rows =
        await (db.gymSets.select()
              ..where((tbl) => tbl.name.equals(widget.name)))
            .get();

    await db.transaction(() async {
      for (final row in rows) {
        GymSetsCompanion companion;
        if (_isWeightUnit(row.unit) && _isWeightUnit(target)) {
          companion = GymSetsCompanion(
            weight: Value(convertStrengthValue(row.weight, row.unit, target)),
          );
        } else if (_isDistanceUnit(row.unit) && _isDistanceUnit(target)) {
          companion = GymSetsCompanion(
            distance: Value(convertCardioValue(row.distance, row.unit, target)),
          );
        } else {
          companion = const GymSetsCompanion();
        }
        await (db.gymSets.update()..where((tbl) => tbl.id.equals(row.id)))
            .write(companion);
      }
    });
  }
}
