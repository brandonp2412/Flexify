import 'package:drift/drift.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tests.dart';
import 'support/fixtures.dart';
import 'support/test_app.dart';

void main() {
  testWidgets(
    'saving a set does not start a rest timer when restTimers is off (#308)',
    (WidgetTester tester) async {
      final harness = await FlexifyTestHarness.create();
      final timerState = harness.timerState;
      final settings = await (harness.database.settings.select()..limit(1))
          .getSingle();
      expect(settings.restTimers, false);

      await harness.pump(
        tester,
        EditSetPage(gymSet: gymSetModelFixture()),
      );

      await tester.enterText(find.bySemanticsLabel('Reps'), '10');
      await tester.enterText(find.bySemanticsLabel('Weight (kg)'), '50');
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
      final harness = await FlexifyTestHarness.create();
      final timerState = harness.timerState;

      await harness.database.settings.update().write(
        testSettings(restTimers: true),
      );
      final settings = await (harness.database.settings.select()..limit(1))
          .getSingle();
      expect(settings.restTimers, true);

      await harness.pump(
        tester,
        EditSetPage(gymSet: gymSetModelFixture()),
      );

      await tester.enterText(find.bySemanticsLabel('Reps'), '10');
      await tester.enterText(find.bySemanticsLabel('Weight (kg)'), '50');
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
