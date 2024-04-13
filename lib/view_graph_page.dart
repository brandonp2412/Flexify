import 'package:drift/drift.dart' as drift;
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/edit_graph_page.dart';
import 'package:flexify/graph_history.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GraphData {
  final String created;
  final double reps;
  final double maxWeight;
  final double volume;
  final double oneRepMax;
  final String unit;

  GraphData(
      {required this.created,
      required this.reps,
      required this.maxWeight,
      required this.volume,
      required this.oneRepMax,
      required this.unit});
}

class ViewGraphPage extends StatefulWidget {
  final String name;
  const ViewGraphPage({super.key, required this.name});

  @override
  createState() => _ViewGraphPageState();
}

class _ViewGraphPageState extends State<ViewGraphPage> {
  late Stream<List<drift.TypedResult>> graphStream;
  Metric metric = Metric.bestWeight;

  final oneRepMax = db.gymSets.weight /
      (const drift.Variable(1.0278) -
          const drift.Variable(0.0278) * db.gymSets.reps);
  final volume =
      const drift.CustomExpression<double>("ROUND(SUM(weight * reps), 2)");

  @override
  void initState() {
    super.initState();
    graphStream = (db.selectOnly(db.gymSets)
          ..addColumns([
            db.gymSets.weight.max(),
            volume,
            oneRepMax,
            db.gymSets.created,
            db.gymSets.reps,
            db.gymSets.unit,
          ])
          ..where(db.gymSets.name.equals(widget.name))
          ..where(db.gymSets.hidden.equals(false))
          ..orderBy([
            drift.OrderingTerm(
                expression: db.gymSets.created.date,
                mode: drift.OrderingMode.desc)
          ])
          ..limit(10)
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
                value: metric,
                items: const [
                  DropdownMenuItem(
                    value: Metric.bestWeight,
                    child: Text("Best weight"),
                  ),
                  DropdownMenuItem(
                    value: Metric.oneRepMax,
                    child: Text("One rep max (estimate)"),
                  ),
                  DropdownMenuItem(
                    value: Metric.volume,
                    child: Text("Volume"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    metric = value!;
                  });
                },
              ),
            ),
            graphBuilder(settings),
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

  StreamBuilder<List<drift.TypedResult>> graphBuilder(SettingsState settings) {
    return StreamBuilder<List<drift.TypedResult>>(
      stream: graphStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        if (snapshot.data?.isEmpty == true)
          return ListTile(
            title: Text("No data yet for ${widget.name}"),
            subtitle: const Text("Complete some plans to view graphs here"),
            contentPadding: EdgeInsets.zero,
          );
        if (snapshot.hasError) return ErrorWidget(snapshot.error.toString());
        final rows = snapshot.data!.reversed
            .map((row) => GraphData(
                created: DateFormat(settings.dateFormat)
                    .format(row.read(db.gymSets.created)!),
                reps: row.read(db.gymSets.reps)!,
                oneRepMax: row.read(oneRepMax)!,
                volume: row.read(volume)!,
                unit: row.read(db.gymSets.unit)!,
                maxWeight: row.read(db.gymSets.weight.max())!))
            .toList();

        GraphData minRow, maxRow;
        double minY, maxY;

        if (metric == Metric.oneRepMax) {
          minRow = rows.reduce((a, b) => a.oneRepMax < b.oneRepMax ? a : b);
          maxRow = rows.reduce((a, b) => a.oneRepMax > b.oneRepMax ? a : b);
          minY = (minRow.oneRepMax - minRow.oneRepMax * 0.25).floorToDouble();
          maxY = (maxRow.oneRepMax + maxRow.oneRepMax * 0.25).ceilToDouble();
        } else if (metric == Metric.volume) {
          minRow = rows.reduce((a, b) => a.volume < b.volume ? a : b);
          maxRow = rows.reduce((a, b) => a.volume > b.volume ? a : b);
          minY = (minRow.volume - minRow.volume * 0.25).floorToDouble();
          maxY = (maxRow.volume + maxRow.volume * 0.25).ceilToDouble();
        } else {
          minRow = rows.reduce((a, b) => a.maxWeight < b.maxWeight ? a : b);
          maxRow = rows.reduce((a, b) => a.maxWeight > b.maxWeight ? a : b);
          minY = (minRow.maxWeight - minRow.maxWeight * 0.25).floorToDouble();
          maxY = (maxRow.maxWeight + maxRow.maxWeight * 0.25).ceilToDouble();
        }

        List<FlSpot> spots;
        if (metric == Metric.oneRepMax) {
          spots = rows
              .asMap()
              .entries
              .map((row) => FlSpot(row.key.toDouble(), row.value.oneRepMax))
              .toList();
        } else if (metric == Metric.volume) {
          spots = rows
              .asMap()
              .entries
              .map((row) => FlSpot(row.key.toDouble(), row.value.volume))
              .toList();
        } else {
          spots = rows
              .asMap()
              .entries
              .map((row) => FlSpot(row.key.toDouble(), row.value.maxWeight))
              .toList();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: LineChart(
              LineChartData(
                titlesData: const FlTitlesData(
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false))),
                minY: minY,
                maxY: maxY,
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: tooltipData(context, rows),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: false,
                    color: Theme.of(context).colorScheme.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  LineTouchTooltipData tooltipData(BuildContext context, List<GraphData> rows) {
    return LineTouchTooltipData(
      tooltipBgColor: Theme.of(context).colorScheme.background,
      getTooltipItems: (touchedSpots) {
        final row = rows.elementAt(touchedSpots.first.spotIndex);
        String text = "";
        if (metric == Metric.oneRepMax)
          text =
              "${row.oneRepMax.toStringAsFixed(2)}${row.unit} ${row.created}";
        else if (metric == Metric.volume)
          text = "${row.volume}${row.unit} ${row.created}";
        else if (metric == Metric.bestWeight)
          text = "${row.reps} ${row.maxWeight}${row.unit} ${row.created}";
        return [
          LineTooltipItem(text,
              TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color))
        ];
      },
    );
  }
}
