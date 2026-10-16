import 'package:flexify/app_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AppFab collapses immediately without resize animations', (
    tester,
  ) async {
    final scroll = ScrollController();
    addTearDown(scroll.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          floatingActionButtonAnimator:
              FloatingActionButtonAnimator.noAnimation,
          floatingActionButton: AppFab(
            onPressed: () {},
            label: const Text('Add'),
            icon: const Icon(Icons.add),
            scroll: scroll,
          ),
          body: ListView(
            controller: scroll,
            children: const [SizedBox(height: 2000)],
          ),
        ),
      ),
    );

    expect(
      tester
          .widget<FloatingActionButton>(find.byType(FloatingActionButton))
          .isExtended,
      isTrue,
    );
    expect(
      find.descendant(
        of: find.byType(AppFab),
        matching: find.byType(AnimatedContainer),
      ),
      findsNothing,
    );

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pump();
    expect(
      tester
          .widget<FloatingActionButton>(find.byType(FloatingActionButton))
          .isExtended,
      isFalse,
    );
    expect(
      find.descendant(
        of: find.byType(AppFab),
        matching: find.byType(AnimatedOpacity),
      ),
      findsNothing,
    );
  });
}
