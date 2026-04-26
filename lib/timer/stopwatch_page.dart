import 'dart:async';

import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage>
    with AutomaticKeepAliveClientMixin {
  final _stopwatch = Stopwatch();
  Timer? _ticker;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _start() {
    _stopwatch.start();
    _ticker = Timer.periodic(const Duration(milliseconds: 30), (_) {
      setState(() {});
    });
  }

  void _pause() {
    _stopwatch.stop();
    _ticker?.cancel();
    setState(() {});
  }

  void _reset() {
    _stopwatch.stop();
    _stopwatch.reset();
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
    final elapsed = _stopwatch.elapsed;
    final isRunning = _stopwatch.isRunning;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatElapsed(elapsed),
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
                  onPressed: isRunning ? _pause : _start,
                  child: Icon(isRunning ? Icons.pause : Icons.play_arrow),
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
