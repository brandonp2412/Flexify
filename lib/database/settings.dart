import 'package:drift/drift.dart';

class Settings extends Table {
  TextColumn get alarmSound => text()();
  BoolColumn get automaticBackups =>
      boolean().withDefault(const Constant(false))();
  TextColumn get backupPath => text().nullable()();
  TextColumn get cardioUnit => text()();
  BoolColumn get curveLines => boolean()();
  RealColumn get curveSmoothness => real().nullable()();
  BoolColumn get durationEstimation =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get enableSound => boolean().withDefault(const Constant(true))();
  BoolColumn get explainedPermissions => boolean()();
  BoolColumn get groupHistory => boolean()();
  IntColumn get id => integer().autoIncrement()();
  TextColumn get longDateFormat => text()();
  IntColumn get maxSets => integer()();
  BoolColumn get notifications => boolean().withDefault(const Constant(true))();
  BoolColumn get peekGraph => boolean().withDefault(const Constant(false))();
  TextColumn get planTrailing => text()();
  BoolColumn get repEstimation =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get restTimers => boolean()();
  TextColumn get shortDateFormat => text()();
  BoolColumn get showBodyWeight =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get showCategories =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get showImages => boolean().withDefault(const Constant(true))();
  BoolColumn get showNotes => boolean().withDefault(const Constant(true))();
  BoolColumn get showGlobalProgress =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get showUnits => boolean()();
  TextColumn get strengthUnit => text()();
  BoolColumn get systemColors => boolean()();
  TextColumn get tabs => text().withDefault(
        const Constant("HistoryPage,PlansPage,GraphsPage,TimerPage"),
      )();
  TextColumn get themeMode => text()();
  IntColumn get timerDuration => integer()();
  BoolColumn get vibrate => boolean()();
  IntColumn get warmupSets => integer().nullable()();
}
