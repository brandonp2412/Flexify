import 'package:drift/drift.dart';
import 'package:flexify/animated_fab.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class EditSetsPage extends StatefulWidget {
  final List<int> ids;

  const EditSetsPage({super.key, required this.ids});

  @override
  createState() => _EditSetsPageState();
}

class _EditSetsPageState extends State<EditSetsPage> {
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
    return Scaffold(
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
                          await db.gymSets.deleteWhere(
                            (u) => u.id.isIn(widget.ids),
                          );
                          if (context.mounted) Navigator.pop(context);
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
              ),
              ListTile(
                title: Text(l10n.cardio),
                leading: _cardio == true
                    ? const Icon(Icons.sports_gymnastics)
                    : const Icon(Icons.fitness_center),
                contentPadding: EdgeInsets.zero,
                onTap: () => setState(() {
                  _setCardio(!(_cardio ?? false));
                }),
                trailing: Switch(
                  value: _cardio ?? false,
                  onChanged: (value) => setState(() {
                    _setCardio(value);
                  }),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      if (double.tryParse(value) == null)
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
                    validator: (value) {
                      if (value == null) return null;
                      if (double.tryParse(value) == null)
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
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    if (double.tryParse(value) == null)
                      return l10n.invalidNumber;
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _weight,
                  decoration: InputDecoration(
                    labelText: _name.text == 'Weight'
                        ? l10n.valueLabel
                        : l10n.weightLabel,
                    hintText: _oldWeights,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onTap: () => selectAll(_weight),
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    if (double.tryParse(value) == null)
                      return l10n.invalidNumber;
                    return null;
                  },
                ),
              ],
              if (_name.text != 'Weight') const SizedBox(height: 12),
              if (_name.text != 'Weight')
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
                      validator: (value) {
                        if (value == null || value.isEmpty) return null;
                        if (double.tryParse(value) == null)
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
                selector: (context, settings) => settings.value.showCategories,
                builder: (context, showCategories, child) => Visibility(
                  visible: showCategories,
                  child: StreamBuilder(
                    stream: getCategoriesStream(),
                    builder: (context, snapshot) {
                      return DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: l10n.categoryLabel,
                          hintText: _oldCat,
                        ),
                        initialValue: _category,
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
                            _category = value!;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
              Selector<SettingsState, String>(
                builder: (context, longDateFormat, child) {
                  var subtitle = _oldCreated ?? "";

                  if (longDateFormat == 'timeago' && _created != null)
                    subtitle = timeago.format(_created!);
                  else if (longDateFormat != 'timeago' && _created != null)
                    subtitle = DateFormat(longDateFormat).format(_created!);

                  return ListTile(
                    title: Text(l10n.createdDate),
                    subtitle: Text(subtitle),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(),
                  );
                },
                selector: (context, settings) => settings.value.longDateFormat,
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
    _cardio = value;
    if (!value && !_isWeightUnit(_unit)) _unit = 'kg';
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

    (db.gymSets.select()
          ..where((u) => u.id.isIn(widget.ids))
          ..limit(3))
        .get()
        .then((gymSets) {
          setState(() {
            _cardio = gymSets.first.cardio;
            final units = gymSets.map((gymSet) => gymSet.unit).toSet();
            _unit = units.length == 1 ? units.single : null;
            _oldNames = gymSets.map((gymSet) => gymSet.name).join(', ');
            _oldReps = gymSets.map((gymSet) => gymSet.reps).join(', ');
            _oldWeights = gymSets.map((gymSet) => gymSet.weight).join(', ');
            _oldBody = gymSets.map((gymSet) => gymSet.bodyWeight).join(', ');
            if (settings.longDateFormat == 'timeago')
              _oldCreated = gymSets
                  .map((gymSet) => timeago.format(gymSet.created))
                  .join(', ');
            else
              _oldCreated = gymSets
                  .map(
                    (gymSet) => DateFormat(
                      settings.longDateFormat,
                    ).format(gymSet.created),
                  )
                  .join(', ');
            _oldDist = gymSets.map((gymSet) => gymSet.distance).join(', ');
            _oldMin = gymSets
                .map((gymSet) => gymSet.duration.floor())
                .join(', ');
            _oldSec = gymSets
                .map((gymSet) => ((gymSet.duration * 60) % 60).floor())
                .join(', ');
            final incs = gymSets
                .map((gymSet) => gymSet.incline)
                .whereType<int>()
                .join(', ');
            _oldInc = incs.isEmpty ? null : incs;
            final cats = gymSets
                .map((gymSet) => gymSet.category)
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

    Navigator.pop(context);

    final gymSet = GymSetsCompanion(
      name: _name.text.isNotEmpty ? Value(_name.text) : const Value.absent(),
      unit: Value.absentIfNull(_unit),
      created: Value.absentIfNull(_created),
      cardio: Value.absentIfNull(_cardio),
      restMs: Value.absentIfNull(_restMs),
      incline: Value.absentIfNull(int.tryParse(_incline.text)),
      reps: Value.absentIfNull(double.tryParse(_reps.text)),
      weight: Value.absentIfNull(double.tryParse(_weight.text)),
      bodyWeight: Value.absentIfNull(double.tryParse(_body.text)),
      distance: Value.absentIfNull(double.tryParse(_distance.text)),
      duration:
          int.tryParse(_seconds.text) == null &&
              int.tryParse(_minutes.text) == null
          ? const Value.absent()
          : Value(
              (int.tryParse(_seconds.text) ?? 0) / 60 +
                  (int.tryParse(_minutes.text) ?? 0),
            ),
      category: Value.absentIfNull(_category),
    );

    await (db.gymSets.update()..where((u) => u.id.isIn(widget.ids))).write(
      gymSet,
    );
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
