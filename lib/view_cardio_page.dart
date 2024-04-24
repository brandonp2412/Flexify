import 'package:flexify/cardio_line.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/edit_graph_page.dart';
import 'package:flexify/graph_history.dart';
import 'package:flutter/material.dart';

class ViewCardioPage extends StatefulWidget {
  final String name;
  const ViewCardioPage({super.key, required this.name});

  @override
  createState() => _ViewCardioPageState();
}

class _ViewCardioPageState extends State<ViewCardioPage> {
  CardioMetric _metric = CardioMetric.pace;
  AppGroupBy _groupBy = AppGroupBy.day;

  @override
  Widget build(BuildContext context) {
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
        child: Column(
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
            CardioLine(
              name: widget.name,
              metric: _metric,
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
