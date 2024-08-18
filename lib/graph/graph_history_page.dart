import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/sets/history_list.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraphHistoryPage extends StatefulWidget {
  final String name;
  final List<GymSet> gymSets;

  const GraphHistoryPage({
    super.key,
    required this.name,
    required this.gymSets,
  });

  @override
  createState() => _GraphHistoryPageState();
}

class _GraphHistoryPageState extends State<GraphHistoryPage> {
  late List<GymSet> gymSets = widget.gymSets;
  int limit = 20;
  final scroll = ScrollController();
  TabController? tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Builder(
        builder: (context) {
          if (gymSets.isEmpty)
            return ListTile(
              title: Text("No data yet for ${widget.name}"),
              subtitle: const Text("Enter some data to view graphs here"),
              contentPadding: EdgeInsets.zero,
            );

          return HistoryList(
            scroll: scroll,
            gymSets: gymSets,
            onSelect: (_) {},
            selected: const {},
            onNext: () {
              setState(() {
                limit += 10;
              });
              setGymSets();
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    tabController?.removeListener(tabListener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      tabController = DefaultTabController.of(context);
      tabController?.addListener(tabListener);
    });
  }

  void setGymSets() async {
    final newGymSets = await (db.gymSets.select()
          ..orderBy(
            [
              (u) => OrderingTerm(
                    expression: u.created,
                    mode: OrderingMode.desc,
                  ),
            ],
          )
          ..where((tbl) => tbl.name.equals(widget.name))
          ..where((tbl) => tbl.hidden.equals(false))
          ..limit(limit))
        .get();
    setState(() {
      gymSets = newGymSets;
    });
  }

  void tabListener() {
    final settings = context.read<SettingsState>().value;
    final graphsIndex = settings.tabs.split(',').indexOf('GraphsPage');
    if (tabController!.indexIsChanging == true) return;
    if (tabController!.index != graphsIndex) return;
    setGymSets();
  }
}
