import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/sets/history_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  await mockTests();

  testWidgets('HistoryList', (WidgetTester tester) async {
    db = AppDatabase(executor: NativeDatabase.memory(), logStatements: false);
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: getTestProviders(settings),
        child: MaterialApp(
          home: Scaffold(
            body: HistoryList(
              gymSets: [
                GymSet(
                  id: 1,
                  name: 'Bench press',
                  reps: 2,
                  weight: 3,
                  unit: 'kg',
                  created: DateTime.now(),
                  hidden: false,
                  bodyWeight: 54,
                  duration: 8,
                  distance: 9,
                  cardio: false,
                ),
              ],
              onNext: () {},
              onSelect: (value) {},
              selected: const {},
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Bench press'), findsOne);
    expect(find.text('2 x 3 kg'), findsOne);

    await db.close();
  });
}
