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

      // Force a known transition to enabled. Notification permission is
      // resolved first; the app then launches ACTION_OPEN_DOCUMENT_TREE.
      if ($(Switch).which<Switch>((widget) => widget.value).exists) {
        await $('Automatic backup').tap();
        await $.pumpAndSettle();
      }
      await $('Automatic backup').tap();

      if (await $.platform.mobile.isPermissionDialogVisible()) {
        await $.platform.mobile.grantPermissionWhenInUse();
        await $.pumpAndSettle();
      }

      // ACTION_OPEN_DOCUMENT_TREE is fulfilled by Android's DocumentsUI.
      // Individual labels/actions differ across API levels and initial folders,
      // so assert the system picker package rather than a presentation detail.
      await $.platform.android.waitUntilVisible(
        const AndroidSelector(applicationPackage: 'com.google.android.documentsui'),
        timeout: const Duration(seconds: 20),
      );

      // Leave no persisted folder grant behind for subsequent test runs.
      await $.platform.android.pressBack();
    },
    semanticsEnabled: false,
  );
}
