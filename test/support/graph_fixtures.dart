import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';

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

final screenshotPlanExercises = <PlanExercisesCompanion>[
  PlanExercisesCompanion.insert(
    planId: 1,
    enabled: true,
    exercise: 'Triceps dip',
  ),
  PlanExercisesCompanion.insert(planId: 1, enabled: true, exercise: 'Squat'),
  PlanExercisesCompanion.insert(
    planId: 1,
    enabled: true,
    exercise: 'Standing calf raise',
  ),
  PlanExercisesCompanion.insert(planId: 1, enabled: true, exercise: 'Pull-up'),
  PlanExercisesCompanion.insert(
    planId: 2,
    enabled: true,
    exercise: 'Barbell bench press',
  ),
  PlanExercisesCompanion.insert(
    planId: 2,
    enabled: true,
    exercise: 'Barbell bent-over row',
  ),
  PlanExercisesCompanion.insert(
    planId: 2,
    enabled: true,
    exercise: 'Dumbbell lateral raise',
  ),
  PlanExercisesCompanion.insert(
    planId: 2,
    enabled: true,
    exercise: 'Barbell biceps curl',
  ),
  PlanExercisesCompanion.insert(
    planId: 3,
    enabled: true,
    exercise: 'Barbell shoulder press',
  ),
  PlanExercisesCompanion.insert(planId: 3, enabled: true, exercise: 'Crunch'),
  PlanExercisesCompanion.insert(planId: 3, enabled: true, exercise: 'Chin-up'),
  PlanExercisesCompanion.insert(
    planId: 3,
    enabled: true,
    exercise: 'Romanian deadlift',
  ),
  PlanExercisesCompanion.insert(
    planId: 4,
    enabled: true,
    exercise: 'Barbell shoulder press',
  ),
  PlanExercisesCompanion.insert(
    planId: 4,
    enabled: true,
    exercise: 'Neck curl',
  ),
  PlanExercisesCompanion.insert(planId: 4, enabled: true, exercise: 'Chin-up'),
  PlanExercisesCompanion.insert(
    planId: 4,
    enabled: true,
    exercise: 'Romanian deadlift',
  ),
];

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

GymSetsCompanion graphGymSet(
  String exercise,
  double weight, {
  double reps = 12,
  DateTime? date,
}) {
  return GymSetsCompanion.insert(
    name: exercise,
    reps: reps,
    weight: weight,
    unit: 'kg',
    created: date ?? graphFixtureNow,
    category: const Value('Arms'),
  );
}

Future<void> seedGraphFixtures(AppDatabase database) async {
  for (final entry in exercisesToPopulateTestDb.entries) {
    await database.into(database.gymSets).insert(
      graphGymSet(entry.key, entry.value),
    );
  }

  for (final element in graphData) {
    await database.into(database.gymSets).insert(
      graphGymSet(
        screenshotExercise,
        element.weight,
        reps: element.reps,
        date: element.dateTime,
      ),
    );
  }
}
