import 'package:flexify/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerProgressIndicator extends StatelessWidget {
  const TimerProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerState>(builder: (context, value, child) {
      final duration = value.nativeTimer.getDuration();
      return Visibility(
        visible: duration > Duration.zero,
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: duration,
          builder: (context, value, child) => LinearProgressIndicator(
            value: value,
          ),
        ),
      );
    });
  }
}
