import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database.dart';
import 'package:flexify/main.dart' as app;
import 'package:flexify/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, double> exercisesToPopulateTestDB = {
  "Barbell bench press": 90,
  "Barbell bent-over row": 82.5,
  "Barbell biceps curl": 45,
  "Barbell shoulder press": 50,
  "Chin-up": 20,
  "Crunch": 25,
  "Dumbbell bicep curls": 30,
  "Dumbbell chest press": 55,
  "Dumbbell lateral raise": 10,
  "Dumbbell shoulder press": 40,
};

class SetInfo {
  final DateTime dateTime;
  final double reps;
  final double weight;

  SetInfo(int days, this.reps, this.weight)
      : dateTime = DateTime.now()
            .subtract(
              Duration(days: days),
            )
            .copyWith(hour: 12);
}

List<SetInfo> graphData = [
  SetInfo(0, 8, 1),
  SetInfo(0, 6, 5),
  SetInfo(0, 6, 6.25),
  SetInfo(4, 8, 1),
  SetInfo(4, 6, 2.5),
  SetInfo(4, 6, 5),
  SetInfo(4, 6, 5),
  SetInfo(4, 6, 5),
  SetInfo(8, 6, 5),
  SetInfo(8, 6, 4),
  SetInfo(8, 6, 10),
  SetInfo(12, 6, 5),
  SetInfo(16, 6, 1),
  SetInfo(20, 6, 5),
  SetInfo(24, 6, 1),
  SetInfo(28, 6, 1),
  SetInfo(32, 6, 1),
  SetInfo(36, 6, 1),
];

List<PlansCompanion> plans = [
  PlansCompanion(
    days: Value([weekdays[1], weekdays[5]].join(",")),
    exercises: Value(
        ["Triceps dip", " Squat", "Standing calf raise", "Pull-up"].join(",")),
    title: const Value("Tuesday, Saturday"),
  ),
  PlansCompanion(
    days: Value([weekdays[2], weekdays[6]].join(",")),
    exercises: Value([
      "Barbell bench press",
      "Barbell bent-over row",
      "Dumbbell lateral raise",
      "Barbell biceps curl"
    ].join(",")),
    title: const Value("Wednesday, Sunday"),
  ),
  PlansCompanion(
    days: Value(weekdays[0]),
    exercises: Value([
      "Barbell shoulder press",
      "Crunch",
      "Chin-up",
      "Romanian deadlift"
    ].join(",")),
    title: const Value("Monday"),
  ),
  PlansCompanion(
    days: Value(weekdays[3]),
    exercises: Value([
      "Barbell shoulder press",
      "Neck curl",
      "Chin-up",
      "Romanian deadlift"
    ].join(",")),
    title: const Value("Thursday"),
  ),
];

Future<void> appWrapper() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsState = SettingsState();
  await settingsState.init();
  settingsState.setTheme(ThemeMode.dark);
  runApp(app.appProviders(settingsState));
}

Future<void> generateScreenshot({
  required IntegrationTestWidgetsFlutterBinding binding,
  required WidgetTester tester,
  required String screenshotName,
  bool skipSettle = false,
  Future<void> Function()? navigateToPage,
}) async {
  await appWrapper();
  await tester.pump();
  if (navigateToPage != null) await navigateToPage();
  await binding.convertFlutterSurfaceToImage();
  if (!skipSettle)
    await tester.pumpAndSettle();
  else
    await tester.pump();
  await binding.takeScreenshot(screenshotName);
}

GymSetsCompanion generateGymSetCompanion(String exercise, double weight,
        {double reps = 12, DateTime? date}) =>
    GymSetsCompanion.insert(
      name: exercise,
      reps: reps,
      weight: weight,
      unit: "kg",
      created: date ?? DateTime.now(),
    );

Future<void> navigateToGraphPage(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.insights));
  await tester.pumpAndSettle();
}

