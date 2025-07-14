import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/graph/graphs_page.dart';
import 'package:flexify/graph/strength_page.dart';
import 'package:flexify/main.dart' as app;
import 'package:flexify/main.dart';
import 'package:flexify/plan/edit_plan_page.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/plan/plans_page.dart';
import 'package:flexify/plan/start_plan_page.dart';
import 'package:flexify/sets/history_page.dart';
import 'package:flexify/settings/settings_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_page.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

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
  "Triceps dip": 20,
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
      ["Triceps dip", "Squat", "Standing calf raise", "Pull-up"].join(","),
    ),
    title: const Value("Tuesday, Saturday"),
  ),
  PlansCompanion(
    days: Value([weekdays[2], weekdays[6]].join(",")),
    exercises: Value(
      [
        "Barbell bench press",
        "Barbell bent-over row",
        "Dumbbell lateral raise",
        "Barbell biceps curl",
      ].join(","),
    ),
    title: const Value("Wednesday, Sunday"),
  ),
  PlansCompanion(
    days: Value(weekdays[0]),
    exercises: Value(
      [
        "Barbell shoulder press",
        "Crunch",
        "Chin-up",
        "Romanian deadlift",
      ].join(","),
    ),
    title: const Value("Monday"),
  ),
  PlansCompanion(
    days: Value(weekdays[3]),
    exercises: Value(
      [
        "Barbell shoulder press",
        "Neck curl",
        "Chin-up",
        "Romanian deadlift",
      ].join(","),
    ),
    title: const Value("Thursday"),
  ),
];

enum TabBarState { history, plans, graphs, timer }

const screenshotExercise = "Dumbbell shoulder press";

Future<void> appWrapper() async {
  WidgetsFlutterBinding.ensureInitialized();
  await app.db.settings.update().write(
        SettingsCompanion(
          themeMode: Value(ThemeMode.dark.toString()),
          explainedPermissions: const Value(true),
          restTimers: const Value(true),
          systemColors: const Value(false),
          curveLines: const Value(true),
        ),
      );
  final settings = await (db.settings.select()..limit(1)).getSingle();
  final settingsState = SettingsState(settings);

  runApp(app.appProviders(settingsState));
}

BuildContext getBuildContext(WidgetTester tester, TabBarState? tabBarState) {
  switch (tabBarState) {
    case TabBarState.plans:
      return (tester.state(find.byType(PlansPage)) as PlansPageState)
          .navKey
          .currentContext!;
    case TabBarState.graphs:
      return (tester.state(find.byType(GraphsPage)) as GraphsPageState)
          .navKey
          .currentContext!;
    case TabBarState.timer:
      return (tester.state(find.byType(TimerPage)) as TimerPageState).context;
    case TabBarState.history:
      return (tester.state(find.byType(HistoryPage)) as HistoryPageState)
          .context;
    case null:
      break;
  }

  return tester.element(find.byType(TabBarView));
}

