import 'package:flexify/sets/history_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fixtures.dart';
import 'support/test_app.dart';

void main() {
  testWidgets('HistoryList', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    final scroll = ScrollController();
    addTearDown(scroll.dispose);

    await harness.pump(
      tester,
      Scaffold(
        body: HistoryList(
          scroll: scroll,
          sets: [
            gymSetModelFixture(
              id: 1,
              bodyWeight: 54,
              duration: 8,
              distance: 9,
            ),
          ],
          onNext: () {},
          onSelect: (value) {},
          selected: const {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bench press'), findsOne);
    expect(find.text('2 x 3 kg'), findsOne);
  });
}
