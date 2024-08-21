import 'package:flutter/material.dart';

class CustomSetIndicator extends StatelessWidget {
  const CustomSetIndicator({
    super.key,
    required this.count,
    required this.firstRender,
    required this.max,
  });
  final int count;
  final int max;
  final bool firstRender;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (int i = 0; i < max; i++) {
      children.add(
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            height: 6,
            child: AnimatedFractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: count > i ? 1 : 0,
              duration: Duration(milliseconds: firstRender ? 0 : 250),
              curve: Curves.ease,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      );
      if (i < max - 1) {
        children.add(const SizedBox(width: 6));
      }
    }
    return Row(children: children);
  }
}
