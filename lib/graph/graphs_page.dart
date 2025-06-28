import 'package:drift/drift.dart' as drift;
import 'package:drift/drift.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/animated_fab.dart';
import 'package:flexify/app_search.dart';
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
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'graph_tile.dart';

class GraphsPage extends StatefulWidget {
  const GraphsPage({super.key});

  @override
  createState() => GraphsPageState();
}

class GraphsPageState extends State<GraphsPage>
    with AutomaticKeepAliveClientMixin {
  late final Stream<List<GymSetsCompanion>> stream = watchGraphs();

  final Set<String> selected = {};
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  String search = '';
  String? category;
  final scroll = ScrollController();
  bool extendFab = true;
  int total = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NavigatorPopHandler(
      onPopWithResult: (result) {
        if (navigatorKey.currentState!.canPop() == false) return;
        final tabController = DefaultTabController.of(context);
        final settings = context.read<SettingsState>().value;
        final graphsIndex = settings.tabs.split(',').indexOf('GraphsPage');
        if (tabController.index == graphsIndex)
          navigatorKey.currentState!.pop();
      },
      child: Navigator(
        key: navigatorKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => graphsPage(),
          settings: settings,
        ),
      ),
    );
  }

  void onDelete() async {
    final planState = context.read<PlanState>();
    final selectedCopy = selected.toList();
    setState(() {
      selected.clear();
    });

    await (db.delete(db.gymSets)..where((tbl) => tbl.name.isIn(selectedCopy)))
        .go();

    final plans = await db.plans.select().get();
    for (final plan in plans) {
      final exercises = plan.exercises.split(',');
      exercises.removeWhere(
        (exercise) => selectedCopy.contains(exercise),
      );
      final updatedExercises = exercises.join(',');
      await db
          .update(db.plans)
          .replace(plan.copyWith(exercises: updatedExercises));
    }
    planState.updatePlans(null);
  }

  LineTouchTooltipData tooltipData(
    List<dynamic> data,
    String unit,
    String format,
  ) {
    return LineTouchTooltipData(
      getTooltipColor: (touch) => Theme.of(context).colorScheme.surface,
      getTooltipItems: (touchedSpots) {
        final row = data.elementAt(touchedSpots.first.spotIndex);
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
        ];
      },
    );
  }

  Widget getPeek(GymSetsCompanion gymSet, List<dynamic> data, String format) {
    List<FlSpot> spots = [];
    for (var index = 0; index < data.length; index++) {
      spots.add(FlSpot(index.toDouble(), data[index].value));
    }

    return material.SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: material.Padding(
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
      body: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          if (snapshot.hasError) return ErrorWidget(snapshot.error.toString());

          final searchTerms = search.toLowerCase().split(" ")
            .where((term) => !term.isEmpty);
          var snapshotStream = snapshot.data!
            .where((gymSet) {
              if (category != null) {
                return gymSet.category.value == category;
              }
              return true;
            });

          for (final term in searchTerms) {
            snapshotStream = snapshotStream
              .where((gymSet) => gymSet.name.value.contains(term));
          }

          final gymSets = snapshotStream.toList();

          return material.Column(
            children: [
              AppSearch(
                filter: GraphsFilters(
                  category: category,
                  setCategory: (value) {
                    setState(() {
                      category = value;
                    });
                  },
                ),
                onShare: onShare,
                onChange: (value) {
                  setState(() {
                    search = value;
                  });
                },
                onClear: () => setState(() {
                  selected.clear();
                }),
                onDelete: onDelete,
                onSelect: () => setState(() {
                  selected.addAll(
                    gymSets.map((gymSet) => gymSet.name.value),
                  );
                }),
                selected: selected,
                onEdit: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditGraphPage(
                      name: selected.first,
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
              Consumer<SettingsState>(
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
                            targetUnit: gymSets.first.unit.value,
                            name: gymSets.first.name.value,
                            metric: StrengthMetric.bestWeight,
                            period: Period.day,
                            startDate: null,
                            endDate: null,
                            limit: 21,
                          ),
                  );
                },
              ),
              Selector<SettingsState, bool>(
                selector: (p0, settingsState) =>
                    settingsState.value.showGlobalProgress,
                builder: (context, value, child) => Expanded(
                  child: graphList(gymSets, value),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: AnimatedFab(
        onTap: () => navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => const AddExercisePage(),
          ),
        ),
        label: 'Add',
        scroll: scroll,
        icon: Icons.add,
      ),
    );
  }

  onShare() async {
    final selCopy = selected.toList();
    setState(() {
      selected.clear();
    });
    final gymSets = (await stream.first)
        .where(
          (gymSet) => selCopy.contains(gymSet.name.value),
        )
        .toList();
    final summaries = gymSets
        .map(
          (gymSet) =>
              "${toString(gymSet.reps.value)}x${toString(gymSet.weight.value)}${gymSet.unit.value} ${gymSet.name.value}",
        )
        .join(', ');
    await Share.share("I just did $summaries");
  }

  void longPressGlobal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.visibility_off),
              title: Text('Hide global progress'),
              onTap: () {
                db.settings.update().write(
                      SettingsCompanion(
                        showGlobalProgress: Value(false),
                      ),
                    );
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.clear),
              title: Text('Cancel'),
              onTap: () {
                Navigator.pop(context);
                // Add logic to show info
              },
            ),
          ],
        );
      },
    );
  }

  material.ListView graphList(
    List<GymSetsCompanion> gymSets,
    bool showGlobalProgress,
  ) {
    var itemCount = gymSets.length;
    final showGlobal = 'global graphs'.contains(search.toLowerCase()) &&
        category == null &&
        showGlobalProgress;
    if (showGlobal) itemCount++;

    return ListView.builder(
      itemCount: itemCount,
      controller: scroll,
      padding: const EdgeInsets.only(bottom: 50, top: 8),
      itemBuilder: (context, index) {
        if (index == 0 && showGlobal)
          return ListTile(
            leading: Icon(Icons.language),
            title: Text("Global progress"),
            subtitle: Text("A chart grouped by category"),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => GlobalProgressPage(),
              ),
            ),
            onLongPress: longPressGlobal,
          );
        if (showGlobal) index--;

        final gymSet = gymSets.elementAtOrNull(index);
        if (gymSet == null) return SizedBox();

        final previousGymSet = index > 0 ? gymSets[index - 1] : null;

        final previousCreated = previousGymSet?.created.value.toLocal();

        final showDivider = previousCreated != null &&
            !isSameDay(previousCreated, gymSet.created.value);

        return material.Column(
          children: [
            if (showDivider)
              material.Row(
                children: [
                  material.Expanded(child: const Divider()),
                  const Icon(Icons.today),
                  const SizedBox(width: 4),
                  Selector<SettingsState, String>(
                    selector: (p0, p1) => p1.value.shortDateFormat,
                    builder: (context, format, child) =>
                        Text(DateFormat(format).format(previousCreated)),
                  ),
                  const SizedBox(width: 4),
                  material.Expanded(child: const Divider()),
                ],
              ),
            GraphTile(
              selected: selected,
              gymSet: gymSet,
              onSelect: (name) async {
                if (selected.contains(name))
                  setState(() {
                    selected.remove(name);
                  });
                else
                  setState(() {
                    selected.add(name);
                  });
                final result = await (db.gymSets.selectOnly()
                      ..addColumns([db.gymSets.name.count()])
                      ..where(db.gymSets.name.isIn(selected)))
                    .getSingle();
                setState(() {
                  total = result.read(db.gymSets.name.count()) ?? 0;
                });
              },
            ),
          ],
        );
      },
    );
  }
}
