import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';

/// Muscle-group categories every install starts with. People can add, rename,
/// merge, or delete categories afterwards.
const defaultCategories = [
  'Chest',
  'Back',
  'Shoulders',
  'Biceps',
  'Triceps',
  'Forearms',
  'Abs',
  'Quads',
  'Hamstrings',
  'Glutes',
  'Calves',
];

const defaultExercises = [
  ('Arnold press', 'Shoulders'),
  ('Back extension', 'Back'),
  ('Barbell bench press', 'Chest'),
  ('Barbell biceps curl', 'Biceps'),
  ('Barbell bent-over row', 'Back'),
  ('Barbell shoulder press', 'Shoulders'),
  ('Barbell shrug', 'Shoulders'),
  ('Cable fly', 'Chest'),
  ('Cable lateral raise', 'Shoulders'),
  ('Cable pull-down', 'Back'),
  ('Chest fly', 'Chest'),
  ('Chin-up', 'Back'),
  ('Close-grip pull-up', 'Back'),
  ('Crunch', 'Abs'),
  ('Deadlift', 'Back'),
  ('Decline bench press', 'Chest'),
  ('Diamond push-up', 'Chest'),
  ('Dumbbell bench press', 'Chest'),
  ('Dumbbell biceps curl', 'Biceps'),
  ('Dumbbell bent-over row', 'Back'),
  ('Dumbbell fly', 'Chest'),
  ('Dumbbell lateral raise', 'Shoulders'),
  ('Dumbbell shoulder press', 'Shoulders'),
  ('Dumbbell shrug', 'Shoulders'),
  ('Good morning', 'Hamstrings'),
  ('Hanging leg raise', 'Abs'),
  ('Hyperextension', 'Back'),
  ('Incline bench press', 'Chest'),
  ('Lat pull-down', 'Back'),
  ('Leg curl', 'Hamstrings'),
  ('Leg extension', 'Quads'),
  ('Leg press', 'Quads'),
  ('Leg raise', 'Abs'),
  ('Lunge', 'Quads'),
  ('Narrow-grip push-up', 'Triceps'),
  ('Neck curl', 'Shoulders'),
  ('Overhead triceps extension', 'Triceps'),
  ('Preacher curl', 'Biceps'),
  ('Pull-down', 'Back'),
  ('Pull-up', 'Back'),
  ('Push-up', 'Chest'),
  ('Reverse grip pull-down', 'Back'),
  ('Reverse grip pushdown', 'Triceps'),
  ('Roman chair leg raise', 'Abs'),
  ('Romanian deadlift', 'Hamstrings'),
  ('Russian twist', 'Abs'),
  ('Seated calf raise', 'Calves'),
  ('Shoulder shrug', 'Shoulders'),
  ('Squat', 'Quads'),
  ('Standing calf raise', 'Calves'),
  ('T-bar row', 'Back'),
  ('Triceps dip', 'Triceps'),
  ('Triceps extension', 'Triceps'),
  ('Triceps pushdown', 'Triceps'),
  ('Upright row', 'Shoulders'),
  ('Weighted Russian twist', 'Abs'),
  ('Wide-grip pull-up', 'Back'),
  ('Wide-grip push-up', 'Chest'),
];

const defaultPlans = [
  PlansCompanion(id: Value(1), days: Value('Monday')),
  PlansCompanion(id: Value(2), days: Value('Wednesday')),
  PlansCompanion(id: Value(3), days: Value('Friday')),
];

final defaultPlanExercises = [
  ...[
    'Barbell bench press',
    'Squat',
    'Lat pull-down',
    'Leg press',
  ].map((name) => _defaultPlanExercise(1, name)),
  ...[
    'Deadlift',
    'Overhead triceps extension',
    'Dumbbell biceps curl',
    'Barbell bent-over row',
  ].map((name) => _defaultPlanExercise(2, name)),
  ...[
    'Leg press',
    'Pull-up',
    'Push-up',
    'Crunch',
  ].map((name) => _defaultPlanExercise(3, name)),
];

PlanExercisesCompanion _defaultPlanExercise(int planId, String name) =>
    PlanExercisesCompanion.insert(
      planId: planId,
      exercise: name,
      category: Value(
        defaultExercises.firstWhere((exercise) => exercise.$1 == name).$2,
      ),
      enabled: true,
    );

final defaultSets = defaultExercises.map(
  (exercise) => GymSetsCompanion(
    created: Value(DateTime.now().toLocal()),
    name: Value(exercise.$1),
    reps: const Value(0),
    weight: const Value(0),
    hidden: const Value(true),
    unit: const Value('kg'),
    category: Value(exercise.$2),
  ),
);
