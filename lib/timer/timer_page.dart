import 'dart:async';
import 'dart:io';

import 'package:flexify/animated_fab.dart';
import 'package:flexify/settings/settings_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_progress_widgets.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerPage extends StatefulWidget {
  final int? total;
  final int? progress;

  const TimerPage({super.key, this.total, this.progress});

  @override
  createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final timerState = context.watch<TimerState>();

    return NavigatorPopHandler(
      onPopWithResult: (result) {
        if (navKey.currentState!.canPop() == false) return;
        final ctrl = DefaultTabController.of(context);
        final settings = context.read<SettingsState>().value;
        final index = settings.tabs.split(',').indexOf('TimerPage');
        if (ctrl.index == index) navKey.currentState!.pop();
      },
      child: Navigator(
        key: navKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => _TimerPageWidget(
            timerState: timerState,
            total: widget.total,
            progress: widget.progress,
          ),
          settings: settings,
        ),
      ),
    );
  }
}

class _TimerPageWidget extends StatefulWidget {
  final TimerState timerState;
  final int? total;
  final int? progress;

  const _TimerPageWidget({
    required this.timerState,
    this.total,
    this.progress,
  });

  @override
  State<_TimerPageWidget> createState() => _TimerPageWidgetState();
}

class _TimerPageWidgetState extends State<_TimerPageWidget>
    with WidgetsBindingObserver {
  // Wall-clock start time; null when the stopwatch is paused/reset.
  DateTime? _stopwatchStartedAt;
  // Accumulated duration from previous running intervals.
  Duration _stopwatchAccumulated = Duration.zero;
  bool _stopwatchRunning = false;
  Timer? _stopwatchTicker;

  Duration get _stopwatchElapsed {
    if (!_stopwatchRunning || _stopwatchStartedAt == null) {
      return _stopwatchAccumulated;
    }
    return _stopwatchAccumulated +
        DateTime.now().difference(_stopwatchStartedAt!);
  }

  @override
  void initState() {
    super.initState();
    widget.timerState.addListener(_onTimerStateChanged);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    widget.timerState.removeListener(_onTimerStateChanged);
    WidgetsBinding.instance.removeObserver(this);
    _stopwatchTicker?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _stopwatchRunning) {
      _startStopwatchTicker();
    } else if (state == AppLifecycleState.paused) {
      _stopwatchTicker?.cancel();
    }
  }

  void _startStopwatchTicker() {
    _stopwatchTicker?.cancel();
    _stopwatchTicker = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  void _startStopwatch() {
    setState(() {
      _stopwatchStartedAt = DateTime.now();
      _stopwatchRunning = true;
    });
    _startStopwatchTicker();
  }

  void _pauseStopwatch() {
    setState(() {
      _stopwatchAccumulated = _stopwatchElapsed;
      _stopwatchStartedAt = null;
      _stopwatchRunning = false;
    });
    _stopwatchTicker?.cancel();
  }

  void _restartStopwatch() {
    setState(() {
      _stopwatchAccumulated = Duration.zero;
      _stopwatchStartedAt = _stopwatchRunning ? DateTime.now() : null;
    });
  }

  void _onTimerStateChanged() {
    if (widget.timerState.timer.getDuration() > Duration.zero &&
        _stopwatchTicker != null) {
      _stopwatchTicker?.cancel();
      _stopwatchTicker = null;
      setState(() {
        _stopwatchRunning = false;
        _stopwatchStartedAt = null;
        _stopwatchAccumulated = Duration.zero;
      });
    }
    if (!widget.timerState.justExpired) return;
    widget.timerState.justExpired = false;
    // Android's TimerService already shows a system notification with its
    // own Stop/Add 1 min actions when the timer expires, so an in-app toast
    // here would just duplicate it.
    if (!kIsWeb && Platform.isAndroid) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      toast(
        'Timer finished!',
        action: SnackBarAction(
          label: 'Stop',
          onPressed: widget.timerState.stopTimer,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.total != null && widget.progress != null) {
      widget.timerState.setTimer(widget.total!, widget.progress!);
    }

    final timer = widget.timerState.timer;
    final countdownActive = timer.getDuration() > Duration.zero;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: Center(
          child: countdownActive
              ? const TimerCircularProgressIndicator()
              : StopwatchProgressIndicator(
                  elapsed: _stopwatchElapsed,
                  timerState: widget.timerState,
                  onRestart: _restartStopwatch,
                ),
        ),
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: timer.isRunning()
            ? AnimatedFab(
                onPressed: () async => await widget.timerState.stopTimer(),
                icon: const Icon(Icons.stop),
                label: const Text("Stop"),
              )
            : countdownActive
                ? const SizedBox()
                : AnimatedFab(
                    onPressed:
                        _stopwatchRunning ? _pauseStopwatch : _startStopwatch,
                    icon: Icon(
                      _stopwatchRunning ? Icons.pause : Icons.play_arrow,
                    ),
                    label: Text(_stopwatchRunning ? "Pause" : "Start"),
                  ),
      ),
    );
  }
}
