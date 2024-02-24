import 'package:drift/drift.dart' as drift;
import 'package:flexify/constants.dart';
import 'package:flexify/database.dart';
import 'package:flexify/edit_plan_page.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';

import 'plan_tile.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({Key? key}) : super(key: key);

  @override
  createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  late Stream<List<Plan>> stream;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    stream = database.select(database.plans).watch();
  }

  @override
  Widget build(BuildContext context) {
    final weekday = weekdays[DateTime.now().weekday - 1];
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
                  : null,
            ),
          ),
          StreamBuilder<List<Plan>>(
            stream: stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              if (snapshot.hasError)
                return ErrorWidget(snapshot.error.toString());
              final plans = snapshot.data!;
              final filtered = plans
                  .where((element) =>
                      element.days
                          .toLowerCase()
                          .contains(searchController.text) ||
                      element.exercises
                          .toLowerCase()
                          .contains(searchController.text))
                  .toList();

              return Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final plan = filtered[index];
                    final active = plan.days.contains(weekday);
                    return PlanTile(plan: plan, active: active, index: index);
                  },
                ),
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const EditPlanPage(
                    plan: PlansCompanion(
                        days: drift.Value(''), exercises: drift.Value('')))),
          );
        },
        tooltip: 'Add plan',
        child: const Icon(Icons.add),
      ),
    );
  }
}
