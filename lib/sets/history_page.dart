import 'package:flexify/animated_fab.dart';
import 'package:flexify/app_search.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/body_weight_repository.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/empty_state.dart';
import 'package:flexify/filters.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/selection_controller.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/sets/edit_sets_page.dart';
import 'package:flexify/sets/group_history.dart';
import 'package:flexify/sets/history_list.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flexify/platform_page_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class HistoryDay {
  final String name;
  final List<ExerciseSetView> exerciseSets;
  final DateTime day;

  HistoryDay({
    required this.name,
    required this.exerciseSets,
    required this.day,
  });
}

class HistoryPage extends StatefulWidget {
  final TabController tabController;

  const HistoryPage({super.key, required this.tabController});

  @override
  createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NavigatorPopHandler(
      onPopWithResult: (result) {
        if (_navKey.currentState!.canPop() == false) return;
        final settings = context.read<SettingsState>().value;
        final historyIndex = settings.tabs.split(',').indexOf('HistoryPage');
        if (widget.tabController.index == historyIndex)
          _navKey.currentState!.pop();
      },
      child: Navigator(
        key: _navKey,
        onGenerateRoute: (settings) => FlexPageRoute(
          builder: (context) => _HistoryPageWidget(navigatorKey: _navKey),
          settings: settings,
        ),
      ),
    );
  }
}

class _HistoryPageWidget extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const _HistoryPageWidget({required this.navigatorKey});

  @override
  createState() => _HistoryPageWidgetState();
}

class _HistoryPageWidgetState extends State<_HistoryPageWidget> {
  late Stream<List<ExerciseSetView>> stream;

  final repsGt = TextEditingController();
  final repsLt = TextEditingController();
  final weightGt = TextEditingController();
  final weightLt = TextEditingController();
  final scroll = ScrollController();
  final _selection = SelectionController<int>();

  String search = '';
  int limit = 100;
  DateTime? startDate;
  DateTime? endDate;
  String? category;

