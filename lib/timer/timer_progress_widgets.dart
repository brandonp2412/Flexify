import 'package:flexify/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerProgressIndicator extends StatelessWidget {
  const TimerProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerState>(
      builder: (context, timerState, child) {
        final duration = timerState.nativeTimer.getDuration();
        final elapsed = timerState.nativeTimer.getElapsed();
        final remaining = timerState.nativeTimer.getRemaining();

        return Visibility(
          visible: duration > Duration.zero,
          child: TweenAnimationBuilder(
            key: UniqueKey(),
            tween: Tween<double>(
              begin: 1,
              end: elapsed.inMilliseconds / duration.inMilliseconds,
            ),
            duration: remaining,
            builder: (context, value, child) => LinearProgressIndicator(
              value: value,
            ),
          ),
        );
      },
    );
  }
}

class TimerCircularProgressIndicator extends StatelessWidget {
  const TimerCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerState>(
      builder: (context, timerState, child) {
        final duration = timerState.nativeTimer.getDuration();
        final elapsed = timerState.nativeTimer.getElapsed();
        final remaining = timerState.nativeTimer.getRemaining();

        return duration > Duration.zero
            ? TweenAnimationBuilder(
                key: UniqueKey(),
                tween: Tween<double>(
                  begin: 1 - (elapsed.inMilliseconds / duration.inMilliseconds),
                  end: 0,
                ),
                duration: remaining,
                builder: (context, value, child) =>
                    _TimerCircularProgressIndicatorTile(
                  value: value,
                  timerState: timerState,
                ),
              )
            : _TimerCircularProgressIndicatorTile(
                value: 0,
                timerState: timerState,
              );
      },
    );
  }
}

class _TimerCircularProgressIndicatorTile extends StatelessWidget {
  final double _value;
  final TimerState _timerState;

  String _generateTitleText(Duration remaining) {
    final minutes = (remaining.inMinutes).toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  const _TimerCircularProgressIndicatorTile({
    required double value,
    required TimerState timerState,
  })  : _timerState = timerState,
        _value = value;

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
            value: _value,
            strokeWidth: 20,
            backgroundColor:
                Theme.of(context).colorScheme.onSurface.withOpacity(0.25),
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 32.0),
            Text(
              _generateTitleText(_timerState.nativeTimer.getRemaining()),
              style: TextStyle(
                fontSize: 50.0,
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () async {
                final settings = context.read<SettingsState>();
                await requestNotificationPermission();
                await _timerState.addOneMinute(
                  settings.alarmSound,
                  settings.vibrate,
                );
              },
              child: const Text('+1 min'),
            ),
          ],
        ),
      ],
    );
  }
}
