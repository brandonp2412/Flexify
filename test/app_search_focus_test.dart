import 'package:flexify/app_search.dart';
import 'package:flexify/selection_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('AppSearch padding taps focus the search field', (tester) async {
    final harness = await FlexifyTestHarness.create();
    final selection = SelectionController<String>();

    await harness.pump(
      tester,
      Scaffold(
        body: AppSearch(
          controller: selection,
          onChange: (_) {},
          onSelectAll: () {},
          onDelete: () async {},
          onEdit: () async {},
          onShare: () async {},
        ),
      ),
      surfaceSize: const Size(430, 240),
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

  testWidgets('AppSearch popup rows have one interactive surface', (
    tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final selection = SelectionController<String>();
    var selectedAll = false;

    await harness.pump(
      tester,
      Scaffold(
        body: AppSearch(
          controller: selection,
          onChange: (_) {},
          onSelectAll: () => selectedAll = true,
          onDelete: () async {},
          onEdit: () async {},
          onShare: () async {},
        ),
      ),
      surfaceSize: const Size(1024, 600),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    final selectAllText = find.text('Select all');
    expect(selectAllText, findsOneWidget);

    final tile = tester.widget<ListTile>(
      find.ancestor(of: selectAllText, matching: find.byType(ListTile)),
    );
    expect(tile.onTap, isNull);

    await tester.tap(selectAllText);
    await tester.pumpAndSettle();

    expect(selectedAll, isTrue);
  });
}
