import 'dart:async';

import 'package:drift/drift.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/animated_fab.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/graph/cardio_data.dart';
import 'package:flexify/graph/edit_graph_page.dart';
import 'package:flexify/graph/flex_line.dart';
import 'package:flexify/graph/graph_history_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CardioPage extends StatefulWidget {
  final String name;
  final String unit;
  final List<CardioData> data;

  const CardioPage({
    super.key,
    required this.name,
    required this.unit,
    required this.data,
  });

  @override
  createState() => _CardioPageState();
}

class _CardioPageState extends State<CardioPage> {
  late List<CardioData> data = widget.data;
  late String target = widget.unit;
  CardioMetric metric = CardioMetric.pace;
  Period period = Period.day;
  DateTime? start;
  DateTime? end;
  TabController? ctrl;
  DateTime lastTap = DateTime(0);

  LineTouchTooltipData tooltipData(String format) => LineTouchTooltipData(
        getTooltipColor: (touch) => Theme.of(context).colorScheme.surface,
        getTooltipItems: (touchedSpots) {
          final row = data.elementAt(touchedSpots.last.spotIndex);
          String text = row.value.toStringAsFixed(2);
          final created = DateFormat(format).format(row.created);

          switch (metric) {
            case CardioMetric.pace:
              text = "${row.value} ${row.unit} / min";
              break;
            case CardioMetric.duration:
              final minutes = row.value.floor();
              final seconds =
                  ((row.value * 60) % 60).floor().toString().padLeft(2, '0');
              text = "$minutes:$seconds";
              break;
            case CardioMetric.distance:
              text += " ${row.unit}";
              break;
            case CardioMetric.incline:
              text += "%";
              break;
            case CardioMetric.inclineAdjustedPace:
              break;
          }

          return [
            LineTooltipItem(
              "$text\n$created",
              TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            if (touchedSpots.length > 1) null,
          ];
        },
      );

  Future<void> touchLine(
    FlTouchEvent event,
    LineTouchResponse? response,
  ) async {
    if (event is ScaleUpdateDetails) return;
    if (event is! FlPanDownEvent) return;
    if (DateTime.now().difference(lastTap) >= const Duration(milliseconds: 300))
      return setState(() {
        lastTap = DateTime.now();
      });

    final index = response?.lineBarSpots?[0].spotIndex;
    if (index == null) return;
    final row = data[index];
    GymSet? gymSet = await (db.gymSets.select()
          ..where(
            (tbl) =>
                tbl.created.equals(row.created) & tbl.name.equals(widget.name),
          )
          ..limit(1))
        .getSingle();

    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSetPage(
          gymSet: gymSet,
        ),
      ),
    );
    Timer(kThemeAnimationDuration, setData);
  }

  @override
  Widget build(BuildContext context) {
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
        child: Builder(
          builder: (context) {
            List<FlSpot> spots = [];
            final rows = data;

            for (var index = 0; index < rows.length; index++) {
              final row = rows.elementAt(index);
              final value = double.parse(row.value.toStringAsFixed(1));
              spots.add(FlSpot(index.toDouble(), value));
            }

            final settings = context.watch<SettingsState>().value;

            return ListView(
              children: [
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Metric'),
                  initialValue: metric,
                  items: const [
                    DropdownMenuItem(
                      value: CardioMetric.pace,
                      child: Text("Pace (distance / time)"),
                    ),
                    DropdownMenuItem(
                      value: CardioMetric.inclineAdjustedPace,
                      child: Text("Adjusted pace"),
                    ),
                    DropdownMenuItem(
                      value: CardioMetric.duration,
                      child: Text("Duration"),
                    ),
                    DropdownMenuItem(
                      value: CardioMetric.distance,
                      child: Text("Distance"),
                    ),
                    DropdownMenuItem(
                      value: CardioMetric.incline,
                      child: Text("Incline"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      metric = value!;
                    });
                    setData();
                  },
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
                if (metric == CardioMetric.distance)
                  Selector<SettingsState, bool>(
                    selector: (p0, p1) => p1.value.showUnits,
                    builder: (context, value, child) => Visibility(
                      visible: value,
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Unit'),
                        initialValue: target,
                        items: const [
                          DropdownMenuItem(
                            value: 'km',
                            child: Text("Kilometers (km)"),
                          ),
                          DropdownMenuItem(
                            value: 'mi',
                            child: Text("Miles (mi)"),
                          ),
                          DropdownMenuItem(
                            value: 'm',
                            child: Text("Meters (m)"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            target = value!;
                          });
                          setData();
                        },
                      ),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Start date'),
                        subtitle: Selector<SettingsState, String>(
                          selector: (p0, settings) =>
                              settings.value.shortDateFormat,
                          builder: (context, value, child) {
                            if (start == null) return Text(value);

                            return Text(
                              DateFormat(value).format(start!),
                            );
                          },
                        ),
                        onLongPress: () => setState(() {
                          start = null;
                        }),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () => _selectStart(),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('Stop date'),
                        subtitle: Selector<SettingsState, String>(
                          selector: (context, settings) =>
                              settings.value.shortDateFormat,
                          builder: (context, value, child) {
                            if (end == null) return Text(value);

                            return Text(
                              DateFormat(value).format(end!),
                            );
                          },
                        ),
                        onLongPress: () => setState(() {
                          end = null;
                        }),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () => _selectEnd(),
                      ),
                    ),
                  ],
                ),
                if (rows.isEmpty)
                  ListTile(
                    title: Text("No data yet for ${widget.name}"),
                    subtitle:
                        const Text("Complete some plans to view graphs here"),
                    contentPadding: EdgeInsets.zero,
                  ),
                if (rows.isNotEmpty)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.40,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 32.0, top: 16.0),
                      child: FlexLine(
                        spots: spots,
                        tooltipData: () =>
                            tooltipData(settings.shortDateFormat),
                        touchLine: touchLine,
                        data: data,
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
                ..where((tbl) => tbl.name.equals(widget.name))
                ..where((tbl) => tbl.hidden.equals(false))
                ..limit(20))
              .get();
          if (!context.mounted) return;

          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GraphHistoryPage(
                name: widget.name,
                gymSets: gymSets,
              ),
            ),
          );
          Timer(kThemeAnimationDuration, setData);
        },
        icon: const Icon(Icons.history),
        label: const Text("History"),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl = DefaultTabController.of(context);
      ctrl?.addListener(tabListener);
    });
  }

  void tabListener() {
    final settings = context.read<SettingsState>().value;
    final index = settings.tabs.split(',').indexOf('GraphsPage');
    if (ctrl!.indexIsChanging == true) return;
    if (ctrl!.index != index) return;
    setData();
  }

  @override
  void dispose() {
    ctrl?.removeListener(tabListener);
    super.dispose();
  }

  void setData() async {
    final cardio = await getCardioData(
      end: end,
      period: period,
      metric: metric,
      name: widget.name,
      start: start,
      target: target,
    );

    if (!mounted) return;
    setState(() {
      data = cardio;
    });
  }

  Future<void> _selectEnd() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: end,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;
    setState(() {
      end = picked;
    });
    setData();
  }

  Future<void> _selectStart() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: start,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;
    setState(() {
      start = picked;
    });
    setData();
  }
}
