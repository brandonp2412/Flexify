import 'package:flutter/material.dart';

class AnimatedFab extends StatefulWidget {
  final Function onPressed;
  final Widget label;
  final ScrollController? scroll;
  final Widget? icon;

  const AnimatedFab({
    super.key,
    required this.onPressed,
    required this.label,
    this.scroll,
    required this.icon,
  });

  @override
  State<AnimatedFab> createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab> {
  bool extended = true;

  @override
  void initState() {
    super.initState();
    widget.scroll?.addListener(onScroll);
  }

  @override
  void dispose() {
    widget.scroll?.removeListener(onScroll);
    super.dispose();
  }

  void onScroll() {
    if (widget.scroll!.position.atEdge && widget.scroll!.position.pixels == 0)
      setState(() {
        extended = true;
      });
    else
      setState(() {
        extended = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 96),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: extended ? 100 : 56,
        height: 56,
        child: FloatingActionButton.extended(
          onPressed: () => widget.onPressed(),
          label: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: extended ? 1.0 : 0.0,
            child: widget.label,
          ),
          icon: widget.icon,
          isExtended: extended,
        ),
      ),
    );
  }
}
