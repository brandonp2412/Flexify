import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/graph/cardio_data.dart';
import 'package:flexify/graph/edit_graph_page.dart';
import 'package:flexify/graph/flex_line.dart';
import 'package:flexify/graph/graph_date_field.dart';
import 'package:flexify/graph/graph_history_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CardioPage extends StatefulWidget {
  final String name;
  final String unit;
  final List<CardioData> data;
  final TabController tabCtrl;

  const CardioPage({
    super.key,
    required this.name,
    required this.unit,
    required this.data,
    required this.tabCtrl,
  });

  @override
  createState() => _CardioPageState();
}

class _CardioPageState extends State<CardioPage> {
  late List<CardioData> data = widget.data;
  late String target = widget.unit;
  late int limit;
  late CardioMetric metric;
  late Period period;
  DateTime? start;
  DateTime? end;
  TabController? ctrl;
  DateTime lastTap = DateTime(0);
  late bool useTimeBasedXAxis;
  Timer? _refreshTimer;
  Timer? _notesDebounce;
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsState>().value;
    useTimeBasedXAxis = settings.defaultGraphTimeBasedXAxis;
    limit = settings.defaultGraphLimit;
    metric = CardioMetric.values.firstWhere(
      (m) => m.name == settings.defaultGraphMetric,
      orElse: () => CardioMetric.pace,
    );
    period = Period.values.firstWhere(
      (p) => p.name == settings.defaultGraphPeriod,
      orElse: () => Period.day,
    );
    widget.tabCtrl.addListener(_onTabChanged);
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final pref = await (db.graphPreferences.select()
          ..where((t) => t.name.equals(widget.name)))
        .getSingleOrNull();
    if (pref == null || !mounted) return;
    setState(() {
      metric = CardioMetric.values.firstWhere(
        (m) => m.name == pref.metric,
        orElse: () => metric,
      );
      period = Period.values.firstWhere(
        (p) => p.name == pref.period,
        orElse: () => period,
      );
      limit = pref.limit;
      useTimeBasedXAxis = pref.timeBasedXAxis;
      _notesCtrl.text = pref.notes ?? '';
    });
    setData();
  }

  Future<void> _savePreferences() async {
    await db.graphPreferences.insertOne(
      GraphPreferencesCompanion.insert(
        name: widget.name,
        metric: Value(metric.name),
        period: Value(period.name),
        limit: Value(limit),
        timeBasedXAxis: Value(useTimeBasedXAxis),
        notes: Value(_notesCtrl.text.isEmpty ? null : _notesCtrl.text),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _notesDebounce?.cancel();
    _notesCtrl.dispose();
    widget.tabCtrl.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    final settings = context.read<SettingsState>().value;
    if (widget.tabCtrl.index ==
        settings.tabs.split(',').indexOf('GraphsPage')) {
      setData();
    }
  }

  LineTouchTooltipData tooltipData(String format) => LineTouchTooltipData(
        getTooltipColor: (touch) => Theme.of(context).colorScheme.surface,
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            // Only show tooltip for the first line (index 0 = actual data)
            // Return null for trend line (index 1)
            if (spot.barIndex != 0) return null;

            final row = data.elementAt(spot.spotIndex);
            String text = row.value.toStringAsFixed(2);
            final created = DateFormat(format).format(row.created);
            switch (metric) {
              case CardioMetric.pace:
                text = "${row.value} ${row.unit} / min";
                break;
              case CardioMetric.duration:
                final minutes = row.value.floor();
                final seconds =
                    ((row.value * 60) % 60).floor().toString().padLeft(2, '0');
                text = "$minutes:$seconds";
                break;
              case CardioMetric.distance:
                text += " ${row.unit}";
                break;
              case CardioMetric.incline:
                text += "%";
                break;
              case CardioMetric.inclineAdjustedPace:
                break;
            }
            return LineTooltipItem(
              "$text\n$created",
              TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            );
          }).toList();
        },
      );

  Future<void> touchLine(
    FlTouchEvent event,
    LineTouchResponse? response,
  ) async {
    if (event is ScaleUpdateDetails) return;
    if (event is! FlPanDownEvent) return;
    if (DateTime.now().difference(lastTap) >= const Duration(milliseconds: 300))
      return setState(() {
        lastTap = DateTime.now();
      });

    final index = response?.lineBarSpots?[0].spotIndex;
    if (index == null) return;
    final row = data[index];
    GymSet? gymSet = await (db.gymSets.select()
          ..where(
            (tbl) =>
                tbl.created.equals(row.created) & tbl.name.equals(widget.name),
          )
          ..limit(1))
        .getSingle();

    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditSetPage(
          gymSet: gymSet,
        ),
      ),
    );
    _refreshTimer?.cancel();
    _refreshTimer = Timer(kThemeAnimationDuration, setData);
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>().value;
    final theme = Theme.of(context);

    const metricOptions = <(CardioMetric, String)>[
      (CardioMetric.pace, 'Pace (distance / time)'),
      (CardioMetric.inclineAdjustedPace, 'Adjusted pace'),
      (CardioMetric.duration, 'Duration'),
      (CardioMetric.distance, 'Distance'),
      (CardioMetric.incline, 'Incline'),
    ];

    final spots = <FlSpot>[];
    for (var index = 0; index < data.length; index++) {
      final row = data[index];
      final value = double.parse(row.value.toStringAsFixed(1));
      if (useTimeBasedXAxis) {
        spots.add(
          FlSpot(
            row.created.millisecondsSinceEpoch.toDouble(),
            value,
          ),
        );
      } else {
        spots.add(FlSpot(index.toDouble(), value));
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final gymSets = await (db.gymSets.select()
                    ..orderBy(
                      [
                        (u) => OrderingTerm(
                              expression: u.created,
                              mode: OrderingMode.desc,
                            ),
                      ],
                    )
                    ..where((tbl) => tbl.name.equals(widget.name))
                    ..where((tbl) => tbl.hidden.equals(false))
                    ..limit(20))
                  .get();
              if (!context.mounted) return;

              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => GraphHistoryPage(
                    name: widget.name,
                    gymSets: gymSets,
                  ),
                ),
              );
              _refreshTimer?.cancel();
              _refreshTimer = Timer(kThemeAnimationDuration, setData);
            },
            icon: const Icon(Icons.history),
            tooltip: "History",
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditGraphPage(
                    name: widget.name,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit),
            tooltip: "Edit",
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: bottomNavHeight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<CardioMetric>(
                      value: metric,
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
                        _savePreferences();
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
                  _savePreferences();
                },
              ),
              const SizedBox(height: 8),
              Expanded(
                child: data.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "No data yet for ${widget.name}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 32.0, top: 16.0),
                        child: FlexLine(
                          spots: spots,
                          tooltipData: () =>
                              tooltipData(settings.shortDateFormat),
                          touchLine: touchLine,
                          data: data,
                          timeBasedXAxis: useTimeBasedXAxis,
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  controller: _notesCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Exercise notes',
                    hintText: 'Notes for this exercise',
                  ),
                  minLines: 2,
                  maxLines: 5,
                  onChanged: (_) {
                    _notesDebounce?.cancel();
                    _notesDebounce = Timer(
                      const Duration(milliseconds: 600),
                      _savePreferences,
                    );
                  },
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
                    if (metric == CardioMetric.distance &&
                        settings.showUnits) ...[
                      sectionLabel('Unit'),
                      DropdownButtonFormField<String>(
                        initialValue: target,
                        items: cardioDistanceUnitMenuItems,
                        onChanged: (value) {
                          setState(() {
                            target = value!;
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
                            value: start,
                            hint: settings.shortDateFormat,
                            onTap: () async {
                              await _selectStart();
                              setSheet(() {});
                            },
                            onClear: () {
                              setState(() {
                                start = null;
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
                            value: end,
                            hint: settings.shortDateFormat,
                            onTap: () async {
                              await _selectEnd();
                              setSheet(() {});
                            },
                            onClear: () {
                              setState(() {
                                end = null;
                              });
                              setData();
                              setSheet(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    if (settings.showGraphLimit) ...[
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
                              color:
                                  colorScheme.primary.withValues(alpha: 0.12),
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
                        max: 100,
                        onChanged: (value) {
                          setState(() {
                            limit = value.toInt();
                          });
                          setData();
                          _savePreferences();
                          setSheet(() {});
                        },
                      ),
                    ],
                    if (settings.showGraphXAxis)
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Use time-based X axis'),
                        value: useTimeBasedXAxis,
                        onChanged: (value) {
                          setState(() {
                            useTimeBasedXAxis = value;
                          });
                          _savePreferences();
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

  void setData() async {
    final cardio = await getCardioData(
      end: end,
      period: period,
      metric: metric,
      name: widget.name,
      start: start,
      target: target,
      limit: limit,
    );

    if (!mounted) return;
    setState(() {
      data = cardio;
    });
  }

  Future<void> _selectEnd() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: end,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;
    setState(() {
      end = picked;
    });
    setData();
  }

  Future<void> _selectStart() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: start,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;
    setState(() {
      start = picked;
    });
    setData();
  }
}
