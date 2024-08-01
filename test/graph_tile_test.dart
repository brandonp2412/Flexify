import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/graph_tile.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  testWidgets('GraphTile', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(executor: NativeDatabase.memory(), logStatements: false);
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: getTestProviders(settings),
        child: MaterialApp(
          home: Scaffold(
            body: GraphTile(
              onSelect: (value) => null,
              selected: const {},
              gymSet: GymSetsCompanion(
                name: const Value("Bench press"),
                created: Value(DateTime.now()),
                reps: const Value(5),
                weight: const Value(20),
                cardio: const Value(false),
                unit: const Value('kg'),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Bench press'), findsOne);
    expect(find.text('5 x 20 kg'), findsOne);

    await db.close();
  });
}
