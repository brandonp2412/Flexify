import 'package:flexify/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('optional features are opt-in by default', () {
    expect(defaultSettings.showUnits.value, isFalse);
    expect(defaultSettings.showBodyWeight.value, isFalse);
    expect(defaultSettings.showCategories.value, isFalse);
    expect(defaultSettings.showNotes.value, isFalse);
    expect(defaultSettings.showImages.value, isFalse);
    expect(defaultSettings.showGlobalProgress.value, isFalse);
    expect(defaultSettings.notifications.value, isFalse);
    expect(defaultSettings.durationEstimation.value, isFalse);
    expect(defaultSettings.keepScreenOn.value, isFalse);
    expect(defaultSettings.restTimers.value, isFalse);
  });
}
