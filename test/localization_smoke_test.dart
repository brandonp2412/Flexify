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

  testWidgets('loads Spanish localization', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Text(AppLocalizations.of(context).navSettings),
        ),
      ),
    );

    expect(find.text('Ajustes'), findsOneWidget);
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

  test('formats Spanish singular and plural messages', () {
    final l10n = lookupAppLocalizations(const Locale('es'));

    expect(
      l10n.deleteRecordsConfirmation(1),
      '¿Seguro que quieres eliminar 1 registro? Esta acción no se puede deshacer.',
    );
    expect(
      l10n.deleteRecordsConfirmation(3),
      '¿Seguro que quieres eliminar 3 registros? Esta acción no se puede deshacer.',
    );
    expect(l10n.editSets(1), 'Editar 1 serie');
    expect(l10n.editSets(4), 'Editar 4 series');
  });

  test('provides localized measurement unit labels', () {
    final english = lookupAppLocalizations(const Locale('en'));
    final spanish = lookupAppLocalizations(const Locale('es'));

    expect(english.kilogramsUnit, 'Kilograms (kg)');
    expect(english.poundsUnit, 'Pounds (lb)');
    expect(english.kilometersUnit, 'Kilometers (km)');
    expect(english.kilocaloriesUnit, 'Kilocalories (kcal)');
    expect(spanish.kilogramsUnit, 'Kilogramos (kg)');
    expect(spanish.kilometersUnit, 'Kilómetros (km)');
  });
}
