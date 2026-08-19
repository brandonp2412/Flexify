import 'dart:io';

import 'package:flexify/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'core navigation and Android data management work end to end',
    ($) async {
      if (!Platform.isAndroid) return;

      app.main();
      await $.pumpAndSettle();

      await $(Icons.calendar_today_outlined).tap();
      await $(Icons.insights_rounded).tap();
      await $(Icons.timer_rounded).tap();

      await $(Icons.settings).tap();
      await $('Data management').tap();
      await $.pumpAndSettle();
      expect($('Automatic backup').exists, isTrue);
      expect($('Export data').exists, isTrue);
      expect($('Import data').exists, isTrue);
      expect($('Delete records').exists, isTrue);

      // Force a known transition to enabled, which launches the real Android
      // ACTION_OPEN_DOCUMENT_TREE folder picker.
      if ($(Switch).which<Switch>((widget) => widget.value).exists) {
        await $('Automatic backup').tap();
        await $.pumpAndSettle();
      }
      await $('Automatic backup').tap();

      if (await $.platform.mobile.isPermissionDialogVisible()) {
        await $.platform.mobile.grantPermissionWhenInUse();
      }

      await $.platform.android.waitUntilVisible(
        const AndroidSelector(contentDescription: 'New folder'),
        timeout: const Duration(seconds: 10),
      );

      // Leave no persisted folder grant behind for subsequent test runs.
      await $.platform.android.pressBack();
    },
    semanticsEnabled: false,
  );
}
