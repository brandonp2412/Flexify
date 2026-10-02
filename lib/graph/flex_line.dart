import 'dart:math';

import 'package:drafter/drafter.dart';
import 'package:drafter/painting.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@immutable
class FlexChartPoint {
  final double x;
  final double y;
  final int? column;

  const FlexChartPoint(this.x, this.y, {this.column});
}

@immutable
class FlexLineSeries {
  final List<FlexChartPoint> points;
  final Color color;
  final String name;

  const FlexLineSeries({
    required this.points,
    required this.color,
    this.name = '',
  });
}

@immutable
class _FlexAxisLabel {
  final double x;
  final int? column;
  final String text;

  const _FlexAxisLabel(this.x, this.text, {this.column});
}

class FlexLine extends StatelessWidget {
  static const double _edgePaddingFraction = 0.02;

  final List<FlexChartPoint> points;
  final List<dynamic> data;
  final bool? hideBottom;
  final bool? hideLeft;
  final bool? showTrendLine;
  final bool timeBasedXAxis;
  final String Function(int index) tooltipText;
  final ValueChanged<int>? onPointSelected;

  const FlexLine({
    super.key,
    required this.points,
    required this.tooltipText,
    required this.data,
    this.onPointSelected,
    this.hideBottom,
    this.hideLeft,
    this.showTrendLine = true,
    this.timeBasedXAxis = false,
  });

  List<FlexChartPoint> _calculateTrendLine(List<FlexChartPoint> source) {
    if (source.length < 2) return const [];

    double sumX = 0;
    double sumY = 0;
    double sumXY = 0;
    double sumXX = 0;
    for (final point in source) {
      sumX += point.x;
      sumY += point.y;
      sumXY += point.x * point.y;
      sumXX += point.x * point.x;
    }

    final n = source.length;
    final denominator = n * sumXX - sumX * sumX;
    if (denominator.abs() < 1e-12) return const [];

    final slope = (n * sumXY - sumX * sumY) / denominator;
    final intercept = (sumY - slope * sumX) / n;
    final start = source.first;
    final end = source.last;

    return [
      FlexChartPoint(
        start.x,
        slope * start.x + intercept,
        column: start.column,
      ),
      FlexChartPoint(end.x, slope * end.x + intercept, column: end.column),
    ];
  }

  static (double, double) calculateYBounds(List<FlexChartPoint> source) {
    if (source.isEmpty) return (0, 1);

    var minY = source.map((point) => point.y).reduce(min);
    var maxY = source.map((point) => point.y).reduce(max);
    if (maxY - minY < 1.0) {
      final center = (maxY + minY) / 2;
      minY = center - 0.5;
      maxY = center + 0.5;
    }

    final padding = (maxY - minY) * _edgePaddingFraction;
    return (minY - padding, maxY + padding);
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>().value;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final yBounds = calculateYBounds(points);
    final labels = <_FlexAxisLabel>[];

    if (hideBottom != true) {
      for (
        var index = 0;
        index < points.length && index < data.length;
        index++
      ) {
        final created = data[index].created as DateTime;
        labels.add(
          _FlexAxisLabel(
            points[index].x,
            formatDisplayDate(context, created, settings.shortDateFormat),
            column: points[index].column ?? index,
          ),
        );
      }
    }

    return InteractiveChart(
      animate: false,
      renderer: _FlexLineRenderer(
        series: [FlexLineSeries(points: points, color: primary)],
        trendSeries: showTrendLine == true
            ? FlexLineSeries(
                points: _calculateTrendLine(points),
                color: secondary,
              )
            : null,
        minY: yBounds.$1,
        maxY: yBounds.$2,
        curveLines: settings.curveLines,
        curveSmoothness: settings.curveSmoothness ?? 0.35,
        fillFirstSeries: true,
        showLeftLabels: hideLeft != true,
        showBottomLabels: hideBottom != true,
        xLabels: labels,
        uniformXCount: timeBasedXAxis ? null : points.length,
      ),
      interaction: ChartInteraction(
        tooltip: true,
        selection: onPointSelected != null,
        rowLabel: (mark) => tooltipText(mark.index),
        onSelected: onPointSelected == null
            ? null
            : (selection) {
                if (selection != null) {
                  onPointSelected!(selection.mark.index);
                }
              },
      ),
    );
  }
}

class FlexGroupedLine extends StatelessWidget {
  final List<FlexLineSeries> series;
  final List<String> xLabels;
  final String Function(int seriesIndex, int xIndex) tooltipText;
  final bool showLeftLabels;
  final bool showBottomLabels;

