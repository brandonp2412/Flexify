import 'package:drift/drift.dart' as drift;
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/edit_graph_page.dart';
import 'package:flexify/graph_data.dart';
import 'package:flexify/graph_history.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewGraphPage extends StatefulWidget {
  final String name;
  const ViewGraphPage({super.key, required this.name});

  @override
  createState() => _ViewGraphPageState();
}

class _ViewGraphPageState extends State<ViewGraphPage> {
  late Stream<List<drift.TypedResult>> _graphStream;
  Metric _metric = Metric.bestWeight;
  String _targetUnit = 'kg';

  final _oneRepMax = db.gymSets.weight /
      (const drift.Variable(1.0278) -
          const drift.Variable(0.0278) * db.gymSets.reps);
  final _volume =
      const drift.CustomExpression<double>("ROUND(SUM(weight * reps), 2)");
  final _relativeStrength = db.gymSets.weight.max() / db.gymSets.bodyWeight;

  @override
  void initState() {
    super.initState();
    _graphStream = (db.selectOnly(db.gymSets)
          ..addColumns([
            db.gymSets.weight.max(),
            _volume,
            _oneRepMax,
            db.gymSets.created,
            db.gymSets.reps,
            db.gymSets.unit,
            _relativeStrength,
          ])
          ..where(db.gymSets.name.equals(widget.name))
          ..where(db.gymSets.hidden.equals(false))
          ..orderBy([
            drift.OrderingTerm(
                expression: db.gymSets.created.date,
                mode: drift.OrderingMode.desc)
          ])
          ..limit(10)
          ..groupBy([db.gymSets.created.date]))
        .watch();
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
                      builder: (context) => GraphHistory(
                            name: widget.name,
                          )),
                );
              },
              icon: const Icon(Icons.history))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Visibility(
              visible: widget.name != "Weight",
              child: DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Metric'),
                value: _metric,
                items: const [
                  DropdownMenuItem(
                    value: Metric.bestWeight,
                    child: Text("Best weight"),
                  ),
                  DropdownMenuItem(
                    value: Metric.oneRepMax,
                    child: Text("One rep max"),
                  ),
                  DropdownMenuItem(
                    value: Metric.volume,
                    child: Text("Volume"),
                  ),
                  DropdownMenuItem(
                    value: Metric.relativeStrength,
                    child: Text("Relative strength"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _metric = value!;
                  });
                },
              ),
            ),
            DropdownButtonFormField<String>(
              value: _targetUnit,
              decoration: const InputDecoration(labelText: 'Unit'),
              items: ['kg', 'lb'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _targetUnit = newValue!;
                });
              },
            ),
            graphBuilder(settings),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Edit graph',
        child: const Icon(Icons.edit),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditGraphPage(name: widget.name),
            )),
      ),
    );
  }

  StreamBuilder<List<drift.TypedResult>> graphBuilder(SettingsState settings) {
    return StreamBuilder<List<drift.TypedResult>>(
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
        final rows = snapshot.data!.reversed.map((row) {
          final unit = row.read(db.gymSets.unit)!;
          var maxWeight = row.read(db.gymSets.weight.max())!;
          var oneRepMax = row.read(_oneRepMax)!;
          var volume = row.read(_volume)!;
          var relativeStrength = row.read(_relativeStrength) ?? 0;

          double conversionFactor = 1;

          if (unit == 'lb' && _targetUnit == 'kg') {
            conversionFactor = 0.45359237;
          } else if (unit == 'kg' && _targetUnit == 'lb') {
            conversionFactor = 2.20462262;
          }

          maxWeight *= conversionFactor;
          oneRepMax *= conversionFactor;
          volume *= conversionFactor;
          relativeStrength *= conversionFactor;

          return GraphData(
            maxWeight: maxWeight,
            oneRepMax: oneRepMax,
            volume: volume,
            relativeStrength: relativeStrength,
            created: DateFormat(settings.dateFormat)
                .format(row.read(db.gymSets.created)!),
            reps: row.read(db.gymSets.reps)!,
            unit: row.read(db.gymSets.unit)!,
          );
        }).toList();

        List<FlSpot> spots;
        if (_metric == Metric.oneRepMax) {
          spots = rows
              .asMap()
              .entries
              .map((row) => FlSpot(row.key.toDouble(), row.value.oneRepMax))
              .toList();
        } else if (_metric == Metric.volume) {
          spots = rows
              .asMap()
              .entries
              .map((row) => FlSpot(row.key.toDouble(), row.value.volume))
              .toList();
        } else if (_metric == Metric.relativeStrength) {
          spots = rows
              .asMap()
              .entries
              .map((row) =>
                  FlSpot(row.key.toDouble(), row.value.relativeStrength))
              .toList();
        } else {
          spots = rows
              .asMap()
              .entries
              .map((row) => FlSpot(row.key.toDouble(), row.value.maxWeight))
              .toList();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: LineChart(
              LineChartData(
                titlesData: const FlTitlesData(
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false))),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: tooltipData(context, rows),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: false,
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

  LineTouchTooltipData tooltipData(BuildContext context, List<GraphData> rows) {
    return LineTouchTooltipData(
      tooltipBgColor: Theme.of(context).colorScheme.background,
      getTooltipItems: (touchedSpots) {
        final row = rows.elementAt(touchedSpots.first.spotIndex);
        String text = "";
        if (_metric == Metric.oneRepMax)
          text =
              "${row.oneRepMax.toStringAsFixed(2)}$_targetUnit ${row.created}";
        else if (_metric == Metric.relativeStrength)
          text = "${(row.relativeStrength).toStringAsFixed(2)} ${row.created}";
        else if (_metric == Metric.volume)
          text = "${row.volume}$_targetUnit ${row.created}";
        else if (_metric == Metric.bestWeight)
          text =
              "${row.reps} x ${row.maxWeight.toStringAsFixed(2)}$_targetUnit ${row.created}";
        return [
          LineTooltipItem(text,
              TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color))
        ];
      },
    );
  }
}
