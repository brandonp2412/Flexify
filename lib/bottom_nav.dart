import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
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
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeInOutCubic,
      ),
    );
    _previousIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(BottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _previousIndex = oldWidget.currentIndex;
      _slideController.reset();
      _slideController.forward();
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Stack(
          children: [
            // Background sliding indicator
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                double tabWidth = (MediaQuery.of(context).size.width - 40) /
                    widget.tabs.length;
                double startX = _previousIndex * tabWidth;
                double endX = widget.currentIndex * tabWidth;
                double currentX =
                    startX + (endX - startX) * _slideAnimation.value;

                return Positioned(
                  left: currentX + 4,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: tabWidth - 8,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            ),
            // Tab items
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.tabs.asMap().entries.map((entry) {
                int index = entry.key;
                String tab = entry.value;
                bool isSelected = index == widget.currentIndex;

                return Expanded(
                  child: GestureDetector(
                    key: Key(tab),
                    onTap: () => widget.onTap(index),
                    onLongPress: widget.onLongPress != null
                        ? () => widget.onLongPress!(context, tab)
                        : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surfaceContainerLow,
                        borderRadius:
                            BorderRadius.circular(isSelected ? 25 : 18),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedScale(
                            scale: isSelected ? 1.1 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: Icon(
                              _getIconForTab(tab),
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onSurface,
                              size: 24,
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: isSelected ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: isSelected ? 20 : 0,
                              child: isSelected
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        _getLabelForTab(tab),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            // Sliding direction indicator (optional visual enhancement)
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                if (_slideAnimation.isAnimating) {
                  bool isMovingRight = widget.currentIndex > _previousIndex;
                  return Positioned(
                    top: 35,
                    left: isMovingRight ? null : 20,
                    right: isMovingRight ? 20 : null,
                    child: AnimatedOpacity(
                      opacity: _slideAnimation.value,
                      duration: const Duration(milliseconds: 150),
                      child: Icon(
                        isMovingRight
                            ? Icons.keyboard_arrow_right
                            : Icons.keyboard_arrow_left,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.6),
                        size: 20,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
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
