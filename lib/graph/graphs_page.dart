import 'package:drift/drift.dart' hide Column;
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/animated_fab.dart';
import 'package:flexify/app_search.dart';
import 'package:flexify/selection_controller.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/graph/add_exercise_page.dart';
import 'package:flexify/graph/cardio_data.dart';
import 'package:flexify/graph/edit_graph_page.dart';
import 'package:flexify/graph/flex_line.dart';
import 'package:flexify/graph/global_progress_page.dart';
import 'package:flexify/graphs_filters.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  late final Stream<List<GymSetsCompanion>> stream = watchGraphs();

  final _selection = SelectionController<String>();
  final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  String search = '';
  String? category;
  final scroll = ScrollController();
  bool extendFab = true;
  int total = 0;
  GraphSort sort = GraphSort.dateDesc;

  @override
  bool get wantKeepAlive => true;

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
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => graphsPage(),
          settings: settings,
        ),
      ),
    );
  }

  void onDelete() async {
    final state = context.read<PlanState>();
    final copy = _selection.toList();
    setState(() {
      _selection.clear();
    });

    await (db.delete(db.gymSets)..where((tbl) => tbl.name.isIn(copy))).go();
    await (db.delete(db.planExercises)..where((x) => x.exercise.isIn(copy)))
        .go();
    state.updatePlans(null);
  }

  LineTouchTooltipData tooltipData(
    List<dynamic> data,
    String unit,
    String format,
  ) {
    return LineTouchTooltipData(
      getTooltipColor: (touch) => Theme.of(context).colorScheme.surface,
      getTooltipItems: (touchedSpots) {
        final row = data.elementAt(touchedSpots.last.spotIndex);
        final created = DateFormat(format).format(row.created);

        String text;
        if (row is CardioData)
          text = "${row.value} ${row.unit} / min";
        else
          text = "${row.reps} x ${row.value.toStringAsFixed(2)}$unit $created";

        return [
          LineTooltipItem(
            text,
            TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
          ),
          if (touchedSpots.length > 1) null,
        ];
      },
    );
  }

  Widget getPeek(GymSetsCompanion gymSet, List<dynamic> data, String format) {
    List<FlSpot> spots = [];
    for (var index = 0; index < data.length; index++) {
      spots.add(FlSpot(index.toDouble(), data[index].value));
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: Padding(
        padding: const EdgeInsets.only(right: 48.0, top: 16.0, left: 48.0),
        child: FlexLine(
          data: data,
          spots: spots,
          tooltipData: () => tooltipData(
            data,
            gymSet.unit.value,
            format,
          ),
          hideBottom: true,
          hideLeft: true,
        ),
      ),
    );
  }

  Scaffold graphsPage() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return ErrorWidget(snapshot.error.toString());
          if (!snapshot.hasData) return const SizedBox();

          final terms =
              search.toLowerCase().split(" ").where((term) => term.isNotEmpty);
          var stream = snapshot.data!.where((gymSet) {
            if (category != null) {
              return gymSet.category.value == category;
            }
            return true;
          });

          for (final term in terms) {
            stream = stream.where(
              (gymSet) => gymSet.name.value.toLowerCase().contains(term),
            );
          }

          final gymSets = stream.toList();
          switch (sort) {
            case GraphSort.dateDesc:
              gymSets.sort(
                (a, b) => b.created.value.compareTo(a.created.value),
              );
              break;

            case GraphSort.dateAsc:
              gymSets.sort(
                (a, b) => a.created.value.compareTo(b.created.value),
              );
              break;

            case GraphSort.name:
              gymSets.sort(
                (a, b) => a.name.value.toLowerCase().compareTo(
                      b.name.value.toLowerCase(),
                    ),
              );
              break;
          }
          return Column(
            children: [
              AppSearch(
                controller: _selection,
                filter: GraphsFilters(
                  category: category,
                  setCategory: (value) {
                    setState(() {
                      category = value;
                    });
                  },
                  sort: sort,
                  setSort: (value) {
                    setState(() {
                      sort = value;
                    });
                  },
                ),
                onShare: onShare,
                onChange: (value) {
                  setState(() {
                    search = value;
                  });
                },
                onDelete: () async => onDelete(),
                onSelectAll: () => setState(() {
                  _selection.setAll(
                    gymSets.map((gymSet) => gymSet.name.value),
                  );
                }),
                onEdit: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditGraphPage(
                      name: _selection.first,
                    ),
                  ),
                ),
                confirmText: "This will delete $total records. Are you sure?",
              ),
              if (gymSets.isEmpty &&
                  !'global progress'.contains(search.toLowerCase()))
                ListTile(
                  title: const Text("No graphs found"),
                  subtitle: Text(
                    "Tap to create an exercise called $search",
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddExercisePage(
                          name: search,
                        ),
                      ),
                    );
                  },
                ),
              Selector<SettingsState, bool>(
                selector: (p0, settingsState) =>
                    settingsState.value.showGlobalProgress,
                builder: (context, showGlobal, child) => Expanded(
                  child: graphList(gymSets, showGlobal),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: AnimatedFab(
        onPressed: () => navKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => const AddExercisePage(),
          ),
        ),
        label: Text('Add'),
        scroll: scroll,
        icon: Icon(Icons.add),
      ),
    );
  }

  Future<void> onShare() async {
    final copy = _selection.toList();
    setState(() {
      _selection.clear();
    });
    final sets = (await stream.first)
        .where(
          (gymSet) => copy.contains(gymSet.name.value),
        )
        .toList();
    final text = sets
        .map(
          (gymSet) =>
              "${toString(gymSet.reps.value)}x${toString(gymSet.weight.value)}${gymSet.unit.value} ${gymSet.name.value}",
        )
        .join(', ');
    await SharePlus.instance.share(ShareParams(text: "I just did $text"));
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
                title: const Text('Hide global progress'),
                onTap: () {
                  db.settings.update().write(
                        const SettingsCompanion(
                          showGlobalProgress: Value(false),
                        ),
                      );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.clear),
                title: const Text('Cancel'),
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

  ListView graphList(
    List<GymSetsCompanion> gymSets,
    bool showGlobalProgress,
  ) {
    var itemCount = gymSets.length + 1;
    final showGlobal = 'global graphs'.contains(search.toLowerCase()) &&
        category == null &&
        showGlobalProgress;
    if (showGlobal) itemCount++;

    final settings = context.read<SettingsState>().value;
    final showPeekGraph = settings.peekGraph && gymSets.firstOrNull != null;
    if (showPeekGraph) itemCount++;

    return ListView.builder(
      itemCount: itemCount,
      controller: scroll,
      padding: const EdgeInsets.only(bottom: 50, top: 8),
      itemBuilder: (context, index) {
        int currentIdx = index;

        if (showGlobal) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
              child: ListTile(
                leading: const Icon(Icons.language),
                title: const Text("Global progress"),
                subtitle: const Text("A chart grouped by category"),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const GlobalProgressPage(),
                  ),
                ),
                onLongPress: longPressGlobal,
              ),
            );
          }
          currentIdx--;
        }

        if (showPeekGraph && currentIdx == 1) {
          return Consumer<SettingsState>(
            builder: (
              BuildContext context,
              SettingsState settings,
              Widget? child,
            ) {
              if (!settings.value.peekGraph) return const SizedBox();
              if (gymSets.firstOrNull == null) return const SizedBox();

              return FutureBuilder(
                builder: (context, snapshot) => snapshot.data != null
                    ? getPeek(
                        gymSets.first,
                        snapshot.data!,
                        settings.value.shortDateFormat,
                      )
                    : const SizedBox(),
                future: gymSets.first.cardio.value
                    ? getCardioData(name: gymSets.first.name.value)
                    : getStrengthData(
                        target: gymSets.first.unit.value,
                        name: gymSets.first.name.value,
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

        if (index == itemCount - 1) return const SizedBox(height: 96);

        if (showPeekGraph && currentIdx > 1) {
          currentIdx--;
        }

        final set = gymSets.elementAtOrNull(currentIdx);
        if (set == null) return const SizedBox();

        final prev = currentIdx > 0 ? gymSets[currentIdx - 1] : null;

        final created = prev?.created.value.toLocal();

        final divider = sort != GraphSort.name &&
            created != null &&
            !isSameDay(created, set.created.value);

        final dividerHighlighted = divider &&
            _selection.selected.contains(set.name.value) &&
            _selection.selected.contains(prev!.name.value);

        return Column(
          children: [
            if (divider)
              Container(
                color: dividerHighlighted
                    ? Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: .18)
                    : Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Expanded(child: Divider()),
                      const Icon(Icons.today),
                      const SizedBox(width: 4),
                      Selector<SettingsState, String>(
                        selector: (p0, p1) => p1.value.shortDateFormat,
                        builder: (context, format, child) =>
                            Text(DateFormat(format).format(created)),
                      ),
                      const SizedBox(width: 4),
                      const Expanded(child: Divider()),
                    ],
                  ),
                ),
              ),
            GraphTile(
              selected: _selection.selected,
              gymSet: set,
              onSelect: (name) async {
                setState(() {
                  _selection.toggle(name);
                });
                final result = await (db.gymSets.selectOnly()
                      ..addColumns([db.gymSets.name.count()])
                      ..where(db.gymSets.name.isIn(_selection.selected)))
                    .getSingle();
                setState(() {
                  total = result.read(db.gymSets.name.count()) ?? 0;
                });
              },
              tabCtrl: widget.tabController,
            ),
          ],
        );
      },
    );
  }
}
