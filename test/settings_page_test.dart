import 'package:flexify/main.dart';
import 'package:flexify/plan_state.dart';
import 'package:flexify/settings_page.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/timer_state.dart';
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

    await tester.enterText(find.bySemanticsLabel('Search...'), 'Rest timers');
    await tester.pump();

    expect(find.textContaining('Theme'), findsNothing);
    expect(find.textContaining('Rest timers'), findsNWidgets(2));

    await db.close();
  });

  testWidgets('SettingsPage changes', (WidgetTester tester) async {
    await render(tester);

    await tester.tap(find.text('System'));
    await tester.pump();
    await tester.tap(find.text('Light'));
    await tester.pump();
    expect(find.text('Light'), findsOne);

    await tester.enterText(find.bySemanticsLabel('Maximum sets'), '5');
    await tester.pump();
    expect(find.text('5'), findsOne);

    await tester.enterText(find.bySemanticsLabel('Rest minutes'), '6');
    await tester.pump();
    expect(find.text('6'), findsOne);

    await tester.enterText(find.bySemanticsLabel('seconds'), '7');
    await tester.pump();
    expect(find.text('7'), findsOne);

    await tester.tap(find.text('Rest timers'));
    await tester.pump();

    await tester.enterText(find.bySemanticsLabel('Search...'), 'Vibrate');
    await tester.pump();
    await tester.tap(find.widgetWithText(ListTile, 'Vibrate'));

    await tester.enterText(find.bySemanticsLabel('Search...'), 'Show units');
    await tester.pump();
    await tester.tap(find.widgetWithText(ListTile, 'Show units'));

    await db.close();
  });
}
