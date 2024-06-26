import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';

class SettingsState extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  PlanTrailing planTrailing = PlanTrailing.reorder;
  Duration timerDuration = const Duration(minutes: 3, seconds: 30);
  int maxSets = 3;
  String longDateFormat = 'dd/MM/yy';
  String shortDateFormat = 'd/M/yy';
  String alarmSound = '';
  String cardioUnit = 'km';
  String strengthUnit = 'kg';

  bool vibrate = true;
  bool restTimers = true;
  bool showUnits = true;
  bool systemColors = true;
  bool explainedPermissions = false;
  bool hideTimerTab = false;
  bool hideHistoryTab = false;
  bool curveLines = false;
  bool hideWeight = false;
  bool groupHistory = true;

  Future<void> init() async {
    final settings = await (db.settings.select()..limit(1)).getSingle();
    alarmSound = settings.alarmSound;
    cardioUnit = settings.cardioUnit;
    strengthUnit = settings.strengthUnit;
    longDateFormat = settings.longDateFormat;
    shortDateFormat = settings.shortDateFormat;
    maxSets = settings.maxSets;

    final duration = settings.timerDuration;
    timerDuration = Duration(milliseconds: duration);

    final theme = settings.themeMode;
    if (theme == ThemeMode.system.toString())
      themeMode = ThemeMode.system;
    else if (theme == ThemeMode.light.toString())
      themeMode = ThemeMode.light;
    else if (theme == ThemeMode.dark.toString()) themeMode = ThemeMode.dark;

    final plan = settings.planTrailing;
    if (plan == PlanTrailing.count.toString())
      planTrailing = PlanTrailing.count;
    else if (plan == PlanTrailing.reorder.toString())
      planTrailing = PlanTrailing.reorder;

    systemColors = settings.systemColors;
    restTimers = settings.restTimers;
    showUnits = settings.showUnits;
    hideTimerTab = settings.hideTimerTab;
    hideHistoryTab = settings.hideHistoryTab;
    explainedPermissions = settings.explainedPermissions;
    curveLines = settings.curveLines;
    vibrate = settings.vibrate;
    hideWeight = settings.hideWeight;
    groupHistory = settings.groupHistory;
    notifyListeners();
  }

  SettingsState() {
    init();
  }

  void setGroupHistory(bool value) {
    groupHistory = value;
    notifyListeners();
    (db.settings.update()).write(SettingsCompanion(groupHistory: Value(value)));
  }

  void setHideWeight(bool value) {
    hideWeight = value;
    notifyListeners();
    (db.settings.update()).write(SettingsCompanion(hideWeight: Value(value)));
  }

  void setMaxSets(int value) {
    maxSets = value;
    notifyListeners();
    (db.settings.update()).write(SettingsCompanion(maxSets: Value(value)));
  }

  void setDuration(Duration value) {
    timerDuration = value;
    notifyListeners();
    (db.settings.update())
        .write(SettingsCompanion(timerDuration: Value(value.inMilliseconds)));
  }

  void setCardioUnit(String value) async {
    cardioUnit = value;
    notifyListeners();
    (db.settings.update()).write(SettingsCompanion(cardioUnit: Value(value)));
  }

  void setStrengthUnit(String value) async {
    strengthUnit = value;
    notifyListeners();
    (db.settings.update()).write(SettingsCompanion(strengthUnit: Value(value)));
  }

  void setAlarm(String sound) async {
    alarmSound = sound;
    notifyListeners();
    (db.settings.update()).write(SettingsCompanion(alarmSound: Value(sound)));
  }

  void setPlanTrailing(PlanTrailing value) {
    planTrailing = value;
    notifyListeners();
    (db.settings.update())
        .write(SettingsCompanion(planTrailing: Value(value.toString())));
  }

  void setVibrate(bool value) {
    vibrate = value;
    notifyListeners();
    (db.settings.update()).write(SettingsCompanion(vibrate: Value(value)));
  }

  void setCurvedLines(bool value) {
    curveLines = value;
    notifyListeners();
    (db.settings.update()).write(SettingsCompanion(curveLines: Value(value)));
  }

  void setHideTimer(bool value) {
    hideTimerTab = value;
    notifyListeners();
    (db.settings.update()).write(SettingsCompanion(hideTimerTab: Value(value)));
  }

  void setHideHistory(bool value) {
    hideHistoryTab = value;
    notifyListeners();
    (db.settings.update())
        .write(SettingsCompanion(hideHistoryTab: Value(value)));
  }

  void setExplained(bool value) {
    explainedPermissions = value;
    notifyListeners();
    (db.settings.update())
        .write(SettingsCompanion(explainedPermissions: Value(value)));
  }

  void setLong(String value) {
    longDateFormat = value;
    notifyListeners();
    (db.settings.update())
        .write(SettingsCompanion(longDateFormat: Value(value)));
  }

  void setShort(String value) {
    shortDateFormat = value;
    notifyListeners();
    (db.settings.update())
        .write(SettingsCompanion(shortDateFormat: Value(value)));
  }

  void setSystem(bool value) {
    systemColors = value;
    (db.settings.update()).write(SettingsCompanion(systemColors: Value(value)));
    notifyListeners();
  }

  void setUnits(bool value) {
    showUnits = value;
    (db.settings.update()).write(SettingsCompanion(showUnits: Value(value)));
    notifyListeners();
  }

  void setTimers(bool value) {
    restTimers = value;
    (db.settings.update()).write(SettingsCompanion(restTimers: Value(value)));
    notifyListeners();
  }

  void setTheme(ThemeMode value) {
    themeMode = value;
    (db.settings.update())
        .write(SettingsCompanion(themeMode: Value(value.toString())));
    notifyListeners();
  }
}
