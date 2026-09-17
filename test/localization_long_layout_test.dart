import 'package:drift/drift.dart' hide isNull;
import 'package:flexify/app_search.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/strength_data.dart';
import 'package:flexify/graph/strength_page.dart';
import 'package:flexify/l10n/generated/app_localizations.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/session_sets.dart';
import 'package:flexify/selection_controller.dart';
import 'package:flexify/settings/appearance_settings.dart';
import 'package:flexify/settings/plan_settings.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_page.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tab_controller.dart';
import 'support/fixtures.dart';
import 'support/test_app.dart';

const _narrowSurface = Size(320, 640);
const _largeText = TextScaler.linear(1.5);

class _RecordingTimerState extends TimerState {
  Map<String, String>? notificationLocalizations;

  @override
  void setNotificationLocalizations({
    required String timerUpTitle,
    required String openNotificationLabel,
    required String stopLabel,
    required String addOneMinuteLabel,
    required String restTimerTitle,
    required String timerChannelName,
    required String timerChannelDescription,
    required String timerFinishedChannelName,
    required String timerFinishedChannelDescription,
    required String timerFinishedTitle,
    required String exactAlarmRequestUnavailable,
  }) {
    notificationLocalizations = {
      'timerUpTitle': timerUpTitle,
      'openNotificationLabel': openNotificationLabel,
      'stopLabel': stopLabel,
      'addOneMinuteLabel': addOneMinuteLabel,
      'restTimerTitle': restTimerTitle,
      'timerChannelName': timerChannelName,
      'timerChannelDescription': timerChannelDescription,
      'timerFinishedChannelName': timerFinishedChannelName,
      'timerFinishedChannelDescription': timerFinishedChannelDescription,
      'timerFinishedTitle': timerFinishedTitle,
      'exactAlarmRequestUnavailable': exactAlarmRequestUnavailable,
    };
    super.setNotificationLocalizations(
      timerUpTitle: timerUpTitle,
      openNotificationLabel: openNotificationLabel,
      stopLabel: stopLabel,
      addOneMinuteLabel: addOneMinuteLabel,
      restTimerTitle: restTimerTitle,
      timerChannelName: timerChannelName,
      timerChannelDescription: timerChannelDescription,
      timerFinishedChannelName: timerFinishedChannelName,
      timerFinishedChannelDescription: timerFinishedChannelDescription,
      timerFinishedTitle: timerFinishedTitle,
      exactAlarmRequestUnavailable: exactAlarmRequestUnavailable,
    );
  }
}

