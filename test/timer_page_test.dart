import 'package:flexify/database/database.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_page.dart';
import 'package:flexify/timer/timer_progress_widgets.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() {
  testWidgets('TimerProgressIndicator maintains state after manual stop',
      (WidgetTester tester) async {
    await mockTests();

    final timerState = TimerState();
    final settings = SettingsState(
      const Setting(
        id: 1,
        alarmSound: '',
        vibrate: true,
        restTimers: true,
        showUnits: true,
        systemColors: true,
        explainedPermissions: true,
        cardioUnit: 'km',
        tabs: 'HistoryPage,PlansPage,GraphsPage,TimerPage',
        themeMode: 'ThemeMode.system',
        groupHistory: true,
        automaticBackups: true,
        curveLines: false,
        warmupSets: null,
        timerDuration: 180000,
        maxSets: 3,
        longDateFormat: 'dd/MM/yy',
        shortDateFormat: 'd/M/yy',
        durationEstimation: true,
        enableSound: true,
        showBodyWeight: true,
        showCategories: true,
        showImages: true,
        showNotes: true,
        showGlobalProgress: true,
        strengthUnit: 'kg',
        backupPath: null,
        curveSmoothness: null,
        notifications: true,
        peekGraph: false,
        planTrailing: 'PlanTrailing.reorder',
        repEstimation: true,
      ),
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: timerState),
          ChangeNotifierProvider.value(value: settings),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: TimerProgressIndicator(),
          ),
        ),
      ),
    );

    expect(find.byType(LinearProgressIndicator), findsNothing);

    await timerState.startTimer(
      'Test Timer',
      const Duration(seconds: 10),
      '',
      false,
    );
    await tester.pump();

    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));

    await timerState.stopTimer();
    await tester.pump();

    expect(find.byType(LinearProgressIndicator), findsNothing);

    await timerState.startTimer(
      'Test Timer 2',
      const Duration(seconds: 10),
      '',
      false,
    );
    await tester.pump();

    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    final progressIndicator = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(progressIndicator.value, isNotNull);
    expect(
      progressIndicator.value! >= 0 && progressIndicator.value! <= 1,
      isTrue,
    );

    await timerState.stopTimer();
    timerState.dispose();
  });

  testWidgets('TimerPage displays stop button when timer is running',
      (WidgetTester tester) async {
    await mockTests();

    final timerState = TimerState();
    final settings = SettingsState(
      const Setting(
        id: 1,
        alarmSound: '',
        vibrate: true,
        restTimers: true,
        showUnits: true,
        systemColors: true,
        explainedPermissions: true,
        cardioUnit: 'km',
        tabs: 'HistoryPage,PlansPage,GraphsPage,TimerPage',
        themeMode: 'ThemeMode.system',
        groupHistory: true,
        automaticBackups: true,
        curveLines: false,
        warmupSets: null,
        timerDuration: 180000,
        maxSets: 3,
        longDateFormat: 'dd/MM/yy',
        shortDateFormat: 'd/M/yy',
        durationEstimation: true,
        enableSound: true,
        showBodyWeight: true,
        showCategories: true,
        showImages: true,
        showNotes: true,
        showGlobalProgress: true,
        strengthUnit: 'kg',
        backupPath: null,
        curveSmoothness: null,
        notifications: true,
        peekGraph: false,
        planTrailing: 'PlanTrailing.reorder',
        repEstimation: true,
      ),
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: timerState),
          ChangeNotifierProvider.value(value: settings),
        ],
        child: const MaterialApp(
          home: TimerPage(),
        ),
      ),
    );

    expect(find.text('Stop'), findsNothing);

    await timerState.startTimer(
      'Test Timer',
      const Duration(seconds: 10),
      '',
      false,
    );
    await tester.pump();

    expect(find.text('Stop'), findsOneWidget);
    expect(find.byIcon(Icons.stop), findsOneWidget);

    await tester.tap(find.text('Stop'));
    await tester.pump();

    expect(find.text('Stop'), findsNothing);

    timerState.dispose();
  });
}
