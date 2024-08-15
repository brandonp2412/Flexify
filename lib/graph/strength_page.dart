import 'package:drift/drift.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/graph/edit_graph_page.dart';
import 'package:flexify/graph/graph_history_page.dart';
import 'package:flexify/graph/strength_data.dart';
import 'package:flexify/main.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/unit_selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StrengthPage extends StatefulWidget {
  final String name;
  final String unit;
  final List<StrengthData> data;

  const StrengthPage({
    super.key,
    required this.name,
    required this.unit,
    required this.data,
  });

  @override
  createState() => _StrengthPageState();
}

class _StrengthPageState extends State<StrengthPage> {
  late List<StrengthData> data = widget.data;
  late String targetUnit = widget.unit;
  StrengthMetric metric = StrengthMetric.bestWeight;
  Period period = Period.day;
  DateTime? startDate;
  DateTime? endDate;
  DateTime lastTap = DateTime.fromMicrosecondsSinceEpoch(0);
  TabController? tabController;

  Widget bottomTitleWidgets(
    double value,
    TitleMeta meta,
    String format,
  ) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;

    double screenWidth = MediaQuery.of(context).size.width;
    double labelWidth = 120;
    int labelCount = (screenWidth / labelWidth).floor();
    List<int> indices = List.generate(labelCount, (index) {
      return ((data.length - 1) * index / (labelCount - 1)).round();
    });

    if (indices.contains(value.toInt())) {
      DateTime createdDate = data[value.toInt()].created;
      text = Text(
        DateFormat(format).format(createdDate),
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
            if (data.isEmpty)
              return const ListTile(title: Text("No data yet."));

            List<FlSpot> spots = [];
            for (var index = 0; index < data.length; index++) {
              spots.add(FlSpot(index.toDouble(), data[index].value));
            }

            final format = context.select<SettingsState, String>(
              (settings) => settings.value.shortDateFormat,
            );

            final curveLines = context.select<SettingsState, bool>(
              (settings) => settings.value.curveLines,
            );

            return ListView(
              children: [
                Selector<SettingsState, bool>(
                  selector: (context, settings) =>
                      settings.value.showBodyWeight,
                  builder: (context, showBodyWeight, child) => Visibility(
                    visible: widget.name != 'Weight',
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(labelText: 'Metric'),
                      value: metric,
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
                        if (showBodyWeight)
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
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Period'),
                  value: period,
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
                Selector<SettingsState, bool>(
                  builder: (context, showUnits, child) => Visibility(
                    visible: showUnits,
                    child: UnitSelector(
                      value: targetUnit,
                      cardio: false,
                      onChanged: (value) {
                        setState(() {
                          targetUnit = value!;
                        });
                        setData();
                      },
                    ),
                  ),
                  selector: (context, settings) => settings.value.showUnits,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: const Text('Start date'),
                          subtitle: Selector<SettingsState, String>(
                            selector: (p0, settings) =>
                                settings.value.shortDateFormat,
                            builder: (context, value, child) {
                              if (startDate == null) return Text(value);

                              return Text(
                                DateFormat(value).format(startDate!),
                              );
                            },
                          ),
                          onLongPress: () => setState(() {
                            startDate = null;
                          }),
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
                              if (endDate == null) return Text(value);

                              return Text(
                                DateFormat(value).format(endDate!),
                              );
                            },
                          ),
                          onLongPress: () => setState(() {
                            endDate = null;
                          }),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () => _selectEnd(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 350,
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
                                  bottomTitleWidgets(
                                value,
                                meta,
                                format,
                              ),
                            ),
                          ),
                        ),
                        lineTouchData: LineTouchData(
                          enabled: true,
                          touchCallback: (event, touchResponse) =>
                              touchLine(event, touchResponse),
                          touchTooltipData: tooltipData(context, format),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: curveLines,
                            color: Theme.of(context).colorScheme.primary,
                            barWidth: 3,
                            isStrokeCapRound: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 75),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GraphHistoryPage(name: widget.name),
          ),
        ),
        child: const Icon(Icons.history),
      ),
    );
  }

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      tabController = DefaultTabController.of(context);
      tabController?.addListener(tabListener);
    });
  }

  void tabListener() {
    final settings = context.read<SettingsState>().value;
    final graphsIndex = settings.tabs.split(',').indexOf('GraphsPage');
    if (tabController!.indexIsChanging == true) return;
    if (tabController!.index != graphsIndex) return;
    setData();
  }

  @override
  void dispose() {
    tabController?.removeListener(tabListener);
    super.dispose();
  }

  Future<void> setData() async {
    if (!mounted) return;
    final strengthData = await getStrengthData(
      targetUnit: targetUnit,
      name: widget.name,
      metric: metric,
      period: period,
      startDate: startDate,
      endDate: endDate,
    );
    setState(() {
      data = strengthData;
    });
  }

  LineTouchTooltipData tooltipData(
    BuildContext context,
    String format,
  ) {
    return LineTouchTooltipData(
      getTooltipColor: (touch) => Theme.of(context).colorScheme.surface,
      getTooltipItems: (touchedSpots) {
        final row = data.elementAt(touchedSpots.first.spotIndex);
        final created = DateFormat(format).format(row.created);
        final formatter = NumberFormat("#,###.00");

        String text =
            "${row.reps} x ${row.value.toStringAsFixed(2)}$targetUnit $created";
        switch (metric) {
          case StrengthMetric.bestReps:
          case StrengthMetric.relativeStrength:
            text = "${row.value.toStringAsFixed(2)} $created";
            break;
          case StrengthMetric.volume:
          case StrengthMetric.oneRepMax:
            text = "${formatter.format(row.value)}$targetUnit $created";
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

  touchLine(
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
                    tbl.reps.equals(row.reps) &
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSetPage(
          gymSet: gymSet!,
        ),
      ),
    );
  }

  Future<void> _selectEnd() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    setState(() {
      endDate = pickedDate;
    });
    setData();
  }

  Future<void> _selectStart() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    setState(() {
      startDate = pickedDate;
    });
    setData();
  }
}
