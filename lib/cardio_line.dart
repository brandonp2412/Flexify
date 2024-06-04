import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/cardio_data.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/gym_sets.dart';
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
  late Stream<List<CardioData>> _graphStream;
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

  @override
  void dispose() {
    super.dispose();
  }

  void _setStream() {
    _graphStream = watchCardio(
      endDate: widget.endDate,
      groupBy: widget.groupBy,
      metric: widget.metric,
      name: widget.name,
      startDate: widget.startDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    _settings = context.watch<SettingsState>();

    return StreamBuilder(
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
        final rows = snapshot.data!;

        for (var index = 0; index < snapshot.data!.length; index++) {
          final row = snapshot.data!.elementAt(index);
          spots.add(FlSpot(index.toDouble(), row.value));
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
                    getTooltipItems: (touchedSpots) {
                      final row = rows.elementAt(touchedSpots.first.spotIndex);
                      String text = row.value.toStringAsFixed(2);
                      switch (widget.metric) {
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
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      ];
                    },
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
