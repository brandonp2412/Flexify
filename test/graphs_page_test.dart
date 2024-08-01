import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/graphs_page.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  testWidgets('GraphsPage lists items', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(executor: NativeDatabase.memory(), logStatements: false);
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: getTestProviders(settings),
        child: const MaterialApp(
          home: GraphsPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Search...'), findsOne);
    expect(find.byType(ListTile), findsWidgets);

    await db.close();
  });

  testWidgets('GraphsPage add button', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(executor: NativeDatabase.memory(), logStatements: false);
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: getTestProviders(settings),
        child: const MaterialApp(
          home: GraphsPage(),
        ),
      ),
    );

    final add = find.byTooltip('Add');
    await tester.tap(add);
    await tester.pumpAndSettle();

    await db.close();
  });

  testWidgets('GraphsPage tap tile', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(executor: NativeDatabase.memory(), logStatements: false);
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: getTestProviders(settings),
        child: const MaterialApp(
          home: GraphsPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    final tile = find.byType(ListTile).first;
    await tester.tap(tile);
    await tester.pumpAndSettle();
    expect(find.byTooltip('Edit'), findsOne);

    await db.close();
  });

  testWidgets('GraphsPage settings', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(executor: NativeDatabase.memory(), logStatements: false);
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: getTestProviders(settings),
        child: const MaterialApp(
          home: GraphsPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    final menu = find.byTooltip('Show menu');
    await tester.tap(menu);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOne);

    await db.close();
  });

  testWidgets('GraphsPage selects', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(executor: NativeDatabase.memory(), logStatements: false);
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: getTestProviders(settings),
        child: const MaterialApp(
          home: GraphsPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    final tile = find.byType(ListTile).first;
    await tester.longPress(tile);
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOne);

    await db.close();
  });

  testWidgets('GraphsPage deletes', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(executor: NativeDatabase.memory(), logStatements: false);
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: getTestProviders(settings),
        child: const MaterialApp(
          home: GraphsPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    final tile = find.byType(ListTile).first;

    await tester.longPress(tile);
    await tester.pumpAndSettle();

    final delete = find.byTooltip('Delete selected');
    await tester.tap(delete);
    await tester.pumpAndSettle();

    expect(find.text('Confirm Delete'), findsOne);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Search...'), findsOne);

    await db.close();
  });
}
