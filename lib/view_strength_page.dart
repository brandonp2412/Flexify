import 'package:flexify/constants.dart';
import 'package:flexify/edit_graph_page.dart';
import 'package:flexify/graph_history.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/strength_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) async {
      _prefs = prefs;
      final targetUnit =
          prefs.getString("viewStrength${widget.name}.targetUnit");
      final groupBy = prefs.getString("viewStrength${widget.name}.groupBy");
      final metric = prefs.getString("viewStrength${widget.name}.metric");

      setState(() {
        if (targetUnit != null) _targetUnit = targetUnit;

        if (groupBy == 'AppGroupBy.week')
          _groupBy = AppGroupBy.week;
        else if (groupBy == 'AppGroupBy.month')
          _groupBy = AppGroupBy.month;
        else if (groupBy == 'AppGroupBy.year') _groupBy = AppGroupBy.year;

        if (metric == 'StrengthMetric.oneRepMax')
          _metric = StrengthMetric.oneRepMax;
        else if (metric == 'StrengthMetric.relativeStrength')
          _metric = StrengthMetric.relativeStrength;
        else if (metric == 'StrengthMetric.volume')
          _metric = StrengthMetric.volume;
      });
    });
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
                    _prefs?.setString(
                        "viewStrength${widget.name}.metric", value.toString());
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
                  _prefs?.setString(
                      "viewStrength${widget.name}.groupBy", value.toString());
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
                    _prefs?.setString(
                        "viewStrength${widget.name}.targetUnit", newValue);
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
