import 'package:flexify/strength_line.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/edit_graph_page.dart';
import 'package:flexify/graph_history.dart';
import 'package:flexify/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewStrengthPage extends StatefulWidget {
  final String name;
  const ViewStrengthPage({super.key, required this.name});

  @override
  createState() => _ViewStrengthPageState();
}

class _ViewStrengthPageState extends State<ViewStrengthPage> {
  StrengthMetric _metric = StrengthMetric.bestWeight;
  AppGroupBy _groupBy = AppGroupBy.day;
  String _targetUnit = 'kg';

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
                      builder: (context) => EditGraphPage(
                            name: widget.name,
                          )),
                );
              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            if (widget.name != 'Weight')
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Metric'),
                value: _metric,
                items: const [
                  DropdownMenuItem(
                    value: StrengthMetric.bestWeight,
                    child: Text("Best weight"),
                  ),
                  DropdownMenuItem(
                    value: StrengthMetric.oneRepMax,
                    child: Text("One rep max"),
                  ),
                  DropdownMenuItem(
                    value: StrengthMetric.volume,
                    child: Text("Volume"),
                  ),
                  DropdownMenuItem(
                    value: StrengthMetric.relativeStrength,
                    child: Text("Relative strength"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _metric = value!;
                  });
                },
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
            if (settings.showUnits)
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
            StrengthLine(
              name: widget.name,
              metric: _metric,
              targetUnit: _targetUnit,
              groupBy: _groupBy,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
}
