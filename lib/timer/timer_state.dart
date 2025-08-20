import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flexify/main.dart';
import 'package:flexify/native_timer_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TimerState extends ChangeNotifier {
  NativeTimerWrapper timer = NativeTimerWrapper.emptyTimer();
  Timer? next;
  AudioPlayer? player;
  bool starting = false;

  TimerState() {
    if (!kIsWeb) {
      try {
        player = AudioPlayer();
      } catch (e) {
        print('Failed to create AudioPlayer: $e');
        player = null;
      }
    }

    androidChannel.setMethodCallHandler((call) async {
      if (call.method == 'tick') {
        final timer = NativeTimerWrapper(
          Duration(milliseconds: call.arguments[0]),
          Duration(milliseconds: call.arguments[1]),
          DateTime.fromMillisecondsSinceEpoch(call.arguments[2], isUtc: true),
          NativeTimerState.values[call.arguments[3] as int],
        );

        updateTimer(timer);
      }
    });
  }

  void setStarting(bool value) {
    starting = value;
    notifyListeners();
  }

  Future<void> addOneMinute(
    String alarmSound,
    bool vibrate,
  ) async {
    final updated = timer.increaseDuration(
      const Duration(minutes: 1),
    );
    updateTimer(updated);
    final args = {
      'timestamp': updated.getTimeStamp(),
      'alarmSound': alarmSound,
      'vibrate': vibrate,
    };
    if (!kIsWeb && Platform.isAndroid) {
      androidChannel.invokeMethod('add', args);
    } else {
      next?.cancel();
      next = Timer(const Duration(minutes: 1), () => notify(null, alarmSound));
    }
  }

  @override
  void dispose() {
    super.dispose();
    next?.cancel();
  }

  Future<void> startTimer(
    String title,
    Duration rest,
    String alarmSound,
    bool vibrate,
  ) async {
    final timer = NativeTimerWrapper(
      rest,
      Duration.zero,
      DateTime.now(),
      NativeTimerState.running,
    );
    updateTimer(timer);
    final args = {
      'title': title,
      'timestamp': timer.getTimeStamp(),
      'restMs': rest.inMilliseconds,
      'alarmSound': alarmSound,
      'vibrate': vibrate,
    };
    if (!kIsWeb && Platform.isAndroid) {
      await androidChannel.invokeMethod('timer', args);
    } else {
      next?.cancel();
      next = Timer(rest, () => notify(title, alarmSound));
    }
  }

  notify(String? title, String? alarmSound) async {
    if (player != null) {
      player!.play(
        alarmSound?.isNotEmpty == true
            ? DeviceFileSource(alarmSound!)
            : AssetSource('argon.mp3'),
      );
    }

    const linux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    const darwin = DarwinInitializationSettings();
    const init = InitializationSettings(
      linux: linux,
      macOS: darwin,
      iOS: darwin,
      android: AndroidInitializationSettings('ic_launcher'),
    );
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(init);
    await plugin.show(1, title ?? "Timer up", null, null);
  }

  Future<void> stopTimer() async {
    updateTimer(NativeTimerWrapper.emptyTimer());
    if (kIsWeb || !Platform.isAndroid) {
      player?.stop();
      next?.cancel();
    } else {
      androidChannel.invokeMethod('stop');
    }
  }

  void setTimer(int total, int progress) {
    timer = NativeTimerWrapper(
      Duration(seconds: total),
      Duration(seconds: progress),
      DateTime.now(),
      NativeTimerState.running,
    );
    notifyListeners();
  }

  void updateTimer(NativeTimerWrapper updated) {
    timer = updated;
    notifyListeners();
  }
}
