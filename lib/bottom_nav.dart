import 'package:flutter/material.dart';
import 'package:frisbee_flutter_foundation/frisbee_flutter_foundation.dart';

/// Total fixed height occupied by the navigation pill and its visual padding.
/// The device bottom safe-area inset is added separately by [PillBottomNav].
const double bottomNavHeight = PillBottomNav.pillHeight + 32;

class BottomNav extends StatelessWidget {
  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final void Function(BuildContext, String)? onLongPress;

  const BottomNav({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return PillBottomNav<String>(
      destinations: tabs
          .map(
            (tab) => PillNavDestination(
              value: tab,
              label: labelForTab(tab),
              icon: iconForTab(tab),
            ),
          )
          .toList(),
      currentIndex: currentIndex,
      onTap: onTap,
      onLongPress: onLongPress,
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
