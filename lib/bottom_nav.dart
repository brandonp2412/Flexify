import 'package:flutter/material.dart';

/// Total height this floating dock occupies, including outer padding.
const double bottomNavHeight = 80;

/// Variant 1: "Pill dock" — a compact centered pill where the selected tab
/// expands horizontally to reveal its label while unselected tabs collapse
/// to icon-only circles.
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Center(
        child: Container(
          height: 60,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.surfaceContainerHigh,
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
            children: tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              final isSelected = index == currentIndex;
              final label = labelForTab(tab);

              return Semantics(
                label: label,
                button: true,
                selected: isSelected,
                child: GestureDetector(
                  key: Key(tab),
                  onTap: () => onTap(index),
                  onLongPress: onLongPress != null
                      ? () => onLongPress!(context, tab)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    height: 48,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSelected ? 16 : 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? color.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          iconForTab(tab),
                          color: isSelected ? color.onPrimary : color.onSurface,
                          size: 24,
                          semanticLabel: label,
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutCubic,
                          child: isSelected
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    label,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(color: color.onPrimary),
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

  static IconData iconForTab(String tab) {
    switch (tab) {
      case 'HistoryPage':
        return Icons.history_rounded;
      case 'PlansPage':
        return Icons.calendar_today_outlined;
      case 'GraphsPage':
        return Icons.insights_rounded;
      case 'TimerPage':
        return Icons.timer_rounded;
      case 'SettingsPage':
        return Icons.settings_rounded;
      default:
        return Icons.error_rounded;
    }
  }

  static String labelForTab(String tab) {
    switch (tab) {
      case 'HistoryPage':
        return 'History';
      case 'PlansPage':
        return 'Plans';
      case 'GraphsPage':
        return 'Graphs';
      case 'TimerPage':
        return 'Timer';
      case 'SettingsPage':
        return 'Settings';
      default:
        return 'Error';
    }
  }
}
