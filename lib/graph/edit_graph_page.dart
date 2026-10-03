import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flexify/animated_fab.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/exercise_analytics.dart';
import 'package:flexify/database/exercise_catalog.dart';
import 'package:flexify/database/categories.dart';
import 'package:flexify/l10n/l10n.dart';
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

  bool? cardio;
  int? _exerciseId;
  String? unit;
  String? image;
  String? category;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _allowPop || !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop || _allowPop || !_hasUnsavedChanges) return;
        unawaited(_confirmDiscard(result));
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(context.l10n.updateAllNamed(widget.name.toLowerCase())),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: key,
            child: ListView(
              padding: const EdgeInsets.only(bottom: 116),
              children: [
                const SizedBox(height: 8.0),
                TextField(
                  controller: name,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: context.l10n.newName),
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (_) => _markDirty(),
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: minutes,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: context.l10n.restMinutes,
                        ),
                        keyboardType: TextInputType.number,
                        onTap: () => selectAll(minutes),
                        onChanged: (_) => _markDirty(),
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
                        controller: seconds,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: context.l10n.restSeconds,
                        ),
                        keyboardType: TextInputType.number,
                        onTap: () {
                          selectAll(seconds);
                        },
                        onChanged: (_) => _markDirty(),
                        validator: (value) {
                          if (value == null || value.isEmpty) return null;
                          if (int.tryParse(value) == null)
                            return context.l10n.invalidNumber;
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Selector<SettingsState, bool>(
                  selector: (p0, settings) => settings.value.showCategories,
                  builder: (context, showCategories, child) {
                    if (!showCategories) return const SizedBox();
                    return StreamBuilder(
                      stream: getCategoriesStream(),
                      builder: (context, snapshot) {
                        final categories = <String>{
                          if (category != null && category!.isNotEmpty)
                            category!,
                          ...?snapshot.data,
                        }.toList();
                        return Column(
                          children: [
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: context.l10n.categoryLabel,
                              ),
                              initialValue: category,
                              items: categories
                                  .map(
                                    (category) => DropdownMenuItem(
                                      value: category,
                                      child: Text(category),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                _markDirty();
                                setState(() {
                                  category = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 12.0),
                          ],
                        );
                      },
                    );
                  },
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: context.l10n.unitLabel,
                  ),
                  initialValue: unit,
                  items: [
                    const DropdownMenuItem(value: null, child: Text("")),
                    ...strengthUnitMenuItems(context.l10n),
                    ...cardioUnitMenuItems(context.l10n),
                  ],
                  onChanged: (value) {
                    _markDirty();
                    setState(() {
                      unit = value;
                    });
                  },
                ),
                if (cardio != null) ...[
                  const SizedBox(height: 12.0),
                  ListTile(
                    leading: cardio!
                        ? const Icon(Icons.sports_gymnastics)
                        : const Icon(Icons.fitness_center),
                    title: Text(
                      cardio! ? context.l10n.cardio : context.l10n.strength,
                    ),
                    onTap: () => _setCardio(!cardio!),
                    trailing: Switch(value: cardio!, onChanged: _setCardio),
                  ),
                  const SizedBox(height: 12.0),
                ] else
                  const SizedBox(height: 12.0),
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
                                label: Text(context.l10n.imageLabel),
                                icon: const Icon(Icons.image),
                              ),
                              if (image != null)
                                TextButton.icon(
                                  onPressed: () {
                                    _markDirty();
                                    setState(() {
                                      image = null;
                                    });
                                  },
                                  label: Text(context.l10n.actionDelete),
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
                                    label: Text(context.l10n.imageError),
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
          label: Text(context.l10n.actionUpdate),
          icon: const Icon(Icons.sync),
        ),
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
        int.tryParse(seconds.text) != null && int.tryParse(seconds.text)! > 0) {
      duration = Duration(
        minutes: int.tryParse(minutes.text) ?? 0,
        seconds: int.tryParse(seconds.text) ?? 0,
      );
    }

    final exerciseId =
        _exerciseId ?? (await getExerciseByName(widget.name))?.id;
    if (exerciseId == null || cardio == null || unit == null) return;

    await updateExerciseDefinition(
      exerciseId: exerciseId,
      name: name.text.isEmpty ? widget.name : name.text,
      cardio: cardio!,
      displayUnit: unit!,
      defaultRestDurationMs: duration?.inMilliseconds,
      image: image,
      category: category,
    );
  }

  Future<int> getCount() => countGraphSets([name.text]);

  @override
  void initState() {
    super.initState();

    getExerciseByName(widget.name).then((exercise) async {
      if (exercise == null || !mounted) return;
      final categoryName = await getExerciseCategoryName(exercise);
      if (!mounted) return;
      setState(() {
        _exerciseId = exercise.id;
        image = exercise.image;
        cardio = exercise.kind == 'cardio';
        unit = exercise.displayUnit;
        category = categoryName;

        if (exercise.defaultRestDurationMs != null) {
          final duration = Duration(
            milliseconds: exercise.defaultRestDurationMs!,
          );
          minutes.text = duration.inMinutes.toString();
          seconds.text = (duration.inSeconds % 60).toString();
        }
      });
    });
  }

  void pick() async {
    final result = await FilePicker.pickFiles();
    final path = result?.files.single.path;
    if (path == null || !mounted) return;

    _markDirty();
    setState(() {
      image = path;
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
                label: Text(context.l10n.actionCancel),
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(dialogContext, false),
              ),
              TextButton.icon(
                label: Text(context.l10n.actionConfirm),
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
    final l10n = context.l10n;

    final count = await getCount();
    if (count > 0 && widget.name != name.text) {
      final confirmed = await confirmUpdate(
        l10n.updateConflict,
        l10n.updateConflictDescription(count),
      );
      if (!confirmed) return;
    }

    await doUpdate();

    if (!mounted) return;
    _allowPop = true;
    Navigator.pop(context, name.text);
  }

  void _setCardio(bool value) {
    _markDirty();
    setState(() {
      cardio = value;
      if (!value && unit != null && !_isWeightUnit(unit!)) unit = 'kg';
    });
  }

  bool _isWeightUnit(String value) =>
      value == 'kg' || value == 'lb' || value == 'stone';
}
