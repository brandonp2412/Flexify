import 'package:flexify/database/database.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/plan/plans_list.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  await mockTests();

  testWidgets('PlanList', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: PlansList(
              plans: const [
                Plan(
                  days: "Monday",
                  id: 1,
                  sequence: 2,
                  exercises: "Bench press",
                ),
              ],
              onSelect: (value) {},
              selected: const {},
              navigatorKey: GlobalKey(),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Bench press'), findsOne);
  });
}
