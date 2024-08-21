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
        TweenAnimationBuilder<Color?>(
          tween: ColorTween(
            begin: widget.daySwitches[i]
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainer,
            end: widget.daySwitches[i]
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainer,
          ),
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
          builder: (BuildContext context, Color? color, Widget? child) {
            return Expanded(
              child: TextButton(
                style: ButtonStyle(
                  shape: const WidgetStatePropertyAll(
                    CircleBorder(),
                  ),
                  minimumSize: const WidgetStatePropertyAll(Size(48, 48)),
                  padding: const WidgetStatePropertyAll(EdgeInsets.zero),
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
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FittedBox(
                    fit: BoxFit.contain,
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
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}
