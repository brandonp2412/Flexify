import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FlexLine extends StatelessWidget {
  final List<FlSpot> spots;
  final List<dynamic> data;
  final bool? hideBottom;
  final bool? hideLeft;

  final LineTouchTooltipData Function() tooltipData;

  final void Function(
    FlTouchEvent event,
    LineTouchResponse? touchResponse,
  )? touchLine;

  const FlexLine({
    super.key,
    required this.spots,
    required this.tooltipData,
    required this.data,
    this.touchLine,
    this.hideBottom,
    this.hideLeft,
  });

  Widget bottomTitleWidgets(
    double value,
    TitleMeta meta,
    String format,
    BuildContext context,
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
    List<Color> gradientColors = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.surface,
    ];

    final settings = context.watch<SettingsState>().value;

    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: hideLeft != true,
              reservedSize: 45,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: hideBottom != true,
              reservedSize: 27,
              interval: 1,
              getTitlesWidget: (value, meta) => bottomTitleWidgets(
                value,
                meta,
                settings.shortDateFormat,
                context,
              ),
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          touchCallback: touchLine != null
              ? (event, touchResponse) => touchLine!(event, touchResponse)
              : null,
          touchTooltipData: tooltipData(),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: settings.curveLines,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            curveSmoothness: settings.curveSmoothness ?? 0.35,
            dotData: const FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors
                    .map((color) => color.withValues(alpha: 0.3))
                    .toList(),
              ),
            ),
          ),
        ],
        gridData: const FlGridData(show: false),
      ),
    );
  }
}
