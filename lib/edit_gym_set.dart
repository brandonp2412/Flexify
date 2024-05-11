import 'package:drift/drift.dart';
import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/timer_state.dart';
import 'package:flexify/unit_selector.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditGymSet extends StatefulWidget {
  final GymSet gymSet;

  const EditGymSet({super.key, required this.gymSet});

  @override
  createState() => _EditGymSetState();
}

class _EditGymSetState extends State<EditGymSet> {
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  final _bodyWeightController = TextEditingController();
  final _distanceController = TextEditingController();
  final _durationController = TextEditingController();
  late String _unit;
  late DateTime _created;
  late bool _cardio;
  late String _name;
  late SettingsState _settings;
  late int _restMs;

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
    super.dispose();
  }

  Future<void> _save() async {
    Navigator.pop(context);
    final gymSet = widget.gymSet.copyWith(
      name: _name,
      unit: _unit,
      created: _created,
      reps: double.parse(_repsController.text),
      weight: double.parse(_weightController.text),
      bodyWeight: double.parse(_bodyWeightController.text),
      distance: double.parse(_distanceController.text),
      duration: double.parse(_durationController.text),
      cardio: _cardio,
      restMs: _restMs,
    );

    if (widget.gymSet.id > 0)
      db.update(db.gymSets).replace(gymSet);
    else {
      db.into(db.gymSets).insert(gymSet.copyWith(id: null));
      final settings = context.read<SettingsState>();
      if (!settings.restTimers) return;
      final timer = context.read<TimerState>();
      timer.startTimer(_name, Duration(milliseconds: _restMs));
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
      _repsController.text = gymSet.reps.toString();
      _weightController.text = gymSet.weight.toString();
      _bodyWeightController.text = gymSet.bodyWeight.toString();
      _durationController.text = gymSet.duration.toString();
      _distanceController.text = gymSet.distance.toString();
      _unit = gymSet.unit;
      _created = DateTime.now();
      _cardio = gymSet.cardio;
      _restMs = gymSet.restMs;
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
        child: material.Column(
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
                final bodyWeight = await getBodyWeight();
                _updateFields(last.copyWith(bodyWeight: bodyWeight?.weight));
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
                  onTap: () {
                    textEditingController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: textEditingController.text.length,
                    );
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
                onTap: () => _distanceController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _distanceController.text.length,
                ),
              ),
              TextField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration'),
                keyboardType: TextInputType.number,
                onTap: () => _durationController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _durationController.text.length,
                ),
              ),
            ],
            if (!_cardio) ...[
              TextField(
                controller: _repsController,
                decoration: const InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
                onTap: () => _repsController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _repsController.text.length,
                ),
              ),
              TextField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText:
                      _name == 'Weight' ? 'Value ($_unit)' : 'Weight ($_unit)',
                ),
                keyboardType: TextInputType.number,
                onTap: () => _weightController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _weightController.text.length,
                ),
              ),
            ],
            if (_name != 'Weight')
              TextField(
                controller: _bodyWeightController,
                decoration: InputDecoration(labelText: 'Body weight ($_unit)'),
                keyboardType: TextInputType.number,
                onTap: () => _bodyWeightController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _bodyWeightController.text.length,
                ),
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
        child: const Icon(Icons.save),
      ),
    );
  }
}
