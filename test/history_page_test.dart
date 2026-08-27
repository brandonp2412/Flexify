import 'package:flexify/sets/history_page.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tab_controller.dart';
import 'support/fixtures.dart';
import 'support/test_app.dart';

Future<void> pumpHistoryPage(
  WidgetTester tester,
  FlexifyTestHarness harness,
) async {
  await harness.pump(
    tester,
    HistoryPage(tabController: MockTabController()),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('HistoryPage loads', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await pumpHistoryPage(tester, harness);

    expect(find.text('Search history...'), findsOne);
    expect(find.text('No entries yet'), findsOne);
  });

  testWidgets('HistoryPage lists items', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.database.gymSets.insertAll([
      gymSetFixture('Bench press', reps: 1, weight: 90),
      gymSetFixture(
        'Bench press',
        reps: 4,
        weight: 80,
        created: testNow.subtract(const Duration(minutes: 3)),
      ),
      gymSetFixture(
        'Bench press',
        reps: 8,
        weight: 70,
        created: testNow.subtract(const Duration(minutes: 6)),
      ),
    ]);

    await pumpHistoryPage(tester, harness);

    expect(find.text('Bench press'), findsNWidgets(3));
    expect(find.text('1 x 90 kg'), findsOne);
    expect(find.text('4 x 80 kg'), findsOne);
    expect(find.text('8 x 70 kg'), findsOne);
  });

  testWidgets('HistoryPage keeps cardio weight when history is grouped', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await harness.database.gymSets.insertOne(
      gymSetFixture(
        'Sled push',
        reps: 0,
        weight: 30,
        cardio: true,
        duration: 10,
      ),
    );
    await harness.database.settings.update().write(
      testSettings(groupHistory: true),
    );

    await pumpHistoryPage(tester, harness);
    await tester.tap(find.text('Sled push (1)'));
    await tester.pumpAndSettle();

    expect(find.text('30 kg / 10:00 '), findsOne);
  });

  testWidgets('HistoryPage tap tile', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.database.gymSets.insertOne(
      gymSetFixture('Bench press', reps: 1, weight: 90),
    );

    await pumpHistoryPage(tester, harness);
    await tester.tap(find.textContaining('Bench press'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Weight (kg)'), findsOne);
    expect(find.textContaining('Reps'), findsOne);
    expect(find.textContaining('Name'), findsOne);
  });

  testWidgets('HistoryPage settings', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await pumpHistoryPage(tester, harness);

    await tester.tap(find.byTooltip('Show menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOne);
  });

  testWidgets('HistoryPage selects', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.database.gymSets.insertOne(
      gymSetFixture('Bench press', reps: 1, weight: 90),
    );

    await pumpHistoryPage(tester, harness);
    await tester.longPress(find.text('1 x 90 kg'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Delete selected'), findsOne);
  });

  testWidgets('HistoryPage deletes', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.database.gymSets.insertOne(
      gymSetFixture('Bench press', reps: 1, weight: 90),
    );

    await pumpHistoryPage(tester, harness);
    await tester.longPress(find.text('1 x 90 kg'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Delete selected'));
    await tester.pumpAndSettle();
    expect(find.text('Confirm Delete'), findsOne);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Search history...'), findsOne);
  });
}
