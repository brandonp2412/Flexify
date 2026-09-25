// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => 'Taal';

  @override
  String get settingsLanguageDescription => 'Kies de taal die Flexify gebruikt';

  @override
  String get languageSystemDefault => 'Systeemstandaard';

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
  String get navHistory => 'Geschiedenis';

  @override
  String get navPlans => 'Schema\'s';

  @override
  String get navGraphs => 'Grafieken';

  @override
  String get navTimer => 'Timer';

  @override
  String get navSettings => 'Instellingen';

  @override
  String get errorLabel => 'Fout';

  @override
  String get tabContentError =>
      'De inhoud van het tabblad kon niet worden weergegeven.';

  @override
  String get cannotHideAllTabs => 'Je kunt niet alles verbergen!';

  @override
  String removeTabQuestion(String tab) {
    return 'Tabblad $tab verwijderen?';
  }

  @override
  String get restoreTabFromSettings =>
      'Je kunt het later weer toevoegen via de instellingen.';

  @override
  String removedTab(String tab) {
    return '$tab verwijderd';
  }

  @override
  String newVersion(String version) {
    return 'Nieuwe versie $version';
  }

  @override
  String get changes => 'Wijzigingen';

  @override
  String get searchHint => 'Zoeken...';

  @override
  String get deleteSelected => 'Selectie verwijderen';

  @override
  String get confirmDelete => 'Verwijderen bevestigen';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Weet je zeker dat je $count records wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt.',
      one:
          'Weet je zeker dat je 1 record wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt.',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'Annuleren';

  @override
  String get actionDelete => 'Verwijderen';

  @override
  String get actionRemove => 'Verwijderen';

  @override
  String get actionEdit => 'Bewerken';

  @override
  String get actionShare => 'Delen';

  @override
  String get clearSelection => 'Selectie wissen';

  @override
  String get clearSearch => 'Zoekopdracht wissen';

  @override
  String get showMenu => 'Menu tonen';

  @override
  String get selectAll => 'Alles selecteren';

  @override
  String get weightLabel => 'Gewicht';

  @override
  String get filter => 'Filter';

  @override
  String get filters => 'Filters';

  @override
  String get categoryLabel => 'Categorie';

  @override
  String get repsLabel => 'Herhalingen';

  @override
  String get repsFilter => 'Herhalingsfilter';

  @override
  String get weightFilter => 'Gewichtsfilter';

  @override
  String get greaterThan => 'Groter dan';

  @override
  String get lessThan => 'Kleiner dan';

  @override
  String get startDate => 'Begindatum';

  @override
  String get endDate => 'Einddatum';

  @override
  String get actionClear => 'Wissen';

  @override
  String get actionOk => 'OK';

  @override
  String get actionClose => 'Sluiten';

  @override
  String get sortBy => 'Sorteren op';

  @override
  String get dateNewest => 'Datum (nieuwste)';

  @override
  String get dateOldest => 'Datum (oudste)';

  @override
  String get nameLabel => 'Naam';

  @override
  String get missingPermissions => 'Ontbrekende machtigingen';

  @override
  String get restTimersPermissionsMissing =>
      'Rusttimers zijn ingeschakeld, maar er ontbreken machtigingen.';

  @override
  String get restTimersPermissionsOptional =>
      'Als je rusttimers uitschakelt, zijn deze machtigingen niet nodig.';

  @override
  String get restTimers => 'Rusttimers';

  @override
  String get disableBatteryOptimizations =>
      'Batterijoptimalisatie uitschakelen';

  @override
  String get batteryOptimizationWarning =>
      'De voortgang kan pauzeren als batterijoptimalisatie ingeschakeld blijft.';

  @override
  String get scheduleExactAlarm => 'Exact alarm plannen';

  @override
  String get exactAlarmWarning =>
      'Alarmen kunnen niet nauwkeurig zijn als dit is uitgeschakeld.';

  @override
  String get postNotifications => 'Meldingen weergeven';

  @override
  String get notificationBarDescription =>
      'De voortgang van de timer wordt in de meldingsbalk weergegeven';

  @override
  String get invalidPermissions => 'Ongeldige machtigingen';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      'Rusttimers zijn ingeschakeld zonder voldoende machtigingen. Weet je het zeker?';

  @override
  String get actionConfirm => 'Bevestigen';

  @override
  String get appAccess => 'App-toegang';

  @override
  String get appAccessDescription =>
      'Nodig voor ingeschakelde timers en meldingen.';

  @override
  String get notifications => 'Meldingen';

  @override
  String get timerProgressAndRestAlerts => 'Timervoortgang en rustmeldingen';

  @override
  String get enabledNotificationsDescription =>
      'Meldingen die je hebt ingeschakeld';

  @override
  String get backgroundActivity => 'Achtergrondactiviteit';

  @override
  String get backgroundActivityDescription =>
      'Houd timers betrouwbaar actief op de achtergrond';

  @override
  String get exactAlarms => 'Exacte alarmen';

  @override
  String get exactAlarmsDescription =>
      'Meld precies wanneer een rusttimer afloopt';

  @override
  String get noAdditionalAndroidAccessNeeded =>
      'Voor je huidige instellingen is geen extra Android-toegang nodig.';

  @override
  String get actionDone => 'Klaar';

  @override
  String get allowed => 'Toegestaan';

  @override
  String get actionAllow => 'Toestaan';

  @override
  String get backupLabel => 'Back-up';

  @override
  String get databaseLabel => 'Database';

  @override
  String get deleteRecords => 'Records verwijderen';

  @override
  String get deleteAllGraphsConfirmation =>
      'Weet je zeker dat je alle grafieken wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get deleteAllPlansConfirmation =>
      'Weet je zeker dat je alle schema\'s wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get deleteDatabaseConfirmation =>
      'Weet je zeker dat je je database wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt en verwijdert al je gegevens.';

  @override
  String get importData => 'Gegevens importeren';

  @override
  String get exportData => 'Gegevens exporteren';

  @override
  String get actionReport => 'Rapporteren';

  @override
  String get graphDataImported => 'Grafiekgegevens zijn geïmporteerd!';

  @override
  String get plansImported => 'Schema\'s zijn geïmporteerd';

  @override
  String failedToImportDatabase(String error) {
    return 'Database importeren mislukt: $error';
  }

  @override
  String get backupArchiveMissingDatabase =>
      'De back-up bevat de Flexify-database niet.';

  @override
  String failedToImportGraphs(String error) {
    return 'Grafieken importeren mislukt: $error';
  }

  @override
  String failedToImportPlans(String error) {
    return 'Schema\'s importeren mislukt: $error';
  }

  @override
  String get selectedFileDoesNotExist =>
      'Het geselecteerde bestand bestaat niet';

  @override
  String get couldNotReadFileData =>
      'De bestandsgegevens konden niet worden gelezen';

  @override
  String get databaseImportWebUnsupported =>
      'Voor database-import op het web is handmatige gegevensmigratie nodig. Exporteer je gegevens als CSV-bestanden en importeer die in plaats daarvan.';

  @override
  String get csvFileEmpty => 'Het CSV-bestand is leeg';

  @override
  String get csvNeedsDataRow =>
      'Het CSV-bestand moet minstens één gegevensrij bevatten';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return 'Rij $row heeft te weinig kolommen: $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return 'Ongeldige waarde voor $field in rij $row: $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return 'Ongeldig gegevenstype voor $field in rij $row: $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return 'Een geheel getal als schema-ID verwacht, ontvangen: \"$value\"';
  }

  @override
  String get unitLabel => 'Eenheid';

  @override
  String get kilogramsUnit => 'Kilogram (kg)';

  @override
  String get poundsUnit => 'Pond (lb)';

  @override
  String get stoneUnit => 'Stone';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => 'Kilometer (km)';

  @override
  String get milesUnit => 'Mijl (mi)';

  @override
  String get metersUnit => 'Meter (m)';

  @override
  String get kilocaloriesUnit => 'Kilocalorieën (kcal)';

  @override
  String get enterWeight => 'Gewicht invoeren';

  @override
  String get requiredField => 'Verplicht';

  @override
  String get invalidNumber => 'Ongeldig getal';

  @override
  String get previousWeight => 'Vorig gewicht';

  @override
  String get imageLabel => 'Afbeelding';

  @override
  String get longPressToDelete => 'Houd ingedrukt om te verwijderen';

  @override
  String get imageError => 'Afbeeldingsfout';

  @override
  String get actionSave => 'Opslaan';

  @override
  String get aboutTitle => 'Over';

  @override
  String get donate => 'Doneren';

  @override
  String get helpSupportProject => 'Help dit project te steunen';

  @override
  String get whatsNewAbout => 'Wat is er nieuw?';

  @override
  String get whatsNewTitle => 'Wat is er nieuw?';

  @override
  String get seeReleaseNotes => 'Bekijk onze release-opmerkingen';

  @override
  String get versionLabel => 'Versie';

  @override
  String get authorLabel => 'Auteur';

  @override
  String get privacyPolicy => 'Privacybeleid';

  @override
  String get privacyPolicyDescription => 'Hoe Flexify met je gegevens omgaat';

  @override
  String get licenseLabel => 'Licentie';

  @override
  String get sourceCode => 'Broncode';

  @override
  String get sourceCodeDescription => 'Bekijk het op GitHub';

  @override
  String get leaveReview => 'Beoordeling achterlaten';

  @override
  String get leaveReviewDescription => 'Beoordeel Flexify in de Play Store';

  @override
  String get reportBug => 'Bug melden';

  @override
  String get reportBugDescription => 'Open een ticket op GitHub';

  @override
  String get failedMigrations => 'Mislukte migraties';

  @override
  String get errorMessageLabel => 'Foutmelding:';

  @override
  String get createIssue => 'Issue aanmaken';

  @override
  String get addExercise => 'Oefening toevoegen';

  @override
  String get cardio => 'Cardio';

  @override
  String get strength => 'Kracht';

  @override
  String get options => 'Opties';

  @override
  String get periodDay => 'Dag';

  @override
  String get periodWeek => 'Week';

  @override
  String get periodMonth => 'Maand';

  @override
  String get periodYear => 'Jaar';

  @override
  String noDataFor(String name) {
    return 'Nog geen gegevens voor $name';
  }

  @override
  String get noDataYet => 'Nog geen gegevens';

  @override
  String get exerciseNotes => 'Oefeningsnotities';

  @override
  String get notesForExercise => 'Notities voor deze oefening';

  @override
  String get useTimeBasedXAxis => 'Tijdgebaseerde X-as gebruiken';

  @override
  String updateAllNamed(String name) {
    return 'Alle $name bijwerken';
  }

  @override
  String get newName => 'Nieuwe naam';

  @override
  String get restMinutes => 'Rustminuten';

  @override
  String get restSeconds => 'Rustseconden';

  @override
  String get globalProgress => 'Algemene voortgang';

  @override
  String get curveLineGraphs => 'Gebogen grafieklijnen';

  @override
  String get curveLineGraphsDescription =>
      'Teken grafieklijnen als vloeiende krommen';

  @override
  String noHistoryFor(String name) {
    return 'Nog geen geschiedenis voor $name';
  }

  @override
  String get cancelSelection => 'Selectie annuleren';

  @override
  String get editSelected => 'Selectie bewerken';

  @override
  String get newExercise => 'Nieuwe oefening';

  @override
  String get noGraphsFound => 'Geen grafieken gevonden';

  @override
  String get searchGraphs => 'Grafieken zoeken...';

  @override
  String get actionAdd => 'Toevoegen';

  @override
  String get actionUpdate => 'Bijwerken';

  @override
  String get hideGlobalProgress => 'Algemene voortgang verbergen';

  @override
  String get chartGroupedByCategory => 'Een grafiek gegroepeerd op categorie';

  @override
  String get noExercisesFound => 'Geen oefeningen gevonden';

  @override
  String get savePlan => 'Schema opslaan';

  @override
  String get titleOptional => 'Titel (optioneel)';

  @override
  String get searchExercises => 'Oefeningen zoeken...';

  @override
  String get warmupSets => 'Opwarmsets';

  @override
  String get workingSetsMax => 'Werksets (max.: 20)';

  @override
  String get actionUndo => 'Ongedaan maken';

  @override
  String get actionSwap => 'Wisselen';

  @override
  String get daily => 'Dagelijks';

  @override
  String get weekly => 'Wekelijks';

  @override
  String get monthly => 'Maandelijks';

  @override
  String get yearly => 'Jaarlijks';

  @override
  String get unexpectedError => 'Er is iets misgegaan. Probeer het opnieuw.';

  @override
  String get loadingExercises => 'Oefeningen laden...';

  @override
  String get noPlansYet => 'Nog geen schema\'s';

  @override
  String get noMatchingPlans => 'Geen overeenkomende schema\'s';

  @override
  String get newPlan => 'Nieuw schema';

  @override
  String get searchPlans => 'Schema\'s zoeken...';

  @override
  String get noExercisesYet => 'Nog geen oefeningen';

  @override
  String get editPlan => 'Schema bewerken';

  @override
  String get saveSet => 'Set opslaan';

  @override
  String get minutesLabel => 'Minuten';

  @override
  String get minutesShort => 'min';

  @override
  String get secondsLabel => 'Seconden';

  @override
  String get distanceLabel => 'Afstand';

  @override
  String get inclinePercent => 'Helling %';

  @override
  String weightWithUnit(String unit) {
    return 'Gewicht ($unit)';
  }

  @override
  String get useBodyWeight => 'Lichaamsgewicht gebruiken';

  @override
  String get noWeightEnteredYet => 'Nog geen gewicht ingevoerd';

  @override
  String get notesLabel => 'Notities';

  @override
  String get swapWorkout => 'Training wisselen';

  @override
  String get addSet => 'Set toevoegen';

  @override
  String get deleteSet => 'Set verwijderen';

  @override
  String get oneRepMaxEstimate => '1RM (schatting)';

  @override
  String get valueLabel => 'Waarde';

  @override
  String amountWithUnit(String unit) {
    return 'Hoeveelheid ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return 'Afstand ($unit)';
  }

  @override
  String get bodyWeightLabel => 'Lichaamsgewicht';

  @override
  String bodyWeightWithUnit(String unit) {
    return 'Lichaamsgewicht ($unit)';
  }

  @override
  String get categoryHelper =>
      'Kies een bestaande categorie of typ een nieuwe.';

  @override
  String get manageCategories => 'Categorieën beheren';

  @override
  String get manageCategoriesDescription =>
      'Categorieën maken, hernoemen, samenvoegen of verwijderen';

  @override
  String get newCategory => 'Nieuwe categorie';

  @override
  String get renameCategory => 'Categorie hernoemen';

  @override
  String get mergeCategory => 'Samenvoegen met een andere categorie';

  @override
  String get noCategories => 'Nog geen categorieën';

  @override
  String get categoryNameRequired => 'Voer een categorienaam in';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wordt door $count items gebruikt',
      one: 'Wordt door 1 item gebruikt',
      zero: 'Wordt door geen items gebruikt',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Deze categorie verwijderen en bij $count items weghalen?',
      one: 'Deze categorie verwijderen en bij 1 item weghalen?',
      zero: 'Deze categorie verwijderen?',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => 'Aanmaakdatum';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sets bewerken',
      one: '1 set bewerken',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => 'Nog geen items';

  @override
  String get historyEmptyMessage =>
      'Voltooi een set of voeg er handmatig een toe om je geschiedenis te starten.';

  @override
  String deleteSetConfirmation(String name) {
    return 'Weet je zeker dat je $name wilt verwijderen?';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Weet je zeker dat je $count items wilt verwijderen?',
      one: 'Weet je zeker dat je 1 item wilt verwijderen?',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => 'Geschiedenis zoeken...';

  @override
  String get themeSystem => 'Systeem';

  @override
  String get themeDark => 'Donker';

  @override
  String get themeLight => 'Licht';

  @override
  String get pureBlackAmoled => 'Puur zwart (AMOLED)';

  @override
  String get showImages => 'Afbeeldingen tonen';

  @override
  String get peekGraph => 'Grafiekvoorbeeld';

  @override
  String get inputStyleLine => 'Lijn';

  @override
  String get inputStyleOutlined => 'Omlijnd';

  @override
  String get inputStyleFilled => 'Ingevuld';

  @override
  String get inputStyle => 'Invoerstijl';

  @override
  String get appearance => 'Uiterlijk';

  @override
  String get automaticBackupsEnabled => 'Automatische back-ups ingeschakeld';

  @override
  String get automaticBackup => 'Automatische back-up';

  @override
  String get appPermissions => 'App-machtigingen';

  @override
  String get shareDatabase => 'Database delen';

  @override
  String get dataManagement => 'Gegevensbeheer';

  @override
  String get strengthUnit => 'Krachteenheid';

  @override
  String get lastEntry => 'Laatste item';

  @override
  String get cardioUnit => 'Cardio-eenheid';

  @override
  String longDateFormat(String format) {
    return 'Lange datumnotatie ($format)';
  }

  @override
  String get formats => 'Notaties';

  @override
  String get setsPerExerciseMax => 'Sets per oefening (max.: 20)';

  @override
  String get countLabel => 'Aantal';

  @override
  String get ratioLabel => 'Verhouding';

  @override
  String get reorder => 'Volgorde wijzigen';

  @override
  String get none => 'Geen';

  @override
  String get monday => 'Maandag';

  @override
  String get examplePlanExercises => 'Bankdrukken, Squat, Deadlift';

  @override
  String get tabs => 'Tabbladen';

  @override
  String get swipeBetweenTabs => 'Tussen tabbladen vegen';

  @override
  String get vibrate => 'Trillen';

  @override
  String get enableSound => 'Geluid inschakelen';

  @override
  String get keepScreenOn => 'Scherm aanhouden';

  @override
  String get alarmSound => 'Alarmgeluid';

  @override
  String get top => 'Boven';

  @override
  String get bottom => 'Onder';

  @override
  String get removeCustomTimer =>
      'Aangepaste timer verwijderen (algemene standaard gebruiken)';

  @override
  String get timers => 'Timers';

  @override
  String get timerSettings => 'Timerinstellingen';

  @override
  String get groupHistory => 'Geschiedenis groeperen';

  @override
  String get showUnits => 'Eenheden tonen';

  @override
  String get showBodyWeight => 'Lichaamsgewicht tonen';

  @override
  String get showCategories => 'Categorieën tonen';

  @override
  String get showNotes => 'Notities tonen';

  @override
  String get repEstimation => 'Herhalingen schatten';

  @override
  String get durationEstimation => 'Duur schatten';

  @override
  String get showGraphLimit => 'Grafieklimiet tonen';

  @override
  String get defaultGraphMetric => 'Standaard grafiekmeting';

  @override
  String get bestWeight => 'Hoogste gewicht';

  @override
  String get bestReps => 'Meeste herhalingen';

  @override
  String get oneRepMax => '1RM';

  @override
  String get volume => 'Volume';

  @override
  String get paceCardio => 'Tempo (cardio)';

  @override
  String get distanceCardio => 'Afstand (cardio)';

  @override
  String get defaultGraphPeriod => 'Standaard grafiekperiode';

  @override
  String get defaultGraphLimit => 'Standaard grafieklimiet';

  @override
  String get workouts => 'Trainingen';

  @override
  String get actionStop => 'Stoppen';

  @override
  String get timerFinishedToast => 'Timer afgelopen!';

  @override
  String get stopTimer => 'Timer stoppen';

  @override
  String get actionPause => 'Pauzeren';

  @override
  String get startStopwatch => 'Stopwatch starten';

  @override
  String get actionStart => 'Starten';

  @override
  String get actionRestart => 'Opnieuw starten';

  @override
  String get addOneMinute => '+1 minuut';

  @override
  String get addOneMinuteNotification => '1 min toevoegen';

  @override
  String get restTimer => 'Rusttimer';

  @override
  String get timerUp => 'Tijd is om';

  @override
  String get openNotification => 'Melding openen';

  @override
  String get timerChannelName => 'Timerkanaal';

  @override
  String get timerChannelDescription => 'Doorlopende voortgang van rusttimers.';

  @override
  String get timerFinishedChannelName => 'Kanaal timer afgelopen';

  @override
  String get timerFinishedChannelDescription =>
      'Speelt een alarm af wanneer een rusttimer afloopt.';

  @override
  String get timerFinished => 'Timer afgelopen';

  @override
  String get batteryOptimizationRequestUnavailable =>
      'Verzoeken om batterijoptimalisatie te negeren zijn uitgeschakeld op je apparaat.';

  @override
  String get exactAlarmRequestUnavailable =>
      'Verzoek voor SCHEDULE_EXACT_ALARM is op je apparaat geweigerd';

  @override
  String get databaseMigrationFailureDescription =>
      'Er ging iets mis bij het maken of bijwerken van je database. Meestal kan dit worden opgelost door je records te verwijderen en opnieuw aan te maken.';

  @override
  String get curveSmoothness => 'Krommevloeiendheid';

  @override
  String get actionBack => 'Terug';

  @override
  String get atLeastOneTab => 'Je hebt minstens één tabblad nodig';

  @override
  String get invalidTabSettings => 'Ongeldige tabbladinstellingen.';

  @override
  String get noSettingsFound => 'Geen instellingen gevonden';

  @override
  String nothingMatchesSearch(String query) {
    return 'Niets komt overeen met “$query”.';
  }

  @override
  String get appearanceDescription => 'Thema, kleuren en interfacestijl';

  @override
  String get dataManagementDescription =>
      'Importeer, exporteer en beheer je trainingsgegevens';

  @override
  String get formatsDescription => 'Datums, getallen en meetnotaties';

  @override
  String get plansSettingsDescription =>
      'Standaardwaarden en gedrag voor trainingsschema\'s';

  @override
  String get tabsDescription =>
      'Kies en rangschik de primaire navigatietabbladen';

  @override
  String get timersDescription => 'Duur, geluid en gedrag van rusttimers';

  @override
  String get workoutsDescription =>
      'Oefeningen bijhouden en trainingsvoorkeuren';

  @override
  String get completeSetForChart =>
      'Voltooi een set van deze oefening om de grafiek op te bouwen.';

  @override
  String get dateRange => 'Datumbereik';

  @override
  String get stopDate => 'Einddatum';

  @override
  String get dataPoints => 'Gegevenspunten';

  @override
  String get completeSetsForProgress =>
      'Voltooi enkele sets om je voortgangsgrafiek op te bouwen.';

  @override
  String get relativeStrength => 'Relatieve kracht';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count geselecteerd',
      one: '1 geselecteerd',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory =>
      'Voltooi enkele sets om de geschiedenis van deze oefening hier te zien.';

  @override
  String get completeSetForFirstGraph =>
      'Voltooi een set om je eerste oefeninggrafiek te maken.';

  @override
  String nothingMatchesGraphSearch(String query) {
    return 'Niets komt overeen met “$query”. Je kunt dit als nieuwe oefening aanmaken.';
  }

  @override
  String addNamed(String name) {
    return '“$name” toevoegen';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return 'Hiermee worden $count records verwijderd. Weet je het zeker?';
  }

  @override
  String shareWorkout(String summary) {
    return 'Ik heb net $summary gedaan';
  }

  @override
  String get updateConflict => 'Updateconflict';

  @override
  String updateConflictDescription(int count) {
    return 'Je nieuwe naam bestaat al voor $count records. Weet je het zeker?';
  }

  @override
  String get unitsConflict => 'Eenhedenconflict';

  @override
  String unitsConflictDescription(String unit) {
    return 'Niet al je records gebruiken dezelfde eenheid. Hiermee worden alle eenheden geconverteerd naar $unit. Weet je het zeker?';
  }

  @override
  String get durationLabel => 'Duur';

  @override
  String get inclineLabel => 'Helling';

  @override
  String get paceDistanceTime => 'Tempo (afstand / tijd)';

  @override
  String get adjustedPace => 'Aangepast tempo';

  @override
  String get oneRepMaxAccuracyWarning =>
      '1RM-schattingen zijn minder nauwkeurig bij sets van 10 of meer herhalingen';

  @override
  String get addPlan => 'Schema toevoegen';

  @override
  String get planDetails => 'Schemadetails';

  @override
  String get exercisesLabel => 'Oefeningen';

  @override
  String get addExerciseToPlan => 'Voeg een oefening aan dit schema toe.';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return 'Niets komt overeen met “$query”. Je kunt dit als nieuwe oefening toevoegen.';
  }

  @override
  String get selectDays => 'Dagen selecteren';

  @override
  String get selectExercises => 'Oefeningen selecteren';

  @override
  String get todayLabel => 'Vandaag';

  @override
  String get setDetails => 'Setdetails';

  @override
  String get themeLabel => 'Thema';

  @override
  String get pureBlackAmoledDescription =>
      'Gebruik puur zwarte kleuren voor AMOLED-schermen';

  @override
  String get systemColorScheme => 'Systeemkleurenschema';

  @override
  String get systemColorSchemeDescription =>
      'Gebruik de primaire kleur van je apparaat voor de app';

  @override
  String get showImagesDescription =>
      'Kies en toon afbeeldingen op de geschiedenispagina';

  @override
  String get showGlobalProgress => 'Algemene voortgang tonen';

  @override
  String get showGlobalProgressDescription =>
      'Voeg aan de grafiek een item toe dat je voortgang per categorie toont';

  @override
  String get peekGraphDescription =>
      'Toon de eerste lijngrafiek op de grafiekenpagina';

  @override
  String get inputStyleDescription => 'Visuele stijl van tekstinvoervelden';

  @override
  String get automaticBackupNotificationBody =>
      'Flexify maakt elke dag automatisch een back-up van je gegevens en afbeeldingen naar de geselecteerde map.';

  @override
  String get backupSettingsChannel => 'Back-upinstellingen';

  @override
  String get backupSettingsChannelDescription =>
      'Meldingen met uitleg over automatische back-ups';

  @override
  String get backupChannelName => 'Back-upkanaal';

  @override
  String get backupChannelDescription =>
      'Automatische back-ups van Flexify-gegevens en afbeeldingen';

  @override
  String get backupCompletedTitle =>
      'Back-up van gegevens en afbeeldingen voltooid';

  @override
  String get backupFailurePathNotSet =>
      'Back-up mislukt: back-uplocatie niet ingesteld. Automatische back-ups uitgeschakeld.';

  @override
  String get backupFailureDirectoryUnavailable =>
      'Back-up mislukt: geen toegang tot de back-upmap. Automatische back-ups uitgeschakeld.';

  @override
  String get backupFailureCreateFile =>
      'Back-up mislukt: back-upbestand kon niet worden gemaakt. Automatische back-ups uitgeschakeld.';

  @override
  String get backupFailureAppFilesUnavailable =>
      'Back-up mislukt: geen toegang tot de map met app-bestanden. Automatische back-ups uitgeschakeld.';

  @override
  String get backupFailureDatabaseMissing =>
      'Back-up mislukt: databasebestand niet gevonden. Automatische back-ups uitgeschakeld.';

  @override
  String get backupFailureOutputUnavailable =>
      'Back-up mislukt: uitvoerstroom kon niet worden geopend. Automatische back-ups uitgeschakeld.';

  @override
  String get backupFailureUnknown =>
      'Back-up mislukt. Automatische back-ups uitgeschakeld.';

  @override
  String get appPermissionsDescription =>
      'Bekijk de toegang die nodig is voor de functies die je hebt ingeschakeld';

  @override
  String get longDateFormatDescription => 'Gebruikt waar voldoende ruimte is';

  @override
  String shortDateFormat(String example) {
    return 'Korte datumnotatie ($example)';
  }

  @override
  String get shortDateFormatDescription =>
      'Voor plekken met weinig ruimte (grafieklijnen)';

  @override
  String get warmupSetsDescription => 'Opwarmsets hebben geen rusttimers';

  @override
  String get setsPerExerciseDescription =>
      'Standaardaantal oefeningen in een schema';

  @override
  String get planTrailingDisplay => 'Weergave rechts van schema';

  @override
  String get planTrailingDisplayDescription =>
      'Inhoud rechts in de lijstweergave van Schema\'s en in de schemaweergave';

  @override
  String get restTimersDescription =>
      'Alarm dat afgaat na het voltooien van een set';

  @override
  String get vibrateDescription => 'Moeten rusttimers trillen?';

  @override
  String get enableSoundDescription => 'Moeten rusttimers een geluid afspelen?';

  @override
  String get keepScreenOnDescription =>
      'Houd het scherm aan tijdens rusttimers';

  @override
  String get restDurationDescription =>
      'Hoe lang duurt het voordat rustalarmen afgaan?';

  @override
  String get globalDefault => 'Algemene standaard';

  @override
  String get alarmSoundDescription =>
      'Muziek die wordt afgespeeld aan het einde van een rusttimer';

  @override
  String get progressBarPosition => 'Positie voortgangsbalk';

  @override
  String get progressBarPositionDescription =>
      'Waar moet de voortgangsbalk van rusttimers worden geplaatst?';

  @override
  String get perExerciseRestTimes => 'Rusttijden per oefening';

  @override
  String get perExerciseRestTimesDescription =>
      'Deze oefeningen hebben aangepaste rusttijden';

  @override
  String get audioFeaturesUnavailable => 'Audiofuncties zijn niet beschikbaar';

  @override
  String get groupHistoryDescription => 'Groepeer geschiedenisitems per dag';

  @override
  String get showUnitsDescription =>
      'Toon km/mi en kg/lb in grafieken, geschiedenis en schema\'s';

  @override
  String get showBodyWeightDescription =>
      'Schakel het bijhouden van lichaamsgewicht in of uit';

  @override
  String get showCategoriesDescription =>
      'Schakel trainingscategorieën in of uit';

  @override
  String get showNotesDescription =>
      'Leg details van je oefening vast in een tekstveld';

  @override
  String get positiveNotificationsDescription =>
      'Toon motiverende berichten wanneer je een nieuw record behaalt';

  @override
  String get positiveMessagesEnabled =>
      'Positieve berichten verschijnen nu zo!';

  @override
  String get recordEncouragement01 => 'Goed gedaan! Je bent geweldig.';

  @override
  String get recordEncouragement02 =>
      'Lekker bezig, koning! Je vooruitgang is inspirerend.';

  @override
  String get recordEncouragement03 => 'Ik kniel...';

  @override
  String get recordEncouragement04 => 'Wat is dat? Een nieuw record!';

  @override
  String get recordEncouragement05 => 'Fantastisch! Je bent een inspiratie.';

  @override
  String get recordEncouragement06 => 'Wauw. Lekker.';

  @override
  String get recordEncouragement07 => 'Zo, word je sterk?';

  @override
  String get recordEncouragement08 => 'Ja. Jij wordt behoorlijk groot.';

  @override
  String get recordEncouragement09 => 'Geweldig. Ongelooflijk.';

  @override
  String get recordEncouragement10 => 'Arnie zou trots zijn.';

  @override
  String get recordEncouragement11 => 'Ronnie C kijkt vol plezier op je neer.';

  @override
  String get recordEncouragement12 => 'JAAA! LICHTGEWICHT, BABY!!!!!!!';

  @override
  String get recordEncouragement13 =>
      'Is dat een nieuw record? Ik wist dat je het kon.';

  @override
  String get recordEncouragement14 => 'Goed gedaan! Ik ben trots op je.';

  @override
  String get recordEncouragement15 => 'Ja baby! Licht gewicht!';

  @override
  String get recordEncouragement16 => 'Ga zo door! Mooie vooruitgang.';

  @override
  String get recordEncouragement17 => 'Je doet het ontzettend goed.';

  @override
  String get recordEncouragement18 => 'Dat is mijn jongen!';

  @override
  String get recordEncouragement19 => 'Ga zo door.';

  @override
  String get recordEncouragement20 => 'Je wordt heel sterk.';

  @override
  String get recordEncouragement21 => 'Krachtig.';

  @override
  String get recordEncouragement22 => 'Wat een kracht!';

  @override
  String get recordEncouragement23 => 'Ik ben trots op je.';

  @override
  String get recordEncouragement24 => 'Ga vooral zo door.';

  @override
  String get recordEncouragement25 =>
      'Sta rechtop! Je hebt net een nieuw record neergezet.';

  @override
  String get recordEncouragement26 =>
      'Nieuw record! Je bent verder gegaan dan ooit!';

  @override
  String get recordEncouragement27 => 'Jazeker! Dat is een record.';

  @override
  String get recordEncouragement28 => 'Wauw! Nieuw record!';

  @override
  String get recordEncouragement29 => 'Heel goed gedaan.';

  @override
  String get repEstimationDescription =>
      'Probeer het aantal herhalingen dat je net deed te voorspellen';

  @override
  String get durationEstimationDescription =>
      'Probeer de duur van je cardio te voorspellen';

  @override
  String get showGraphXAxisToggle => 'Schakelaar voor X-as van grafiek tonen';

  @override
  String get showGraphXAxisToggleDescription =>
      'Toon in grafieken de schakelaar voor een tijdgebaseerde X-as';

  @override
  String get showGraphLimitDescription =>
      'Toon de limietschuifregelaar in grafieken';

  @override
  String get defaultTimeBasedXAxis => 'Standaard tijdgebaseerde X-as';

  @override
  String get defaultTimeBasedXAxisDescription =>
      'Gebruik standaard een tijdgebaseerde X-as in grafieken';

  @override
  String get createFirstTrainingPlan =>
      'Maak je eerste trainingsschema om te beginnen.';

  @override
  String nothingMatchesPlanSearch(String query) {
    return 'Niets komt overeen met “$query”. Je kunt dit als nieuw schema aanmaken.';
  }

  @override
  String get createPlan => 'Schema aanmaken';

  @override
  String createNamedPlan(String name) {
    return '“$name” aanmaken';
  }

  @override
  String setNumber(int number) {
    return 'Set $number';
  }
}
