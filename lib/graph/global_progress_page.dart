import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/empty_state.dart';
import 'package:flexify/graph/graph_options_controls.dart';
import 'package:flexify/graph/strength_data.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GlobalProgressPage extends StatefulWidget {
  final TabController tabController;

  const GlobalProgressPage({super.key, required this.tabController});

  @override
  State<GlobalProgressPage> createState() => _GlobalProgressPageState();
}

class _GlobalProgressPageState extends State<GlobalProgressPage> {
  StrengthMetric metric = StrengthMetric.bestWeight;
  List<StrengthData> data = [];
  List<String?> categories = [];
  Period period = Period.day;
  DateTime? startDate;
  DateTime? endDate;
  String targetUnit = 'kg';
  int limit = 100;
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    setData();

    tabController = widget.tabController;
    tabController?.addListener(tabListener);
  }

  void tabListener() {
    final settings = context.read<SettingsState>().value;
    final graphsIndex = settings.tabs.split(',').indexOf('GraphsPage');
    if (tabController?.indexIsChanging == true) return;
    if (tabController?.index != graphsIndex) return;
    setData();
  }

  @override
  void dispose() {
    tabController?.removeListener(tabListener);
    super.dispose();
  }

  void setData() async {
    final newData = await getGlobalData(
      target: targetUnit,
      metric: metric,
      period: period,
      start: startDate,
      end: endDate,
      limit: limit,
    );
    final newCategories = await getCategories();
    if (!mounted) return;
    setState(() {
      data = newData;
      categories = newCategories;
    });
  }

  List<Color> generateChartColors(BuildContext context, int count) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<double> hueValues = List.generate(
      count,
      (index) => (index * (360 / count)) % 360,
    );

    return hueValues.map((hue) {
      return HSLColor.fromAHSL(1.0, hue, 0.65, isDark ? 0.7 : 0.5).toColor();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>().value;

    final chartColors = generateChartColors(context, categories.length);
    List<LineChartBarData> lineBarsData = [];

    final allDates = data.map((d) => d.created).toSet().toList()..sort();
    final dateToXMap = <DateTime, double>{};
    for (int i = 0; i < allDates.length; i++) {
      dateToXMap[allDates[i]] = i.toDouble();
    }

    var index = 0;
    for (final category in categories) {
      final categoryData = data.where((d) => d.category == category).toList();
      lineBarsData.add(
        LineChartBarData(
          spots: categoryData
              .map((d) => FlSpot(dateToXMap[d.created]!, d.value))
              .toList(),
          isCurved: settings.curveLines,
          color: chartColors[index],
          barWidth: 3,
          isStrokeCapRound: true,
          curveSmoothness: settings.curveSmoothness ?? 0.35,
          dotData: const FlDotData(show: false),
        ),
      );
      index++;
    }

    var lineChart = LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 45),
          ),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: tooltipData(settings.shortDateFormat, chartColors),
        ),
        lineBarsData: lineBarsData,
        gridData: const FlGridData(show: false),
      ),
    );

    final desktop = isDesktopLayout(context);
    final theme = Theme.of(context);
    final metricOptions = <(StrengthMetric, String)>[
      (StrengthMetric.bestWeight, context.l10n.bestWeight),
      (StrengthMetric.bestReps, context.l10n.bestReps),
      (StrengthMetric.oneRepMax, context.l10n.oneRepMax),
      (StrengthMetric.volume, context.l10n.volume),
      if (settings.showBodyWeight)
        (StrengthMetric.relativeStrength, context.l10n.relativeStrength),
    ];
    final metricValue = metricOptions.any((option) => option.$1 == metric)
        ? metric
        : null;

    final metricSelector = DropdownButton<StrengthMetric>(
      value: metricValue,
      isExpanded: true,
      underline: const SizedBox.shrink(),
      borderRadius: BorderRadius.circular(12),
      items: metricOptions
          .map(
            (option) =>
                DropdownMenuItem(value: option.$1, child: Text(option.$2)),
          )
          .toList(),
      selectedItemBuilder: (context) => metricOptions
          .map(
            (option) => Align(
              alignment: Alignment.centerLeft,
              child: Text(
                option.$2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          metric = value!;
        });
        setData();
      },
    );
    final periodSelector = SegmentedButton<Period>(
      showSelectedIcon: false,
      segments: [
        ButtonSegment(value: Period.day, label: Text(context.l10n.periodDay)),
        ButtonSegment(value: Period.week, label: Text(context.l10n.periodWeek)),
        ButtonSegment(
          value: Period.month,
          label: Text(context.l10n.periodMonth),
        ),
        ButtonSegment(value: Period.year, label: Text(context.l10n.periodYear)),
      ],
      selected: {period},
      onSelectionChanged: (value) {
        setState(() {
          period = value.first;
        });
        setData();
      },
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(context.l10n.globalProgress),
        actions: [
          IconButton(icon: const Icon(Icons.language), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            top: 16,
            right: 16,
            bottom: desktop ? 24.0 : bottomNavHeight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (desktop)
                Row(
                  children: [
                    Expanded(child: metricSelector),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: periodSelector),
                  ],
                )
              else ...[
                Row(
                  children: [
                    Expanded(child: metricSelector),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.tune),
                      tooltip: context.l10n.options,
                      onPressed: _showOptions,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                periodSelector,
              ],
              if (desktop) ...[
                const SizedBox(height: 12),
                GraphOptionsControls(
                  compact: true,
                  shortDateFormat: settings.shortDateFormat,
                  unitValue: settings.showUnits ? targetUnit : null,
                  unitItems: settings.showUnits
                      ? strengthUnitMenuItems(context.l10n)
                      : const [],
                  onUnitChanged: (value) {
                    setState(() {
                      targetUnit = value;
                    });
                    setData();
                  },
                  startDate: startDate,
                  endDate: endDate,
                  onSelectStart: selectStart,
                  onClearStart: () {
                    setState(() {
                      startDate = null;
                    });
                    setData();
                  },
                  onSelectEnd: selectEnd,
                  onClearEnd: () {
                    setState(() {
                      endDate = null;
                    });
                    setData();
                  },
                  limit: limit,
                  maxLimit: 200,
                  onLimitChanged: (value) {
                    setState(() {
                      limit = value;
                    });
                    setData();
                  },
                ),
              ],
              const SizedBox(height: 8),
              Expanded(
                flex: 3,
                child: data.isEmpty
                    ? AppEmptyState(
                        icon: Icons.show_chart_rounded,
                        title: context.l10n.noDataYet,
                        message: context.l10n.completeSetsForProgress,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 32.0, top: 16.0),
                        child: lineChart,
                      ),
              ),
              if (data.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDisplayDate(
                        context,
                        data.first.created,
                        settings.shortDateFormat,
                      ),
                    ),
                    if (data.length > 2)
                      Text(
                        formatDisplayDate(
                          context,
                          data[data.length ~/ 2].created,
                          settings.shortDateFormat,
                        ),
                      ),
                    if (data.length > 1)
                      Text(
                        formatDisplayDate(
                          context,
                          data.last.created,
                          settings.shortDateFormat,
                        ),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 16.0,
                    runSpacing: 8.0,
                    alignment: WrapAlignment.center,
                    children: chartColors
                        .asMap()
                        .entries
                        .map(
                          (entry) => SizedBox(
                            width: 120,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RadioGroup<int>(
                                  groupValue: 1,
                                  onChanged: (value) {},
                                  child: Radio<int>(
                                    value: 1,
                                    fillColor: WidgetStateProperty.resolveWith(
                                      (states) => entry.value,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    categories[entry.key] ?? context.l10n.none,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptions() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheet) {
            final settings = context.read<SettingsState>().value;
            void refreshSheet() => setSheet(() {});

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  16 + MediaQuery.of(sheetContext).viewInsets.bottom,
                ),
                child: GraphOptionsControls(
                  compact: false,
                  shortDateFormat: settings.shortDateFormat,
                  unitValue: settings.showUnits ? targetUnit : null,
                  unitItems: settings.showUnits
                      ? strengthUnitMenuItems(context.l10n)
                      : const [],
                  onUnitChanged: (value) {
                    setState(() {
                      targetUnit = value;
                    });
                    setData();
                    refreshSheet();
                  },
                  startDate: startDate,
                  endDate: endDate,
                  onSelectStart: () async {
                    await selectStart();
                    if (sheetContext.mounted) refreshSheet();
                  },
                  onClearStart: () {
                    setState(() {
                      startDate = null;
                    });
                    setData();
                    refreshSheet();
                  },
                  onSelectEnd: () async {
                    await selectEnd();
                    if (sheetContext.mounted) refreshSheet();
                  },
                  onClearEnd: () {
                    setState(() {
                      endDate = null;
                    });
                    setData();
                    refreshSheet();
                  },
                  limit: limit,
                  maxLimit: 200,
                  onLimitChanged: (value) {
                    setState(() {
                      limit = value;
                    });
                    setData();
                    refreshSheet();
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> selectEnd() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null || !mounted) return;

    setState(() {
      endDate = pickedDate;
    });
    setData();
  }

  Future<void> selectStart() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null || !mounted) return;

    setState(() {
      startDate = pickedDate;
    });
    setData();
  }

  LineTouchTooltipData tooltipData(String format, List<Color> chartColors) {
    return LineTouchTooltipData(
      getTooltipColor: (touch) => Theme.of(context).colorScheme.surface,
      getTooltipItems: (touchedSpots) {
        final allDates = data.map((d) => d.created).toSet().toList()..sort();
        final xToDateMap = <double, DateTime>{};
        for (int i = 0; i < allDates.length; i++) {
          xToDateMap[i.toDouble()] = allDates[i];
        }

        return touchedSpots.map((spot) {
          var category = categories[spot.barIndex];
          final color = chartColors[spot.barIndex];
          final touchedDate = xToDateMap[spot.x];

          final row = data.firstWhere(
            (d) => d.category == category && d.created == touchedDate,
          );

          category ??= context.l10n.none;
          final formattedValue = formatDisplayNumber(
            context,
            row.value,
            minimumFractionDigits: 2,
          );
          final displayUnit = displayMeasurementUnit(context.l10n, targetUnit);

          String value;
          switch (metric) {
            case StrengthMetric.bestReps:
            case StrengthMetric.relativeStrength:
              value = formattedValue;
              break;
            case StrengthMetric.volume:
            case StrengthMetric.oneRepMax:
              value = "$formattedValue$displayUnit";
              break;
            case StrengthMetric.bestWeight:
              value =
                  "${formatDisplayNumber(context, row.reps, maximumFractionDigits: 0)} × $formattedValue$displayUnit";
              break;
          }

          return LineTooltipItem(
            value,
            Theme.of(context).textTheme.labelLarge!.copyWith(color: color),
          );
        }).toList();
      },
    );
  }
}