void navigateTo({required BuildContext context, required Widget page}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

Future<void> generateScreenshot({
  required IntegrationTestWidgetsFlutterBinding binding,
  required WidgetTester tester,
  required String screenshotName,
  required TabBarState tabBarState,
  Future<void> Function(BuildContext context)? navigateToPage,
  bool skipSettle = false,
}) async {
  await appWrapper();
  await tester.pumpAndSettle();

  final controllerState = getBuildContext(tester, null);
  DefaultTabController.of(controllerState).index = tabBarState.index;
  await tester.pumpAndSettle();

  if (navigateToPage != null) {
    final navState = getBuildContext(tester, tabBarState);
    await navigateToPage(navState);
  }

  skipSettle ? await tester.pump() : await tester.pumpAndSettle();
  await binding.convertFlutterSurfaceToImage();
  skipSettle ? await tester.pump() : await tester.pumpAndSettle();
  await binding.takeScreenshot(screenshotName);
}

GymSetsCompanion generateGymSetCompanion(
  String exercise,
  double weight, {
  double reps = 12,
  DateTime? date,
}) =>
    GymSetsCompanion.insert(
      name: exercise,
      reps: reps,
      weight: weight,
      unit: "kg",
      created: date ?? DateTime.now(),
      category: Value("Arms"),
    );

void main() {
  IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  var deviceType = const String.fromEnvironment("FLEXIFY_DEVICE_TYPE");
  if (deviceType.isEmpty) deviceType = 'desktop';

  setUpAll(() async {
    app.db = AppDatabase();
    app.androidChannel = const MethodChannel("com.presley.flexify/timer");
    IntegrationTestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(app.androidChannel, (message) => null);

    await app.db.delete(app.db.gymSets).go();
    await app.db.delete(app.db.plans).go();

    exercisesToPopulateTestDB.forEach(
      (key, value) async => await app.db.into(app.db.gymSets).insert(
            generateGymSetCompanion(key, value),
          ),
    );

    for (final element in graphData) {
      await app.db.into(app.db.gymSets).insert(
            generateGymSetCompanion(
              "Dumbbell shoulder press",
              element.weight,
              reps: element.reps,
              date: element.dateTime,
            ),
          );
    }

    for (var plan in plans) {
      final id = await app.db.into(app.db.plans).insert(plan);
      final exercisesList = plan.exercises.value.split(',');

      for (final exercise in exercisesList) {
        final gymSetExists = await (db.gymSets.select()
              ..where((tbl) => tbl.name.equals(exercise))
              ..limit(1))
            .getSingleOrNull();

        if (gymSetExists != null) {
          await app.db.planExercises.insertOne(
            PlanExercisesCompanion.insert(
              enabled: true,
              timers: Value(true),
              exercise: exercise,
              planId: id,
            ),
          );
        } else {
          await app.db.into(app.db.gymSets).insert(
                generateGymSetCompanion(exercise, 50.0),
              );
          await app.db.planExercises.insertOne(
            PlanExercisesCompanion.insert(
              enabled: true,
              timers: Value(true),
              exercise: exercise,
              planId: id,
            ),
          );
        }
      }
    }
  });

  group("Generate default screenshots ", () {
    testWidgets(
      "PlanPage",
      (tester) async => await generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '1_en-US',
        tabBarState: TabBarState.plans,
      ),
    );

    testWidgets(
      "GraphPage",
      (tester) async => await generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '2_en-US',
        navigateToPage: (context) async => navigateTo(
          context: context,
          page: const GraphsPage(),
        ),
        tabBarState: TabBarState.graphs,
      ),
    );

    testWidgets(
      "SettingsPage",
      (tester) async => await generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '3_en-US',
        navigateToPage: (context) async => navigateTo(
          context: context,
          page: const SettingsPage(),
        ),
        tabBarState: TabBarState.plans,
      ),
    );

    testWidgets(
      "StartPlanPage",
      (tester) async => await generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '4_en-US',
        navigateToPage: (context) async {
          final plan = await (db.plans.select()..limit(1)).getSingle();

          final planState = context.read<PlanState>();
          await planState.updateGymCounts(plan.id);

          navigateTo(
            context: context,
            page: StartPlanPage(
              plan: plan,
            ),
          );
        },
        tabBarState: TabBarState.plans,
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
        navigateToPage: (context) async => navigateTo(
          context: context,
          page: StrengthPage(
            name: screenshotExercise,
            unit: 'kg',
            data: await getStrengthData(
              target: 'kg',
              name: 'Dumbbell shoulder press',
              metric: StrengthMetric.bestWeight,
              period: Period.day,
              start: null,
              end: null,
              limit: 11,
            ),
          ),
        ),
        tabBarState: TabBarState.graphs,
      ),
    );

    testWidgets(
      "GraphHistory",
      (tester) async => await generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '6_en-US',
        navigateToPage: (context) async => navigateTo(
          context: context,
          page: const HistoryPage(),
        ),
        tabBarState: TabBarState.graphs,
      ),
    );

    testWidgets(
      "EditPlanPage",
      (tester) async => await generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '7_en-US',
        navigateToPage: (context) async {
          final state = context.read<PlanState>();
          final plan = await (db.plans.select()..limit(1)).getSingle();
          await state.setExercises(plan.toCompanion(false));
          navigateTo(
            context: context,
            page: EditPlanPage(plan: plan.toCompanion(false)),
          );
        },
        tabBarState: TabBarState.graphs,
      ),
    );

    testWidgets(
      "TimerPage",
      (tester) async => await generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '8_en-US',
        skipSettle: true,
        navigateToPage: (context) async {
          await context.read<TimerState>().addOneMinute('', true);
          await tester.pump();
          await tester.pump(const Duration(seconds: 7));
        },
        tabBarState: TabBarState.timer,
      ),
    );
  });
}
