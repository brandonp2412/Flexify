import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';

class SettingsState extends ChangeNotifier {
  late Setting value;
  StreamSubscription? subscription;

  SettingsState(Setting settings) {
    value = settings;
    init();
  }

  @override
  dispose() {
    super.dispose();
    subscription?.cancel();
  }

  Future<void> init() async {
    subscription =
        (db.settings.select()..limit(1)).watchSingle().listen((event) {
      value = event;
      notifyListeners();
    });
  }
}
