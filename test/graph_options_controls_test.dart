import 'package:flexify/graph/graph_options_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets(
    'desktop graph controls fit without overflow at a narrow desktop width',
    (WidgetTester tester) async {
      final harness = await FlexifyTestHarness.create();

      await harness.pump(
        tester,
        Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 780,
              child: GraphOptionsControls(
                compact: true,
                shortDateFormat: 'M/d/yy',
                startDate: null,
                endDate: null,
                onSelectStart: () {},
                onClearStart: () {},
                onSelectEnd: () {},
                onClearEnd: () {},
                limit: 20,
                maxLimit: 100,
                onLimitChanged: (_) {},
                timeBasedXAxis: false,
                onTimeBasedXAxisChanged: (_) {},
              ),
            ),
          ),
        ),
        surfaceSize: const Size(820, 500),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Start date'), findsOneWidget);
      expect(find.text('Stop date'), findsOneWidget);
      expect(find.text('Data points'), findsOneWidget);
      expect(find.text('Use time-based X axis'), findsOneWidget);
      expect(find.text('Curve line graphs'), findsOneWidget);

      final startY = tester.getTopLeft(find.text('Start date')).dy;
      final stopY = tester.getTopLeft(find.text('Stop date')).dy;
      final dataY = tester.getTopLeft(find.text('Data points')).dy;
      expect((startY - stopY).abs(), lessThan(2));
      expect((startY - dataY).abs(), lessThan(4));

      final timeAxisY = tester.getCenter(find.text('Use time-based X axis')).dy;
      final curveY = tester.getCenter(find.text('Curve line graphs')).dy;
      expect((timeAxisY - curveY).abs(), lessThan(4));
    },
  );
}
