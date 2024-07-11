import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings/settings_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  render(WidgetTester tester) async {
    await mockTests();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: SettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SettingsPage searches', (WidgetTester tester) async {
    await render(tester);
    expect(find.text('Settings'), findsOne);
    expect(find.text('Search...'), findsOne);

    await tester.enterText(find.bySemanticsLabel('Search...'), 'Show units');
    await tester.pumpAndSettle();

    expect(find.textContaining('Theme'), findsNothing);
    expect(find.widgetWithText(ListTile, 'Show units'), findsOne);

    await db.close();
  });

  testWidgets('SettingsPage changes', (WidgetTester tester) async {
    await render(tester);

    await tester.tap(find.text('System'));
    await tester.pump();
    await tester.tap(find.text('Light'));
    await tester.pump();
    expect(find.text('Light'), findsOne);

    await tester.enterText(find.bySemanticsLabel('Sets per exercise'), '5');
    await tester.pump();
    expect(find.text('5'), findsOne);

    await tester.enterText(find.bySemanticsLabel('Search...'), 'Show units');
    await tester.pump();
    await tester.tap(
      find.widgetWithText(ListTile, 'Show units'),
      warnIfMissed: false,
    );

    await db.close();
  });
}
