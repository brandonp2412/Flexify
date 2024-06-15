import 'package:drift/drift.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/edit_gym_set.dart';
import 'package:flexify/graph/edit_graph_page.dart';
import 'package:flexify/graph/view_graph.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/graph/strength_data.dart';
import 'package:flexify/unit_selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StrengthPage extends StatefulWidget {
  final String name;
  final String unit;

  const StrengthPage({super.key, required this.name, required this.unit});

  @override
  createState() => _StrengthPageState();
}

class _StrengthPageState extends State<StrengthPage> {
  late String _targetUnit = widget.unit;
  late Stream<List<StrengthData>> _graphStream;
  StrengthMetric _metric = StrengthMetric.bestWeight;
  Period _period = Period.day;
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime _lastTap = DateTime.fromMicrosecondsSinceEpoch(0);

  final _ormCol = db.gymSets.weight /
      (const Variable(1.0278) - const Variable(0.0278) * db.gymSets.reps);
  final _volumeCol =
      const CustomExpression<double>("ROUND(SUM(weight * reps), 2)");
  final _relativeCol = db.gymSets.weight.max() / db.gymSets.bodyWeight;

  @override
  initState() {
    super.initState();
    if (widget.name == 'Weight') _period = Period.week;
    _setStream();
  }

