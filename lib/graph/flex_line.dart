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
  final bool? showTrendLine; // New parameter to control trend line visibility
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
    this.showTrendLine = true, // Default to showing trend line
  });

  // Calculate linear regression trend line
  List<FlSpot> _calculateTrendLine(List<FlSpot> spots) {
    if (spots.length < 2) return [];

    double sumX = 0, sumY = 0, sumXY = 0, sumXX = 0;
    int n = spots.length;

    for (FlSpot spot in spots) {
      sumX += spot.x;
      sumY += spot.y;
      sumXY += spot.x * spot.y;
      sumXX += spot.x * spot.x;
    }

    // Calculate slope (m) and y-intercept (b) for y = mx + b
    double slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);
    double intercept = (sumY - slope * sumX) / n;

    // Generate trend line points from first to last x value
    double startX = spots.first.x;
    double endX = spots.last.x;

    return [
      FlSpot(startX, slope * startX + intercept),
      FlSpot(endX, slope * endX + intercept),
    ];
  }

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
    double screen = MediaQuery.of(context).size.width;
    double label = 120;
    int count = (screen / label).floor();
    List<int> indices = List.generate(count, (index) {
      return ((data.length - 1) * index / (count - 1)).round();
    });

    if (indices.contains(value.toInt())) {
      DateTime created = data[value.toInt()].created;
      text = Text(
        DateFormat(format).format(created),
        style: style,
      );
    } else {
      text = const Text('', style: style);
    }

    return SideTitleWidget(
      meta: meta,
      child: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.surface,
    ];
    final settings = context.watch<SettingsState>().value;

    // Calculate trend line spots
    List<FlSpot> trendSpots =
        showTrendLine == true ? _calculateTrendLine(spots) : [];

    // Prepare line bars data
    List<LineChartBarData> lineBarsData = [
      // Original data line
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
        preventCurveOverShooting: true,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors:
                colors.map((color) => color.withValues(alpha: 0.3)).toList(),
          ),
        ),
      ),
    ];

    // Add trend line if enabled and we have enough data points
    if (showTrendLine == true && trendSpots.isNotEmpty) {
      lineBarsData.add(
        LineChartBarData(
          spots: trendSpots,
          isCurved: false, // Trend line should always be straight
          color: Theme.of(context).colorScheme.secondary,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          dashArray: [5, 5], // Makes the trend line dashed
          belowBarData: BarAreaData(show: false), // No fill for trend line
        ),
      );
    }

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
        lineBarsData: lineBarsData,
        gridData: const FlGridData(show: false),
      ),
    );
  }
}
