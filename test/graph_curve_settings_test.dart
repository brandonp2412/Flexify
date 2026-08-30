import 'package:flexify/graph/graph_curve_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('curve controls persist graph line settings', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();

    await harness.pump(tester, const Scaffold(body: GraphCurveSettings()));
    await tester.pumpAndSettle();

    expect(find.text('Curve line graphs'), findsOne);
    expect(find.text('Curve smoothness'), findsOne);

    final initial = await harness.database
        .select(harness.database.settings)
        .getSingle();
    expect(initial.curveLines, isTrue);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    final updated = await harness.database
        .select(harness.database.settings)
        .getSingle();
    expect(updated.curveLines, isFalse);
  });
}
