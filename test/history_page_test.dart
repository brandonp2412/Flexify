import 'package:flexify/sets/history_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tab_controller.dart';
import 'support/fixtures.dart';
import 'support/test_app.dart';

import 'package:drift/drift.dart';

Future<void> pumpHistoryPage(
  WidgetTester tester,
  FlexifyTestHarness harness, {
  Size? surfaceSize,
}) async {
  await harness.pump(
    tester,
    HistoryPage(tabController: MockTabController()),
    surfaceSize: surfaceSize,
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
    await insertExerciseSetFixture(
      harness.database,
      'Bench press',
      reps: 1,
      weight: 90,
    );
    await insertExerciseSetFixture(
      harness.database,
      'Bench press',
      reps: 4,
      weight: 80,
      created: testNow.subtract(const Duration(minutes: 3)),
    );
    await insertExerciseSetFixture(
      harness.database,
      'Bench press',
      reps: 8,
      weight: 70,
      created: testNow.subtract(const Duration(minutes: 6)),
    );

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
    await insertExerciseSetFixture(
      harness.database,
      'Sled push',
      reps: 0,
      weight: 30,
      cardio: true,
      duration: 10,
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
    await insertExerciseSetFixture(
      harness.database,
      'Bench press',
      reps: 1,
      weight: 90,
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

  testWidgets('HistoryPage exposes desktop row actions on secondary click', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await insertExerciseSetFixture(
      harness.database,
      'Desktop row',
      reps: 5,
      weight: 90,
    );

    await pumpHistoryPage(tester, harness, surfaceSize: const Size(1200, 800));
    final gesture = await tester.startGesture(
      tester.getCenter(find.text('5 x 90 kg')),
      kind: PointerDeviceKind.mouse,
      buttons: kSecondaryMouseButton,
    );
    await gesture.up();
    await tester.pumpAndSettle();

    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
  });

  testWidgets('HistoryPage selects', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await insertExerciseSetFixture(
      harness.database,
      'Bench press',
      reps: 1,
      weight: 90,
    );

    await pumpHistoryPage(tester, harness);
    await tester.longPress(find.text('1 x 90 kg'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Delete selected'), findsOne);
  });

  testWidgets('HistoryPage deletes', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await insertExerciseSetFixture(
      harness.database,
      'Bench press',
      reps: 1,
      weight: 90,
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

  testWidgets(
    'HistoryPage select all includes every filtered row, not just loaded rows',
    (WidgetTester tester) async {
      final harness = await FlexifyTestHarness.create();
      for (var i = 0; i < 150; i++) {
        await insertExerciseSetFixture(
          harness.database,
          'Bench press',
          reps: i + 1,
          weight: 50,
          created: testNow.subtract(Duration(minutes: i)),
        );
      }
      for (var i = 0; i < 10; i++) {
        await insertExerciseSetFixture(
          harness.database,
          'Squat',
          reps: i + 1,
          weight: 100,
          created: testNow.subtract(Duration(days: 1, minutes: i)),
        );
      }

      await pumpHistoryPage(tester, harness);
      final searchField = find.descendant(
        of: find.byType(SearchBar),
        matching: find.byType(EditableText),
      );
      await tester.enterText(searchField, 'Bench');
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Show menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Select all'));
      await tester.pumpAndSettle();

      expect(find.text('150'), findsOne);
    },
  );

  testWidgets(
    'HistoryPage can clear selection without clearing the search filter',
    (WidgetTester tester) async {
      final harness = await FlexifyTestHarness.create();
      await insertExerciseSetFixture(
        harness.database,
        'Bench press',
        reps: 5,
        weight: 50,
      );
      await insertExerciseSetFixture(
        harness.database,
        'Squat',
        reps: 5,
        weight: 100,
      );

      await pumpHistoryPage(tester, harness);
      final searchBar = find.byType(SearchBar);
      final searchField = find.descendant(
        of: searchBar,
        matching: find.byType(EditableText),
      );
      await tester.enterText(searchField, 'Bench');
      await tester.pumpAndSettle();
      expect(find.text('Squat'), findsNothing);

      await tester.longPress(find.text('5 x 50 kg'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Show menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Clear selection'));
      await tester.pumpAndSettle();

      final widget = tester.widget<SearchBar>(searchBar);
      expect(widget.controller?.text, 'Bench');
      expect(find.text('Squat'), findsNothing);
      expect(find.byTooltip('Delete selected'), findsNothing);
    },
  );
}
