import 'dart:math';

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
  final bool? showTrendLine;
  final bool timeBasedXAxis;
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
    this.showTrendLine = true,
    this.timeBasedXAxis = false,
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

    double slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);
    double intercept = (sumY - slope * sumX) / n;

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
    int count = max(2, (screen / label).floor());

    if (timeBasedXAxis) {
      if (spots.isEmpty) {
        text = const Text('', style: style);
      } else {
        int nearestIndex = -1;
        double minDiff = 2;
        for (int i = 0; i < spots.length; i++) {
          final d = (spots[i].x - value).abs();
          if (d < minDiff) {
            minDiff = d;
            nearestIndex = i;
          }
        }

        final range = spots.last.x - spots.first.x;
        final spacing = range / (count - 1);
        if (minDiff <= spacing / 2 &&
            nearestIndex >= 0 &&
            nearestIndex < data.length) {
          DateTime created = data[nearestIndex].created;
          text = Text(
            DateFormat(format).format(created),
            style: style,
          );
        } else {
          text = const Text('', style: style);
        }
      }
    } else {
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

    // CRITICAL FIX: Calculate Y-axis min/max to prevent decimal interval issues
    double minY = spots.isEmpty
        ? 0
        : spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    double maxY = spots.isEmpty
        ? 1
        : spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);

    // If range is very small (decimal-only data), expand it to prevent tiny intervals
    double range = maxY - minY;
    if (range < 1.0) {
      // Ensure at least a range of 1.0 to avoid problematic decimal intervals
      double center = (maxY + minY) / 2;
      minY = center - 0.5;
      maxY = center + 0.5;
    }

    List<FlSpot> trendSpots =
        showTrendLine == true ? _calculateTrendLine(spots) : [];

    List<LineChartBarData> lineBarsData = [
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

    if (showTrendLine == true && trendSpots.isNotEmpty) {
      lineBarsData.add(
        LineChartBarData(
          spots: trendSpots,
          isCurved: false,
          color: Theme.of(context).colorScheme.secondary,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          dashArray: [5, 5],
          belowBarData: BarAreaData(show: false),
        ),
      );
    }

    // Determine interval for bottom titles
    double? bottomInterval;
    if (timeBasedXAxis && spots.length > 1) {
      double screen = MediaQuery.of(context).size.width;
      double label = 120;
      int count = max(2, (screen / label).floor());
      bottomInterval = (spots.last.x - spots.first.x) / (count - 1);
    } else {
      bottomInterval = 1;
    }

    return LineChart(
      LineChartData(
        // FIX: Set explicit min/max for Y-axis to prevent decimal interval issues
        minY: minY,
        maxY: maxY,
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
              interval: bottomInterval,
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
