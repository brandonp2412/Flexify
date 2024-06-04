import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/strength/strength_page.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  testWidgets('StrengthPage displays', (WidgetTester tester) async {
    await mockTests();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: StrengthPage(
            name: 'Dumbbell shoulder press',
            unit: 'kg',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Dumbbell shoulder press'), findsOne);
    expect(find.text('Metric'), findsOne);
    expect(find.text('Day'), findsOne);
    expect(find.text('Start date'), findsOne);
    expect(find.text('Stop date'), findsOne);
    expect(find.byTooltip('Edit'), findsOne);
    expect(find.byType(LineChart), findsOne);

    await db.close();
  });

  testWidgets('StrengthPage edits', (WidgetTester tester) async {
    await mockTests();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: StrengthPage(
            name: 'Dumbbell shoulder press',
            unit: 'kg',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    final edit = find.byTooltip('Edit');
    await tester.tap(edit);
    await tester.pumpAndSettle();
    expect(find.text('Edit dumbbell shoulder press'), findsOne);

    await db.close();
  });

  testWidgets('StrengthPage selects metrics', (WidgetTester tester) async {
    await mockTests();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: StrengthPage(
            name: 'Dumbbell shoulder press',
            unit: 'kg',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Best weight'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Best reps'));
    await tester.pumpAndSettle();
    expect(find.byType(LineChart), findsOne);

    await tester.tap(find.text('Best reps'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('One rep max'));
    await tester.pumpAndSettle();
    expect(find.byType(LineChart), findsOne);

    await tester.tap(find.text('One rep max'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Volume'));
    await tester.pumpAndSettle();
    expect(find.byType(LineChart), findsOne);

    await db.close();
  });
}
