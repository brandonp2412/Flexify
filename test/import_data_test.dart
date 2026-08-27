import 'package:flexify/import_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('ImportData', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.pump(
      tester,
      Builder(builder: (context) => ImportData(ctx: context)),
    );

    await tester.tap(find.text('Import data'));
    await tester.pumpAndSettle();

    expect(find.text('Graphs'), findsOne);
    expect(find.text('Plans'), findsOne);
    expect(find.text('Database'), findsOne);
  });
}
