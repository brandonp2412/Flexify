import 'package:flexify/constants.dart';
import 'package:flutter/material.dart';

class DaySelector extends StatefulWidget {
  final List<bool> daySwitches;
  const DaySelector({super.key, required this.daySwitches});

  @override
  State<DaySelector> createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    for (int i = 0; i < weekdays.length; i++) {
      children.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TweenAnimationBuilder<Color?>(
            tween: ColorTween(
              begin: widget.daySwitches[i]
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainer,
              end: widget.daySwitches[i]
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainer,
            ),
            duration: const Duration(milliseconds: 150),
            curve: Curves.ease,
            builder: (BuildContext context, Color? color, Widget? child) {
              return TextButton(
                style: ButtonStyle(
                  shape: const WidgetStatePropertyAll(
                    CircleBorder(),
                  ),
                  minimumSize: const WidgetStatePropertyAll(Size(54, 54)),
                  shadowColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.shadow,
                  ),
                  elevation: const WidgetStatePropertyAll(4.0),
                  backgroundColor: WidgetStatePropertyAll(color),
                ),
                onPressed: () {
                  setState(() {
                    widget.daySwitches[i]
                        ? widget.daySwitches[i] = false
                        : widget.daySwitches[i] = true;
                  });
                },
                child: Text(
                  weekdays[i].length < 3
                      ? weekdays[i]
                      : weekdays[i].substring(0, 3),
                  style: TextStyle(
                    color: widget.daySwitches[i]
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.inverseSurface,
                    fontSize: 14.0,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return Wrap(children: children);
  }
}
