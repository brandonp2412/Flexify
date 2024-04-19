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
  final List<TypedResult> data;
  final Metric metric;
  final String targetUnit;

  const AppLineGraph(
      {super.key,
      required this.data,
      required this.metric,
      required this.targetUnit});

  @override
  createState() => _AppLineGraphState();
}

class _AppLineGraphState extends State<AppLineGraph> {
  final _oneRepMax = db.gymSets.weight /
      (const Variable(1.0278) - const Variable(0.0278) * db.gymSets.reps);
  final _volume =
      const CustomExpression<double>("ROUND(SUM(weight * reps), 2)");
  final _relativeStrength = db.gymSets.weight.max() / db.gymSets.bodyWeight;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final rows = widget.data.reversed.map((row) {
      final unit = row.read(db.gymSets.unit)!;
      var maxWeight = row.read(db.gymSets.weight.max())!;
      var oneRepMax = row.read(_oneRepMax)!;
      var volume = row.read(_volume)!;
      var relativeStrength = row.read(_relativeStrength) ?? 0;

      double conversionFactor = 1;

      if (unit == 'lb' && widget.targetUnit == 'kg') {
        conversionFactor = 0.45359237;
      } else if (unit == 'kg' && widget.targetUnit == 'lb') {
        conversionFactor = 2.20462262;
      }

      maxWeight *= conversionFactor;
      oneRepMax *= conversionFactor;
      volume *= conversionFactor;
      relativeStrength *= conversionFactor;

      return GraphData(
        maxWeight: maxWeight,
        oneRepMax: oneRepMax,
        volume: volume,
        relativeStrength: relativeStrength,
        created: row.read(db.gymSets.created)!,
        reps: row.read(db.gymSets.reps)!,
        unit: row.read(db.gymSets.unit)!,
      );
    }).toList();

    List<FlSpot> spots;
    if (widget.metric == Metric.oneRepMax) {
      spots = rows
          .asMap()
          .entries
          .map((row) => FlSpot(row.key.toDouble(), row.value.oneRepMax))
          .toList();
    } else if (widget.metric == Metric.volume) {
      spots = rows
          .asMap()
          .entries
          .map((row) => FlSpot(row.key.toDouble(), row.value.volume))
          .toList();
    } else if (widget.metric == Metric.relativeStrength) {
      spots = rows
          .asMap()
          .entries
          .map((row) => FlSpot(row.key.toDouble(), row.value.relativeStrength))
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
      child: AspectRatio(
        aspectRatio: 0.9,
        child: Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
      ),
    );
  }

  Widget _bottomTitleWidgets(
      double value, TitleMeta meta, List<GraphData> rows) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    DateFormat formatter = DateFormat("d/M/yy");

    int middleIndex = (rows.length / 2).floor();
    List<int> indices;

    if (rows.length % 2 == 0) {
      indices = [0, rows.length - 1];
    } else {
      indices = [0, middleIndex, rows.length - 1];
    }

    if (indices.contains(value.toInt())) {
      DateTime createdDate = rows[value.toInt()].created;
      text = Text(formatter.format(createdDate), style: style);
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
    final settings = context.watch<SettingsState>();

    return LineTouchTooltipData(
      tooltipBgColor: Theme.of(context).colorScheme.background,
      getTooltipItems: (touchedSpots) {
        final row = rows.elementAt(touchedSpots.first.spotIndex);
        final created = DateFormat(settings.dateFormat).format(row.created);
        String text = "";
        if (widget.metric == Metric.oneRepMax)
          text =
              "${row.oneRepMax.toStringAsFixed(2)}${widget.targetUnit} $created";
        else if (widget.metric == Metric.relativeStrength)
          text = "${(row.relativeStrength).toStringAsFixed(2)} $created";
        else if (widget.metric == Metric.volume)
          text = "${row.volume}${widget.targetUnit} $created";
        else if (widget.metric == Metric.bestWeight)
          text =
              "${row.reps} x ${row.maxWeight.toStringAsFixed(2)}${widget.targetUnit} $created";
        return [
          LineTooltipItem(text,
              TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color))
        ];
      },
    );
  }
}
