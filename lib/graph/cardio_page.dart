import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/empty_state.dart';
import 'package:flexify/graph/cardio_data.dart';
import 'package:flexify/graph/edit_graph_page.dart';
import 'package:flexify/graph/flex_line.dart';
import 'package:flexify/graph/graph_options_controls.dart';
import 'package:flexify/graph/graph_history_page.dart';
import 'package:flexify/graph/graph_notes_page.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardioPage extends StatefulWidget {
  final String name;
  final String? category;
  final String unit;
  final List<CardioData> data;
  final TabController? tabCtrl;

  const CardioPage({
    super.key,
    required this.name,
    this.category,
    required this.unit,
    required this.data,
    this.tabCtrl,
  });

  @override
  createState() => _CardioPageState();
}

class _CardioPageState extends State<CardioPage> {
  late List<CardioData> data = widget.data;
  late String target = widget.unit;
  late String name = widget.name;
  late String? category = widget.category;
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
    metric = _isWeightUnit(target)
        ? CardioMetric.weight
        : CardioMetric.values.firstWhere(
            (m) => m.name == settings.defaultGraphMetric,
            orElse: () => CardioMetric.pace,
          );
    period = Period.values.firstWhere(
      (p) => p.name == settings.defaultGraphPeriod,
      orElse: () => Period.day,
    );
    widget.tabCtrl?.addListener(_onTabChanged);
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final pref =
        await (db.graphPreferences.select()..where(
              (t) => t.name.equals(name) & t.category.equals(category ?? ''),
            ))
            .getSingleOrNull();
    if (pref == null || !mounted) return;
    setState(() {
      final savedMetric = CardioMetric.values.firstWhere(
        (m) => m.name == pref.metric,
        orElse: () => metric,
      );
      metric =
          _isWeightUnit(target) &&
              !{
                CardioMetric.weight,
                CardioMetric.duration,
                CardioMetric.incline,
              }.contains(savedMetric)
          ? CardioMetric.weight
          : savedMetric;
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
        name: name,
        category: Value(category ?? ''),
        metric: Value(metric.name),
        period: Value(period.name),
        limit: Value(limit),
        timeBasedXAxis: Value(useTimeBasedXAxis),
        notes: Value(_notesCtrl.text.isEmpty ? null : _notesCtrl.text),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  void _onNotesChanged() {
    _notesDebounce?.cancel();
    _notesDebounce = Timer(const Duration(milliseconds: 600), _savePreferences);
  }

  Future<void> _editNotes() async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) =>
            GraphNotesPage(controller: _notesCtrl, onChanged: _onNotesChanged),
      ),
    );
    _notesDebounce?.cancel();
    await _savePreferences();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _notesDebounce?.cancel();
    _notesCtrl.dispose();
    widget.tabCtrl?.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    final settings = context.read<SettingsState>().value;
    if (widget.tabCtrl?.index ==
        settings.tabs.split(',').indexOf('GraphsPage')) {
      setData();
    }
  }

  LineTouchTooltipData tooltipData(String format) => LineTouchTooltipData(
    getTooltipColor: (touch) => Theme.of(context).colorScheme.surface,
    getTooltipItems: (touchedSpots) {
      return touchedSpots.map((spot) {
        if (spot.barIndex != 0) return null;

        final row = data.elementAt(spot.spotIndex);
        String text = formatDisplayNumber(
          context,
          row.value,
          minimumFractionDigits: 2,
        );
        final created = formatDisplayDate(context, row.created, format);
        switch (metric) {
          case CardioMetric.pace:
            text =
                "${formatDisplayNumber(context, row.value)} ${displayMeasurementUnit(context.l10n, row.unit)} / ${context.l10n.minutesShort}";
            break;
          case CardioMetric.duration:
            final minutes = row.value.floor();
            final seconds = ((row.value * 60) % 60).floor().toString().padLeft(
              2,
              '0',
            );
            text = "$minutes:$seconds";
            break;
          case CardioMetric.distance:
            text += " ${displayMeasurementUnit(context.l10n, row.unit)}";
            break;
          case CardioMetric.incline:
            text = formatDisplayPercent(context, row.value / 100);
            break;
          case CardioMetric.inclineAdjustedPace:
            break;
          case CardioMetric.weight:
            text += " ${displayMeasurementUnit(context.l10n, row.unit)}";
            break;
        }
        return LineTooltipItem(
          "$text\n$created",
          TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
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
    GymSet? gymSet =
        await (db.gymSets.select()
              ..where(
                (tbl) =>
                    tbl.created.equals(row.created) &
                    isExercise(tbl, name, category),
              )
              ..limit(1))
            .getSingle();

    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => EditSetPage(gymSet: gymSet)),
    );
    _refreshTimer?.cancel();
    _refreshTimer = Timer(kThemeAnimationDuration, setData);
  }

  @override
  Widget build(BuildContext context) {
    final shortDateFormat = context.select<SettingsState, String>(
      (settings) => settings.value.shortDateFormat,
    );
    final showUnits = context.select<SettingsState, bool>(
      (settings) => settings.value.showUnits,
    );
    final desktop = isDesktopLayout(context);
    final theme = Theme.of(context);

    final metricOptions = _isWeightUnit(target)
        ? <(CardioMetric, String)>[
            (CardioMetric.weight, context.l10n.weightLabel),
            (CardioMetric.duration, context.l10n.durationLabel),
            (CardioMetric.incline, context.l10n.inclineLabel),
          ]
        : <(CardioMetric, String)>[
            (CardioMetric.pace, context.l10n.paceDistanceTime),
            (CardioMetric.inclineAdjustedPace, context.l10n.adjustedPace),
            (CardioMetric.duration, context.l10n.durationLabel),
            (CardioMetric.distance, context.l10n.distanceLabel),
            (CardioMetric.incline, context.l10n.inclineLabel),
          ];

    final metricSelector = DropdownButton<CardioMetric>(
      value: metric,
      isExpanded: true,
      underline: const SizedBox.shrink(),
      borderRadius: BorderRadius.circular(12),
      items: metricOptions
          .map(
            (option) => DropdownMenuItem(
              value: option.$1,
              child: Text(option.$2, style: theme.textTheme.titleLarge),
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
                style: theme.textTheme.titleLarge,
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
        _savePreferences();
      },
    );
    final showUnitControl =
        showUnits &&
        (metric == CardioMetric.distance || metric == CardioMetric.weight);
    final unitItems = showUnitControl
        ? (metric == CardioMetric.weight
              ? strengthUnitMenuItems(context.l10n)
              : cardioDistanceUnitMenuItems(context.l10n))
        : <DropdownMenuItem<String>>[];

    final spots = <FlSpot>[];
    for (var index = 0; index < data.length; index++) {
      final row = data[index];
      final value = double.parse(row.value.toStringAsFixed(1));
      if (useTimeBasedXAxis) {
        spots.add(FlSpot(row.created.millisecondsSinceEpoch.toDouble(), value));
      } else {
        spots.add(FlSpot(index.toDouble(), value));
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(exerciseLabel(context.l10n, name, category)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final gymSets =
                  await (db.gymSets.select()
                        ..orderBy([
                          (u) => OrderingTerm(
                            expression: u.created,
                            mode: OrderingMode.desc,
                          ),
                        ])
                        ..where((tbl) => isExercise(tbl, name, category))
                        ..where((tbl) => tbl.hidden.equals(false))
                        ..limit(20))
                      .get();
              if (!context.mounted) return;

              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => GraphHistoryPage(
                    name: name,
                    category: category,
                    gymSets: gymSets,
                    tabController: widget.tabCtrl,
                  ),
                ),
              );
              _refreshTimer?.cancel();
              _refreshTimer = Timer(kThemeAnimationDuration, setData);
            },
            icon: const Icon(Icons.history),
            tooltip: context.l10n.navHistory,
          ),
          IconButton(
            onPressed: () async {
              final renamed = await Navigator.of(context).push<ExerciseKey>(
                MaterialPageRoute(
                  builder: (context) =>
                      EditGraphPage(name: name, category: category),
                ),
              );
              if (mounted && renamed != null) {
                final updated =
                    await (db.gymSets.select()
                          ..where(
                            (tbl) =>
                                isExercise(tbl, renamed.name, renamed.category),
                          )
                          ..limit(1))
                        .getSingleOrNull();
                if (!mounted) return;
                setState(() {
                  name = renamed.name;
                  category = renamed.category;
                  if (updated != null) target = updated.unit;
                  if (_isWeightUnit(target) &&
                      !{
                        CardioMetric.weight,
                        CardioMetric.duration,
                        CardioMetric.incline,
                      }.contains(metric)) {
                    metric = CardioMetric.weight;
                  } else if (!_isWeightUnit(target) &&
                      metric == CardioMetric.weight) {
                    metric = CardioMetric.pace;
                  }
                });
                setData();
              }
            },
            icon: const Icon(Icons.edit),
            tooltip: context.l10n.actionEdit,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: desktop ? 24.0 : bottomNavHeight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
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
                const SizedBox(height: 8),
                periodSelector,
              ],
              if (desktop) ...[
                const SizedBox(height: 12),
                GraphOptionsControls(
                  compact: true,
                  shortDateFormat: shortDateFormat,
                  unitValue: showUnitControl ? target : null,
                  unitItems: unitItems,
                  onUnitChanged: (value) {
                    setState(() {
                      target = value;
                    });
                    setData();
                  },
                  startDate: start,
                  endDate: end,
                  onSelectStart: _selectStart,
                  onClearStart: () {
                    setState(() {
                      start = null;
                    });
                    setData();
                  },
                  onSelectEnd: _selectEnd,
                  onClearEnd: () {
                    setState(() {
                      end = null;
                    });
                    setData();
                  },
                  limit: limit,
                  maxLimit: 100,
                  onLimitChanged: (value) {
                    setState(() {
                      limit = value;
                    });
                    setData();
                    _savePreferences();
                  },
                  timeBasedXAxis: useTimeBasedXAxis,
                  onTimeBasedXAxisChanged: (value) {
                    setState(() {
                      useTimeBasedXAxis = value;
                    });
                    _savePreferences();
                  },
                ),
              ],
              const SizedBox(height: 8),
              Expanded(
                child: data.isEmpty
                    ? AppEmptyState(
                        icon: Icons.monitor_heart_outlined,
                        title: context.l10n.noDataFor(name),
                        message: context.l10n.completeSetForChart,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 32.0, top: 16.0),
                        child: FlexLine(
                          spots: spots,
                          tooltipData: () => tooltipData(shortDateFormat),
                          touchLine: touchLine,
                          data: data,
                          timeBasedXAxis: useTimeBasedXAxis,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  controller: _notesCtrl,
                  readOnly: true,
                  onTap: _editNotes,
                  decoration: InputDecoration(
                    labelText: context.l10n.exerciseNotes,
                    hintText: context.l10n.notesForExercise,
                  ),
                  minLines: 2,
                  maxLines: 5,
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
            final showUnitControl =
                settings.showUnits &&
                (metric == CardioMetric.distance ||
                    metric == CardioMetric.weight);
            final unitItems = showUnitControl
                ? (metric == CardioMetric.weight
                      ? strengthUnitMenuItems(context.l10n)
                      : cardioDistanceUnitMenuItems(context.l10n))
                : <DropdownMenuItem<String>>[];
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
                  unitValue: showUnitControl ? target : null,
                  unitItems: unitItems,
                  onUnitChanged: (value) {
                    setState(() {
                      target = value;
                    });
                    setData();
                    refreshSheet();
                  },
                  startDate: start,
                  endDate: end,
                  onSelectStart: () async {
                    await _selectStart();
                    if (sheetContext.mounted) refreshSheet();
                  },
                  onClearStart: () {
                    setState(() {
                      start = null;
                    });
                    setData();
                    refreshSheet();
                  },
                  onSelectEnd: () async {
                    await _selectEnd();
                    if (sheetContext.mounted) refreshSheet();
                  },
                  onClearEnd: () {
                    setState(() {
                      end = null;
                    });
                    setData();
                    refreshSheet();
                  },
                  limit: limit,
                  maxLimit: 100,
                  onLimitChanged: (value) {
                    setState(() {
                      limit = value;
                    });
                    setData();
                    _savePreferences();
                    refreshSheet();
                  },
                  timeBasedXAxis: useTimeBasedXAxis,
                  onTimeBasedXAxisChanged: (value) {
                    setState(() {
                      useTimeBasedXAxis = value;
                    });
                    _savePreferences();
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

  void setData() async {
    final cardio = await getCardioData(
      end: end,
      period: period,
      metric: metric,
      name: name,
      category: category,
      start: start,
      target: target,
      limit: limit,
    );

    if (!mounted) return;
    setState(() {
      data = cardio;
    });
  }

  bool _isWeightUnit(String value) =>
      value == 'kg' || value == 'lb' || value == 'stone';

  Future<void> _selectEnd() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: end,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null || !mounted) return;
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

    if (picked == null || !mounted) return;
    setState(() {
      start = picked;
    });
    setData();
  }
}
