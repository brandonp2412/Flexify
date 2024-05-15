import 'package:flexify/main.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState extends ChangeNotifier {
  SharedPreferences? prefs;

  ThemeMode themeMode = ThemeMode.system;
  String longDateFormat = 'dd/MM/yy';
  String shortDateFormat = 'd/M/yy';
  String? alarmSound;

  bool vibrate = true;
  bool showReorder = true;
  bool restTimers = true;
  bool showUnits = true;
  bool showPlanCounts = true;
  bool systemColors = true;
  bool explainedPermissions = false;
  bool hideTimerTab = false;
  bool hideHistoryTab = false;
  bool curveLines = false;
  bool automaticBackup = false;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();

    alarmSound = prefs?.getString('alarmSound');
    longDateFormat = prefs?.getString('longDateFormat') ?? "dd/MM/yy";
    shortDateFormat = prefs?.getString('shortDateFormat') ?? "d/M/yy";
    final theme = prefs?.getString('themeMode');
    if (theme == "ThemeMode.system")
      themeMode = ThemeMode.system;
    else if (theme == "ThemeMode.light")
      themeMode = ThemeMode.light;
    else if (theme == "ThemeMode.dark") themeMode = ThemeMode.dark;

    showPlanCounts = prefs?.getBool("showPlanCounts") ?? true;
    systemColors = prefs?.getBool("systemColors") ?? true;
    showReorder = prefs?.getBool("showReorder") ?? true;
    restTimers = prefs?.getBool("restTimers") ?? true;
    showUnits = prefs?.getBool("showUnits") ?? true;
    hideTimerTab = prefs?.getBool("hideTimerTab") ?? false;
    hideHistoryTab = prefs?.getBool("hideHistoryTab") ?? false;
    explainedPermissions = prefs?.getBool('explainedPermissions') ?? false;
    curveLines = prefs?.getBool('curveLines') ?? false;
    automaticBackup = prefs?.getBool('automaticBackup') ?? false;
    vibrate = prefs?.getBool('vibrate') ?? true;
  }

  void setAlarm(String? sound) async {
    alarmSound = sound;
    notifyListeners();
    if (sound == null)
      prefs?.remove("alarmSound");
    else
      prefs?.setString('alarmSound', sound);
  }

  void setAutomatic(bool backup) async {
    if (backup) {
      final dbFolder = await getApplicationDocumentsDirectory();
      android.invokeMethod('pick', [join(dbFolder.path, 'flexify.sqlite')]);
    }
    automaticBackup = backup;
    notifyListeners();
    prefs?.setBool('automaticBackup', backup);
  }

  void setShowPlanCounts(bool value) {
    showPlanCounts = value;
    notifyListeners();
    prefs?.setBool('showPlanCounts', value);
  }

  void setVibrate(bool value) {
    vibrate = value;
    notifyListeners();
    prefs?.setBool('vibrate', value);
  }

  void setCurvedLines(bool curve) {
    curveLines = curve;
    notifyListeners();
    prefs?.setBool('curveLines', curve);
  }

  void setHideTimer(bool hide) {
    hideTimerTab = hide;
    notifyListeners();
    prefs?.setBool('hideTimerTab', hide);
  }

  void setHideHistory(bool hide) {
    hideHistoryTab = hide;
    notifyListeners();
    prefs?.setBool('hideHistoryTab', hide);
  }

  void setExplained(bool explained) {
    explainedPermissions = explained;
    notifyListeners();
    prefs?.setBool('explainedPermissions', explained);
  }

  void setLong(String format) {
    longDateFormat = format;
    notifyListeners();
    prefs?.setString('longDateFormat', format);
  }

  void setShort(String format) {
    shortDateFormat = format;
    notifyListeners();
    prefs?.setString('shortDateFormat', format);
  }

  void setSystem(bool system) {
    systemColors = system;
    prefs?.setBool('systemColors', system);
    notifyListeners();
  }

  void setUnits(bool show) {
    showUnits = show;
    prefs?.setBool('showUnits', show);
    notifyListeners();
  }

  void setTimers(bool show) {
    restTimers = show;
    prefs?.setBool('restTimers', show);
    notifyListeners();
  }

  void setReorder(bool show) {
    showReorder = show;
    prefs?.setBool('showReorder', show);
    notifyListeners();
  }

  void setTheme(ThemeMode theme) {
    themeMode = theme;
    prefs?.setString('themeMode', theme.toString());
    notifyListeners();
  }
}
