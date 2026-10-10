import 'package:flexify/graph/graph_options_controls.dart';
import 'package:flexify/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('history and options share a responsive action wrap', (
    tester,
  ) async {
    var historyTaps = 0;
    var optionsTaps = 0;

    Widget app(double width) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: width,
            child: GraphActionButtons(
              onHistoryPressed: () => historyTaps++,
              onOptionsPressed: () => optionsTaps++,
            ),
          ),
        ),
      ),
    );

    final history = find.byKey(const Key('graph-history-button'));
    final options = find.byKey(const Key('graph-options-button'));

    await tester.pumpWidget(app(350));
    expect(find.byType(Wrap), findsOneWidget);
    expect(history, findsOneWidget);
    expect(options, findsOneWidget);
    expect(tester.getTopLeft(history).dy, tester.getTopLeft(options).dy);
    await tester.tap(history);
    await tester.tap(options);
    expect(historyTaps, 1);
    expect(optionsTaps, 1);

    await tester.pumpWidget(app(155));
    await tester.pump();
    expect(
      tester.getTopLeft(options).dy,
      greaterThan(tester.getTopLeft(history).dy),
    );
  });
}
