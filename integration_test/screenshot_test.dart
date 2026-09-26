import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/graph/graphs_page.dart';
import 'package:flexify/graph/strength_page.dart';
import 'package:flexify/main.dart' as app;
import 'package:flexify/main.dart';
import 'package:flexify/plan/edit_plan_page.dart';
import 'package:flexify/plan/plans_page.dart';
import 'package:flexify/sets/history_page.dart';
import 'package:flexify/settings/settings_page.dart';
import 'package:flexify/timer/timer_page.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

import '../test/mock_tab_controller.dart';
import '../test/support/graph_fixtures.dart';
import 'test_database.dart';

Future<void> appWrapper(
  WidgetTester tester, {
  required String localeIdentifier,
}) async {
  await app.db.settings.update().write(
    SettingsCompanion(
      themeMode: Value(ThemeMode.dark.toString()),
      explainedPermissions: const Value(true),
      restTimers: const Value(true),
      systemColors: const Value(false),
      curveLines: const Value(true),
      showImages: const Value(false),
      showGlobalProgress: const Value(false),
      localeOverride: Value(localeIdentifier),
    ),
  );
  final settings = await (db.settings.select()..limit(1)).getSingle();

  await tester.pumpWidget(app.appProviders(settings));
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
  required String localeIdentifier,
  Future<void> Function(BuildContext context)? navigateToPage,
  bool skipSettle = false,
}) async {
  await appWrapper(tester, localeIdentifier: localeIdentifier);
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
const _screenshotLocales = String.fromEnvironment(
  'SCREENSHOT_LOCALES',
  defaultValue: 'en-US',
);

const _storeLocaleToAppLocale = <String, String>{
  'en-US': 'en',
  'de-DE': 'de',
  'es-ES': 'es',
  'fr-FR': 'fr',
  'hi-IN': 'hi',
  'it-IT': 'it',
  'ja-JP': 'ja',
  'ko-KR': 'ko',
  'nl-NL': 'nl',
  'pl-PL': 'pl',
  'pt-BR': 'pt-BR',
  'tr-TR': 'tr',
  'ru-RU': 'ru',
  'zh-CN': 'zh-CN',
};

bool _skip(String name) => _only.isNotEmpty && _only != name;

List<MapEntry<String, String>> _requestedScreenshotLocales() =>
    _screenshotLocales
        .split(',')
        .map((locale) => locale.trim())
        .where((locale) => locale.isNotEmpty)
        .map(
          (storeLocale) => MapEntry(
            storeLocale,
            _storeLocaleToAppLocale[storeLocale] ??
                (throw ArgumentError.value(
                  storeLocale,
                  'SCREENSHOT_LOCALES',
                  'Unsupported store locale',
                )),
          ),
        )
        .toList(growable: false);

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase database;

  setUpAll(() async {
    database = createIntegrationTestDatabase();
    app.db = database;
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

  tearDownAll(() async {
    await database.close();
  });

  for (final screenshotLocale in _requestedScreenshotLocales()) {
    final storeLocale = screenshotLocale.key;
    final appLocale = screenshotLocale.value;

    group('Generate $storeLocale default screenshots ', () {
      testWidgets(
        'PlanPage',
        (tester) async => generateScreenshot(
          binding: binding,
          tester: tester,
          screenshotName: '1_$storeLocale',
          tabBarState: 'PlansPage',
          localeIdentifier: appLocale,
        ),
        skip: _skip('PlanPage'),
      );

      testWidgets(
        'GraphPage',
        (tester) async => generateScreenshot(
          binding: binding,
          tester: tester,
          screenshotName: '2_$storeLocale',
          localeIdentifier: appLocale,
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
          screenshotName: '3_$storeLocale',
          localeIdentifier: appLocale,
          navigateToPage: (context) async =>
              navigateTo(context: context, page: const SettingsPage()),
          tabBarState: 'PlansPage',
        ),
        skip: _skip('SettingsPage'),
      );

      testWidgets('StartPlanPage', (tester) async {
        final today = DateTime.now().toLocal();
        for (var index = 0; index < 3; index++) {
          await db
              .into(db.gymSets)
              .insert(
                graphGymSet(
                  'Barbell shoulder press',
                  50 + (index * 2.5),
                  reps: 8,
                  date: today.subtract(Duration(minutes: index)),
                  planId: 3,
                ),
              );
        }
        for (var index = 0; index < 2; index++) {
          await db
              .into(db.gymSets)
              .insert(
                graphGymSet(
                  'Crunch',
                  25,
                  reps: 12,
                  date: today.subtract(Duration(minutes: 10 + index)),
                  planId: 3,
                ),
              );
        }

        try {
          await generateScreenshot(
            binding: binding,
            tester: tester,
            screenshotName: '4_$storeLocale',
            localeIdentifier: appLocale,
            navigateToPage: (context) async {
              await tester.tap(find.text('Monday'));
              await tester.pumpAndSettle();
            },
            tabBarState: 'PlansPage',
          );
        } finally {
          await (db.delete(
            db.gymSets,
          )..where((tbl) => tbl.planId.equals(3))).go();
        }
      }, skip: _skip('StartPlanPage'));
    });

    group('Generate $storeLocale extra screenshots', () {
      testWidgets(
        'ViewGraphPage',
        (tester) async => generateScreenshot(
          binding: binding,
          tester: tester,
          screenshotName: '5_$storeLocale',
          localeIdentifier: appLocale,
          navigateToPage: (context) async {
            final data = await getStrengthData(
              target: 'kg',
              name: screenshotExercise,
              category: fixtureCategory(screenshotExercise),
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
                name: 'Shoulder press',
                category: fixtureCategory(screenshotExercise),
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
          screenshotName: '6_$storeLocale',
          tabBarState: 'HistoryPage',
          localeIdentifier: appLocale,
        ),
        skip: _skip('GraphHistory'),
      );

      testWidgets('EditPlanPage', (tester) async {
        const planId = 99;
        final plan = PlansCompanion.insert(
          id: const Value(planId),
          days: 'Tuesday,Thursday,Saturday',
          title: const Value('Upper body strength'),
        );
        await db.into(db.plans).insert(plan);
        await db.planExercises.insertAll(
          [
            'Barbell bench press',
            'Barbell bent-over row',
            'Dumbbell chest press',
            'Dumbbell lateral raise',
            'Barbell biceps curl',
            'Triceps dip',
          ].map(
            (exercise) => PlanExercisesCompanion.insert(
              planId: planId,
              enabled: true,
              exercise: exercise,
            ),
          ),
        );

        try {
          await generateScreenshot(
            binding: binding,
            tester: tester,
            screenshotName: '7_$storeLocale',
            localeIdentifier: appLocale,
            navigateToPage: (context) async {
              if (!context.mounted) return;
              navigateTo(
                context: context,
                page: EditPlanPage(plan: plan),
              );
            },
            tabBarState: 'GraphsPage',
          );
        } finally {
          await (db.delete(
            db.planExercises,
          )..where((tbl) => tbl.planId.equals(planId))).go();
          await (db.delete(
            db.plans,
          )..where((tbl) => tbl.id.equals(planId))).go();
        }
      }, skip: _skip('EditPlanPage'));

      testWidgets(
        'TimerPage',
        (tester) async => generateScreenshot(
          binding: binding,
          tester: tester,
          screenshotName: '8_$storeLocale',
          localeIdentifier: appLocale,
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
}
