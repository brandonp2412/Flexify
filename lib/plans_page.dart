import 'package:csv/csv.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flexify/constants.dart';
import 'package:flexify/database.dart';
import 'package:flexify/edit_plan_page.dart';
import 'package:flexify/enter_weight_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/timer_page.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'plan_tile.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({Key? key}) : super(key: key);

  @override
  createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  List<Plan>? plans;
  late Stream<List<drift.TypedResult>> countStream;
  TextEditingController searchController = TextEditingController();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    updatePlans();
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    final startOfTomorrow = startOfToday.add(const Duration(days: 1));
    countStream = (database.selectOnly(database.gymSets)
          ..addColumns([
            database.gymSets.name.count(),
            database.gymSets.name,
          ])
          ..where(database.gymSets.created.isBiggerOrEqualValue(startOfToday))
          ..where(database.gymSets.created.isSmallerThanValue(startOfTomorrow))
          ..groupBy([database.gymSets.name]))
        .watch();
  }

  void updatePlans() async {
    plans = await (database.select(database.plans)
          ..orderBy([
            (u) => drift.OrderingTerm(expression: u.sequence),
          ]))
        .get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final weekday = weekdays[DateTime.now().weekday - 1];
    return NavigatorPopHandler(
      onPop: () {
        if (navigatorKey.currentState!.canPop() == false) return;
        navigatorKey.currentState!.pop();
      },
      child: Navigator(
          key: navigatorKey,
          onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => plansPage(weekday, context),
                settings: settings,
              )),
    );
  }

  Widget get plansWidget {
    final weekday = weekdays[DateTime.now().weekday - 1];
    if (plans == null) return const SizedBox();
    final filtered = plans!
        .where((element) =>
            element.days.toLowerCase().contains(searchController.text) ||
            element.exercises.toLowerCase().contains(searchController.text))
        .toList();

    return Expanded(
      child: ReorderableListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final plan = filtered[index];
          return PlanTile(
            key: Key(plan.id.toString()),
            plan: plan,
            weekday: weekday,
            index: index,
            countStream: countStream,
            navigatorKey: navigatorKey,
            refresh: updatePlans,
          );
        },
        onReorder: (int oldIndex, int newIndex) {
          if (oldIndex < newIndex) {
            newIndex--;
          }

          final temp = plans![oldIndex];
          plans!.removeAt(oldIndex);
          plans!.insert(newIndex, temp);
          setState(() {});

          database.transaction(() async {
            for (int i = 0; i < plans!.length; i++) {
              final plan = plans![i];
              final updatedPlan =
                  plan.toCompanion(false).copyWith(sequence: drift.Value(i));
              await database.update(database.plans).replace(updatedPlan);
            }
          });
        },
      ),
    );
  }

  Scaffold plansPage(String weekday, BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              hintText: "Search...",
              controller: searchController,
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onChanged: (_) {
                setState(() {});
              },
              leading: const Icon(Icons.search),
              trailing: searchController.text.isNotEmpty
                  ? [
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          setState(() {});
                        },
                      )
                    ]
                  : [
                      PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          enterWeight(context),
                          timer(context),
                          downloadCsv(context),
                          uploadCsv(context),
                          deleteAll(context),
                        ],
                      )
                    ],
            ),
          ),
          plansWidget
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const EditPlanPage(
                    plan: PlansCompanion(
                        days: drift.Value(''), exercises: drift.Value('')))),
          );
          updatePlans();
        },
        tooltip: 'Add plan',
        child: const Icon(Icons.add),
      ),
    );
  }

  PopupMenuItem<dynamic> timer(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.timer),
        title: const Text('Timer'),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TimerPage()),
          );
        },
      ),
    );
  }

  PopupMenuItem<dynamic> enterWeight(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.scale),
        title: const Text('Weight'),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EnterWeightPage()),
          );
        },
      ),
    );
  }

  PopupMenuItem<dynamic> deleteAll(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.delete),
        title: const Text('Delete all'),
        onTap: () {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirm Delete'),
                content: const Text(
                    'Are you sure you want to delete all plans? This action is not reversible.'),
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
                      Navigator.of(context).pop();
                      await database.delete(database.plans).go();
                      updatePlans();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  PopupMenuItem<dynamic> uploadCsv(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.upload),
        title: const Text('Upload CSV'),
        onTap: () async {
          Navigator.pop(context);
          String csv = await android.invokeMethod('read');
          List<List<dynamic>> rows =
              const CsvToListConverter(eol: "\n").convert(csv);
          if (rows.isEmpty) return;
          try {
            final plans = rows.map(
              (row) => PlansCompanion(
                days: drift.Value(row[1]),
                exercises: drift.Value(row[2]),
              ),
            );
            await database.batch(
              (batch) => batch.insertAll(database.plans, plans),
            );
            updatePlans();
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to upload csv.')),
            );
          }
        },
      ),
    );
  }

  PopupMenuItem<dynamic> downloadCsv(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.download),
        title: const Text('Download CSV'),
        onTap: () async {
          Navigator.pop(context);

          final plans = await database.plans.select().get();
          final List<List<dynamic>> csvData = [
            ['id', 'days', 'exercises']
          ];
          for (var plan in plans) {
            csvData.add([plan.id, plan.days, plan.exercises]);
          }

          if (!await requestNotificationPermission()) return;
          final csv = const ListToCsvConverter(eol: "\n").convert(csvData);
          android.invokeMethod('save', ['plans.csv', csv]);
        },
      ),
    );
  }
}
