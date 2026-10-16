import 'package:flexify/bottom_nav.dart';
import 'package:flexify/responsive.dart';
import 'package:flutter/material.dart';

class AppFab extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget label;
  final ScrollController? scroll;
  final Widget? icon;
  final double? bottomPadding;

  const AppFab({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
    this.scroll,
    this.bottomPadding,
  });

  @override
  State<AppFab> createState() => _AppFabState();
}

class _AppFabState extends State<AppFab> {
  bool _extended = true;

  @override
  void initState() {
    super.initState();
    widget.scroll?.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(AppFab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scroll == widget.scroll) return;
    oldWidget.scroll?.removeListener(_onScroll);
    widget.scroll?.addListener(_onScroll);
    _extended = true;
  }

  @override
  void dispose() {
    widget.scroll?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final scroll = widget.scroll;
    if (scroll == null || !scroll.hasClients) return;
    final extended = scroll.position.pixels <= scroll.position.minScrollExtent;
    if (_extended != extended) setState(() => _extended = extended);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom:
            widget.bottomPadding ??
            (isDesktopLayout(context) ? 16 : bottomNavHeight),
      ),
      child: _extended
          ? FloatingActionButton.extended(
              heroTag: null,
              onPressed: widget.onPressed,
              label: widget.label,
              icon: widget.icon,
            )
          : FloatingActionButton(
              heroTag: null,
              onPressed: widget.onPressed,
              child: widget.icon,
            ),
    );
  }
}
