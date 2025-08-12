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
                gradient: isSelected
                    ? RadialGradient(
                        center: Alignment.center,
                        radius: 0.8,
                        colors: [
                          colorScheme.primary,
                          colorScheme.primary.withOpacity(0.7),
                          colorScheme.primary.withOpacity(0.9),
                        ],
                        stops: const [0.0, 0.7, 1.0],
                      )
                    : RadialGradient(
                        center: Alignment.center,
                        radius: 0.8,
                        colors: [
                          colorScheme.surface,
                          colorScheme.surfaceContainer,
                          colorScheme.surfaceContainerHighest,
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? colorScheme.primary.withOpacity(0.7)
                      : colorScheme.outline.withOpacity(0.3),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  if (isSelected) ...[
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ] else ...[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 1,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ],
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
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
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