  const FlexGroupedLine({
    super.key,
    required this.series,
    required this.xLabels,
    required this.tooltipText,
    this.showLeftLabels = true,
    this.showBottomLabels = false,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>().value;
    final points = [for (final line in series) ...line.points];

    var minY = points.isEmpty
        ? 0.0
        : points.map((point) => point.y).reduce(min);
    var maxY = points.isEmpty
        ? 1.0
        : points.map((point) => point.y).reduce(max);
    if (maxY - minY < 1.0) {
      final center = (maxY + minY) / 2;
      minY = center - 0.5;
      maxY = center + 0.5;
    }
    final padding = (maxY - minY) * 0.02;
    minY -= padding;
    maxY += padding;

    return InteractiveChart(
      animate: false,
      renderer: _FlexLineRenderer(
        series: series,
        minY: minY,
        maxY: maxY,
        curveLines: settings.curveLines,
        curveSmoothness: settings.curveSmoothness ?? 0.35,
        fillFirstSeries: false,
        showLeftLabels: showLeftLabels,
        showBottomLabels: showBottomLabels,
        xLabels: [
          for (var i = 0; i < xLabels.length; i++)
            _FlexAxisLabel(i.toDouble(), xLabels[i], column: i),
        ],
        uniformXCount: xLabels.length,
      ),
      interaction: ChartInteraction(
        tooltip: true,
        selection: false,
        rowLabel: (mark) => tooltipText(mark.seriesIndex, mark.index),
      ),
    );
  }
}

class _FlexLineRenderer extends ChartRenderer implements InteractiveRenderer {
  final List<FlexLineSeries> series;
  final FlexLineSeries? trendSeries;
  final double minY;
  final double maxY;
  final bool curveLines;
  final double curveSmoothness;
  final bool fillFirstSeries;
  final bool showLeftLabels;
  final bool showBottomLabels;
  final List<_FlexAxisLabel> xLabels;
  final int? uniformXCount;

  const _FlexLineRenderer({
    required this.series,
    required this.minY,
    required this.maxY,
    required this.curveLines,
    required this.curveSmoothness,
    required this.fillFirstSeries,
    required this.showLeftLabels,
    required this.showBottomLabels,
    required this.xLabels,
    required this.uniformXCount,
    this.trendSeries,
  });

  ChartBounds _bounds(Size size) {
    final left = showLeftLabels ? 48.0 : 8.0;
    final bottom = showBottomLabels ? 30.0 : 8.0;
    return ChartBounds.insets(
      size,
      left: left,
      top: 8,
      right: 8,
      bottom: bottom,
    );
  }

  List<FlexChartPoint> get _allPoints => [
    for (final line in series) ...line.points,
  ];

  (double, double) get _xBounds {
    final points = _allPoints;
    if (points.isEmpty) return (0, 1);
    final minX = points.map((point) => point.x).reduce(min);
    final maxX = points.map((point) => point.x).reduce(max);
    return maxX == minX ? (minX - 0.5, maxX + 0.5) : (minX, maxX);
  }

  double _xForPoint(FlexChartPoint point, int pointIndex, ChartBounds bounds) {
    final count = uniformXCount;
    if (count != null) {
      if (count <= 1) return bounds.left + bounds.width / 2;
      final column = point.column ?? pointIndex;
      return bounds.left + bounds.width * column / (count - 1);
    }

    final xBounds = _xBounds;
    return bounds.left +
        bounds.width * (point.x - xBounds.$1) / (xBounds.$2 - xBounds.$1);
  }

  double _yForValue(double value, ChartBounds bounds) {
    final span = maxY - minY;
    if (span == 0) return bounds.bottom;
    return bounds.bottom - (value - minY) / span * bounds.height;
  }

  List<Offset> _pixelPoints(FlexLineSeries line, ChartBounds bounds) => [
    for (var i = 0; i < line.points.length; i++)
      Offset(
        _xForPoint(line.points[i], i, bounds),
        _yForValue(line.points[i].y, bounds),
      ),
  ];

  Path _linePath(List<Offset> points) {
    if (!curveLines || points.length < 3) return polylinePath(points);

    final tension = curveSmoothness.clamp(0.0, 1.0);
    if ((tension - 0.35).abs() < 0.001) return smoothPath(points);

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    final controlScale = tension / 2.1;
    for (var i = 0; i < points.length - 1; i++) {
      final p0 = points[i == 0 ? i : i - 1];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = points[i + 2 >= points.length ? i + 1 : i + 2];
      final c1 = Offset(
        p1.dx + (p2.dx - p0.dx) * controlScale,
        p1.dy + (p2.dy - p0.dy) * controlScale,
      );
      final c2 = Offset(
        p2.dx - (p3.dx - p1.dx) * controlScale,
        p2.dy - (p3.dy - p1.dy) * controlScale,
      );
      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
    }
    return path;
  }

