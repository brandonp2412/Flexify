import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan_state.dart';
import 'package:flutter/material.dart' as material;
import 'package:drift/drift.dart';
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
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameNode.requestFocus();
  }

  @override
  dispose() {
    _nameNode.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<int> getCount() async {
    final result = await (db.gymSets.selectOnly()
          ..addColumns([db.gymSets.name.count()])
          ..where(db.gymSets.name.equals(_nameController.text)))
        .getSingle();
    return result.read(db.gymSets.name.count()) ?? 0;
  }

  Future<void> doUpdate() async {
    await (db.gymSets.update()..where((tbl) => tbl.name.equals(widget.name)))
        .write(GymSetsCompanion(name: Value(_nameController.text)));
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
        title: Text(widget.name),
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
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (widget.name == _nameController.text ||
              _nameController.text.isEmpty) {
            Navigator.pop(context);
            return;
          }

          final count = await getCount();
          if (!context.mounted) return;
          if (count == 0)
            await doUpdate();
          else {
            showDialog(
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
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Confirm'),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await doUpdate();
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
