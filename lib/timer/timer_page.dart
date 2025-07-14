import 'package:flexify/settings/settings_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_progress_widgets.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
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
          builder: (context) => _TimerPageWidget(timerState: timerState),
          settings: settings,
        ),
      ),
    );
  }
}

class _TimerPageWidget extends StatelessWidget {
  const _TimerPageWidget({
    required this.timerState,
  });

  final TimerState timerState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: const Center(
        child: TimerCircularProgressIndicator(),
      ),
      floatingActionButton: Visibility(
        visible: timerState.timer.isRunning(),
        child: FloatingActionButton.extended(
          onPressed: () async => await timerState.stopTimer(),
          icon: const Icon(Icons.stop),
          label: const Text("Stop"),
        ),
      ),
    );
  }
}
