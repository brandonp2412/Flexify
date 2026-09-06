import 'package:flexify/timer/timer_page.dart';
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
}
