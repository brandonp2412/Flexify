import 'package:drift/drift.dart';
import 'package:flexify/graph/graph_history_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tab_controller.dart';
import 'support/fixtures.dart';
import 'support/test_app.dart';

void main() {
  testWidgets(
    'long press selects multiple graph history rows and deletes them',
    (WidgetTester tester) async {
      final harness = await FlexifyTestHarness.create();
      await harness.database
          .into(harness.database.gymSets)
          .insert(
            gymSetFixture(
              'Graph history test',
              reps: 2,
              weight: 3,
              created: testNow.subtract(const Duration(days: 1)),
            ),
          );
      await harness.database
          .into(harness.database.gymSets)
          .insert(
            gymSetFixture(
              'Graph history test',
              reps: 4,
              weight: 5,
              created: testNow,
            ),
          );
      final sets =
          await (harness.database.gymSets.select()
                ..where((row) => row.name.equals('Graph history test'))
                ..orderBy([(row) => OrderingTerm.desc(row.created)]))
              .get();
      final tabController = MockTabController();
      addTearDown(tabController.dispose);

      await harness.pump(
        tester,
        GraphHistoryPage(
          name: 'Graph history test',
          gymSets: sets,
          tabController: tabController,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsNWidgets(2));
      await tester.longPress(find.byType(ListTile).first);
      await tester.pumpAndSettle();
      expect(find.text('1 selected'), findsOne);

      await tester.tap(find.byType(ListTile).last);
      await tester.pumpAndSettle();
      expect(find.text('2 selected'), findsOne);
      expect(find.byKey(const ValueKey('editGraphHistorySelection')), findsOne);

      await tester.tap(
        find.byKey(const ValueKey('deleteGraphHistorySelection')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Confirm Delete'), findsOne);

      await tester.tap(find.widgetWithText(TextButton, 'Delete'));
      await tester.pumpAndSettle();

      final remaining =
          await (harness.database.gymSets.select()
                ..where((row) => row.name.equals('Graph history test')))
              .get();
      expect(remaining, isEmpty);
      expect(find.text('No history yet for Graph history test'), findsOne);
    },
  );
}
