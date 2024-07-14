import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';

class SettingsState extends ChangeNotifier {
  late Setting value;

  SettingsState(Setting settings) {
    value = settings;
    init();
  }

  Future<void> init() async {
    (db.settings.select()..limit(1)).watchSingle().listen((event) {
      value = event;
      notifyListeners();
    });
  }
}
