import 'package:flutter/material.dart';

/// Total height of the flat Material 3 style bar. It sits flush with the
/// bottom edge, so no extra floating padding is included.
const double bottomNavHeight = 80;

/// Variant 2: "Material 3 classic" — a full-width, flush bar with the
/// standard M3 pill indicator behind the icon and always-visible labels.
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
      decoration: BoxDecoration(
        color: color.surfaceContainer,
        border: Border(
          top: BorderSide(color: color.outlineVariant, width: 0.5),
        ),
      ),
      child: Row(
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
              child: InkWell(
                key: Key(tab),
                onTap: () => onTap(index),
                onLongPress: onLongPress != null
                    ? () => onLongPress!(context, tab)
                    : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      width: isSelected ? 64 : 48,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.secondaryContainer
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        _getIconForTab(tab),
                        color: isSelected
                            ? color.onSecondaryContainer
                            : color.onSurfaceVariant,
                        size: 24,
                        semanticLabel: label,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: isSelected
                                ? color.onSurface
                                : color.onSurfaceVariant,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
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
