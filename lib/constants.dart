const weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const categories = [
  'Chest',
  'Back',
  'Shoulders',
  'Arms',
  'Legs',
  'Core',
  'Glutes',
  'Calves',
];

enum CardioMetric { pace, distance, duration, incline, inclineAdjustedPace }

enum Period {
  day,
  week,
  month,
  year,
}

enum PlanTrailing { reorder, ratio, count, percent, none }

enum StrengthMetric {
  oneRepMax,
  volume,
  bestWeight,
  relativeStrength,
  bestReps,
}
