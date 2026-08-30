import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
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

  const GraphHistoryPage({
    super.key,
    required this.name,
    required this.gymSets,
    required this.tabController,
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
              return ListTile(
                title: Text("No data yet for ${widget.name}"),
                subtitle: const Text("Enter some data to view graphs here"),
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
        tooltip: 'Cancel selection',
        icon: const Icon(Icons.close),
        onPressed: () => setState(_selection.clear),
      ),
      title: Text('${_selection.length} selected'),
      actions: [
        IconButton(
          key: const ValueKey('selectAllGraphHistory'),
          tooltip: 'Select all',
          icon: const Icon(Icons.done_all),
          onPressed: () => setState(
            () => _selection.setAll(sets.map((gymSet) => gymSet.id)),
          ),
        ),
        IconButton(
          key: const ValueKey('editGraphHistorySelection'),
          tooltip: 'Edit selected',
          icon: const Icon(Icons.edit),
          onPressed: _editSelected,
        ),
        IconButton(
          key: const ValueKey('deleteGraphHistorySelection'),
          tooltip: 'Delete selected',
          icon: const Icon(Icons.delete),
          onPressed: _deleteSelected,
        ),
      ],
    );
  }

  Future<void> _editSelected() async {
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
        title: const Text('Confirm Delete'),
        content: Text(
          'Are you sure you want to delete $count ${count == 1 ? 'record' : 'records'}? This action is not reversible.',
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.close),
            label: const Text('Cancel'),
            onPressed: () => Navigator.pop(dialogContext, false),
          ),
          TextButton.icon(
            icon: const Icon(Icons.delete),
            label: const Text('Delete'),
            onPressed: () => Navigator.pop(dialogContext, true),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final ids = _selection.toList();
    await (db.delete(db.gymSets)..where((tbl) => tbl.id.isIn(ids))).go();
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
    final result =
        await (db.gymSets.select()
              ..orderBy([
                (u) => OrderingTerm(
                  expression: u.created,
                  mode: OrderingMode.desc,
                ),
              ])
              ..where((tbl) => tbl.name.equals(widget.name))
              ..where((tbl) => tbl.hidden.equals(false))
              ..limit(limit))
            .get();
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
