import 'package:drift/drift.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/graph_data.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppLineGraph extends StatefulWidget {
  final String name;
  final Metric metric;
  final String targetUnit;

  const AppLineGraph(
      {super.key,
      required this.name,
      required this.metric,
      required this.targetUnit});

  @override
  createState() => _AppLineGraphState();
}

class _AppLineGraphState extends State<AppLineGraph> {
  late Stream<List<TypedResult>> _graphStream;
  late SettingsState _settings;

  @override
  void initState() {
    super.initState();
    _graphStream = (db.selectOnly(db.gymSets)
          ..addColumns([
            db.gymSets.weight.max(),
            volume,
            oneRepMax,
            db.gymSets.created,
            db.gymSets.reps,
            db.gymSets.unit,
            relativeStrength,
          ])
          ..where(db.gymSets.name.equals(widget.name))
          ..where(db.gymSets.hidden.equals(false))
          ..orderBy([
            OrderingTerm(
                expression: db.gymSets.created.date, mode: OrderingMode.desc)
          ])
          ..limit(11)
          ..groupBy([db.gymSets.created.date]))
        .watch();
    _settings = context.read<SettingsState>();
  }

  double getValue(TypedResult row, Metric metric) {
    if (metric == Metric.oneRepMax) {
      return row.read(oneRepMax)!;
    } else if (metric == Metric.volume) {
      return row.read(volume)!;
    } else if (metric == Metric.relativeStrength) {
      return row.read(relativeStrength)!;
    } else if (metric == Metric.bestWeight) {
      return row.read(db.gymSets.weight.max())!;
    } else {
      throw Exception("Metric not supported.");
    }
  }

  @override
  Widget build(BuildContext context) {
    _settings = context.watch<SettingsState>();

    return StreamBuilder<List<TypedResult>>(
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

        List<FlSpot> spots = [];
        List<GraphData> rows = [];

        for (var index = 0; index < snapshot.data!.length; index++) {
          final row = snapshot.data!.reversed.elementAt(index);
          final unit = row.read(db.gymSets.unit)!;
          var value = getValue(row, widget.metric);

          if (unit == 'lb' && widget.targetUnit == 'kg') {
            value *= 0.45359237;
          } else if (unit == 'kg' && widget.targetUnit == 'lb') {
            value *= 2.20462262;
          }

          rows.add(GraphData(
            value: value,
            created: row.read(db.gymSets.created)!,
            reps: row.read(db.gymSets.reps)!,
            unit: row.read(db.gymSets.unit)!,
          ));
          spots.add(FlSpot(index.toDouble(), value));
        }

        return Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 80.0, right: 32.0, top: 16.0),
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 27,
                      interval: 1,
                      getTitlesWidget: (value, meta) =>
                          _bottomTitleWidgets(value, meta, rows),
                    ),
                  ),
                ),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: _tooltipData(context, rows),
                  longPressDuration: Duration.zero,
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: _settings.curveLines,
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

  Widget _bottomTitleWidgets(
      double value, TitleMeta meta, List<GraphData> rows) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;

    int middleIndex = (rows.length / 2).floor();
    List<int> indices;

    if (rows.length % 2 == 0) {
      indices = [0, rows.length - 1];
    } else {
      indices = [0, middleIndex, rows.length - 1];
    }

    if (indices.contains(value.toInt())) {
      DateTime createdDate = rows[value.toInt()].created;
      text = Text(DateFormat(_settings.shortDateFormat).format(createdDate),
          style: style);
    } else {
      text = const Text('', style: style);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  LineTouchTooltipData _tooltipData(
      BuildContext context, List<GraphData> rows) {
    return LineTouchTooltipData(
      tooltipBgColor: Theme.of(context).colorScheme.background,
      getTooltipItems: (touchedSpots) {
        final row = rows.elementAt(touchedSpots.first.spotIndex);
        final created =
            DateFormat(_settings.shortDateFormat).format(row.created);
        final formatter = NumberFormat("#,###.00");

        String text =
            "${row.reps} x ${row.value.toStringAsFixed(2)}${widget.targetUnit} $created";
        if (widget.metric == Metric.relativeStrength)
          text = "${row.value.toStringAsFixed(2)} $created";
        else if (widget.metric == Metric.volume ||
            widget.metric == Metric.oneRepMax)
          text = "${formatter.format(row.value)}${widget.targetUnit} $created";

        return [
          LineTooltipItem(text,
              TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color))
        ];
      },
    );
  }
}
