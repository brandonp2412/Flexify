import 'package:flutter/material.dart';

/// Total height of the minimal flat bar.
const double bottomNavHeight = 72;

/// Variant 5: "Minimal line" — a flat, chrome-free bar where the only
/// selection cue is an animated dot-and-line indicator that slides between
/// tabs, with icons tinting toward the primary color.
class BottomNav extends StatelessWidget {
  final List<String> tabs;
  final int currentIndex;
  final Function(int) onTap;
  final Function(BuildContext, String)? onLongPress;

  const BottomNav({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      height: bottomNavHeight,
      color: color.surface,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / tabs.length;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                top: 0,
                left: currentIndex * tabWidth + tabWidth / 2 - 16,
                child: Container(
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(
                    color: color.primary,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(3),
                    ),
                  ),
                ),
              ),
              Row(
                children: tabs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final tab = entry.value;
                  final isSelected = index == currentIndex;
                  final label = _getLabelForTab(tab);

                  return Expanded(
                    child: Semantics(
                      label: label,
                      button: true,
                      selected: isSelected,
                      child: GestureDetector(
                        key: Key(tab),
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onTap(index),
                        onLongPress: onLongPress != null
                            ? () => onLongPress!(context, tab)
                            : null,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedSlide(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                              offset: isSelected
                                  ? const Offset(0, -0.05)
                                  : Offset.zero,
                              child: Icon(
                                _getIconForTab(tab),
                                color: isSelected
                                    ? color.primary
                                    : color.onSurfaceVariant,
                                size: 24,
                                semanticLabel: label,
                              ),
                            ),
                            const SizedBox(height: 4),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 250),
                              style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: isSelected
                                            ? color.primary
                                            : color.onSurfaceVariant,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                      ) ??
                                  const TextStyle(),
                              child: Text(label, maxLines: 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _getIconForTab(String tab) {
    switch (tab) {
      case 'HistoryPage':
        return Icons.history_rounded;
      case 'PlansPage':
        return Icons.calendar_today_outlined;
      case 'GraphsPage':
        return Icons.insights_rounded;
      case 'TimerPage':
        return Icons.timer_rounded;
      case 'StopwatchPage':
        return Icons.timer_outlined;
      case 'SettingsPage':
        return Icons.settings_rounded;
      default:
        return Icons.error_rounded;
    }
  }

  String _getLabelForTab(String tab) {
    switch (tab) {
      case 'HistoryPage':
        return 'History';
      case 'PlansPage':
        return 'Plans';
      case 'GraphsPage':
        return 'Graphs';
      case 'TimerPage':
        return 'Timer';
      case 'StopwatchPage':
        return 'Watch';
      case 'SettingsPage':
        return 'Settings';
      default:
        return 'Error';
    }
  }
}
