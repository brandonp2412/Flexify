import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool get isDesktopPlatform =>
    !kIsWeb &&
    {
      TargetPlatform.linux,
      TargetPlatform.macOS,
      TargetPlatform.windows,
    }.contains(defaultTargetPlatform);

/// Material route semantics on mobile, but truly instant transitions on desktop.
class FlexPageRoute<T> extends MaterialPageRoute<T> {
  FlexPageRoute({
    required super.builder,
    super.settings,
    super.requestFocus,
    super.maintainState = true,
    super.fullscreenDialog = false,
    super.allowSnapshotting = true,
    super.barrierDismissible = false,
  });

  @override
  Duration get transitionDuration =>
      isDesktopPlatform ? Duration.zero : super.transitionDuration;

  @override
  Duration get reverseTransitionDuration =>
      isDesktopPlatform ? Duration.zero : super.reverseTransitionDuration;
}
