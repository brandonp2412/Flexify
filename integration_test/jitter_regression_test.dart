import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart' as app;
import 'package:flexify/plan/start_plan_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/support/fixtures.dart';

const _allTabs = 'HistoryPage,PlansPage,GraphsPage,TimerPage,SettingsPage';

Future<AppDatabase> _pumpBenchmarkApp(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(1440, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final database = AppDatabase(
    DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ),
  );
  app.db = database;

  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await database.close();
  });

  await database.settings.update().write(
    const SettingsCompanion(
      tabs: Value(_allTabs),
      explainedPermissions: Value(true),
      notificationPermissionRequested: Value(true),
      restTimers: Value(false),
      notifications: Value(false),
      groupHistory: Value(false),
      showBodyWeight: Value(true),
      showCategories: Value(true),
      showNotes: Value(true),
      showUnits: Value(true),
      scrollableTabs: Value(true),
      systemColors: Value(false),
      localeOverride: Value('en'),
      progressPosition: Value('none'),
    ),
  );

  final planId = await database.plans.insertOne(
    planFixture(title: 'Jitter plan', days: 'Monday'),
  );
  await insertPlanExerciseFixture(
    database,
    planId: planId,
    exercise: 'Jitter bench press',
  );
  await insertExerciseSetFixture(
    database,
    'Jitter bench press',
    reps: 5,
    weight: 80,
    created: DateTime(2026, 10, 3, 12),
  );

  final settings = await (database.settings.select()..limit(1)).getSingle();
  await tester.pumpWidget(app.appProviders(settings));
  await tester.pumpAndSettle();

  return database;
}

Future<void> _openTab(WidgetTester tester, String tab) async {
  await tester.tap(find.byKey(Key(tab)));
  await tester.pumpAndSettle();
}

Future<Map<String, dynamic>> _measureFrames(
  IntegrationTestWidgetsFlutterBinding binding,
  String reportKey,
  Future<void> Function() action,
) async {
  await binding.watchPerformance(action, reportKey: reportKey);
  final report = Map<String, dynamic>.from(
    binding.reportData![reportKey] as Map<Object?, Object?>,
  );

  final buildMisses = report['missed_frame_build_budget_count'];
  final rasterMisses = report['missed_frame_rasterizer_budget_count'];
  final worstBuild = report['worst_frame_build_time_millis'];
  final worstRaster = report['worst_frame_rasterizer_time_millis'];
  debugPrint(
    '$reportKey: build misses=$buildMisses, raster misses=$rasterMisses, '
    'worst build=${worstBuild}ms, worst raster=${worstRaster}ms',
  );

  return report;
}

