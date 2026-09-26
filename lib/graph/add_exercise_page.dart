import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:file_picker/file_picker.dart';
import 'package:flexify/animated_fab.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/exercise_options_view.dart';
import 'package:flexify/graph/graph_tile.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/logging.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Creates an exercise inside a category.
///
/// Typing a name that already exists in another category offers to copy that
/// exercise's details. Saving a name that already exists in the chosen
/// category is refused with a link to the existing exercise instead.
class AddExercisePage extends StatefulWidget {
  final String? name;
  final String? category;
  final TabController? tabController;

  const AddExercisePage({
    super.key,
    this.name,
    this.category,
    this.tabController,
  });

  @override
  createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  TextEditingController? _nameCtrl;
  bool _cardio = false;
  late String? _category = normalizeCategory(widget.category);
  late String _unit = _defaultUnit(context.read<SettingsState>().value);
  String? _image;
  int? _restMs;
  List<ExerciseKey> _existing = [];
  final _key = GlobalKey<FormState>();

  static String _defaultUnit(Setting settings) =>
      settings.strengthUnit == 'last-entry' ? 'kg' : settings.strengthUnit;

  @override
  void initState() {
    super.initState();
    (db.gymSets.selectOnly(distinct: true)
          ..addColumns([db.gymSets.name, db.gymSets.category])
          ..where(db.gymSets.name.isNotValue(bodyWeightExercise)))
        .get()
        .then((rows) {
          if (!mounted) return;
          setState(() {
            _existing = rows
                .map(
                  (row) => (
                    name: row.read(db.gymSets.name)!,
                    category: row.read(db.gymSets.category),
                  ),
                )
                .toList();
          });
        });
  }

  Future<void> _copyFrom(ExerciseKey exercise) async {
    final source =
        await (db.gymSets.select()
              ..where(
                (tbl) => isExercise(tbl, exercise.name, exercise.category),
              )
              ..orderBy([
                (tbl) => OrderingTerm(
                  expression: tbl.created,
                  mode: OrderingMode.desc,
                ),
              ])
              ..limit(1))
            .getSingleOrNull();
    if (source == null || !mounted) return;
    setState(() {
      _cardio = source.cardio;
      _unit = source.unit;
      _image = source.image;
      _restMs = source.restMs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final showImages = context.select<SettingsState, bool>(
      (settings) => settings.value.showImages,
    );

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
              StreamBuilder<List<String>>(
                stream: getCategoriesStream(),
                builder: (context, snapshot) {
                  final categories = {...?snapshot.data, ?_category}.toList();
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: context.l10n.categoryLabel,
                    ),
                    initialValue: _category,
                    items: categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                    validator: (value) =>
                        value == null ? context.l10n.chooseCategory : null,
                    onChanged: (value) => setState(() => _category = value),
                  );
                },
              ),
              const SizedBox(height: 8),
              Autocomplete<ExerciseKey>(
                initialValue: TextEditingValue(text: widget.name ?? ''),
                displayStringForOption: (option) => option.name,
                optionsBuilder: (value) {
                  if (value.text.trim().isEmpty) return const [];
                  return filterExerciseOptions(
                    _existing.where((option) => option.category != _category),
                    value.text,
                  );
                },
                optionsViewBuilder: (context, onSelected, options) =>
                    ExerciseOptionsView(
                      options: options,
                      onSelected: onSelected,
                    ),
                onSelected: _copyFrom,
                fieldViewBuilder: (context, controller, focusNode, onSubmit) {
                  _nameCtrl = controller;
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: context.l10n.nameLabel,
                      helperText: context.l10n.copyFromOtherCategory,
                      helperMaxLines: 2,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: true,
                    onFieldSubmitted: (_) => onSubmit(),
                    validator: (value) => value?.trim().isNotEmpty == true
                        ? null
                        : context.l10n.requiredField,
                  );
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                key: ValueKey(_unit),
                decoration: InputDecoration(labelText: context.l10n.unitLabel),
                initialValue: _unit,
                items: [
                  ...strengthUnitMenuItems(context.l10n),
                  if (_cardio) ...cardioUnitMenuItems(context.l10n),
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
                visible: showImages,
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
        onPressed: save,
        label: Text(context.l10n.actionSave),
        icon: const Icon(Icons.save),
      ),
    );
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

  /// Tells the user [existing] is already in the chosen category and offers
  /// to open it instead of creating a duplicate.
  void _showExisting(GymSet existing) {
    final navigator = Navigator.of(context);
    toast(
      context.l10n.exerciseExistsInCategory(existing.name, existing.category!),
      action: SnackBarAction(
        label: context.l10n.actionOpen,
        onPressed: () {
          if (!mounted) return;
          navigator.pop();
          openExerciseGraph(
            navigator,
            name: existing.name,
            category: existing.category,
            unit: existing.unit,
            cardio: existing.cardio,
            tabCtrl: widget.tabController,
          );
        },
      ),
    );
  }

  Future<void> save() async {
    if (!_key.currentState!.validate()) return;
    final name = _nameCtrl!.text.trim();
    final category = _category!;

    final existing =
        await (db.gymSets.select()
              ..where(
                (tbl) =>
                    tbl.name.lower().equals(name.toLowerCase()) &
                    tbl.category.equals(category),
              )
              ..limit(1))
            .getSingleOrNull();
    if (!mounted) return;
    if (existing != null) return _showExisting(existing);

    final insert = GymSetsCompanion.insert(
      created: DateTime.now().toLocal(),
      reps: 0,
      weight: 0,
      name: name,
      unit: _unit,
      cardio: Value(_cardio),
      hidden: const Value(true),
      image: Value(_image),
      category: Value(category),
      restMs: Value(_restMs),
    );
    await db.gymSets.insertOne(insert);
    talker.info('Created exercise template');
    if (!mounted) return;

    Navigator.pop(context, insert);
  }
}
