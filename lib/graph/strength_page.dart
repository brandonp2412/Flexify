import 'dart:async';

import 'package:flexify/bottom_nav.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/exercise_catalog.dart';
import 'package:flexify/database/exercise_analytics.dart';
import 'package:flexify/empty_state.dart';
import 'package:flexify/graph/edit_graph_page.dart';
import 'package:flexify/graph/flex_line_chart.dart';
import 'package:flexify/graph/graph_options_controls.dart';
import 'package:flexify/graph/graph_metric_chips.dart';
import 'package:flexify/graph/graph_history_page.dart';
import 'package:flexify/graph/graph_notes_page.dart';
import 'package:flexify/graph/strength_data.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flexify/platform_page_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StrengthPage extends StatefulWidget {
  final String initialName;
  final String initialUnit;
  final List<StrengthData> initialData;
  final TabController tabCtrl;
  final bool bodyWeight;

  const StrengthPage({
    super.key,
    required this.initialName,
    required this.initialUnit,
    required this.initialData,
    required this.tabCtrl,
    this.bodyWeight = false,
  });

  @override
  createState() => _StrengthPageState();
}

class _StrengthPageState extends State<StrengthPage> {
  late List<StrengthData> _data;
  late String _targetUnit;
  late String _exerciseName;
  late bool useTimeBasedXAxis;
  Timer? _refreshTimer;
  Timer? _notesDebounce;

