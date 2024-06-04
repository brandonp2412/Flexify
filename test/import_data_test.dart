import 'package:flexify/import_data.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  testWidgets('ImportData', (WidgetTester tester) async {
    await mockTests();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) => ImportData(
              pageContext: context,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Import data'));
    await tester.pumpAndSettle();
    expect(find.text('Graphs'), findsOne);
    expect(find.text('Plans'), findsOne);
    expect(find.text('Database'), findsOne);

    await db.close();
  });
}
