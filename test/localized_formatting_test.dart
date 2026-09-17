import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget formattingApp(Locale locale, String Function(BuildContext) value) =>
    MaterialApp(
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('de'), Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: Builder(builder: (context) => Text(value(context))),
    );

void main() {
  testWidgets('formats decimal values using the active locale', (tester) async {
    await tester.pumpWidget(
      formattingApp(
        const Locale('de'),
        (context) => formatDisplayNumber(context, 1234.5),
      ),
    );

    expect(find.text('1.234,5'), findsOneWidget);
  });

  testWidgets('formats percentages using the active locale', (tester) async {
    await tester.pumpWidget(
      formattingApp(
        const Locale('de'),
        (context) => formatDisplayPercent(context, 0.125),
      ),
    );

    final text = tester.widget<Text>(find.byType(Text)).data!;
    expect(text, contains('12,5'));
    expect(text, contains('%'));
  });

  testWidgets('formats dates using localized month names', (tester) async {
    await tester.pumpWidget(
      formattingApp(
        const Locale('de'),
        (context) =>
            formatDisplayDate(context, DateTime(2026, 9, 18), 'd MMMM yyyy'),
      ),
    );

    final text = tester.widget<Text>(find.byType(Text)).data!;
    expect(text, contains('September'));
    expect(text, contains('2026'));
  });

  testWidgets('formats relative times in the active locale', (tester) async {
    final fiveMinutesAgo = DateTime.now().subtract(const Duration(minutes: 5));

    await tester.pumpWidget(
      formattingApp(
        const Locale('de'),
        (context) => formatRelativeTime(context, fiveMinutesAgo),
      ),
    );

    expect(find.textContaining('vor 5 Minuten'), findsOneWidget);
  });
}
