import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/sets/history_list.dart';
import 'package:flutter/material.dart';

class ViewGraphPage extends StatefulWidget {
  final String name;

  const ViewGraphPage({super.key, required this.name});

  @override
  createState() => _ViewGraphPageState();
}

class _ViewGraphPageState extends State<ViewGraphPage> {
  late Stream<List<GymSet>> stream;
  int limit = 20;

  @override
  void initState() {
    super.initState();
    setStream();
  }

  void setStream() {
    setState(() {
      stream = (db.gymSets.select()
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
          .watch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          if (snapshot.data?.isEmpty == true)
            return ListTile(
              title: Text("No data yet for ${widget.name}"),
              subtitle: const Text("Enter some data to view graphs here"),
              contentPadding: EdgeInsets.zero,
            );
          if (snapshot.hasError) return ErrorWidget(snapshot.error.toString());

          return HistoryList(
            gymSets: snapshot.data!,
            onSelect: (_) {},
            selected: const {},
            onNext: () {
              setState(() {
                limit += 10;
              });
              setStream();
            },
          );
        },
      ),
    );
  }
}