Future<void> navigateToDumbbell(WidgetTester tester) async {
  await tester.dragUntilVisible(find.text("Dumbbell shoulder press"),
      find.byType(ListView), const Offset(0, 10));
  await tester.pump();
  await tester.tap(find.widgetWithText(ListTile, "Dumbbell shoulder press"));
  await tester.pumpAndSettle();
}

Future<void> navigateToViewGraphPage(WidgetTester tester) async {
  await navigateToGraphPage(tester);
  await tester.pumpAndSettle();
  await navigateToDumbbell(tester);
}

void main() {
  IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const deviceType = String.fromEnvironment("FLEXIFY_DEVICE_TYPE");
  if (deviceType.isEmpty)
    throw "FLEXIFY_DEVICE_TYPE must be set, so integration test knows what screenshots to take";

  setUpAll(() async {
    app.db = AppDatabase();
    app.android = const MethodChannel("com.presley.flexify/android");
    IntegrationTestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(app.android, (message) => null);

    await app.db.delete(app.db.gymSets).go();
    await app.db.delete(app.db.plans).go();

    exercisesToPopulateTestDB.forEach(
      (key, value) async => await app.db.into(app.db.gymSets).insert(
            generateGymSetCompanion(key, value),
          ),
    );

    for (final element in graphData) {
      await app.db.into(app.db.gymSets).insert(
            generateGymSetCompanion("Dumbbell shoulder press", element.weight,
                reps: element.reps, date: element.dateTime),
          );
    }

    for (var element in plans) {
      await app.db.into(app.db.plans).insert(element);
    }

    SharedPreferences.setMockInitialValues({
      "themeMode": "ThemeMode.system",
      "showReorder": true,
      "resetTimers": true,
      "showUnits": true,
      "dateFormat": "yyyy-MM-dd h:mm a",
      "timerDuration": const Duration(minutes: 3, seconds: 30).inMilliseconds,
    });
  });

  group("Generate default screenshots ", () {
    testWidgets(
      "PlanPage",
      (tester) async => await generateScreenshot(
          binding: binding, tester: tester, screenshotName: '1_en-US'),
    );
    testWidgets(
      "GraphPage",
      (tester) async => await generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '2_en-US',
        navigateToPage: () async => await navigateToGraphPage(tester),
      ),
    );
    testWidgets(
      "SettingsPage",
      (tester) async => await generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '3_en-US',
        navigateToPage: () async {
          await tester.tap(
            find.byIcon(Icons.more_vert),
          );
          await tester.pumpAndSettle();
          await tester.tap(
            find.byIcon(Icons.settings),
          );
        },
      ),
    );
    testWidgets(
      "StartPlanPage",
      (tester) async => await generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '4_en-US',
        navigateToPage: () async {
          await tester.pumpAndSettle();
          await tester.tap(
            find.widgetWithText(
              ListTile,
              plans.first.exercises.value.split(",").join(", "),
            ),
          );
        },
      ),
    );
  });

  group("Generate extra screenshots", () {
    testWidgets(
      "ViewGraphPage",
      (tester) async => await generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '5_en-US',
        navigateToPage: () async => await navigateToViewGraphPage(tester),
      ),
    );
    testWidgets(
      "GraphHistory",
      (tester) async => await generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '6_en-US',
        navigateToPage: () async {
          await navigateToViewGraphPage(tester);
          await tester.pump();
          await tester.tap(find.byIcon(Icons.history));
        },
      ),
    );
    testWidgets(
      "EditPlanPage",
      (tester) async => await generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '7_en-US',
        navigateToPage: () async {
          await tester.tap(find.byIcon(Icons.add));
        },
      ),
    );
    testWidgets(
      "TimerPage",
      (tester) async => await generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '8_en-US',
        skipSettle: true,
        navigateToPage: () async {
          await tester.tap(find.byIcon(Icons.timer_outlined));
          await tester.pumpAndSettle();
          await tester.tap(find.text("+1 min"));
          await tester.pump(const Duration(seconds: 6));
        },
      ),
    );
  });
}
