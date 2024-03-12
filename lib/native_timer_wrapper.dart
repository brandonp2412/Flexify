

enum NativeTimerState { running, paused, expired }

class NativeTimerWrapper {
  NativeTimerWrapper(
    Duration totalTimerDuration,
    Duration elapsedTimerDuration,
    DateTime timeStamp,
    NativeTimerState state,
  )   : _totalTimerDuration = totalTimerDuration,
        _elapsedTimerDuration = elapsedTimerDuration,
        _timeStamp = timeStamp,
        _state = state;

  static NativeTimerWrapper emptyTimer() => NativeTimerWrapper(
        Duration.zero,
        Duration.zero,
        DateTime.now(),
        NativeTimerState.expired,
      );

  Duration getElapsed() => _totalTimerDuration != Duration.zero
      ? DateTime.now().difference(_timeStamp) + _elapsedTimerDuration
      : Duration.zero;

  Duration getDuration() => _totalTimerDuration;

  Duration getRemaining() => getDuration() - getElapsed();

  int getTimeStamp() => _timeStamp.millisecondsSinceEpoch;

  bool isRunning() => _state == NativeTimerState.running;

  NativeTimerWrapper increaseDuration(Duration increase) => NativeTimerWrapper(
        _totalTimerDuration + increase,
        isRunning() ? _elapsedTimerDuration : Duration.zero,
        isRunning() ? _timeStamp : DateTime.now(),
        NativeTimerState.running,
      );

  bool update() {
    if (_state == NativeTimerState.running &&
        (getDuration() - getElapsed()).inMilliseconds <= 0) {
      _state == NativeTimerState.expired;
    }
    return _state != NativeTimerState.running;
  }

  final NativeTimerState _state;
  final Duration _totalTimerDuration;
  final Duration _elapsedTimerDuration;
  final DateTime _timeStamp;
}
