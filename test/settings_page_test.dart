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
  testWidgets('SettingsPage', (WidgetTester tester) async {
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

    expect(find.text('Settings'), findsOne);
    expect(find.text('Search...'), findsOne);
    expect(find.textContaining('Long date format'), findsOne);
    expect(find.textContaining('Short date format'), findsOne);
    expect(find.textContaining('Maximum sets'), findsOne);
    expect(find.textContaining('Rest minutes'), findsOne);
    expect(find.textContaining('Rest timers'), findsOne);
    expect(find.textContaining('Vibrate'), findsOne);
    expect(find.textContaining('Show units'), findsOne);

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
    await tester.tap(find.text('Vibrate'));
    await tester.pump();

    await db.close();
  });
}
