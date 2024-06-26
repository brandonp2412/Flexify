import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../integration_test/screenshot_test.dart';

mockTests({bool insert = true}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  timerChannel = const MethodChannel("com.presley.flexify/timer");
  db = AppDatabase(executor: NativeDatabase.memory());

  if (!insert) return;
  await db.delete(db.gymSets).go();
  await db.delete(db.plans).go();

  exercisesToPopulateTestDB.forEach(
    (key, value) async => await db.into(db.gymSets).insert(
          generateGymSetCompanion(key, value),
        ),
  );

  for (final element in graphData) {
    await db.into(db.gymSets).insert(
          generateGymSetCompanion(
            "Dumbbell shoulder press",
            element.weight,
            reps: element.reps,
            date: element.dateTime,
          ),
        );
  }

  for (var element in plans) {
    await db.into(db.plans).insert(element);
  }
}
