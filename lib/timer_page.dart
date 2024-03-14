import 'package:flexify/app_state.dart';
import 'package:flexify/timer_progress_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {

  @override
  Widget build(BuildContext context) {
    final timerState = context.watch<TimerState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
      ),
      body: const Center(
        child: TimerCircularProgressIndicator(),
      ),
      floatingActionButton: Visibility(
        visible: timerState.nativeTimer.isRunning(),
        child: FloatingActionButton(
        onPressed: () => timerState.stopTimer(),
        child: const Icon(Icons.stop),
      ),)
    );
  }


}
