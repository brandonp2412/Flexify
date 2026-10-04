import 'package:drift/drift.dart' hide Column;
import 'package:flexify/animated_fab.dart';
import 'package:flexify/app_search.dart';
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_analytics.dart';
import 'package:flexify/empty_state.dart';
import 'package:flexify/graph/add_exercise_page.dart';
import 'package:flexify/graph/cardio_data.dart';
import 'package:flexify/graph/edit_graph_page.dart';
import 'package:flexify/graph/flex_line_chart.dart';
import 'package:flexify/graph/global_progress_page.dart';
import 'package:flexify/graphs_filters.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/selection_controller.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flexify/platform_page_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'graph_tile.dart';

class GraphsPage extends StatefulWidget {
  final TabController tabController;

  const GraphsPage({super.key, required this.tabController});

  @override
  createState() => GraphsPageState();
}

class GraphsPageState extends State<GraphsPage>
    with AutomaticKeepAliveClientMixin {
  late final Stream<List<GraphExerciseSummary>> _stream = watchGraphs();

  final _selection = SelectionController<String>();
  final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  String _search = '';
  String? _category;
  final _scroll = ScrollController();
  bool extendFab = true;
  int _total = 0;
  GraphSort _sort = GraphSort.dateDesc;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NavigatorPopHandler(
      onPopWithResult: (result) {
        if (navKey.currentState!.canPop() == false) return;
        final settings = context.read<SettingsState>().value;
        final graphsIndex = settings.tabs.split(',').indexOf('GraphsPage');
        if (widget.tabController.index == graphsIndex)
          Navigator.of(navKey.currentContext!).pop();
      },
      child: Navigator(
        key: navKey,
        onGenerateRoute: (settings) => FlexPageRoute(
          builder: (context) => graphsPage(),
          settings: settings,
        ),
      ),
    );
  }

  Future<void> onDelete() async {
    final keys = _selection.toList();
    final summaries = (await _stream.first)
        .where((summary) => keys.contains(summary.selectionKey))
        .toList();
    final exerciseIds = summaries
        .where((summary) => !summary.bodyWeight)
        .map((summary) => summary.exerciseId!)
        .toList();
    final deleteBodyWeight = summaries.any((summary) => summary.bodyWeight);

    setState(_selection.clear);

    await db.transaction(() async {
      if (deleteBodyWeight) {
        await db.bodyWeights.deleteAll();
      }
      if (exerciseIds.isNotEmpty) {
        await (db.exerciseSets.delete()
              ..where((set) => set.exerciseId.isIn(exerciseIds)))
            .go();
        await (db.planExercises.delete()
              ..where((row) => row.exerciseId.isIn(exerciseIds)))
            .go();
        await (db.exercises.delete()
              ..where((exercise) => exercise.id.isIn(exerciseIds)))
            .go();
      }
    });
  }

  Future<int> _countSelectedGraphRecords() async {
    final keys = _selection.toList();
    final summaries = (await _stream.first)
        .where((summary) => keys.contains(summary.selectionKey))
        .toList();
    var count = await countGraphSets(
      summaries
          .where((summary) => !summary.bodyWeight)
          .map((summary) => summary.name),
    );
    if (summaries.any((summary) => summary.bodyWeight)) {
      count += await db.bodyWeights.count().getSingle();
    }
    return count;
  }

  Future<void> _editGraphSummary(GraphExerciseSummary summary) async {
    if (summary.bodyWeight) return;
    await Navigator.of(context).push(
      FlexPageRoute(builder: (context) => EditGraphPage(name: summary.name)),
    );
  }

  Future<void> _deleteGraphSummary(GraphExerciseSummary summary) async {
    final count = summary.bodyWeight
        ? await db.bodyWeights.count().getSingle()
        : await countGraphSets([summary.name]);
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.confirmDelete),
        content: Text(context.l10n.deleteGraphRecordsConfirmation(count)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(context.l10n.actionDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() {
      _selection.setAll([summary.selectionKey]);
    });
    await onDelete();
  }

  Future<void> _hideGlobalProgressAt(Offset position) async {
    final hide = await showDesktopContextMenu<bool>(context, position, [
      PopupMenuItem(
        value: true,
        child: ListTile(
          leading: const Icon(Icons.visibility_off_outlined),
          title: Text(context.l10n.hideGlobalProgress),
        ),
      ),
    ]);
    if (hide == true) {
      await db.settings.update().write(
        const SettingsCompanion(showGlobalProgress: Value(false)),
      );
    }
  }

  String tooltipText(
    List<dynamic> data,
    String unit,
    String format,
    int index,
  ) {
    final row = data.elementAt(index);
    final created = formatDisplayDate(context, row.created, format);

    if (row is CardioData) {
      return "${formatDisplayNumber(context, row.value)} ${displayMeasurementUnit(context.l10n, row.unit)} / ${context.l10n.minutesShort}";
    }

    return "${formatDisplayNumber(context, row.reps, maximumFractionDigits: 0)} × ${formatDisplayNumber(context, row.value, minimumFractionDigits: 2)}${displayMeasurementUnit(context.l10n, unit)} $created";
  }

  Widget getPeek(
    GraphExerciseSummary exerciseSet,
    List<dynamic> data,
    String format,
  ) {
    final points = [
      for (var index = 0; index < data.length; index++)
        FlexLineChartPoint(index.toDouble(), data[index].value),
    ];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 48.0,
          top: 16.0,
          left: 48.0,
          bottom: 16.0,
        ),
        child: FlexLineChart(
          points: points,
          tooltipText: (index) =>
              tooltipText(data, exerciseSet.unit, format, index),
          hideBottom: true,
          hideLeft: true,
          showTrendLine: false,
        ),
      ),
    );
  }

  bool _isWeightUnit(String unit) =>
      unit == 'kg' || unit == 'lb' || unit == 'stone';

  Scaffold graphsPage() {
    final desktop = isDesktopLayout(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: desktop
          ? AppBar(
              title: Text(context.l10n.navGraphs),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: FilledButton.icon(
                    onPressed: () => navKey.currentState!.push(
                      FlexPageRoute(
                        builder: (context) => const AddExercisePage(),
                      ),
                    ),
                    icon: const Icon(Icons.add_rounded),
                    label: Text(context.l10n.newExercise),
                  ),
                ),
              ],
            )
          : null,
      body: ResponsiveContent(
        maxWidth: desktopDataContentMaxWidth,
        desktopPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: StreamBuilder(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorWidget(context.l10n.unexpectedError);
            }
            if (!snapshot.hasData) return const SizedBox();

            final terms = _search
                .toLowerCase()
                .split(" ")
                .where((term) => term.isNotEmpty);
            var stream = snapshot.data!.where((exerciseSet) {
              if (_category != null) {
                return exerciseSet.category == _category;
              }
              return true;
            });

            for (final term in terms) {
              stream = stream.where(
                (exerciseSet) => exerciseSet.name.toLowerCase().contains(term),
              );
            }

            final exerciseSets = stream.toList();
            switch (_sort) {
              case GraphSort.dateDesc:
                exerciseSets.sort((a, b) => b.created.compareTo(a.created));
                break;

              case GraphSort.dateAsc:
                exerciseSets.sort((a, b) => a.created.compareTo(b.created));
                break;

              case GraphSort.name:
                exerciseSets.sort(
                  (a, b) =>
                      a.name.toLowerCase().compareTo(b.name.toLowerCase()),
                );
                break;
            }
            return Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    children: [
                      Selector<SettingsState, bool>(
                        selector: (p0, settingsState) =>
                            settingsState.value.showGlobalProgress,
                        builder: (context, showGlobal, child) {
                          final globalSearchTerms =
                              '${context.l10n.globalProgress} ${context.l10n.navGraphs}'
                                  .toLowerCase();
                          final globalProgressVisible =
                              showGlobal &&
                              _category == null &&
                              globalSearchTerms.contains(_search.toLowerCase());
                          final showEmpty =
                              exerciseSets.isEmpty && !globalProgressVisible;
                          return Expanded(
                            child: showEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      top: appSearchHeight,
                                    ),
                                    child: AppEmptyState(
                                      icon: Icons.search_off_rounded,
                                      title: context.l10n.noGraphsFound,
                                      message: _search.trim().isEmpty
                                          ? context
                                                .l10n
                                                .completeSetForFirstGraph
                                          : context.l10n
                                                .nothingMatchesGraphSearch(
                                                  _search.trim(),
                                                ),
                                      actionLabel: _search.trim().isEmpty
                                          ? context.l10n.addExercise
                                          : context.l10n.addNamed(
                                              _search.trim(),
                                            ),
                                      actionIcon: Icons.add_rounded,
                                      onAction: () =>
                                          Navigator.of(context).push(
                                            FlexPageRoute(
                                              builder: (context) =>
                                                  AddExercisePage(
                                                    name: _search,
                                                  ),
                                            ),
                                          ),
                                    ),
                                  )
                                : graphList(exerciseSets, showGlobal),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppSearch(
                    hintText: context.l10n.searchGraphs,
                    controller: _selection,
                    filter: GraphsFilters(
                      category: _category,
                      setCategory: (value) {
                        setState(() {
                          _category = value;
                        });
                      },
                      sort: _sort,
                      setSort: (value) {
                        setState(() {
                          _sort = value;
                        });
                      },
                    ),
                    onShare: onShare,
                    onChange: (value) {
                      setState(() {
                        _search = value;
                      });
                    },
                    onDelete: () async => onDelete(),
                    onSelectAll: () => setState(() {
                      _selection.setAll(
                        exerciseSets.map(
                          (exerciseSet) => exerciseSet.selectionKey,
                        ),
                      );
                    }),
                    onEdit: () async {
                      final key = _selection.first;
                      final summary = (await _stream.first).firstWhere(
                        (entry) => entry.selectionKey == key,
                      );
                      if (summary.bodyWeight || !context.mounted) return;
                      await Navigator.of(context).push(
                        FlexPageRoute(
                          builder: (context) =>
                              EditGraphPage(name: summary.name),
                        ),
                      );
                    },
                    confirmText: context.l10n.deleteGraphRecordsConfirmation(
                      _total,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: desktop
          ? null
          : AnimatedFab(
              onPressed: () => navKey.currentState!.push(
                FlexPageRoute(builder: (context) => const AddExercisePage()),
              ),
              label: Text(context.l10n.actionAdd),
              scroll: _scroll,
              icon: const Icon(Icons.add),
            ),
    );
  }

  Future<void> onShare() async {
    final l10n = context.l10n;
    final copy = _selection.toList();
    setState(() {
      _selection.clear();
    });
    final sets = (await _stream.first)
        .where((exerciseSet) => copy.contains(exerciseSet.selectionKey))
        .toList();
    final text = sets
        .map(
          (exerciseSet) =>
              "${formatDisplayNumber(context, exerciseSet.reps)}×${formatDisplayNumber(context, exerciseSet.weight)}${displayMeasurementUnit(l10n, exerciseSet.unit)} ${exerciseSet.name}",
        )
        .join(', ');
    await SharePlus.instance.share(ShareParams(text: l10n.shareWorkout(text)));
  }

  void longPressGlobal() {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.visibility_off),
                title: Text(context.l10n.hideGlobalProgress),
                onTap: () {
                  db.settings.update().write(
                    const SettingsCompanion(showGlobalProgress: Value(false)),
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.clear),
                title: Text(context.l10n.actionCancel),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _desktopGraphList(
    List<GraphExerciseSummary> exerciseSets,
    bool showGlobalProgress,
  ) {
    final globalSearchTerms =
        '${context.l10n.globalProgress} ${context.l10n.navGraphs}'
            .toLowerCase();
    final showGlobal =
        globalSearchTerms.contains(_search.toLowerCase()) &&
        _category == null &&
        showGlobalProgress;
    final settings = context.read<SettingsState>().value;
    final showPeekGraph =
        settings.peekGraph && exerciseSets.firstOrNull != null;

    Widget graphTile(GraphExerciseSummary exerciseSet) => GraphTile(
      selected: _selection.selected,
      exerciseSet: exerciseSet,
      onSelect: (key) async {
        setState(() {
          _selection.toggle(key);
        });
        final total = await _countSelectedGraphRecords();
        if (!mounted) return;
        setState(() {
          _total = total;
        });
      },
      tabCtrl: widget.tabController,
      onEdit: exerciseSet.bodyWeight
          ? null
          : () => _editGraphSummary(exerciseSet),
      onDelete: () => _deleteGraphSummary(exerciseSet),
    );

    return CustomScrollView(
      controller: _scroll,
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: appSearchHeight + 8)),
        if (showGlobal)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            sliver: SliverToBoxAdapter(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onSecondaryTapDown: (details) =>
                    _hideGlobalProgressAt(details.globalPosition),
                child: Material(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 9,
                    ),
                    leading: const Icon(Icons.language),
                    title: Text(
                      context.l10n.globalProgress,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(context.l10n.chartGroupedByCategory),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.of(context).push(
                      FlexPageRoute(
                        builder: (context) => GlobalProgressPage(
                          tabController: widget.tabController,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (showPeekGraph)
          SliverToBoxAdapter(
            child: Consumer<SettingsState>(
              builder:
                  (
                    BuildContext context,
                    SettingsState settings,
                    Widget? child,
                  ) {
                    if (!settings.value.peekGraph ||
                        exerciseSets.firstOrNull == null) {
                      return const SizedBox();
                    }
                    return FutureBuilder(
                      builder: (context, snapshot) => snapshot.data != null
                          ? getPeek(
                              exerciseSets.first,
                              snapshot.data!,
                              settings.value.shortDateFormat,
                            )
                          : const SizedBox(),
                      future: exerciseSets.first.bodyWeight
                          ? getBodyWeightData(
                              target: exerciseSets.first.unit,
                              period: Period.day,
                              start: null,
                              end: null,
                              limit: 20,
                            )
                          : exerciseSets.first.cardio
                          ? getCardioData(
                              name: exerciseSets.first.name,
                              target: exerciseSets.first.unit,
                              metric: _isWeightUnit(exerciseSets.first.unit)
                                  ? CardioMetric.weight
                                  : CardioMetric.pace,
                            )
                          : getStrengthData(
                              target: exerciseSets.first.unit,
                              name: exerciseSets.first.name,
                              metric: StrengthMetric.bestWeight,
                              period: Period.day,
                              start: null,
                              end: null,
                              limit: 20,
                            ),
                    );
                  },
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 32),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 620,
              mainAxisExtent: 94,
              crossAxisSpacing: 4,
              mainAxisSpacing: 2,
            ),
            itemCount: exerciseSets.length,
            itemBuilder: (context, index) => graphTile(exerciseSets[index]),
          ),
        ),
      ],
    );
  }

  Widget graphList(
    List<GraphExerciseSummary> exerciseSets,
    bool showGlobalProgress,
  ) {
    if (isDesktopLayout(context)) {
      return _desktopGraphList(exerciseSets, showGlobalProgress);
    }
    var itemCount = exerciseSets.length;
    final globalSearchTerms =
        '${context.l10n.globalProgress} ${context.l10n.navGraphs}'
            .toLowerCase();
    final showGlobal =
        globalSearchTerms.contains(_search.toLowerCase()) &&
        _category == null &&
        showGlobalProgress;
    if (showGlobal) itemCount++;

    final settings = context.read<SettingsState>().value;
    final showPeekGraph =
        settings.peekGraph && exerciseSets.firstOrNull != null;
    if (showPeekGraph) itemCount++;

    return ListView.builder(
      itemCount: itemCount,
      controller: _scroll,
      padding: EdgeInsets.only(
        bottom: isDesktopLayout(context) ? 32 : floatingActionButtonListPadding,
        top: appSearchHeight + 8,
      ),
      itemBuilder: (context, index) {
        int currentIdx = index;

        if (showGlobal) {
          if (index == 0) {
            return ResponsiveContent(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 5,
                ),
                child: Material(
                  color: isDesktopLayout(context)
                      ? Theme.of(context).colorScheme.surfaceContainerLow
                      : Colors.transparent,
                  borderRadius: isDesktopLayout(context)
                      ? BorderRadius.circular(16)
                      : null,
                  clipBehavior: isDesktopLayout(context)
                      ? Clip.antiAlias
                      : Clip.none,
                  child: ListTile(
                    contentPadding: isDesktopLayout(context)
                        ? const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 9,
                          )
                        : null,
                    leading: const Icon(Icons.language),
                    title: Text(
                      context.l10n.globalProgress,
                      style: isDesktopLayout(context)
                          ? Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            )
                          : null,
                    ),
                    subtitle: Text(context.l10n.chartGroupedByCategory),
                    trailing: isDesktopLayout(context)
                        ? const Icon(Icons.chevron_right_rounded)
                        : null,
                    onTap: () => Navigator.of(context).push(
                      FlexPageRoute(
                        builder: (context) => GlobalProgressPage(
                          tabController: widget.tabController,
                        ),
                      ),
                    ),
                    onLongPress: longPressGlobal,
                  ),
                ),
              ),
            );
          }
          currentIdx--;
        }

        if (showPeekGraph && currentIdx == 0) {
          return Consumer<SettingsState>(
            builder:
                (BuildContext context, SettingsState settings, Widget? child) {
                  if (!settings.value.peekGraph) return const SizedBox();
                  if (exerciseSets.firstOrNull == null) return const SizedBox();

                  return FutureBuilder(
                    builder: (context, snapshot) => snapshot.data != null
                        ? getPeek(
                            exerciseSets.first,
                            snapshot.data!,
                            settings.value.shortDateFormat,
                          )
                        : const SizedBox(),
                    future: exerciseSets.first.bodyWeight
                        ? getBodyWeightData(
                            target: exerciseSets.first.unit,
                            period: Period.day,
                            start: null,
                            end: null,
                            limit: 20,
                          )
                        : exerciseSets.first.cardio
                        ? getCardioData(
                            name: exerciseSets.first.name,
                            target: exerciseSets.first.unit,
                            metric: _isWeightUnit(exerciseSets.first.unit)
                                ? CardioMetric.weight
                                : CardioMetric.pace,
                          )
                        : getStrengthData(
                            target: exerciseSets.first.unit,
                            name: exerciseSets.first.name,
                            metric: StrengthMetric.bestWeight,
                            period: Period.day,
                            start: null,
                            end: null,
                            limit: 20,
                          ),
                  );
                },
          );
        }

        if (showPeekGraph && currentIdx > 0) {
          currentIdx--;
        }

        final exerciseSet = exerciseSets.elementAtOrNull(currentIdx);
        if (exerciseSet == null) return const SizedBox();

        return ResponsiveContent(
          child: GraphTile(
            selected: _selection.selected,
            exerciseSet: exerciseSet,
            onSelect: (key) async {
              setState(() {
                _selection.toggle(key);
              });
              final total = await _countSelectedGraphRecords();
              if (!mounted) return;
              setState(() {
                _total = total;
              });
            },
            tabCtrl: widget.tabController,
            onEdit: exerciseSet.bodyWeight
                ? null
                : () => _editGraphSummary(exerciseSet),
            onDelete: () => _deleteGraphSummary(exerciseSet),
          ),
        );
      },
    );
  }
}
