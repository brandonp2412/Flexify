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

import '../test/mock_tab_controller.dart';

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

List<PlanExercisesCompanion> planExercises = [
  PlanExercisesCompanion.insert(
    planId: 1,
    enabled: true,
    exercise: 'Triceps dip',
  ),
  PlanExercisesCompanion.insert(
    planId: 1,
    enabled: true,
    exercise: 'Squat',
  ),
  PlanExercisesCompanion.insert(
    planId: 1,
    enabled: true,
    exercise: 'Standing calf raise',
  ),
  PlanExercisesCompanion.insert(
    planId: 1,
    enabled: true,
    exercise: 'Pull-up',
  ),
  PlanExercisesCompanion.insert(
    planId: 2,
    enabled: true,
    exercise: 'Barbell bench press',
  ),
  PlanExercisesCompanion.insert(
    planId: 2,
    enabled: true,
    exercise: 'Barbell bent-over row',
  ),
  PlanExercisesCompanion.insert(
    planId: 2,
    enabled: true,
    exercise: 'Dumbbell lateral raise',
  ),
  PlanExercisesCompanion.insert(
    planId: 2,
    enabled: true,
    exercise: 'Barbell biceps curl',
  ),
  PlanExercisesCompanion.insert(
    planId: 3,
    enabled: true,
    exercise: 'Barbell shoulder press',
  ),
  PlanExercisesCompanion.insert(
    planId: 3,
    enabled: true,
    exercise: 'Crunch',
  ),
  PlanExercisesCompanion.insert(
    planId: 3,
    enabled: true,
    exercise: 'Chin-up',
  ),
  PlanExercisesCompanion.insert(
    planId: 3,
    enabled: true,
    exercise: 'Romanian deadlift',
  ),
  PlanExercisesCompanion.insert(
    planId: 4,
    enabled: true,
    exercise: 'Barbell shoulder press',
  ),
  PlanExercisesCompanion.insert(
    planId: 4,
    enabled: true,
    exercise: 'Neck curl',
  ),
  PlanExercisesCompanion.insert(
    planId: 4,
    enabled: true,
    exercise: 'Chin-up',
  ),
  PlanExercisesCompanion.insert(
    planId: 4,
    enabled: true,
    exercise: 'Romanian deadlift',
  ),
];

List<PlansCompanion> plans = [
  PlansCompanion.insert(
    id: Value(1),
    days: 'Tuesday,Saturday',
    title: const Value("Tuesday, Saturday"),
  ),
  PlansCompanion(
    id: Value(2),
    days: Value('Wednesday,Sunday'),
    title: const Value("Wednesday, Sunday"),
  ),
  PlansCompanion(
    id: Value(3),
    days: Value('Monday'),
    title: const Value("Monday"),
  ),
  PlansCompanion(
    id: Value(4),
    days: Value('Thursday'),
    title: const Value("Thursday"),
  ),
];

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

BuildContext getBuildContext(WidgetTester tester, String tabBarState) {
  switch (tabBarState) {
    case 'PlansPage':
      return (tester.state(find.byType(PlansPage)) as PlansPageState)
          .navKey
          .currentContext!;
    case 'GraphsPage':
      return (tester.state(find.byType(GraphsPage)) as GraphsPageState)
          .navKey
          .currentContext!;
    case 'TimerPage':
      return (tester.state(find.byType(TimerPage)) as TimerPageState).context;
    case 'HistoryPage':
      return (tester.state(find.byType(HistoryPage)) as HistoryPageState)
          .context;
  }

  return tester.element(find.byType(MaterialApp));
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
  required String tabBarState,
  Future<void> Function(BuildContext context)? navigateToPage,
  bool skipSettle = false,
}) async {
  await appWrapper();
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(Key(tabBarState)));
  await tester.pumpAndSettle();

  if (navigateToPage != null) {
    final navState = getBuildContext(tester, tabBarState);
    if (navState.mounted) await navigateToPage(navState);
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
      category: const Value("Arms"),
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

    await db.plans.insertAll(plans);
    await db.planExercises.insertAll(planExercises);
  });

  group("Generate default screenshots ", () {
    testWidgets(
      "PlanPage",
      (tester) async => await generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '1_en-US',
        tabBarState: 'PlansPage',
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
          page: GraphsPage(tabController: MockTabController()),
        ),
        tabBarState: 'GraphsPage',
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
        tabBarState: 'PlansPage',
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

          if (!context.mounted) return;
          final planState = context.read<PlanState>();
          await planState.updateGymCounts(plan.id);

          if (!context.mounted) return;
          navigateTo(
            context: context,
            page: StartPlanPage(
              plan: plan,
            ),
          );
        },
        tabBarState: 'PlansPage',
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
        navigateToPage: (context) async {
          navigateTo(
            // ignore: use_build_context_synchronously
            context: context,
            page: StrengthPage(
              tabCtrl: MockTabController(),
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
          );
        },
        tabBarState: 'GraphsPage',
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
          page: HistoryPage(tabController: MockTabController()),
        ),
        tabBarState: 'HistoryPage',
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
          if (!context.mounted) return;
          navigateTo(
            context: context,
            page: EditPlanPage(plan: plan.toCompanion(false)),
          );
        },
        tabBarState: 'GraphsPage',
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
          context.read<TimerState>().setTimer(60, 7);
          await tester.pump();
          if (!context.mounted) return;
          await tester.pump(const Duration(seconds: 7));
        },
        tabBarState: 'TimerPage',
      ),
    );
  });
}