void _expectSmoothFrames(Map<String, dynamic> report, String interaction) {
  final buildMisses = report['missed_frame_build_budget_count'] as int;
  final rasterMisses = report['missed_frame_rasterizer_budget_count'] as int;
  final worstBuild = report['worst_frame_build_time_millis'] as double;
  final worstRaster = report['worst_frame_rasterizer_time_millis'] as double;

  expect(
    buildMisses,
    0,
    reason: '$interaction exceeded the 16 ms build-frame budget.',
  );
  expect(
    rasterMisses,
    0,
    reason: '$interaction exceeded the 16 ms raster-frame budget.',
  );
  expect(
    worstBuild,
    lessThanOrEqualTo(16),
    reason: '$interaction had a slow build frame.',
  );
  expect(
    worstRaster,
    lessThanOrEqualTo(16),
    reason: '$interaction had a slow raster frame.',
  );
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    expect(
      kProfileMode,
      isTrue,
      reason:
          'Run this performance regression test with flutter drive --profile.',
    );
    app.androidChannel = const MethodChannel('com.presley.flexify/timer');
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      app.androidChannel,
      (message) => null,
    );
  });

  testWidgets('opening StartPlanPage stays within the frame budget', (
    tester,
  ) async {
    await _pumpBenchmarkApp(tester);
    await _openTab(tester, 'PlansPage');

    final report = await _measureFrames(binding, 'open_start_plan', () async {
      await tester.tap(find.text('Jitter plan'));
      await tester.pumpAndSettle();
    });

    expect(find.byType(StartPlanPage), findsOneWidget);
    _expectSmoothFrames(report, 'Opening StartPlanPage');
  });

  testWidgets('back navigation stays within the frame budget', (tester) async {
    await _pumpBenchmarkApp(tester);

    final reports = <Map<String, dynamic>>[];

    await _openTab(tester, 'PlansPage');
    await tester.tap(find.text('Jitter plan'));
    await tester.pumpAndSettle();
    reports.add(
      await _measureFrames(binding, 'back_from_start_plan_0', () async {
        await tester.tap(find.byIcon(Icons.arrow_back).first);
        await tester.pump();
        await tester.pumpAndSettle();
      }),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'New plan'));
    await tester.pumpAndSettle();
    reports.add(
      await _measureFrames(binding, 'back_from_plan_add', () async {
        await tester.tap(find.byIcon(Icons.arrow_back).first);
        await tester.pump();
        await tester.pumpAndSettle();
      }),
    );

    await _openTab(tester, 'HistoryPage');
    await tester.tap(find.widgetWithText(FilledButton, 'Add set'));
    await tester.pumpAndSettle();
    reports.add(
      await _measureFrames(binding, 'back_from_history_add', () async {
        await tester.tap(find.byIcon(Icons.arrow_back).first);
        await tester.pump();
        await tester.pumpAndSettle();
      }),
    );

    await _openTab(tester, 'PlansPage');
    await tester.tap(find.text('Jitter plan'));
    await tester.pumpAndSettle();
    reports.add(
      await _measureFrames(binding, 'back_from_start_plan_1', () async {
        await tester.tap(find.byIcon(Icons.arrow_back).first);
        await tester.pump();
        await tester.pumpAndSettle();
      }),
    );

    final totalMissedFrames = reports.fold<int>(
      0,
      (sum, report) =>
          sum +
          (report['missed_frame_build_budget_count'] as int) +
          (report['missed_frame_rasterizer_budget_count'] as int),
    );
    final worstBuildMs = reports
        .map((report) => report['worst_frame_build_time_millis'] as double)
        .reduce((a, b) => a > b ? a : b);
    final worstRasterMs = reports
        .map((report) => report['worst_frame_rasterizer_time_millis'] as double)
        .reduce((a, b) => a > b ? a : b);

    debugPrint(
      'back_navigation: missed frames across 4 pops=$totalMissedFrames, '
      'worst build=${worstBuildMs}ms, worst raster=${worstRasterMs}ms',
    );

    expect(
      totalMissedFrames,
      0,
      reason: 'Back navigation should not miss the frame budget.',
    );
    for (final report in reports) {
      _expectSmoothFrames(report, 'Back navigation');
    }
  });

  testWidgets('History add stays within the frame budget', (tester) async {
    await _pumpBenchmarkApp(tester);
    await _openTab(tester, 'HistoryPage');

    final report = await _measureFrames(binding, 'history_add', () async {
      await tester.tap(find.widgetWithText(FilledButton, 'Add set'));
      await tester.pumpAndSettle();
    });

    expect(find.text('Save'), findsOneWidget);
    _expectSmoothFrames(report, 'History Add');
  });

  testWidgets('Plans add stays within the frame budget', (tester) async {
    await _pumpBenchmarkApp(tester);
    await _openTab(tester, 'PlansPage');

    final report = await _measureFrames(binding, 'plans_add', () async {
      await tester.tap(find.widgetWithText(FilledButton, 'New plan'));
      await tester.pumpAndSettle();
    });

    expect(find.text('Save plan'), findsOneWidget);
    _expectSmoothFrames(report, 'Plans Add');
  });
}
