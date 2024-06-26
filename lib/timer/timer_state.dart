import 'package:flexify/main.dart';
import 'package:flexify/native_timer_wrapper.dart';
import 'package:flutter/material.dart';

class TimerState extends ChangeNotifier {
  NativeTimerWrapper nativeTimer = NativeTimerWrapper.emptyTimer();

  TimerState() {
    timerChannel.setMethodCallHandler((call) async {
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

  Future<void> addOneMinute(
    String alarmSound,
    bool vibrate,
  ) async {
    final newTimer = nativeTimer.increaseDuration(
      const Duration(minutes: 1),
    );
    updateTimer(newTimer);
    final args = {
      'timestamp': newTimer.getTimeStamp(),
      'alarmSound': alarmSound,
      'vibrate': vibrate,
    };
    await timerChannel.invokeMethod('add', args);
  }

  Future<void> stopTimer() async {
    updateTimer(NativeTimerWrapper.emptyTimer());
    await timerChannel.invokeMethod('stop');
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
    await timerChannel.invokeMethod('timer', args);
  }

  void updateTimer(NativeTimerWrapper newTimer) {
    nativeTimer = newTimer;
    notifyListeners();
  }
}
