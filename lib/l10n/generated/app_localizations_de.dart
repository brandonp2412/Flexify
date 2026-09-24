// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageDescription => 'Wähle die Sprache für Flexify';

  @override
  String get languageSystemDefault => 'Systemstandard';

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
  String get navHistory => 'Verlauf';

  @override
  String get navPlans => 'Pläne';

  @override
  String get navGraphs => 'Diagramme';

  @override
  String get navTimer => 'Timer';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get errorLabel => 'Fehler';

  @override
  String get tabContentError =>
      'Der Inhalt des Tabs konnte nicht angezeigt werden.';

  @override
  String get cannotHideAllTabs =>
      'Es können nicht alle Tabs ausgeblendet werden!';

  @override
  String removeTabQuestion(String tab) {
    return 'Tab „$tab“ entfernen?';
  }

  @override
  String get restoreTabFromSettings =>
      'Du kannst ihn später in den Einstellungen wieder hinzufügen.';

  @override
  String removedTab(String tab) {
    return '„$tab“ entfernt';
  }

  @override
  String newVersion(String version) {
    return 'Neue Version $version';
  }

  @override
  String get changes => 'Änderungen';

  @override
  String get searchHint => 'Suchen...';

  @override
  String get deleteSelected => 'Auswahl löschen';

  @override
  String get confirmDelete => 'Löschen bestätigen';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Möchtest du wirklich $count Einträge löschen? Diese Aktion kann nicht rückgängig gemacht werden.',
      one:
          'Möchtest du wirklich 1 Eintrag löschen? Diese Aktion kann nicht rückgängig gemacht werden.',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'Abbrechen';

  @override
  String get actionDelete => 'Löschen';

  @override
  String get actionRemove => 'Entfernen';

  @override
  String get actionEdit => 'Bearbeiten';

  @override
  String get actionShare => 'Teilen';

  @override
  String get clearSelection => 'Auswahl aufheben';

  @override
  String get clearSearch => 'Suche löschen';

  @override
  String get showMenu => 'Menü anzeigen';

  @override
  String get selectAll => 'Alle auswählen';

  @override
  String get weightLabel => 'Gewicht';

  @override
  String get filter => 'Filter';

  @override
  String get filters => 'Filter';

  @override
  String get categoryLabel => 'Kategorie';

  @override
  String get repsLabel => 'Wiederholungen';

  @override
  String get repsFilter => 'Wiederholungsfilter';

  @override
  String get weightFilter => 'Gewichtsfilter';

  @override
  String get greaterThan => 'Größer als';

  @override
  String get lessThan => 'Kleiner als';

  @override
  String get startDate => 'Startdatum';

  @override
  String get endDate => 'Enddatum';

  @override
  String get actionClear => 'Leeren';

  @override
  String get actionOk => 'OK';

  @override
  String get actionClose => 'Schließen';

  @override
  String get sortBy => 'Sortieren nach';

  @override
  String get dateNewest => 'Datum (neueste zuerst)';

  @override
  String get dateOldest => 'Datum (älteste zuerst)';

  @override
  String get nameLabel => 'Name';

  @override
  String get missingPermissions => 'Fehlende Berechtigungen';

  @override
  String get restTimersPermissionsMissing =>
      'Pausentimer sind aktiviert, aber Berechtigungen fehlen.';

  @override
  String get restTimersPermissionsOptional =>
      'Wenn du die Pausentimer deaktivierst, werden diese Berechtigungen nicht benötigt.';

  @override
  String get restTimers => 'Pausentimer';

  @override
  String get disableBatteryOptimizations => 'Akkuoptimierung deaktivieren';

  @override
  String get batteryOptimizationWarning =>
      'Der Fortschritt kann pausieren, wenn die Akkuoptimierung aktiviert bleibt.';

  @override
  String get scheduleExactAlarm => 'Genauen Alarm planen';

  @override
  String get exactAlarmWarning =>
      'Alarme können nicht genau ausgelöst werden, wenn dies deaktiviert ist.';

  @override
  String get postNotifications => 'Benachrichtigungen anzeigen';

  @override
  String get notificationBarDescription =>
      'Der Timerfortschritt wird in der Benachrichtigungsleiste angezeigt';

  @override
  String get invalidPermissions => 'Ungültige Berechtigungen';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      'Pausentimer sind ohne ausreichende Berechtigungen aktiviert. Trotzdem fortfahren?';

  @override
  String get actionConfirm => 'Bestätigen';

  @override
  String get appAccess => 'App-Zugriff';

  @override
  String get appAccessDescription =>
      'Wird für aktivierte Timer und Benachrichtigungen benötigt.';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get timerProgressAndRestAlerts =>
      'Timerfortschritt und Pausenhinweise';

  @override
  String get enabledNotificationsDescription =>
      'Von dir aktivierte Benachrichtigungen';

  @override
  String get backgroundActivity => 'Hintergrundaktivität';

  @override
  String get backgroundActivityDescription =>
      'Hält Timer im Hintergrund zuverlässig am Laufen';

  @override
  String get exactAlarms => 'Genaue Alarme';

  @override
  String get exactAlarmsDescription =>
      'Benachrichtigt genau beim Ende eines Pausentimers';

  @override
  String get noAdditionalAndroidAccessNeeded =>
      'Für deine aktuellen Einstellungen ist kein zusätzlicher Android-Zugriff erforderlich.';

  @override
  String get actionDone => 'Fertig';

  @override
  String get allowed => 'Erlaubt';

  @override
  String get actionAllow => 'Erlauben';

  @override
  String get backupLabel => 'Sicherung';

  @override
  String get databaseLabel => 'Datenbank';

  @override
  String get deleteRecords => 'Einträge löschen';

  @override
  String get deleteAllGraphsConfirmation =>
      'Möchtest du wirklich alle Diagramme löschen? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get deleteAllPlansConfirmation =>
      'Möchtest du wirklich alle Pläne löschen? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get deleteDatabaseConfirmation =>
      'Möchtest du wirklich deine Datenbank löschen? Diese Aktion kann nicht rückgängig gemacht werden und löscht alle deine Daten.';

  @override
  String get importData => 'Daten importieren';

  @override
  String get exportData => 'Daten exportieren';

  @override
  String get actionReport => 'Melden';

  @override
  String get graphDataImported => 'Diagrammdaten erfolgreich importiert!';

  @override
  String get plansImported => 'Pläne erfolgreich importiert';

  @override
  String failedToImportDatabase(String error) {
    return 'Datenbank konnte nicht importiert werden: $error';
  }

  @override
  String get backupArchiveMissingDatabase =>
      'Die Sicherung enthält die Flexify-Datenbank nicht.';

  @override
  String failedToImportGraphs(String error) {
    return 'Diagramme konnten nicht importiert werden: $error';
  }

  @override
  String failedToImportPlans(String error) {
    return 'Pläne konnten nicht importiert werden: $error';
  }

  @override
  String get selectedFileDoesNotExist =>
      'Die ausgewählte Datei ist nicht vorhanden';

  @override
  String get couldNotReadFileData => 'Dateidaten konnten nicht gelesen werden';

  @override
  String get databaseImportWebUnsupported =>
      'Der Datenbankimport im Web erfordert eine manuelle Datenmigration. Exportiere deine Daten als CSV-Dateien und importiere stattdessen diese.';

  @override
  String get csvFileEmpty => 'Die CSV-Datei ist leer';

  @override
  String get csvNeedsDataRow =>
      'Die CSV-Datei muss mindestens eine Datenzeile enthalten';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return 'Zeile $row enthält zu wenige Spalten: $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return 'Ungültiger Wert für $field in Zeile $row: $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return 'Ungültiger Datentyp für $field in Zeile $row: $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return 'Für die Plan-ID wurde eine Ganzzahl erwartet, erhalten: \"$value\"';
  }

  @override
  String get unitLabel => 'Einheit';

  @override
  String get kilogramsUnit => 'Kilogramm (kg)';

  @override
  String get poundsUnit => 'Pfund (lb)';

  @override
  String get stoneUnit => 'Stone';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => 'Kilometer (km)';

  @override
  String get milesUnit => 'Meilen (mi)';

  @override
  String get metersUnit => 'Meter (m)';

  @override
  String get kilocaloriesUnit => 'Kilokalorien (kcal)';

  @override
  String get enterWeight => 'Gewicht eingeben';

  @override
  String get requiredField => 'Erforderlich';

  @override
  String get invalidNumber => 'Ungültige Zahl';

  @override
  String get previousWeight => 'Vorheriges Gewicht';

  @override
  String get imageLabel => 'Bild';

  @override
  String get longPressToDelete => 'Zum Löschen lange drücken';

  @override
  String get imageError => 'Bildfehler';

  @override
  String get actionSave => 'Speichern';

  @override
  String get aboutTitle => 'Über';

  @override
  String get donate => 'Spenden';

  @override
  String get helpSupportProject => 'Hilf mit, dieses Projekt zu unterstützen';

  @override
  String get whatsNewAbout => 'Was ist neu?';

  @override
  String get whatsNewTitle => 'Was ist neu?';

  @override
  String get seeReleaseNotes => 'Versionshinweise ansehen';

  @override
  String get versionLabel => 'Version';

  @override
  String get authorLabel => 'Autor';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get privacyPolicyDescription => 'Wie Flexify mit deinen Daten umgeht';

  @override
  String get licenseLabel => 'Lizenz';

  @override
  String get sourceCode => 'Quellcode';

  @override
  String get sourceCodeDescription => 'Auf GitHub ansehen';

  @override
  String get leaveReview => 'Bewertung abgeben';

  @override
  String get leaveReviewDescription => 'Flexify im Play Store bewerten';

  @override
  String get reportBug => 'Fehler melden';

  @override
  String get reportBugDescription => 'Ticket auf GitHub erstellen';

  @override
  String get failedMigrations => 'Fehlgeschlagene Migrationen';

  @override
  String get errorMessageLabel => 'Fehlermeldung:';

  @override
  String get createIssue => 'Issue erstellen';

  @override
  String get addExercise => 'Übung hinzufügen';

  @override
  String get cardio => 'Cardio';

  @override
  String get strength => 'Krafttraining';

  @override
  String get options => 'Optionen';

  @override
  String get periodDay => 'Tag';

  @override
  String get periodWeek => 'Woche';

  @override
  String get periodMonth => 'Monat';

  @override
  String get periodYear => 'Jahr';

  @override
  String noDataFor(String name) {
    return 'Noch keine Daten für $name';
  }

  @override
  String get noDataYet => 'Noch keine Daten';

  @override
  String get exerciseNotes => 'Übungsnotizen';

  @override
  String get notesForExercise => 'Notizen für diese Übung';

  @override
  String get useTimeBasedXAxis => 'Zeitbasierte X-Achse verwenden';

  @override
  String updateAllNamed(String name) {
    return 'Alle „$name“ aktualisieren';
  }

  @override
  String get newName => 'Neuer Name';

  @override
  String get restMinutes => 'Pausenminuten';

  @override
  String get restSeconds => 'Pausensekunden';

  @override
  String get globalProgress => 'Gesamtfortschritt';

  @override
  String get curveLineGraphs => 'Diagrammlinien glätten';

  @override
  String get curveLineGraphsDescription =>
      'Diagrammlinien als weiche Kurven zeichnen';

  @override
  String noHistoryFor(String name) {
    return 'Noch kein Verlauf für $name';
  }

  @override
  String get cancelSelection => 'Auswahl aufheben';

  @override
  String get editSelected => 'Auswahl bearbeiten';

  @override
  String get newExercise => 'Neue Übung';

  @override
  String get noGraphsFound => 'Keine Diagramme gefunden';

  @override
  String get searchGraphs => 'Diagramme suchen...';

  @override
  String get actionAdd => 'Hinzufügen';

  @override
  String get actionUpdate => 'Aktualisieren';

  @override
  String get hideGlobalProgress => 'Gesamtfortschritt ausblenden';

  @override
  String get chartGroupedByCategory => 'Nach Kategorie gruppiertes Diagramm';

  @override
  String get noExercisesFound => 'Keine Übungen gefunden';

  @override
  String get savePlan => 'Plan speichern';

  @override
  String get titleOptional => 'Titel (optional)';

  @override
  String get searchExercises => 'Übungen suchen...';

  @override
  String get warmupSets => 'Aufwärmsätze';

  @override
  String get workingSetsMax => 'Arbeitssätze (max. 20)';

  @override
  String get actionUndo => 'Rückgängig';

  @override
  String get actionSwap => 'Tauschen';

  @override
  String get daily => 'Täglich';

  @override
  String get weekly => 'Wöchentlich';

  @override
  String get monthly => 'Monatlich';

  @override
  String get yearly => 'Jährlich';

  @override
  String get unexpectedError =>
      'Etwas ist schiefgelaufen. Bitte versuche es erneut.';

  @override
  String get loadingExercises => 'Übungen werden geladen...';

  @override
  String get noPlansYet => 'Noch keine Pläne';

  @override
  String get noMatchingPlans => 'Keine passenden Pläne';

  @override
  String get newPlan => 'Neuer Plan';

  @override
  String get searchPlans => 'Pläne suchen...';

  @override
  String get noExercisesYet => 'Noch keine Übungen';

  @override
  String get editPlan => 'Plan bearbeiten';

  @override
  String get saveSet => 'Satz speichern';

  @override
  String get minutesLabel => 'Minuten';

  @override
  String get minutesShort => 'Min.';

  @override
  String get secondsLabel => 'Sekunden';

  @override
  String get distanceLabel => 'Distanz';

  @override
  String get inclinePercent => 'Steigung %';

  @override
  String weightWithUnit(String unit) {
    return 'Gewicht ($unit)';
  }

  @override
  String get useBodyWeight => 'Körpergewicht verwenden';

  @override
  String get noWeightEnteredYet => 'Noch kein Gewicht eingetragen';

  @override
  String get notesLabel => 'Notizen';

  @override
  String get swapWorkout => 'Übung austauschen';

  @override
  String get addSet => 'Satz hinzufügen';

  @override
  String get deleteSet => 'Satz löschen';

  @override
  String get oneRepMaxEstimate => '1RM (Schätzung)';

  @override
  String get valueLabel => 'Wert';

  @override
  String amountWithUnit(String unit) {
    return 'Menge ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return 'Distanz ($unit)';
  }

  @override
  String get bodyWeightLabel => 'Körpergewicht';

  @override
  String bodyWeightWithUnit(String unit) {
    return 'Körpergewicht ($unit)';
  }

  @override
  String get categoryHelper =>
      'Wähle eine vorhandene Kategorie oder gib eine neue ein.';

  @override
  String get manageCategories => 'Kategorien verwalten';

  @override
  String get manageCategoriesDescription =>
      'Kategorien erstellen, umbenennen, zusammenführen oder entfernen';

  @override
  String get newCategory => 'Neue Kategorie';

  @override
  String get renameCategory => 'Kategorie umbenennen';

  @override
  String get mergeCategory => 'Mit einer anderen Kategorie zusammenführen';

  @override
  String get noCategories => 'Noch keine Kategorien';

  @override
  String get categoryNameRequired => 'Gib einen Kategorienamen ein';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Von $count Einträgen verwendet',
      one: 'Von 1 Eintrag verwendet',
      zero: 'Von keinem Eintrag verwendet',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Diese Kategorie löschen und aus $count Einträgen entfernen?',
      one: 'Diese Kategorie löschen und aus 1 Eintrag entfernen?',
      zero: 'Diese Kategorie löschen?',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => 'Erstellungsdatum';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sätze bearbeiten',
      one: '1 Satz bearbeiten',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => 'Noch keine Einträge';

  @override
  String get historyEmptyMessage =>
      'Schließe einen Satz ab oder füge manuell einen hinzu, um deinen Verlauf zu starten.';

  @override
  String deleteSetConfirmation(String name) {
    return 'Möchtest du $name wirklich löschen?';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Möchtest du wirklich $count Einträge löschen?',
      one: 'Möchtest du wirklich 1 Eintrag löschen?',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => 'Verlauf durchsuchen...';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeLight => 'Hell';

  @override
  String get pureBlackAmoled => 'Reines Schwarz (AMOLED)';

  @override
  String get showImages => 'Bilder anzeigen';

  @override
  String get peekGraph => 'Diagrammvorschau';

  @override
  String get inputStyleLine => 'Linie';

  @override
  String get inputStyleOutlined => 'Umrandet';

  @override
  String get inputStyleFilled => 'Ausgefüllt';

  @override
  String get inputStyle => 'Eingabestil';

  @override
  String get appearance => 'Darstellung';

  @override
  String get automaticBackupsEnabled => 'Automatische Sicherungen aktiviert';

  @override
  String get automaticBackup => 'Automatische Sicherung';

  @override
  String get appPermissions => 'App-Berechtigungen';

  @override
  String get shareDatabase => 'Datenbank teilen';

  @override
  String get dataManagement => 'Datenverwaltung';

  @override
  String get strengthUnit => 'Gewichtseinheit';

  @override
  String get lastEntry => 'Letzter Eintrag';

  @override
  String get cardioUnit => 'Cardio-Einheit';

  @override
  String longDateFormat(String format) {
    return 'Langes Datumsformat ($format)';
  }

  @override
  String get formats => 'Formate';

  @override
  String get setsPerExerciseMax => 'Sätze pro Übung (max. 20)';

  @override
  String get countLabel => 'Anzahl';

  @override
  String get ratioLabel => 'Verhältnis';

  @override
  String get reorder => 'Neu anordnen';

  @override
  String get none => 'Keine';

  @override
  String get monday => 'Montag';

  @override
  String get examplePlanExercises => 'Bankdrücken, Kniebeuge, Kreuzheben';

  @override
  String get tabs => 'Tabs';

  @override
  String get swipeBetweenTabs => 'Zwischen Tabs wischen';

  @override
  String get vibrate => 'Vibrieren';

  @override
  String get enableSound => 'Ton aktivieren';

  @override
  String get keepScreenOn => 'Bildschirm eingeschaltet lassen';

  @override
  String get alarmSound => 'Alarmton';

  @override
  String get top => 'Oben';

  @override
  String get bottom => 'Unten';

  @override
  String get removeCustomTimer =>
      'Benutzerdefinierten Timer entfernen (globalen Standard verwenden)';

  @override
  String get timers => 'Timer';

  @override
  String get timerSettings => 'Timer-Einstellungen';

  @override
  String get groupHistory => 'Verlauf gruppieren';

  @override
  String get showUnits => 'Einheiten anzeigen';

  @override
  String get showBodyWeight => 'Körpergewicht anzeigen';

  @override
  String get showCategories => 'Kategorien anzeigen';

  @override
  String get showNotes => 'Notizen anzeigen';

  @override
  String get repEstimation => 'Wiederholungsschätzung';

  @override
  String get durationEstimation => 'Dauerschätzung';

  @override
  String get showGraphLimit => 'Diagrammlimit anzeigen';

  @override
  String get defaultGraphMetric => 'Standard-Diagrammmetrik';

  @override
  String get bestWeight => 'Bestes Gewicht';

  @override
  String get bestReps => 'Meiste Wiederholungen';

  @override
  String get oneRepMax => '1RM';

  @override
  String get volume => 'Volumen';

  @override
  String get paceCardio => 'Tempo (Cardio)';

  @override
  String get distanceCardio => 'Distanz (Cardio)';

  @override
  String get defaultGraphPeriod => 'Standard-Diagrammzeitraum';

  @override
  String get defaultGraphLimit => 'Standard-Diagrammlimit';

  @override
  String get workouts => 'Training';

  @override
  String get actionStop => 'Stopp';

  @override
  String get timerFinishedToast => 'Timer beendet!';

  @override
  String get stopTimer => 'Timer stoppen';

  @override
  String get actionPause => 'Pause';

  @override
  String get startStopwatch => 'Stoppuhr starten';

  @override
  String get actionStart => 'Starten';

  @override
  String get actionRestart => 'Neu starten';

  @override
  String get addOneMinute => '+1 Minute';

  @override
  String get addOneMinuteNotification => '1 Min. hinzufügen';

  @override
  String get restTimer => 'Pausentimer';

  @override
  String get timerUp => 'Zeit abgelaufen';

  @override
  String get openNotification => 'Benachrichtigung öffnen';

  @override
  String get timerChannelName => 'Timer-Kanal';

  @override
  String get timerChannelDescription =>
      'Fortlaufender Fortschritt von Pausentimern.';

  @override
  String get timerFinishedChannelName => 'Kanal für beendete Timer';

  @override
  String get timerFinishedChannelDescription =>
      'Spielt einen Alarm ab, wenn ein Pausentimer endet.';

  @override
  String get timerFinished => 'Timer beendet';

  @override
  String get batteryOptimizationRequestUnavailable =>
      'Anfragen zum Ignorieren der Akkuoptimierung sind auf deinem Gerät deaktiviert.';

  @override
  String get exactAlarmRequestUnavailable =>
      'Die Anfrage für SCHEDULE_EXACT_ALARM wurde auf deinem Gerät abgelehnt';

  @override
  String get databaseMigrationFailureDescription =>
      'Beim Erstellen oder Aktualisieren deiner Datenbank ist ein Fehler aufgetreten. Meist lässt sich das Problem beheben, indem du deine Einträge löschst und neu erstellst.';

  @override
  String get curveSmoothness => 'Kurvenglättung';

  @override
  String get actionBack => 'Zurück';

  @override
  String get atLeastOneTab => 'Du benötigst mindestens einen Tab';

  @override
  String get invalidTabSettings => 'Ungültige Tab-Einstellungen.';

  @override
  String get noSettingsFound => 'Keine Einstellungen gefunden';

  @override
  String nothingMatchesSearch(String query) {
    return 'Keine Treffer für „$query“.';
  }

  @override
  String get appearanceDescription =>
      'Design, Farben und Darstellung der Oberfläche';

  @override
  String get dataManagementDescription =>
      'Trainingsdaten importieren, exportieren und verwalten';

  @override
  String get formatsDescription =>
      'Formatierung von Datum, Zahlen und Maßeinheiten';

  @override
  String get plansSettingsDescription =>
      'Standards und Verhalten für Trainingspläne';

  @override
  String get tabsDescription => 'Hauptnavigation auswählen und anordnen';

  @override
  String get timersDescription => 'Dauer, Ton und Verhalten des Pausentimers';

  @override
  String get workoutsDescription =>
      'Übungsverfolgung und Trainingseinstellungen';

  @override
  String get completeSetForChart =>
      'Schließe einen Satz dieser Übung ab, um das Diagramm zu erstellen.';

  @override
  String get dateRange => 'Datumsbereich';

  @override
  String get stopDate => 'Enddatum';

  @override
  String get dataPoints => 'Datenpunkte';

  @override
  String get completeSetsForProgress =>
      'Schließe einige Sätze ab, um dein Fortschrittsdiagramm zu erstellen.';

  @override
  String get relativeStrength => 'Relative Kraft';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ausgewählt',
      one: '1 ausgewählt',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory =>
      'Schließe einige Sätze ab, um den Verlauf dieser Übung hier zu sehen.';

  @override
  String get completeSetForFirstGraph =>
      'Schließe einen Satz ab, um dein erstes Übungsdiagramm zu erstellen.';

  @override
  String nothingMatchesGraphSearch(String query) {
    return 'Keine Treffer für „$query“. Du kannst daraus eine neue Übung erstellen.';
  }

  @override
  String addNamed(String name) {
    return '„$name“ hinzufügen';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return 'Dadurch werden $count Einträge gelöscht. Fortfahren?';
  }

  @override
  String shareWorkout(String summary) {
    return 'Ich habe gerade $summary gemacht';
  }

  @override
  String get updateConflict => 'Aktualisierungskonflikt';

  @override
  String updateConflictDescription(int count) {
    return 'Der neue Name ist bereits bei $count Einträgen vorhanden. Trotzdem fortfahren?';
  }

  @override
  String get unitsConflict => 'Einheitenkonflikt';

  @override
  String unitsConflictDescription(String unit) {
    return 'Nicht alle Einträge verwenden dieselbe Einheit. Dadurch werden alle Einheiten in $unit umgerechnet. Fortfahren?';
  }

  @override
  String get durationLabel => 'Dauer';

  @override
  String get inclineLabel => 'Steigung';

  @override
  String get paceDistanceTime => 'Tempo (Distanz / Zeit)';

  @override
  String get adjustedPace => 'Angepasstes Tempo';

  @override
  String get oneRepMaxAccuracyWarning =>
      '1RM-Schätzungen sind bei Sätzen mit 10 oder mehr Wiederholungen weniger genau';

  @override
  String get addPlan => 'Plan hinzufügen';

  @override
  String get planDetails => 'Plandetails';

  @override
  String get exercisesLabel => 'Übungen';

  @override
  String get addExerciseToPlan => 'Füge diesem Plan eine Übung hinzu.';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return 'Keine Treffer für „$query“. Du kannst sie als neue Übung hinzufügen.';
  }

  @override
  String get selectDays => 'Tage auswählen';

  @override
  String get selectExercises => 'Übungen auswählen';

  @override
  String get todayLabel => 'Heute';

  @override
  String get setDetails => 'Satzdetails';

  @override
  String get themeLabel => 'Design';

  @override
  String get pureBlackAmoledDescription =>
      'Reines Schwarz für AMOLED-Displays verwenden';

  @override
  String get systemColorScheme => 'Systemfarbschema';

  @override
  String get systemColorSchemeDescription =>
      'Die Primärfarbe deines Geräts für die App verwenden';

  @override
  String get showImagesDescription =>
      'Bilder auf der Verlaufsseite auswählen und anzeigen';

  @override
  String get showGlobalProgress => 'Gesamtfortschritt anzeigen';

  @override
  String get showGlobalProgressDescription =>
      'Ein Diagramm hinzufügen, das deinen Fortschritt nach Kategorie zeigt';

  @override
  String get peekGraphDescription =>
      'Das erste Liniendiagramm auf der Diagrammseite anzeigen';

  @override
  String get inputStyleDescription => 'Darstellung der Texteingabefelder';

  @override
  String get automaticBackupNotificationBody =>
      'Flexify sichert deine Daten und Bilder jeden Tag automatisch im ausgewählten Ordner.';

  @override
  String get backupSettingsChannel => 'Sicherungseinstellungen';

  @override
  String get backupSettingsChannelDescription =>
      'Benachrichtigungen zu automatischen Sicherungen';

  @override
  String get backupChannelName => 'Sicherungskanal';

  @override
  String get backupChannelDescription =>
      'Automatische Sicherungen von Flexify-Daten und -Bildern';

  @override
  String get backupCompletedTitle => 'Daten und Bilder gesichert';

  @override
  String get backupFailurePathNotSet =>
      'Sicherung fehlgeschlagen: Sicherungspfad nicht festgelegt. Automatische Sicherungen wurden deaktiviert.';

  @override
  String get backupFailureDirectoryUnavailable =>
      'Sicherung fehlgeschlagen: Auf den Sicherungsordner konnte nicht zugegriffen werden. Automatische Sicherungen wurden deaktiviert.';

  @override
  String get backupFailureCreateFile =>
      'Sicherung fehlgeschlagen: Sicherungsdatei konnte nicht erstellt werden. Automatische Sicherungen wurden deaktiviert.';

  @override
  String get backupFailureAppFilesUnavailable =>
      'Sicherung fehlgeschlagen: Auf den App-Dateiordner konnte nicht zugegriffen werden. Automatische Sicherungen wurden deaktiviert.';

  @override
  String get backupFailureDatabaseMissing =>
      'Sicherung fehlgeschlagen: Datenbankdatei nicht gefunden. Automatische Sicherungen wurden deaktiviert.';

  @override
  String get backupFailureOutputUnavailable =>
      'Sicherung fehlgeschlagen: Ausgabestream konnte nicht geöffnet werden. Automatische Sicherungen wurden deaktiviert.';

  @override
  String get backupFailureUnknown =>
      'Sicherung fehlgeschlagen. Automatische Sicherungen wurden deaktiviert.';

  @override
  String get appPermissionsDescription =>
      'Für aktivierte Funktionen erforderliche Zugriffe prüfen';

  @override
  String get longDateFormatDescription =>
      'Wird verwendet, wenn ausreichend Platz vorhanden ist';

  @override
  String shortDateFormat(String example) {
    return 'Kurzes Datumsformat ($example)';
  }

  @override
  String get shortDateFormatDescription =>
      'Für Bereiche mit wenig Platz (Diagrammlinien)';

  @override
  String get warmupSetsDescription => 'Aufwärmsätze haben keine Pausentimer';

  @override
  String get setsPerExerciseDescription =>
      'Standardanzahl der Sätze für jede Übung in einem Plan';

  @override
  String get planTrailingDisplay => 'Zusatzinfo im Plan';

  @override
  String get planTrailingDisplayDescription =>
      'Informationen rechts in der Planliste und Planansicht';

  @override
  String get restTimersDescription => 'Alarm nach Abschluss eines Satzes';

  @override
  String get vibrateDescription => 'Pausentimer vibrieren lassen';

  @override
  String get enableSoundDescription => 'Bei Pausentimern einen Ton abspielen';

  @override
  String get keepScreenOnDescription =>
      'Bildschirm während Pausentimern eingeschaltet lassen';

  @override
  String get restDurationDescription =>
      'Zeit bis zum Auslösen des Pausenalarms';

  @override
  String get globalDefault => 'Globaler Standard';

  @override
  String get alarmSoundDescription => 'Ton am Ende eines Pausentimers';

  @override
  String get progressBarPosition => 'Position der Fortschrittsleiste';

  @override
  String get progressBarPositionDescription =>
      'Position der Fortschrittsleiste des Pausentimers';

  @override
  String get perExerciseRestTimes => 'Pausenzeiten pro Übung';

  @override
  String get perExerciseRestTimesDescription =>
      'Diese Übungen haben eigene Pausenzeiten';

  @override
  String get audioFeaturesUnavailable => 'Audiofunktionen sind nicht verfügbar';

  @override
  String get groupHistoryDescription =>
      'Verlaufseinträge nach Tag zusammenfassen';

  @override
  String get showUnitsDescription =>
      'km/mi und kg/lb in Diagrammen, Verlauf und Plänen anzeigen';

  @override
  String get showBodyWeightDescription =>
      'Körpergewichtserfassung aktivieren oder deaktivieren';

  @override
  String get showCategoriesDescription =>
      'Trainingskategorien aktivieren oder deaktivieren';

  @override
  String get showNotesDescription =>
      'Details zu deinem Satz in einem Textfeld speichern';

  @override
  String get positiveNotificationsDescription =>
      'Motivierende Nachrichten bei einem neuen Rekord anzeigen';

  @override
  String get positiveMessagesEnabled =>
      'Motivierende Nachrichten werden jetzt so angezeigt!';

  @override
  String get recordEncouragement01 => 'Starke Leistung! Du bist unglaublich.';

  @override
  String get recordEncouragement02 =>
      'Sehr stark! Dein Fortschritt ist inspirierend.';

  @override
  String get recordEncouragement03 => 'Ich verneige mich...';

  @override
  String get recordEncouragement04 => 'Was ist das? Ein neuer Rekord!';

  @override
  String get recordEncouragement05 => 'Unglaublich! Du bist eine Inspiration.';

  @override
  String get recordEncouragement06 => 'Wow. Stark.';

  @override
  String get recordEncouragement07 => 'Ganz schön stark geworden, oder?';

  @override
  String get recordEncouragement08 => 'Ja. Du wirst richtig stark.';

  @override
  String get recordEncouragement09 => 'Fantastisch. Unglaublich.';

  @override
  String get recordEncouragement10 => 'Arnie wäre stolz.';

  @override
  String get recordEncouragement11 => 'Ronnie C schaut dir mit Freude zu.';

  @override
  String get recordEncouragement12 => 'YEAH! LIGHTWEIGHT, BABY!!!!!!!';

  @override
  String get recordEncouragement13 =>
      'Ist das ein neuer Rekord? Ich wusste, dass du es schaffst.';

  @override
  String get recordEncouragement14 =>
      'Starke Leistung! Ich bin stolz auf dich.';

  @override
  String get recordEncouragement15 => 'Yeah, Baby! Federleicht!';

  @override
  String get recordEncouragement16 => 'Weiter so! Toller Fortschritt.';

  @override
  String get recordEncouragement17 => 'Du machst das richtig gut.';

  @override
  String get recordEncouragement18 => 'Das ist mein Champion!';

  @override
  String get recordEncouragement19 => 'Weiter so.';

  @override
  String get recordEncouragement20 => 'Du wirst richtig stark.';

  @override
  String get recordEncouragement21 => 'Kraftvoll.';

  @override
  String get recordEncouragement22 => 'Was für eine Kraft!';

  @override
  String get recordEncouragement23 => 'Ich bin stolz auf dich.';

  @override
  String get recordEncouragement24 => 'Mach weiter so.';

  @override
  String get recordEncouragement25 =>
      'Kopf hoch! Du hast gerade einen neuen Rekord aufgestellt.';

  @override
  String get recordEncouragement26 =>
      'Neuer Rekord! Du bist gerade weiter gegangen als je zuvor!';

  @override
  String get recordEncouragement27 => 'Ja! Das ist ein Rekord.';

  @override
  String get recordEncouragement28 => 'Wow! Neuer Rekord!';

  @override
  String get recordEncouragement29 => 'Sehr starke Leistung.';

  @override
  String get repEstimationDescription =>
      'Versucht vorherzusagen, wie viele Wiederholungen du gerade gemacht hast';

  @override
  String get durationEstimationDescription =>
      'Versucht die Dauer deines Cardio-Trainings vorherzusagen';

  @override
  String get showGraphXAxisToggle => 'X-Achsen-Umschalter anzeigen';

  @override
  String get showGraphXAxisToggleDescription =>
      'Umschalter für die zeitbasierte X-Achse in Diagrammen anzeigen';

  @override
  String get showGraphLimitDescription =>
      'Limit-Schieberegler in Diagrammen anzeigen';

  @override
  String get defaultTimeBasedXAxis => 'Standardmäßig zeitbasierte X-Achse';

  @override
  String get defaultTimeBasedXAxisDescription =>
      'In Diagrammen standardmäßig eine zeitbasierte X-Achse verwenden';

  @override
  String get createFirstTrainingPlan =>
      'Erstelle deinen ersten Trainingsplan, um loszulegen.';

  @override
  String nothingMatchesPlanSearch(String query) {
    return 'Keine Treffer für „$query“. Du kannst daraus einen neuen Plan erstellen.';
  }

  @override
  String get createPlan => 'Plan erstellen';

  @override
  String createNamedPlan(String name) {
    return '„$name“ erstellen';
  }

  @override
  String setNumber(int number) {
    return 'Satz $number';
  }
}
