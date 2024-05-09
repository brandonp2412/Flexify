import 'package:flexify/main.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState extends ChangeNotifier {
  SharedPreferences? prefs;

  ThemeMode themeMode = ThemeMode.system;
  Duration timerDuration = const Duration(minutes: 3, seconds: 30);
  int maxSets = 5;
  String longDateFormat = 'dd/MM/yy';
  String shortDateFormat = 'd/M/yy';
  String? alarmSound;

  bool vibrate = true;
  bool showReorder = true;
  bool restTimers = true;
  bool showUnits = true;
  bool systemColors = true;
  bool explainedPermissions = false;
  bool hideTimerTab = false;
  bool hideHistoryTab = false;
  bool curveLines = false;
  bool automaticBackup = false;

  Future<void> init() async {
    final prefsInstance = await SharedPreferences.getInstance();

    prefs = prefsInstance;

    alarmSound = prefsInstance.getString('alarmSound');
    longDateFormat = prefsInstance.getString('longDateFormat') ?? "dd/MM/yy";
    shortDateFormat = prefsInstance.getString('shortDateFormat') ?? "d/M/yy";
    final theme = prefsInstance.getString('themeMode');
    if (theme == "ThemeMode.system")
      themeMode = ThemeMode.system;
    else if (theme == "ThemeMode.light")
      themeMode = ThemeMode.light;
    else if (theme == "ThemeMode.dark") themeMode = ThemeMode.dark;

    maxSets = prefsInstance.getInt("maxSets") ?? 5;
    final ms = prefsInstance.getInt("timerDuration");
    if (ms != null) timerDuration = Duration(milliseconds: ms);

    systemColors = prefsInstance.getBool("systemColors") ?? true;
    showReorder = prefsInstance.getBool("showReorder") ?? true;
    restTimers = prefsInstance.getBool("restTimers") ?? true;
    showUnits = prefsInstance.getBool("showUnits") ?? true;
    hideTimerTab = prefsInstance.getBool("hideTimerTab") ?? false;
    hideHistoryTab = prefsInstance.getBool("hideHistoryTab") ?? false;
    explainedPermissions =
        prefsInstance.getBool('explainedPermissions') ?? false;
    curveLines = prefsInstance.getBool('curveLines') ?? false;
    automaticBackup = prefsInstance.getBool('automaticBackup') ?? false;
    vibrate = prefsInstance.getBool('vibrate') ?? true;
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

  void setMaxSets(int max) {
    maxSets = max;
    notifyListeners();
    prefs?.setInt('maxSets', max);
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

  void setDuration(Duration duration) {
    timerDuration = duration;
    prefs?.setInt('timerDuration', duration.inMilliseconds);
    notifyListeners();
  }

  void setTheme(ThemeMode theme) {
    themeMode = theme;
    prefs?.setString('themeMode', theme.toString());
    notifyListeners();
  }
}
