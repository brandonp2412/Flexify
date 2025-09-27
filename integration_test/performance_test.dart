import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart' as app;
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

Future<void> appWrapper() async {
  WidgetsFlutterBinding.ensureInitialized();
  await app.db.settings.update().write(
        SettingsCompanion(
          themeMode: Value(ThemeMode.dark.toString()),
          explainedPermissions: const Value(true),
          restTimers: const Value(true),
          systemColors: const Value(false),
          curveLines: const Value(true),
          scrollableTabs: const Value(true),
        ),
      );
  final settings = await (db.settings.select()..limit(1)).getSingle();
  final settingsState = SettingsState(settings);

  runApp(app.appProviders(settingsState, hideChangelog: true));
}

void main() {
  IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    app.db = AppDatabase();
    app.androidChannel = const MethodChannel("com.presley.flexify/timer");
    IntegrationTestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(app.androidChannel, (message) => null);

    await app.db.delete(app.db.gymSets).go();
    await app.db.delete(app.db.plans).go();
  });

  group('Performance Tests', () {
    testWidgets('Swipe between tabs performance', (tester) async {
      await appWrapper();
      await tester.pumpAndSettle();

      final stopwatch = Stopwatch()..start();

      // Assuming there are 4 tabs: Plans, Graphs, Timer, History
      // Find the TabBarView
      final tabBarViewFinder = find.byType(TabBarView);
      expect(tabBarViewFinder, findsOneWidget);

      // Swipe from Plans to Graphs
      await tester.drag(tabBarViewFinder, const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Swipe from Graphs to Timer
      await tester.drag(tabBarViewFinder, const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Swipe from Timer to History
      await tester.drag(tabBarViewFinder, const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Swipe back from History to Timer
      await tester.drag(tabBarViewFinder, const Offset(500, 0));
      await tester.pumpAndSettle();

      // Swipe back from Timer to Graphs
      await tester.drag(tabBarViewFinder, const Offset(500, 0));
      await tester.pumpAndSettle();

      // Swipe back from Graphs to Plans
      await tester.drag(tabBarViewFinder, const Offset(500, 0));
      await tester.pumpAndSettle();

      stopwatch.stop();
      final elapsed = stopwatch.elapsedMilliseconds;

      print('Performance Test: Swiping between tabs took $elapsed ms');

      // You can set a threshold for performance here
      // For example, expect it to be under 2000ms (2 seconds)
      expect(elapsed, lessThan(2000));
    });
  });
}
