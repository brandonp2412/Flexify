enum NativeTimerState { running, paused, expired }

class NativeTimerWrapper {
  final NativeTimerState state;

  final Duration totalTimerDuration;

  final Duration elapsedTimerDuration;

  final DateTime timeStamp;

  NativeTimerWrapper(
    this.totalTimerDuration,
    this.elapsedTimerDuration,
    this.timeStamp,
    this.state,
  );

  Duration getDuration() => totalTimerDuration;

  Duration getElapsed() => totalTimerDuration != Duration.zero
      ? DateTime.now().difference(timeStamp) + elapsedTimerDuration
      : Duration.zero;

  Duration getRemaining() => getDuration() - getElapsed();

  int getTimeStamp() => timeStamp.millisecondsSinceEpoch;

  NativeTimerWrapper increaseDuration(Duration increase) => NativeTimerWrapper(
        totalTimerDuration + increase,
        isRunning() ? elapsedTimerDuration : Duration.zero,
        isRunning() ? timeStamp : DateTime.now(),
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
