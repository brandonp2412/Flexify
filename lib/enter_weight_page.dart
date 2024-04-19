import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;

class EnterWeightPage extends StatefulWidget {
  const EnterWeightPage({super.key});

  @override
  createState() => _EnterWeightPageState();
}

class _EnterWeightPageState extends State<EnterWeightPage> {
  final TextEditingController _valueController = TextEditingController();
  String _yesterdaysWeight = "";
  String _unit = 'kg'; // Default unit
  final List<String> _units = ['kg', 'lb']; // Available units

  @override
  void initState() {
    super.initState();
    getBodyWeight().then((value) => setState(() {
          _yesterdaysWeight = "${value?.weight ?? 0} ${value?.unit ?? 'kg'}";
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Weight')),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _valueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Weight'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter weight' : null,
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
                controller: TextEditingController(text: _yesterdaysWeight),
                decoration: const InputDecoration(labelText: 'Previous weight'),
                enabled: false,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.pop(context);
          db.gymSets.insertOne(GymSetsCompanion.insert(
              created: DateTime.now(),
              name: "Weight",
              reps: 1,
              unit: _unit,
              weight: double.parse(_valueController.text)));
          (db.gymSets.update()..where((tbl) => tbl.bodyWeight.equals(0))).write(
              GymSetsCompanion(
                  bodyWeight:
                      drift.Value(double.parse(_valueController.text))));
        },
        tooltip: "Save today's weight",
        child: const Icon(Icons.save),
      ),
    );
  }
}
