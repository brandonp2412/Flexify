import 'dart:math' as math;

import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/foundation.dart';
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
  // Start true so the idle state never triggers the spurious stopping animation
  // on the very first build (when no timer has run yet).
  bool _stopping = true;
  double _lastValue = 0;

  // Animation key — replaced only at true phase transitions detected in
  // didChangeDependencies, which runs before build in the same frame. This
  // ensures the new render object is laid out before the semantics pass,
  // avoiding the '!parentDataDirty' / '_needsLayout' assertions.
  Key _animationKey = UniqueKey();

  // Phase-transition tracking (updated in didChangeDependencies).
  bool _prevStarting = false;
  bool _prevActive = false;
  Duration? _prevDuration;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final timerState = Provider.of<TimerState>(context);
    final duration = timerState.timer.getDuration();
    final remaining = timerState.timer.getRemaining();
    final isActive = duration > Duration.zero && remaining > Duration.zero;

    var needNewKey = false;

    if (timerState.starting && !_prevStarting && isActive) {
      // Entering the brief start animation (idle/stopped → starting).
      needNewKey = true;
    } else if (!timerState.starting && _prevStarting && isActive) {
      // Start animation finished; entering the running phase.
      needNewKey = true;
    } else if (isActive && !_prevActive) {
      // Timer became active without a start animation (first use or no starting flag).
      needNewKey = true;
      _stopping = false;
    } else if (isActive && duration != _prevDuration) {
      // Duration changed while running (e.g. +1 minute).
      needNewKey = true;
    } else if (!isActive && _prevActive && !_stopping) {
      // Timer just expired; queue the stopping animation.
      needNewKey = true;
    }

    if (needNewKey) _animationKey = UniqueKey();

    _prevStarting = timerState.starting;
    _prevActive = isActive;
    _prevDuration = duration;
  }

  @override
  Widget build(BuildContext context) {
    final timerState = Provider.of<TimerState>(context);
    final duration = timerState.timer.getDuration();
    final elapsed = timerState.timer.getElapsed();
    final remaining = timerState.timer.getRemaining();

    // Phase 1 — brief entering animation (0 → current position in 300 ms).
    if (duration > Duration.zero &&
        remaining > Duration.zero &&
        timerState.starting) {
      return TweenAnimationBuilder(
        key: _animationKey,
        tween: Tween<double>(
          begin: 0,
          end: 1 - (elapsed.inMilliseconds / duration.inMilliseconds),
        ),
        duration: const Duration(milliseconds: 300),
        onEnd: () {
          timerState.setStarting(false);
        },
        builder: (context, value, child) => _TimerCircularProgressIndicatorTile(
          value: value,
          timerState: timerState,
        ),
      );
    }

    // Phase 2 — timer running (animate from current position to 0).
    if (duration > Duration.zero && remaining > Duration.zero) {
      _lastValue = 1 - (elapsed.inMilliseconds / duration.inMilliseconds);
      // Allow the stopping animation to play once this phase has been entered.
      _stopping = false;
      return TweenAnimationBuilder(
        key: _animationKey,
        tween: Tween<double>(begin: _lastValue, end: 0),
        duration: remaining,
        builder: (context, value, child) => _TimerCircularProgressIndicatorTile(
          value: value,
          timerState: timerState,
        ),
      );
    }

    // Phase 3 — stopping animation (current position → 0 in 300 ms).
    // Only fires after the timer was actually running (_stopping == false).
    if (!timerState.starting && !_stopping) {
      _stopping = true;
      return TweenAnimationBuilder(
        key: _animationKey,
        tween: Tween<double>(begin: _lastValue, end: 0),
        duration: const Duration(milliseconds: 300),
        onEnd: () {
          setState(() {
            _stopping = false;
          });
          timerState.setStarting(true);
        },
        builder: (context, value, child) => _TimerCircularProgressIndicatorTile(
          value: value,
          timerState: timerState,
        ),
      );
    }

    return _TimerCircularProgressIndicatorTile(
      value: 0,
      timerState: timerState,
    );
  }
}

class TimerProgressIndicator extends StatefulWidget {
  const TimerProgressIndicator({super.key});

  @override
  State<TimerProgressIndicator> createState() => _TimerProgressIndicatorState();
}

class _TimerProgressIndicatorState extends State<TimerProgressIndicator>
    with WidgetsBindingObserver {
  Duration? lastDuration;
  DateTime? lastTimestamp;
  GlobalKey? animationKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        animationKey = GlobalKey();
      });
    }
  }

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
    const double circleSize = 280;
    const double strokeWidth = 10;
    const double dotSize = 16;
    // Dot sits at the centreline of the stroke track.
    const double dotRadius = circleSize / 2;

    final angle = (-math.pi / 2) - (2 * math.pi * (1 - value));
    final dotX = dotRadius * math.cos(angle);
    final dotY = dotRadius * math.sin(angle);

    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: circleSize,
          height: circleSize,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: <Widget>[
              SizedBox.expand(
                child: CircularProgressIndicator(
                  strokeCap: StrokeCap.round,
                  value: value,
                  strokeWidth: strokeWidth,
                  backgroundColor: onSurface.withValues(alpha: 0.08),
                  valueColor: AlwaysStoppedAnimation<Color>(primary),
                ),
              ),
              if (value > 0)
                Transform.translate(
                  offset: Offset(dotX, dotY),
                  child: Container(
                    width: dotSize,
                    height: dotSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary,
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.55),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              Text(
                generateTitleText(timerState.timer.getRemaining()),
                style: TextStyle(
                  fontSize: 60,
                  color: onSurface,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: () async {
            final settings = context.read<SettingsState>().value;
            if (defaultTargetPlatform != TargetPlatform.linux)
              await requestNotificationPermission();
            await timerState.addOneMinute(
              settings.alarmSound,
              settings.vibrate,
              settings.enableSound,
            );
          },
          child: const Text('+1 minute'),
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
