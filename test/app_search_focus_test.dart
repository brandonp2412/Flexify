import 'package:flex/app_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('AppSearch padding taps focus the search field', (tester) async {
    final harness = await FlexTestHarness.create();
    final selection = <String>{};

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

  testWidgets('Clear selection menu uses deselect icon and clears selection', (
    tester,
  ) async {
    final harness = await FlexTestHarness.create();
    final selection = <String>{}..add('plan');

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
      surfaceSize: const Size(1024, 600),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    final tile = tester.widget<ListTile>(
      find.ancestor(
        of: find.text('Clear selection'),
        matching: find.byType(ListTile),
      ),
    );
    expect((tile.leading! as Icon).icon, Icons.deselect);

    await tester.tap(find.text('Clear selection'));
    await tester.pumpAndSettle();
    expect(selection.isEmpty, isTrue);
  });

  testWidgets('AppSearch popup rows have one interactive surface', (
    tester,
  ) async {
    final harness = await FlexTestHarness.create();
    final selection = <String>{};
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
