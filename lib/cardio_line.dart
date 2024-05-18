import 'package:drift/drift.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/cardio_data.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CardioLine extends StatefulWidget {
  final String name;
  final CardioMetric metric;
  final Period groupBy;
  final DateTime? startDate;
  final DateTime? endDate;

  const CardioLine({
    super.key,
    required this.name,
    required this.metric,
    required this.groupBy,
    this.startDate,
    this.endDate,
  });

  @override
  createState() => _CardioLineState();
}

class _CardioLineState extends State<CardioLine> {
  late Stream<List<TypedResult>> _graphStream;
  late SettingsState _settings;

  @override
  void didUpdateWidget(covariant CardioLine oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setStream();
  }

  @override
  void initState() {
    super.initState();
    _setStream();
    _settings = context.read<SettingsState>();
  }

  void _setStream() {
    Iterable<Expression> groupBy = [db.gymSets.created.date];

    if (widget.groupBy == Period.month)
      groupBy = [db.gymSets.created.year, db.gymSets.created.month];
    else if (widget.groupBy == Period.week)
      groupBy = [
        db.gymSets.created.year,
        db.gymSets.created.month,
        const CustomExpression<int>(
          "STRFTIME('%W', DATE(created, 'unixepoch'))",
        ),
      ];
    else if (widget.groupBy == Period.year) groupBy = [db.gymSets.created.year];

    _graphStream = (db.selectOnly(db.gymSets)
          ..addColumns([
            db.gymSets.duration.sum(),
            db.gymSets.distance.sum(),
            db.gymSets.distance.sum() / db.gymSets.duration.sum(),
            db.gymSets.created,
            db.gymSets.unit,
          ])
          ..where(db.gymSets.name.equals(widget.name))
          ..where(db.gymSets.hidden.equals(false))
          ..where(
            db.gymSets.created
                .isBiggerOrEqualValue(widget.startDate ?? DateTime(0)),
          )
          ..where(
            db.gymSets.created.isSmallerThanValue(
              widget.endDate ??
                  DateTime.now().toLocal().add(const Duration(days: 1)),
            ),
          )
          ..orderBy([
            OrderingTerm(
              expression: db.gymSets.created.date,
              mode: OrderingMode.desc,
            ),
          ])
          ..limit(11)
          ..groupBy(groupBy))
        .watch();
  }

  double _getValue(TypedResult row) {
    if (widget.metric == CardioMetric.distance) {
      return row.read(db.gymSets.distance.sum())!;
    } else if (widget.metric == CardioMetric.duration) {
      return row.read(db.gymSets.duration.sum())!;
    } else if (widget.metric == CardioMetric.pace) {
      return row.read(db.gymSets.distance.sum() / db.gymSets.duration.sum()) ??
          0;
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
        List<CardioData> rows = [];

        for (var index = 0; index < snapshot.data!.length; index++) {
          final row = snapshot.data!.reversed.elementAt(index);
          var value = double.parse(_getValue(row).toStringAsFixed(2));

          rows.add(
            CardioData(
              value: value,
              created: row.read(db.gymSets.created)!,
              unit: row.read(db.gymSets.unit)!,
            ),
          );
          spots.add(FlSpot(index.toDouble(), value));
        }

        return SizedBox(
          height: 400,
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 80.0, right: 32.0, top: 16.0),
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
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
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touch) =>
                        Theme.of(context).colorScheme.surface,
                    getTooltipItems: (touchedSpots) => [
                      LineTooltipItem(
                        touchedSpots.first.y.toStringAsFixed(2),
                        TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                    ],
                  ),
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
    double value,
    TitleMeta meta,
    List<CardioData> rows,
  ) {
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
      text = Text(
        DateFormat(_settings.shortDateFormat).format(createdDate),
        style: style,
      );
    } else {
      text = const Text('', style: style);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
}
