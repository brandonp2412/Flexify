import 'package:drift/drift.dart' hide isNull;
import 'package:flexify/category/category_exercises_page.dart';
import 'package:flexify/database/categories.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_catalog.dart';
import 'package:flexify/home_page.dart';
import 'package:flexify/settings/category_management_page.dart';
import 'package:flexify/settings/tab_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

Future<String> _storedTabs(FlexifyTestHarness harness) async =>
    (await harness.database.settings.select().getSingle()).tabs;

void main() {
  testWidgets('Categories is not one of the default tabs', (tester) async {
    final harness = await FlexifyTestHarness.create();

    expect(
      (await _storedTabs(harness)).split(','),
      isNot(contains('CategoriesPage')),
    );
  });

  testWidgets('tab settings list Categories last and off by default', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await harness.pump(tester, const TabSettings());
    await tester.pumpAndSettle();

    final categories = find.widgetWithText(ListTile, 'Categories');
    expect(categories, findsOneWidget);
    expect(
      tester
          .widget<Switch>(
            find.descendant(of: categories, matching: find.byType(Switch)),
          )
          .value,
      isFalse,
    );
    for (final label in ['History', 'Plans', 'Graphs', 'Timer', 'Settings']) {
      expect(
        tester.getTopLeft(find.widgetWithText(ListTile, label)).dy,
        lessThan(tester.getTopLeft(categories).dy),
        reason: '$label should be listed before Categories',
      );
    }

    await tester.tap(categories);
    await tester.pumpAndSettle();

    expect((await _storedTabs(harness)).split(',').last, 'CategoriesPage');
  });

  testWidgets('the Categories tab opens when it is enabled', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await harness.database.settings.update().write(
      const SettingsCompanion(tabs: Value('HistoryPage,CategoriesPage')),
    );
    await harness.pump(tester, const HomePage());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('CategoriesPage')));
    await tester.pumpAndSettle();

    expect(find.byType(CategoryManagementPage), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);
  });

  testWidgets('browse a category from the tab', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    for (final name in ['Reverse fly', 'Row']) {
      await createExerciseDefinition(
        name: name,
        cardio: false,
        displayUnit: 'kg',
        category: 'Mine',
      );
    }
    await createCategory('Empty');
    await harness.pump(tester, const CategoryManagementPage(asTab: true));
    await tester.pumpAndSettle();

    expect(find.text('Categories'), findsOneWidget);
    await tester.tap(find.widgetWithText(ListTile, 'Mine'));
    await tester.pumpAndSettle();

    expect(find.byType(CategoryExercisesPage), findsOneWidget);
    expect(find.text('Reverse fly'), findsOneWidget);
    expect(find.text('Row'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Empty'));
    await tester.pumpAndSettle();
    expect(find.text('No exercises found'), findsOneWidget);
  });

  testWidgets('category management from settings keeps its own title', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await createCategory('Back');
    await harness.pump(tester, const CategoryManagementPage());
    await tester.pumpAndSettle();

    expect(find.text('Manage categories'), findsOneWidget);
    await tester.tap(find.widgetWithText(ListTile, 'Back'));
    await tester.pumpAndSettle();
    expect(find.byType(CategoryExercisesPage), findsNothing);
  });
}