  late int limit;
  late StrengthMetric metric;
  late Set<StrengthMetric> _selectedMetrics;
  Map<StrengthMetric, List<StrengthData>> _metricData = {};
  int _dataRequest = 0;
  late Period period;
  DateTime? start;
  DateTime? end;
  DateTime lastTap = DateTime(0);
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _data = widget.initialData;
    _targetUnit = widget.initialUnit;
    _exerciseName = widget.initialName;
    final settings = context.read<SettingsState>().value;
    useTimeBasedXAxis = settings.defaultGraphTimeBasedXAxis;
    limit = settings.defaultGraphLimit;
    metric = StrengthMetric.values.firstWhere(
      (m) => m.name == settings.defaultGraphMetric,
      orElse: () => StrengthMetric.bestWeight,
    );
    if (!settings.showBodyWeight && metric == StrengthMetric.relativeStrength) {
      metric = StrengthMetric.bestWeight;
    }
    _selectedMetrics = {metric};
    _metricData = {metric: _data};
    period = Period.values.firstWhere(
      (p) => p.name == settings.defaultGraphPeriod,
      orElse: () => Period.day,
    );
    widget.tabCtrl.addListener(_onTabChanged);
    if (!widget.bodyWeight) _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final pref = await getExerciseByName(_exerciseName);
    if (pref == null || !mounted) return;
    setState(() {
      final names = pref.graphMetric.split(',').toSet();
      _selectedMetrics = {
        for (final m in StrengthMetric.values)
          if (names.contains(m.name)) m,
      };
      if (!context.read<SettingsState>().value.showBodyWeight) {
        _selectedMetrics.remove(StrengthMetric.relativeStrength);
      }
      if (_selectedMetrics.isEmpty)
        _selectedMetrics = {StrengthMetric.bestWeight};
      metric = _selectedMetrics.first;
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
    if (widget.bodyWeight) return;
    final exercise = await getExerciseByName(_exerciseName);
    if (exercise == null) return;
    await updateExerciseGraphPreferences(
      exerciseId: exercise.id,
      metric: _selectedMetrics.map((m) => m.name).join(','),
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
      FlexPageRoute(
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
    final metricSelector = GraphMetricChips<StrengthMetric>(
      options: metricOptions,
      selected: _selectedMetrics,
      onChanged: (next) {
        setState(() {
          _selectedMetrics = next;
          if (!next.contains(metric)) {
            metric = metricOptions.firstWhere((o) => next.contains(o.$1)).$1;
          }
          _data = _metricData[metric] ?? _data;
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

    final selectedOptions = [
      for (final option in metricOptions)
        if (_selectedMetrics.contains(option.$1)) option,
    ];
    final palette = GraphMetricChips.palette(theme.colorScheme);
    final points = <FlexLineChartPoint>[];
    for (var index = 0; index < _data.length; index++) {
      points.add(
        FlexLineChartPoint(
          useTimeBasedXAxis
              ? _data[index].created.millisecondsSinceEpoch.toDouble()
              : index.toDouble(),
          _data[index].value,
          column: index,
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(_exerciseName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!widget.bodyWeight)
            IconButton(
              onPressed: () async {
                String? newName = await Navigator.of(context).push(
                  FlexPageRoute(
                    builder: (context) => EditGraphPage(name: _exerciseName),
                  ),
                );
                if (mounted && newName != null) {
                  setState(() {
                    _exerciseName = newName;
                  });
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
              if (!widget.bodyWeight) ...[
                metricSelector,
                const SizedBox(height: 8),
              ],
              periodSelector,
              const SizedBox(height: 8),
              Expanded(
                child: _data.isEmpty
                    ? AppEmptyState(
                        icon: Icons.fitness_center_rounded,
                        title: context.l10n.noDataYet,
                        message: context.l10n.completeSetForChart,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 16.0, right: 45.0),
                        child: selectedOptions.length <= 1
                            ? FlexLineChart(
                                dates: _data.map((row) => row.created).toList(),
                                points: points,
                                tooltipText: (index) => tooltipText(
                                  metric,
                                  _data[index],
                                  shortDateFormat,
                                ),
                                onPointSelected: touchLine,
                                timeBasedXAxis: useTimeBasedXAxis,
                              )
                            : FlexMultiMetricLineChart(
                                dates: _data.map((row) => row.created).toList(),
                                timeBasedXAxis: useTimeBasedXAxis,
                                onPointSelected: touchLine,
                                series: [
                                  for (final option in selectedOptions)
                                    FlexLineChartSeries(
                                      name: option.$2,
                                      color:
                                          palette[metricOptions.indexOf(
                                                option,
                                              ) %
                                              palette.length],
                                      points: [
                                        for (
                                          var index = 0;
                                          index <
                                                  (_metricData[option.$1]
                                                          ?.length ??
                                                      0) &&
                                              index < _data.length;
                                          index++
                                        )
                                          FlexLineChartPoint(
                                            useTimeBasedXAxis
                                                ? _data[index]
                                                      .created
                                                      .millisecondsSinceEpoch
                                                      .toDouble()
                                                : index.toDouble(),
                                            _metricData[option.$1]![index]
                                                .value,
                                            column: index,
                                          ),
                                      ],
                                    ),
                                ],
                                tooltipText: (seriesIndex, index) {
                                  final option = selectedOptions[seriesIndex];
                                  final rows = _metricData[option.$1]!;
                                  return '${option.$2}: ${tooltipText(option.$1, rows[index], shortDateFormat)}';
                                },
                              ),
                      ),
              ),
              const SizedBox(height: 8),
              GraphActionButtons(
                onHistoryPressed: _showHistory,
                onOptionsPressed: _showOptions,
              ),
              const SizedBox(height: 8),
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

  Future<void> _showHistory() async {
    final exerciseSets = widget.bodyWeight
        ? await getBodyWeightGraphHistory()
        : await getGraphHistory(_exerciseName);
    if (!mounted) return;

    final desktop = isDesktopLayout(context);
    await Navigator.of(context).push(
      FlexPageRoute(
        builder: (context) => GraphHistoryPage(
          name: _exerciseName,
          initialSets: exerciseSets,
          tabController: widget.tabCtrl,
          bodyWeight: widget.bodyWeight,
        ),
      ),
    );
    if (!mounted) return;
    _refreshTimer?.cancel();
    if (desktop) {
      setData();
    } else {
      _refreshTimer = Timer(kThemeAnimationDuration, setData);
    }
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
                  unitValue: settings.showUnits ? _targetUnit : null,
                  unitItems: settings.showUnits
                      ? strengthUnitMenuItems(context.l10n)
                      : const [],
                  onUnitChanged: (value) {
                    setState(() {
                      _targetUnit = value;
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
    final request = ++_dataRequest;
    final selected = {..._selectedMetrics};
    final values = widget.bodyWeight
        ? <StrengthMetric, List<StrengthData>>{
            metric: await getBodyWeightData(
              target: _targetUnit,
              period: period,
              start: start,
              end: end,
              limit: limit,
            ),
          }
        : await getStrengthMetricsData(
            target: _targetUnit,
            name: _exerciseName,
            metrics: selected,
            period: period,
            start: start,
            end: end,
            limit: limit,
          );
    if (!mounted || request != _dataRequest) return;
    setState(() {
      _metricData = values;
      _data = values[metric] ?? const [];
    });
  }

  String tooltipText(
    StrengthMetric selectedMetric,
    StrengthData row,
    String format,
  ) {
    final created = formatDisplayDate(context, row.created, format);
    final value = formatDisplayNumber(
      context,
      row.value,
      minimumFractionDigits: 2,
    );
    final displayUnit = displayMeasurementUnit(context.l10n, _targetUnit);
    return switch (selectedMetric) {
      StrengthMetric.bestReps ||
      StrengthMetric.relativeStrength => '$value $created',
      _ => '$value$displayUnit $created',
    };
  }

  Future<void> touchLine(int index) async {
    if (DateTime.now().difference(lastTap) >=
        const Duration(milliseconds: 300)) {
      lastTap = DateTime.now();
      return;
    }

    if (widget.bodyWeight || index < 0 || index >= _data.length) return;
    final row = _data[index];
    final desktop = isDesktopLayout(context);
    final exerciseSet = await getGraphPointSet(_exerciseName, row.created);
    if (!mounted || exerciseSet == null) return;

    await Navigator.of(context).push(
      FlexPageRoute(
        builder: (context) => EditSetPage(exerciseSet: exerciseSet),
      ),
    );
    _refreshTimer?.cancel();
    if (desktop) {
      setData();
    } else {
      _refreshTimer = Timer(kThemeAnimationDuration, setData);
    }
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
