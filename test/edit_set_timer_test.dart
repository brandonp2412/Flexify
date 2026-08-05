import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  testWidgets(
    'saving a set does not start a rest timer when restTimers is off (#308)',
    (WidgetTester tester) async {
      await mockTests();
      db = testDb();
      final timerState = TimerState();

      final settings = await (db.settings.select()..limit(1)).getSingle();
      expect(settings.restTimers, false);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => SettingsState(settings),
            ),
            ChangeNotifierProvider.value(value: timerState),
            ChangeNotifierProvider(create: (context) => PlanState()),
          ],
          child: MaterialApp(
            home: EditSetPage(
              gymSet: GymSet(
                id: 0,
                name: 'Bench press',
                reps: 2,
                weight: 3,
                unit: 'kg',
                created: DateTime.now(),
                hidden: false,
                bodyWeight: 0,
                duration: 0,
                distance: 0,
                cardio: false,
              ),
            ),
          ),
        ),
      );

      final reps = find.bySemanticsLabel('Reps');
      final weight = find.bySemanticsLabel('Weight (kg)');
      await tester.enterText(reps, '10');
      await tester.enterText(weight, '50');

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(
        timerState.timer.isRunning(),
        false,
        reason: 'No rest timer should start when restTimers is disabled',
      );

      timerState.dispose();
    },
  );

  testWidgets(
    'starting a second rest timer supersedes the first instead of stacking '
    '(#300)',
    (WidgetTester tester) async {
      await mockTests();
      final timerState = TimerState();

      await timerState.startTimer(
        'Bench press',
        const Duration(seconds: 30),
        '',
        false,
        false,
      );
      expect(timerState.timer.isRunning(), true);
      expect(timerState.timer.total, const Duration(seconds: 30));

      await timerState.startTimer(
        'Squat',
        const Duration(seconds: 45),
        '',
        false,
        false,
      );

      expect(
        timerState.timer.isRunning(),
        true,
        reason: 'The second startTimer call must leave a single active timer',
      );
      expect(
        timerState.timer.total,
        const Duration(seconds: 45),
        reason: 'The second timer must supersede the first, not be ignored',
      );

      timerState.dispose();
    },
  );

  testWidgets(
    'saving a set starts a rest timer using the exercise default duration '
    'when restTimers is on',
    (WidgetTester tester) async {
      await mockTests();
      db = testDb();
      final timerState = TimerState();

      await db
          .update(db.settings)
          .write(const SettingsCompanion(restTimers: Value(true)));
      final settings = await (db.settings.select()..limit(1)).getSingle();
      expect(settings.restTimers, true);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => SettingsState(settings),
            ),
            ChangeNotifierProvider.value(value: timerState),
            ChangeNotifierProvider(create: (context) => PlanState()),
          ],
          child: MaterialApp(
            home: EditSetPage(
              gymSet: GymSet(
                id: 0,
                name: 'Bench press',
                reps: 2,
                weight: 3,
                unit: 'kg',
                created: DateTime.now(),
                hidden: false,
                bodyWeight: 0,
                duration: 0,
                distance: 0,
                cardio: false,
              ),
            ),
          ),
        ),
      );

      final reps = find.bySemanticsLabel('Reps');
      final weight = find.bySemanticsLabel('Weight (kg)');
      await tester.enterText(reps, '10');
      await tester.enterText(weight, '50');

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(timerState.timer.isRunning(), true);
      expect(
        timerState.timer.total,
        Duration(milliseconds: settings.timerDuration),
      );

      timerState.dispose();
    },
  );
}
