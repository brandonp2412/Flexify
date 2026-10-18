import 'package:drift/drift.dart' hide Column;
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/graphs_page.dart';
import 'package:flexify/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('tab dock hides on nested pages and returns when popped', (
    tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await harness.database.settings.update().write(
      const SettingsCompanion(tabs: Value('GraphsPage')),
    );
    await harness.pump(
      tester,
      const HomePage(),
      surfaceSize: const Size(360, 780),
    );
    await tester.pumpAndSettle();
    expect(find.byType(BottomNav), findsOneWidget);

    final graphs = tester.state<GraphsPageState>(find.byType(GraphsPage));
    graphs.navKey.currentState!.push(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Text('Nested details')),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Nested details'), findsOneWidget);
    expect(find.byType(BottomNav), findsNothing);

    graphs.navKey.currentState!.pop();
    await tester.pumpAndSettle();
    expect(find.byType(BottomNav), findsOneWidget);
  });
}
