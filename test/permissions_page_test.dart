import 'package:flexify/permissions_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('PermissionsPage', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.pump(tester, const Scaffold(body: PermissionsPage()));
    await tester.pumpAndSettle();

    expect(find.text('Missing permissions'), findsOne);
    expect(find.text('Confirm'), findsOne);
  });
}
