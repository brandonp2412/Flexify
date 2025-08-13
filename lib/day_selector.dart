import 'package:flexify/constants.dart';
import 'package:flutter/material.dart';

class DaySelector extends StatefulWidget {
  final List<bool> daySwitches;
  const DaySelector({super.key, required this.daySwitches});

  @override
  State<DaySelector> createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  void _toggleDay(int index) {
    setState(() {
      widget.daySwitches[index] = !widget.daySwitches[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: List.generate(weekdays.length, (index) {
        final isSelected = widget.daySwitches[index];
        final dayLabel = weekdays[index].length < 3
            ? weekdays[index]
            : weekdays[index].substring(0, 3);

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? colorScheme.primary.withAlpha(
                          (colorScheme.primary.a * 0.7 * 255.0).round() & 0xff,
                        )
                      : colorScheme.outline.withAlpha(
                          (colorScheme.outline.a * 0.3 * 255.0).round() & 0xff,
                        ),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _toggleDay(index),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                      child: Text(dayLabel),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
