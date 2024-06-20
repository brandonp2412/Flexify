import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/graph/cardio_data.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/graph/edit_graph_page.dart';
import 'package:flexify/graph/view_graph.dart';
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
  late String _targetUnit = widget.unit;
  late Stream<List<CardioData>> _graphStream;
  CardioMetric _metric = CardioMetric.pace;
  Period _period = Period.day;

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _setStream();
  }

  void _setStream() {
    _graphStream = watchCardio(
      endDate: _endDate,
      groupBy: _period,
      metric: _metric,
      name: widget.name,
      startDate: _startDate,
      targetUnit: _targetUnit,
    );
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
    List<CardioData> rows,
    SettingsState settings,
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
              final row = snapshot.data!.elementAt(index);
              final value = double.parse(row.value.toStringAsFixed(1));
              spots.add(FlSpot(index.toDouble(), value));
            }

            return ListView(
              children: [
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Metric'),
                  value: _metric,
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
                if (_metric == CardioMetric.distance && settings.showUnits)
                  UnitSelector(
                    value: _targetUnit,
                    cardio: true,
                    onChanged: (value) {
                      setState(() {
                        _targetUnit = value!;
                      });
                      _setStream();
                    },
                  ),
                Row(
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
                                settings,
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
                              switch (_metric) {
                                case CardioMetric.pace:
                                case CardioMetric.duration:
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
