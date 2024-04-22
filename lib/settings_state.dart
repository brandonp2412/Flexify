import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState extends ChangeNotifier {
  SharedPreferences? prefs;

  ThemeMode themeMode = ThemeMode.system;
  Duration timerDuration = const Duration(minutes: 3, seconds: 30);
  String dateFormat = 'dd/MM/yy';

  bool showReorder = true;
  bool restTimers = true;
  bool showUnits = true;
  bool systemColors = true;
  bool explainedPermissions = false;
  bool hideTimerTab = false;
  bool curveLines = false;

  Future<void> init() async {
    final prefsInstance = await SharedPreferences.getInstance();

    prefs = prefsInstance;

    dateFormat = prefsInstance.getString('dateFormat') ?? "yyyy-MM-dd h:mm a";
    final theme = prefsInstance.getString('themeMode');
    if (theme == "ThemeMode.system")
      themeMode = ThemeMode.system;
    else if (theme == "ThemeMode.light")
      themeMode = ThemeMode.light;
    else if (theme == "ThemeMode.dark") themeMode = ThemeMode.dark;

    final ms = prefsInstance.getInt("timerDuration");
    if (ms != null) timerDuration = Duration(milliseconds: ms);

    systemColors = prefsInstance.getBool("systemColors") ?? true;
    showReorder = prefsInstance.getBool("showReorder") ?? true;
    restTimers = prefsInstance.getBool("restTimers") ?? true;
    showUnits = prefsInstance.getBool("showUnits") ?? true;
    hideTimerTab = prefsInstance.getBool("hideTimerTab") ?? false;
    explainedPermissions =
        prefsInstance.getBool('explainedPermissions') ?? false;
    curveLines = prefsInstance.getBool('curveLines') ?? false;
  }

  void setCurvedLines(bool curve) {
    curveLines = curve;
    notifyListeners();
    prefs?.setBool('curveLines', curve);
  }

  void setHideTimerTab(bool hide) {
    hideTimerTab = hide;
    notifyListeners();
    prefs?.setBool('hideTimerTab', hide);
  }

  void setExplained(bool explained) {
    explainedPermissions = explained;
    notifyListeners();
    prefs?.setBool('explainedPermissions', explained);
  }

  void setFormat(String format) {
    dateFormat = format;
    notifyListeners();
    prefs?.setString('dateFormat', format);
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
