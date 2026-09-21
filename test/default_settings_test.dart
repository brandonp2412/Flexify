import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  test('new installs keep optional features off by default', () async {
    final harness = await FlexifyTestHarness.create();
    final settings = await harness.database.settings.select().getSingle();

    expect(settings.showUnits, isFalse);
    expect(settings.showBodyWeight, isFalse);
    expect(settings.showCategories, isFalse);
    expect(settings.showImages, isFalse);
    expect(settings.showGlobalProgress, isFalse);
    expect(settings.notifications, isFalse);
    expect(settings.durationEstimation, isFalse);
    expect(settings.keepScreenOn, isFalse);
    expect(settings.showNotes, isFalse);
    expect(settings.restTimers, isFalse);
  });
}
