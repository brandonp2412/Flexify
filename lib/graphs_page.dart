import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'graph_tile.dart';

class GraphsPage extends StatefulWidget {
  const GraphsPage({Key? key}) : super(key: key);

  @override
  createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> {
  late Stream<List<TypedResult>> stream;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    stream = (database.gymSets.selectOnly(distinct: true)
          ..addColumns([database.gymSets.name, database.gymSets.weight.max()])
          ..groupBy([database.gymSets.name]))
        .watch();
  }

  DateTime parseDate(String dateString) {
    List<String> formats = [
      'yyyy-MM-ddTHH:mm',
      'yyyy-MM-ddTHH:mm:ss.SSS',
      'yyyy-MM-ddTHH:mm:ss'
    ];

    for (String format in formats) {
      try {
        return DateFormat(format).parseStrict(dateString.replaceAll('Z', ''));
      } catch (_) {}
    }

    throw FormatException('Invalid date format: $dateString');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              icon: Icon(Icons.search),
              hintText: 'Search',
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        body: StreamBuilder<List<TypedResult>>(
          stream: stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();
            if (snapshot.hasError)
              return ErrorWidget(snapshot.error.toString());
            final gymSets = snapshot.data!;

            final filteredGymSets = gymSets.where((gymSet) {
              final name = gymSet.read(database.gymSets.name)!.toLowerCase();
              final searchText = searchController.text.toLowerCase();
              return name.contains(searchText);
            }).toList();

            return ListView.builder(
              itemCount: filteredGymSets.length,
              itemBuilder: (context, index) {
                final gymSet = filteredGymSets[index];
                final name = gymSet.read(database.gymSets.name)!;
                final weight = gymSet.read(database.gymSets.weight.max())!;
                return GraphTile(
                  gymSetName: name,
                  weight: weight,
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.upload),
                      title: const Text('Upload csv'),
                      onTap: () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.any,
                        );
                        if (result == null) return;

                        final file = File(result.files.single.path!);
                        final input = file.openRead();
                        final fields = await input
                            .transform(utf8.decoder)
                            .transform(const CsvToListConverter(eol: "\n"))
                            .skip(1)
                            .toList();
                        final gymSets = fields.map(
                          (row) => GymSetsCompanion(
                            name: Value(row[1]),
                            reps: Value(double.parse(row[2])),
                            weight: Value(double.parse(row[3])),
                            created: Value(parseDate(row[4])),
                            unit: Value(row[5]),
                          ),
                        );
                        await database.batch(
                          (batch) => batch.insertAll(database.gymSets, gymSets),
                        );
                        if (!mounted) return;
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Imported sets')),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Delete all records'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm Delete'),
                              content: const Text(
                                  'Are you sure you want to delete all records? This action is not reversible.'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Delete'),
                                  onPressed: () async {
                                    await database
                                        .delete(database.gymSets)
                                        .go();
                                    if (!mounted) return;
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
          tooltip: 'More options',
          child: const Icon(Icons.more_vert),
        ),
      ),
    );
  }
}
