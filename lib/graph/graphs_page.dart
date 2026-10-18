import 'package:drift/drift.dart' hide Column;
import 'package:flexify/app_fab.dart';
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
import 'package:flexify/utils.dart';
import 'package:flexify/platform_page_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'graph_tile.dart';

void applyGraphSortToNewestFirstSummaries(
  List<GraphExerciseSummary> summaries,
  GraphSort sort,
) {
  switch (sort) {
    case GraphSort.dateDesc:
      break;
    case GraphSort.dateAsc:
      for (var i = 0, j = summaries.length - 1; i < j; i++, j--) {
        final item = summaries[i];
        summaries[i] = summaries[j];
        summaries[j] = item;
      }
      break;
    case GraphSort.name:
      summaries.sort((a, b) => a.normalizedName.compareTo(b.normalizedName));
      break;
  }
}

List<GraphExerciseSummary> filterGraphSummaries(
  List<GraphExerciseSummary> summaries,
  String search,
  String? category,
) {
  final terms = search
      .toLowerCase()
      .split(' ')
      .where((term) => term.isNotEmpty)
      .toList();
  return [
    for (final summary in summaries)
      if ((category == null || summary.category == category) &&
          terms.every(summary.normalizedName.contains))
        summary,
  ];
}

class GraphsPage extends StatefulWidget {
  final TabController tabController;

  const GraphsPage({super.key, required this.tabController});

  @override
  createState() => GraphsPageState();
}

class GraphsPageState extends State<GraphsPage>
    with AutomaticKeepAliveClientMixin {
  late final Stream<List<GraphExerciseSummary>> _stream = watchGraphs();

  GraphExerciseSummary? _peekSummary;
  Future<List<dynamic>>? _peekFuture;

  Future<List<dynamic>> _peekData(GraphExerciseSummary summary) {
    if (!identical(_peekSummary, summary)) {
      _peekSummary = summary;
      _peekFuture = summary.bodyWeight
          ? getBodyWeightData(
              target: summary.unit,
              period: Period.day,
              start: null,
              end: null,
              limit: 20,
            )
          : summary.cardio
          ? getCardioData(
              name: summary.name,
              target: summary.unit,
              metric: _isWeightUnit(summary.unit)
                  ? CardioMetric.weight
                  : CardioMetric.pace,
            )
          : getStrengthData(
              target: summary.unit,
              name: summary.name,
              metric: StrengthMetric.bestWeight,
              period: Period.day,
              start: null,
              end: null,
              limit: 20,
            );
    }
    return _peekFuture!;
  }

  final _selection = SelectionController<String>();
  final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  String _search = '';
  String? _category;
  final _scroll = ScrollController();
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
        final settings = context.read<Setting>();
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
    final keys = Set<String>.of(_selection.selected);
    final summaries = filterGraphSummariesBySelection(
      await _stream.first,
      keys,
    );
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
    final keys = Set<String>.of(_selection.selected);
    final summaries = filterGraphSummariesBySelection(
      await _stream.first,
      keys,
    );
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

    return Padding(
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
    );
  }

  Widget _peekPreview(GraphExerciseSummary summary, String dateFormat) {
    return SizedBox(
      key: const Key('graphs-peek-preview'),
      height: MediaQuery.sizeOf(context).height * 0.15,
      child: FutureBuilder<List<dynamic>>(
        future: _peekData(summary),
        builder: (context, snapshot) => snapshot.data == null
            ? const SizedBox.shrink()
            : getPeek(summary, snapshot.data!, dateFormat),
      ),
    );
  }

  bool _isWeightUnit(String unit) =>
      unit == 'kg' || unit == 'lb' || unit == 'stone';

  Scaffold graphsPage() {
    final desktop = isDesktopLayout(context);
    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
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

            final exerciseSets = filterGraphSummaries(
              snapshot.data!,
              _search,
              _category,
            );
            applyGraphSortToNewestFirstSummaries(exerciseSets, _sort);
            return Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    children: [
                      Selector<Setting, bool>(
                        selector: (context, settings) =>
                            settings.showGlobalProgress,
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
          : AppFab(
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
    final copy = Set<String>.of(_selection.selected);
    setState(() {
      _selection.clear();
    });
    final sets = filterGraphSummariesBySelection(await _stream.first, copy);
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
    final settings = context.read<Setting>();
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
            child: Consumer<Setting>(
              builder: (BuildContext context, Setting settings, Widget? child) {
                if (!settings.peekGraph || exerciseSets.firstOrNull == null) {
                  return const SizedBox();
                }
                return _peekPreview(
                  exerciseSets.first,
                  settings.shortDateFormat,
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

    final settings = context.read<Setting>();
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
          return Consumer<Setting>(
            builder: (BuildContext context, Setting settings, Widget? child) {
              if (!settings.peekGraph) return const SizedBox();
              if (exerciseSets.firstOrNull == null) return const SizedBox();

              return _peekPreview(exerciseSets.first, settings.shortDateFormat);
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
