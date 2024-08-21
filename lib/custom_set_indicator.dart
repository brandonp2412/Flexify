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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.ease,
            decoration: BoxDecoration(
              color: count > i
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
            height: 6,
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
