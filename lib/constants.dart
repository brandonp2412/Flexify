import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Consistent padding for input fields (dropdowns, text fields) in settings screens.
const kSettingsInputPadding = EdgeInsets.symmetric(
  horizontal: 16.0,
  vertical: 8.0,
);

const weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

String localizedWeekday(
  AppLocalizations l10n,
  String storedWeekday, {
  bool abbreviated = false,
}) {
  final index = weekdays.indexOf(storedWeekday);
  if (index < 0) return storedWeekday;
  final date = DateTime.utc(2024, 1, index + 1);
  return DateFormat(abbreviated ? 'EEE' : 'EEEE', l10n.localeName).format(date);
}

enum CardioMetric {
  pace,
  distance,
  duration,
  incline,
  inclineAdjustedPace,
  weight,
}

enum Period { day, week, month, year }

enum PlanTrailing { reorder, ratio, count, percent, none }

enum StrengthMetric {
  oneRepMax,
  volume,
  bestWeight,
  relativeStrength,
  bestReps,
}

enum GraphSort { dateDesc, dateAsc, name }

/// Name of the entry Flexify uses to log body weight. It is not an exercise,
/// so it never belongs to a category.
const bodyWeightExercise = 'Weight';

/// Tabs shown on a fresh install, in order.
const defaultTabs = 'HistoryPage,CategoriesPage,PlansPage,GraphsPage,TimerPage';

final defaultSettings = SettingsCompanion.insert(
  themeMode: ThemeMode.system.toString(),
  planTrailing: PlanTrailing.reorder.toString(),
  longDateFormat: 'timeago',
  shortDateFormat: 'd/M/yy',
  timerDuration: const Duration(minutes: 3, seconds: 30).inMilliseconds,
  maxSets: 3,
  vibrate: true,
  restTimers: false,
  showUnits: false,
  alarmSound: '',
  cardioUnit: 'last-entry',
  curveLines: true,
  durationEstimation: const Value(false),
  explainedPermissions: false,
  groupHistory: false,
  notifications: const Value(false),
  showBodyWeight: const Value(false),
  showImages: const Value(false),
  showGlobalProgress: const Value(false),
  strengthUnit: 'last-entry',
  systemColors: false,
  keepScreenOn: const Value(false),
  tabs: const Value(defaultTabs),
  showNotes: const Value(false),
);

List<DropdownMenuItem<String>> strengthUnitMenuItems(AppLocalizations l10n) => [
  DropdownMenuItem(value: 'kg', child: Text(l10n.kilogramsUnit)),
  DropdownMenuItem(value: 'lb', child: Text(l10n.poundsUnit)),
  DropdownMenuItem(value: 'stone', child: Text(l10n.stoneUnit)),
];

List<DropdownMenuItem<String>> cardioDistanceUnitMenuItems(
  AppLocalizations l10n,
) => [
  DropdownMenuItem(value: 'km', child: Text(l10n.kilometersUnit)),
  DropdownMenuItem(value: 'mi', child: Text(l10n.milesUnit)),
  DropdownMenuItem(value: 'm', child: Text(l10n.metersUnit)),
];

List<DropdownMenuItem<String>> cardioUnitMenuItems(AppLocalizations l10n) => [
  DropdownMenuItem(value: 'km', child: Text(l10n.kilometersUnit)),
  DropdownMenuItem(value: 'mi', child: Text(l10n.milesUnit)),
  DropdownMenuItem(value: 'm', child: Text(l10n.metersUnit)),
  DropdownMenuItem(value: 'kcal', child: Text(l10n.kilocaloriesUnit)),
];

String displayMeasurementUnit(AppLocalizations l10n, String unit) =>
    unit == 'stone' ? l10n.stoneUnitShort : unit;

/// Names an exercise together with its category, so exercises that share a
/// name in different categories can be told apart.
String exerciseLabel(AppLocalizations l10n, String name, String? category) {
  if (name == bodyWeightExercise) return name;
  return l10n.exerciseInCategory(name, category ?? l10n.uncategorized);
}

/// The display name of [category], where null means uncategorized.
String categoryLabel(AppLocalizations l10n, String? category) =>
    category ?? l10n.uncategorized;

List<String> positiveReinforcementMessages(AppLocalizations l10n) => [
  l10n.recordEncouragement01,
  l10n.recordEncouragement02,
  l10n.recordEncouragement03,
  l10n.recordEncouragement04,
  l10n.recordEncouragement05,
  l10n.recordEncouragement06,
  l10n.recordEncouragement07,
  l10n.recordEncouragement08,
  l10n.recordEncouragement09,
  l10n.recordEncouragement10,
  l10n.recordEncouragement11,
  l10n.recordEncouragement12,
  l10n.recordEncouragement13,
  l10n.recordEncouragement14,
  l10n.recordEncouragement15,
  l10n.recordEncouragement16,
  l10n.recordEncouragement17,
  l10n.recordEncouragement18,
  l10n.recordEncouragement19,
  l10n.recordEncouragement20,
  l10n.recordEncouragement21,
  l10n.recordEncouragement22,
  l10n.recordEncouragement23,
  l10n.recordEncouragement24,
  l10n.recordEncouragement25,
  l10n.recordEncouragement26,
  l10n.recordEncouragement27,
  l10n.recordEncouragement28,
  l10n.recordEncouragement29,
];
