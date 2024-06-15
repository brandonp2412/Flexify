import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/history_list.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';

class ViewGraph extends StatefulWidget {
  final String name;

  const ViewGraph({super.key, required this.name});

  @override
  createState() => _ViewGraphState();
}

class _ViewGraphState extends State<ViewGraph> {
  late Stream<List<GymSet>> _stream;
  int _limit = 20;

  @override
  void initState() {
    super.initState();
    _setStream();
  }

  void _setStream() {
    setState(() {
      _stream = (db.gymSets.select()
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
            ..limit(_limit))
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
        stream: _stream,
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
                _limit += 10;
              });
              _setStream();
            },
          );
        },
      ),
    );
  }
}
