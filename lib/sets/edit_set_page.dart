import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart' hide Column;
import 'package:file_picker/file_picker.dart';
import 'package:flexify/animated_fab.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/body_weight_repository.dart';
import 'package:flexify/database/categories.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_catalog.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/logging.dart';
import 'package:flexify/main.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/settings/category_management_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/stepper_field.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flexify/utils.dart';
import 'package:flexify/platform_page_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditSetPage extends StatefulWidget {
  final ExerciseSetView exerciseSet;

  const EditSetPage({super.key, required this.exerciseSet});

  @override
  createState() => _EditSetPageState();
}

class _EditSetPageState extends State<EditSetPage> {
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
  final _orm = TextEditingController();
  final _body = TextEditingController();
  final _distance = TextEditingController();
  final _minutes = TextEditingController();
  final _seconds = TextEditingController();
  final _incline = TextEditingController();
  final _notes = TextEditingController();
  final _repsNode = FocusNode();
  final _distNode = FocusNode();
  final _key = GlobalKey<FormState>();

  var _categoryCtrl = TextEditingController();
  DateTime _created = DateTime.now().toLocal();
  TextEditingController? _nameCtrl;
  List<String> _options = [];
  int? restMs;
  String? _image;
  String? _category;
  bool _ormUpdateScheduled = false;

  late String _unit;
  late bool _cardio;
  late String _name;

  void onSelected(String option, bool showBodyWeight) async {
    _markDirty();
    final last = await getLatestExerciseSet(db, exerciseName: option);
    if (last == null) {
      final definition = await getExerciseByName(option);
      final categoryName = definition == null
          ? null
          : await getExerciseCategoryName(definition);
      if (!mounted) return;
      return setState(() {
        _name = option;
        if (definition != null) {
          _cardio = definition.kind == 'cardio';
          _unit = definition.displayUnit;
          _category = categoryName;
          _image = definition.image;
          restMs = definition.defaultRestDurationMs;
          if (categoryName != null && categoryName.isNotEmpty) {
            _categoryCtrl.text = categoryName;
          }
        }
      });
    }

    if (!mounted) return;
    if (showBodyWeight) {
      final bodyWeight = await getBodyWeight();
      if (!mounted) return;
      updateFields(
        bodyWeight == null
            ? last
            : last.copyWith(
                bodyWeight: displayBodyWeight(last.unit, bodyWeight.weightKg),
              ),
      );
    } else {
      updateFields(last.copyWith(bodyWeight: 0));
    }

    if (_cardio) {
      _distNode.requestFocus();
      selectAll(_distance);
    } else {
      _repsNode.requestFocus();
      selectAll(_reps);
    }
  }

