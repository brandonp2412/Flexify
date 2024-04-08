import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;

class EnterWeightPage extends StatefulWidget {
  const EnterWeightPage({super.key});

  @override
  createState() => _EnterWeightPageState();
}

class _EnterWeightPageState extends State<EnterWeightPage> {
  final _formKey = GlobalKey<FormState>();
  double _weight = 0;
  String yesterdaysWeight = "";
  String _unit = 'kg'; // Default unit
  final List<String> _units = ['kg', 'lb']; // Available units

  @override
  void initState() {
    super.initState();
    (db.gymSets.select()
          ..where((tbl) => tbl.name.equals('Weight'))
          ..orderBy(
            [
              (u) => drift.OrderingTerm(
                  expression: u.created, mode: drift.OrderingMode.desc)
            ],
          )
          ..limit(1))
        .getSingleOrNull()
        .then((value) {
      if (value == null) return;
      setState(
        () {
          yesterdaysWeight = "${value.weight} ${value.unit}";
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Weight')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Weight'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter weight' : null,
                onSaved: (value) {
                  setState(() {
                    _weight = double.parse(value!);
                  });
                },
                autofocus: true,
              ),
              DropdownButtonFormField<String>(
                value: _unit,
                decoration: const InputDecoration(labelText: 'Unit'),
                items: _units.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _unit = newValue!;
                  });
                },
              ),
              TextFormField(
                controller: TextEditingController(text: yesterdaysWeight),
                decoration: const InputDecoration(labelText: 'Previous weight'),
                enabled: false,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            db.gymSets.insertOne(GymSetsCompanion.insert(
                created: DateTime.now(),
                name: "Weight",
                reps: 1,
                unit: _unit,
                weight: _weight));
            Navigator.pop(context);
          }
        },
        tooltip: "Save today's weight",
        child: const Icon(Icons.save),
      ),
    );
  }
}
