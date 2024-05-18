import 'package:flexify/cardio_line.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/edit_graph_page.dart';
import 'package:flexify/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewCardioPage extends StatefulWidget {
  final String name;
  const ViewCardioPage({super.key, required this.name});

  @override
  createState() => _ViewCardioPageState();
}

class _ViewCardioPageState extends State<ViewCardioPage> {
  CardioMetric _metric = CardioMetric.pace;
  Period _groupBy = Period.day;

  DateTime? _startDate;
  DateTime? _endDate;

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
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'Metric'),
              value: _metric,
              items: const [
                DropdownMenuItem(
                  value: CardioMetric.pace,
                  child: Text("Pace (distance / time)"),
                ),
                DropdownMenuItem(
                  value: CardioMetric.duration,
                  child: Text("Duration"),
                ),
                DropdownMenuItem(
                  value: CardioMetric.distance,
                  child: Text("Distance"),
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
                  value: Period.day,
                  child: Text("Day"),
                ),
                DropdownMenuItem(
                  value: Period.week,
                  child: Text("Week"),
                ),
                DropdownMenuItem(
                  value: Period.month,
                  child: Text("Month"),
                ),
                DropdownMenuItem(
                  value: Period.year,
                  child: Text("Year"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _groupBy = value!;
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
            CardioLine(
              name: widget.name,
              metric: _metric,
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
