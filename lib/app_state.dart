import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
import 'native_timer_wrapper.dart';

class SettingsState extends ChangeNotifier {
  SharedPreferences? prefs;
  ThemeMode themeMode = ThemeMode.system;
  Duration timerDuration = const Duration(minutes: 3, seconds: 30);
  bool showReorder = true;
  bool restTimers = true;
  bool showUnits = true;
  bool systemColors = true;
  String dateFormat = "yyyy-MM-dd h:mm a";

  Future<void> init() async {
    final prefsInstance = await SharedPreferences.getInstance();

    prefs = prefsInstance;

    final theme = prefsInstance.getString('themeMode');
    if (theme == "ThemeMode.system")
      themeMode = ThemeMode.system;
    else if (theme == "ThemeMode.light")
      themeMode = ThemeMode.light;
    else if (theme == "ThemeMode.dark") themeMode = ThemeMode.dark;

    final ms = prefsInstance.getInt("timerDuration");
    if (ms != null) timerDuration = Duration(milliseconds: ms);

    showReorder = prefsInstance.getBool("showReorder") ?? true;
    restTimers = prefsInstance.getBool("restTimers") ?? true;
    showUnits = prefsInstance.getBool("showUnits") ?? true;
    dateFormat = prefsInstance.getString('dateFormat') ?? "yyyy-MM-dd h:mm a";
  }

  void setFormat(String format) {
    dateFormat = format;
    notifyListeners();
    prefs?.setString('dateFormat', format);
  }

  Future<void> setSystem(bool system) async {
    systemColors = system;
    await prefs?.setBool('systemColors', system);
    notifyListeners();
  }

  Future<void> setUnits(bool show) async {
    showUnits = show;
    await prefs?.setBool('showUnits', show);
    notifyListeners();
  }

  Future<void> setTimers(bool show) async {
    restTimers = show;
    await prefs?.setBool('restTimers', show);
    notifyListeners();
  }

  Future<void> setReorder(bool show) async {
    showReorder = show;
    await prefs?.setBool('showReorder', show);
    notifyListeners();
  }

  Future<void> setDuration(Duration duration) async {
    timerDuration = duration;
    await prefs?.setInt('timerDuration', duration.inMilliseconds);
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode theme) async {
    themeMode = theme;
    await prefs?.setString('themeMode', theme.toString());
    notifyListeners();
  }
}

class TimerState extends ChangeNotifier {
  NativeTimerWrapper nativeTimer = NativeTimerWrapper.emptyTimer();

  TimerState() {
    android.setMethodCallHandler((call) async {
      if (call.method == 'tick') {
        final newTimer = NativeTimerWrapper(
          Duration(milliseconds: call.arguments[0]),
          Duration(milliseconds: call.arguments[1]),
          DateTime.fromMillisecondsSinceEpoch(call.arguments[2], isUtc: true),
          NativeTimerState.values[call.arguments[3] as int],
        );

        updateTimer(newTimer);
      }
    });
  }

  Future<void> addOneMinute() async {
    final newTimer = nativeTimer.increaseDuration(
      const Duration(minutes: 1),
    );
    updateTimer(newTimer);
    await android.invokeMethod('add', [newTimer.getTimeStamp()]);
  }

  Future<void> stopTimer() async {
    updateTimer(NativeTimerWrapper.emptyTimer());
    await android.invokeMethod('stop');
  }

  Future<void> startTimer(String title, Duration timerDuration) async {
    final timer = NativeTimerWrapper(
      timerDuration,
      Duration.zero,
      DateTime.now(),
      NativeTimerState.running,
    );
    updateTimer(timer);
    await android.invokeMethod(
      'timer',
      [timerDuration.inMilliseconds, title, timer.getTimeStamp()],
    );
  }

  void updateTimer(NativeTimerWrapper newTimer) {
    nativeTimer = newTimer;
    notifyListeners();
  }
}
