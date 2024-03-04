import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart' as material;
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

class EditGraphPage extends StatefulWidget {
  final String name;

  const EditGraphPage({required this.name, super.key});

  @override
  createState() => _EditGraphPageState();
}

class _EditGraphPageState extends State<EditGraphPage> {
  final nameNode = FocusNode();
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameNode.requestFocus();
  }

  @override
  dispose() {
    nameNode.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<int> getCount() async {
    final result = await (database.gymSets.selectOnly()
          ..addColumns([database.gymSets.name.count()])
          ..where(database.gymSets.name.equals(nameController.text)))
        .getSingle();
    return result.read(database.gymSets.name.count()) ?? 0;
  }

  Future<void> doUpdate() {
    return (database.gymSets.update()
          ..where((tbl) => tbl.name.equals(widget.name)))
        .write(GymSetsCompanion(name: Value(nameController.text)));
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
              controller: nameController,
              focusNode: nameNode,
              decoration: const InputDecoration(labelText: "New name"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (widget.name == nameController.text ||
              nameController.text.isEmpty) {
            Navigator.pop(context);
            return;
          }

          final count = await getCount();
          if (count > 0) {
            if (!mounted) return;
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
          } else
            await doUpdate();

          if (!mounted) return;
          Navigator.pop(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
