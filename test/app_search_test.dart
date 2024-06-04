import 'package:flexify/app_search.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  await mockTests();

  testWidgets('AppSearch', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: AppSearch(
              onChange: (p0) => null,
              onClear: () => null,
              onDelete: () => null,
              onEdit: () => null,
              onSelect: () => null,
              selected: const {},
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Search...'), findsOne);

    final menu = find.byTooltip("Show menu");
    await tester.tap(menu);
    await tester.pumpAndSettle();
    expect(find.text("Select all"), findsOne);
  });
}
