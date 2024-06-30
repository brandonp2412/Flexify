import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';

const defaultPlans = [
  PlansCompanion(
    id: Value(1),
    days: Value('Monday'),
    exercises: Value(
      'Deadlift,Lat pull-down,Barbell bent-over row,Barbell biceps curl',
    ),
  ),
  PlansCompanion(
    id: Value(2),
    days: Value('Wednesday'),
    exercises: Value(
      'Barbell bench press,Barbell shoulder press,Chest fly,Dumbbell lateral raise,Triceps extension',
    ),
  ),
  PlansCompanion(
    id: Value(3),
    days: Value('Friday'),
    exercises: Value('Squat,Leg press,Leg curl,Seated calf raise'),
  ),
];

final defaultPlanExercises = defaultPlans
    .map((plan) {
      final exercises = plan.exercises.value.split(',');
      return defaultExercises.map(
        (exercise) => PlanExercisesCompanion.insert(
          planId: plan.id.value,
          exercise: exercise,
          enabled: exercises.contains(exercise),
        ),
      );
    })
    .toList()
    .expand(
      (element) => element,
    );

const defaultExercises = [
  'Arnold press',
  'Back extension',
  'Barbell bench press',
  'Barbell biceps curl',
  'Barbell bent-over row',
  'Barbell shoulder press',
  'Barbell shrug',
  'Cable fly',
  'Cable lateral raise',
  'Cable pull-down',
  'Chest fly',
  'Chin-up',
  'Close-grip pull-up',
  'Crunch',
  'Deadlift',
  'Decline bench press',
  'Diamond push-up',
  'Dumbbell bench press',
  'Dumbbell biceps curl',
  'Dumbbell bent-over row',
  'Dumbbell fly',
  'Dumbbell lateral raise',
  'Dumbbell shoulder press',
  'Dumbbell shrug',
  'Good morning',
  'Hanging leg raise',
  'Hyperextension',
  'Incline bench press',
  'Lat pull-down',
  'Leg curl',
  'Leg extension',
  'Leg press',
  'Leg raise',
  'Lunge',
  'Narrow-grip push-up',
  'Neck curl',
  'Overhead triceps extension',
  'Preacher curl',
  'Pull-down',
  'Pull-up',
  'Push-up',
  'Reverse grip pull-down',
  'Reverse grip pushdown',
  'Roman chair leg raise',
  'Romanian deadlift',
  'Russian twist',
  'Seated calf raise',
  'Shoulder shrug',
  'Squat',
  'Standing calf raise',
  'T-bar row',
  'Triceps dip',
  'Triceps extension',
  'Triceps pushdown',
  'Upright row',
  'Weighted Russian twist',
  'Wide-grip pull-up',
  'Wide-grip push-up',
];

final defaultSets = defaultExercises.map(
  (exercise) => GymSetsCompanion(
    created: Value(DateTime.now().toLocal()),
    name: Value(exercise),
    reps: const Value(0),
    weight: const Value(0),
    hidden: const Value(true),
    unit: const Value('kg'),
  ),
);
