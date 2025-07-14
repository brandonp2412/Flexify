enum NativeTimerState { running, paused, expired }

class NativeTimerWrapper {
  final NativeTimerState state;

  final Duration total;

  final Duration elapsed;

  final DateTime stamp;

  NativeTimerWrapper(
    this.total,
    this.elapsed,
    this.stamp,
    this.state,
  );

  Duration getDuration() => total;

  Duration getElapsed() => total != Duration.zero
      ? DateTime.now().difference(stamp) + elapsed
      : Duration.zero;

  Duration getRemaining() => getDuration() - getElapsed();

  int getTimeStamp() => stamp.millisecondsSinceEpoch;

  NativeTimerWrapper increaseDuration(Duration increase) => NativeTimerWrapper(
        total + increase,
        isRunning() ? elapsed : Duration.zero,
        isRunning() ? stamp : DateTime.now(),
        NativeTimerState.running,
      );
  bool isRunning() => state == NativeTimerState.running;
  bool update() {
    if (state == NativeTimerState.running &&
        (getDuration() - getElapsed()).inMilliseconds <= 0) {
      state == NativeTimerState.expired;
    }
    return state != NativeTimerState.running;
  }

  static NativeTimerWrapper emptyTimer() => NativeTimerWrapper(
        Duration.zero,
        Duration.zero,
        DateTime.now(),
        NativeTimerState.expired,
      );
}
