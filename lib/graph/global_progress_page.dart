import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/graph/graph_date_field.dart';
import 'package:flexify/graph/strength_data.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GlobalProgressPage extends StatefulWidget {
  const GlobalProgressPage({super.key});

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      tabController = DefaultTabController.of(context);
      tabController?.addListener(tabListener);
    });
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
      return HSLColor.fromAHSL(
        1.0,
        hue,
        0.65,
        isDark ? 0.7 : 0.5,
      ).toColor();
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
          dotData: const FlDotData(
            show: false,
          ),
        ),
      );
      index++;
    }

    var lineChart = LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: tooltipData(settings.shortDateFormat, chartColors),
        ),
        lineBarsData: lineBarsData,
        gridData: const FlGridData(show: false),
      ),
    );

    final theme = Theme.of(context);
    final metricOptions = <(StrengthMetric, String)>[
      (StrengthMetric.bestWeight, 'Best weight'),
      (StrengthMetric.bestReps, 'Best reps'),
      (StrengthMetric.oneRepMax, 'One rep max'),
      (StrengthMetric.volume, 'Volume'),
      if (settings.showBodyWeight)
        (StrengthMetric.relativeStrength, 'Relative strength'),
    ];
    final metricValue =
        metricOptions.any((option) => option.$1 == metric) ? metric : null;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Global progress"),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            top: 16,
            right: 16,
            bottom: bottomNavHeight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<StrengthMetric>(
                      value: metricValue,
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      borderRadius: BorderRadius.circular(12),
                      items: metricOptions
                          .map(
                            (option) => DropdownMenuItem(
                              value: option.$1,
                              child: Text(option.$2),
                            ),
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
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.tune),
                    tooltip: 'Options',
                    onPressed: _showOptions,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SegmentedButton<Period>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: Period.day, label: Text('Day')),
                  ButtonSegment(value: Period.week, label: Text('Week')),
                  ButtonSegment(value: Period.month, label: Text('Month')),
                  ButtonSegment(value: Period.year, label: Text('Year')),
                ],
                selected: {period},
                onSelectionChanged: (value) {
                  setState(() {
                    period = value.first;
                  });
                  setData();
                },
              ),
              const SizedBox(height: 8),
              Expanded(
                flex: 3,
                child: data.isEmpty
                    ? const Center(child: Text("No data yet."))
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
                      DateFormat(settings.shortDateFormat)
                          .format(data.first.created),
                    ),
                    if (data.length > 2)
                      Text(
                        DateFormat(settings.shortDateFormat)
                            .format(data[data.length ~/ 2].created),
                      ),
                    if (data.length > 1)
                      Text(
                        DateFormat(settings.shortDateFormat)
                            .format(data.last.created),
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
                                    categories[entry.key] ?? "None",
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
            final theme = Theme.of(sheetContext);
            final colorScheme = theme.colorScheme;
            final settings = context.read<SettingsState>().value;

            Widget sectionLabel(String text) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    text,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                );

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  16 + MediaQuery.of(sheetContext).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (settings.showUnits) ...[
                      sectionLabel('Unit'),
                      DropdownButtonFormField<String>(
                        initialValue: targetUnit,
                        items: const [
                          DropdownMenuItem(
                            value: 'kg',
                            child: Text("Kilograms (kg)"),
                          ),
                          DropdownMenuItem(
                            value: 'lb',
                            child: Text("Pounds (lb)"),
                          ),
                          DropdownMenuItem(
                            value: 'stone',
                            child: Text("Stone"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            targetUnit = value!;
                          });
                          setData();
                          setSheet(() {});
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                    sectionLabel('Date range'),
                    Row(
                      children: [
                        Expanded(
                          child: GraphDateField(
                            label: 'Start date',
                            value: startDate,
                            hint: settings.shortDateFormat,
                            onTap: () async {
                              await selectStart();
                              setSheet(() {});
                            },
                            onClear: () {
                              setState(() {
                                startDate = null;
                              });
                              setData();
                              setSheet(() {});
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GraphDateField(
                            label: 'Stop date',
                            value: endDate,
                            hint: settings.shortDateFormat,
                            onTap: () async {
                              await selectEnd();
                              setSheet(() {});
                            },
                            onClear: () {
                              setState(() {
                                endDate = null;
                              });
                              setData();
                              setSheet(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Data points',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$limit',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: limit.toDouble(),
                      inactiveColor:
                          colorScheme.primary.withValues(alpha: 0.24),
                      min: 10,
                      max: 200,
                      onChanged: (value) {
                        setState(() {
                          limit = value.toInt();
                        });
                        setData();
                        setSheet(() {});
                      },
                    ),
                  ],
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

    if (pickedDate == null) return;

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

    if (pickedDate == null) return;

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

          final formatter = NumberFormat("#,###.00");
          category ??= "None";

          String value;
          switch (metric) {
            case StrengthMetric.bestReps:
            case StrengthMetric.relativeStrength:
              value = row.value.toStringAsFixed(2);
              break;
            case StrengthMetric.volume:
            case StrengthMetric.oneRepMax:
              value = "${formatter.format(row.value)}$targetUnit";
              break;
            case StrengthMetric.bestWeight:
              value =
                  "${row.reps} x ${row.value.toStringAsFixed(2)}$targetUnit";
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
