import 'package:drift/drift.dart';

class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get themeMode => text()();
  TextColumn get planTrailing => text()();
  TextColumn get longDateFormat => text()();
  TextColumn get shortDateFormat => text()();
  IntColumn get timerDuration => integer()();
  IntColumn get maxSets => integer()();
  BoolColumn get vibrate => boolean()();
  BoolColumn get restTimers => boolean()();
  BoolColumn get showUnits => boolean()();
  BoolColumn get systemColors => boolean()();
  BoolColumn get explainedPermissions => boolean()();
  BoolColumn get hideTimerTab => boolean()();
  BoolColumn get hideHistoryTab => boolean()();
  BoolColumn get curveLines => boolean()();
  BoolColumn get hideWeight => boolean()();
  BoolColumn get groupHistory => boolean()();
  TextColumn get alarmSound => text()();
  TextColumn get cardioUnit => text()();
  TextColumn get strengthUnit => text()();
}