void main() {
  testWidgets('Polish appearance segmented controls fit narrow scaled layout', (
    tester,
  ) async {
    const locale = Locale('pl');
    final l10n = lookupAppLocalizations(locale);
    final harness = await FlexifyTestHarness.create();

    await harness.pump(
      tester,
      const AppearanceSettings(),
      locale: locale,
      surfaceSize: _narrowSurface,
      textScaler: _largeText,
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.appearance), findsOneWidget);
    expect(find.text(l10n.themeSystem), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.scrollUntilVisible(
      find.text(l10n.inputStyleFilled),
      260,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text(l10n.inputStyleFilled), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Polish plan segmented controls fit narrow scaled layout', (
    tester,
  ) async {
    const locale = Locale('pl');
    final l10n = lookupAppLocalizations(locale);
    final harness = await FlexifyTestHarness.create();

    await harness.pump(
      tester,
      const PlanSettings(),
      locale: locale,
      surfaceSize: _narrowSurface,
      textScaler: _largeText,
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.planTrailingDisplay), findsOneWidget);
    expect(find.text(l10n.reorder), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Polish delete dialog fits narrow scaled layout', (tester) async {
    const locale = Locale('pl');
    final l10n = lookupAppLocalizations(locale);
    final harness = await FlexifyTestHarness.create();
    final selection = SelectionController<String>()..add('User entry');

    await harness.pump(
      tester,
      Scaffold(
        body: AppSearch(
          controller: selection,
          onChange: (_) {},
          onSelectAll: () {},
          onDelete: () async {},
          onEdit: () async {},
          onShare: () async {},
          confirmText: l10n.deleteEntriesConfirmation(1),
        ),
      ),
      locale: locale,
      surfaceSize: _narrowSurface,
      textScaler: _largeText,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(l10n.deleteSelected));
    await tester.pumpAndSettle();

    expect(find.text(l10n.confirmDelete), findsOneWidget);
    expect(find.text(l10n.deleteEntriesConfirmation(1)), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text(l10n.actionCancel));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Polish strength graph controls fit narrow scaled layout', (
    tester,
  ) async {
    const locale = Locale('pl');
    final l10n = lookupAppLocalizations(locale);
    final harness = await FlexifyTestHarness.create();
    const exercise = 'User entered press';
    final now = DateTime.now().toLocal();

    await harness.pump(
      tester,
      StrengthPage(
        name: exercise,
        unit: 'kg',
        data: [
          StrengthData(
            created: now.subtract(const Duration(days: 1)),
            reps: 8,
            unit: 'kg',
            value: 90,
          ),
          StrengthData(created: now, reps: 6, unit: 'kg', value: 95),
        ],
        tabCtrl: MockTabController(),
      ),
      locale: locale,
      surfaceSize: _narrowSurface,
      textScaler: _largeText,
    );
    await tester.pumpAndSettle();

    expect(find.text(exercise), findsWidgets);
    expect(find.text(l10n.bestWeight), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Polish timer actions fit narrow scaled layout', (tester) async {
    const locale = Locale('pl');
    final l10n = lookupAppLocalizations(locale);
    final harness = await FlexifyTestHarness.create();
    final timerState = harness.timerState;

    await harness.pump(
      tester,
      const TimerPage(),
      locale: locale,
      surfaceSize: _narrowSurface,
      textScaler: _largeText,
    );
    await tester.pumpAndSettle();

    await timerState.startTimer(
      'User timer title',
      const Duration(seconds: 10),
      '',
      false,
      true,
    );
    await tester.pump();

    expect(find.text(l10n.actionStop), findsOneWidget);
    expect(tester.takeException(), isNull);

    await timerState.stopTimer();
    timerState.dispose();
  });

  testWidgets('Polish notification copy is wired into timer state', (
    tester,
  ) async {
    const locale = Locale('pl');
    final l10n = lookupAppLocalizations(locale);
    final timerState = _RecordingTimerState();
    final harness = await FlexifyTestHarness.create(timerState: timerState);
    await harness.database.settings.update().write(
      const SettingsCompanion(localeOverride: Value('pl')),
    );
    final settings = await (harness.database.settings.select()..limit(1))
        .getSingle();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<SettingsState>.value(value: settings),
          ChangeNotifierProvider<TimerState>.value(value: timerState),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(timerState.notificationLocalizations, {
      'timerUpTitle': l10n.timerUp,
      'openNotificationLabel': l10n.openNotification,
      'stopLabel': l10n.actionStop,
      'addOneMinuteLabel': l10n.addOneMinuteNotification,
      'restTimerTitle': l10n.restTimer,
      'timerChannelName': l10n.timerChannelName,
      'timerChannelDescription': l10n.timerChannelDescription,
      'timerFinishedChannelName': l10n.timerFinishedChannelName,
      'timerFinishedChannelDescription': l10n.timerFinishedChannelDescription,
      'timerFinishedTitle': l10n.timerFinished,
      'exactAlarmRequestUnavailable': l10n.exactAlarmRequestUnavailable,
    });
    expect(tester.takeException(), isNull);
  });

  testWidgets('Japanese session set chips fit narrow scaled layout', (
    tester,
  ) async {
    const locale = Locale('ja');
    final l10n = lookupAppLocalizations(locale);
    final harness = await FlexifyTestHarness.create();
    const exercise = 'User entered exercise';
    final planId = await harness.database.plans.insertOne(planFixture());
    await harness.database.gymSets.insertOne(
      gymSetFixture(
        exercise,
        planId: planId,
        reps: 12,
        weight: 102.5,
        created: DateTime.now().toLocal(),
      ),
    );

    await harness.pump(
      tester,
      Scaffold(
        body: SessionSets(exercise: exercise, planId: planId),
      ),
      locale: locale,
      surfaceSize: _narrowSurface,
      textScaler: _largeText,
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.setNumber(1)), findsOneWidget);
    expect(find.text(exercise), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
