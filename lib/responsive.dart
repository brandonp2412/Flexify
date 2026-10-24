import 'package:flutter/material.dart';

const double desktopBreakpoint = 900;
const double desktopMaxWidth = 1040;
const double wideMaxWidth = 1240;
const double dataMaxWidth = 1440;

/// Whether the current window should use Flex's desktop layout.
bool isDesktopLayout(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= desktopBreakpoint;

/// Constrains page content on wide windows while leaving mobile unconstrained.
class ResponsiveContent extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry mobilePadding;
  final EdgeInsetsGeometry desktopPadding;
  final Alignment alignment;

  const ResponsiveContent({
    super.key,
    required this.child,
    this.maxWidth = desktopMaxWidth,
    this.mobilePadding = EdgeInsets.zero,
    this.desktopPadding = const EdgeInsets.symmetric(horizontal: 24),
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    final desktop = isDesktopLayout(context);
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: desktop ? maxWidth : double.infinity,
        ),
        child: Padding(
          padding: desktop ? desktopPadding : mobilePadding,
          child: child,
        ),
      ),
    );
  }
}

/// Keeps settings readable at every window width.
class ResponsiveSettingsList extends StatelessWidget {
  final List<Widget> children;
  final double maxWidth;
  final bool grouped;

  const ResponsiveSettingsList({
    super.key,
    required this.children,
    this.maxWidth = 720,
    this.grouped = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = grouped
        ? [
            Card(
              margin: EdgeInsets.zero,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(children: children),
              ),
            ),
          ]
        : children;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView(
            padding: const EdgeInsets.only(top: 12, bottom: 116),
            children: content,
          ),
        ),
      ),
    );
  }
}

/// Shows a native-feeling popup menu at a desktop secondary-click position.
Future<T?> showDesktopContextMenu<T>(
  BuildContext context,
  Offset globalPosition,
  List<PopupMenuEntry<T>> items,
) {
  final overlay = Overlay.of(context).context.findRenderObject()! as RenderBox;
  return showMenu<T>(
    context: context,
    position: RelativeRect.fromRect(
      globalPosition & const Size(1, 1),
      Offset.zero & overlay.size,
    ),
    items: items,
  );
}
