import 'package:flutter/material.dart';

/// Description of a destination rendered by [PillBottomNav].
class PillNavDestination<T> {
  const PillNavDestination({
    required this.value,
    required this.label,
    required this.icon,
  });

  final T value;
  final String label;
  final IconData icon;
}

/// Compact floating Material 3 navigation dock shared across the apps.
class PillBottomNav<T> extends StatelessWidget {
  const PillBottomNav({
    super.key,
    required this.destinations,
    required this.currentIndex,
    required this.onTap,
    this.onLongPress,
    this.outerPadding = 16,
  });

  /// Height of the pill itself, excluding safe-area and outer padding.
  static const double pillHeight = 60;

  final List<PillNavDestination<T>> destinations;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final void Function(BuildContext context, T value)? onLongPress;
  final double outerPadding;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final systemBottomInset = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        outerPadding,
        outerPadding,
        outerPadding,
        systemBottomInset + outerPadding,
      ),
      child: Center(
        heightFactor: 1,
        child: Container(
          height: pillHeight,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: destinations.asMap().entries.map((entry) {
              final index = entry.key;
              final destination = entry.value;
              final selected = index == currentIndex;

              return Semantics(
                label: destination.label,
                button: true,
                selected: selected,
                excludeSemantics: true,
                child: GestureDetector(
                  key: ValueKey(destination.value),
                  onTap: () => onTap(index),
                  onLongPress: onLongPress == null
                      ? null
                      : () => onLongPress!(context, destination.value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    height: 48,
                    padding: EdgeInsets.symmetric(
                      horizontal: selected ? 16 : 12,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? colors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          destination.icon,
                          color: selected ? colors.onPrimary : colors.onSurface,
                          size: 24,
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutCubic,
                          child: selected
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    destination.label,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(color: colors.onPrimary),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
