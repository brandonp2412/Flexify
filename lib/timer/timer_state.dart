import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flexify/main.dart';
import 'package:flexify/native_timer_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class TimerState extends ChangeNotifier {
  String _alarmSound = "";
  bool _vibrate = false;
  NativeTimerWrapper nativeTimer = NativeTimerWrapper.emptyTimer();

  Future<TimerState> init() async => this;

  void _updateAlarmDetails(String pAlarmSound, bool pVibrate) {
    _alarmSound = pAlarmSound;
    _vibrate = pVibrate;
  }

  Future<void> addOneMinute(String pAlarmSound, bool pVibrate) async {
    final newTimer = nativeTimer.increaseDuration(
      const Duration(minutes: 1),
    );
    updateTimer(newTimer);
    _updateAlarmDetails(pAlarmSound, pVibrate);
  }

  Future<void> startTimer(
    String title,
    Duration rest,
    String pAlarmSound,
    bool pVibrate,
  ) async {
    final newTimer = NativeTimerWrapper(
      rest,
      Duration.zero,
      DateTime.now(),
      NativeTimerState.running,
    );
    updateTimer(newTimer);
    _updateAlarmDetails(pAlarmSound, pVibrate);
  }

  Future<void> stopTimer() async {
    updateTimer(NativeTimerWrapper.emptyTimer());
  }

  void updateTimer(NativeTimerWrapper newTimer) {
    nativeTimer = newTimer;
    notifyListeners();
  }

  static Future<TimerState> getTimerState() async =>
      await (Platform.isAndroid ? AndroidTimerState() : DartTimerState())
          .init();
}

class AndroidTimerState extends TimerState {
  AndroidTimerState() {
    androidChannel.setMethodCallHandler((call) async {
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

  @override
  Future<void> addOneMinute(String pAlarmSound, bool pVibrate) async {
    await super.addOneMinute(pAlarmSound, pVibrate);
    final args = {
      'timestamp': nativeTimer.getTimeStamp(),
      'alarmSound': _alarmSound,
      'vibrate': _vibrate,
    };
    await androidChannel.invokeMethod('add', args);
  }

  @override
  Future<void> startTimer(String title, Duration rest, String pAlarmSound, bool pVibrate) async {
    await super.startTimer(title, rest, pAlarmSound, pVibrate);
    final args = {
      'title': title,
      'timestamp': nativeTimer.getTimeStamp(),
      'restMs': nativeTimer.getDuration().inMilliseconds,
      'alarmSound': _alarmSound,
      'vibrate': _vibrate,
    };
    await androidChannel.invokeMethod('timer', args);
  }

  @override
  Future<void> stopTimer() async {
    await super.stopTimer();
    await androidChannel.invokeMethod('stop');
  }
}

class DartTimerState extends TimerState {
  Timer? next;
  final player = AudioPlayer();
  late final FlutterLocalNotificationsPlugin notificationPlugin;
  final NotificationDetails timerNotificationDetails =
      const NotificationDetails(
    linux: LinuxNotificationDetails(
      actions: [
        LinuxNotificationAction(
          key: "stop",
          label: 'Stop',
        ),
        LinuxNotificationAction(
          key: "add",
          label: 'Add 1 min',
        ),
      ],
      defaultActionName: '',
    ),
  );

  Future<void> onNotificationPress(final NotificationResponse resp) async {
    switch (resp.actionId) {
      case "stop":
        await stopTimer();
        break;
      case "add":
        await addOneMinute(_alarmSound, _vibrate);
        break;
      default:
        if (!nativeTimer.isRunning()) await stopTimer();
        break;
    }
  }

  @override
  Future<TimerState> init() async {
    const linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
    );
    const darwinSettings = DarwinInitializationSettings();
    final initSettings = InitializationSettings(
      linux: linuxSettings,
      macOS: darwinSettings,
      iOS: darwinSettings,
      android: defaultTargetPlatform == TargetPlatform.android
          ? const AndroidInitializationSettings('app_icon')
          : null, // Needed to fix tests
    );
    notificationPlugin = FlutterLocalNotificationsPlugin();
    await notificationPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (resp) async =>
          await onNotificationPress(resp),
    );
    return this;
  }

  @override
  void dispose() {
    super.dispose();
    next?.cancel();
  }

  Future<void> _notify(String? title, String? alarmSound) async {
    updateTimer(NativeTimerWrapper.emptyTimer());
    next?.cancel();
    player.play(
      alarmSound?.isNotEmpty == true
          ? DeviceFileSource(alarmSound!)
          : AssetSource('argon.mp3'),
    );

    await notificationPlugin.show(
      1,
      title ?? "Timer up",
      null,
      timerNotificationDetails,
    );
  }

  Future<void> _timerLoop(String? title) async {
    if (!nativeTimer.isRunning() ||
        nativeTimer.getRemaining().inMilliseconds <= 0)
      return await _notify(title, _alarmSound);
    final remaining = nativeTimer.getRemaining();
    await notificationPlugin.show(
      1,
      title ?? "Rest timer",
      '${remaining.inMinutes.toString().padLeft(2, '0')}:${remaining.inSeconds.remainder(60).toString().padLeft(2, '0')}',
      timerNotificationDetails,
    );
  }

  Future<void> _startTimerLoop(String? title) async {
    next?.cancel();
    await _timerLoop(title);
    next = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async => await _timerLoop(title),
    );
  }

  @override
  Future<void> addOneMinute(String pAlarmSound, bool pVibrate) async {
    await super.addOneMinute(pAlarmSound, pVibrate);
    await _startTimerLoop(null);
  }

  @override
  Future<void> startTimer(String title, Duration rest, String pAlarmSound, bool pVibrate) async {
    await super.startTimer(title, rest, pAlarmSound, pVibrate);
    await _startTimerLoop(null);
  }

  @override
  Future<void> stopTimer() async {
    await super.stopTimer();
    player.stop();
    next?.cancel();
    await notificationPlugin.cancel(1);
  }
}
