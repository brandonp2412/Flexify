import 'dart:async';
import 'dart:io';

import 'package:flex/audio/safe_audio_player.dart';
import 'package:flex/crash_logger.dart';
import 'package:flex/logging.dart';
import 'package:flex/main.dart';
import 'package:flex/native_timer_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class TimerState extends ChangeNotifier {
  NativeTimerWrapper timer = NativeTimerWrapper.emptyTimer();
  Timer? next;
  final SafeAudioPlayer player = SafeAudioPlayer(enabled: !kIsWeb);
  bool starting = false;
  bool justExpired = false;
  bool _keepScreenOn = true;
  String _target = 'timer';
  String? _pendingTarget;

  FlutterLocalNotificationsPlugin? _notifications;
  String _timerUpTitle = '';
  String _openLabel = '';
  String _stopLabel = '';
  String _addMinuteLabel = '';
  String _restTimerTitle = '';
  String _channelName = '';
  String _timerChannelDesc = '';
  String _doneChannel = '';
  String _doneChannelDesc = '';
  String _doneTitle = '';
  String _alarmUnavailable = '';

  bool get keepScreenOn => _keepScreenOn;

  void setNotificationLocalizations({
    required String upTitle,
    required String openLabel,
    required String stopLabel,
    required String addMinuteLabel,
    required String restTitle,
    required String timerChannel,
    required String timerDesc,
    required String doneChannel,
    required String doneDesc,
    required String doneTitle,
    required String alarmUnavailable,
  }) {
    _timerUpTitle = upTitle;
    _stopLabel = stopLabel;
    _addMinuteLabel = addMinuteLabel;
    _restTimerTitle = restTitle;
    _channelName = timerChannel;
    _timerChannelDesc = timerDesc;
    _doneChannel = doneChannel;
    _doneChannelDesc = doneDesc;
    _doneTitle = doneTitle;
    _alarmUnavailable = alarmUnavailable;
    if (_openLabel == openLabel) return;
    _openLabel = openLabel;
    _notifications = null;
  }

  void setKeepScreenOn(bool value) {
    _keepScreenOn = value;
    if (!value && !kIsWeb && Platform.isAndroid) {
      WakelockPlus.disable().catchError((error, stackTrace) {
        talker.handle(error, stackTrace, 'Failed to disable wakelock');
      });
    }
  }

  TimerState({bool keepScreenOn = true}) {
    _keepScreenOn = keepScreenOn;

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
    final target = _pendingTarget;
    _pendingTarget = null;
    return target;
  }

  void _setNotificationTarget(String? target) {
    if (target == null || target.isEmpty) return;
    _pendingTarget = target;
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
    bool keepRinging,
  ) async {
    starting = false;
    final updated = timer.increaseDuration(const Duration(minutes: 1));
    updateTimer(updated);
    final args = {
      'timestamp': updated.stamp.millisecondsSinceEpoch,
      'alarmSound': alarmSound,
      'vibrate': vibrate,
      'enableSound': enableSound,
      'keepRinging': keepRinging,
      'target': _target,
      'stopLabel': _stopLabel,
      'addOneMinuteLabel': _addMinuteLabel,
      'restTimerTitle': _restTimerTitle,
      'timerChannelName': _channelName,
      'timerChannelDescription': _timerChannelDesc,
      'timerFinishedChannelName': _doneChannel,
      'timerFinishedChannelDescription': _doneChannelDesc,
      'timerFinishedTitle': _doneTitle,
      'exactAlarmRequestUnavailable': _alarmUnavailable,
    };
    if (!kIsWeb && Platform.isAndroid) {
      androidChannel.invokeMethod('add', args);
    } else {
      next?.cancel();
      next = Timer(
        const Duration(minutes: 1),
        () => _expireDesktopTimer(null, alarmSound, enableSound, keepRinging),
      );
    }
  }

  @override
  void dispose() {
    next?.cancel();
    player.dispose();
    super.dispose();
  }

  Future<void> startTimer(
    String title,
    Duration rest,
    String alarmSound,
    bool vibrate,
    bool enableSound, [
    String target = 'timer',
    bool keepRinging = false,
  ]) async {
    talker.info('Starting rest timer for ${rest.inSeconds} seconds');
    _target = target;
    if (_keepScreenOn && !kIsWeb && Platform.isAndroid) {
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
      'timestamp': timer.stamp.millisecondsSinceEpoch,
      'restMs': rest.inMilliseconds,
      'alarmSound': alarmSound,
      'vibrate': vibrate,
      'enableSound': enableSound,
      'keepRinging': keepRinging,
      'target': target,
      'stopLabel': _stopLabel,
      'addOneMinuteLabel': _addMinuteLabel,
      'restTimerTitle': _restTimerTitle,
      'timerChannelName': _channelName,
      'timerChannelDescription': _timerChannelDesc,
      'timerFinishedChannelName': _doneChannel,
      'timerFinishedChannelDescription': _doneChannelDesc,
      'timerFinishedTitle': _doneTitle,
      'exactAlarmRequestUnavailable': _alarmUnavailable,
    };
    if (!kIsWeb && Platform.isAndroid) {
      await androidChannel.invokeMethod('timer', args);
    } else {
      next?.cancel();
      next = Timer(
        rest,
        () => _expireDesktopTimer(title, alarmSound, enableSound, keepRinging),
      );
    }
  }

  Future<void> _expireDesktopTimer(
    String? title,
    String alarmSound,
    bool enableSound,
    bool keepRinging,
  ) async {
    final duration = timer.total;
    justExpired = true;
    updateTimer(
      NativeTimerWrapper(
        duration,
        duration,
        DateTime.now(),
        NativeTimerState.expired,
      ),
    );
    await notify(title, alarmSound, enableSound, keepRinging);
  }

  /// Lazily builds and initializes the notification plugin a single time.
  ///
  /// Re-initializing on every timer expiry repeatedly re-registers the native
  /// (WinRT) notification stack on Windows, which was a likely source of
  /// intermittent crashes; initializing once avoids that churn.
  Future<FlutterLocalNotificationsPlugin?> _getNotifications() async {
    if (_notifications != null) return _notifications;

    final linux = LinuxInitializationSettings(defaultActionName: _openLabel);
    const darwin = DarwinInitializationSettings();
    final init = InitializationSettings(
      linux: linux,
      macOS: darwin,
      iOS: darwin,
      android: const AndroidInitializationSettings('ic_launcher'),
      windows: const WindowsInitializationSettings(
        appName: 'Flex',
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
    bool keepRinging,
  ) async {
    talker.info('Rest timer expired');
    if (enableSound) {
      if (alarmSound?.isNotEmpty == true) {
        await player.playFile(alarmSound!, loop: keepRinging);
      } else {
        await player.playAsset('argon.mp3', loop: keepRinging);
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
    if (kIsWeb || !Platform.isAndroid) {
      player.stop();
      next?.cancel();
    } else {
      WakelockPlus.disable().catchError((error, stackTrace) {
        talker.handle(error, stackTrace, 'Failed to disable wakelock');
      });
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
    if ((updated.state == NativeTimerState.expired ||
            updated.state == NativeTimerState.paused) &&
        !kIsWeb &&
        Platform.isAndroid) {
      WakelockPlus.disable().catchError((error, stackTrace) {
        talker.handle(error, stackTrace, 'Failed to disable wakelock');
      });
    }
    notifyListeners();
  }
}
