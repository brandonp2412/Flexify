import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:patrol/patrol.dart';

const _uiTimeout = Duration(seconds: 15);
const _nativeTimeout = Duration(seconds: 15);

bool _isDocumentsUi(AndroidNativeView view) {
  final packageName = view.applicationPackage?.toLowerCase();
  if (packageName != null && packageName.endsWith('.documentsui')) {
    return true;
  }

  return view.children.any(_isDocumentsUi);
}

Future<void> _waitForDocumentsUi(AndroidAutomator android) async {
  final deadline = DateTime.now().add(_nativeTimeout);
  while (DateTime.now().isBefore(deadline)) {
    final nativeViews = await android.getNativeViews(null);
    if (nativeViews.roots.any(_isDocumentsUi)) return;
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }

  throw StateError(
    'Android document picker did not appear within $_nativeTimeout',
  );
}

void main() {
  patrolTest(
    'core navigation and Android data management work end to end',
    ($) async {
      if (!Platform.isAndroid) return;

      await app.db.settings.update().write(
        const SettingsCompanion(localeOverride: Value('en')),
      );
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
      await _waitForDocumentsUi($.platform.android);
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
