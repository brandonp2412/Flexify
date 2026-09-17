import 'package:flexify/constants.dart';
import 'package:flexify/l10n/generated/app_localizations.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget formattingApp(Locale locale, String Function(BuildContext) value) =>
    MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
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

  testWidgets('parses localized decimal input using the active locale', (
    tester,
  ) async {
    await tester.pumpWidget(
      formattingApp(
        const Locale('de'),
        (context) => '${parseDisplayNumber(context, '1.234,5')}',
      ),
    );

    expect(find.text('1234.5'), findsOneWidget);
  });

  testWidgets('keeps canonical decimal input parse-safe in any locale', (
    tester,
  ) async {
    await tester.pumpWidget(
      formattingApp(
        const Locale('de'),
        (context) => '${parseDisplayNumber(context, '12.5')}',
      ),
    );

    expect(find.text('12.5'), findsOneWidget);
  });

  testWidgets('formats editable decimals using the active locale', (
    tester,
  ) async {
    await tester.pumpWidget(
      formattingApp(
        const Locale('de'),
        (context) => formatEditableNumber(context, 12.5),
      ),
    );

    expect(find.text('12,5'), findsOneWidget);
  });

  testWidgets('formats weight without changing its stored numeric value', (
    tester,
  ) async {
    const storedWeight = 1234.5;
    await tester.pumpWidget(
      formattingApp(
        const Locale('de'),
        (context) =>
            '${formatDisplayNumber(context, storedWeight)} ${displayMeasurementUnit(context.l10n, 'kg')}|$storedWeight',
      ),
    );

    expect(find.text('1.234,5 kg|1234.5'), findsOneWidget);
  });

  testWidgets('formats distance without changing its stored numeric value', (
    tester,
  ) async {
    const storedDistance = 12.5;
    await tester.pumpWidget(
      formattingApp(
        const Locale('de'),
        (context) =>
            '${formatDisplayNumber(context, storedDistance)} ${displayMeasurementUnit(context.l10n, 'km')}|$storedDistance',
      ),
    );

    expect(find.text('12,5 km|12.5'), findsOneWidget);
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

  testWidgets('uses Brazilian Portuguese for the Portuguese fallback locale', (
    tester,
  ) async {
    final fiveMinutesAgo = DateTime.now().subtract(const Duration(minutes: 5));

    await tester.pumpWidget(
      formattingApp(
        const Locale('pt', 'PT'),
        (context) => formatRelativeTime(context, fiveMinutesAgo),
      ),
    );

    expect(find.textContaining('há 5 minutos'), findsOneWidget);
  });

  testWidgets('uses Simplified Chinese for the Chinese fallback locale', (
    tester,
  ) async {
    final fiveMinutesAgo = DateTime.now().subtract(const Duration(minutes: 5));

    await tester.pumpWidget(
      formattingApp(
        const Locale('zh', 'TW'),
        (context) => formatRelativeTime(context, fiveMinutesAgo),
      ),
    );

    expect(find.textContaining('5 分 前'), findsOneWidget);
  });
}
