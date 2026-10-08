import 'package:drift/drift.dart' hide Column;
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_analytics.dart';
import 'package:flexify/database/exercise_key.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/empty_state.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/selection_controller.dart';
import 'package:flexify/sets/edit_sets_page.dart';
import 'package:flexify/sets/history_list.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/platform_page_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraphHistoryPage extends StatefulWidget {
  final ExerciseKey exercise;
  final List<ExerciseSetView> initialSets;
  final TabController tabController;
  final bool bodyWeight;

  const GraphHistoryPage({
    super.key,
    required this.exercise,
    required this.initialSets,
    required this.tabController,
    this.bodyWeight = false,
  });

  @override
  createState() => _GraphHistoryPageState();
}

class _GraphHistoryPageState extends State<GraphHistoryPage> {
  late List<ExerciseSetView> _sets;
  final _selection = SelectionController<int>();
  int limit = 20;
  final scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selection.isEmpty,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop || _selection.isEmpty) return;
        setState(_selection.clear);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(),
        body: Builder(
          builder: (context) {
            if (_sets.isEmpty) {
              return AppEmptyState(
                icon: Icons.history_rounded,
                title: context.l10n.noHistoryFor(widget.exercise.name),
                message: context.l10n.completeSetsForHistory,
              );
            }

            return HistoryList(
              scroll: scroll,
              sets: _sets,
              onSelect: (id) => setState(() => _selection.toggle(id)),
              selected: _selection.selected,
              onNext: () {
                setState(() {
                  limit += 10;
                });
                setSets();
              },
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    if (_selection.isEmpty) return AppBar(title: Text(widget.exercise.name));

    return AppBar(
      leading: IconButton(
        key: const ValueKey('clearGraphHistorySelection'),
        tooltip: context.l10n.cancelSelection,
        icon: const Icon(Icons.close),
        onPressed: () => setState(_selection.clear),
      ),
      title: Text(context.l10n.selectedCount(_selection.length)),
      actions: [
        IconButton(
          key: const ValueKey('selectAllGraphHistory'),
          tooltip: context.l10n.selectAll,
          icon: const Icon(Icons.done_all),
          onPressed: () => setState(
            () => _selection.setAll(_sets.map((exerciseSet) => exerciseSet.id)),
          ),
        ),
        if (!widget.bodyWeight)
          IconButton(
            key: const ValueKey('editGraphHistorySelection'),
            tooltip: context.l10n.editSelected,
            icon: const Icon(Icons.edit),
            onPressed: _editSelected,
          ),
        IconButton(
          key: const ValueKey('deleteGraphHistorySelection'),
          tooltip: context.l10n.deleteSelected,
          icon: const Icon(Icons.delete),
          onPressed: _deleteSelected,
        ),
      ],
    );
  }

  Future<void> _editSelected() async {
    if (widget.bodyWeight) return;
    await Navigator.of(context).push(
      FlexPageRoute(
        builder: (context) => EditSetsPage(ids: _selection.toList()),
      ),
    );
    if (!mounted) return;
    setState(_selection.clear);
    await setSets();
  }

  Future<void> _deleteSelected() async {
    final count = _selection.length;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.confirmDelete),
        content: Text(context.l10n.deleteRecordsConfirmation(count)),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.close),
            label: Text(context.l10n.actionCancel),
            onPressed: () => Navigator.pop(dialogContext, false),
          ),
          TextButton.icon(
            icon: const Icon(Icons.delete),
            label: Text(context.l10n.actionDelete),
            onPressed: () => Navigator.pop(dialogContext, true),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final ids = _selection.toList();
    if (widget.bodyWeight) {
      await (db.bodyWeights.delete()..where((row) => row.id.isIn(ids))).go();
    } else {
      await deleteExerciseSets(db, ids);
    }
    if (!mounted) return;
    setState(_selection.clear);
    await setSets();
  }

  @override
  void didUpdateWidget(GraphHistoryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabController == widget.tabController) return;
    oldWidget.tabController.removeListener(tabListener);
    widget.tabController.addListener(tabListener);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(tabListener);
    scroll.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _sets = widget.initialSets;
    widget.tabController.addListener(tabListener);
  }

  Future<void> setSets() async {
    final result = widget.bodyWeight
        ? await getBodyWeightGraphHistory(limit: limit)
        : await getExerciseSetsForExercise(
            db,
            exercise: widget.exercise,
            limit: limit,
          );
    if (!mounted) return;
    setState(() {
      _sets = result;
    });
  }

  void tabListener() {
    final settings = context.read<SettingsState>().value;
    final index = settings.tabs.split(',').indexOf('GraphsPage');
    if (widget.tabController.indexIsChanging) return;
    if (widget.tabController.index != index) return;
    setSets();
  }
}
