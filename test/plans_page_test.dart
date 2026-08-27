import 'package:flexify/plan/plans_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tab_controller.dart';
import 'support/test_app.dart';

Future<void> pumpPlansPage(
  WidgetTester tester,
  FlexifyTestHarness harness,
) async {
  await harness.pump(
    tester,
    PlansPage(tabController: MockTabController()),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('PlansPage lists items', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await pumpPlansPage(tester, harness);

    expect(find.text('Search plans...'), findsOne);
    expect(find.byType(ListTile), findsWidgets);
  });

  testWidgets('PlansPage add button', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await pumpPlansPage(tester, harness);

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Save'), findsOne);
  });

  testWidgets('PlansPage tap tile', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await pumpPlansPage(tester, harness);

    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();

    expect(find.text('Save'), findsOne);
  });

  testWidgets('PlansPage settings', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await pumpPlansPage(tester, harness);

    await tester.tap(find.byTooltip('Show menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOne);
  });

  testWidgets('PlansPage selects', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await pumpPlansPage(tester, harness);

    await tester.longPress(find.byType(ListTile).first);
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOne);
  });

  testWidgets('PlansPage deletes', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await pumpPlansPage(tester, harness);

    await tester.longPress(find.byType(ListTile).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Delete selected'));
    await tester.pumpAndSettle();

    expect(find.text('Confirm Delete'), findsOne);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Search plans...'), findsOne);
  });
}
