// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => 'Język';

  @override
  String get settingsLanguageDescription =>
      'Wybierz język używany przez Flexify';

  @override
  String get languageSystemDefault => 'Domyślny systemowy';

  @override
  String get languageNameEnglish => 'English';

  @override
  String get languageNameSpanish => 'Español';

  @override
  String get languageNameFrench => 'Français';

  @override
  String get languageNameGerman => 'Deutsch';

  @override
  String get languageNameItalian => 'Italiano';

  @override
  String get languageNamePortugueseBrazil => 'Português (Brasil)';

  @override
  String get languageNameDutch => 'Nederlands';

  @override
  String get languageNamePolish => 'Polski';

  @override
  String get languageNameJapanese => '日本語';

  @override
  String get languageNameKorean => '한국어';

  @override
  String get languageNameSimplifiedChinese => '简体中文';

  @override
  String get languageNameTraditionalChinese => '繁體中文';

  @override
  String get languageNameTurkish => 'Türkçe';

  @override
  String get languageNameRussian => 'Русский';

  @override
  String get languageNameHindi => 'हिन्दी';

  @override
  String get languageNameArabic => 'العربية';

  @override
  String get languageNameIndonesian => 'Bahasa Indonesia';

  @override
  String get languageNameVietnamese => 'Tiếng Việt';

  @override
  String get navHistory => 'Historia';

  @override
  String get navPlans => 'Plany';

  @override
  String get navGraphs => 'Wykresy';

  @override
  String get navTimer => 'Minutnik';

  @override
  String get navSettings => 'Ustawienia';

  @override
  String get errorLabel => 'Błąd';

  @override
  String get tabContentError => 'Nie udało się wyświetlić zawartości karty.';

  @override
  String get cannotHideAllTabs => 'Nie można ukryć wszystkiego!';

  @override
  String removeTabQuestion(String tab) {
    return 'Usunąć kartę $tab?';
  }

  @override
  String get restoreTabFromSettings =>
      'Możesz dodać ją ponownie później w ustawieniach.';

  @override
  String removedTab(String tab) {
    return 'Usunięto $tab';
  }

  @override
  String newVersion(String version) {
    return 'Nowa wersja $version';
  }

  @override
  String get changes => 'Zmiany';

  @override
  String get searchHint => 'Szukaj...';

  @override
  String get deleteSelected => 'Usuń zaznaczone';

  @override
  String get confirmDelete => 'Potwierdź usunięcie';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Czy na pewno chcesz usunąć $count rekordu? Tej operacji nie można cofnąć.',
      many:
          'Czy na pewno chcesz usunąć $count rekordów? Tej operacji nie można cofnąć.',
      few:
          'Czy na pewno chcesz usunąć $count rekordy? Tej operacji nie można cofnąć.',
      one:
          'Czy na pewno chcesz usunąć 1 rekord? Tej operacji nie można cofnąć.',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'Anuluj';

  @override
  String get actionDelete => 'Usuń';

  @override
  String get actionRemove => 'Usuń';

  @override
  String get actionEdit => 'Edytuj';

  @override
  String get actionShare => 'Udostępnij';

  @override
  String get clearSelection => 'Wyczyść zaznaczenie';

  @override
  String get clearSearch => 'Wyczyść wyszukiwanie';

  @override
  String get showMenu => 'Pokaż menu';

  @override
  String get selectAll => 'Zaznacz wszystko';

  @override
  String get weightLabel => 'Ciężar';

  @override
  String get filter => 'Filtr';

  @override
  String get filters => 'Filtry';

  @override
  String get categoryLabel => 'Kategoria';

  @override
  String get repsLabel => 'Powtórzenia';

  @override
  String get repsFilter => 'Filtr powtórzeń';

  @override
  String get weightFilter => 'Filtr ciężaru';

  @override
  String get greaterThan => 'Większe niż';

  @override
  String get lessThan => 'Mniejsze niż';

  @override
  String get startDate => 'Data początkowa';

  @override
  String get endDate => 'Data końcowa';

  @override
  String get actionClear => 'Wyczyść';

  @override
  String get actionOk => 'OK';

  @override
  String get actionClose => 'Zamknij';

  @override
  String get sortBy => 'Sortuj według';

  @override
  String get dateNewest => 'Data (najnowsze)';

  @override
  String get dateOldest => 'Data (najstarsze)';

  @override
  String get nameLabel => 'Nazwa';

  @override
  String get missingPermissions => 'Brakujące uprawnienia';

  @override
  String get restTimersPermissionsMissing =>
      'Minutniki odpoczynku są włączone, ale brakuje uprawnień.';

  @override
  String get restTimersPermissionsOptional =>
      'Jeśli wyłączysz minutniki odpoczynku, te uprawnienia nie będą potrzebne.';

  @override
  String get restTimers => 'Minutniki odpoczynku';

  @override
  String get disableBatteryOptimizations => 'Wyłącz optymalizację baterii';

  @override
  String get batteryOptimizationWarning =>
      'Postęp może się zatrzymać, jeśli optymalizacja baterii pozostanie włączona.';

  @override
  String get scheduleExactAlarm => 'Zaplanuj dokładny alarm';

  @override
  String get exactAlarmWarning =>
      'Alarmy nie będą dokładne, jeśli ta opcja jest wyłączona.';

  @override
  String get postNotifications => 'Wyświetlaj powiadomienia';

  @override
  String get notificationBarDescription =>
      'Postęp minutnika jest wyświetlany na pasku powiadomień';

  @override
  String get invalidPermissions => 'Nieprawidłowe uprawnienia';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      'Minutniki odpoczynku są włączone bez wystarczających uprawnień. Czy na pewno chcesz kontynuować?';

  @override
  String get actionConfirm => 'Potwierdź';

  @override
  String get appAccess => 'Dostęp aplikacji';

  @override
  String get appAccessDescription =>
      'Wymagany przez włączone minutniki i powiadomienia.';

  @override
  String get notifications => 'Powiadomienia';

  @override
  String get timerProgressAndRestAlerts =>
      'Postęp minutnika i alerty odpoczynku';

  @override
  String get enabledNotificationsDescription =>
      'Włączone przez Ciebie powiadomienia';

  @override
  String get backgroundActivity => 'Aktywność w tle';

  @override
  String get backgroundActivityDescription =>
      'Zapewnia niezawodne działanie minutników w tle';

  @override
  String get exactAlarms => 'Dokładne alarmy';

  @override
  String get exactAlarmsDescription =>
      'Powiadamiaj dokładnie po zakończeniu minutnika odpoczynku';

  @override
  String get noAdditionalAndroidAccessNeeded =>
      'Przy obecnych ustawieniach nie jest wymagany dodatkowy dostęp Androida.';

  @override
  String get actionDone => 'Gotowe';

  @override
  String get allowed => 'Dozwolone';

  @override
  String get actionAllow => 'Zezwól';

  @override
  String get backupLabel => 'Kopia zapasowa';

  @override
  String get databaseLabel => 'Baza danych';

  @override
  String get deleteRecords => 'Usuń rekordy';

  @override
  String get deleteAllGraphsConfirmation =>
      'Czy na pewno chcesz usunąć wszystkie wykresy? Tej operacji nie można cofnąć.';

  @override
  String get deleteAllPlansConfirmation =>
      'Czy na pewno chcesz usunąć wszystkie plany? Tej operacji nie można cofnąć.';

  @override
  String get deleteDatabaseConfirmation =>
      'Czy na pewno chcesz usunąć bazę danych? Tej operacji nie można cofnąć, a wszystkie dane zostaną utracone.';

  @override
  String get importData => 'Importuj dane';

  @override
  String get exportData => 'Eksportuj dane';

  @override
  String get actionReport => 'Zgłoś';

  @override
  String get graphDataImported =>
      'Dane wykresów zostały pomyślnie zaimportowane!';

  @override
  String get plansImported => 'Plany zostały pomyślnie zaimportowane';

  @override
  String failedToImportDatabase(String error) {
    return 'Nie udało się zaimportować bazy danych: $error';
  }

  @override
  String get backupArchiveMissingDatabase =>
      'Kopia zapasowa nie zawiera bazy danych Flexify.';

  @override
  String failedToImportGraphs(String error) {
    return 'Nie udało się zaimportować wykresów: $error';
  }

  @override
  String failedToImportPlans(String error) {
    return 'Nie udało się zaimportować planów: $error';
  }

  @override
  String get selectedFileDoesNotExist => 'Wybrany plik nie istnieje';

  @override
  String get couldNotReadFileData => 'Nie udało się odczytać danych pliku';

  @override
  String get databaseImportWebUnsupported =>
      'Import bazy danych w przeglądarce wymaga ręcznej migracji danych. Wyeksportuj dane jako pliki CSV i zaimportuj je zamiast bazy danych.';

  @override
  String get csvFileEmpty => 'Plik CSV jest pusty';

  @override
  String get csvNeedsDataRow =>
      'Plik CSV musi zawierać co najmniej jeden wiersz danych';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return 'Wiersz $row ma za mało kolumn: $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return 'Nieprawidłowa wartość $field w wierszu $row: $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return 'Nieprawidłowy typ danych $field w wierszu $row: $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return 'Oczekiwano całkowitego identyfikatora planu, otrzymano \"$value\"';
  }

  @override
  String get unitLabel => 'Jednostka';

  @override
  String get kilogramsUnit => 'Kilogramy (kg)';

  @override
  String get poundsUnit => 'Funty (lb)';

  @override
  String get stoneUnit => 'Stone';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => 'Kilometry (km)';

  @override
  String get milesUnit => 'Mile (mi)';

  @override
  String get metersUnit => 'Metry (m)';

  @override
  String get kilocaloriesUnit => 'Kilokalorie (kcal)';

  @override
  String get enterWeight => 'Wprowadź ciężar';

  @override
  String get requiredField => 'Wymagane';

  @override
  String get invalidNumber => 'Nieprawidłowa liczba';

  @override
  String get previousWeight => 'Poprzedni ciężar';

  @override
  String get imageLabel => 'Obraz';

  @override
  String get longPressToDelete => 'Przytrzymaj, aby usunąć';

  @override
  String get imageError => 'Błąd obrazu';

  @override
  String get actionSave => 'Zapisz';

  @override
  String get aboutTitle => 'O aplikacji';

  @override
  String get donate => 'Wesprzyj';

  @override
  String get helpSupportProject => 'Pomóż wesprzeć ten projekt';

  @override
  String get whatsNewAbout => 'Co nowego?';

  @override
  String get whatsNewTitle => 'Co nowego?';

  @override
  String get seeReleaseNotes => 'Zobacz informacje o wydaniu';

  @override
  String get versionLabel => 'Wersja';

  @override
  String get authorLabel => 'Autor';

  @override
  String get privacyPolicy => 'Polityka prywatności';

  @override
  String get privacyPolicyDescription => 'Jak Flexify przetwarza Twoje dane';

  @override
  String get licenseLabel => 'Licencja';

  @override
  String get sourceCode => 'Kod źródłowy';

  @override
  String get sourceCodeDescription => 'Zobacz na GitHubie';

  @override
  String get leaveReview => 'Dodaj opinię';

  @override
  String get leaveReviewDescription => 'Oceń Flexify w Sklepie Play';

  @override
  String get reportBug => 'Zgłoś błąd';

  @override
  String get reportBugDescription => 'Utwórz zgłoszenie na GitHubie';

  @override
  String get failedMigrations => 'Nieudane migracje';

  @override
  String get errorMessageLabel => 'Komunikat błędu:';

  @override
  String get createIssue => 'Utwórz zgłoszenie';

  @override
  String get addExercise => 'Dodaj ćwiczenie';

  @override
  String get cardio => 'Cardio';

  @override
  String get strength => 'Siła';

  @override
  String get options => 'Opcje';

  @override
  String get periodDay => 'Dzień';

  @override
  String get periodWeek => 'Tydzień';

  @override
  String get periodMonth => 'Miesiąc';

  @override
  String get periodYear => 'Rok';

  @override
  String noDataFor(String name) {
    return 'Brak danych dla $name';
  }

  @override
  String get noDataYet => 'Brak danych';

  @override
  String get exerciseNotes => 'Notatki do ćwiczenia';

  @override
  String get notesForExercise => 'Notatki do tego ćwiczenia';

  @override
  String get useTimeBasedXAxis => 'Użyj osi X opartej na czasie';

  @override
  String updateAllNamed(String name) {
    return 'Zaktualizuj wszystkie $name';
  }

  @override
  String get newName => 'Nowa nazwa';

  @override
  String get restMinutes => 'Minuty odpoczynku';

  @override
  String get restSeconds => 'Sekundy odpoczynku';

  @override
  String get globalProgress => 'Postęp ogólny';

  @override
  String get curveLineGraphs => 'Wygładzone linie wykresów';

  @override
  String get curveLineGraphsDescription =>
      'Rysuj linie wykresów jako płynne krzywe';

  @override
  String noHistoryFor(String name) {
    return 'Brak historii dla $name';
  }

  @override
  String get cancelSelection => 'Anuluj zaznaczenie';

  @override
  String get editSelected => 'Edytuj zaznaczone';

  @override
  String get newExercise => 'Nowe ćwiczenie';

  @override
  String get noGraphsFound => 'Nie znaleziono wykresów';

  @override
  String get searchGraphs => 'Szukaj wykresów...';

  @override
  String get actionAdd => 'Dodaj';

  @override
  String get actionUpdate => 'Aktualizuj';

  @override
  String get hideGlobalProgress => 'Ukryj postęp ogólny';

  @override
  String get chartGroupedByCategory => 'Wykres pogrupowany według kategorii';

  @override
  String get noExercisesFound => 'Nie znaleziono ćwiczeń';

  @override
  String get savePlan => 'Zapisz plan';

  @override
  String get titleOptional => 'Tytuł (opcjonalnie)';

  @override
  String get searchExercises => 'Szukaj ćwiczeń...';

  @override
  String get warmupSets => 'Serie rozgrzewkowe';

  @override
  String get workingSetsMax => 'Serie robocze (maks.: 20)';

  @override
  String get actionUndo => 'Cofnij';

  @override
  String get actionSwap => 'Zamień';

  @override
  String get daily => 'Codziennie';

  @override
  String get weekly => 'Co tydzień';

  @override
  String get monthly => 'Co miesiąc';

  @override
  String get yearly => 'Co rok';

  @override
  String get unexpectedError => 'Coś poszło nie tak. Spróbuj ponownie.';

  @override
  String get loadingExercises => 'Ładowanie ćwiczeń...';

  @override
  String get noPlansYet => 'Brak planów';

  @override
  String get noMatchingPlans => 'Brak pasujących planów';

  @override
  String get newPlan => 'Nowy plan';

  @override
  String get searchPlans => 'Szukaj planów...';

  @override
  String get noExercisesYet => 'Brak ćwiczeń';

  @override
  String get editPlan => 'Edytuj plan';

  @override
  String get saveSet => 'Zapisz serię';

  @override
  String get minutesLabel => 'Minuty';

  @override
  String get minutesShort => 'min';

  @override
  String get secondsLabel => 'Sekundy';

  @override
  String get distanceLabel => 'Dystans';

  @override
  String get inclinePercent => 'Nachylenie %';

  @override
  String weightWithUnit(String unit) {
    return 'Ciężar ($unit)';
  }

  @override
  String get useBodyWeight => 'Użyj masy ciała';

  @override
  String get noWeightEnteredYet => 'Nie wprowadzono jeszcze ciężaru';

  @override
  String get notesLabel => 'Notatki';

  @override
  String get swapWorkout => 'Zamień trening';

  @override
  String get addSet => 'Dodaj serię';

  @override
  String get deleteSet => 'Usuń serię';

  @override
  String get oneRepMaxEstimate => '1RM (szacunek)';

  @override
  String get valueLabel => 'Wartość';

  @override
  String amountWithUnit(String unit) {
    return 'Wartość ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return 'Dystans ($unit)';
  }

  @override
  String get bodyWeightLabel => 'Masa ciała';

  @override
  String bodyWeightWithUnit(String unit) {
    return 'Masa ciała ($unit)';
  }

  @override
  String get categoryHelper => 'Wybierz istniejącą kategorię lub wpisz nową.';

  @override
  String get manageCategories => 'Zarządzaj kategoriami';

  @override
  String get manageCategoriesDescription =>
      'Twórz, zmieniaj nazwy, łącz lub usuwaj kategorie';

  @override
  String get newCategory => 'Nowa kategoria';

  @override
  String get renameCategory => 'Zmień nazwę kategorii';

  @override
  String get mergeCategory => 'Połącz z inną kategorią';

  @override
  String get noCategories => 'Brak kategorii';

  @override
  String get categoryNameRequired => 'Wpisz nazwę kategorii';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Używana przez $count wpisu',
      many: 'Używana przez $count wpisów',
      few: 'Używana przez $count wpisy',
      one: 'Używana przez $count wpis',
      zero: 'Nie jest używana przez żaden wpis',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Usunąć tę kategorię i usunąć ją z $count wpisu?',
      many: 'Usunąć tę kategorię i usunąć ją z $count wpisów?',
      few: 'Usunąć tę kategorię i usunąć ją z $count wpisów?',
      one: 'Usunąć tę kategorię i usunąć ją z $count wpisu?',
      zero: 'Usunąć tę kategorię?',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => 'Data utworzenia';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Edytuj $count serii',
      many: 'Edytuj $count serii',
      few: 'Edytuj $count serie',
      one: 'Edytuj 1 serię',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => 'Brak wpisów';

  @override
  String get historyEmptyMessage =>
      'Ukończ serię lub dodaj ją ręcznie, aby rozpocząć historię.';

  @override
  String deleteSetConfirmation(String name) {
    return 'Czy na pewno chcesz usunąć $name?';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Czy na pewno chcesz usunąć $count wpisu?',
      many: 'Czy na pewno chcesz usunąć $count wpisów?',
      few: 'Czy na pewno chcesz usunąć $count wpisy?',
      one: 'Czy na pewno chcesz usunąć 1 wpis?',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => 'Szukaj w historii...';

  @override
  String get themeSystem => 'Systemowy';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get themeLight => 'Jasny';

  @override
  String get pureBlackAmoled => 'Czysta czerń (AMOLED)';

  @override
  String get showImages => 'Pokaż obrazy';

  @override
  String get peekGraph => 'Podgląd wykresu';

  @override
  String get inputStyleLine => 'Linia';

  @override
  String get inputStyleOutlined => 'Obrys';

  @override
  String get inputStyleFilled => 'Wypełnione';

  @override
  String get inputStyle => 'Styl pól';

  @override
  String get appearance => 'Wygląd';

  @override
  String get automaticBackupsEnabled => 'Automatyczne kopie zapasowe włączone';

  @override
  String get automaticBackup => 'Automatyczna kopia zapasowa';

  @override
  String get appPermissions => 'Uprawnienia aplikacji';

  @override
  String get shareDatabase => 'Udostępnij bazę danych';

  @override
  String get dataManagement => 'Zarządzanie danymi';

  @override
  String get strengthUnit => 'Jednostka siły';

  @override
  String get lastEntry => 'Ostatni wpis';

  @override
  String get cardioUnit => 'Jednostka cardio';

  @override
  String longDateFormat(String format) {
    return 'Długi format daty ($format)';
  }

  @override
  String get formats => 'Formaty';

  @override
  String get setsPerExerciseMax => 'Serie na ćwiczenie (maks.: 20)';

  @override
  String get countLabel => 'Liczba';

  @override
  String get ratioLabel => 'Stosunek';

  @override
  String get reorder => 'Zmień kolejność';

  @override
  String get none => 'Brak';

  @override
  String get monday => 'Poniedziałek';

  @override
  String get examplePlanExercises =>
      'Wyciskanie na ławce, Przysiad, Martwy ciąg';

  @override
  String get tabs => 'Karty';

  @override
  String get swipeBetweenTabs => 'Przesuwaj między kartami';

  @override
  String get vibrate => 'Wibracje';

  @override
  String get enableSound => 'Włącz dźwięk';

  @override
  String get keepScreenOn => 'Nie wyłączaj ekranu';

  @override
  String get alarmSound => 'Dźwięk alarmu';

  @override
  String get top => 'Góra';

  @override
  String get bottom => 'Dół';

  @override
  String get removeCustomTimer =>
      'Usuń niestandardowy minutnik (użyj domyślnego globalnego)';

  @override
  String get timers => 'Minutniki';

  @override
  String get timerSettings => 'Ustawienia minutnika';

  @override
  String get groupHistory => 'Grupuj historię';

  @override
  String get showUnits => 'Pokaż jednostki';

  @override
  String get showBodyWeight => 'Pokaż masę ciała';

  @override
  String get showCategories => 'Pokaż kategorie';

  @override
  String get showNotes => 'Pokaż notatki';

  @override
  String get repEstimation => 'Szacowanie powtórzeń';

  @override
  String get durationEstimation => 'Szacowanie czasu trwania';

  @override
  String get showGraphLimit => 'Pokaż limit wykresu';

  @override
  String get defaultGraphMetric => 'Domyślna metryka wykresu';

  @override
  String get bestWeight => 'Największy ciężar';

  @override
  String get bestReps => 'Najwięcej powtórzeń';

  @override
  String get oneRepMax => '1RM';

  @override
  String get volume => 'Objętość';

  @override
  String get paceCardio => 'Tempo (cardio)';

  @override
  String get distanceCardio => 'Dystans (cardio)';

  @override
  String get defaultGraphPeriod => 'Domyślny okres wykresu';

  @override
  String get defaultGraphLimit => 'Domyślny limit wykresu';

  @override
  String get workouts => 'Treningi';

  @override
  String get actionStop => 'Zatrzymaj';

  @override
  String get timerFinishedToast => 'Minutnik zakończony!';

  @override
  String get stopTimer => 'Zatrzymaj minutnik';

  @override
  String get actionPause => 'Wstrzymaj';

  @override
  String get startStopwatch => 'Uruchom stoper';

  @override
  String get actionStart => 'Start';

  @override
  String get actionRestart => 'Uruchom ponownie';

  @override
  String get addOneMinute => '+1 minuta';

  @override
  String get addOneMinuteNotification => 'Dodaj 1 min';

  @override
  String get restTimer => 'Minutnik odpoczynku';

  @override
  String get timerUp => 'Czas minął';

  @override
  String get openNotification => 'Otwórz powiadomienie';

  @override
  String get timerChannelName => 'Kanał minutnika';

  @override
  String get timerChannelDescription => 'Bieżący postęp minutników odpoczynku.';

  @override
  String get timerFinishedChannelName => 'Kanał zakończonego minutnika';

  @override
  String get timerFinishedChannelDescription =>
      'Odtwarza alarm po zakończeniu minutnika odpoczynku.';

  @override
  String get timerFinished => 'Minutnik zakończony';

  @override
  String get batteryOptimizationRequestUnavailable =>
      'Żądania ignorowania optymalizacji baterii są wyłączone na Twoim urządzeniu.';

  @override
  String get exactAlarmRequestUnavailable =>
      'Żądanie SCHEDULE_EXACT_ALARM zostało odrzucone na Twoim urządzeniu';

  @override
  String get databaseMigrationFailureDescription =>
      'Coś poszło nie tak podczas tworzenia lub aktualizowania bazy danych. Zwykle można to naprawić, usuwając i ponownie tworząc rekordy.';

  @override
  String get curveSmoothness => 'Gładkość krzywych';

  @override
  String get actionBack => 'Wstecz';

  @override
  String get atLeastOneTab => 'Potrzebujesz co najmniej jednej karty';

  @override
  String get invalidTabSettings => 'Nieprawidłowe ustawienia kart.';

  @override
  String get noSettingsFound => 'Nie znaleziono ustawień';

  @override
  String nothingMatchesSearch(String query) {
    return 'Brak wyników dla „$query”.';
  }

  @override
  String get appearanceDescription => 'Motyw, kolory i wygląd interfejsu';

  @override
  String get dataManagementDescription =>
      'Importuj, eksportuj i zarządzaj danymi treningowymi';

  @override
  String get formatsDescription => 'Formatowanie dat, liczb i jednostek';

  @override
  String get plansSettingsDescription =>
      'Domyślne ustawienia i zachowanie planów treningowych';

  @override
  String get tabsDescription => 'Wybierz i uporządkuj główne karty nawigacji';

  @override
  String get timersDescription =>
      'Czas, dźwięk i zachowanie minutników odpoczynku';

  @override
  String get workoutsDescription =>
      'Śledzenie ćwiczeń i preferencje treningowe';

  @override
  String get completeSetForChart =>
      'Ukończ serię tego ćwiczenia, aby utworzyć wykres.';

  @override
  String get dateRange => 'Zakres dat';

  @override
  String get stopDate => 'Data końcowa';

  @override
  String get dataPoints => 'Punkty danych';

  @override
  String get completeSetsForProgress =>
      'Ukończ kilka serii, aby utworzyć wykres postępu.';

  @override
  String get relativeStrength => 'Siła względna';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wybrano $count',
      many: 'Wybrano $count',
      few: 'Wybrano $count',
      one: 'Wybrano 1',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory =>
      'Ukończ kilka serii, aby zobaczyć tutaj historię tego ćwiczenia.';

  @override
  String get completeSetForFirstGraph =>
      'Ukończ serię, aby utworzyć pierwszy wykres ćwiczenia.';

  @override
  String nothingMatchesGraphSearch(String query) {
    return 'Brak wyników dla „$query”. Możesz utworzyć to jako nowe ćwiczenie.';
  }

  @override
  String addNamed(String name) {
    return 'Dodaj „$name”';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return 'Spowoduje to usunięcie $count rekordów. Czy na pewno?';
  }

  @override
  String shareWorkout(String summary) {
    return 'Właśnie zrobiłem $summary';
  }

  @override
  String get updateConflict => 'Konflikt aktualizacji';

  @override
  String updateConflictDescription(int count) {
    return 'Nowa nazwa już istnieje dla $count rekordów. Czy na pewno chcesz kontynuować?';
  }

  @override
  String get unitsConflict => 'Konflikt jednostek';

  @override
  String unitsConflictDescription(String unit) {
    return 'Nie wszystkie rekordy mają tę samą jednostkę. Wszystkie jednostki zostaną przeliczone na $unit. Czy na pewno chcesz kontynuować?';
  }

  @override
  String get durationLabel => 'Czas trwania';

  @override
  String get inclineLabel => 'Nachylenie';

  @override
  String get paceDistanceTime => 'Tempo (dystans / czas)';

  @override
  String get adjustedPace => 'Skorygowane tempo';

  @override
  String get oneRepMaxAccuracyWarning =>
      'Szacunki 1RM są mniej dokładne dla serii po 10 lub więcej powtórzeń';

  @override
  String get addPlan => 'Dodaj plan';

  @override
  String get planDetails => 'Szczegóły planu';

  @override
  String get exercisesLabel => 'Ćwiczenia';

  @override
  String get addExerciseToPlan => 'Dodaj ćwiczenie do tego planu.';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return 'Brak wyników dla „$query”. Możesz dodać to jako nowe ćwiczenie.';
  }

  @override
  String get selectDays => 'Wybierz dni';

  @override
  String get selectExercises => 'Wybierz ćwiczenia';

  @override
  String get todayLabel => 'Dzisiaj';

  @override
  String get setDetails => 'Szczegóły serii';

  @override
  String get themeLabel => 'Motyw';

  @override
  String get pureBlackAmoledDescription =>
      'Używaj czystej czerni na ekranach AMOLED';

  @override
  String get systemColorScheme => 'Systemowy schemat kolorów';

  @override
  String get systemColorSchemeDescription =>
      'Używaj w aplikacji głównego koloru urządzenia';

  @override
  String get showImagesDescription =>
      'Wybieraj i wyświetlaj obrazy na stronie historii';

  @override
  String get showGlobalProgress => 'Pokaż postęp ogólny';

  @override
  String get showGlobalProgressDescription =>
      'Dodaj do wykresu wpis pokazujący postęp według kategorii';

  @override
  String get peekGraphDescription =>
      'Pokaż pierwszy wykres liniowy na stronie wykresów';

  @override
  String get inputStyleDescription => 'Wygląd pól tekstowych';

  @override
  String get automaticBackupNotificationBody =>
      'Flexify będzie codziennie automatycznie tworzyć kopię zapasową danych i obrazów w wybranym folderze.';

  @override
  String get backupSettingsChannel => 'Ustawienia kopii zapasowej';

  @override
  String get backupSettingsChannelDescription =>
      'Powiadomienia objaśniające automatyczne kopie zapasowe';

  @override
  String get backupChannelName => 'Kanał kopii zapasowej';

  @override
  String get backupChannelDescription =>
      'Automatyczne kopie zapasowe danych i obrazów Flexify';

  @override
  String get backupCompletedTitle =>
      'Utworzono kopię zapasową danych i obrazów';

  @override
  String get backupFailurePathNotSet =>
      'Kopia zapasowa nie powiodła się: nie ustawiono lokalizacji. Automatyczne kopie zapasowe wyłączone.';

  @override
  String get backupFailureDirectoryUnavailable =>
      'Kopia zapasowa nie powiodła się: brak dostępu do folderu kopii zapasowej. Automatyczne kopie zapasowe wyłączone.';

  @override
  String get backupFailureCreateFile =>
      'Kopia zapasowa nie powiodła się: nie udało się utworzyć pliku. Automatyczne kopie zapasowe wyłączone.';

  @override
  String get backupFailureAppFilesUnavailable =>
      'Kopia zapasowa nie powiodła się: brak dostępu do folderu plików aplikacji. Automatyczne kopie zapasowe wyłączone.';

  @override
  String get backupFailureDatabaseMissing =>
      'Kopia zapasowa nie powiodła się: nie znaleziono pliku bazy danych. Automatyczne kopie zapasowe wyłączone.';

  @override
  String get backupFailureOutputUnavailable =>
      'Kopia zapasowa nie powiodła się: nie udało się otworzyć strumienia wyjściowego. Automatyczne kopie zapasowe wyłączone.';

  @override
  String get backupFailureUnknown =>
      'Kopia zapasowa nie powiodła się. Automatyczne kopie zapasowe wyłączone.';

  @override
  String get appPermissionsDescription =>
      'Sprawdź dostęp wymagany przez włączone funkcje';

  @override
  String get longDateFormatDescription =>
      'Używany tam, gdzie jest dużo miejsca';

  @override
  String shortDateFormat(String example) {
    return 'Krótki format daty ($example)';
  }

  @override
  String get shortDateFormatDescription =>
      'Do miejsc z małą ilością miejsca (linie wykresów)';

  @override
  String get warmupSetsDescription =>
      'Serie rozgrzewkowe nie uruchamiają minutników odpoczynku';

  @override
  String get setsPerExerciseDescription => 'Domyślna liczba ćwiczeń w planie';

  @override
  String get planTrailingDisplay => 'Informacja po prawej stronie planu';

  @override
  String get planTrailingDisplayDescription =>
      'Zawartość po prawej stronie listy w widokach Plany i Plan';

  @override
  String get restTimersDescription => 'Alarm uruchamiany po ukończeniu serii';

  @override
  String get vibrateDescription => 'Czy minutniki odpoczynku mają wibrować?';

  @override
  String get enableSoundDescription =>
      'Czy minutniki odpoczynku mają odtwarzać dźwięk?';

  @override
  String get keepScreenOnDescription =>
      'Nie wyłączaj ekranu podczas działania minutników odpoczynku';

  @override
  String get restDurationDescription =>
      'Po jakim czasie mają uruchamiać się alarmy odpoczynku?';

  @override
  String get globalDefault => 'Domyślne globalne';

  @override
  String get alarmSoundDescription =>
      'Muzyka odtwarzana po zakończeniu minutnika odpoczynku';

  @override
  String get progressBarPosition => 'Położenie paska postępu';

  @override
  String get progressBarPositionDescription =>
      'Gdzie ma być umieszczony pasek postępu minutników odpoczynku?';

  @override
  String get perExerciseRestTimes => 'Czas odpoczynku dla ćwiczeń';

  @override
  String get perExerciseRestTimesDescription =>
      'Te ćwiczenia mają niestandardowy czas odpoczynku';

  @override
  String get audioFeaturesUnavailable => 'Funkcje audio są niedostępne';

  @override
  String get groupHistoryDescription => 'Łącz wpisy historii według dnia';

  @override
  String get showUnitsDescription =>
      'Pokaż km/mi oraz kg/lb na wykresach, w historii i planach';

  @override
  String get showBodyWeightDescription =>
      'Włącz lub wyłącz śledzenie masy ciała';

  @override
  String get showCategoriesDescription =>
      'Włącz lub wyłącz kategorie treningowe';

  @override
  String get showNotesDescription =>
      'Zapisuj szczegóły ćwiczenia w polu tekstowym';

  @override
  String get positiveNotificationsDescription =>
      'Wyświetlaj motywujące wiadomości po ustanowieniu nowego rekordu';

  @override
  String get positiveMessagesEnabled =>
      'Pozytywne wiadomości wyglądają teraz tak!';

  @override
  String get recordEncouragement01 => 'Świetna robota! Jesteś niesamowity.';

  @override
  String get recordEncouragement02 =>
      'Dobra robota, królu! Twój postęp inspiruje.';

  @override
  String get recordEncouragement03 => 'Klękam...';

  @override
  String get recordEncouragement04 => 'Co to? Nowy rekord!';

  @override
  String get recordEncouragement05 => 'Niesamowite! Inspirujesz.';

  @override
  String get recordEncouragement06 => 'Wow. Pięknie.';

  @override
  String get recordEncouragement07 => 'Ale rośnie siła, co?';

  @override
  String get recordEncouragement08 => 'Tak. Robisz się naprawdę duży.';

  @override
  String get recordEncouragement09 => 'Niesamowite. Rewelacja.';

  @override
  String get recordEncouragement10 => 'Arnie byłby dumny.';

  @override
  String get recordEncouragement11 => 'Ronnie C patrzy na Ciebie z radością.';

  @override
  String get recordEncouragement12 => 'TAK! LEKKI CIĘŻAR, DZIECIAKU!!!!!!!';

  @override
  String get recordEncouragement13 =>
      'Czy to nowy rekord? Wiedziałem, że dasz radę.';

  @override
  String get recordEncouragement14 => 'Świetna robota! Jestem z Ciebie dumny.';

  @override
  String get recordEncouragement15 => 'Tak jest! Lekki ciężar!';

  @override
  String get recordEncouragement16 => 'Tak trzymaj! Świetny postęp.';

  @override
  String get recordEncouragement17 => 'Idzie Ci naprawdę świetnie.';

  @override
  String get recordEncouragement18 => 'To mój chłopak!';

  @override
  String get recordEncouragement19 => 'Tak trzymaj.';

  @override
  String get recordEncouragement20 => 'Robisz się naprawdę silny.';

  @override
  String get recordEncouragement21 => 'Potężnie.';

  @override
  String get recordEncouragement22 => 'Ale moc!';

  @override
  String get recordEncouragement23 => 'Jestem z Ciebie dumny.';

  @override
  String get recordEncouragement24 => 'Tak trzymaj, świetna robota.';

  @override
  String get recordEncouragement25 =>
      'Głowa do góry! Właśnie ustanowiłeś nowy rekord.';

  @override
  String get recordEncouragement26 =>
      'Nowy rekord! Poszedłeś dalej niż kiedykolwiek!';

  @override
  String get recordEncouragement27 => 'Tak! To rekord.';

  @override
  String get recordEncouragement28 => 'Wow! Nowy rekord!';

  @override
  String get recordEncouragement29 => 'Naprawdę świetnie.';

  @override
  String get repEstimationDescription =>
      'Spróbuj przewidzieć liczbę właśnie wykonanych powtórzeń';

  @override
  String get durationEstimationDescription =>
      'Spróbuj przewidzieć czas trwania cardio';

  @override
  String get showGraphXAxisToggle => 'Pokaż przełącznik osi X wykresu';

  @override
  String get showGraphXAxisToggleDescription =>
      'Pokaż na wykresach przełącznik osi X opartej na czasie';

  @override
  String get showGraphLimitDescription => 'Pokaż suwak limitu na wykresach';

  @override
  String get defaultTimeBasedXAxis => 'Domyślnie oś X oparta na czasie';

  @override
  String get defaultTimeBasedXAxisDescription =>
      'Domyślnie używaj na wykresach osi X opartej na czasie';

  @override
  String get createFirstTrainingPlan =>
      'Utwórz pierwszy plan treningowy, aby zacząć.';

  @override
  String nothingMatchesPlanSearch(String query) {
    return 'Brak wyników dla „$query”. Możesz utworzyć to jako nowy plan.';
  }

  @override
  String get createPlan => 'Utwórz plan';

  @override
  String createNamedPlan(String name) {
    return 'Utwórz „$name”';
  }

  @override
  String setNumber(int number) {
    return 'Seria $number';
  }
}
