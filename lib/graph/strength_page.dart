import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/exercise_catalog.dart';
import 'package:flexify/database/exercise_analytics.dart';
import 'package:flexify/empty_state.dart';
import 'package:flexify/graph/edit_graph_page.dart';
import 'package:flexify/graph/flex_line.dart';
import 'package:flexify/graph/graph_options_controls.dart';
import 'package:flexify/graph/graph_history_page.dart';
import 'package:flexify/graph/graph_notes_page.dart';
import 'package:flexify/graph/strength_data.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StrengthPage extends StatefulWidget {
  final String name;
  final String unit;
  final List<StrengthData> data;
  final TabController tabCtrl;

  const StrengthPage({
    super.key,
    required this.name,
    required this.unit,
    required this.data,
    required this.tabCtrl,
  });

  @override
  createState() => _StrengthPageState();
}

class _StrengthPageState extends State<StrengthPage> {
  late List<StrengthData> data = widget.data;
  late String target = widget.unit;
  late String name = widget.name;
  late bool useTimeBasedXAxis;
  Timer? _refreshTimer;
  Timer? _notesDebounce;

  late int limit;
  late StrengthMetric metric;
  late Period period;
  DateTime? start;
  DateTime? end;
  DateTime lastTap = DateTime(0);
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsState>().value;
    useTimeBasedXAxis = settings.defaultGraphTimeBasedXAxis;
    limit = settings.defaultGraphLimit;
    metric = StrengthMetric.values.firstWhere(
      (m) => m.name == settings.defaultGraphMetric,
      orElse: () => StrengthMetric.bestWeight,
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
      metric = StrengthMetric.values.firstWhere(
        (m) => m.name == pref.graphMetric,
        orElse: () => metric,
      );
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

  @override
  Widget build(BuildContext context) {
    final showBodyWeight = context.select<SettingsState, bool>(
      (settings) => settings.value.showBodyWeight,
    );
    final shortDateFormat = context.select<SettingsState, String>(
      (settings) => settings.value.shortDateFormat,
    );
    final showNotes = context.select<SettingsState, bool>(
      (settings) => settings.value.showNotes,
    );
    final showUnits = context.select<SettingsState, bool>(
      (settings) => settings.value.showUnits,
    );
    final desktop = isDesktopLayout(context);
    final theme = Theme.of(context);

    final metricOptions = <(StrengthMetric, String)>[
      (StrengthMetric.bestWeight, context.l10n.bestWeight),
      (StrengthMetric.bestReps, context.l10n.bestReps),
      (StrengthMetric.oneRepMax, context.l10n.oneRepMax),
      (StrengthMetric.volume, context.l10n.volume),
      if (showBodyWeight)
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

    final spots = <FlSpot>[];
    for (var index = 0; index < data.length; index++) {
      if (useTimeBasedXAxis) {
        spots.add(
          FlSpot(
            data[index].created.millisecondsSinceEpoch.toDouble(),
            data[index].value,
          ),
        );
      } else {
        spots.add(FlSpot(index.toDouble(), data[index].value));
      }
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
              String? newName = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditGraphPage(name: name),
                ),
              );
              if (mounted && newName != null)
                setState(() {
                  name = newName;
                });
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
                    if (name != 'Weight') Expanded(child: metricSelector),
                    if (name != 'Weight') const SizedBox(width: 16),
                    Expanded(flex: 2, child: periodSelector),
                  ],
                )
              else ...[
                Row(
                  children: [
                    if (name != 'Weight')
                      Expanded(child: metricSelector)
                    else
                      const Spacer(),
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
                  unitValue: showUnits ? target : null,
                  unitItems: showUnits
                      ? strengthUnitMenuItems(context.l10n)
                      : const [],
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
              if (metric == StrengthMetric.oneRepMax &&
                  data.any((row) => row.reps >= 10))
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: theme.colorScheme.onErrorContainer,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            context.l10n.oneRepMaxAccuracyWarning,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Expanded(
                child: data.isEmpty
                    ? AppEmptyState(
                        icon: Icons.fitness_center_rounded,
                        title: context.l10n.noDataYet,
                        message: context.l10n.completeSetForChart,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 16.0, right: 45.0),
                        child: FlexLine(
                          data: data,
                          spots: spots,
                          tooltipData: () => tooltipData(shortDateFormat),
                          touchLine: touchLine,
                          timeBasedXAxis: useTimeBasedXAxis,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              if (showNotes) ...[
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
              ],
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
                  unitValue: settings.showUnits ? target : null,
                  unitItems: settings.showUnits
                      ? strengthUnitMenuItems(context.l10n)
                      : const [],
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

  Future<void> setData() async {
    if (!mounted) return;
    final strengthData = await getStrengthData(
      target: target,
      name: name,
      metric: metric,
      period: period,
      start: start,
      end: end,
      limit: limit,
    );
    if (!mounted) return;
    setState(() {
      data = strengthData;
    });
  }

  LineTouchTooltipData tooltipData(String format) {
    return LineTouchTooltipData(
      getTooltipColor: (touch) => Theme.of(context).colorScheme.surface,
      getTooltipItems: (touchedSpots) {
        return touchedSpots.map((spot) {
          if (spot.barIndex != 0) return null;

          final row = data.elementAt(spot.spotIndex);
          final created = formatDisplayDate(context, row.created, format);
          final value = formatDisplayNumber(
            context,
            row.value,
            minimumFractionDigits: 2,
          );
          final displayUnit = displayMeasurementUnit(context.l10n, target);

          String text = "$value$displayUnit $created";
          switch (metric) {
            case StrengthMetric.bestReps:
            case StrengthMetric.relativeStrength:
              text = "$value $created";
              break;
            case StrengthMetric.volume:
            case StrengthMetric.oneRepMax:
              text = "$value$displayUnit $created";
              break;
            case StrengthMetric.bestWeight:
              break;
          }

          return LineTooltipItem(
            text,
            TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
          );
        }).toList();
      },
    );
  }

  Future<void> touchLine(
    FlTouchEvent event,
    LineTouchResponse? touchResponse,
  ) async {
    if (event is ScaleUpdateDetails) return;
    if (event is! FlPanDownEvent) return;
    if (DateTime.now().difference(lastTap) >=
        const Duration(milliseconds: 300)) {
      return setState(() {
        lastTap = DateTime.now();
      });
    }

    final index = touchResponse?.lineBarSpots?[0].spotIndex;
    if (index == null) return;
    final row = data[index];
    final gymSet = await getGraphPointSet(name, row.created);
    if (!mounted || gymSet == null) return;

    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => EditSetPage(gymSet: gymSet)),
    );
    _refreshTimer?.cancel();
    _refreshTimer = Timer(kThemeAnimationDuration, setData);
  }

  Future<void> _selectEnd() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: end,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null || !mounted) return;

    setState(() {
      end = pickedDate;
    });
    setData();
  }

  Future<void> _selectStart() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: start,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null || !mounted) return;

    setState(() {
      start = pickedDate;
    });
    setData();
  }
}
