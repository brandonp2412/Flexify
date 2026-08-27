import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../mock_tests.dart';

class FlexifyTestHarness {
  FlexifyTestHarness._({
    required this.database,
    required this.planState,
    required this.timerState,
  });

  final AppDatabase database;
  final PlanState planState;
  final TimerState timerState;

  static Future<FlexifyTestHarness> create({
    PlanState? planState,
    TimerState? timerState,
  }) async {
    await mockTests();
    final database = testDb();
    db = database;

    return FlexifyTestHarness._(
      database: database,
      planState: planState ?? PlanState(),
      timerState: timerState ?? TimerState(),
    );
  }

  Future<void> pump(
    WidgetTester tester,
    Widget home, {
    PlanState? planState,
    TimerState? timerState,
    Size? surfaceSize,
  }) async {
    if (surfaceSize != null) {
      await tester.binding.setSurfaceSize(surfaceSize);
      addTearDown(() => tester.binding.setSurfaceSize(null));
    }

    final setting = await (database.settings.select()..limit(1)).getSingle();
    final settingsState = SettingsState(setting);
    final effectiveTimerState = timerState ?? this.timerState;

    addTearDown(settingsState.dispose);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: settingsState),
          ChangeNotifierProvider.value(value: effectiveTimerState),
          ChangeNotifierProvider.value(value: planState ?? this.planState),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: rootScaffoldMessenger,
          home: home,
        ),
      ),
    );
  }
}
