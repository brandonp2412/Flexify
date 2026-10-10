import 'package:flexify/database/exercise_set_repository.dart';
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
      await insertExerciseSetFixture(
        harness.database,
        'Graph history test',
        reps: 2,
        weight: 3,
        created: testNow.subtract(const Duration(days: 1)),
      );
      await insertExerciseSetFixture(
        harness.database,
        'Graph history test',
        reps: 4,
        weight: 5,
        created: testNow,
      );
      final sets = (await getExerciseSets(
        harness.database,
        search: 'Graph history test',
      )).where((set) => set.name == 'Graph history test').toList();
      final tabController = MockTabController();
      addTearDown(tabController.dispose);

      await harness.pump(
        tester,
        GraphHistoryPage(
          name: 'Graph history test',
          initialSets: sets,
          tabController: tabController,
        ),
      );
      await tester.pumpAndSettle();

      final list = tester.widget<ListView>(find.byType(ListView));
      expect((list.padding! as EdgeInsets).top, 0);
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

      final remaining = (await getExerciseSets(
        harness.database,
        search: 'Graph history test',
      )).where((set) => set.name == 'Graph history test');
      expect(remaining, isEmpty);
      expect(find.text('No history yet for Graph history test'), findsOne);
    },
  );
  testWidgets(
    'refresh keeps exact exercise history when similar names are newer',
    (WidgetTester tester) async {
      final harness = await FlexifyTestHarness.create();
      final exact = await insertExerciseSetFixture(
        harness.database,
        'Press',
        reps: 5,
        weight: 100,
        created: testNow.subtract(const Duration(days: 30)),
      );
      for (var i = 0; i < 25; i++) {
        await insertExerciseSetFixture(
          harness.database,
          'Bench Press',
          reps: i + 1,
          weight: 50 + i.toDouble(),
          created: testNow.subtract(Duration(minutes: i)),
        );
      }

      final initialSets = await getExerciseSetsForExercise(
        harness.database,
        exerciseName: 'Press',
      );
      expect(initialSets.map((set) => set.id), contains(exact.id));

      final tabController = TabController(
        length: 4,
        initialIndex: 1,
        vsync: tester,
      );
      addTearDown(tabController.dispose);

      await harness.pump(
        tester,
        GraphHistoryPage(
          name: 'Press',
          initialSets: initialSets,
          tabController: tabController,
        ),
      );
      tabController.animateTo(2, duration: const Duration(milliseconds: 1));
      await tester.pumpAndSettle();

      expect(find.text('5 x 100 kg'), findsOneWidget);
      expect(find.text('No history yet for Press'), findsNothing);
    },
  );
}
