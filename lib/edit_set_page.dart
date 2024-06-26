import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flexify/unit_selector.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditSetPage extends StatefulWidget {
  final GymSet gymSet;

  const EditSetPage({super.key, required this.gymSet});

  @override
  createState() => _EditSetPageState();
}

class _EditSetPageState extends State<EditSetPage> {
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  final _bodyWeightController = TextEditingController();
  final _distanceController = TextEditingController();
  final _minutesController = TextEditingController();
  final _secondsController = TextEditingController();
  final _inclineController = TextEditingController();

  late String _unit;
  late DateTime _created;
  late bool _cardio;
  late String _name;
  late SettingsState _settings;
  int? _restMs;

  TextEditingController? _nameController;
  List<String> _nameOptions = [];

  @override
  void initState() {
    super.initState();
    _settings = context.read<SettingsState>();
    _updateFields(widget.gymSet);
    (db.gymSets.selectOnly(distinct: true)..addColumns([db.gymSets.name]))
        .get()
        .then((results) {
      final names = results.map((result) => result.read(db.gymSets.name)!);
      setState(() {
        _nameOptions = names.toList();
      });
    });
  }

  @override
  void dispose() {
    _repsController.dispose();
    _weightController.dispose();
    _bodyWeightController.dispose();
    _distanceController.dispose();
    _minutesController.dispose();
    _inclineController.dispose();

    super.dispose();
  }

  Future<void> _save() async {
    Navigator.pop(context);
    final minutes = int.tryParse(_minutesController.text);
    final seconds = int.tryParse(_secondsController.text);
    final duration = (seconds ?? 0) / 60 + (minutes ?? 0);

    final gymSet = widget.gymSet.copyWith(
      name: _name,
      unit: _unit,
      created: _created,
      reps: double.tryParse(_repsController.text),
      weight: double.tryParse(_weightController.text),
      bodyWeight: double.tryParse(_bodyWeightController.text),
      distance: double.tryParse(_distanceController.text),
      duration: duration,
      cardio: _cardio,
      restMs: Value(_restMs),
      incline: Value(int.tryParse(_inclineController.text)),
    );

    if (widget.gymSet.id > 0)
      db.update(db.gymSets).replace(gymSet);
    else {
      var insert = gymSet.toCompanion(false).copyWith(id: const Value.absent());
      db.into(db.gymSets).insert(insert);
      final settings = context.read<SettingsState>();
      if (!settings.restTimers || !platformSupportsTimer()) return;
      final timer = context.read<TimerState>();
      if (_restMs != null)
        timer.startTimer(
          _name,
          Duration(milliseconds: _restMs!),
          settings.alarmSound,
          settings.vibrate,
        );
      else
        timer.startTimer(
          _name,
          _settings.timerDuration,
          settings.alarmSound,
          settings.vibrate,
        );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _created,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      _selectTime(pickedDate);
    }
  }

  Future<void> _selectTime(DateTime pickedDate) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_created),
    );

    if (pickedTime != null) {
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

  void _updateFields(GymSet gymSet) {
    _nameController?.text = gymSet.name;

    setState(() {
      _name = gymSet.name;
      _repsController.text = toString(gymSet.reps);
      _weightController.text = toString(gymSet.weight);
      _bodyWeightController.text = toString(gymSet.bodyWeight);
      _minutesController.text = gymSet.duration.floor().toString();
      _secondsController.text =
          ((gymSet.duration * 60) % 60).floor().toString();
      _distanceController.text = toString(gymSet.distance);
      _unit = gymSet.unit;
      _created = gymSet.created;
      _cardio = gymSet.cardio;
      _restMs = gymSet.restMs;
      _inclineController.text = gymSet.incline?.toString() ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    _settings = context.watch<SettingsState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.gymSet.id > 0 ? 'Edit ${widget.gymSet.name}' : 'Add gym set',
        ),
        actions: [
          if (widget.gymSet.id > 0)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Confirm Delete'),
                      content: Text(
                        'Are you sure you want to delete ${widget.gymSet.name}?',
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                        ),
                        TextButton(
                          child: const Text('Delete'),
                          onPressed: () async {
                            Navigator.pop(dialogContext);
                            await db.delete(db.gymSets).delete(widget.gymSet);
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
        child: ListView(
          children: [
            Autocomplete<String>(
              optionsBuilder: (textEditingValue) {
                return _nameOptions.where(
                  (option) => option
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()),
                );
              },
              onSelected: (option) async {
                final last = await (db.gymSets.select()
                      ..where((tbl) => tbl.name.equals(option))
                      ..limit(1))
                    .getSingleOrNull();
                if (last == null) return;

                if (_settings.hideWeight)
                  _updateFields(
                    last.copyWith(
                      created: DateTime.now().toLocal(),
                    ),
                  );
                else {
                  final bodyWeight = await getBodyWeight();
                  _updateFields(
                    last.copyWith(
                      bodyWeight: bodyWeight?.weight,
                      created: DateTime.now().toLocal(),
                    ),
                  );
                }
              },
              initialValue: TextEditingValue(text: _name),
              fieldViewBuilder: (
                BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted,
              ) {
                _nameController = textEditingController;
                return TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  controller: textEditingController,
                  textInputAction: TextInputAction.next,
                  onTap: () {
                    selectAll(textEditingController);
                  },
                  focusNode: focusNode,
                  onFieldSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                  onChanged: (value) => setState(() {
                    _name = value;
                  }),
                );
              },
            ),
            if (_cardio) ...[
              TextField(
                controller: _distanceController,
                decoration: const InputDecoration(labelText: 'Distance'),
                keyboardType: TextInputType.number,
                onTap: () => selectAll(_distanceController),
                textInputAction: TextInputAction.next,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _minutesController,
                      decoration: const InputDecoration(labelText: 'Minutes'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      onTap: () => selectAll(_minutesController),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: _secondsController,
                      decoration: const InputDecoration(labelText: 'Seconds'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      onTap: () => selectAll(_secondsController),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _inclineController,
                decoration: const InputDecoration(labelText: 'Incline'),
                keyboardType: TextInputType.number,
                onTap: () => selectAll(_inclineController),
              ),
            ],
            if (!_cardio) ...[
              TextField(
                controller: _repsController,
                decoration: const InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
                onTap: () => selectAll(_repsController),
                textInputAction: TextInputAction.next,
              ),
              TextField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: _name == 'Weight' ? 'Value ' : 'Weight ',
                ),
                keyboardType: TextInputType.number,
                onTap: () => selectAll(_weightController),
                textInputAction: TextInputAction.next,
              ),
            ],
            if (_name != 'Weight' && !_settings.hideWeight)
              TextField(
                controller: _bodyWeightController,
                decoration: const InputDecoration(labelText: 'Body weight '),
                keyboardType: TextInputType.number,
                onTap: () => selectAll(_bodyWeightController),
              ),
            UnitSelector(
              value: _unit,
              onChanged: (String? newValue) {
                setState(() {
                  _unit = newValue!;
                });
              },
              cardio: _cardio,
            ),
            ListTile(
              title: const Text('Created Date'),
              subtitle:
                  Text(DateFormat(_settings.longDateFormat).format(_created)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _save,
        tooltip: "Save",
        child: const Icon(Icons.save),
      ),
    );
  }
}
