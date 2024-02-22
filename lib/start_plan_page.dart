import 'package:flutter/material.dart';
import 'package:flexify/database.dart';

class StartPlanPage extends StatefulWidget {
  final Plan plan;

  const StartPlanPage({Key? key, required this.plan}) : super(key: key);

  @override
  _StartPlanPageState createState() => _StartPlanPageState();
}

class _StartPlanPageState extends State<StartPlanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Plan'),
      ),
      body: Center(
        child: Text('Starting plan: ${widget.plan.exercises}'),
      ),
    );
  }
}
