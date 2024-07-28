import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flutter/material.dart';

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

final defaultSettings = SettingsCompanion.insert(
  themeMode: ThemeMode.system.toString(),
  planTrailing: PlanTrailing.reorder.toString(),
  longDateFormat: 'dd/MM/yy',
  shortDateFormat: 'd/M/yy',
  timerDuration: const Duration(minutes: 3, seconds: 30).inMilliseconds,
  maxSets: 3,
  vibrate: true,
  restTimers: true,
  showUnits: true,
  alarmSound: '',
  cardioUnit: 'km',
  curveLines: false,
  explainedPermissions: false,
  groupHistory: true,
  showBodyWeight: const Value(true),
  strengthUnit: 'kg',
  systemColors: false,
);