  void _drawSeries(
    Canvas canvas,
    ChartBounds bounds,
    FlexLineSeries line, {
    required bool fill,
    required double progress,
  }) {
    final points = _pixelPoints(line, bounds);
    if (points.length < 2) return;

    final path = _linePath(points);
    final metrics = path.computeMetrics().toList();
    final drawn = Path();
    final clamped = progress.clamp(0.0, 1.0);
    for (final metric in metrics) {
      drawn.addPath(
        metric.extractPath(0, metric.length * clamped),
        Offset.zero,
      );
    }

    if (fill) {
      final fillPath = Path.from(path)
        ..lineTo(points.last.dx, bounds.bottom)
        ..lineTo(points.first.dx, bounds.bottom)
        ..close();
      canvas.drawPath(
        fillPath,
        Paint()
          ..style = PaintingStyle.fill
          ..shader = areaGradientShader(
            line.color,
            top: points.map((point) => point.dy).reduce(min),
            bottom: bounds.bottom,
            topAlpha: 0.3,
          ),
      );
    }

    canvas.drawPath(
      drawn,
      Paint()
        ..color = line.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..isAntiAlias = true,
    );
  }

  void _drawDashedTrend(
    Canvas canvas,
    ChartBounds bounds,
    FlexLineSeries trend,
  ) {
    final points = _pixelPoints(trend, bounds);
    if (points.length < 2) return;
    final path = polylinePath(points);
    final paint = Paint()
      ..color = trend.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = min(distance + 5, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += 10;
      }
    }
  }

  void _drawAxes(Canvas canvas, ChartBounds bounds, DrafterThemeColors theme) {
    if (showLeftLabels) {
      const tickCount = 4;
      for (var i = 0; i <= tickCount; i++) {
        final value = minY + (maxY - minY) * i / tickCount;
        final y = _yForValue(value, bounds);
        drawChartText(
          canvas,
          ChartFormatting.format(value),
          Offset(bounds.left - 7, y),
          color: theme.label,
          h: HAlign.end,
          v: VAlign.center,
        );
      }
    }

    if (!showBottomLabels || xLabels.isEmpty) return;
    final centers = <double>[];
    final widths = <double>[];
    for (final label in xLabels) {
      final point = FlexChartPoint(label.x, 0, column: label.column);
      centers.add(_xForPoint(point, label.column ?? centers.length, bounds));
      widths.add(measureChartText(label.text));
    }
    final keep = LabelLayout.thin(centers, widths, 6).toSet();
    for (var i = 0; i < xLabels.length; i++) {
      if (!keep.contains(i)) continue;
      drawChartText(
        canvas,
        xLabels[i].text,
        Offset(centers[i], bounds.bottom + 15),
        color: theme.label,
        h: HAlign.center,
        v: VAlign.center,
      );
    }
  }

  @override
  void draw(
    Canvas canvas,
    Size size,
    DrafterThemeColors theme,
    double progress,
  ) {
    if (size.isEmpty) return;
    final bounds = _bounds(size);
    _drawAxes(canvas, bounds, theme);

    for (var i = 0; i < series.length; i++) {
      _drawSeries(
        canvas,
        bounds,
        series[i],
        fill: fillFirstSeries && i == 0,
        progress: progress,
      );
    }

    final trend = trendSeries;
    if (trend != null && trend.points.isNotEmpty) {
      _drawDashedTrend(canvas, bounds, trend);
    }
  }

  @override
  ChartScene buildScene(Size size) {
    final bounds = _bounds(size);
    CartesianScale? scale;
    final count = uniformXCount;
    if (count != null && count > 0) {
      scale = CartesianScale(
        bounds: bounds,
        count: count,
        minValue: minY,
        maxValue: maxY,
      );
    }

    final marks = <PlotMark>[];
    for (var seriesIndex = 0; seriesIndex < series.length; seriesIndex++) {
      final line = series[seriesIndex];
      for (var pointIndex = 0; pointIndex < line.points.length; pointIndex++) {
        final point = line.points[pointIndex];
        marks.add(
          PlotMark(
            index: point.column ?? pointIndex,
            seriesIndex: seriesIndex,
            seriesName: line.name,
            label: '',
            value: point.y,
            center: Offset(
              _xForPoint(point, pointIndex, bounds),
              _yForValue(point.y, bounds),
            ),
            color: line.color,
          ),
        );
      }
    }

    return ChartScene(
      bounds: bounds,
      scale: scale,
      categories: const [],
      marks: marks,
    );
  }

  @override
  String get accessibilityLabel => 'Line chart';

  @override
  String get accessibilityValue {
    final count = _allPoints.length;
    return count == 0 ? 'No data' : '$count points';
  }
}
