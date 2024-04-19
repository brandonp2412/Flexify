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
    final settings = context.watch<SettingsState>();
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
        created: DateFormat(settings.dateFormat)
            .format(row.read(db.gymSets.created)!),
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 300),
        child: LineChart(
          LineChartData(
            titlesData: const FlTitlesData(
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false))),
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
  }

  LineTouchTooltipData tooltipData(BuildContext context, List<GraphData> rows) {
    return LineTouchTooltipData(
      tooltipBgColor: Theme.of(context).colorScheme.background,
      getTooltipItems: (touchedSpots) {
        final row = rows.elementAt(touchedSpots.first.spotIndex);
        String text = "";
        if (widget.metric == Metric.oneRepMax)
          text =
              "${row.oneRepMax.toStringAsFixed(2)}${widget.targetUnit} ${row.created}";
        else if (widget.metric == Metric.relativeStrength)
          text = "${(row.relativeStrength).toStringAsFixed(2)} ${row.created}";
        else if (widget.metric == Metric.volume)
          text = "${row.volume}${widget.targetUnit} ${row.created}";
        else if (widget.metric == Metric.bestWeight)
          text =
              "${row.reps} x ${row.maxWeight.toStringAsFixed(2)}${widget.targetUnit} ${row.created}";
        return [
          LineTooltipItem(text,
              TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color))
        ];
      },
    );
  }
}
