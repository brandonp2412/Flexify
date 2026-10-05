import 'dart:math';

import 'package:drafter/drafter.dart';
import 'package:drafter/painting.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@immutable
class FlexLineChartPoint {
  final double x;
  final double y;
  final int? column;

  const FlexLineChartPoint(this.x, this.y, {this.column});
}

@immutable
class FlexLineChartSeries {
  final List<FlexLineChartPoint> points;
  final Color color;
  final String name;

  const FlexLineChartSeries({
    required this.points,
    required this.color,
    this.name = '',
  });
}

@immutable
class _LineChartAxisLabel {
  final double x;
  final int? column;
  final String text;

  const _LineChartAxisLabel(this.x, this.text, {this.column});
}

const _lineChartEdgePaddingFraction = 0.02;
const _axisLabelFontSize = 12.0;
const _axisLabelFontWeight = FontWeight.w600;
const _xAxisLabelMinGap = 12.0;
const _chartTopInset = 24.0;
const _chartBottomInset = 16.0;
const _chartBottomLabelInset = 38.0;
const _tooltipPadding = 8.0;
const _tooltipRowHeight = 16.0;
const _tooltipDotGap = 8.0;
const _tooltipFontSize = 10.0;
const _tooltipSwatchSize = 8.0;
const _tooltipSwatchGap = 6.0;

void _drawFlexTooltip(
  Canvas canvas, {
  required Offset anchor,
  required Size container,
  required List<TooltipRow> rows,
  required Color background,
  required Color textColor,
  required Color mutedTextColor,
  String? title,
}) {
  final hasTitle = title != null && title.isNotEmpty;
  if (rows.isEmpty && !hasTitle) return;

  var maxWidth = 0.0;
  if (hasTitle) {
    maxWidth = measureChartText(
      title,
      color: textColor,
      fontSize: _tooltipFontSize,
      weight: FontWeight.w600,
    );
  }
  for (final row in rows) {
    final textWidth = measureChartText(
      row.text,
      color: textColor,
      fontSize: _tooltipFontSize,
    );
    final rowWidth =
        textWidth +
        (row.swatch == null ? 0 : _tooltipSwatchSize + _tooltipSwatchGap);
    maxWidth = max(maxWidth, rowWidth);
  }

  final titleHeight = hasTitle ? _tooltipRowHeight : 0.0;
  final boxWidth = maxWidth + _tooltipPadding * 2;
  final boxHeight =
      titleHeight + rows.length * _tooltipRowHeight + _tooltipPadding * 2;
  var left = anchor.dx + 12;
  if (left + boxWidth > container.width) {
    left = anchor.dx - 12 - boxWidth;
  }
  left = left.clamp(0.0, max(0.0, container.width - boxWidth));
  final top = anchor.dy
      .clamp(0.0, max(0.0, container.height - boxHeight))
      .toDouble();

  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, boxWidth, boxHeight),
      const Radius.circular(8),
    ),
    Paint()..color = background,
  );

  var rowTop = top + _tooltipPadding;
  if (hasTitle) {
    drawChartText(
      canvas,
      title,
      Offset(left + _tooltipPadding, rowTop + _tooltipRowHeight / 2),
      color: mutedTextColor,
      fontSize: _tooltipFontSize,
      weight: FontWeight.w600,
      v: VAlign.center,
    );
    rowTop += _tooltipRowHeight;
  }
  for (final row in rows) {
    final rowCenter = rowTop + _tooltipRowHeight / 2;
    var textX = left + _tooltipPadding;
    if (row.swatch case final color?) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            textX,
            rowCenter - _tooltipSwatchSize / 2,
            _tooltipSwatchSize,
            _tooltipSwatchSize,
          ),
          const Radius.circular(2),
        ),
        Paint()..color = color,
      );
      textX += _tooltipSwatchSize + _tooltipSwatchGap;
    }
    drawChartText(
      canvas,
      row.text,
      Offset(textX, rowCenter),
      color: textColor,
      fontSize: _tooltipFontSize,
      v: VAlign.center,
    );
    rowTop += _tooltipRowHeight;
  }
}

(double, double) _calculateYBounds(List<FlexLineChartPoint> points) {
  if (points.isEmpty) return (0, 1);

  var minY = points.map((point) => point.y).reduce(min);
  var maxY = points.map((point) => point.y).reduce(max);
  if (maxY - minY < 1.0) {
    final center = (maxY + minY) / 2;
    minY = center - 0.5;
    maxY = center + 0.5;
  }

  final padding = (maxY - minY) * _lineChartEdgePaddingFraction;
  return (minY - padding, maxY + padding);
}

