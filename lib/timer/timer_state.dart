import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flexify/main.dart';
import 'package:flexify/native_timer_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class TimerState extends ChangeNotifier {
  NativeTimerWrapper timer = NativeTimerWrapper.emptyTimer();
  Timer? next;
  AudioPlayer? player;
  bool starting = false;
  bool _keepScreenOn = true;

  bool get keepScreenOn => _keepScreenOn;

  void setKeepScreenOn(bool value) {
    _keepScreenOn = value;
    if (!value) {
      WakelockPlus.disable().catchError((_) {});
    }
  }

  TimerState({bool keepScreenOn = true}) {
    _keepScreenOn = keepScreenOn;
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
    bool enableSound,
  ) async {
    starting = false;
    final updated = timer.increaseDuration(
      const Duration(minutes: 1),
    );
    updateTimer(updated);
    final args = {
      'timestamp': updated.getTimeStamp(),
      'alarmSound': alarmSound,
      'vibrate': vibrate,
      'enableSound': enableSound,
    };
    if (!kIsWeb && Platform.isAndroid) {
      androidChannel.invokeMethod('add', args);
    } else {
      next?.cancel();
      next = Timer(
        const Duration(minutes: 1),
        () => notify(null, alarmSound, enableSound),
      );
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
    bool enableSound,
  ) async {
    if (_keepScreenOn) {
      WakelockPlus.enable().catchError((_) {});
    }
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
      'enableSound': enableSound,
    };
    if (!kIsWeb && Platform.isAndroid) {
      await androidChannel.invokeMethod('timer', args);
    } else {
      next?.cancel();
      next = Timer(rest, () => notify(title, alarmSound, enableSound));
    }
  }

  Future<void> notify(
    String? title,
    String? alarmSound,
    bool enableSound,
  ) async {
    if (player != null && enableSound) {
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
      windows: WindowsInitializationSettings(
        appName: 'Flexify',
        appUserModelId: 'com.presley.flexify',
        guid: '550e8400-e29b-41d4-a716-446655440000',
        iconPath: 'assets/ic_launcher.png',
      ),
    );
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(init);
    await plugin.show(1, title ?? "Timer up", null, null);
  }

  Future<void> stopTimer() async {
    updateTimer(NativeTimerWrapper.emptyTimer());
    WakelockPlus.disable().catchError((_) {});
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
    if (updated.state == NativeTimerState.expired ||
        updated.state == NativeTimerState.paused) {
      WakelockPlus.disable().catchError((_) {});
    }
    notifyListeners();
  }
}
