import 'package:flexify/constants.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/main.dart';
import 'package:intl/intl.dart';

class GraphData {
  final String created;
  final double reps;
  final double maxWeight;
  final double volume;
  final double oneRepMax;

  GraphData(
      {required this.created,
      required this.reps,
      required this.maxWeight,
      required this.volume,
      required this.oneRepMax});
}

class ViewGraphPage extends StatefulWidget {
  final String name;
  const ViewGraphPage({Key? key, required this.name}) : super(key: key);

  @override
  createState() => _ViewGraphPageState();
}

class _ViewGraphPageState extends State<ViewGraphPage> {
  late Stream<List<drift.TypedResult>> stream;
  final oneRepMax = database.gymSets.weight /
      (const drift.Variable(1.0278) -
          const drift.Variable(0.0278) * database.gymSets.reps);
  Metric metric = Metric.oneRepMax;

  @override
  void initState() {
    super.initState();
    stream = (database.selectOnly(database.gymSets)
          ..addColumns([
            database.gymSets.weight.max(),
            database.gymSets.reps * database.gymSets.weight,
            oneRepMax,
            database.gymSets.name,
            database.gymSets.created.date,
            database.gymSets.reps
          ])
          ..where(database.gymSets.name.equals(widget.name))
          ..orderBy([
            drift.OrderingTerm(
                expression: database.gymSets.created,
                mode: drift.OrderingMode.desc)
          ])
          ..limit(10)
          ..groupBy([database.gymSets.created.date]))
        .watch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: StreamBuilder<List<drift.TypedResult>>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          if (snapshot.hasError) return ErrorWidget(snapshot.error.toString());
          final rows = snapshot.data!.reversed
              .map((row) => GraphData(
                  created: row.read(database.gymSets.created.date)!,
                  reps: row.read(database.gymSets.reps)!,
                  oneRepMax: row.read(oneRepMax)!,
                  volume: row
                      .read(database.gymSets.reps * database.gymSets.weight)!,
                  maxWeight: row.read(database.gymSets.weight.max())!))
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                DropdownButtonFormField(
                  value: metric,
                  items: const [
                    DropdownMenuItem(
                      value: Metric.oneRepMax,
                      child: Text("One rep max (estimate)"),
                    ),
                    DropdownMenuItem(
                      value: Metric.volume,
                      child: Text("Volume"),
                    ),
                    DropdownMenuItem(
                      value: Metric.bestWeight,
                      child: Text("Best weight"),
                    )
                  ],
                  onChanged: (value) {
                    setState(() {
                      metric = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 24.0,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: LineChart(
                    LineChartData(
                      titlesData: const FlTitlesData(
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false))),
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
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const ColorScheme.dark().primary
                              : const ColorScheme.light().primary,
                          barWidth: 3,
                          isStrokeCapRound: true,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  LineTouchTooltipData tooltipData(BuildContext context, List<GraphData> rows) {
    return LineTouchTooltipData(
      tooltipBgColor: Theme.of(context).colorScheme.background,
      getTooltipItems: (touchedSpots) {
        final row = rows.elementAt(touchedSpots.first.spotIndex);
        String text = "";
        if (metric == Metric.oneRepMax)
          text = "${row.oneRepMax.toStringAsFixed(2)} ${row.created}";
        else if (metric == Metric.volume)
          text = "${row.volume} ${row.created}";
        else if (metric == Metric.bestWeight)
          text = "${row.reps} ${row.maxWeight} ${row.created}";
        return [
          LineTooltipItem(text,
              TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color))
        ];
      },
    );
  }
}
