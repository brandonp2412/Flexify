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
import '../test/support/graph_fixtures.dart';

Future<void> appWrapper(WidgetTester tester) async {
  await app.db.settings.update().write(
    SettingsCompanion(
      themeMode: Value(ThemeMode.dark.toString()),
      explainedPermissions: const Value(true),
      restTimers: const Value(true),
      systemColors: const Value(false),
      curveLines: const Value(true),
      showImages: const Value(false),
      showGlobalProgress: const Value(false),
    ),
  );
  final settings = await (db.settings.select()..limit(1)).getSingle();
  final settingsState = SettingsState(settings);

  await tester.pumpWidget(app.appProviders(settingsState));
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
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}

Future<void> generateScreenshot({
  required IntegrationTestWidgetsFlutterBinding binding,
  required WidgetTester tester,
  required String screenshotName,
  required String tabBarState,
  Future<void> Function(BuildContext context)? navigateToPage,
  bool skipSettle = false,
}) async {
  await appWrapper(tester);
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

const _only = String.fromEnvironment('SCREENSHOT_ONLY');

bool _skip(String name) => _only.isNotEmpty && _only != name;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    app.db = AppDatabase();
    app.androidChannel = const MethodChannel('com.presley.flexify/timer');
    IntegrationTestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(app.androidChannel, (message) => null);

    await app.db.delete(app.db.gymSets).go();
    await app.db.delete(app.db.plans).go();
    await app.db.delete(app.db.planExercises).go();

    await seedGraphFixtures(app.db);
    await db.plans.insertAll(screenshotPlans);
    await db.planExercises.insertAll(screenshotPlanExercises);
  });

  group('Generate default screenshots ', () {
    testWidgets(
      'PlanPage',
      (tester) async => generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '1_en-US',
        tabBarState: 'PlansPage',
      ),
      skip: _skip('PlanPage'),
    );

    testWidgets(
      'GraphPage',
      (tester) async => generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '2_en-US',
        navigateToPage: (context) async => navigateTo(
          context: context,
          page: GraphsPage(tabController: MockTabController()),
        ),
        tabBarState: 'GraphsPage',
      ),
      skip: _skip('GraphPage'),
    );

    testWidgets(
      'SettingsPage',
      (tester) async => generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '3_en-US',
        navigateToPage: (context) async =>
            navigateTo(context: context, page: const SettingsPage()),
        tabBarState: 'PlansPage',
      ),
      skip: _skip('SettingsPage'),
    );

    testWidgets(
      'StartPlanPage',
      (tester) async => generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '4_en-US',
        navigateToPage: (context) async {
          await tester.tap(find.text('Monday'));
          await tester.pumpAndSettle();
        },
        tabBarState: 'PlansPage',
      ),
      skip: _skip('StartPlanPage'),
    );
  });

  group('Generate extra screenshots', () {
    testWidgets(
      'ViewGraphPage',
      (tester) async => generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '5_en-US',
        navigateToPage: (context) async {
          final data = await getStrengthData(
            target: 'kg',
            name: screenshotExercise,
            metric: StrengthMetric.bestWeight,
            period: Period.day,
            start: null,
            end: null,
            limit: 11,
          );
          if (!context.mounted) return;
          navigateTo(
            context: context,
            page: StrengthPage(
              tabCtrl: MockTabController(),
              name: screenshotExercise,
              unit: 'kg',
              data: data,
            ),
          );
        },
        tabBarState: 'GraphsPage',
      ),
      skip: _skip('ViewGraphPage'),
    );

    testWidgets(
      'GraphHistory',
      (tester) async => generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '6_en-US',
        tabBarState: 'HistoryPage',
      ),
      skip: _skip('GraphHistory'),
    );

    testWidgets(
      'EditPlanPage',
      (tester) async => generateScreenshot(
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
      skip: _skip('EditPlanPage'),
    );

    testWidgets(
      'TimerPage',
      (tester) async => generateScreenshot(
        binding: binding,
        tester: tester,
        screenshotName: '8_en-US',
        skipSettle: true,
        navigateToPage: (context) async {
          context.read<TimerState>().setTimer(60, 7);
          await tester.pump();
        },
        tabBarState: 'TimerPage',
      ),
      skip: _skip('TimerPage'),
    );
  });
}
