import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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

  runApp(app.appProviders(settingsState));
}

void main() {
  late AppDatabase database;

  setUpAll(() async {
    database = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    app.db = database;
    app.androidChannel = const MethodChannel("com.presley.flexify/timer");
    IntegrationTestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(app.androidChannel, (message) => null);
  });

  tearDownAll(() async {
    await database.close();
  });

  group('Performance Tests', () {
    testWidgets('Swipe between tabs performance', (tester) async {
      await appWrapper();
      await tester.pumpAndSettle();

      final tabBarViewFinder = find.byType(TabBarView);
      expect(tabBarViewFinder, findsOneWidget);

      var gestureTime = Duration.zero;
      for (final offset in const [
        Offset(-500, 0),
        Offset(-500, 0),
        Offset(-500, 0),
        Offset(500, 0),
        Offset(500, 0),
        Offset(500, 0),
      ]) {
        final stopwatch = Stopwatch()..start();
        await tester.drag(tabBarViewFinder, offset);
        stopwatch.stop();
        gestureTime += stopwatch.elapsed;
        await tester.pumpAndSettle();
      }

      print(
        'Performance Test: Six tab swipe gestures took '
        '${gestureTime.inMilliseconds} ms excluding animations',
      );
      expect(gestureTime.inMilliseconds, lessThan(2000));
    });
  });
}
