import 'package:flexify/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Total height this floating dock occupies, including outer padding.
const double bottomNavHeight = 80;

/// Bottom inset that keeps scrollable content clear of the mobile FAB.
const double floatingActionButtonListPadding = bottomNavHeight + 80;

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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: tabs.asMap().entries.map((entry) {
                final index = entry.key;
                final tab = entry.value;
                final isSelected = index == currentIndex;
                final label = labelForTab(context, tab);

                return Semantics(
                  label: label,
                  button: true,
                  selected: isSelected,
                  child: Tooltip(
                    message: label,
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
                          color: isSelected
                              ? color.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              iconForTab(tab),
                              color: isSelected
                                  ? color.onPrimary
                                  : color.onSurface,
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
                  ),
                );
              }).toList(),
            ),
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

  static String labelForTab(BuildContext context, String tab) {
    final l10n = context.l10n;
    switch (tab) {
      case 'HistoryPage':
        return l10n.navHistory;
      case 'PlansPage':
        return l10n.navPlans;
      case 'GraphsPage':
        return l10n.navGraphs;
      case 'TimerPage':
        return l10n.navTimer;
      case 'SettingsPage':
        return l10n.navSettings;
      default:
        return l10n.errorLabel;
    }
  }
}

class DesktopNav extends StatelessWidget {
  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final void Function(BuildContext, String)? onSecondaryTap;

  const DesktopNav({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 224,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        border: Border(
          right: BorderSide(
            color: colors.outlineVariant.withValues(alpha: .35),
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Icon(Icons.fitness_center_rounded, color: colors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        context.l10n.appTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ...tabs.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: _DesktopNavItem(
                    key: Key(entry.value),
                    icon: BottomNav.iconForTab(entry.value),
                    label: BottomNav.labelForTab(context, entry.value),
                    selected: entry.key == currentIndex,
                    onTap: () => onTap(entry.key),
                    onSecondaryTap: onSecondaryTap == null
                        ? null
                        : () => onSecondaryTap!(context, entry.value),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DesktopNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onSecondaryTap;

  const _DesktopNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final foreground = selected
        ? colors.onSecondaryContainer
        : colors.onSurfaceVariant;

    final child = Material(
      color: selected ? colors.secondaryContainer : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              Icon(icon, size: 22, color: foreground),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: foreground,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: onSecondaryTap == null
          ? child
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onSecondaryTap: onSecondaryTap,
              child: child,
            ),
    );
  }
}
