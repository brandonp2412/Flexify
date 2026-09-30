import 'package:flexify/timer/timer_page.dart';
import 'package:flexify/timer/timer_progress_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications_platform_interface/flutter_local_notifications_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

class TestFlutterLocalNotificationsPlatform
    extends FlutterLocalNotificationsPlatform {
  @override
  Future<void> show({int? id, String? title, String? body, String? payload}) {
    return Future.value();
  }

  @override
  Future<NotificationAppLaunchDetails?> getNotificationAppLaunchDetails() {
    return Future.value(null);
  }

  @override
  Future<void> cancel({int? id}) {
    return Future.value();
  }

  @override
  Future<void> cancelAll() {
    return Future.value();
  }

  @override
  Future<List<ActiveNotification>> getActiveNotifications() {
    return Future.value([]);
  }

  @override
  Future<List<PendingNotificationRequest>> pendingNotificationRequests() {
    return Future.value([]);
  }

  @override
  Future<void> periodicallyShow({
    int? id,
    String? title,
    String? body,
    RepeatInterval? repeatInterval,
  }) {
    return Future.value();
  }

  @override
  Future<void> periodicallyShowWithDuration({
    int? id,
    String? title,
    String? body,
    Duration? repeatDurationInterval,
  }) {
    return Future.value();
  }

  @override
  Future<void> cancelAllPendingNotifications() {
    return Future.value();
  }
}

void main() {
  setUpAll(() {
    FlutterLocalNotificationsPlatform.instance =
        TestFlutterLocalNotificationsPlatform();
  });

  testWidgets('Timer state resets after manual stop', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final timerState = harness.timerState;

    await timerState.startTimer(
      'Test Timer',
      const Duration(seconds: 10),
      '',
      false,
      true,
    );
    await tester.pump();

    expect(timerState.timer.isRunning(), isTrue);

    await tester.pump(const Duration(seconds: 2));

    await timerState.stopTimer();
    await tester.pump();

    expect(timerState.timer.isRunning(), isFalse);

    await timerState.startTimer(
      'Test Timer 2',
      const Duration(seconds: 10),
      '',
      false,
      true,
    );
    await tester.pump();

    expect(timerState.timer.isRunning(), isTrue);
    final remaining = timerState.timer.getRemaining();
    expect(remaining.compareTo(Duration.zero), greaterThanOrEqualTo(0));
    expect(
      remaining.compareTo(const Duration(seconds: 10)),
      lessThanOrEqualTo(0),
    );

    await timerState.stopTimer();
    timerState.dispose();
  });

  testWidgets('TimerPage displays stop button when timer is running', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final timerState = harness.timerState;

    await harness.pump(tester, const TimerPage());

    expect(find.text('Stop'), findsNothing);

    await timerState.startTimer(
      'Test Timer',
      const Duration(seconds: 10),
      '',
      false,
      true,
    );
    await tester.pump();

    expect(find.text('Stop'), findsOneWidget);

    await tester.tap(find.text('Stop'));
    await tester.pumpAndSettle();

    expect(find.text('Stop'), findsNothing);

    timerState.dispose();
  });

  testWidgets('Timer and stopwatch keep the same text size', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final timerState = harness.timerState;

    await harness.pump(
      tester,
      Scaffold(
        body: StopwatchProgressIndicator(
          startedAt: null,
          accumulated: const Duration(
            minutes: 1,
            seconds: 2,
            milliseconds: 345,
          ),
          isRunning: false,
          timerState: timerState,
          onRestart: () {},
        ),
      ),
    );

    final stopwatchTime = tester.widget<Text>(find.text('01:02'));
    final stopwatchMilliseconds = tester.widget<Text>(find.text('.345'));

    expect(
      stopwatchMilliseconds.style!.fontSize,
      lessThan(stopwatchTime.style!.fontSize!),
    );
    expect(
      stopwatchMilliseconds.style!.color!.a,
      lessThan(stopwatchTime.style!.color!.a),
    );

    await timerState.startTimer(
      'Test Timer',
      const Duration(seconds: 10),
      '',
      false,
      true,
    );
    await harness.pump(
      tester,
      const Scaffold(body: TimerCircularProgressIndicator()),
    );
    await tester.pump(const Duration(milliseconds: 16));

    final timerTimeFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Text &&
          RegExp(r'^\d{2}:\d{2}$').hasMatch(widget.data ?? ''),
    );
    final timerMillisecondsFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Text && RegExp(r'^\.\d{3}$').hasMatch(widget.data ?? ''),
    );

    expect(timerTimeFinder, findsOneWidget);
    expect(timerMillisecondsFinder, findsOneWidget);

    final timerTime = tester.widget<Text>(timerTimeFinder);
    final timerMilliseconds = tester.widget<Text>(timerMillisecondsFinder);

    expect(timerTime.style!.fontSize, stopwatchTime.style!.fontSize);
    expect(
      timerMilliseconds.style!.fontSize,
      stopwatchMilliseconds.style!.fontSize,
    );
    expect(
      timerMilliseconds.style!.fontSize,
      lessThan(timerTime.style!.fontSize!),
    );
    expect(
      timerMilliseconds.style!.color!.a,
      lessThan(timerTime.style!.color!.a),
    );

    await timerState.stopTimer();
    timerState.dispose();
  });

  testWidgets('stopwatch circle stays fixed across start and pause', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final timerState = harness.timerState;

    await harness.pump(tester, const TimerPage());

    final circleFinder = find.byKey(const ValueKey('stopwatch-ring'));
    expect(circleFinder, findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    final idleRect = tester.getRect(circleFinder);
    final timeFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Text &&
          RegExp(r'^\d{2}:\d{2}$').hasMatch(widget.data ?? ''),
    );
    final millisFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Text && RegExp(r'^\.\d{3}$').hasMatch(widget.data ?? ''),
    );
    final idleTimeRect = tester.getRect(timeFinder);
    final idleMillisRect = tester.getRect(millisFinder);

    await tester.tap(find.text('Start'));
    await tester.pump(const Duration(milliseconds: 50));
    final runningRect = tester.getRect(circleFinder);
    final runningTimeRect = tester.getRect(timeFinder);
    final runningMillisRect = tester.getRect(millisFinder);

    await tester.tap(find.text('Pause'));
    await tester.pump(const Duration(milliseconds: 50));
    final pausedRect = tester.getRect(circleFinder);
    final pausedTimeRect = tester.getRect(timeFinder);
    final pausedMillisRect = tester.getRect(millisFinder);

    expect(runningRect, idleRect);
    expect(pausedRect, idleRect);
    expect(runningTimeRect, idleTimeRect);
    expect(pausedTimeRect, idleTimeRect);
    expect(runningMillisRect, idleMillisRect);
    expect(pausedMillisRect, idleMillisRect);

    timerState.dispose();
  });
}
