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

  testWidgets('loads French localization', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Text(AppLocalizations.of(context).navSettings),
        ),
      ),
    );

    expect(find.text('Paramètres'), findsOneWidget);
  });

  testWidgets('loads German localization', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Text(AppLocalizations.of(context).navSettings),
        ),
      ),
    );

    expect(find.text('Einstellungen'), findsOneWidget);
  });

  testWidgets('loads Italian localization', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('it'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Text(AppLocalizations.of(context).navSettings),
        ),
      ),
    );

    expect(find.text('Impostazioni'), findsOneWidget);
  });

  testWidgets('loads Brazilian Portuguese localization', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Text(AppLocalizations.of(context).navSettings),
        ),
      ),
    );

    expect(find.text('Configurações'), findsOneWidget);
  });

  testWidgets('loads Portuguese through language fallback', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'PT'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Text(AppLocalizations.of(context).navSettings),
        ),
      ),
    );

    expect(find.text('Configurações'), findsOneWidget);
  });

  testWidgets('falls back safely for an unsupported locale', (tester) async {
    await tester.pumpWidget(localizedTitleApp(const Locale('zz')));

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

  test('formats French singular and plural messages', () {
    final l10n = lookupAppLocalizations(const Locale('fr'));

    expect(
      l10n.deleteRecordsConfirmation(1),
      'Voulez-vous vraiment supprimer 1 enregistrement ? Cette action est irréversible.',
    );
    expect(
      l10n.deleteRecordsConfirmation(3),
      'Voulez-vous vraiment supprimer 3 enregistrements ? Cette action est irréversible.',
    );
    expect(l10n.editSets(1), 'Modifier 1 série');
    expect(l10n.editSets(4), 'Modifier 4 séries');
  });

  test('formats German singular and plural messages', () {
    final l10n = lookupAppLocalizations(const Locale('de'));

    expect(
      l10n.deleteRecordsConfirmation(1),
      'Möchtest du wirklich 1 Eintrag löschen? Diese Aktion kann nicht rückgängig gemacht werden.',
    );
    expect(
      l10n.deleteRecordsConfirmation(3),
      'Möchtest du wirklich 3 Einträge löschen? Diese Aktion kann nicht rückgängig gemacht werden.',
    );
    expect(l10n.editSets(1), '1 Satz bearbeiten');
    expect(l10n.editSets(4), '4 Sätze bearbeiten');
  });

  test('formats Italian singular and plural messages', () {
    final l10n = lookupAppLocalizations(const Locale('it'));

    expect(
      l10n.deleteRecordsConfirmation(1),
      'Vuoi davvero eliminare 1 record? Questa azione non può essere annullata.',
    );
    expect(
      l10n.deleteRecordsConfirmation(3),
      'Vuoi davvero eliminare 3 record? Questa azione non può essere annullata.',
    );
    expect(l10n.editSets(1), 'Modifica 1 serie');
    expect(l10n.editSets(4), 'Modifica 4 serie');
  });

  test('formats Brazilian Portuguese singular and plural messages', () {
    final l10n = lookupAppLocalizations(const Locale('pt', 'BR'));

    expect(
      l10n.deleteRecordsConfirmation(1),
      'Tem certeza de que deseja excluir 1 registro? Esta ação não pode ser desfeita.',
    );
    expect(
      l10n.deleteRecordsConfirmation(3),
      'Tem certeza de que deseja excluir 3 registros? Esta ação não pode ser desfeita.',
    );
    expect(l10n.editSets(1), 'Editar 1 série');
    expect(l10n.editSets(4), 'Editar 4 séries');
  });

  test('provides localized measurement unit labels', () {
    final english = lookupAppLocalizations(const Locale('en'));
    final spanish = lookupAppLocalizations(const Locale('es'));
    final french = lookupAppLocalizations(const Locale('fr'));
    final german = lookupAppLocalizations(const Locale('de'));
    final italian = lookupAppLocalizations(const Locale('it'));
    final portuguese = lookupAppLocalizations(const Locale('pt', 'BR'));

    expect(english.kilogramsUnit, 'Kilograms (kg)');
    expect(english.poundsUnit, 'Pounds (lb)');
    expect(english.kilometersUnit, 'Kilometers (km)');
    expect(english.kilocaloriesUnit, 'Kilocalories (kcal)');
    expect(spanish.kilogramsUnit, 'Kilogramos (kg)');
    expect(spanish.kilometersUnit, 'Kilómetros (km)');
    expect(french.kilogramsUnit, 'Kilogrammes (kg)');
    expect(french.kilometersUnit, 'Kilomètres (km)');
    expect(german.kilogramsUnit, 'Kilogramm (kg)');
    expect(german.kilometersUnit, 'Kilometer (km)');
    expect(italian.kilogramsUnit, 'Chilogrammi (kg)');
    expect(italian.kilometersUnit, 'Chilometri (km)');
    expect(portuguese.kilogramsUnit, 'Quilogramas (kg)');
    expect(portuguese.kilometersUnit, 'Quilômetros (km)');
  });
}
