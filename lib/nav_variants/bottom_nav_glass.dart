import 'dart:ui';

import 'package:flutter/material.dart';

/// Total height of the floating glass dock, including outer padding.
const double bottomNavHeight = 100;

/// Variant 3: "Glass dock" — a frosted-glass floating bar (BackdropFilter
/// blur) with icon-only tabs; the selected icon sits in a gradient circle.
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
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: color.surface.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: color.onSurface.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutBack,
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      color.primary,
                                      color.tertiary,
                                    ],
                                  )
                                : null,
                            shape: BoxShape.circle,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color:
                                          color.primary.withValues(alpha: 0.4),
                                      blurRadius: 12,
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
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
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
