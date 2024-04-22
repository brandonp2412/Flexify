import 'package:drift/drift.dart' as drift;
import 'package:flexify/app_line_graph.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database.dart';
import 'package:flexify/graph_history.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewGraphPage extends StatefulWidget {
  final String name;
  const ViewGraphPage({super.key, required this.name});

  @override
  createState() => _ViewGraphPageState();
}

class _ViewGraphPageState extends State<ViewGraphPage> {
  Metric _metric = Metric.bestWeight;
  AppGroupBy _groupBy = AppGroupBy.day;
  String _targetUnit = 'kg';
  bool _editing = false;

  final _nameNode = FocusNode();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _editing
            ? TextField(
                focusNode: _nameNode,
                controller: _nameController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                onSubmitted: (value) => _saveName(),
              )
            : Text(widget.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_editing)
              setState(() {
                _editing = false;
              });
            else
              Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _editing = !_editing;
                });
                _nameNode.requestFocus();
                _nameController.selection = TextSelection(
                    baseOffset: 0, extentOffset: _nameController.text.length);
              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Visibility(
              visible: widget.name != "Weight",
              child: DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Metric'),
                value: _metric,
                items: const [
                  DropdownMenuItem(
                    value: Metric.bestWeight,
                    child: Text("Best weight"),
                  ),
                  DropdownMenuItem(
                    value: Metric.oneRepMax,
                    child: Text("One rep max"),
                  ),
                  DropdownMenuItem(
                    value: Metric.volume,
                    child: Text("Volume"),
                  ),
                  DropdownMenuItem(
                    value: Metric.relativeStrength,
                    child: Text("Relative strength"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _metric = value!;
                  });
                },
              ),
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'Group by'),
              value: _groupBy,
              items: const [
                DropdownMenuItem(
                  value: AppGroupBy.day,
                  child: Text("Day"),
                ),
                DropdownMenuItem(
                  value: AppGroupBy.week,
                  child: Text("Week"),
                ),
                DropdownMenuItem(
                  value: AppGroupBy.month,
                  child: Text("Month"),
                ),
                DropdownMenuItem(
                  value: AppGroupBy.year,
                  child: Text("Year"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _groupBy = value!;
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: _targetUnit,
              decoration: const InputDecoration(labelText: 'Unit'),
              items: ['kg', 'lb'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _targetUnit = newValue!;
                });
              },
            ),
            AppLineGraph(
              name: widget.name,
              metric: _metric,
              targetUnit: _targetUnit,
              groupBy: _groupBy,
            ),
          ],
        ),
      ),
      floatingActionButton: _editing
          ? FloatingActionButton(
              onPressed: _saveName,
              child: const Icon(Icons.save),
            )
          : FloatingActionButton(
              tooltip: 'View history',
              child: const Icon(Icons.history),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GraphHistory(
                          name: widget.name,
                        )),
              ),
            ),
    );
  }

  Future<int> _countName() async {
    final result = await (db.gymSets.selectOnly()
          ..addColumns([db.gymSets.name.count()])
          ..where(db.gymSets.name.equals(_nameController.text)))
        .getSingle();
    return result.read(db.gymSets.name.count()) ?? 0;
  }

  Future<void> _updateName() async {
    await (db.gymSets.update()..where((tbl) => tbl.name.equals(widget.name)))
        .write(GymSetsCompanion(name: drift.Value(_nameController.text)));
    await db.customUpdate(
      'UPDATE plans SET exercises = REPLACE(exercises, ?, ?)',
      variables: [
        drift.Variable.withString(widget.name),
        drift.Variable.withString(_nameController.text)
      ],
      updates: {db.plans},
    );
    if (!mounted) return;
    context.read<PlanState>().updatePlans(null);

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ViewGraphPage(
                name: _nameController.text,
              )),
    );
  }

  Future<void> _saveName() async {
    setState(() {
      _editing = false;
    });

    if (widget.name == _nameController.text || _nameController.text.isEmpty)
      return;

    final count = await _countName();

    if (!mounted) return;
    if (count == 0)
      await _updateName();
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
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Confirm'),
                onPressed: () async {
                  Navigator.pop(context);
                  await _updateName();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
