import 'package:drift/drift.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/edit_gym_set.dart';
import 'package:flexify/strength_data.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StrengthLine extends StatefulWidget {
  final String name;
  final StrengthMetric metric;
  final String targetUnit;
  final AppGroupBy groupBy;
  final DateTime? startDate;
  final DateTime? endDate;

  const StrengthLine(
      {super.key,
      required this.name,
      required this.metric,
      required this.targetUnit,
      required this.groupBy,
      this.startDate,
      this.endDate});

  @override
  createState() => _StrengthLineState();
}

class _StrengthLineState extends State<StrengthLine> {
  late Stream<List<TypedResult>> _graphStream;
  late SettingsState _settings;
  final _ormColumn = db.gymSets.weight /
      (const Variable(1.0278) - const Variable(0.0278) * db.gymSets.reps);
  final _volumeColumn =
      const CustomExpression<double>("ROUND(SUM(weight * reps), 2)");
  final _relativeColumn = db.gymSets.weight.max() / db.gymSets.bodyWeight;
  final _weekCol =
      const CustomExpression<int>("STRFTIME('%W', DATE(created, 'unixepoch'))");

  DateTime _lastTap = DateTime.fromMicrosecondsSinceEpoch(0);

  @override
  void didUpdateWidget(covariant StrengthLine oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.groupBy != widget.groupBy ||
        oldWidget.startDate != widget.startDate ||
        oldWidget.endDate != widget.endDate) _setStream();
  }

  @override
  void initState() {
    super.initState();
    _setStream();
    _settings = context.read<SettingsState>();
  }

  void _setStream() {
    Iterable<Expression> groupBy = [db.gymSets.created.date];

    if (widget.groupBy == AppGroupBy.month)
      groupBy = [db.gymSets.created.year, db.gymSets.created.month];
    else if (widget.groupBy == AppGroupBy.week)
      groupBy = [db.gymSets.created.year, db.gymSets.created.month, _weekCol];
    else if (widget.groupBy == AppGroupBy.year)
      groupBy = [db.gymSets.created.year];

    _graphStream = (db.selectOnly(db.gymSets)
          ..addColumns([
            db.gymSets.weight.max(),
            _volumeColumn,
            _ormColumn,
            db.gymSets.created,
            db.gymSets.reps,
            db.gymSets.unit,
            _relativeColumn,
          ])
          ..where(db.gymSets.name.equals(widget.name))
          ..where(db.gymSets.hidden.equals(false))
          ..where(db.gymSets.created
              .isBiggerOrEqualValue(widget.startDate ?? DateTime(0)))
          ..where(db.gymSets.created.isSmallerThanValue(
              widget.endDate ?? DateTime.now().add(const Duration(days: 1))))
          ..orderBy([
            OrderingTerm(
                expression: db.gymSets.created.date, mode: OrderingMode.desc)
          ])
          ..limit(11)
          ..groupBy(groupBy))
        .watch();
  }

  double getValue(TypedResult row, StrengthMetric metric) {
    if (metric == StrengthMetric.oneRepMax) {
      return row.read(_ormColumn)!;
    } else if (metric == StrengthMetric.volume) {
      return row.read(_volumeColumn)!;
    } else if (metric == StrengthMetric.relativeStrength) {
      return row.read(_relativeColumn) ?? 0;
    } else if (metric == StrengthMetric.bestWeight) {
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
        List<StrengthData> rows = [];

        for (var index = 0; index < snapshot.data!.length; index++) {
          final row = snapshot.data!.reversed.elementAt(index);
          final unit = row.read(db.gymSets.unit)!;
          var value = getValue(row, widget.metric);

          if (unit == 'lb' && widget.targetUnit == 'kg') {
            value *= 0.45359237;
          } else if (unit == 'kg' && widget.targetUnit == 'lb') {
            value *= 2.20462262;
          }

          rows.add(StrengthData(
            value: value,
            created: row.read(db.gymSets.created)!,
            reps: row.read(db.gymSets.reps)!,
            unit: row.read(db.gymSets.unit)!,
          ));
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
                  touchCallback: (event, touchResponse) async {
                    if (event is ScaleUpdateDetails) return;
                    if (event is! FlPanDownEvent) return;
                    if (widget.metric != StrengthMetric.bestWeight) return;
                    if (DateTime.now().difference(_lastTap) <
                        const Duration(milliseconds: 300)) {
                      final index = touchResponse?.lineBarSpots?[0].spotIndex;
                      if (index == null) return;
                      final row = rows[index];
                      final gymSet = await (db.gymSets.select()
                            ..where((tbl) => tbl.created.equals(row.created))
                            ..where((tbl) => tbl.reps.equals(row.reps))
                            ..where((tbl) => tbl.weight.equals(row.value))
                            ..where((tbl) => tbl.name.equals(widget.name))
                            ..limit(1))
                          .getSingle();

                      if (!context.mounted) return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditGymSet(
                                    gymSet: gymSet.toCompanion(false),
                                  )));
                    }
                    setState(() {
                      _lastTap = DateTime.now();
                    });
                  },
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
      double value, TitleMeta meta, List<StrengthData> rows) {
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
      BuildContext context, List<StrengthData> rows) {
    return LineTouchTooltipData(
      tooltipBgColor: Theme.of(context).colorScheme.background,
      getTooltipItems: (touchedSpots) {
        final row = rows.elementAt(touchedSpots.first.spotIndex);
        final created =
            DateFormat(_settings.shortDateFormat).format(row.created);
        final formatter = NumberFormat("#,###.00");

        String text =
            "${row.reps} x ${row.value.toStringAsFixed(2)}${widget.targetUnit} $created";
        if (widget.metric == StrengthMetric.relativeStrength)
          text = "${row.value.toStringAsFixed(2)} $created";
        else if (widget.metric == StrengthMetric.volume ||
            widget.metric == StrengthMetric.oneRepMax)
          text = "${formatter.format(row.value)}${widget.targetUnit} $created";

        return [
          LineTooltipItem(text,
              TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color))
        ];
      },
    );
  }
}
