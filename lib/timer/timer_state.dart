import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flexify/crash_logger.dart';
import 'package:flexify/main.dart';
import 'package:flexify/logging.dart';
import 'package:flexify/native_timer_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class TimerState extends ChangeNotifier {
  NativeTimerWrapper timer = NativeTimerWrapper.emptyTimer();
  Timer? next;
  AudioPlayer? player;
  bool starting = false;
  bool justExpired = false;
  bool _keepScreenOn = true;
  String _target = 'timer';
  String? _notificationTarget;

  FlutterLocalNotificationsPlugin? _notifications;
  String _timerUpTitle = '';
  String _openNotificationLabel = '';
  String _stopLabel = '';
  String _addOneMinuteLabel = '';
  String _restTimerTitle = '';
  String _timerChannelName = '';
  String _timerChannelDescription = '';
  String _timerFinishedChannelName = '';
  String _timerFinishedChannelDescription = '';
  String _timerFinishedTitle = '';
  String _exactAlarmRequestUnavailable = '';

  bool get keepScreenOn => _keepScreenOn;

  void setNotificationLocalizations({
    required String timerUpTitle,
    required String openNotificationLabel,
    required String stopLabel,
    required String addOneMinuteLabel,
    required String restTimerTitle,
    required String timerChannelName,
    required String timerChannelDescription,
    required String timerFinishedChannelName,
    required String timerFinishedChannelDescription,
    required String timerFinishedTitle,
    required String exactAlarmRequestUnavailable,
  }) {
    _timerUpTitle = timerUpTitle;
    _stopLabel = stopLabel;
    _addOneMinuteLabel = addOneMinuteLabel;
    _restTimerTitle = restTimerTitle;
    _timerChannelName = timerChannelName;
    _timerChannelDescription = timerChannelDescription;
    _timerFinishedChannelName = timerFinishedChannelName;
    _timerFinishedChannelDescription = timerFinishedChannelDescription;
    _timerFinishedTitle = timerFinishedTitle;
    _exactAlarmRequestUnavailable = exactAlarmRequestUnavailable;
    if (_openNotificationLabel == openNotificationLabel) return;
    _openNotificationLabel = openNotificationLabel;
    _notifications = null;
  }

  void setKeepScreenOn(bool value) {
    _keepScreenOn = value;
    if (!value) {
      WakelockPlus.disable().catchError((error, stackTrace) {
        talker.handle(error, stackTrace, 'Failed to disable wakelock');
      });
    }
  }

  TimerState({bool keepScreenOn = true}) {
    _keepScreenOn = keepScreenOn;
    if (!kIsWeb) {
      try {
        player = AudioPlayer();
      } catch (error, stackTrace) {
        talker.handle(error, stackTrace, 'Failed to create timer audio player');
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
      } else if (call.method == 'timerExpired') {
        justExpired = true;
        notifyListeners();
      } else if (call.method == 'notificationTap') {
        _setNotificationTarget(call.arguments as String?);
      }
    });
    if (!kIsWeb && Platform.isAndroid) {
      androidChannel
          .invokeMethod<String>('getNotificationTarget')
          .then(
            _setNotificationTarget,
            onError: (Object error, StackTrace stackTrace) {
              talker.handle(
                error,
                stackTrace,
                'Failed to read notification target',
              );
            },
          );
    }
  }

  String? consumeNotificationTarget() {
    final target = _notificationTarget;
    _notificationTarget = null;
    return target;
  }

  void _setNotificationTarget(String? target) {
    if (target == null || target.isEmpty) return;
    _notificationTarget = target;
    notifyListeners();
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
    final updated = timer.increaseDuration(const Duration(minutes: 1));
    updateTimer(updated);
    final args = {
      'timestamp': updated.getTimeStamp(),
      'alarmSound': alarmSound,
      'vibrate': vibrate,
      'enableSound': enableSound,
      'target': _target,
      'stopLabel': _stopLabel,
      'addOneMinuteLabel': _addOneMinuteLabel,
      'restTimerTitle': _restTimerTitle,
      'timerChannelName': _timerChannelName,
      'timerChannelDescription': _timerChannelDescription,
      'timerFinishedChannelName': _timerFinishedChannelName,
      'timerFinishedChannelDescription': _timerFinishedChannelDescription,
      'timerFinishedTitle': _timerFinishedTitle,
      'exactAlarmRequestUnavailable': _exactAlarmRequestUnavailable,
    };
    if (!kIsWeb && Platform.isAndroid) {
      androidChannel.invokeMethod('add', args);
    } else {
      next?.cancel();
      next = Timer(
        const Duration(minutes: 1),
        () => _expireDesktopTimer(null, alarmSound, enableSound),
      );
    }
  }

  @override
  void dispose() {
    next?.cancel();
    player?.dispose();
    super.dispose();
  }

  Future<void> startTimer(
    String title,
    Duration rest,
    String alarmSound,
    bool vibrate,
    bool enableSound, [
    String target = 'timer',
  ]) async {
    talker.info('Starting rest timer for ${rest.inSeconds} seconds');
    _target = target;
    if (_keepScreenOn) {
      WakelockPlus.enable().catchError((error, stackTrace) {
        talker.handle(error, stackTrace, 'Failed to enable wakelock');
      });
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
      'target': target,
      'stopLabel': _stopLabel,
      'addOneMinuteLabel': _addOneMinuteLabel,
      'restTimerTitle': _restTimerTitle,
      'timerChannelName': _timerChannelName,
      'timerChannelDescription': _timerChannelDescription,
      'timerFinishedChannelName': _timerFinishedChannelName,
      'timerFinishedChannelDescription': _timerFinishedChannelDescription,
      'timerFinishedTitle': _timerFinishedTitle,
      'exactAlarmRequestUnavailable': _exactAlarmRequestUnavailable,
    };
    if (!kIsWeb && Platform.isAndroid) {
      await androidChannel.invokeMethod('timer', args);
    } else {
      next?.cancel();
      next = Timer(
        rest,
        () => _expireDesktopTimer(title, alarmSound, enableSound),
      );
    }
  }

  Future<void> _expireDesktopTimer(
    String? title,
    String alarmSound,
    bool enableSound,
  ) async {
    final duration = timer.getDuration();
    justExpired = true;
    updateTimer(
      NativeTimerWrapper(
        duration,
        duration,
        DateTime.now(),
        NativeTimerState.expired,
      ),
    );
    await notify(title, alarmSound, enableSound);
  }

  /// Lazily builds and initializes the notification plugin a single time.
  ///
  /// Re-initializing on every timer expiry repeatedly re-registers the native
  /// (WinRT) notification stack on Windows, which was a likely source of
  /// intermittent crashes; initializing once avoids that churn.
  Future<FlutterLocalNotificationsPlugin?> _getNotifications() async {
    if (_notifications != null) return _notifications;

    final linux = LinuxInitializationSettings(
      defaultActionName: _openNotificationLabel,
    );
    const darwin = DarwinInitializationSettings();
    final init = InitializationSettings(
      linux: linux,
      macOS: darwin,
      iOS: darwin,
      android: const AndroidInitializationSettings('ic_launcher'),
      windows: const WindowsInitializationSettings(
        appName: 'Flexify',
        appUserModelId: 'com.presley.flexify',
        guid: '550e8400-e29b-41d4-a716-446655440000',
        iconPath: 'assets/ic_launcher.png',
      ),
    );

    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(settings: init);
    _notifications = plugin;
    return _notifications;
  }

  Future<void> notify(
    String? title,
    String? alarmSound,
    bool enableSound,
  ) async {
    talker.info('Rest timer expired');
    if (player != null && enableSound) {
      try {
        await player!.play(
          alarmSound?.isNotEmpty == true
              ? DeviceFileSource(alarmSound!)
              : AssetSource('argon.mp3'),
        );
      } catch (error, stack) {
        CrashLogger.instance?.record(error, stack, context: 'notify.play');
      }
    }

    try {
      final plugin = await _getNotifications();
      await plugin?.show(id: 1, title: title ?? _timerUpTitle);
    } catch (error, stack) {
      CrashLogger.instance?.record(error, stack, context: 'notify.show');
    }
  }

  Future<void> stopTimer() async {
    talker.info('Stopping rest timer');
    _target = 'timer';
    updateTimer(NativeTimerWrapper.emptyTimer());
    WakelockPlus.disable().catchError((error, stackTrace) {
      talker.handle(error, stackTrace, 'Failed to disable wakelock');
    });
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
      WakelockPlus.disable().catchError((error, stackTrace) {
        talker.handle(error, stackTrace, 'Failed to disable wakelock');
      });
    }
    notifyListeners();
  }
}
