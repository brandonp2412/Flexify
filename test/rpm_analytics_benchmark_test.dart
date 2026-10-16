import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_analytics.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/main.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tests.dart';

int median(List<int> values) {
  final sorted = List<int>.of(values)..sort();
  return sorted[sorted.length ~/ 2];
}

Future<List<Rpm>> legacyGetRpms() async {
  final cutoff = DateTime.now().subtract(const Duration(days: 30));
  final sets = await getExerciseSets(db, startDate: cutoff, cardio: false)
    ..sort((a, b) => a.created.compareTo(b.created));

  final byName = <String, List<ExerciseSetView>>{};
  for (final set in sets) {
    byName.putIfAbsent(set.name, () => []).add(set);
  }

  final grouped = <String, List<double>>{};
  final weights = <String, double>{};
  for (final entry in byName.entries) {
    ExerciseSetView? previous;
    for (final set in entry.value) {
      if (previous != null) {
        final minutes =
            set.created.difference(previous.created).inMilliseconds / 60000;
        if (minutes > 0 && minutes <= 5) {
          final rpm = set.reps / minutes;
          if (rpm >= 0.1 && rpm <= 10) {
            final key = '${entry.key}\u0000${set.weight}';
            grouped.putIfAbsent(key, () => []).add(rpm);
            weights[key] = set.weight;
          }
        }
      }
      previous = set;
    }
  }

  return grouped.entries.map((entry) {
    final split = entry.key.indexOf('\u0000');
    final values = entry.value;
    return (
      name: entry.key.substring(0, split),
      rpm: values.reduce((a, b) => a + b) / values.length,
      weight: weights[entry.key]!,
    );
  }).toList();
}

List<Rpm> sortedRpms(List<Rpm> values) {
  return List<Rpm>.of(values)..sort((a, b) {
    final name = a.name.compareTo(b.name);
    if (name != 0) return name;
    return a.weight.compareTo(b.weight);
  });
}

Future<int> measure(Future<List<Rpm>> Function() load) async {
  final timer = Stopwatch()..start();
  final result = await load();
  timer.stop();
  expect(result, isNotEmpty);
  return timer.elapsedMicroseconds;
}

void main() {
  test('RPM analytics benchmark', () async {
    db = testDb();
    addTearDown(db.close);

    const exerciseCount = 40;
    const setsPerExercise = 500;
    final now = DateTime.now().toLocal();
    final exercises = [
      for (var i = 0; i < exerciseCount; i++)
        ExercisesCompanion.insert(
          id: Value(10000 + i),
          name: 'Exercise $i',
          kind: 'strength',
          displayUnit: 'kg',
        ),
    ];
    final sets = <ExerciseSetsCompanion>[];
    for (var exercise = 0; exercise < exerciseCount; exercise++) {
      for (var set = 0; set < setsPerExercise; set++) {
        sets.add(
          ExerciseSetsCompanion.insert(
            exerciseId: 10000 + exercise,
            timestamp: now
                .subtract(const Duration(days: 1))
                .add(Duration(minutes: set)),
            reps: Value(5 + (set % 5).toDouble()),
            loadKg: const Value(50),
          ),
        );
      }
    }

    await db.batch((batch) {
      batch.insertAll(db.exercises, exercises);
      batch.insertAll(db.exerciseSets, sets);
    });

    final legacy = sortedRpms(await legacyGetRpms());
    final optimized = sortedRpms(await getRpms());
    expect(optimized, hasLength(legacy.length));
    for (var i = 0; i < legacy.length; i++) {
      expect(optimized[i].name, legacy[i].name);
      expect(optimized[i].weight, legacy[i].weight);
      expect(optimized[i].rpm, closeTo(legacy[i].rpm, 0.0000001));
    }

    for (var i = 0; i < 2; i++) {
      await legacyGetRpms();
      await getRpms();
    }

    final legacySamples = <int>[];
    final optimizedSamples = <int>[];
    for (var sample = 0; sample < 7; sample++) {
      if (sample.isEven) {
        legacySamples.add(await measure(legacyGetRpms));
        optimizedSamples.add(await measure(getRpms));
      } else {
        optimizedSamples.add(await measure(getRpms));
        legacySamples.add(await measure(legacyGetRpms));
      }
    }

    print('RPM_LEGACY_US=$legacySamples');
    print('RPM_LEGACY_MEDIAN_US=${median(legacySamples)}');
    print('RPM_OPTIMIZED_US=$optimizedSamples');
    print('RPM_OPTIMIZED_MEDIAN_US=${median(optimizedSamples)}');
  });
}
