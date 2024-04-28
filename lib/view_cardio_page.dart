import 'package:flexify/cardio_line.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/edit_graph_page.dart';
import 'package:flexify/graph_history.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewCardioPage extends StatefulWidget {
  final String name;
  const ViewCardioPage({super.key, required this.name});

  @override
  createState() => _ViewCardioPageState();
}

class _ViewCardioPageState extends State<ViewCardioPage> {
  CardioMetric _metric = CardioMetric.pace;
  AppGroupBy _groupBy = AppGroupBy.day;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) async {
      _prefs = prefs;
      final groupBy = prefs.getString("viewCardio${widget.name}.groupBy");
      final metric = prefs.getString("viewCardio${widget.name}.metric");

      setState(() {
        if (groupBy == AppGroupBy.week.toString())
          _groupBy = AppGroupBy.week;
        else if (groupBy == AppGroupBy.month.toString())
          _groupBy = AppGroupBy.month;
        else if (groupBy == AppGroupBy.year.toString())
          _groupBy = AppGroupBy.year;

        if (metric == CardioMetric.distance.toString())
          _metric = CardioMetric.distance;
        else if (metric == CardioMetric.duration.toString())
          _metric = CardioMetric.duration;
      });
    });
  }

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
                  _prefs?.setString(
                      "viewCardio${widget.name}.metric", value.toString());
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
                      "viewCardio${widget.name}.groupBy", value.toString());
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
