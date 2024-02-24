import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/main.dart';
import 'package:intl/intl.dart';

class ViewGraphPage extends StatefulWidget {
  final String name;
  const ViewGraphPage({Key? key, required this.name}) : super(key: key);

  @override
  createState() => _ViewGraphPageState();
}

class _ViewGraphPageState extends State<ViewGraphPage> {
  late Stream<List<TypedResult>> stream;

  @override
  void initState() {
    super.initState();
    stream = (database.selectOnly(database.gymSets)
          ..addColumns([
            database.gymSets.weight.max(),
            database.gymSets.name,
            database.gymSets.created,
            database.gymSets.reps
          ])
          ..where(database.gymSets.name.equals(widget.name))
          ..orderBy([
            OrderingTerm(
                expression: database.gymSets.created, mode: OrderingMode.desc)
          ])
          ..limit(10)
          ..groupBy([database.gymSets.created.date]))
        .watch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.name} graph")),
      body: StreamBuilder<List<TypedResult>>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          if (snapshot.hasError) return ErrorWidget(snapshot.error.toString());
          final plans = snapshot.data!;
          final reps = plans
              .map((row) => row.read(database.gymSets.reps))
              .toList()
              .reversed;
          final createds = plans
              .map((row) => row.read(database.gymSets.created))
              .toList()
              .reversed;
          final maxes = plans
              .map((row) => row.read(database.gymSets.weight.max()))
              .toList()
              .reversed;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 400),
              child: LineChart(
                LineChartData(
                  titlesData: const FlTitlesData(
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false))),
                  minY: maxes.reduce((a, b) => a! < b! ? a : b)! - 10,
                  maxY: maxes.reduce((a, b) => a! > b! ? a : b)! + 10,
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Theme.of(context).primaryColor,
                      getTooltipItems: (touchedSpots) {
                        final created =
                            createds.elementAt(touchedSpots.first.spotIndex)!;
                        final max =
                            maxes.elementAt(touchedSpots.first.spotIndex)!;
                        final rep =
                            reps.elementAt(touchedSpots.first.spotIndex)!;
                        String formattedDate =
                            DateFormat('dd/MM/yyyy').format(created);
                        var text = "$rep x $max $formattedDate";
                        return [
                          LineTooltipItem(
                              text,
                              TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.black
                                      : Colors.white))
                        ];
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: maxes
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) =>
                              FlSpot(entry.key.toDouble(), entry.value ?? 0))
                          .toList(),
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
            ),
          );
        },
      ),
    );
  }
}
