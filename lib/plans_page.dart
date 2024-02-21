import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({
    super.key,
  });

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  @override
  void initState() {
    super.initState();
    getPlans();
  }

  void getPlans() async {
    WidgetsFlutterBinding.ensureInitialized();

    await database.into(database.plans).insert(PlansCompanion.insert(
        workouts: 'Bench press,Bicep curls,Rows',
        days: 'Monday,Tuesday,Wednesday'));
    final allPlans = await database.select(database.plans).get();

    print('items in database: $allPlans');
  }

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.event);
  }
}