  @override
  Widget build(BuildContext context) {
    final desktop = isDesktopLayout(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: desktop
          ? AppBar(
              title: Text(context.l10n.navHistory),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: FilledButton.icon(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add_rounded),
                    label: Text(context.l10n.addSet),
                  ),
                ),
              ],
            )
          : null,
      body: ResponsiveContent(
        maxWidth: desktopDataContentMaxWidth,
        desktopPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    children: [
                      if (snapshot.data?.isEmpty == true)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: appSearchHeight,
                            ),
                            child: AppEmptyState(
                              icon: Icons.history_rounded,
                              title: context.l10n.noEntriesYet,
                              message: context.l10n.historyEmptyMessage,
                              actionLabel: context.l10n.addSet,
                              actionIcon: Icons.add_rounded,
                              onAction: onAdd,
                            ),
                          ),
                        ),
                      if (snapshot.hasError)
                        Expanded(
                          child: ErrorWidget(context.l10n.unexpectedError),
                        ),
                      if (snapshot.hasData && snapshot.data!.isNotEmpty)
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              final groupHistory = context
                                  .select<SettingsState, bool>(
                                    (settings) => settings.value.groupHistory,
                                  );

                              if (groupHistory) {
                                final historyDays = getHistoryDays(
                                  snapshot.data!,
                                );
                                return GroupHistory(
                                  scroll: scroll,
                                  days: historyDays,
                                  onSelect: (id) {
                                    setState(() {
                                      _selection.toggle(id);
                                    });
                                  },
                                  selected: _selection.selected,
                                  onNext: () {
                                    setState(() {
                                      limit += 100;
                                    });
                                    setStream();
                                  },
                                );
                              } else
                                return HistoryList(
                                  scroll: scroll,
                                  sets: snapshot.data!,
                                  onSelect: (id) {
                                    setState(() {
                                      _selection.toggle(id);
                                    });
                                  },
                                  selected: _selection.selected,
                                  onNext: () {
                                    setState(() {
                                      limit += 100;
                                    });
                                    setStream();
                                  },
                                );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppSearch(
                    hintText: context.l10n.searchHistory,
                    controller: _selection,
                    filter: Filters(
                      repsGtCtrl: repsGt,
                      repsLtCtrl: repsLt,
                      weightGtCtrl: weightGt,
                      weightLtCtrl: weightLt,
                      setStream: () {
                        setState(() {
                          limit = 100;
                        });
                        setStream();
                      },
                      endDate: endDate,
                      startDate: startDate,
                      setEnd: (value) {
                        setState(() {
                          endDate = value;
                          limit = 100;
                        });
                        setStream();
                      },
                      setStart: (value) {
                        setState(() {
                          startDate = value;
                          limit = 100;
                        });
                        setStream();
                      },
                      category: category,
                      setCategory: (value) {
                        setState(() {
                          category = value;
                          limit = 100;
                        });
                        setStream();
                      },
                    ),
                    onShare: () async {
                      final exerciseSets = snapshot.data!
                          .where(
                            (exerciseSet) =>
                                _selection.contains(exerciseSet.id),
                          )
                          .toList();
                      final summaries = exerciseSets
                          .map(
                            (exerciseSet) =>
                                "${formatDisplayNumber(context, exerciseSet.reps)}×${formatDisplayNumber(context, exerciseSet.weight)}${displayMeasurementUnit(context.l10n, exerciseSet.unit)} ${exerciseSet.name}",
                          )
                          .join(', ');
                      await SharePlus.instance.share(
                        ShareParams(text: context.l10n.shareWorkout(summaries)),
                      );
                      if (!mounted) return;
                      setState(() {
                        _selection.clear();
                      });
                    },
                    onChange: (value) {
                      setState(() {
                        search = value;
                        limit = 100;
                      });
                      setStream();
                    },
                    onDelete: () async {
                      await deleteExerciseSets(db, _selection.selected);
                      setState(() {
                        _selection.clear();
                      });
                    },
                    onSelectAll: selectAllFiltered,
                    onEdit: () => Navigator.of(context).push(
                      FlexPageRoute(
                        builder: (context) =>
                            EditSetsPage(ids: _selection.toList()),
                      ),
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
              onPressed: onAdd,
              label: Text(context.l10n.actionAdd),
              icon: const Icon(Icons.add),
              scroll: scroll,
            ),
    );
  }

  void onAdd() async {
    final settings = context.read<SettingsState>().value;
    final exerciseSetsFuture = stream.first;
    final bodyWeightFuture = settings.showBodyWeight
        ? getBodyWeight()
        : Future<BodyWeight?>.value();
    final exerciseSets = await exerciseSetsFuture;
    final latestBodyWeight = await bodyWeightFuture;

    ExerciseSetView exerciseSet =
        exerciseSets.firstOrNull ??
        ExerciseSetView(
          id: 0,
          bodyWeight: 0,
          restMs: const Duration(minutes: 3, seconds: 30).inMilliseconds,
          name: '',
          reps: 0,
          created: DateTime.now().toLocal(),
          unit: 'kg',
          weight: 0,
          cardio: false,
          duration: 0,
          distance: 0,
        );
    exerciseSet = exerciseSet.copyWith(
      id: 0,
      bodyWeight: 0,
      created: DateTime.now().toLocal(),
    );

    if (settings.strengthUnit != 'last-entry' && !exerciseSet.cardio) {
      exerciseSet = exerciseSet.copyWith(unit: settings.strengthUnit);
    } else if (settings.cardioUnit != 'last-entry' && exerciseSet.cardio) {
      exerciseSet = exerciseSet.copyWith(unit: settings.cardioUnit);
    }

    if (latestBodyWeight != null) {
      exerciseSet = exerciseSet.copyWith(
        bodyWeight: displayBodyWeight(
          exerciseSet.unit,
          latestBodyWeight.weightKg,
        ),
      );
    }

    if (!mounted) return;
    Navigator.of(context).push(
      FlexPageRoute(
        builder: (context) => EditSetPage(exerciseSet: exerciseSet),
      ),
    );
  }

  List<HistoryDay> getHistoryDays(List<ExerciseSetView> exerciseSets) {
    final map = <String, HistoryDay>{};
    final list = <HistoryDay>[];
    for (final exerciseSet in exerciseSets) {
      final day = DateUtils.dateOnly(exerciseSet.created);
      final key = '${exerciseSet.name}|${day.millisecondsSinceEpoch}';
      final existing = map[key];
      if (existing == null) {
        final hd = HistoryDay(
          name: exerciseSet.name,
          exerciseSets: [exerciseSet],
          day: day,
        );
        map[key] = hd;
        list.add(hd);
      } else {
        existing.exerciseSets.add(exerciseSet);
      }
    }
    return list;
  }

  @override
  void dispose() {
    repsGt.dispose();
    repsLt.dispose();
    weightGt.dispose();
    weightLt.dispose();
    scroll.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setStream();
  }

  Stream<List<ExerciseSetView>> _filteredStream({int? rowLimit}) {
    return watchExerciseSets(
      db,
      search: search,
      category: category,
      startDate: startDate,
      endDate: endDate,
      repsGt: repsGt.text.isEmpty
          ? null
          : parseDisplayNumber(context, repsGt.text),
      repsLt: repsLt.text.isEmpty
          ? null
          : parseDisplayNumber(context, repsLt.text),
      weightGt: weightGt.text.isEmpty
          ? null
          : parseDisplayNumber(context, weightGt.text),
      weightLt: weightLt.text.isEmpty
          ? null
          : parseDisplayNumber(context, weightLt.text),
      limit: rowLimit,
    );
  }

  Future<List<ExerciseSetView>> _filteredSets({int? rowLimit}) {
    return getExerciseSets(
      db,
      search: search,
      category: category,
      startDate: startDate,
      endDate: endDate,
      repsGt: repsGt.text.isEmpty
          ? null
          : parseDisplayNumber(context, repsGt.text),
      repsLt: repsLt.text.isEmpty
          ? null
          : parseDisplayNumber(context, repsLt.text),
      weightGt: weightGt.text.isEmpty
          ? null
          : parseDisplayNumber(context, weightGt.text),
      weightLt: weightLt.text.isEmpty
          ? null
          : parseDisplayNumber(context, weightLt.text),
      limit: rowLimit,
    );
  }

  Future<void> selectAllFiltered() async {
    final exerciseSets = await _filteredSets();
    if (!mounted) return;
    setState(() {
      _selection.setAll(exerciseSets.map((exerciseSet) => exerciseSet.id));
    });
  }

  void setStream() {
    setState(() {
      stream = _filteredStream(rowLimit: limit);
    });
  }
}
