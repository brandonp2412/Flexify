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

      if ($(Switch).which<Switch>((widget) => widget.value).exists) {
        await $('Automatic backup').tap();
        await $.pumpAndSettle();
      }
      expect($(Switch).which<Switch>((widget) => !widget.value).exists, isTrue);

      await $('Automatic backup').tap();
      await $.platform.android.pressBack();
      await $.pump(const Duration(seconds: 1));

      expect($('Automatic backup').exists, isTrue);
      expect($(Switch).which<Switch>((widget) => !widget.value).exists, isTrue);
    },
    semanticsEnabled: false,
    tags: 'backup',
  );
}
