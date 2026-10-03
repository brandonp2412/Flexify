import 'package:flexify/database/performed_sets.dart';
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
      await insertPerformedSetFixture(
        harness.database,
        'Graph history test',
        reps: 2,
        weight: 3,
        created: testNow.subtract(const Duration(days: 1)),
      );
      await insertPerformedSetFixture(
        harness.database,
        'Graph history test',
        reps: 4,
        weight: 5,
        created: testNow,
      );
      final sets = (await getPerformedSets(
        harness.database,
        search: 'Graph history test',
      )).where((set) => set.name == 'Graph history test').toList();
      final tabController = MockTabController();
      addTearDown(tabController.dispose);

      await harness.pump(
        tester,
        GraphHistoryPage(
          name: 'Graph history test',
          performedSets: sets,
          tabController: tabController,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('2 x 3 kg'), findsOne);
      expect(find.text('4 x 5 kg'), findsOne);
      await tester.longPress(find.text('4 x 5 kg'));
      await tester.pumpAndSettle();
      expect(find.text('1 selected'), findsOne);

      await tester.tap(find.text('2 x 3 kg'));
      await tester.pumpAndSettle();
      expect(find.text('2 selected'), findsOne);
      expect(find.byTooltip('Edit selected'), findsOne);

      await tester.tap(find.byTooltip('Delete selected'));
      await tester.pumpAndSettle();
      expect(find.text('Confirm Delete'), findsOne);

      await tester.tap(find.widgetWithText(TextButton, 'Delete'));
      await tester.pumpAndSettle();

      final remaining = (await getPerformedSets(
        harness.database,
        search: 'Graph history test',
      )).where((set) => set.name == 'Graph history test');
      expect(remaining, isEmpty);
      expect(find.text('No history yet for Graph history test'), findsOne);
    },
  );
}
