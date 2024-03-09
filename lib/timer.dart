class Timer {
  Timer(Duration totalTimerDuration, Duration elapsedTimerDuration,
      DateTime timeStamp)
      : _totalTimerDuration = totalTimerDuration,
        _elapsedTimerDuration = elapsedTimerDuration,
        _timeStamp = timeStamp;

  static Timer emptyTimer() =>
      Timer(Duration.zero, Duration.zero, DateTime.now());

  Duration getElapsed() => _totalTimerDuration != Duration.zero
      ? DateTime.now().difference(_timeStamp) + _elapsedTimerDuration
      : Duration.zero;

  Duration getDuration() => _totalTimerDuration;

  bool isRunning() => (getDuration() - getElapsed()).inMilliseconds > 0;

  Timer increaseTimerDuration(Duration increase) {
    if (!isRunning()) return this;
    return Timer(
      _totalTimerDuration + increase,
      _elapsedTimerDuration,
      _timeStamp,
    );
  }

  final Duration _totalTimerDuration;
  final Duration _elapsedTimerDuration;
  final DateTime _timeStamp;
}