  Future<void> _selectEnd() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    setState(() {
      _endDate = pickedDate;
    });
    _setStream();
  }

  Future<void> _selectStart() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    setState(() {
      _startDate = pickedDate;
    });
    _setStream();
  }

  Widget _bottomTitleWidgets(
    double value,
    TitleMeta meta,
    List<StrengthData> rows,
    SettingsState settings,
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
        DateFormat(settings.shortDateFormat).format(createdDate),
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

  LineTouchTooltipData _tooltipData(
    BuildContext context,
    List<StrengthData> rows,
    SettingsState settings,
  ) {
    return LineTouchTooltipData(
      getTooltipColor: (touch) => Theme.of(context).colorScheme.surface,
      getTooltipItems: (touchedSpots) {
        final row = rows.elementAt(touchedSpots.first.spotIndex);
        final created =
            DateFormat(settings.shortDateFormat).format(row.created);
        final formatter = NumberFormat("#,###.00");

        String text =
            "${row.reps} x ${row.value.toStringAsFixed(2)}$_targetUnit $created";
        switch (_metric) {
          case StrengthMetric.bestReps:
          case StrengthMetric.relativeStrength:
            text = "${row.value.toStringAsFixed(2)} $created";
            break;
          case StrengthMetric.volume:
          case StrengthMetric.oneRepMax:
            text = "${formatter.format(row.value)}$_targetUnit $created";
            break;
          case StrengthMetric.bestWeight:
            break;
        }

        return [
          LineTooltipItem(
            text,
            TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
          ),
        ];
      },
    );
  }

  void _setStream() {
    Expression<String> createdCol = const CustomExpression<String>(
      "STRFTIME('%Y-%m-%d', DATE(created, 'unixepoch', 'localtime'))",
    );
    if (_period == Period.month)
      createdCol = const CustomExpression<String>(
        "STRFTIME('%Y-%m', DATE(created, 'unixepoch', 'localtime'))",
      );
    else if (_period == Period.week)
      createdCol = const CustomExpression<String>(
        "STRFTIME('%Y-%m-%W', DATE(created, 'unixepoch', 'localtime'))",
      );
    else if (_period == Period.year)
      createdCol = const CustomExpression<String>(
        "STRFTIME('%Y', DATE(created, 'unixepoch', 'localtime'))",
      );

    setState(() {
      _graphStream = (db.selectOnly(db.gymSets)
            ..addColumns([
              db.gymSets.weight.max(),
              _volumeCol,
              _ormCol,
              db.gymSets.created,
              if (_metric == StrengthMetric.bestReps) db.gymSets.reps.max(),
              if (_metric != StrengthMetric.bestReps) db.gymSets.reps,
              db.gymSets.unit,
              _relativeCol,
            ])
            ..where(db.gymSets.name.equals(widget.name))
            ..where(db.gymSets.hidden.equals(false))
            ..where(
              db.gymSets.created
                  .isBiggerOrEqualValue(_startDate ?? DateTime(0)),
            )
            ..where(
              db.gymSets.created.isSmallerThanValue(
                _endDate ??
                    DateTime.now().toLocal().add(const Duration(days: 1)),
              ),
            )
            ..orderBy([
              OrderingTerm(
                expression: createdCol,
                mode: OrderingMode.desc,
              ),
            ])
            ..limit(11)
            ..groupBy([createdCol]))
          .watch()
          .map(
        (results) {
          List<StrengthData> list = [];
          for (final result in results.reversed) {
            final unit = result.read(db.gymSets.unit)!;
            var value = _getValue(result, _metric);

            if (unit == 'lb' && _targetUnit == 'kg') {
              value *= 0.45359237;
            } else if (unit == 'kg' && _targetUnit == 'lb') {
              value *= 2.20462262;
            }

            double reps = 0.0;
            try {
              reps = result.read(db.gymSets.reps)!;
            } catch (_) {}

            list.add(
              StrengthData(
                created: result.read(db.gymSets.created)!.toLocal(),
                value: value,
                unit: unit,
                reps: reps,
              ),
            );
          }
          return list;
        },
      );
    });
  }

  double _getValue(TypedResult row, StrengthMetric metric) {
    switch (metric) {
      case StrengthMetric.oneRepMax:
        return row.read(_ormCol)!;
      case StrengthMetric.volume:
        return row.read(_volumeCol)!;
      case StrengthMetric.relativeStrength:
        return row.read(_relativeCol) ?? 0;
      case StrengthMetric.bestWeight:
        return row.read(db.gymSets.weight.max())!;
      case StrengthMetric.bestReps:
        try {
          return row.read(db.gymSets.reps.max())!;
        } catch (error) {
          return 0;
        }
    }
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
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit),
            tooltip: "Edit",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: StreamBuilder(
          stream: _graphStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();
            if (snapshot.data?.isEmpty == true)
              return ListTile(
                title: Text("No data yet for ${widget.name}"),
                subtitle: const Text("Complete some plans to view graphs here"),
                contentPadding: EdgeInsets.zero,
              );
            if (snapshot.hasError)
              return ErrorWidget(snapshot.error.toString());

            List<FlSpot> spots = [];
            final rows = snapshot.data!;

            for (var index = 0; index < snapshot.data!.length; index++) {
              spots.add(FlSpot(index.toDouble(), snapshot.data![index].value));
            }

            return ListView(
              children: [
                if (widget.name != 'Weight')
                  DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: 'Metric'),
                    value: _metric,
                    items: [
                      const DropdownMenuItem(
                        value: StrengthMetric.bestWeight,
                        child: Text("Best weight"),
                      ),
                      const DropdownMenuItem(
                        value: StrengthMetric.bestReps,
                        child: Text("Best reps"),
                      ),
                      const DropdownMenuItem(
                        value: StrengthMetric.oneRepMax,
                        child: Text("One rep max"),
                      ),
                      const DropdownMenuItem(
                        value: StrengthMetric.volume,
                        child: Text("Volume"),
                      ),
                      if (!settings.hideWeight)
                        const DropdownMenuItem(
                          value: StrengthMetric.relativeStrength,
                          child: Text("Relative strength"),
                        ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _metric = value!;
                      });
                      _setStream();
                    },
                  ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Period'),
                  value: _period,
                  items: const [
                    DropdownMenuItem(
                      value: Period.day,
                      child: Text("Daily"),
                    ),
                    DropdownMenuItem(
                      value: Period.week,
                      child: Text("Weekly"),
                    ),
                    DropdownMenuItem(
                      value: Period.month,
                      child: Text("Monthly"),
                    ),
                    DropdownMenuItem(
                      value: Period.year,
                      child: Text("Yearly"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _period = value!;
                    });
                    _setStream();
                  },
                ),
                if (settings.showUnits)
                  UnitSelector(
                    value: _targetUnit,
                    cardio: false,
                    onChanged: (value) {
                      setState(() {
                        _targetUnit = value!;
                      });
                      _setStream();
                    },
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: const Text('Start date'),
                          subtitle: _startDate != null
                              ? Text(
                                  DateFormat(settings.shortDateFormat)
                                      .format(_startDate!),
                                )
                              : null,
                          onLongPress: () => setState(() {
                            _startDate = null;
                          }),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () => _selectStart(),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('Stop date'),
                          subtitle: _endDate != null
                              ? Text(
                                  DateFormat(settings.shortDateFormat)
                                      .format(_endDate!),
                                )
                              : null,
                          onLongPress: () => setState(() {
                            _endDate = null;
                          }),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () => _selectEnd(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 32.0, top: 16.0),
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
                                  _bottomTitleWidgets(
                                value,
                                meta,
                                rows,
                                settings,
                              ),
                            ),
                          ),
                        ),
                        lineTouchData: LineTouchData(
                          enabled: true,
                          touchCallback: (event, touchResponse) async {
                            if (event is ScaleUpdateDetails) return;
                            if (event is! FlPanDownEvent) return;
                            if (_metric != StrengthMetric.bestWeight) return;
                            if (DateTime.now().difference(_lastTap) <
                                const Duration(milliseconds: 300)) {
                              final index =
                                  touchResponse?.lineBarSpots?[0].spotIndex;
                              if (index == null) return;
                              final row = rows[index];
                              final gymSet = await (db.gymSets.select()
                                    ..where(
                                      (tbl) => tbl.created.equals(row.created),
                                    )
                                    ..where((tbl) => tbl.reps.equals(row.reps))
                                    ..where(
                                      (tbl) => tbl.weight.equals(row.value),
                                    )
                                    ..where(
                                      (tbl) => tbl.name.equals(widget.name),
                                    )
                                    ..limit(1))
                                  .getSingle();

                              if (!context.mounted) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditGymSet(
                                    gymSet: gymSet,
                                  ),
                                ),
                              );
                            }
                            setState(() {
                              _lastTap = DateTime.now();
                            });
                          },
                          touchTooltipData:
                              _tooltipData(context, rows, settings),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: settings.curveLines,
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
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViewGraph(name: widget.name),
          ),
        ),
        child: const Icon(Icons.history),
      ),
    );
  }
}
