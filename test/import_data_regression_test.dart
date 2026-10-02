import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/l10n/generated/app_localizations.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_tile.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  await mockTests();

  testWidgets('PlanTile refreshes its exercise list after db is swapped and '
      'dbVersion bumps, without the widget being remounted (#315)', (
    WidgetTester tester,
  ) async {
    final oldDb = testDb();
    await oldDb.planExercises.deleteAll();
    await oldDb.plans.deleteAll();
    await oldDb.plans.insertOne(
      PlansCompanion.insert(id: const Value(1), days: 'Monday'),
    );
    final oldBench =
        await (oldDb.exercises.select()
              ..where((exercise) => exercise.name.equals('Bench press')))
            .getSingleOrNull() ??
        await oldDb.exercises.insertReturning(
          ExercisesCompanion.insert(
            name: 'Bench press',
            kind: 'strength',
            displayUnit: 'kg',
          ),
        );
    await oldDb.planExercises.insertOne(
      PlanExercisesCompanion.insert(
        planId: 1,
        exerciseId: oldBench.id,
        enabled: true,
      ),
    );
    db = oldDb;

    final settings = await (db.settings.select()..limit(1)).getSingle();

    await tester.pumpWidget(
      MultiProvider(
        providers: [Provider<SettingsState>.value(value: settings)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: PlanTile(
              plan: Plan(days: 'Monday', id: 1, sequence: null, title: null),
              weekday: 'Monday',
              index: 0,
              navigatorKey: GlobalKey<NavigatorState>(),
              selected: const {},
              count: null,
              onSelect: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bench press'), findsOne);
    expect(find.text('Squat'), findsNothing);

    final newDb = testDb();
    await newDb.planExercises.deleteAll();
    await newDb.plans.deleteAll();
    await newDb.plans.insertOne(
      PlansCompanion.insert(id: const Value(1), days: 'Monday'),
    );
    final newSquat =
        await (newDb.exercises.select()
              ..where((exercise) => exercise.name.equals('Squat')))
            .getSingleOrNull() ??
        await newDb.exercises.insertReturning(
          ExercisesCompanion.insert(
            name: 'Squat',
            kind: 'strength',
            displayUnit: 'kg',
          ),
        );
    await newDb.planExercises.insertOne(
      PlanExercisesCompanion.insert(
        planId: 1,
        exerciseId: newSquat.id,
        enabled: true,
      ),
    );
    await oldDb.close();
    db = newDb;
    dbVersion.value++;

    await tester.pumpAndSettle();

    expect(find.text('Squat'), findsOne);
    expect(find.text('Bench press'), findsNothing);

    await newDb.close();
  });
}
