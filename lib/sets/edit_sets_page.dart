import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flexify/animated_fab.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/exercise_catalog.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/database/categories.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/settings/category_management_page.dart';
import 'package:flexify/utils.dart';
import 'package:flexify/platform_page_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditSetsPage extends StatefulWidget {
  final List<int> ids;

  const EditSetsPage({super.key, required this.ids});

  @override
  createState() => _EditSetsPageState();
}

class _EditSetsPageState extends State<EditSetsPage> {
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

  final _reps = TextEditingController();
  final _weight = TextEditingController();
  final _body = TextEditingController();
  final _distance = TextEditingController();
  final _minutes = TextEditingController();
  final _seconds = TextEditingController();
  final _incline = TextEditingController();
  final _name = TextEditingController();
  final _key = GlobalKey<FormState>();

  String? _unit;
  DateTime? _created;
  bool? _cardio;
  int? _restMs;
  String? _category;
  String? _oldNames;
  String? _oldReps;
  String? _oldWeights;
  String? _oldBody;
  String? _oldCreated;
  String? _oldDist;
  String? _oldMin;
  String? _oldSec;
  String? _oldInc;
  String? _oldCat;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopScope(
      canPop: _allowPop || !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop || _allowPop || !_hasUnsavedChanges) return;
        unawaited(_confirmDiscard(result));
      },
      child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l10n.editSets(widget.ids.length)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: Text(l10n.confirmDelete),
                    content: Text(
                      l10n.deleteEntriesConfirmation(widget.ids.length),
                    ),
                    actions: <Widget>[
                      TextButton.icon(
                        label: Text(l10n.actionCancel),
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                      ),
                      TextButton.icon(
                        label: Text(l10n.actionDelete),
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          Navigator.pop(dialogContext);
                          await deleteExerciseSets(db, widget.ids);
                            if (!context.mounted) return;
                            _allowPop = true;
                            Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: ListView(
            children: [
              TextField(
                controller: _name,
                decoration: InputDecoration(
                  labelText: l10n.nameLabel,
                  hintText: _oldNames,
                ),
                textCapitalization: TextCapitalization.sentences,
                  onChanged: (_) => _markDirty(),
              ),
              ListTile(
                title: Text(l10n.cardio),
                leading: _cardio == true
                    ? const Icon(Icons.sports_gymnastics)
                    : const Icon(Icons.fitness_center),
                contentPadding: EdgeInsets.zero,
                  onTap: () => _setCardio(!(_cardio ?? false)),
                trailing: Switch(
                  value: _cardio ?? false,
                    onChanged: _setCardio,
                ),
              ),
              if (_cardio == true) ...[
                if (_isWeightUnit(_unit))
                  TextFormField(
                    controller: _weight,
                    decoration: InputDecoration(
                      labelText: l10n.weightLabel,
                      hintText: _oldWeights,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onTap: () => selectAll(_weight),
                      onChanged: (_) => _markDirty(),
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      if (parseDisplayNumber(context, value) == null)
                        return l10n.invalidNumber;
                      return null;
                    },
                  )
                else
                  TextFormField(
                    controller: _distance,
                    decoration: InputDecoration(
                      labelText: l10n.distanceLabel,
                      hintText: _oldDist,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onTap: () => selectAll(_distance),
                      onChanged: (_) => _markDirty(),
                    validator: (value) {
                      if (value == null) return null;
                      if (parseDisplayNumber(context, value) == null)
                        return l10n.invalidNumber;
                      return null;
                    },
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _minutes,
                        decoration: InputDecoration(
                          labelText: l10n.minutesLabel,
                          hintText: _oldMin,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: false,
                        ),
                        onTap: () => selectAll(_minutes),
                          onChanged: (_) => _markDirty(),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) return null;
                          if (int.tryParse(value) == null)
                            return l10n.invalidNumber;
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextFormField(
                        controller: _seconds,
                        decoration: InputDecoration(
                          labelText: l10n.secondsLabel,
                          hintText: _oldSec,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: false,
                        ),
                        onTap: () => selectAll(_seconds),
                          onChanged: (_) => _markDirty(),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) return null;
                          if (int.tryParse(value) == null)
                            return l10n.invalidNumber;
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _incline,
                  decoration: InputDecoration(
                    labelText: l10n.inclinePercent,
                    hintText: _oldInc,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onTap: () => selectAll(_incline),
                    onChanged: (_) => _markDirty(),
                  validator: (value) {
                    if (value == null) return null;
                    if (double.tryParse(value) == null)
                      return l10n.invalidNumber;
                    return null;
                  },
                ),
              ],
              if (_cardio == false || _cardio == null) ...[
                TextFormField(
                  controller: _reps,
                  decoration: InputDecoration(
                    labelText: l10n.repsLabel,
                    hintText: _oldReps,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onTap: () => selectAll(_reps),
                    onChanged: (_) => _markDirty(),
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    if (parseDisplayNumber(context, value) == null)
                      return l10n.invalidNumber;
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _weight,
                  decoration: InputDecoration(
                    labelText: l10n.weightLabel,
                    hintText: _oldWeights,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onTap: () => selectAll(_weight),
                    onChanged: (_) => _markDirty(),
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    if (parseDisplayNumber(context, value) == null)
                      return l10n.invalidNumber;
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 12),
              Selector<SettingsState, bool>(
                builder: (context, showBodyWeight, child) => Visibility(
                  visible: showBodyWeight,
                  child: TextFormField(
                    controller: _body,
                    decoration: InputDecoration(
                      labelText: l10n.bodyWeightLabel,
                      hintText: _oldBody,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onTap: () => selectAll(_body),
                      onChanged: (_) => _markDirty(),
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      if (parseDisplayNumber(context, value) == null)
                        return l10n.invalidNumber;
                      return null;
                    },
                  ),
                ),
                  selector: (context, settings) =>
                      settings.value.showBodyWeight,
              ),
              const SizedBox(height: 12),
              Selector<SettingsState, bool>(
                builder: (context, showUnits, child) => Visibility(
                  visible: showUnits,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: l10n.unitLabel),
                    initialValue: _unit,
                    items: _getUnitItems(context),
                    onChanged: (String? newValue) {
                        _markDirty();
                      setState(() {
                        _unit = newValue!;
                      });
                    },
                  ),
                ),
                selector: (context, settings) => settings.value.showUnits,
              ),
              const SizedBox(height: 12),
              Selector<SettingsState, bool>(
                  selector: (context, settings) =>
                      settings.value.showCategories,
                builder: (context, showCategories, child) => Visibility(
                  visible: showCategories,
                  child: StreamBuilder<List<String>>(
                    stream: getCategoriesStream(),
                    builder: (context, snapshot) => Autocomplete<String>(
                      initialValue: TextEditingValue(text: _category ?? ''),
                      optionsBuilder: (value) =>
                          snapshot.data
                              ?.where(
                                (category) => category.toLowerCase().contains(
                                  value.text.toLowerCase(),
                                ),
                              )
                              .toList() ??
                          [],
                        onSelected: (category) {
                          _markDirty();
                          setState(() => _category = category);
                        },
                      fieldViewBuilder: (context, controller, focusNode, _) =>
                          TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: l10n.categoryLabel,
                              hintText: _oldCat,
                              helperText: l10n.categoryHelper,
                              suffixIcon: IconButton(
                                tooltip: l10n.manageCategories,
                                icon: const Icon(Icons.settings),
                                onPressed: () => Navigator.of(context).push(
                                  FlexPageRoute(
                                    builder: (_) =>
                                        const CategoryManagementPage(),
                                  ),
                                ),
                              ),
                            ),
                              onChanged: (value) {
                                _markDirty();
                                setState(
                                  () =>
                                      _category = value.isEmpty ? null : value,
                                );
                              },
                          ),
                    ),
                  ),
                ),
              ),
              Selector<SettingsState, String>(
                builder: (context, longDateFormat, child) {
                  var subtitle = _oldCreated ?? "";

                  if (longDateFormat == 'timeago' && _created != null)
                    subtitle = formatRelativeTime(context, _created!);
                  else if (longDateFormat != 'timeago' && _created != null)
                    subtitle = formatDisplayDate(
                      context,
                      _created!,
                      longDateFormat,
                    );

                  return ListTile(
                    title: Text(l10n.createdDate),
                    subtitle: Text(subtitle),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(),
                  );
                },
                  selector: (context, settings) =>
                      settings.value.longDateFormat,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedFab(
        onPressed: save,
        label: Text(l10n.actionUpdate),
        icon: const Icon(Icons.sync),
      ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _getUnitItems(BuildContext context) {
    if (_cardio == true) {
      return [
        ...strengthUnitMenuItems(context.l10n),
        ...cardioUnitMenuItems(context.l10n),
      ];
    }
    return strengthUnitMenuItems(context.l10n);
  }

  void _setCardio(bool value) {
    _markDirty();
    setState(() {
    _cardio = value;
    if (!value && !_isWeightUnit(_unit)) _unit = 'kg';
    });
  }

  bool _isWeightUnit(String? value) =>
      value == 'kg' || value == 'lb' || value == 'stone';

  @override
  void dispose() {
    _reps.dispose();
    _weight.dispose();
    _body.dispose();
    _distance.dispose();
    _minutes.dispose();
    _seconds.dispose();
    _incline.dispose();
    _name.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsState>().value;

    getExerciseSetsByIds(db, widget.ids).then((allSets) {
      final exerciseSets = allSets.take(3).toList();
      if (exerciseSets.isEmpty) return;
      setState(() {
        _cardio = exerciseSets.first.cardio;
        final units = exerciseSets
            .map((exerciseSet) => exerciseSet.unit)
            .toSet();
        _unit = units.length == 1 ? units.single : null;
        _oldNames = exerciseSets
            .map((exerciseSet) => exerciseSet.name)
            .join(', ');
        _oldReps = exerciseSets
            .map((exerciseSet) => exerciseSet.reps)
            .join(', ');
        _oldWeights = exerciseSets
            .map((exerciseSet) => exerciseSet.weight)
            .join(', ');
        _oldBody = exerciseSets
            .map((exerciseSet) => exerciseSet.bodyWeight)
            .join(', ');
        if (settings.longDateFormat == 'timeago')
          _oldCreated = exerciseSets
              .map(
                (exerciseSet) =>
                    formatRelativeTime(context, exerciseSet.created),
              )
              .join(', ');
        else
          _oldCreated = exerciseSets
              .map(
                (exerciseSet) => formatDisplayDate(
                  context,
                  exerciseSet.created,
                  settings.longDateFormat,
                ),
              )
              .join(', ');
        _oldDist = exerciseSets
            .map((exerciseSet) => exerciseSet.distance)
            .join(', ');
        _oldMin = exerciseSets
            .map((exerciseSet) => exerciseSet.duration.floor())
            .join(', ');
        _oldSec = exerciseSets
            .map((exerciseSet) => ((exerciseSet.duration * 60) % 60).floor())
            .join(', ');
        final incs = exerciseSets
            .map((exerciseSet) => exerciseSet.incline)
            .whereType<int>()
            .join(', ');
        _oldInc = incs.isEmpty ? null : incs;
        final cats = exerciseSets
            .map((exerciseSet) => exerciseSet.category)
            .whereType<String>()
            .join(', ');
        _oldCat = cats.isEmpty ? null : cats;
      });
    });
  }

  Future<void> selectTime(DateTime pickedDate) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_created ?? DateTime.now()),
    );

    if (pickedTime != null && mounted) {
      _markDirty();
      setState(() {
        _created = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  Future<void> save() async {
    if (!_key.currentState!.validate()) return;

    _category = _category?.trim();
    if (_category?.isEmpty ?? false) _category = null;
    final reps = _reps.text.isEmpty
        ? null
        : parseDisplayNumber(context, _reps.text);
    final weight = _weight.text.isEmpty
        ? null
        : parseDisplayNumber(context, _weight.text);
    final bodyWeight = _body.text.isEmpty
        ? null
        : parseDisplayNumber(context, _body.text);
    final distance = _distance.text.isEmpty
        ? null
        : parseDisplayNumber(context, _distance.text);
    if (_category != null) await createCategory(_category!);

    final selected = await getExerciseSetsByIds(db, widget.ids);

    final changesExercise =
        _name.text.isNotEmpty ||
        _unit != null ||
        _cardio != null ||
        _restMs != null ||
        _category != null;

    for (final original in selected) {
      final name = _name.text.isNotEmpty ? _name.text : original.name;
      final unit = _unit ?? original.unit;
      final cardio = _cardio ?? original.cardio;
      final restMs = _restMs ?? original.restMs;
      final category = _category ?? original.category;

      final exercise = changesExercise
          ? await syncExerciseDefinition(
              name: name,
              cardio: cardio,
              displayUnit: unit,
              category: category,
              image: original.image,
              defaultRestDurationMs: restMs,
            )
          : await getExerciseByName(original.name);
      if (exercise == null) continue;

      final updated = original.copyWith(
        name: name,
        unit: unit,
        created: _created ?? original.created,
        cardio: cardio,
        restMs: Value(restMs),
        reps: reps ?? original.reps,
        weight: weight ?? original.weight,
        bodyWeight: bodyWeight ?? original.bodyWeight,
        distance: distance ?? original.distance,
        duration: _seconds.text.isEmpty && _minutes.text.isEmpty
            ? original.duration
            : (int.tryParse(_seconds.text) ?? 0) / 60 +
                  (int.tryParse(_minutes.text) ?? 0),
        incline: _incline.text.isEmpty
            ? Value(original.incline)
            : Value(int.tryParse(_incline.text)),
        category: Value(category),
      );

      await updateExerciseSet(
        db,
        id: original.id,
        exerciseSet: updated,
        exerciseId: exercise.id,
      );
    }

    if (!mounted) return;
    _allowPop = true;
    Navigator.pop(context);
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _created,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      selectTime(pickedDate);
    }
  }
}
