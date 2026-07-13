import 'package:flutter/material.dart';

/// Total height of the bubble bar, including the space the raised bubble
/// pops into above the bar body.
const double bottomNavHeight = 104;

/// Variant 4: "Bubble" — the selected icon lifts out of the bar into a
/// raised, shadowed circle with a springy pop animation.
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

    return SizedBox(
      height: bottomNavHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 72,
            decoration: BoxDecoration(
              color: color.surfaceContainerHigh,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
          ),
          Positioned.fill(
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
                    child: GestureDetector(
                      key: Key(tab),
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTap(index),
                      onLongPress: onLongPress != null
                          ? () => onLongPress!(context, tab)
                          : null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.elasticOut,
                            width: isSelected ? 52 : 40,
                            height: isSelected ? 52 : 40,
                            margin: EdgeInsets.only(
                              bottom: isSelected ? 40 : 20,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? color.primary
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: color.primary
                                            .withValues(alpha: 0.4),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              _getIconForTab(tab),
                              color: isSelected
                                  ? color.onPrimary
                                  : color.onSurfaceVariant,
                              size: 24,
                              semanticLabel: label,
                            ),
                          ),
                          if (isSelected)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: Text(
                                label,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: color.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            )
                          else
                            const SizedBox(height: 14),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
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
