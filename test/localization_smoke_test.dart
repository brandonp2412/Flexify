import 'package:flexify/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget localizedTitleApp(Locale locale) => MaterialApp(
  locale: locale,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Builder(
    builder: (context) => Text(AppLocalizations.of(context).appTitle),
  ),
);

void main() {
  testWidgets('loads canonical English localization', (tester) async {
    await tester.pumpWidget(localizedTitleApp(const Locale('en')));

    expect(find.text('Flexify'), findsOneWidget);
  });

  testWidgets('loads a regional English locale through language fallback', (
    tester,
  ) async {
    await tester.pumpWidget(localizedTitleApp(const Locale('en', 'NZ')));

    expect(find.text('Flexify'), findsOneWidget);
  });

  testWidgets('falls back safely for an unsupported locale', (tester) async {
    await tester.pumpWidget(localizedTitleApp(const Locale('fr')));

    expect(find.text('Flexify'), findsOneWidget);
  });

  test('formats shared delete confirmation plurals', () {
    final l10n = lookupAppLocalizations(const Locale('en'));

    expect(
      l10n.deleteRecordsConfirmation(1),
      'Are you sure you want to delete 1 record? This action is not reversible.',
    );
    expect(
      l10n.deleteRecordsConfirmation(3),
      'Are you sure you want to delete 3 records? This action is not reversible.',
    );
  });

  test('formats localized data import validation messages', () {
    final l10n = lookupAppLocalizations(const Locale('en'));

    expect(
      l10n.csvRowInsufficientColumns(4, 3),
      'Row 4 has insufficient columns: 3',
    );
    expect(
      l10n.invalidCsvValue('Reps', 2, 'abc'),
      'Invalid Reps value in row 2: abc',
    );
    expect(
      l10n.failedToImportGraphs('CSV file is empty'),
      'Failed to import graphs: CSV file is empty',
    );
  });

  test('provides localized measurement unit labels', () {
    final l10n = lookupAppLocalizations(const Locale('en'));

    expect(l10n.kilogramsUnit, 'Kilograms (kg)');
    expect(l10n.poundsUnit, 'Pounds (lb)');
    expect(l10n.kilometersUnit, 'Kilometers (km)');
    expect(l10n.kilocaloriesUnit, 'Kilocalories (kcal)');
  });
}
