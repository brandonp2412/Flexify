import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';
import 'package:drift/drift.dart';
import 'package:flexify/database.dart';
import 'package:flexify/main.dart';

class GraphHistory extends StatefulWidget {
  final String name;

  const GraphHistory({Key? key, required this.name}) : super(key: key);

  @override
  _GraphHistoryState createState() => _GraphHistoryState();
}

class _GraphHistoryState extends State<GraphHistory> {
  final ScrollController _scrollController = ScrollController();
  late Stream<List<GymSet>> stream;

  @override
  void initState() {
    super.initState();
    stream = (database.gymSets.select()
          ..orderBy(
            [
              (u) =>
                  OrderingTerm(expression: u.created, mode: OrderingMode.desc)
            ],
          )
          ..where((tbl) => tbl.name.equals(widget.name)))
        .watch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: StreamBuilder<List<GymSet>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final gymSet = snapshot.data![index];
                final previousGymSet =
                    index > 0 ? snapshot.data![index - 1] : null;

                // Check if this gym set is on a different day from the previous one
                final bool showDivider = previousGymSet != null &&
                    !isSameDay(gymSet.created, previousGymSet.created);

                return material.Column(
                  children: [
                    if (showDivider) const Divider(),
                    ListTile(
                      title: Text(gymSet.name),
                      subtitle: Text(DateFormat("yyyy-MM-dd hh:mm a")
                          .format(gymSet.created)),
                      trailing: Text(
                          "${gymSet.reps} x ${gymSet.weight} ${gymSet.unit}",
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  // Function to check if two DateTime objects represent the same day
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
