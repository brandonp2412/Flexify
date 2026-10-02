import 'package:drift/drift.dart' hide Column;
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_analytics.dart';
import 'package:flexify/database/performed_sets.dart';
import 'package:flexify/empty_state.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/selection_controller.dart';
import 'package:flexify/sets/edit_sets_page.dart';
import 'package:flexify/sets/history_list.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraphHistoryPage extends StatefulWidget {
  final String name;
  final List<GymSet> gymSets;
  final TabController tabController;
  final bool bodyWeight;

  const GraphHistoryPage({
    super.key,
    required this.name,
    required this.gymSets,
    required this.tabController,
    this.bodyWeight = false,
  });

  @override
  createState() => _GraphHistoryPageState();
}

class _GraphHistoryPageState extends State<GraphHistoryPage> {
  late List<GymSet> sets = widget.gymSets;
  final _selection = SelectionController<int>();
  int limit = 20;
  final scroll = ScrollController();
  late final TabController ctrl = widget.tabController;

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
            if (sets.isEmpty) {
              return AppEmptyState(
                icon: Icons.history_rounded,
                title: context.l10n.noHistoryFor(widget.name),
                message: context.l10n.completeSetsForHistory,
              );
            }

            return HistoryList(
              scroll: scroll,
              sets: sets,
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
    if (_selection.isEmpty) return AppBar(title: Text(widget.name));

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
            () => _selection.setAll(sets.map((gymSet) => gymSet.id)),
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
      MaterialPageRoute(
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
      await deletePerformedSets(db, ids);
    }
    if (!mounted) return;
    setState(_selection.clear);
    await setSets();
  }

  @override
  void dispose() {
    ctrl.removeListener(tabListener);
    scroll.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ctrl.addListener(tabListener);
  }

  Future<void> setSets() async {
    final result = widget.bodyWeight
        ? await getBodyWeightGraphHistory(limit: limit)
        : (await getPerformedSets(
            db,
            search: widget.name,
            limit: limit,
          )).where((set) => set.name == widget.name).toList();
    if (!mounted) return;
    setState(() {
      sets = result;
    });
  }

  void tabListener() {
    final settings = context.read<SettingsState>().value;
    final index = settings.tabs.split(',').indexOf('GraphsPage');
    if (ctrl.indexIsChanging == true) return;
    if (ctrl.index != index) return;
    setSets();
  }
}
