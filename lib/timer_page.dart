import 'package:flexify/app_state.dart';
import 'package:flexify/timer_progress_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  Widget build(BuildContext context) {
    final timerState = context.watch<TimerState>();
    return Scaffold(
        body: const Center(
          child: TimerCircularProgressIndicator(),
        ),
        floatingActionButton: Visibility(
          visible: timerState.nativeTimer.isRunning(),
          child: FloatingActionButton(
            onPressed: () async => await timerState.stopTimer(),
            child: const Icon(Icons.stop),
          ),
        ));
  }
}