class FlexLineChart extends StatelessWidget {
  final List<FlexLineChartPoint> points;
  final List<DateTime> dates;
  final bool? hideBottom;
  final bool? hideLeft;
  final bool? showTrendLine;
  final bool timeBasedXAxis;
  final String Function(int index) tooltipText;
  final ValueChanged<int>? onPointSelected;

  static (double, double) calculateYBounds(List<FlexLineChartPoint> points) =>
      _calculateYBounds(points);

  @visibleForTesting
  static double get axisLabelFontSize => _axisLabelFontSize;

  @visibleForTesting
  static FontWeight get axisLabelFontWeight => _axisLabelFontWeight;

  @visibleForTesting
  static double tooltipTopForMarks(
    List<double> markYs, {
    required int rowCount,
    bool hasTitle = false,
  }) {
    if (markYs.isEmpty) return 0;

    final tooltipHeight =
        (hasTitle ? _tooltipRowHeight : 0) +
        rowCount * _tooltipRowHeight +
        _tooltipPadding * 2;
    return markYs.reduce(min) - tooltipHeight - _tooltipDotGap;
  }

  @visibleForTesting
  static List<int> selectXAxisLabelIndices(
    List<double> centers,
    List<double> widths,
    double minGap,
  ) {
    final count = centers.length;
    if (count == 0) return const [];
    if (count == 1) return const [0];

    final order = List<int>.generate(count, (index) => index)
      ..sort((a, b) => centers[a].compareTo(centers[b]));
    final first = order.first;
    final last = order.last;
    final lastLeft = centers[last] - widths[last] / 2;

    // First determine how many labels actually fit while reserving both edges.
    final packed = <int>[first];
    var lastRight = centers[first] + widths[first] / 2;
    for (final index in order.skip(1).take(count - 2)) {
      final left = centers[index] - widths[index] / 2;
      final right = centers[index] + widths[index] / 2;
      if (left < lastRight + minGap || right + minGap > lastLeft) continue;
      packed.add(index);
      lastRight = right;
    }
    packed.add(last);

    if (packed.length <= 2 || packed.length == count) {
      packed.sort();
      return packed;
    }

    // Keep that adaptive label count, but choose the middle labels nearest
    // evenly spaced visual targets instead of packing them left-to-right.
    final balanced = <int>[first];
    var previousOrderPosition = 0;
    final span = centers[last] - centers[first];

    for (var slot = 1; slot < packed.length - 1; slot++) {
      final target = centers[first] + span * slot / (packed.length - 1);
      final remainingSlots = packed.length - 1 - slot;
      final maxOrderPosition = order.length - 1 - remainingSlots;
      var bestOrderPosition = -1;
      var bestDistance = double.infinity;

      for (
        var position = previousOrderPosition + 1;
        position <= maxOrderPosition;
        position++
      ) {
        final index = order[position];
        final previous = balanced.last;
        final left = centers[index] - widths[index] / 2;
        final previousRight = centers[previous] + widths[previous] / 2;
        if (left < previousRight + minGap) continue;

        final distance = (centers[index] - target).abs();
        if (distance <= bestDistance) {
          bestDistance = distance;
          bestOrderPosition = position;
        }
      }

      if (bestOrderPosition < 0) {
        packed.sort();
        return packed;
      }

      balanced.add(order[bestOrderPosition]);
      previousOrderPosition = bestOrderPosition;
    }

    balanced.add(last);

    for (var i = 1; i < balanced.length; i++) {
      final previous = balanced[i - 1];
      final current = balanced[i];
      final gap =
          centers[current] -
          widths[current] / 2 -
          (centers[previous] + widths[previous] / 2);
      if (gap < minGap) {
        packed.sort();
        return packed;
      }
    }

    balanced.sort();
    return balanced;
  }

  const FlexLineChart({
    super.key,
    required this.points,
    required this.tooltipText,
    this.dates = const [],
    this.onPointSelected,
    this.hideBottom,
    this.hideLeft,
    this.showTrendLine = true,
    this.timeBasedXAxis = false,
  });