  @override
  Widget build(BuildContext context) {
    final showBodyWeight = context.select<SettingsState, bool>(
      (settings) => settings.value.showBodyWeight,
    );

    return PopScope(
      canPop: _allowPop || !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop || _allowPop || !_hasUnsavedChanges) return;
        unawaited(_confirmDiscard(result));
      },
      child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: buildAppBar(),
      body: buildBody(showBodyWeight),
      floatingActionButton: buildSaveButton(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        widget.exerciseSet.id > 0
            ? widget.exerciseSet.name
            : context.l10n.addSet,
      ),
      actions: [if (widget.exerciseSet.id > 0) buildDeleteButton()],
    );
  }

  Widget buildDeleteButton() {
    return IconButton(
      tooltip: context.l10n.deleteSet,
      icon: const Icon(Icons.delete),
      onPressed: () => showDeleteDialog(),
    );
  }

  Future<void> showDeleteDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(context.l10n.confirmDelete),
          content: Text(
            context.l10n.deleteSetConfirmation(widget.exerciseSet.name),
          ),
          actions: [
            TextButton.icon(
              label: Text(context.l10n.actionCancel),
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            TextButton.icon(
              label: Text(context.l10n.actionDelete),
              icon: const Icon(Icons.delete),
              onPressed: () async {
                Navigator.pop(dialogContext);
                await deleteExerciseSets(db, [widget.exerciseSet.id]);
                if (!mounted) return;
                _allowPop = true;
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildBody(bool showBodyWeight) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _key,
        child: Consumer<SettingsState>(
          builder: (context, settingsState, child) {
            final settings = settingsState.value;
            final showUnits = settings.showUnits;
            final showCategories = settings.showCategories;
            final showNotes = settings.showNotes;
            final showImages = settings.showImages;

            return ListView(
              children: [
                autocomplete(showBodyWeight),
                const SizedBox(height: 12.0),
                ...exerciseFields(),
                const SizedBox(height: 12.0),
                if (showBodyWeight) ...[
                  bodyFields(showBodyWeight),
                  const SizedBox(height: 12.0),
                ],
                if (showUnits) ...[
                  unitSelector(),
                  const SizedBox(height: 12.0),
                ],
                if (showCategories) ...[categorySelector()],
                if (showNotes) ...[notesField(), const SizedBox(height: 12.0)],
                dateSelector(),
                ListTile(
                  title: Text(context.l10n.cardio),
                  leading: _cardio
                      ? const Icon(Icons.sports_gymnastics)
                      : const Icon(Icons.fitness_center),
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    _markDirty();
                    setState(() {
                    _cardio = !_cardio;
                    });
                  },
                  trailing: Switch(
                    value: _cardio,
                    onChanged: (value) {
                      _markDirty();
                      setState(() {
                      _cardio = value;
                      });
                    },
                  ),
                ),
                if (showImages) ...[const SizedBox(height: 8.0), imageField()],
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> exerciseFields() {
    if (_cardio) return buildCardioFields();
    return buildStrengthFields();
  }

  List<Widget> buildStrengthFields() {
    return [
      buildRepsField(),
      const SizedBox(height: 12.0),
      buildWeightField(),
      const SizedBox(height: 12.0),
      buildORMField(),
    ];
  }

  Widget buildRepsField() {
    return StepperField(
      controller: _reps,
      focusNode: _repsNode,
      labelText: context.l10n.repsLabel,
      step: 1,
      onChanged: (value) {
        _markDirty();
        setORM();
      },
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => selectAll(_weight),
      validator: (value) {
        if (value == null || value.isEmpty) return context.l10n.requiredField;
        if (parseDisplayNumber(context, value) == null)
          return context.l10n.invalidNumber;
        return null;
      },
    );
  }

  Widget buildWeightField() {
    return StepperField(
      controller: _weight,
      labelText: context.l10n.weightWithUnit(_unit),
      step: weightStep(_name, _unit),
      onFieldSubmitted: (value) => save(),
      onChanged: (value) {
        _markDirty();
        setORM();
      },
      validator: (value) {
        if (value == null || value.isEmpty) return context.l10n.requiredField;
        if (parseDisplayNumber(context, value) == null)
          return context.l10n.invalidNumber;
        return null;
      },
    );
  }

  Widget buildORMField() {
    return TextField(
      controller: _orm,
      decoration: InputDecoration(labelText: context.l10n.oneRepMaxEstimate),
      enabled: false,
    );
  }

  List<Widget> buildCardioFields() {
    return [
      SizedBox(height: 12.0),
      buildDistanceField(),
      SizedBox(height: 12.0),
      duration(),
      SizedBox(height: 12.0),
      buildInclineField(),
    ];
  }

  Widget buildDistanceField() {
    if (_unit == 'kg' || _unit == 'lb' || _unit == 'stone')
      return buildWeightField();
    return TextFormField(
      controller: _distance,
      focusNode: _distNode,
      decoration: InputDecoration(
        labelText: _unit == 'kcal'
            ? context.l10n.amountWithUnit(_unit)
            : context.l10n.distanceWithUnit(_unit),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onTap: () => selectAll(_distance),
      onChanged: (_) => _markDirty(),
      onFieldSubmitted: (value) => selectAll(_minutes),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) return null;
        if (parseDisplayNumber(context, value) == null)
          return context.l10n.invalidNumber;
        return null;
      },
    );
  }

  Widget buildInclineField() {
    return TextFormField(
      controller: _incline,
      decoration: InputDecoration(labelText: context.l10n.inclinePercent),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onTap: () => selectAll(_incline),
      onChanged: (_) => _markDirty(),
      validator: (value) {
        if (value == null || value.isEmpty) return null;
        if (int.tryParse(value) == null) return context.l10n.invalidNumber;
        return null;
      },
    );
  }

  Widget bodyFields(bool showBodyWeight) {
    return Visibility(
      visible: showBodyWeight,
      child: TextFormField(
        controller: _body,
        decoration: InputDecoration(
          labelText: context.l10n.bodyWeightWithUnit(_unit),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onTap: () => selectAll(_body),
        onChanged: (_) => _markDirty(),
        validator: (value) {
          if (value == null) return null;
          if (value.isNotEmpty && parseDisplayNumber(context, value) == null)
            return context.l10n.invalidNumber;
          return null;
        },
      ),
    );
  }

  Widget unitSelector() {
    return Selector<SettingsState, bool>(
      builder: (context, showUnits, child) => Visibility(
        visible: showUnits,
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: context.l10n.unitLabel),
          initialValue: _unit,
          items: getUnitItems(context),
          onChanged: (String? newValue) {
            _markDirty();
            setState(() {
              _unit = newValue!;
            });
          },
        ),
      ),
      selector: (context, settings) => settings.value.showUnits,
    );
  }

  Widget categorySelector() {
    return Selector<SettingsState, bool>(
      selector: (context, settings) => settings.value.showCategories,
      builder: (context, showCategories, child) {
        if (!showCategories) {
          return const SizedBox();
        }

        return StreamBuilder(
          stream: getCategoriesStream(),
          builder: (context, snapshot) {
            return Autocomplete<String>(
              initialValue: TextEditingValue(
                text: widget.exerciseSet.category ?? "",
              ),
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (snapshot.data == null) return [];
                if (textEditingValue.text == '') {
                  return snapshot.data!;
                }
                return snapshot.data!.where((String option) {
                  return option.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  );
                });
              },
              onSelected: (String selection) {
                _markDirty();
                setState(() {
                  _category = selection;
                });
              },
              fieldViewBuilder:
                  (
                    BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted,
                  ) {
                    _categoryCtrl = textEditingController;
                    return TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: context.l10n.categoryLabel,
                        helperText: context.l10n.categoryHelper,
                        suffixIcon: IconButton(
                          tooltip: context.l10n.manageCategories,
                          icon: const Icon(Icons.settings),
                          onPressed: () => Navigator.of(context).push(
                            FlexPageRoute(
                              builder: (_) => const CategoryManagementPage(),
                            ),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        _markDirty();
                        setState(() {
                        _category = value.isNotEmpty ? value : null;
                        });
                      },
                    );
                  },
            );
          },
        );
      },
    );
  }

  Widget notesField() {
    return Selector<SettingsState, bool>(
      builder: (context, showNotes, child) => Visibility(
        visible: showNotes,
        child: TextField(
          maxLines: 3,
          decoration: InputDecoration(labelText: context.l10n.notesLabel),
          controller: _notes,
          onChanged: (_) => _markDirty(),
        ),
      ),
      selector: (context, settingsState) => settingsState.value.showNotes,
    );
  }

  Widget dateSelector() {
    return Selector<SettingsState, String>(
      builder: (context, longDateFormat, child) => ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(context.l10n.createdDate),
        subtitle: Text(
          longDateFormat == 'timeago'
              ? formatRelativeTime(context, _created)
              : formatDisplayDate(context, _created, longDateFormat),
        ),
        trailing: const Icon(Icons.calendar_today),
        onTap: () => selectDate(),
      ),
      selector: (context, settings) => settings.value.longDateFormat,
    );
  }

  Widget buildSaveButton() {
    return AnimatedFab(
      onPressed: save,
      label: Text(context.l10n.actionSave),
      icon: const Icon(Icons.save),
    );
  }

  Selector<SettingsState, bool> imageField() {
    return Selector<SettingsState, bool>(
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
                    onLongPress: isDesktopLayout(context)
                        ? null
                        : () {
                            _markDirty();
                            setState(() {
                            _image = null;
                            });
                          },
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
                if (isDesktopLayout(context))
                  TextButton.icon(
                    onPressed: () {
                      _markDirty();
                      setState(() {
                      _image = null;
                      });
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: Text(context.l10n.actionRemove),
                  ),
              ],
            ],
          ),
        );
      },
      selector: (context, settings) => settings.value.showImages,
    );
  }

  Row duration() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _minutes,
            decoration: InputDecoration(labelText: context.l10n.minutesLabel),
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            onTap: () => selectAll(_minutes),
            onChanged: (_) => _markDirty(),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) => selectAll(_seconds),
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              if (int.tryParse(value) == null)
                return context.l10n.invalidNumber;
              return null;
            },
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: TextFormField(
            controller: _seconds,
            decoration: InputDecoration(labelText: context.l10n.secondsLabel),
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            onTap: () => selectAll(_seconds),
            onChanged: (_) => _markDirty(),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) => selectAll(_incline),
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              if (int.tryParse(value) == null)
                return context.l10n.invalidNumber;
              return null;
            },
          ),
        ),
      ],
    );
  }

  Autocomplete<String> autocomplete(bool showBodyWeight) {
    return Autocomplete<String>(
      optionsBuilder: (textEditingValue) {
        final searchTerms = textEditingValue.text
            .toLowerCase()
            .split(" ")
            .where((term) => term.isNotEmpty);
        Iterable<String> opts = _options;

        for (final term in searchTerms) {
          opts = opts.where((option) => option.toLowerCase().contains(term));
        }
        return opts;
      },
      onSelected: (option) => onSelected(option, showBodyWeight),
      initialValue: TextEditingValue(text: _name),
      fieldViewBuilder:
          (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            _nameCtrl = textEditingController;
            return TextFormField(
              decoration: InputDecoration(labelText: context.l10n.nameLabel),
              controller: textEditingController,
              textInputAction: TextInputAction.next,
              onTap: () {
                selectAll(textEditingController);
              },
              focusNode: focusNode,
              onFieldSubmitted: (String value) {
                onFieldSubmitted();
              },
              onChanged: (value) {
                _markDirty();
                setState(() {
                _name = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty)
                  return context.l10n.requiredField;
                return null;
              },
            );
          },
    );
  }

  @override
  void dispose() {
    _reps.dispose();
    _repsNode.dispose();
    _weight.dispose();
    _orm.dispose();
    _body.dispose();
    _distance.dispose();
    _distNode.dispose();
    _minutes.dispose();
    _seconds.dispose();
    _incline.dispose();
    _notes.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ormUpdateScheduled) return;
    _ormUpdateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setORM();
    });
  }

  @override
  void initState() {
    super.initState();

    updateFields(widget.exerciseSet, formatOrm: false, rebuild: false);
    _created = widget.exerciseSet.created;

    getExerciseNames().then((names) {
      if (!mounted) return;
      _options = names;
    });
  }

  void pick() async {
    final result = await FilePicker.pickFiles();
    final path = result?.files.single.path;
    if (path == null || !mounted) return;

    _markDirty();
    setState(() {
      _image = path;
    });
  }

  Future<void> save() async {
    if (!_key.currentState!.validate()) return;

    _category = _category?.trim();
    if (_category?.isEmpty ?? false) _category = null;

    final exerciseSet = widget.exerciseSet.copyWith(
      name: _name,
      unit: _unit,
      created: _created,
      reps: parseDisplayNumber(context, _reps.text),
      weight: parseDisplayNumber(context, _weight.text),
      bodyWeight: parseDisplayNumber(context, _body.text),
      distance: parseDisplayNumber(context, _distance.text),
      duration:
          (int.tryParse(_seconds.text) ?? 0) / 60 +
          (int.tryParse(_minutes.text) ?? 0),
      cardio: _cardio,
      restMs: Value(restMs),
      incline: Value(int.tryParse(_incline.text)),
      image: Value(_image),
      notes: Value(_notes.text),
      category: Value(_category),
    );

    if (_category != null) await createCategory(_category!);
    final exerciseDefinition = await syncExerciseDefinition(
      name: _name,
      cardio: _cardio,
      displayUnit: _unit,
      category: _category,
      image: _image,
      defaultRestDurationMs: restMs,
    );
    if (!mounted) return;

    final settings = context.read<SettingsState>().value;
    final messages = positiveReinforcementMessages(context.l10n);

    if (widget.exerciseSet.id > 0) {
      await updateExerciseSet(
        db,
        id: widget.exerciseSet.id,
        exerciseSet: exerciseSet,
        exerciseId: exerciseDefinition.id,
      );
      if (!mounted) return;
      talker.info('Updated workout set');
      _allowPop = true;
      return Navigator.of(context).pop();
    }

    final inserted = await insertExerciseSet(
      db,
      exerciseSet: exerciseSet,
      exerciseId: exerciseDefinition.id,
    );
    talker.info('Created workout set');

    if (settings.notifications) {
      final best = await isBestExerciseSet(db, inserted);
      if (best) {
        final random = Random();
        final randomMessage = messages[random.nextInt(messages.length)];
        if (mounted) toast(randomMessage);
      }
    }

    if (!settings.restTimers && mounted) {
      _allowPop = true;
      return Navigator.of(context).pop();
    }
    if (!mounted) return;
    final timer = context.read<TimerState>();
    if (restMs != null)
      timer.startTimer(
        _name,
        Duration(milliseconds: restMs!),
        settings.alarmSound,
        settings.vibrate,
        settings.enableSound,
        'history',
        settings.keepRinging,
      );
    else
      timer.startTimer(
        _name,
        Duration(milliseconds: settings.timerDuration),
        settings.alarmSound,
        settings.vibrate,
        settings.enableSound,
        'history',
        settings.keepRinging,
      );
    if (!mounted) return;
    _allowPop = true;
    return Navigator.of(context).pop();
  }

  Future<void> selectTime(DateTime pickedDate) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_created),
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

  void setORM() {
    final parsedReps = parseDisplayNumber(context, _reps.text);
    final parsedWeight = parseDisplayNumber(context, _weight.text);
    if (parsedReps == null || parsedWeight == null) return;
    final estimate = parsedReps > 0
        ? parsedWeight / (1.0278 - (0.0278 * parsedReps))
        : parsedWeight * (1.0278 - (0.0278 * parsedReps));
    _orm.text =
        "${formatDisplayNumber(context, estimate, minimumFractionDigits: 2)} $_unit";
  }

  List<DropdownMenuItem<String>> getUnitItems(BuildContext context) {
    return [
      ...strengthUnitMenuItems(context.l10n),
      ...cardioUnitMenuItems(context.l10n),
    ];
  }

  void updateFields(
    ExerciseSetView exerciseSet, {
    bool formatOrm = true,
    bool rebuild = true,
  }) {
    _nameCtrl?.text = exerciseSet.name;
    void updateState() {
      _category = exerciseSet.category;
      _image = exerciseSet.image;
      _name = exerciseSet.name;
      _unit = exerciseSet.unit;
      _cardio = exerciseSet.cardio;
      restMs = exerciseSet.restMs;
    }

    if (rebuild) {
      setState(updateState);
    } else {
      updateState();
    }

    if (exerciseSet.reps != 0) _reps.text = toString(exerciseSet.reps);
    _weight.text = toString(exerciseSet.weight);
    if (formatOrm) setORM();
    if (exerciseSet.bodyWeight != 0)
      _body.text = toString(exerciseSet.bodyWeight);
    if (exerciseSet.duration != 0) {
      _minutes.text = exerciseSet.duration.floor().toString();
      _seconds.text = ((exerciseSet.duration * 60) % 60).floor().toString();
    }
    if (exerciseSet.distance != 0)
      _distance.text = toString(exerciseSet.distance);
    if (exerciseSet.incline != null && exerciseSet.incline != 0)
      _incline.text = exerciseSet.incline.toString();
    if (exerciseSet.category != null && exerciseSet.category!.isNotEmpty)
      _categoryCtrl.text = exerciseSet.category!;
    _notes.text = exerciseSet.notes ?? '';
  }

  Future<void> selectDate() async {
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
