import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState extends ChangeNotifier {
  SharedPreferences? prefs;
  ThemeMode themeMode = ThemeMode.system;
  Duration timerDuration = const Duration(minutes: 3, seconds: 30);
  bool showReorder = true;
  bool restTimers = true;
  bool showUnits = true;

  SettingsState() {
    SharedPreferences.getInstance().then((value) {
      prefs = value;

      final theme = value.getString('themeMode');
      if (theme == "ThemeMode.system")
        themeMode = ThemeMode.system;
      else if (theme == "ThemeMode.light")
        themeMode = ThemeMode.light;
      else if (theme == "ThemeMode.dark") themeMode = ThemeMode.dark;

      final ms = value.getInt("timerDuration");
      if (ms != null) timerDuration = Duration(milliseconds: ms);

      showReorder = value.getBool("showReorder") ?? true;
      restTimers = value.getBool("restTimers") ?? true;

      notifyListeners();
    });
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
