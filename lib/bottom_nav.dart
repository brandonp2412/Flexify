import 'package:flutter/material.dart';

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
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: tabs.asMap().entries.map((entry) {
            int index = entry.key;
            String tab = entry.value;
            bool isSelected = index == currentIndex;

            return GestureDetector(
              onTap: () => onTap(index),
              onLongPress:
                  onLongPress != null ? () => onLongPress!(context, tab) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: isSelected ? 80 : 60,
                height: isSelected ? 80 : 60,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      isSelected ? 25 : 18,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getIconForTab(tab),
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                      size: isSelected ? 26 : 22,
                    ),
                    if (isSelected) ...[
                      const SizedBox(height: 4),
                      Text(
                        _getLabelForTab(tab),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                        maxLines: 1,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  IconData _getIconForTab(String tab) {
    switch (tab) {
      case 'HistoryPage':
        return Icons.history_rounded;
      case 'PlansPage':
        return Icons.calendar_today_rounded;
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
      case 'SettingsPage':
        return 'Settings';
      default:
        return 'Error';
    }
  }
}
