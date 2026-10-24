import 'package:drift/drift.dart' hide isNull;
import 'package:flex/responsive.dart';
import 'package:flex/settings/appearance_settings.dart';
import 'package:flex/settings/data_settings.dart';
import 'package:flex/settings/tab_settings.dart';
import 'package:flex/settings/timer_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('Appearance settings use desktop card layout', (
    WidgetTester tester,
  ) async {
    final harness = await FlexTestHarness.create();
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

  for (final page in <Widget>[
    const AppearanceSettings(),
    const TimerSettings(),
    const TabSettings(),
    const DataSettings(),
  ]) {
    testWidgets('${page.runtimeType} is readable at an 850px window', (
      WidgetTester tester,
    ) async {
      final harness = await FlexTestHarness.create();
      await harness.pump(tester, page, surfaceSize: const Size(850, 900));
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsWidgets);
      expect(tester.getSize(find.byType(Card).first).width, lessThan(740));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Reordering tabs still updates persisted order', (
    WidgetTester tester,
  ) async {
    final harness = await FlexTestHarness.create();
    await harness.pump(
      tester,
      const TabSettings(),
      surfaceSize: const Size(850, 900),
    );
    await tester.pumpAndSettle();

    final historyHandle = find.descendant(
      of: find.byKey(const Key('HistoryPage')),
      matching: find.byIcon(Icons.drag_handle),
    );
    await tester.drag(historyHandle, const Offset(0, 150));
    await tester.pumpAndSettle();

    final settings = await harness.database.settings.select().getSingle();
    expect(settings.tabs.split(','), isNot(startsWith('HistoryPage')));
  });

  testWidgets('Data management presents actions as list rows', (
    WidgetTester tester,
  ) async {
    final harness = await FlexTestHarness.create();
    await harness.pump(
      tester,
      const DataSettings(),
      surfaceSize: const Size(850, 900),
    );
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ListTile, 'Export data'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Import data'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Delete records'), findsOneWidget);
  });
}
