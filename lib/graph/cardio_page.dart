import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/graph/cardio_data.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/graph/edit_graph_page.dart';
import 'package:flexify/graph/view_graph_page.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/unit_selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CardioPage extends StatefulWidget {
  final String name;
  final String unit;
  const CardioPage({super.key, required this.name, required this.unit});

  @override
  createState() => _CardioPageState();
}

class _CardioPageState extends State<CardioPage> {
  late String targetUnit = widget.unit;
  late Stream<List<CardioData>> graphStream;
  CardioMetric metric = CardioMetric.pace;
  Period period = Period.day;

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    _setStream();
  }

  void _setStream() {
    graphStream = watchCardio(
      endDate: endDate,
      groupBy: period,
      metric: metric,
      name: widget.name,
      startDate: startDate,
      targetUnit: targetUnit,
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
    _setStream();
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
    _setStream();
  }

  Widget _bottomTitleWidgets(
    double value,
    TitleMeta meta,
    List<CardioData> rows,
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
      return ((rows.length - 1) * index / (labelCount - 1)).round();
    });

    if (indices.contains(value.toInt())) {
      DateTime createdDate = rows[value.toInt()].created;
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
        child: StreamBuilder(
          stream: graphStream,
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
              final row = snapshot.data!.elementAt(index);
              final value = double.parse(row.value.toStringAsFixed(1));
              spots.add(FlSpot(index.toDouble(), value));
            }

            final curveLines = context
                .select<SettingsState, bool>((value) => value.curveLines);
            final format = context.select<SettingsState, String>(
                (value) => value.shortDateFormat);

            return ListView(
              children: [
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Metric'),
                  value: metric,
                  items: const [
                    DropdownMenuItem(
                      value: CardioMetric.pace,
                      child: Text("Pace (distance / time)"),
                    ),
                    DropdownMenuItem(
                      value: CardioMetric.duration,
                      child: Text("Duration"),
                    ),
                    DropdownMenuItem(
                      value: CardioMetric.distance,
                      child: Text("Distance"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      metric = value!;
                    });
                    _setStream();
                  },
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
                    _setStream();
                  },
                ),
                if (metric == CardioMetric.distance)
                  Selector<SettingsState, bool>(
                    selector: (p0, p1) => p1.showUnits,
                    builder: (context, value, child) => Visibility(
                      visible: value,
                      child: UnitSelector(
                        value: targetUnit,
                        cardio: true,
                        onChanged: (value) {
                          setState(() {
                            targetUnit = value!;
                          });
                          _setStream();
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
                          selector: (p0, p1) => p1.shortDateFormat,
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
                          selector: (p0, p1) => p1.shortDateFormat,
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
                                  _bottomTitleWidgets(
                                value,
                                meta,
                                rows,
                                format,
                              ),
                            ),
                          ),
                        ),
                        lineTouchData: LineTouchData(
                          enabled: true,
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (touch) =>
                                Theme.of(context).colorScheme.surface,
                            getTooltipItems: (touchedSpots) {
                              final row =
                                  rows.elementAt(touchedSpots.first.spotIndex);
                              String text = row.value.toStringAsFixed(2);
                              switch (metric) {
                                case CardioMetric.pace:
                                  text = "${row.value} ${row.unit} / min";
                                  break;
                                case CardioMetric.duration:
                                  final minutes = row.value.floor();
                                  final seconds = ((row.value * 60) % 60)
                                      .floor()
                                      .toString()
                                      .padLeft(2, '0');
                                  text = "$minutes:$seconds";
                                  break;
                                case CardioMetric.distance:
                                  text += " ${row.unit}";
                                  break;
                              }

                              return [
                                LineTooltipItem(
                                  text,
                                  TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color,
                                  ),
                                ),
                              ];
                            },
                          ),
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
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViewGraphPage(name: widget.name),
          ),
        ),
        child: const Icon(Icons.history),
      ),
    );
  }
}
