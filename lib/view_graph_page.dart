import 'package:drift/drift.dart' as drift;
import 'package:flexify/app_line_graph.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/edit_graph_page.dart';
import 'package:flexify/graph_history.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewGraphPage extends StatefulWidget {
  final String name;
  const ViewGraphPage({super.key, required this.name});

  @override
  createState() => _ViewGraphPageState();
}

class _ViewGraphPageState extends State<ViewGraphPage> {
  late Stream<List<drift.TypedResult>> _graphStream;
  Metric _metric = Metric.bestWeight;
  String _targetUnit = 'kg';

  final _oneRepMax = db.gymSets.weight /
      (const drift.Variable(1.0278) -
          const drift.Variable(0.0278) * db.gymSets.reps);
  final _volume =
      const drift.CustomExpression<double>("ROUND(SUM(weight * reps), 2)");
  final _relativeStrength = db.gymSets.weight.max() / db.gymSets.bodyWeight;

  @override
  void initState() {
    super.initState();
    _graphStream = (db.selectOnly(db.gymSets)
          ..addColumns([
            db.gymSets.weight.max(),
            _volume,
            _oneRepMax,
            db.gymSets.created,
            db.gymSets.reps,
            db.gymSets.unit,
            _relativeStrength,
          ])
          ..where(db.gymSets.name.equals(widget.name))
          ..where(db.gymSets.hidden.equals(false))
          ..orderBy([
            drift.OrderingTerm(
                expression: db.gymSets.created.date,
                mode: drift.OrderingMode.desc)
          ])
          ..limit(11)
          ..groupBy([db.gymSets.created.date]))
        .watch();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GraphHistory(
                            name: widget.name,
                          )),
                );
              },
              icon: const Icon(Icons.history))
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
            _graphBuilder(settings),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Edit graph',
        child: const Icon(Icons.edit),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditGraphPage(name: widget.name),
            )),
      ),
    );
  }

  StreamBuilder<List<drift.TypedResult>> _graphBuilder(SettingsState settings) {
    return StreamBuilder<List<drift.TypedResult>>(
      stream: _graphStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        if (snapshot.data?.isEmpty == true)
          return ListTile(
            title: Text("No data yet for ${widget.name}"),
            subtitle: const Text("Complete some plans to view graphs here"),
            contentPadding: EdgeInsets.zero,
          );
        if (snapshot.hasError) return ErrorWidget(snapshot.error.toString());

        return AppLineGraph(
            data: snapshot.data!, metric: _metric, targetUnit: _targetUnit);
      },
    );
  }
}