  List<FlexLineChartPoint> _calculateTrendLine(
    List<FlexLineChartPoint> source,
  ) {
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
      FlexLineChartPoint(
        start.x,
        slope * start.x + intercept,
        column: start.column,
      ),
      FlexLineChartPoint(end.x, slope * end.x + intercept, column: end.column),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>().value;
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;
    final secondary = colorScheme.secondary;
    final yBounds = calculateYBounds(points);
    final labels = <_LineChartAxisLabel>[];

    if (hideBottom != true) {
      for (
        var index = 0;
        index < points.length && index < dates.length;
        index++
      ) {
        final created = dates[index];
        labels.add(
          _LineChartAxisLabel(
            points[index].x,
            formatDisplayDate(context, created, settings.shortDateFormat),
            column: points[index].column ?? index,
          ),
        );
      }
    }

    return _FlexLineChartInteraction(
      renderer: _FlexLineChartRenderer(
        series: [FlexLineChartSeries(points: points, color: primary)],
        trendSeries: showTrendLine == true
            ? FlexLineChartSeries(
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
        axisLabelColor: colorScheme.onSurface,
      ),
      rowLabel: (mark) => tooltipText(mark.index),
      onPointSelected: onPointSelected,
    );
  }
}

class FlexGroupedLineChart extends StatelessWidget {
  final List<FlexLineChartSeries> series;
  final List<String> xLabels;
  final String Function(int seriesIndex, int xIndex) tooltipText;
  final bool showLeftLabels;
  final bool showBottomLabels;

  const FlexGroupedLineChart({
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
    final axisLabelColor = Theme.of(context).colorScheme.onSurface;
    final points = [for (final line in series) ...line.points];

    final yBounds = _calculateYBounds(points);

    return _FlexLineChartInteraction(
      renderer: _FlexLineChartRenderer(
        series: series,
        minY: yBounds.$1,
        maxY: yBounds.$2,
        curveLines: settings.curveLines,
        curveSmoothness: settings.curveSmoothness ?? 0.35,
        fillFirstSeries: false,
        showLeftLabels: showLeftLabels,
        showBottomLabels: showBottomLabels,
        xLabels: [
          for (var i = 0; i < xLabels.length; i++)
            _LineChartAxisLabel(i.toDouble(), xLabels[i], column: i),
        ],
        uniformXCount: xLabels.length,
        axisLabelColor: axisLabelColor,
      ),
      rowLabel: (mark) => tooltipText(mark.seriesIndex, mark.index),
    );
  }
}

class _FlexLineChartInteraction extends StatefulWidget {
  final _FlexLineChartRenderer renderer;
  final String Function(PlotMark mark) rowLabel;
  final ValueChanged<int>? onPointSelected;

  const _FlexLineChartInteraction({
    required this.renderer,
    required this.rowLabel,
    this.onPointSelected,
  });

  @override
  State<_FlexLineChartInteraction> createState() =>
      _FlexLineChartInteractionState();
}

class _FlexLineChartInteractionState extends State<_FlexLineChartInteraction> {
  final ValueNotifier<int?> _activeIndex = ValueNotifier(null);

  void _activate(Offset position, ChartScene scene) {
    _activeIndex.value = ChartHitTest.nearestIndexAtX(scene, position.dx);
  }

  void _select(Offset position, ChartScene scene) {
    final callback = widget.onPointSelected;
    final index = ChartHitTest.nearestIndexAtX(scene, position.dx);
    if (callback != null && index != null) callback(index);
  }

  void _clear() {
    _activeIndex.value = null;
  }

  bool get _keepTooltipOnTapUp {
    if (kIsWeb) return true;
    return switch (defaultTargetPlatform) {
      TargetPlatform.linux ||
      TargetPlatform.macOS ||
      TargetPlatform.windows => true,
      _ => false,
    };
  }

  @override
  void didUpdateWidget(_FlexLineChartInteraction oldWidget) {
    super.didUpdateWidget(oldWidget);
    final index = _activeIndex.value;
    if (index != null && !widget.renderer.hasIndex(index)) _clear();
  }

