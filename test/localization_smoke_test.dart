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

  testWidgets('loads Dutch localization', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('nl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Text(AppLocalizations.of(context).navSettings),
        ),
      ),
    );

    expect(find.text('Instellingen'), findsOneWidget);
  });

  testWidgets('loads Polish localization', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Text(AppLocalizations.of(context).navSettings),
        ),
      ),
    );

    expect(find.text('Ustawienia'), findsOneWidget);
  });

  testWidgets('loads Japanese localization', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ja'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Text(AppLocalizations.of(context).navSettings),
        ),
      ),
    );

    expect(find.text('設定'), findsOneWidget);
  });

  testWidgets('loads Korean localization', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ko'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Text(AppLocalizations.of(context).navSettings),
        ),
      ),
    );

    expect(find.text('설정'), findsOneWidget);
  });

  testWidgets('loads Simplified Chinese localization', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh', 'CN'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Text(AppLocalizations.of(context).navSettings),
        ),
      ),
    );

    expect(find.text('设置'), findsOneWidget);
  });

  testWidgets('loads Traditional Chinese localization', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh', 'TW'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Text(AppLocalizations.of(context).navSettings),
        ),
      ),
    );

    expect(find.text('設定'), findsOneWidget);
  });

  testWidgets('loads Russian localization', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Text(AppLocalizations.of(context).navSettings),
        ),
      ),
    );

    expect(find.text('Настройки'), findsOneWidget);
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

  test('formats Dutch singular and plural messages', () {
    final l10n = lookupAppLocalizations(const Locale('nl'));

    expect(
      l10n.deleteRecordsConfirmation(1),
      'Weet je zeker dat je 1 record wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt.',
    );
    expect(
      l10n.deleteRecordsConfirmation(3),
      'Weet je zeker dat je 3 records wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt.',
    );
    expect(l10n.editSets(1), '1 set bewerken');
    expect(l10n.editSets(4), '4 sets bewerken');
  });

  test('formats Polish plural categories', () {
    final l10n = lookupAppLocalizations(const Locale('pl'));

    expect(
      l10n.deleteRecordsConfirmation(1),
      'Czy na pewno chcesz usunąć 1 rekord? Tej operacji nie można cofnąć.',
    );
    expect(
      l10n.deleteRecordsConfirmation(3),
      'Czy na pewno chcesz usunąć 3 rekordy? Tej operacji nie można cofnąć.',
    );
    expect(
      l10n.deleteRecordsConfirmation(5),
      'Czy na pewno chcesz usunąć 5 rekordów? Tej operacji nie można cofnąć.',
    );
    expect(l10n.editSets(1), 'Edytuj 1 serię');
    expect(l10n.editSets(3), 'Edytuj 3 serie');
    expect(l10n.editSets(5), 'Edytuj 5 serii');
    expect(l10n.selectedCount(1), 'Wybrano 1');
    expect(l10n.selectedCount(3), 'Wybrano 3');
    expect(l10n.selectedCount(5), 'Wybrano 5');
  });

  test('formats CJK count messages', () {
    final japanese = lookupAppLocalizations(const Locale('ja'));
    final korean = lookupAppLocalizations(const Locale('ko'));
    final chinese = lookupAppLocalizations(const Locale('zh', 'CN'));
    final traditionalChinese = lookupAppLocalizations(const Locale('zh', 'TW'));

    expect(japanese.deleteRecordsConfirmation(1), '1件の記録を削除しますか？この操作は元に戻せません。');
    expect(japanese.deleteRecordsConfirmation(3), '3件の記録を削除しますか？この操作は元に戻せません。');
    expect(japanese.editSets(4), '4セットを編集');

    expect(
      korean.deleteRecordsConfirmation(1),
      '기록 1개를 삭제할까요? 이 작업은 되돌릴 수 없습니다.',
    );
    expect(
      korean.deleteRecordsConfirmation(3),
      '기록 3개를 삭제할까요? 이 작업은 되돌릴 수 없습니다.',
    );
    expect(korean.editSets(4), '세트 4개 편집');

    expect(chinese.deleteRecordsConfirmation(1), '确定要删除 1 条记录吗？此操作无法撤销。');
    expect(chinese.deleteRecordsConfirmation(3), '确定要删除 3 条记录吗？此操作无法撤销。');
    expect(chinese.editSets(4), '编辑 4 组');

    expect(
      traditionalChinese.deleteRecordsConfirmation(1),
      '確定要刪除 1 筆紀錄嗎？此操作無法撤銷。',
    );
    expect(
      traditionalChinese.deleteRecordsConfirmation(3),
      '確定要刪除 3 筆紀錄嗎？此操作無法撤銷。',
    );
    expect(traditionalChinese.editSets(4), '編輯 4 組');
  });

  test('provides localized measurement unit labels', () {
    final english = lookupAppLocalizations(const Locale('en'));
    final spanish = lookupAppLocalizations(const Locale('es'));
    final french = lookupAppLocalizations(const Locale('fr'));
    final german = lookupAppLocalizations(const Locale('de'));
    final italian = lookupAppLocalizations(const Locale('it'));
    final portuguese = lookupAppLocalizations(const Locale('pt', 'BR'));
    final dutch = lookupAppLocalizations(const Locale('nl'));
    final polish = lookupAppLocalizations(const Locale('pl'));
    final japanese = lookupAppLocalizations(const Locale('ja'));
    final korean = lookupAppLocalizations(const Locale('ko'));
    final chinese = lookupAppLocalizations(const Locale('zh', 'CN'));

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
    expect(dutch.kilogramsUnit, 'Kilogram (kg)');
    expect(dutch.kilometersUnit, 'Kilometer (km)');
    expect(polish.kilogramsUnit, 'Kilogramy (kg)');
    expect(polish.kilometersUnit, 'Kilometry (km)');
    expect(japanese.kilogramsUnit, 'キログラム (kg)');
    expect(japanese.kilometersUnit, 'キロメートル (km)');
    expect(korean.kilogramsUnit, '킬로그램 (kg)');
    expect(korean.kilometersUnit, '킬로미터 (km)');
    expect(chinese.kilogramsUnit, '千克 (kg)');
    expect(chinese.kilometersUnit, '千米 (km)');
  });
}
