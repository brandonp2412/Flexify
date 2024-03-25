import 'dart:async';

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

import 'plan_tile.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return NavigatorPopHandler(
      onPop: () {
        if (navigatorKey.currentState!.canPop() == false) return;
        navigatorKey.currentState!.pop();
      },
      child: Navigator(
        key: navigatorKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => _PlansPageWidget(
            navigatorKey: navigatorKey,
          ),
          settings: settings,
        ),
      ),
    );
  }
}

class _PlansPageWidget extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const _PlansPageWidget({required this.navigatorKey});

  @override
  createState() => _PlansPageWidgetState();
}

class _PlansPageWidgetState extends State<_PlansPageWidget> {
  late Stream<List<drift.TypedResult>> countStream;
  StreamController<List<Plan>?> planStreamController = StreamController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    updatePlans();
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    final startOfTomorrow = startOfToday.add(const Duration(days: 1));
    countStream = (db.selectOnly(db.gymSets)
          ..addColumns([
            db.gymSets.name.count(),
            db.gymSets.name,
          ])
          ..where(db.gymSets.created.isBiggerOrEqualValue(startOfToday))
          ..where(db.gymSets.created.isSmallerThanValue(startOfTomorrow))
          ..where(db.gymSets.hidden.equals(false))
          ..groupBy([db.gymSets.name]))
        .watch();
  }

  Future<void> updatePlans({List<Plan>? plans}) async {
    if (plans != null)
      planStreamController.add(plans);
    else
      planStreamController.add(await getPlans());
  }

  Future<List<Plan>?> getPlans() async => await (db.select(db.plans)
        ..orderBy([
          (u) => drift.OrderingTerm(expression: u.sequence),
        ]))
      .get();

  @override
  Widget build(BuildContext context) {
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
                        ],
                      )
                    ],
            ),
          ),
          _PlanWidget(
            plans: planStreamController.stream,
            searchText: searchController.text,
            countStream: countStream,
            updatePlans: updatePlans,
            navigatorKey: widget.navigatorKey,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditPlanPage(
                plan: PlansCompanion(
                  days: drift.Value(''),
                  exercises: drift.Value(''),
                ),
              ),
            ),
          );
          await updatePlans();
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
            MaterialPageRoute(builder: (context) => const TimerPage()),
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
}

class _PlanWidget extends StatelessWidget {
  final String searchText;
  final Stream<List<Plan>?> plans;
  final Future<void> Function({List<Plan>? plans}) updatePlans;
  final GlobalKey<NavigatorState> navigatorKey;
  final Stream<List<drift.TypedResult>> countStream;

  const _PlanWidget({
    required this.plans,
    required this.searchText,
    required this.countStream,
    required this.updatePlans,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Plan>?>(
      stream: plans,
      builder: (context, snapshot) {
        if (snapshot.data?.isEmpty == true)
          return const ListTile(
            title: Text("No plans yet."),
            subtitle:
                Text("Tap the plus button in the bottom right to add plans."),
          );
        if (!snapshot.hasData || snapshot.data == null) return const SizedBox();

        final plans = snapshot.data!;
        final weekday = weekdays[DateTime.now().weekday - 1];
        final filtered = plans
            .where((element) =>
                element.days.toLowerCase().contains(searchText) ||
                element.exercises.toLowerCase().contains(searchText))
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
            onReorder: (int oldIndex, int newIndex) async {
              if (oldIndex < newIndex) {
                newIndex--;
              }

              final temp = plans[oldIndex];
              plans.removeAt(oldIndex);
              plans.insert(newIndex, temp);

              await updatePlans(plans: plans);
              await db.transaction(() async {
                for (int i = 0; i < plans.length; i++) {
                  final plan = plans[i];
                  final updatedPlan = plan
                      .toCompanion(false)
                      .copyWith(sequence: drift.Value(i));
                  await db.update(db.plans).replace(updatedPlan);
                }
              });
            },
          ),
        );
      },
    );
  }
}
