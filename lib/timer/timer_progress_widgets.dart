import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerCircularProgressIndicator extends StatefulWidget {
  const TimerCircularProgressIndicator({super.key});
  @override
  State<TimerCircularProgressIndicator> createState() =>
      _TimerCircularProgressIndicatorState();
}

class _TimerCircularProgressIndicatorState
    extends State<TimerCircularProgressIndicator> {
  bool stopping = false;
  double lastValue = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerState>(
      builder: (context, timerState, child) {
        final duration = timerState.timer.getDuration();
        final elapsed = timerState.timer.getElapsed();
        final remaining = timerState.timer.getRemaining();

        if (duration > Duration.zero &&
            remaining > Duration.zero &&
            timerState.starting) {
          return TweenAnimationBuilder(
            key: UniqueKey(),
            tween: Tween<double>(
              begin: 0,
              end: 1 - (elapsed.inMilliseconds / duration.inMilliseconds),
            ),
            duration: const Duration(milliseconds: 300),
            onEnd: () {
              timerState.setStarting(false);
            },
            builder: (context, value, child) =>
                _TimerCircularProgressIndicatorTile(
              value: value,
              timerState: timerState,
            ),
          );
        }

        if (duration > Duration.zero && remaining > Duration.zero) {
          lastValue = 1 - (elapsed.inMilliseconds / duration.inMilliseconds);
          return TweenAnimationBuilder(
            key: UniqueKey(),
            tween: Tween<double>(
              begin: lastValue,
              end: 0,
            ),
            duration: remaining,
            builder: (context, value, child) =>
                _TimerCircularProgressIndicatorTile(
              value: value,
              timerState: timerState,
            ),
          );
        }

        if (!timerState.starting && !stopping) {
          stopping = true;
          return TweenAnimationBuilder(
            key: UniqueKey(),
            tween: Tween<double>(
              begin: lastValue,
              end: 0,
            ),
            duration: const Duration(milliseconds: 300),
            onEnd: () {
              setState(() {
                stopping = false;
              });
              timerState.setStarting(true);
            },
            builder: (context, value, child) =>
                _TimerCircularProgressIndicatorTile(
              value: value,
              timerState: timerState,
            ),
          );
        }

        return _TimerCircularProgressIndicatorTile(
          value: 0,
          timerState: timerState,
        );
      },
    );
  }
}

class TimerProgressIndicator extends StatefulWidget {
  const TimerProgressIndicator({super.key});

  @override
  State<TimerProgressIndicator> createState() => _TimerProgressIndicatorState();
}

class _TimerProgressIndicatorState extends State<TimerProgressIndicator> {
  Duration? lastDuration;
  DateTime? lastTimestamp;
  GlobalKey? animationKey;

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerState>(
      builder: (context, timerState, child) {
        final duration = timerState.timer.getDuration();
        final elapsed = timerState.timer.getElapsed();
        final remaining = timerState.timer.getRemaining();

        if (duration == Duration.zero || remaining == Duration.zero) {
          lastDuration = null;
          lastTimestamp = null;
          animationKey = null;
          return const SizedBox.shrink();
        }

        final currentProgress =
            elapsed.inMilliseconds / duration.inMilliseconds;

        final isNewTimer = lastDuration != duration ||
            (lastTimestamp != null &&
                timerState.timer.stamp
                        .difference(lastTimestamp!)
                        .inSeconds
                        .abs() >
                    1);

        if (isNewTimer) {
          lastDuration = duration;
          lastTimestamp = timerState.timer.stamp;
          animationKey = GlobalKey();
        }

        return Visibility(
          visible: true,
          child: TweenAnimationBuilder<double>(
            key: animationKey,
            tween: Tween<double>(
              begin: 1.0 - currentProgress,
              end: 0.0,
            ),
            duration: remaining,
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
              );
            },
          ),
        );
      },
    );
  }
}

class _TimerCircularProgressIndicatorTile extends StatelessWidget {
  final double value;
  final TimerState timerState;

  const _TimerCircularProgressIndicatorTile({
    required this.value,
    required this.timerState,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        SizedBox(
          height: 300,
          width: 300,
          child: CircularProgressIndicator(
            strokeCap: StrokeCap.round,
            value: value,
            strokeWidth: 20,
            backgroundColor:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.25),
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20.0),
            Text(
              generateTitleText(timerState.timer.getRemaining()),
              style: TextStyle(
                fontSize: 50.0,
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () async {
                final settings = context.read<SettingsState>().value;
                await requestNotificationPermission();
                await timerState.addOneMinute(
                  settings.alarmSound,
                  settings.vibrate,
                );
              },
              child: const Text('+1 minute'),
            ),
          ],
        ),
      ],
    );
  }

  String generateTitleText(Duration remaining) {
    final minutes = (remaining.inMinutes).toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
