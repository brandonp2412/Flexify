import 'package:flutter/material.dart';

class CustomSetIndicator extends StatelessWidget {
  const CustomSetIndicator({
    super.key,
    required this.index,
    required this.count,
    required this.firstRender,
  });
  final int index;
  final int count;
  final bool firstRender;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        height: 6,
        child: AnimatedFractionallySizedBox(
          widthFactor: count > index ? 1 : 0,
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
    );
  }
}
