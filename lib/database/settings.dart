import 'package:drift/drift.dart';

class Settings extends Table {
  TextColumn get alarmSound => text()();
  TextColumn get cardioUnit => text()();
  BoolColumn get curveLines => boolean()();
  BoolColumn get explainedPermissions => boolean()();
  BoolColumn get groupHistory => boolean()();
  BoolColumn get hideHistoryTab => boolean()();
  BoolColumn get hideTimerTab => boolean()();
  BoolColumn get hideWeight => boolean()();
  IntColumn get id => integer().autoIncrement()();
  TextColumn get longDateFormat => text()();
  IntColumn get maxSets => integer()();
  TextColumn get planTrailing => text()();
  BoolColumn get restTimers => boolean()();
  TextColumn get shortDateFormat => text()();
  BoolColumn get showImages => boolean().withDefault(const Constant(true))();
  BoolColumn get showUnits => boolean()();
  TextColumn get strengthUnit => text()();
  BoolColumn get systemColors => boolean()();
  TextColumn get themeMode => text()();
  IntColumn get timerDuration => integer()();
  BoolColumn get vibrate => boolean()();
  IntColumn get warmupSets => integer().nullable()();
  BoolColumn get repEstimation => boolean().withDefault(const Constant(true))();
}
