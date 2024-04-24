import 'package:drift/drift.dart';
import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan_state.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditGraphPage extends StatefulWidget {
  final String name;

  const EditGraphPage({required this.name, super.key});

  @override
  createState() => _EditGraphPageState();
}

class _EditGraphPageState extends State<EditGraphPage> {
  final _nameNode = FocusNode();
  late TextEditingController _nameController;
  bool _cardio = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    (db.gymSets.select()
          ..where((tbl) => tbl.name.equals(widget.name))
          ..limit(1))
        .getSingle()
        .then((value) => setState(() {
              _cardio = value.cardio;
            }));
  }

  @override
  dispose() {
    _nameNode.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<int> _getCount() async {
    final result = await (db.gymSets.selectOnly()
          ..addColumns([db.gymSets.name.count()])
          ..where(db.gymSets.name.equals(_nameController.text)))
        .getSingle();
    return result.read(db.gymSets.name.count()) ?? 0;
  }

  Future<void> _doUpdate() async {
    await (db.gymSets.update()..where((tbl) => tbl.name.equals(widget.name)))
        .write(GymSetsCompanion(
            name: Value(_nameController.text), cardio: Value(_cardio)));
    await db.customUpdate(
      'UPDATE plans SET exercises = REPLACE(exercises, ?, ?)',
      variables: [
        Variable.withString(widget.name),
        Variable.withString(_nameController.text)
      ],
      updates: {db.plans},
    );
    if (mounted) context.read<PlanState>().updatePlans(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.name.toLowerCase()}"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: material.Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              focusNode: _nameNode,
              decoration: const InputDecoration(labelText: "New name"),
              textCapitalization: TextCapitalization.sentences,
            ),
            ListTile(
              title: const Text('Cardio'),
              onTap: () {
                setState(() {
                  _cardio = !_cardio;
                });
              },
              trailing: Switch(
                value: _cardio,
                onChanged: (value) => setState(() {
                  _cardio = value;
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_nameController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Name cannot be empty.')),
            );
            Navigator.pop(context);
            return;
          }

          final count = await _getCount();

          if (!context.mounted) return;
          if (count == 0 || widget.name == _nameController.text)
            await _doUpdate();
          else {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Update conflict'),
                  content: Text(
                      'Your new name exists already for $count records. Are you sure?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Text('Confirm'),
                      onPressed: () async {
                        Navigator.pop(context);
                        await _doUpdate();
                      },
                    ),
                  ],
                );
              },
            );
          }

          if (!context.mounted) return;
          Navigator.pop(context);
          Navigator.pop(context);
        },
        tooltip: "Update all records for this exercise",
        child: const Icon(Icons.save),
      ),
    );
  }
}
