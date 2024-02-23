import 'package:flexify/constants.dart';
import 'package:flexify/database.dart';
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
    return StreamBuilder<List<Plan>>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        if (snapshot.hasError) return ErrorWidget(snapshot.error.toString());
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
    );
  }
}
