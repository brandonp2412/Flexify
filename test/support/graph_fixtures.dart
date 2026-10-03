import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';

import 'fixtures.dart';

final graphFixtureNow = DateTime(2026, 1, 15, 12);

const exercisesToPopulateTestDb = <String, double>{
  'Barbell bench press': 90,
  'Barbell bent-over row': 82.5,
  'Barbell biceps curl': 45,
  'Barbell shoulder press': 50,
  'Chin-up': 20,
  'Crunch': 25,
  'Dumbbell bicep curls': 30,
  'Dumbbell chest press': 55,
  'Dumbbell lateral raise': 10,
  'Dumbbell shoulder press': 40,
  'Triceps dip': 20,
};

class GraphSetInfo {
  GraphSetInfo(int daysAgo, this.reps, this.weight)
    : dateTime = graphFixtureNow.subtract(Duration(days: daysAgo));

  final DateTime dateTime;
  final double reps;
  final double weight;
}

final graphData = <GraphSetInfo>[
  GraphSetInfo(0, 8, 1),
  GraphSetInfo(0, 6, 5),
  GraphSetInfo(0, 6, 6.25),
  GraphSetInfo(4, 8, 1),
  GraphSetInfo(4, 6, 2.5),
  GraphSetInfo(4, 6, 5),
  GraphSetInfo(4, 6, 5),
  GraphSetInfo(4, 6, 5),
  GraphSetInfo(8, 6, 5),
  GraphSetInfo(8, 6, 4),
  GraphSetInfo(8, 6, 10),
  GraphSetInfo(12, 6, 5),
  GraphSetInfo(16, 6, 1),
  GraphSetInfo(20, 6, 5),
  GraphSetInfo(24, 6, 1),
  GraphSetInfo(28, 6, 1),
  GraphSetInfo(32, 6, 1),
  GraphSetInfo(36, 6, 1),
];

const screenshotPlanExercises = <int, List<String>>{
  1: ['Triceps dip', 'Squat', 'Standing calf raise', 'Pull-up'],
  2: [
    'Barbell bench press',
    'Barbell bent-over row',
    'Dumbbell lateral raise',
    'Barbell biceps curl',
  ],
  3: ['Barbell shoulder press', 'Crunch', 'Chin-up', 'Romanian deadlift'],
  4: ['Barbell shoulder press', 'Neck curl', 'Chin-up', 'Romanian deadlift'],
};

final screenshotPlans = <PlansCompanion>[
  PlansCompanion.insert(
    id: const Value(1),
    days: 'Tuesday,Saturday',
    title: const Value('Tuesday, Saturday'),
  ),
  const PlansCompanion(
    id: Value(2),
    days: Value('Wednesday,Sunday'),
    title: Value('Wednesday, Sunday'),
  ),
  const PlansCompanion(
    id: Value(3),
    days: Value('Monday'),
    title: Value('Monday'),
  ),
  const PlansCompanion(
    id: Value(4),
    days: Value('Thursday'),
    title: Value('Thursday'),
  ),
];

const screenshotExercise = 'Dumbbell shoulder press';

Future<PerformedSetView> insertGraphSet(
  AppDatabase database,
  String exercise,
  double weight, {
  double reps = 12,
  DateTime? date,
  int? planId,
  bool cardio = false,
  String unit = 'kg',
  double duration = 0,
  double distance = 0,
  int? incline,
  String category = 'Arms',
}) {
  return insertPerformedSetFixture(
    database,
    exercise,
    weight: weight,
    reps: reps,
    created: date ?? graphFixtureNow,
    planId: planId,
    cardio: cardio,
    unit: unit,
    duration: duration,
    distance: distance,
    incline: incline,
    category: category,
  );
}

Future<void> seedGraphFixtures(AppDatabase database) async {
  for (final entry in exercisesToPopulateTestDb.entries) {
    await insertGraphSet(database, entry.key, entry.value);
  }

  for (final element in graphData) {
    await insertGraphSet(
      database,
      screenshotExercise,
      element.weight,
      reps: element.reps,
      date: element.dateTime,
    );
  }
}
