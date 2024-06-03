import 'package:flexify/constants.dart';
import 'package:flexify/edit_graph_page.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/strength_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StrengthPage extends StatefulWidget {
  final String name;
  final String unit;

  const StrengthPage({super.key, required this.name, required this.unit});

  @override
  createState() => _StrengthPageState();
}

class _StrengthPageState extends State<StrengthPage> {
  late String _targetUnit = widget.unit;
  StrengthMetric _metric = StrengthMetric.bestWeight;
  Period _groupBy = Period.day;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  initState() {
    super.initState();
    if (widget.name == 'Weight') _groupBy = Period.week;
  }

  Future<void> _selectEnd() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null)
      setState(() {
        _endDate = pickedDate;
      });
  }

  Future<void> _selectStart() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null)
      setState(() {
        _startDate = pickedDate;
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
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit),
            tooltip: "Edit",
          ),
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
                items: [
                  const DropdownMenuItem(
                    value: StrengthMetric.bestWeight,
                    child: Text("Best weight"),
                  ),
                  const DropdownMenuItem(
                    value: StrengthMetric.bestReps,
                    child: Text("Best reps"),
                  ),
                  const DropdownMenuItem(
                    value: StrengthMetric.oneRepMax,
                    child: Text("One rep max"),
                  ),
                  const DropdownMenuItem(
                    value: StrengthMetric.volume,
                    child: Text("Volume"),
                  ),
                  if (!settings.hideWeight)
                    const DropdownMenuItem(
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
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Start date'),
                    subtitle: _startDate != null
                        ? Text(
                            DateFormat(settings.shortDateFormat)
                                .format(_startDate!),
                          )
                        : null,
                    onLongPress: () => setState(() {
                      _startDate = null;
                    }),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectStart(),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Stop date'),
                    subtitle: _endDate != null
                        ? Text(
                            DateFormat(settings.shortDateFormat)
                                .format(_endDate!),
                          )
                        : null,
                    onLongPress: () => setState(() {
                      _endDate = null;
                    }),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectEnd(),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: Period.values.map((period) {
                return TextButton(
                  onPressed: _groupBy == period
                      ? null
                      : () {
                          setState(() {
                            _groupBy = period;
                          });
                        },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: _groupBy == period
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    period.name[0].toUpperCase() + period.name.substring(1),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              }).toList(),
            ),
            if (settings.showUnits)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['kg', 'lb'].map((unit) {
                  return TextButton(
                    onPressed: _targetUnit == unit
                        ? null
                        : () {
                            setState(() {
                              _targetUnit = unit;
                            });
                          },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: _targetUnit == unit
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      unit,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            StrengthLine(
              name: widget.name,
              metric: _metric,
              targetUnit: _targetUnit,
              groupBy: _groupBy,
              startDate: _startDate,
              endDate: _endDate,
            ),
          ],
        ),
      ),
    );
  }
}
