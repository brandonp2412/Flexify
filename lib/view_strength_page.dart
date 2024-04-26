import 'package:drift/drift.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/edit_graph_page.dart';
import 'package:flexify/edit_gym_set.dart';
import 'package:flexify/graph_history.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/strength_data.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewStrengthPage extends StatefulWidget {
  final String name;
  const ViewStrengthPage({super.key, required this.name});

  @override
  createState() => _ViewStrengthPageState();
}

final _ormColumn = db.gymSets.weight /
    (const Variable(1.0278) - const Variable(0.0278) * db.gymSets.reps);
const _volumeColumn = CustomExpression<double>("ROUND(SUM(weight * reps), 2)");
final _relativeColumn = db.gymSets.weight.max() / db.gymSets.bodyWeight;

class _ViewStrengthPageState extends State<ViewStrengthPage> {
  late SettingsState _settings;

  List<StrengthData> _strengthData = [];
  List<FlSpot> _spots = [];
  StrengthMetric _metric = StrengthMetric.bestWeight;
  AppGroupBy _groupBy = AppGroupBy.day;
  String _targetUnit = 'kg';
  DateTime _lastTap = DateTime.fromMicrosecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _setData();
    _settings = context.read<SettingsState>();
  }

  double _convert(String unit, String targetUnit, double value) {
    if (unit == targetUnit) return value;
    if (unit == 'kg' && targetUnit == 'lb') return value * 2.20462;
    if (unit == 'lb' && targetUnit == 'kg') return value / 2.20462;
    throw Exception('Unsupported unit conversion');
  }

  void _setData() async {
    Iterable<Expression> groupBy = [db.gymSets.created.date];

    if (_groupBy == AppGroupBy.month)
      groupBy = [db.gymSets.created.year, db.gymSets.created.month];
    else if (_groupBy == AppGroupBy.week)
      groupBy = [
        db.gymSets.created.year,
        db.gymSets.created.month,
        const CustomExpression<double>("STRFTIME('%W', created)")
      ];
    else if (_groupBy == AppGroupBy.year) groupBy = [db.gymSets.created.year];

    final query = (db.selectOnly(db.gymSets)
      ..where(db.gymSets.name.equals(widget.name))
      ..where(db.gymSets.hidden.equals(false))
      ..orderBy([
        OrderingTerm(
            expression: db.gymSets.created.date, mode: OrderingMode.desc)
      ])
      ..limit(11)
      ..groupBy(groupBy));

    if (_metric == StrengthMetric.oneRepMax)
      query.addColumns(
          [_ormColumn, db.gymSets.created, db.gymSets.reps, db.gymSets.unit]);
    else if (_metric == StrengthMetric.volume)
      query.addColumns([_volumeColumn, db.gymSets.created, db.gymSets.unit]);
    else if (_metric == StrengthMetric.bestWeight)
      query.addColumns([
        db.gymSets.weight.max(),
        db.gymSets.created,
        db.gymSets.unit,
        db.gymSets.reps
      ]);
    else if (_metric == StrengthMetric.relativeStrength)
      query.addColumns([
        _relativeColumn,
        db.gymSets.created,
      ]);
    else
      throw Exception("Metric not supported.");

    final typedData = await query.get();
    List<StrengthData> strengthData = [];
    List<FlSpot> spots = [];

    for (int i = 0; i < typedData.length; i++) {
      final row = typedData.reversed.elementAt(i);
      final created = row.read(db.gymSets.created)!;
      double value = 0;
      String? unit;
      double? reps;

      if (_metric == StrengthMetric.bestWeight) {
        unit = row.read(db.gymSets.unit)!;
        value = _convert(unit, _targetUnit, row.read(db.gymSets.weight.max())!);
        reps = row.read(db.gymSets.reps)!;
      } else if (_metric == StrengthMetric.oneRepMax) {
        unit = row.read(db.gymSets.unit)!;
        reps = row.read(db.gymSets.reps)!;
        value = _convert(unit, _targetUnit, row.read(_ormColumn)!);
      } else if (_metric == StrengthMetric.relativeStrength) {
        value = row.read(_relativeColumn) ?? 0;
      } else if (_metric == StrengthMetric.volume) {
        unit = row.read(db.gymSets.unit)!;
        value = _convert(unit, _targetUnit, row.read(_volumeColumn)!);
      }

      strengthData.add(
          StrengthData(created: created, unit: unit, reps: reps, value: value));
      spots.add(FlSpot(i.toDouble(), value));
    }

    setState(() {
      _strengthData = strengthData;
      _spots = spots;
    });
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;

    int middleIndex = (_strengthData.length / 2).floor();
    List<int> indices;

    if (_strengthData.length % 2 == 0) {
      indices = [0, _strengthData.length - 1];
    } else {
      indices = [0, middleIndex, _strengthData.length - 1];
    }

    if (indices.contains(value.toInt())) {
      DateTime createdDate = _strengthData[value.toInt()].created;
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

  LineTouchTooltipData _tooltipData(BuildContext context) {
    return LineTouchTooltipData(
      tooltipBgColor: Theme.of(context).colorScheme.background,
      getTooltipItems: (touchedSpots) {
        final row = _strengthData.elementAt(touchedSpots.first.spotIndex);
        final created =
            DateFormat(_settings.shortDateFormat).format(row.created);
        final formatter = NumberFormat("#,###.00");

        String text =
            "${row.reps} x ${row.value.toStringAsFixed(2)}$_targetUnit $created";
        if (_metric == StrengthMetric.relativeStrength)
          text = "${row.value.toStringAsFixed(2)} $created";
        else if (_metric == StrengthMetric.volume ||
            _metric == StrengthMetric.oneRepMax)
          text = "${formatter.format(row.value)}$_targetUnit $created";

        return [
          LineTooltipItem(text,
              TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color))
        ];
      },
    );
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
        child: material.Column(
          children: [
            if (widget.name != 'Weight')
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Metric'),
                value: _metric,
                items: const [
                  DropdownMenuItem(
                    value: StrengthMetric.bestWeight,
                    child: Text("Best weight"),
                  ),
                  DropdownMenuItem(
                    value: StrengthMetric.oneRepMax,
                    child: Text("One rep max"),
                  ),
                  DropdownMenuItem(
                    value: StrengthMetric.volume,
                    child: Text("Volume"),
                  ),
                  DropdownMenuItem(
                    value: StrengthMetric.relativeStrength,
                    child: Text("Relative strength"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _metric = value!;
                  });
                  _setData();
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
            if (settings.showUnits)
              DropdownButtonFormField<String>(
                value: _targetUnit,
                decoration: const InputDecoration(labelText: 'Unit'),
                items: ['kg', 'lb'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _targetUnit = newValue!;
                  });
                },
              ),
            if (_strengthData.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 80.0, right: 32.0, top: 16.0),
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
                                _bottomTitleWidgets(value, meta),
                          ),
                        ),
                      ),
                      lineTouchData: LineTouchData(
                        enabled: true,
                        touchCallback: (event, touchResponse) async {
                          if (event is! FlPanDownEvent) return;
                          if (_metric != StrengthMetric.bestWeight) return;
                          if (DateTime.now().difference(_lastTap) <
                              const Duration(milliseconds: 300)) {
                            final index =
                                touchResponse?.lineBarSpots?[0].spotIndex;
                            if (index == null) return;
                            final row = _strengthData[index];
                            final gymSet = await (db.gymSets.select()
                                  ..where(
                                      (tbl) => tbl.created.equals(row.created))
                                  ..where((tbl) => tbl.reps.equals(row.reps!))
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
                          _lastTap = DateTime.now();
                        },
                        touchTooltipData: _tooltipData(context),
                        longPressDuration: Duration.zero,
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _spots,
                          isCurved: _settings.curveLines,
                          color: Theme.of(context).colorScheme.primary,
                          barWidth: 3,
                          isStrokeCapRound: true,
                        ),
                      ],
                    ),
                  ),
                ),
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
