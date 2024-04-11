import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';

class PlanState extends ChangeNotifier {
  List<Plan> plans = [];

  PlanState() {
    updatePlans(null);
  }

  Future<void> updatePlans(List<Plan>? newPlans) async {
    if (newPlans != null)
      plans = newPlans;
    else
      plans = await _getPlans();
    notifyListeners();
  }

  Future<List<Plan>> _getPlans() async => await (db.select(db.plans)
        ..orderBy([
          (u) => OrderingTerm(expression: u.sequence),
        ]))
      .get();
}
