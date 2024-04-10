import 'package:flexify/main.dart';
import 'package:flexify/native_timer_wrapper.dart';
import 'package:flutter/material.dart';

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
