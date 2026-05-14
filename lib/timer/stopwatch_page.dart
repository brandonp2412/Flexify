import 'dart:async';

import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  // Wall-clock start time; null when paused/stopped.
  DateTime? _startedAt;
  // Accumulated duration from previous running intervals.
  Duration _accumulated = Duration.zero;
  bool _isRunning = false;
  Timer? _ticker;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isRunning) {
      _startTicker();
    } else if (state == AppLifecycleState.paused) {
      _ticker?.cancel();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.cancel();
    super.dispose();
  }

  Duration get _elapsed {
    if (!_isRunning || _startedAt == null) return _accumulated;
    return _accumulated + DateTime.now().difference(_startedAt!);
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 30), (_) {
      setState(() {});
    });
  }

  void _start() {
    _startedAt = DateTime.now();
    _isRunning = true;
    _startTicker();
  }

  void _pause() {
    _accumulated = _elapsed;
    _startedAt = null;
    _isRunning = false;
    _ticker?.cancel();
    setState(() {});
  }

  void _reset() {
    _accumulated = Duration.zero;
    _startedAt = null;
    _isRunning = false;
    _ticker?.cancel();
    setState(() {});
  }

  String _formatElapsed(Duration elapsed) {
    final hours = elapsed.inHours;
    final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    final centiseconds =
        (elapsed.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(
              2,
              '0',
            );
    if (hours > 0) return '$hours:$minutes:$seconds.$centiseconds';
    return '$minutes:$seconds.$centiseconds';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatElapsed(_elapsed),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontFeatures: [const FontFeature.tabularFigures()],
                fontSize: 56,
              ),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.large(
                  heroTag: 'stopwatch_start_stop',
                  onPressed: _isRunning ? _pause : _start,
                  child: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                ),
                const SizedBox(width: 24),
                FloatingActionButton(
                  heroTag: 'stopwatch_reset',
                  onPressed: _reset,
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  foregroundColor:
                      Theme.of(context).colorScheme.onSecondaryContainer,
                  child: const Icon(Icons.refresh),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
