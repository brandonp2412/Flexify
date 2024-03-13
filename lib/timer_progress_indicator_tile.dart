import 'package:flexify/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class TimerProgressIndicator extends StatefulWidget {
  const TimerProgressIndicator({super.key});

  @override
  State<TimerProgressIndicator> createState() => _TimerProgressIndicatorState();
}

class _TimerProgressIndicatorState extends State<TimerProgressIndicator> with SingleTickerProviderStateMixin {
  late Ticker ticker;
  int seconds = 0;

  @override
  void initState() {
    super.initState();
    ticker = createTicker((elapsed) {
      final currSeconds = context.read<TimerState>().nativeTimer.getElapsed().inSeconds;
      if (seconds != currSeconds) setState(() {
        seconds = currSeconds;
      });
    });
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerState>(builder: (context, value, child) {
      final duration = value.nativeTimer.getDuration();
      final elapsed = value.nativeTimer.getElapsed();
      if (!value.nativeTimer.isRunning()) ticker.stop();
      else if (!ticker.isActive) ticker.start();

      return Visibility(
        visible: duration > Duration.zero,
        child: LinearProgressIndicator(
          value: elapsed.inMilliseconds / duration.inMilliseconds,
        ),
      );
    });
  }
}