  @override
  void dispose() {
    _activeIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final theme = dark ? DrafterThemeColors.dark : DrafterThemeColors.light;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final scene = widget.renderer.buildScene(size);

        return MouseRegion(
          onHover: (event) => _activate(event.localPosition, scene),
          onExit: (_) => _clear(),
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: (event) {
              _activate(event.localPosition, scene);
              _select(event.localPosition, scene);
            },
            onPointerUp: (event) {
              _activate(event.localPosition, scene);
              if (!_keepTooltipOnTapUp) _clear();
            },
            onPointerCancel: (_) => _clear(),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onLongPressStart: (details) =>
                  _activate(details.localPosition, scene),
              onLongPressMoveUpdate: (details) =>
                  _activate(details.localPosition, scene),
              onLongPressEnd: (_) => _clear(),
              onLongPressCancel: _clear,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  DrafterTheme(
                    colors: theme,
                    child: ChartCanvas(
                      renderer: widget.renderer,
                      animate: false,
                    ),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: RepaintBoundary(
                        child: CustomPaint(
                          painter: _FlexLineTooltipPainter(
                            activeIndex: _activeIndex,
                            scene: scene,
                            theme: theme,
                            rowLabel: widget.rowLabel,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FlexLineTooltipPainter extends CustomPainter {
  final ValueNotifier<int?> activeIndex;
  final ChartScene scene;
  final DrafterThemeColors theme;
  final String Function(PlotMark mark) rowLabel;

  _FlexLineTooltipPainter({
    required this.activeIndex,
    required this.scene,
    required this.theme,
    required this.rowLabel,
  }) : super(repaint: activeIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final index = activeIndex.value;
    final bounds = scene.bounds;
    if (index == null || bounds == null) return;

    final marks = ChartHitTest.marksAtIndex(scene, index);
    if (marks.isEmpty) return;

    final x = scene.scale?.xForIndex(index) ?? marks.first.center.dx;
    drawTrackball(
      canvas,
      x: x,
      top: bounds.top,
      bottom: bounds.bottom,
      lineColor: theme.crosshair,
      markers: [for (final mark in marks) mark.center],
      markerColors: [for (final mark in marks) mark.color],
    );
    final title = marks.first.label.isEmpty ? null : marks.first.label;
    _drawFlexTooltip(
      canvas,
      anchor: Offset(
        x,
        FlexLineChart.tooltipTopForMarks(
          [for (final mark in marks) mark.center.dy],
          rowCount: marks.length,
          hasTitle: title != null,
        ),
      ),
      container: size,
      title: title,
      background: theme.tooltipBackground,
      textColor: theme.tooltipText,
      mutedTextColor: theme.tooltipMutedText,
      rows: [
        for (final mark in marks)
          TooltipRow(rowLabel(mark), swatch: mark.color),
      ],
    );
  }

  @override
  bool shouldRepaint(covariant _FlexLineTooltipPainter oldDelegate) =>
      oldDelegate.scene != scene ||
      oldDelegate.theme != theme ||
      oldDelegate.rowLabel != rowLabel;
}

class _FlexLineChartScale extends CartesianScale {
  final Map<int, double> _xByIndex;

  _FlexLineChartScale({
    required super.bounds,
    required super.count,
    required super.minValue,
    required super.maxValue,
    required Map<int, double> xByIndex,
  }) : _xByIndex = Map.unmodifiable(xByIndex);

  @override
  double xForIndex(int index) => _xByIndex[index] ?? super.xForIndex(index);

  @override
  int nearestIndex(double px) {
    if (_xByIndex.isEmpty || !px.isFinite) return super.nearestIndex(px);

    var nearest = _xByIndex.keys.first;
    var nearestDistance = (_xByIndex[nearest]! - px).abs();
    for (final entry in _xByIndex.entries.skip(1)) {
      final distance = (entry.value - px).abs();
      if (distance < nearestDistance) {
        nearest = entry.key;
        nearestDistance = distance;
      }
    }
    return nearest;
  }
}

class _FlexLineChartRenderer extends ChartRenderer
    implements InteractiveRenderer {
  final List<FlexLineChartSeries> series;
  final FlexLineChartSeries? trendSeries;
  final double minY;
  final double maxY;
  final bool curveLines;
  final double curveSmoothness;
  final bool fillFirstSeries;
  final bool showLeftLabels;
  final bool showBottomLabels;
  final List<_LineChartAxisLabel> xLabels;
  final int? uniformXCount;
  final Color axisLabelColor;

  const _FlexLineChartRenderer({
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
    required this.axisLabelColor,
    this.trendSeries,
  });

  ChartBounds _bounds(Size size) {
    final left = showLeftLabels ? 48.0 : 8.0;
    final bottom = showBottomLabels
        ? _chartBottomLabelInset
        : _chartBottomInset;
    return ChartBounds.insets(
      size,
      left: left,
      top: _chartTopInset,
      right: 8,
      bottom: bottom,
    );
  }

  List<FlexLineChartPoint> get _allPoints => [
    for (final line in series) ...line.points,
  ];

  bool hasIndex(int index) {
    for (final line in series) {
      for (var pointIndex = 0; pointIndex < line.points.length; pointIndex++) {
        if ((line.points[pointIndex].column ?? pointIndex) == index)
          return true;
      }
    }
    return false;
  }

  (double, double) get _xBounds {
    final points = _allPoints;
    if (points.isEmpty) return (0, 1);
    final minX = points.map((point) => point.x).reduce(min);
    final maxX = points.map((point) => point.x).reduce(max);
    return maxX == minX ? (minX - 0.5, maxX + 0.5) : (minX, maxX);
  }

  double _xForPoint(
    FlexLineChartPoint point,
    int pointIndex,
    ChartBounds bounds,
  ) {
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

  List<Offset> _pixelPoints(FlexLineChartSeries line, ChartBounds bounds) => [
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
    FlexLineChartSeries line, {
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
    FlexLineChartSeries trend,
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

  void _drawAxes(Canvas canvas, ChartBounds bounds) {
    if (showLeftLabels) {
      const tickCount = 4;
      for (var i = 0; i <= tickCount; i++) {
        final value = minY + (maxY - minY) * i / tickCount;
        final y = _yForValue(value, bounds);
        drawChartText(
          canvas,
          ChartFormatting.format(value),
          Offset(bounds.left - 7, y),
          color: axisLabelColor,
          fontSize: _axisLabelFontSize,
          weight: _axisLabelFontWeight,
          h: HAlign.end,
          v: VAlign.center,
        );
      }
    }

    if (!showBottomLabels || xLabels.isEmpty) return;
    final centers = <double>[];
    final widths = <double>[];
    for (final label in xLabels) {
      final point = FlexLineChartPoint(label.x, 0, column: label.column);
      centers.add(_xForPoint(point, label.column ?? centers.length, bounds));
      widths.add(
        measureChartText(
          label.text,
          fontSize: _axisLabelFontSize,
          weight: _axisLabelFontWeight,
          color: axisLabelColor,
        ),
      );
    }
    final keep = FlexLineChart.selectXAxisLabelIndices(
      centers,
      widths,
      _xAxisLabelMinGap,
    ).toSet();
    for (var i = 0; i < xLabels.length; i++) {
      if (!keep.contains(i)) continue;
      drawChartText(
        canvas,
        xLabels[i].text,
        Offset(centers[i], bounds.bottom + 15),
        color: axisLabelColor,
        fontSize: _axisLabelFontSize,
        weight: _axisLabelFontWeight,
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
    _drawAxes(canvas, bounds);

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
    final xByIndex = <int, double>{};

    for (final line in series) {
      for (var pointIndex = 0; pointIndex < line.points.length; pointIndex++) {
        final point = line.points[pointIndex];
        final index = point.column ?? pointIndex;
        xByIndex.putIfAbsent(
          index,
          () => _xForPoint(point, pointIndex, bounds),
        );
      }
    }

    final orderedColumns = xByIndex.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    final hitRegions = <int, Rect>{};
    for (var i = 0; i < orderedColumns.length; i++) {
      final column = orderedColumns[i];
      final left = i == 0
          ? bounds.left
          : (orderedColumns[i - 1].value + column.value) / 2;
      final right = i == orderedColumns.length - 1
          ? bounds.right
          : (column.value + orderedColumns[i + 1].value) / 2;
      hitRegions[column.key] = Rect.fromLTRB(
        left,
        bounds.top,
        right,
        bounds.bottom,
      );
    }

    final marks = <PlotMark>[];
    for (var seriesIndex = 0; seriesIndex < series.length; seriesIndex++) {
      final line = series[seriesIndex];
      for (var pointIndex = 0; pointIndex < line.points.length; pointIndex++) {
        final point = line.points[pointIndex];
        final index = point.column ?? pointIndex;
        marks.add(
          PlotMark(
            index: index,
            seriesIndex: seriesIndex,
            seriesName: line.name,
            label: '',
            value: point.y,
            center: Offset(
              _xForPoint(point, pointIndex, bounds),
              _yForValue(point.y, bounds),
            ),
            region: hitRegions[index],
            color: line.color,
          ),
        );
      }
    }

    final scale = xByIndex.isEmpty
        ? null
        : _FlexLineChartScale(
            bounds: bounds,
            count: xByIndex.length,
            minValue: minY,
            maxValue: maxY,
            xByIndex: xByIndex,
          );

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
