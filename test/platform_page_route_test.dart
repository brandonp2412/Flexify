import 'package:flexify/platform_page_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  test('desktop page routes are actually instantaneous', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;

    final route = FlexPageRoute<void>(
      builder: (context) => const SizedBox.shrink(),
    );

    expect(route.transitionDuration, Duration.zero);
    expect(route.reverseTransitionDuration, Duration.zero);
  });

  test('mobile platform does not use desktop route timing', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    expect(isDesktopPlatform, isFalse);
  });
}
