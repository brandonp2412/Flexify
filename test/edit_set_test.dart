import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  testWidgets('EditGymSet inserts', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(executor: NativeDatabase.memory(), logStatements: false);
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: getTestProviders(settings),
        child: MaterialApp(
          home: EditSetPage(
            gymSet: GymSet(
              id: 0,
              name: "Bench press",
              reps: 2,
              weight: 3,
              unit: 'kg',
              created: DateTime.now(),
              hidden: false,
              bodyWeight: 52,
              duration: 3,
              distance: 6,
              cardio: false,
            ),
          ),
        ),
      ),
    );

    expect(find.text("Bench press"), findsOne);

    final button = find.byTooltip("Save");
    expect(button, findsOne);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Bench press'), findsNothing);

    await db.close();
  });

  testWidgets('EditGymSet updates', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(executor: NativeDatabase.memory(), logStatements: false);
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: getTestProviders(settings),
        child: MaterialApp(
          home: EditSetPage(
            gymSet: GymSet(
              id: 1,
              name: "Bench press",
              reps: 2,
              weight: 3,
              unit: 'kg',
              created: DateTime.now(),
              hidden: false,
              bodyWeight: 52,
              duration: 3,
              distance: 6,
              cardio: false,
            ),
          ),
        ),
      ),
    );

    expect(find.text("Bench press"), findsNWidgets(2));

    final button = find.byTooltip("Save");
    expect(button, findsOne);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Bench press'), findsNothing);

    await db.close();
  });
}
