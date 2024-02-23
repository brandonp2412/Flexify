import 'package:drift/drift.dart';
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

  @override
  void initState() {
    super.initState();
    stream = database.select(database.plans).watch();
  }

  @override
  Widget build(BuildContext context) {
    final weekday = weekdays[DateTime.now().weekday - 1];
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<List<Plan>>(
          stream: stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();
            if (snapshot.hasError)
              return ErrorWidget(snapshot.error.toString());
            final plans = snapshot.data!;

            return ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                final active = plan.days.contains(weekday);
                return PlanTile(
                    plan: plan,
                    active: active,
                    plans: plans,
                    mounted: mounted,
                    index: index);
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EditPlanPage(
                      plan: PlansCompanion(
                          days: Value(''), exercises: Value('')))),
            );
          },
          tooltip: 'Add plan',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
