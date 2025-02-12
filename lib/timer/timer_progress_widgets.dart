import 'dart:math';

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
    extends State<TimerCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  bool starting = true;
  bool stopping = false;
  double lastValue = 0;
  late AnimationController _textShakeController;

  @override
  void initState() {
    super.initState();
    _textShakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _textShakeController.dispose();
    super.dispose();
  }

  void triggerShake() {
    if (lastValue >= 0.9) _textShakeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerState>(
      builder: (context, timerState, child) {
        final duration = timerState.nativeTimer.getDuration();
        final elapsed = timerState.nativeTimer.getElapsed();
        final remaining = timerState.nativeTimer.getRemaining();

        // Opening animation
        if (duration > Duration.zero &&
            remaining > Duration.zero &&
            starting &&
            elapsed == Duration.zero) {
          return TweenAnimationBuilder(
            key: UniqueKey(),
            tween: Tween<double>(
              begin: 0,
              end: 1,
            ),
            duration: const Duration(milliseconds: 300),
            onEnd: () {
              setState(() {
                starting = false;
              });
            },
            builder: (context, value, child) =>
                _TimerCircularProgressIndicatorTile(
              value: value,
              timerState: timerState,
              textShakeController: _textShakeController,
              onAddMinute: value >= 0.9 ? triggerShake : null,
            ),
          );
        }

        // Normal countdown
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
              textShakeController: _textShakeController,
              onAddMinute: value >= 0.9 ? triggerShake : null,
            ),
          );
        }

        // Closing animation
        if (!starting && !stopping) {
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
                starting = true;
              });
            },
            builder: (context, value, child) =>
                _TimerCircularProgressIndicatorTile(
              value: value,
              timerState: timerState,
              textShakeController: _textShakeController,
              onAddMinute: value >= 0.9 ? triggerShake : null,
            ),
          );
        }

        if (!starting) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                starting = true;
              });
            }
          });
        }

        return _TimerCircularProgressIndicatorTile(
          value: 0,
          timerState: timerState,
          textShakeController: _textShakeController,
          onAddMinute: null,
        );
      },
    );
  }
}

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
          visible: duration > Duration.zero && remaining > Duration.zero,
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

class _TimerCircularProgressIndicatorTile extends StatelessWidget {
  final double value;
  final TimerState timerState;
  final AnimationController textShakeController;
  final VoidCallback? onAddMinute;

  const _TimerCircularProgressIndicatorTile({
    required this.value,
    required this.timerState,
    required this.textShakeController,
    required this.onAddMinute,
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
            const SizedBox(height: 32.0),
            AnimatedBuilder(
              animation: textShakeController,
              builder: (context, child) {
                final sineValue = sin(textShakeController.value * 3 * pi) * 5;
                return Transform.translate(
                  offset: Offset(0, sineValue),
                  child: child,
                );
              },
              child: Text(
                generateTitleText(timerState.nativeTimer.getRemaining()),
                style: TextStyle(
                  fontSize: 50.0,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.bold,
                ),
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
                if (onAddMinute != null) onAddMinute!();
              },
              child: const Text('+1 min'),
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
