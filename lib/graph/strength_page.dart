import 'dart:async';

import 'package:drift/drift.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/animated_fab.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/graph/edit_graph_page.dart';
import 'package:flexify/graph/flex_line.dart';
import 'package:flexify/graph/graph_history_page.dart';
import 'package:flexify/graph/strength_data.dart';
import 'package:flexify/main.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StrengthPage extends StatefulWidget {
  final String name;
  final String unit;
  final List<StrengthData> data;
  final TabController tabCtrl;

  const StrengthPage({
    super.key,
    required this.name,
    required this.unit,
    required this.data,
    required this.tabCtrl,
  });

  @override
  createState() => _StrengthPageState();
}

class _StrengthPageState extends State<StrengthPage> {
  late List<StrengthData> data = widget.data;
  late String target = widget.unit;
  late String name = widget.name;

  int limit = 20;
  StrengthMetric metric = StrengthMetric.bestWeight;
  Period period = Period.day;
  DateTime? start;
  DateTime? end;
  DateTime lastTap = DateTime.fromMicrosecondsSinceEpoch(0);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>().value;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              String? newName = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditGraphPage(
                    name: name,
                  ),
                ),
              );
              if (mounted && newName != null)
                setState(() {
                  name = newName;
                });
            },
            icon: const Icon(Icons.edit),
            tooltip: "Edit",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Builder(
          builder: (context) {
            List<FlSpot> spots = [];
            for (var index = 0; index < data.length; index++) {
              spots.add(FlSpot(index.toDouble(), data[index].value));
            }

            return ListView(
              children: [
                Visibility(
                  visible: name != 'Weight',
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: 'Metric'),
                    initialValue: metric,
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
                      if (settings.showBodyWeight)
                        const DropdownMenuItem(
                          value: StrengthMetric.relativeStrength,
                          child: Text("Relative strength"),
                        ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        metric = value!;
                      });
                      setData();
                    },
                  ),
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Period'),
                  initialValue: period,
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
                      period = value!;
                    });
                    setData();
                  },
                ),
                Visibility(
                  visible: settings.showUnits,
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Unit'),
                    initialValue: target,
                    items: const [
                      DropdownMenuItem(
                        value: 'kg',
                        child: Text("Kilograms (kg)"),
                      ),
                      DropdownMenuItem(
                        value: 'lb',
                        child: Text("Pounds (lb)"),
                      ),
                      DropdownMenuItem(
                        value: 'stone',
                        child: Text("Stone"),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        target = newValue!;
                      });
                      setData();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: const Text('Start date'),
                          subtitle: start == null
                              ? Text(settings.shortDateFormat)
                              : Text(
                                  DateFormat(settings.shortDateFormat)
                                      .format(start!),
                                ),
                          onLongPress: () {
                            setState(() {
                              start = null;
                            });
                            setData();
                          },
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () => _selectStart(),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('Stop date'),
                          subtitle: Selector<SettingsState, String>(
                            selector: (p0, settings) =>
                                settings.value.shortDateFormat,
                            builder: (context, value, child) {
                              if (end == null) return Text(value);

                              return Text(
                                DateFormat(value).format(end!),
                              );
                            },
                          ),
                          onLongPress: () {
                            setState(() {
                              end = null;
                            });
                            setData();
                          },
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () => _selectEnd(),
                        ),
                      ),
                    ],
                  ),
                ),
                material.Column(
                  children: [
                    material.Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        "Limit ($limit)",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Slider(
                      value: limit.toDouble(),
                      inactiveColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.24),
                      min: 10,
                      max: 100,
                      onChanged: (value) {
                        setState(() {
                          limit = value.toInt();
                        });
                        setData();
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: data.isEmpty
                      ? const ListTile(title: Text("No data yet."))
                      : Padding(
                          padding:
                              const EdgeInsets.only(right: 32.0, top: 16.0),
                          child: FlexLine(
                            data: data,
                            spots: spots,
                            tooltipData: () =>
                                tooltipData(settings.shortDateFormat),
                            touchLine: touchLine,
                          ),
                        ),
                ),
                const SizedBox(height: 75),
              ],
            );
          },
        ),
      ),
      floatingActionButton: AnimatedFab(
        onPressed: () async {
          final gymSets = await (db.gymSets.select()
                ..orderBy(
                  [
                    (u) => OrderingTerm(
                          expression: u.created,
                          mode: OrderingMode.desc,
                        ),
                  ],
                )
                ..where((tbl) => tbl.name.equals(name))
                ..where((tbl) => tbl.hidden.equals(false))
                ..limit(20))
              .get();
          if (!context.mounted) return;

          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GraphHistoryPage(
                name: name,
                gymSets: gymSets,
              ),
            ),
          );
          Timer(kThemeAnimationDuration, setData);
        },
        icon: const Icon(Icons.history),
        label: const Text('History'),
      ),
    );
  }

  Future<void> setData() async {
    if (!mounted) return;
    final strengthData = await getStrengthData(
      target: target,
      name: widget.name,
      metric: metric,
      period: period,
      start: start,
      end: end,
      limit: limit,
    );
    setState(() {
      data = strengthData;
    });
  }

  LineTouchTooltipData tooltipData(
    String format,
  ) {
    return LineTouchTooltipData(
      getTooltipColor: (touch) => Theme.of(context).colorScheme.surface,
      getTooltipItems: (touchedSpots) {
        final row = data.elementAt(touchedSpots.last.spotIndex);
        final created = DateFormat(format).format(row.created);
        final formatter = NumberFormat("#,###.00");

        String text = "${row.value.toStringAsFixed(2)}$target $created";
        switch (metric) {
          case StrengthMetric.bestReps:
          case StrengthMetric.relativeStrength:
            text = "${row.value.toStringAsFixed(2)} $created";
            break;
          case StrengthMetric.volume:
          case StrengthMetric.oneRepMax:
            text = "${formatter.format(row.value)}$target $created";
            break;
          case StrengthMetric.bestWeight:
            break;
        }

        return [
          LineTooltipItem(
            text,
            TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
          ),
          if (touchedSpots.length > 1) null,
        ];
      },
    );
  }

  Future<void> touchLine(
    FlTouchEvent event,
    LineTouchResponse? touchResponse,
  ) async {
    if (event is ScaleUpdateDetails) return;
    if (event is! FlPanDownEvent) return;
    if (DateTime.now().difference(lastTap) >= const Duration(milliseconds: 300))
      return setState(() {
        lastTap = DateTime.now();
      });

    final index = touchResponse?.lineBarSpots?[0].spotIndex;
    if (index == null) return;
    final row = data[index];
    GymSet? gymSet;

    switch (metric) {
      case StrengthMetric.oneRepMax:
        final ormExpression = db.gymSets.weight /
            (const CustomExpression<double>('1.0278 - 0.0278 * reps'));
        gymSet = await (db.gymSets.select()
              ..where(
                (tbl) =>
                    tbl.created.equals(row.created) &
                    ormExpression.equals(row.value) &
                    tbl.name.equals(widget.name),
              )
              ..limit(1))
            .getSingle();
        break;
      case StrengthMetric.volume:
        gymSet = await (db.gymSets.select()
              ..where(
                (tbl) =>
                    tbl.created.equals(row.created) &
                    tbl.name.equals(widget.name),
              )
              ..limit(1))
            .getSingle();
        break;
      case StrengthMetric.bestWeight:
        gymSet = await (db.gymSets.select()
              ..where(
                (tbl) =>
                    tbl.created.equals(row.created) &
                    tbl.weight.equals(row.value) &
                    tbl.name.equals(widget.name),
              )
              ..limit(1))
            .getSingle();
        break;
      case StrengthMetric.relativeStrength:
        gymSet = await (db.gymSets.select()
              ..where(
                (tbl) =>
                    tbl.created.equals(row.created) &
                    ((tbl.weight / tbl.bodyWeight).equals(row.value) |
                        (tbl.weight / tbl.bodyWeight).isNull()) &
                    tbl.name.equals(widget.name),
              )
              ..limit(1))
            .getSingle();
        break;
      case StrengthMetric.bestReps:
        gymSet = await (db.gymSets.select()
              ..where(
                (tbl) =>
                    tbl.created.equals(row.created) &
                    tbl.reps.equals(row.value) &
                    tbl.name.equals(widget.name),
              )
              ..limit(1))
            .getSingle();
        break;
    }

    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSetPage(
          gymSet: gymSet!,
        ),
      ),
    );
    Timer(kThemeAnimationDuration, setData);
  }

  Future<void> _selectEnd() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: end,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    setState(() {
      end = pickedDate;
    });
    setData();
  }

  Future<void> _selectStart() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: start,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    setState(() {
      start = pickedDate;
    });
    setData();
  }
}
