import 'package:drift/native.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../integration_test/screenshot_test.dart';

mockTests() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({
    "themeMode": "ThemeMode.system",
    "showReorder": true,
    "resetTimers": true,
    "showUnits": true,
    "systemColors": false,
    "dateFormat": "yyyy-MM-dd h:mm a",
    "timerDuration": const Duration(minutes: 3, seconds: 30).inMilliseconds,
    "hideWeight": true,
    "planTrailing": PlanTrailing.count.toString(),
    "explainedPermissions": true,
  });
  prefs = await SharedPreferences.getInstance();
  android = const MethodChannel("com.presley.flexify/android");
  db = AppDatabase(executor: NativeDatabase.memory());

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
