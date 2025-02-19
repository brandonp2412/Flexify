import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/graph/strength_data.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/unit_selector.dart';
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

  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData() async {
    final newData = await getGlobalData(
      targetUnit: targetUnit,
      metric: metric,
      period: period,
      startDate: startDate,
      endDate: endDate,
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
    var index = 0;
    for (final category in categories) {
      lineBarsData.add(
        LineChartBarData(
          spots: data
              .where((d) => d.category == category)
              .toList()
              .asMap()
              .entries
              .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value))
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
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Global progress"),
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'Metric'),
              value: metric,
              items: [
                const DropdownMenuItem(
                  value: StrengthMetric.bestWeight,
                  child: Text("Best weight"),
                ),
                const DropdownMenuItem(
                  value: StrengthMetric.bestReps,
                  child: Text("Best reps"),
                ),
                const DropdownMenuItem(
                  value: StrengthMetric.oneRepMax,
                  child: Text("One rep max"),
                ),
                const DropdownMenuItem(
                  value: StrengthMetric.volume,
                  child: Text("Volume"),
                ),
                if (settings.showBodyWeight)
                  const DropdownMenuItem(
                    value: StrengthMetric.relativeStrength,
                    child: Text("Relative strength"),
                  ),
              ],
              onChanged: (value) {
                setState(() {
                  metric = value!;
                });
                setData();
              },
            ),
            const SizedBox(height: 8),
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
                setData();
              },
            ),
            Visibility(
              visible: settings.showUnits,
              child: Column(
                children: [
                  SizedBox(height: 8),
                  UnitSelector(
                    value: targetUnit,
                    onChanged: (value) {
                      setState(() {
                        targetUnit = value!;
                      });
                      setData();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Start date'),
                      subtitle: startDate == null
                          ? Text(settings.shortDateFormat)
                          : Text(
                              DateFormat(settings.shortDateFormat)
                                  .format(startDate!),
                            ),
                      onLongPress: () {
                        setState(() {
                          startDate = null;
                        });
                        setData();
                      },
                      trailing: const Icon(Icons.calendar_today),
                      onTap: selectStart,
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Stop date'),
                      subtitle: endDate != null
                          ? Text(
                              DateFormat(settings.shortDateFormat)
                                  .format(endDate!),
                            )
                          : Text(settings.shortDateFormat),
                      onLongPress: () {
                        setState(() {
                          endDate = null;
                        });
                        setData();
                      },
                      trailing: const Icon(Icons.calendar_today),
                      onTap: selectEnd,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.40,
              child: data.isEmpty
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(right: 32.0, top: 16.0),
                      child: lineChart,
                    ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (data.isNotEmpty)
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
            SizedBox(height: 8),
            Wrap(
              spacing: 16.0, // Space between radio-category pairs
              runSpacing: 8.0, // Space between rows
              alignment: WrapAlignment.center,
              children: chartColors
                  .asMap()
                  .entries
                  .map(
                    (entry) => SizedBox(
                      width: 120, // Adjust this width based on your needs
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(
                            value: 1,
                            groupValue: 1,
                            onChanged: (value) {},
                            fillColor: WidgetStateProperty.resolveWith(
                              (states) => entry.value,
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
          ],
        ),
      ),
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
        return touchedSpots.map((spot) {
          var category = categories[spot.barIndex];
          final color = chartColors[spot.barIndex];
          final categoryData =
              data.where((d) => d.category == category).toList();

          final row = categoryData[spot.spotIndex];
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
