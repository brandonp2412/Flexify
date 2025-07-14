import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/graphs_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  testWidgets('GraphsPage lists items', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(NativeDatabase.memory());
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
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
    db = AppDatabase(NativeDatabase.memory());
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: GraphsPage(),
        ),
      ),
    );

    final add = find.text('Add');
    await tester.tap(add);
    await tester.pumpAndSettle();

    await db.close();
  });

  testWidgets('GraphsPage taps barbell bench press',
      (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(NativeDatabase.memory());

    // Add non-hidden workout data for the test
    await db.gymSets.insertOne(
      GymSetsCompanion.insert(
        name: 'Barbell bench press',
        reps: 10,
        weight: 100,
        unit: 'kg',
        created: DateTime.now().toLocal(),
        hidden: const Value(false),
        category: const Value('Chest'),
      ),
    );

    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: DefaultTabController(length: 1, child: GraphsPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Barbell bench press'));
    await tester.pumpAndSettle();
    expect(find.text('Best weight'), findsOne);

    await db.close();
  });

  testWidgets('GraphsPage taps global progress', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(NativeDatabase.memory());
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: DefaultTabController(length: 1, child: GraphsPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Global progress'));
    await tester.pumpAndSettle();
    expect(find.text('Best weight'), findsOne);

    await db.close();
  });

  testWidgets('GraphsPage settings', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(NativeDatabase.memory());
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
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
    db = AppDatabase(NativeDatabase.memory());

    // Add non-hidden workout data for the test
    await db.gymSets.insertOne(
      GymSetsCompanion.insert(
        name: 'Barbell bent-over row',
        reps: 8,
        weight: 80,
        unit: 'kg',
        created: DateTime.now().toLocal(),
        hidden: const Value(false),
        category: const Value('Back'),
      ),
    );

    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: GraphsPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.longPress(find.text('Barbell bent-over row'));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOne);

    await db.close();
  });

  testWidgets('GraphsPage deletes', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(NativeDatabase.memory());

    // Add non-hidden workout data for the test
    await db.gymSets.insertOne(
      GymSetsCompanion.insert(
        name: 'Back extension',
        reps: 12,
        weight: 50,
        unit: 'kg',
        created: DateTime.now().toLocal(),
        hidden: const Value(false),
        category: const Value('Back'),
      ),
    );

    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: GraphsPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.longPress(find.text('Back extension'));
    await tester.pumpAndSettle();

    final delete = find.byTooltip('Delete selected');
    await tester.tap(delete);
    await tester.pumpAndSettle();

    expect(find.text('Confirm Delete'), findsOne);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Back extension'), findsNothing);

    await db.close();
  });
}
