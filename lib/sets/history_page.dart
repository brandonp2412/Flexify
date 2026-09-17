import 'package:drift/drift.dart' hide Column;
import 'package:flexify/animated_fab.dart';
import 'package:flexify/app_search.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class HistoryDay {
  final String name;
  final List<GymSet> gymSets;
  final DateTime day;

  HistoryDay({required this.name, required this.gymSets, required this.day});
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
        onGenerateRoute: (settings) => MaterialPageRoute(
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
  late Stream<List<GymSet>> stream;

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
      body: StreamBuilder(
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
                          padding: const EdgeInsets.only(top: appSearchHeight),
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
                    final gymSets = snapshot.data!
                        .where((gymSet) => _selection.contains(gymSet.id))
                        .toList();
                    final summaries = gymSets
                        .map(
                          (gymSet) =>
                              "${formatDisplayNumber(context, gymSet.reps)}×${formatDisplayNumber(context, gymSet.weight)}${displayMeasurementUnit(context.l10n, gymSet.unit)} ${gymSet.name}",
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
                    (db.delete(
                      db.gymSets,
                    )..where((tbl) => tbl.id.isIn(_selection.selected))).go();
                    setState(() {
                      _selection.clear();
                    });
                  },
                  onSelectAll: selectAllFiltered,
                  onEdit: () => Navigator.of(context).push(
                    MaterialPageRoute(
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
    final gymSets = await stream.first;
    var bodyWeight = 0.0;
    if (settings.showBodyWeight)
      bodyWeight = (await getBodyWeight())?.weight ?? 0.0;

    GymSet gymSet =
        gymSets.firstOrNull ??
        GymSet(
          id: 0,
          bodyWeight: bodyWeight,
          restMs: const Duration(minutes: 3, seconds: 30).inMilliseconds,
          name: '',
          reps: 0,
          created: DateTime.now().toLocal(),
          unit: 'kg',
          weight: 0,
          cardio: false,
          duration: 0,
          distance: 0,
          hidden: false,
        );
    gymSet = gymSet.copyWith(
      id: 0,
      bodyWeight: bodyWeight,
      created: DateTime.now().toLocal(),
    );

    if (settings.strengthUnit != 'last-entry' && !gymSet.cardio)
      gymSet = gymSet.copyWith(unit: settings.strengthUnit);
    else if (settings.cardioUnit != 'last-entry' && gymSet.cardio)
      gymSet = gymSet.copyWith(unit: settings.cardioUnit);

    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => EditSetPage(gymSet: gymSet)),
    );
  }

  List<HistoryDay> getHistoryDays(List<GymSet> gymSets) {
    final map = <String, HistoryDay>{};
    final list = <HistoryDay>[];
    for (final gymSet in gymSets) {
      final day = DateUtils.dateOnly(gymSet.created);
      final key = '${gymSet.name}|${day.millisecondsSinceEpoch}';
      final existing = map[key];
      if (existing == null) {
        final hd = HistoryDay(name: gymSet.name, gymSets: [gymSet], day: day);
        map[key] = hd;
        list.add(hd);
      } else {
        existing.gymSets.add(gymSet);
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

  SimpleSelectStatement<$GymSetsTable, GymSet> _filteredQuery({int? rowLimit}) {
    final terms = search
        .toLowerCase()
        .split(" ")
        .where((term) => term.isNotEmpty);

    final query = db.gymSets.select()
      ..orderBy([
        (u) => OrderingTerm(expression: u.created, mode: OrderingMode.desc),
      ])
      ..where((tbl) => tbl.hidden.equals(false));

    if (rowLimit != null) query.limit(rowLimit);

    for (final term in terms) {
      query.where((tbl) => tbl.name.contains(term));
    }

    if (category != null) query.where((tbl) => tbl.category.equals(category!));
    if (startDate != null) {
      query.where((tbl) => tbl.created.isBiggerOrEqualValue(startDate!));
    }
    if (endDate != null) {
      query.where((tbl) => tbl.created.isSmallerOrEqualValue(endDate!));
    }
    if (repsGt.text.isNotEmpty) {
      query.where(
        (tbl) =>
            tbl.reps.isBiggerThanValue(
              parseDisplayNumber(context, repsGt.text) ?? 0,
            ) &
            tbl.cardio.equals(false),
      );
    }
    if (repsLt.text.isNotEmpty) {
      query.where(
        (tbl) =>
            tbl.reps.isSmallerThanValue(
              parseDisplayNumber(context, repsLt.text) ?? 0,
            ) &
            tbl.cardio.equals(false),
      );
    }
    if (weightGt.text.isNotEmpty) {
      query.where(
        (tbl) =>
            tbl.weight.isBiggerThanValue(
              parseDisplayNumber(context, weightGt.text) ?? 0,
            ) &
            tbl.cardio.equals(false),
      );
    }
    if (weightLt.text.isNotEmpty) {
      query.where(
        (tbl) =>
            tbl.weight.isSmallerThanValue(
              parseDisplayNumber(context, weightLt.text) ?? 0,
            ) &
            tbl.cardio.equals(false),
      );
    }

    return query;
  }

  Future<void> selectAllFiltered() async {
    final gymSets = await _filteredQuery().get();
    if (!mounted) return;
    setState(() {
      _selection.setAll(gymSets.map((gymSet) => gymSet.id));
    });
  }

  void setStream() {
    final query = _filteredQuery(rowLimit: limit);
    setState(() {
      stream = query.watch();
    });
  }
}
