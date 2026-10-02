import 'package:flexify/responsive.dart';
import 'package:flexify/settings/appearance_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('Appearance settings use desktop card layout', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await harness.pump(
      tester,
      const AppearanceSettings(),
      surfaceSize: const Size(1200, 900),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ResponsiveSettingsList), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
