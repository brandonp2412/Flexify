import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
  });

  tearDown(() => database.close());

  test(
    'redesign cutover removes legacy tables and keeps canonical set columns',
    () async {
      final legacyColumns = await database
          .customSelect('PRAGMA table_info(gym_sets)')
          .get();
      final setColumns = await database
          .customSelect('PRAGMA table_info(exercise_sets)')
          .get();

      expect(legacyColumns, isEmpty);
      expect(
        setColumns.map((row) => row.read<String>('name')),
        containsAll(<String>[
          'exercise_id',
          'workout_id',
          'timestamp',
          'reps',
          'load_kg',
          'duration_ms',
          'distance_metres',
          'incline',
          'body_weight_kg',
          'notes',
        ]),
      );

      final indexes = await database
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type = 'index' AND name NOT LIKE 'sqlite_%'",
          )
          .get();
      expect(
        indexes.map((row) => row.read<String>('name')),
        containsAll(<String>[
          'plan_exercises_plan_id',
          'exercise_sets_exercise_timestamp',
          'exercise_sets_workout_exercise',
          'workouts_plan_ended_started',
          'body_weights_timestamp',
        ]),
      );
    },
  );

  test('redesign foundation declares stable identity foreign keys', () async {
    final exerciseSetForeignKeys = await database
        .customSelect('PRAGMA foreign_key_list(exercise_sets)')
        .get();
    final planExerciseForeignKeys = await database
        .customSelect('PRAGMA foreign_key_list(plan_exercises)')
        .get();

    expect(
      exerciseSetForeignKeys.map((row) => row.read<String>('table')),
      containsAll(<String>['exercises', 'workouts']),
    );
    expect(
      planExerciseForeignKeys
          .where((row) => row.read<String>('from') == 'exercise_id')
          .map((row) => row.read<String>('table')),
      contains('exercises'),
    );
  });
}
