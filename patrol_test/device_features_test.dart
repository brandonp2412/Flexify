import 'dart:io';

import 'package:flexify/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:patrol/patrol.dart';

const _uiTimeout = Duration(seconds: 15);
const _nativeTimeout = Duration(seconds: 15);

void main() {
  patrolTest(
    'core navigation and Android data management work end to end',
    ($) async {
      if (!Platform.isAndroid) return;

      app.main();

      await $(
        Icons.calendar_today_outlined,
      ).waitUntilVisible(timeout: _uiTimeout).tap();
      await $(
        Icons.insights_rounded,
      ).waitUntilVisible(timeout: _uiTimeout).tap();
      await $(Icons.timer_rounded).waitUntilVisible(timeout: _uiTimeout).tap();
      await $(Icons.settings).waitUntilVisible(timeout: _uiTimeout).tap();
      await $('Data management').waitUntilVisible(timeout: _uiTimeout).tap();

      final backupTile = $(#automaticBackupTile);
      final backupSwitch = $(#automaticBackupSwitch);
      await backupTile.waitUntilVisible(timeout: _uiTimeout);
      await $('Export data').waitUntilVisible(timeout: _uiTimeout);
      await $('Import data').waitUntilVisible(timeout: _uiTimeout);
      await $('Delete records').waitUntilVisible(timeout: _uiTimeout);

      if (backupSwitch.which<Switch>((widget) => widget.value).exists) {
        await backupTile.tap();
        await backupSwitch
            .which<Switch>((widget) => !widget.value)
            .waitUntilExists(timeout: _uiTimeout);
      }

      await backupTile.tap();
      await $.platform.android.waitUntilVisible(
        const AndroidSelector(
          applicationPackage: 'com.google.android.documentsui',
        ),
        timeout: _nativeTimeout,
      );
      await $.platform.android.pressBack();

      await backupTile.waitUntilVisible(timeout: _uiTimeout);
      await backupSwitch
          .which<Switch>((widget) => !widget.value)
          .waitUntilExists(timeout: _uiTimeout);
    },
    semanticsEnabled: false,
    tags: 'backup',
  );
}
