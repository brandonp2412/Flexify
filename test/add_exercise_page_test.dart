import 'package:flexify/graph/add_exercise_page.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('AddExercise', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.pump(tester, const AddExercisePage());

    expect(find.text('Add exercise'), findsOne);
    await tester.enterText(find.bySemanticsLabel('Name'), 'Bench press 2');

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Add exercise'), findsNothing);
  });
}
