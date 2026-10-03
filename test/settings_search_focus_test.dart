import 'package:flexify/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('Settings search padding taps focus the search field', (
    tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await harness.pump(
      tester,
      const SettingsPage(),
      surfaceSize: const Size(430, 900),
    );
    await tester.pumpAndSettle();

    final searchBar = find.byType(SearchBar);
    final rect = tester.getRect(searchBar);
    final editable = tester.widget<EditableText>(
      find.descendant(of: searchBar, matching: find.byType(EditableText)),
    );
    expect(editable.focusNode.hasFocus, isFalse);
    expect(rect.left, greaterThan(0));

    await tester.tapAt(Offset(rect.left / 2, rect.center.dy));
    await tester.pump();

    expect(editable.focusNode.hasFocus, isTrue);
  });
}
