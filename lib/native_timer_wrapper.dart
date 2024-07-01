enum NativeTimerState { running, paused, expired }

class NativeTimerWrapper {
  NativeTimerWrapper(
    this.totalTimerDuration,
    this.elapsedTimerDuration,
    this.timeStamp,
    this.state,
  );

  static NativeTimerWrapper emptyTimer() => NativeTimerWrapper(
        Duration.zero,
        Duration.zero,
        DateTime.now(),
        NativeTimerState.expired,
      );

  Duration getElapsed() => totalTimerDuration != Duration.zero
      ? DateTime.now().difference(timeStamp) + elapsedTimerDuration
      : Duration.zero;

  Duration getDuration() => totalTimerDuration;

  Duration getRemaining() => getDuration() - getElapsed();

  int getTimeStamp() => timeStamp.millisecondsSinceEpoch;

  bool isRunning() => state == NativeTimerState.running;

  NativeTimerWrapper increaseDuration(Duration increase) => NativeTimerWrapper(
        totalTimerDuration + increase,
        isRunning() ? elapsedTimerDuration : Duration.zero,
        isRunning() ? timeStamp : DateTime.now(),
        NativeTimerState.running,
      );

  bool update() {
    if (state == NativeTimerState.running &&
        (getDuration() - getElapsed()).inMilliseconds <= 0) {
      state == NativeTimerState.expired;
    }
    return state != NativeTimerState.running;
  }

  final NativeTimerState state;
  final Duration totalTimerDuration;
  final Duration elapsedTimerDuration;
  final DateTime timeStamp;
}
