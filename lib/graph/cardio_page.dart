import 'dart:async';

import 'package:flexify/bottom_nav.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/exercise_catalog.dart';
import 'package:flexify/database/exercise_analytics.dart';
import 'package:flexify/empty_state.dart';
import 'package:flexify/graph/cardio_data.dart';
import 'package:flexify/graph/edit_graph_page.dart';
import 'package:flexify/graph/flex_line.dart';
import 'package:flexify/graph/graph_options_controls.dart';
import 'package:flexify/graph/graph_history_page.dart';
import 'package:flexify/graph/graph_notes_page.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
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
  late String name = widget.name;
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
    widget.tabCtrl.addListener(_onTabChanged);
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final pref = await getExerciseByName(name);
    if (pref == null || !mounted) return;
    setState(() {
      final savedMetric = CardioMetric.values.firstWhere(
        (m) => m.name == pref.graphMetric,
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
        (p) => p.name == pref.graphPeriod,
        orElse: () => period,
      );
      limit = pref.graphLimit;
      useTimeBasedXAxis = pref.graphTimeBasedXAxis;
      _notesCtrl.text = pref.notes ?? '';
    });
    setData();
  }

  Future<void> _savePreferences() async {
    final exercise = await getExerciseByName(name);
    if (exercise == null) return;
    await updateExerciseGraphPreferences(
      exerciseId: exercise.id,
      metric: metric.name,
      period: period.name,
      limit: limit,
      timeBasedXAxis: useTimeBasedXAxis,
      notes: _notesCtrl.text.isEmpty ? null : _notesCtrl.text,
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

  String tooltipText(int index, String format) {
    final row = data.elementAt(index);
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
    return "$text\n$created";
  }

  Future<void> touchLine(int index) async {
    if (DateTime.now().difference(lastTap) >=
        const Duration(milliseconds: 300)) {
      return setState(() {
        lastTap = DateTime.now();
      });
    }

    if (index < 0 || index >= data.length) return;
    final row = data[index];
    final gymSet = await getGraphPointSet(name, row.created);
    if (!mounted || gymSet == null) return;

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

    final points = <FlexChartPoint>[];
    for (var index = 0; index < data.length; index++) {
      final row = data[index];
      final value = double.parse(row.value.toStringAsFixed(1));
      points.add(
        FlexChartPoint(
          useTimeBasedXAxis
              ? row.created.millisecondsSinceEpoch.toDouble()
              : index.toDouble(),
          value,
          column: index,
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final gymSets = await getGraphHistory(name);
              if (!context.mounted) return;

              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => GraphHistoryPage(
                    name: name,
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
              final newName = await Navigator.of(context).push<String>(
                MaterialPageRoute(
                  builder: (context) => EditGraphPage(name: name),
                ),
              );
              if (mounted && newName != null) {
                final updated = await getExerciseByName(newName);
                if (!mounted) return;
                setState(() {
                  name = newName;
                  if (updated != null) target = updated.displayUnit;
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
                          points: points,
                          tooltipText: (index) =>
                              tooltipText(index, shortDateFormat),
                          onPointSelected: touchLine,
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
