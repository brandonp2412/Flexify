import 'package:drift/drift.dart' hide Column;
import 'package:flex/bottom_nav.dart';
import 'package:flex/database/database.dart';
import 'package:flex/plan/plans_page.dart';
import 'package:flex/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('tab dock stays visible on nested pages', (tester) async {
    final harness = await FlexTestHarness.create();
    await harness.database.settings.update().write(
      const SettingsCompanion(tabs: Value('PlansPage')),
    );
    await harness.pump(
      tester,
      const HomePage(),
      surfaceSize: const Size(360, 780),
    );
    await tester.pumpAndSettle();
    expect(find.byType(BottomNav), findsOneWidget);

    final plans = tester.state<PlansPageState>(find.byType(PlansPage));
    plans.navKey.currentState!.push(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Text('Start Plan')),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Start Plan'), findsOneWidget);
    expect(find.byType(BottomNav), findsOneWidget);

    plans.navKey.currentState!.pop();
    await tester.pumpAndSettle();
    expect(find.byType(BottomNav), findsOneWidget);
  });
}
