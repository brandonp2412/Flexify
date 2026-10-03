import 'package:flexify/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('touching outside a text field releases its focus', (
    WidgetTester tester,
  ) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: KeyboardUnfocusWrapper(
          child: Scaffold(
            body: Column(
              children: [
                TextField(focusNode: focusNode),
                const TextButton(onPressed: _doNothing, child: Text('Done')),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(focusNode.hasFocus, isTrue);

    await tester.tap(find.text('Done'));
    await tester.pump();
    expect(focusNode.hasFocus, isFalse);
  });
}

void _doNothing() {}
