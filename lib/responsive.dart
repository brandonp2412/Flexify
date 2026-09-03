import 'package:flutter/material.dart';

const double desktopBreakpoint = 900;
const double desktopContentMaxWidth = 1040;
const double desktopWideContentMaxWidth = 1240;

/// Whether the current window should use Flexify's desktop layout.
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
    this.maxWidth = desktopContentMaxWidth,
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

/// Adds the standard desktop surface treatment around wide-screen content.
class DesktopSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  const DesktopSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.maxWidth = desktopContentMaxWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (!isDesktopLayout(context)) return child;
    final colors = Theme.of(context).colorScheme;
    return ResponsiveContent(
      maxWidth: maxWidth,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: .45),
          ),
        ),
        child: child,
      ),
    );
  }
}
