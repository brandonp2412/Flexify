import 'package:flexify/plan_state.dart';
import 'package:flexify/settings_page.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  await mockTests();

  testWidgets('SettingsPage', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SettingsPage(),
          ),
        ),
      ),
    );

    expect(find.text('Settings'), findsOne);
    expect(find.text('Search...'), findsOne);
    expect(find.textContaining('Long date format'), findsOne);
    expect(find.textContaining('Short date format'), findsOne);
    expect(find.textContaining('Maximum sets'), findsOne);
    expect(find.textContaining('Rest minutes'), findsOne);
    expect(find.textContaining('Rest timers'), findsOne);
    expect(find.textContaining('Vibrate'), findsOne);
    expect(find.textContaining('Show units'), findsOne);
  });
}
