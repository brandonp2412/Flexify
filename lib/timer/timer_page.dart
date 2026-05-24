import 'package:flexify/animated_fab.dart';
import 'package:flexify/settings/settings_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_progress_widgets.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flexify/utils.dart';
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

class _TimerPageWidgetState extends State<_TimerPageWidget> {
  @override
  void initState() {
    super.initState();
    widget.timerState.addListener(_onTimerStateChanged);
  }

  @override
  void dispose() {
    widget.timerState.removeListener(_onTimerStateChanged);
    super.dispose();
  }

  void _onTimerStateChanged() {
    if (!widget.timerState.justExpired) return;
    widget.timerState.justExpired = false;
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
      body: const Padding(
        padding: EdgeInsets.only(bottom: 80),
        child: Center(
          child: TimerCircularProgressIndicator(),
        ),
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: widget.timerState.timer.isRunning()
            ? AnimatedFab(
                onPressed: () async => await widget.timerState.stopTimer(),
                icon: const Icon(Icons.stop),
                label: const Text("Stop"),
              )
            : const SizedBox(),
      ),
    );
  }
}
