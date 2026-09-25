// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsLanguageDescription => 'Scegli la lingua usata da Flexify';

  @override
  String get languageSystemDefault => 'Predefinita di sistema';

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
  String get languageNameBengali => 'বাংলা';

  @override
  String get languageNameUrdu => 'اردو';

  @override
  String get navHistory => 'Cronologia';

  @override
  String get navPlans => 'Schede';

  @override
  String get navGraphs => 'Grafici';

  @override
  String get navTimer => 'Timer';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get errorLabel => 'Errore';

  @override
  String get tabContentError =>
      'Impossibile visualizzare il contenuto della scheda.';

  @override
  String get cannotHideAllTabs => 'Non puoi nascondere tutte le schede!';

  @override
  String removeTabQuestion(String tab) {
    return 'Rimuovere la scheda $tab?';
  }

  @override
  String get restoreTabFromSettings =>
      'Potrai aggiungerla di nuovo in seguito dalle impostazioni.';

  @override
  String removedTab(String tab) {
    return '$tab rimossa';
  }

  @override
  String newVersion(String version) {
    return 'Nuova versione $version';
  }

  @override
  String get changes => 'Novità';

  @override
  String get searchHint => 'Cerca...';

  @override
  String get deleteSelected => 'Elimina selezionati';

  @override
  String get confirmDelete => 'Conferma eliminazione';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Vuoi davvero eliminare $count record? Questa azione non può essere annullata.',
      one:
          'Vuoi davvero eliminare 1 record? Questa azione non può essere annullata.',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'Annulla';

  @override
  String get actionDelete => 'Elimina';

  @override
  String get actionRemove => 'Rimuovi';

  @override
  String get actionEdit => 'Modifica';

  @override
  String get actionShare => 'Condividi';

  @override
  String get clearSelection => 'Deseleziona tutto';

  @override
  String get clearSearch => 'Cancella ricerca';

  @override
  String get showMenu => 'Mostra menu';

  @override
  String get selectAll => 'Seleziona tutto';

  @override
  String get weightLabel => 'Peso';

  @override
  String get filter => 'Filtra';

  @override
  String get filters => 'Filtri';

  @override
  String get categoryLabel => 'Categoria';

  @override
  String get repsLabel => 'Ripetizioni';

  @override
  String get repsFilter => 'Filtro ripetizioni';

  @override
  String get weightFilter => 'Filtro peso';

  @override
  String get greaterThan => 'Maggiore di';

  @override
  String get lessThan => 'Minore di';

  @override
  String get startDate => 'Data di inizio';

  @override
  String get endDate => 'Data di fine';

  @override
  String get actionClear => 'Cancella';

  @override
  String get actionOk => 'OK';

  @override
  String get actionClose => 'Chiudi';

  @override
  String get sortBy => 'Ordina per';

  @override
  String get dateNewest => 'Data (più recenti)';

  @override
  String get dateOldest => 'Data (più vecchie)';

  @override
  String get nameLabel => 'Nome';

  @override
  String get missingPermissions => 'Autorizzazioni mancanti';

  @override
  String get restTimersPermissionsMissing =>
      'I timer di recupero sono attivi, ma mancano alcune autorizzazioni.';

  @override
  String get restTimersPermissionsOptional =>
      'Se disattivi i timer di recupero, queste autorizzazioni non sono necessarie.';

  @override
  String get restTimers => 'Timer di recupero';

  @override
  String get disableBatteryOptimizations => 'Disattiva ottimizzazione batteria';

  @override
  String get batteryOptimizationWarning =>
      'Il timer potrebbe interrompersi se l’ottimizzazione della batteria resta attiva.';

  @override
  String get scheduleExactAlarm => 'Programma allarme esatto';

  @override
  String get exactAlarmWarning =>
      'Gli allarmi non possono essere precisi se questa opzione è disattivata.';

  @override
  String get postNotifications => 'Mostra notifiche';

  @override
  String get notificationBarDescription =>
      'L’avanzamento del timer viene mostrato nella barra delle notifiche';

  @override
  String get invalidPermissions => 'Autorizzazioni non valide';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      'I timer di recupero sono attivi senza autorizzazioni sufficienti. Vuoi continuare?';

  @override
  String get actionConfirm => 'Conferma';

  @override
  String get appAccess => 'Accesso app';

  @override
  String get appAccessDescription => 'Necessario per timer e notifiche attivi.';

  @override
  String get notifications => 'Notifiche';

  @override
  String get timerProgressAndRestAlerts =>
      'Avanzamento timer e avvisi di recupero';

  @override
  String get enabledNotificationsDescription => 'Notifiche che hai attivato';

  @override
  String get backgroundActivity => 'Attività in background';

  @override
  String get backgroundActivityDescription =>
      'Mantiene affidabili i timer in background';

  @override
  String get exactAlarms => 'Allarmi esatti';

  @override
  String get exactAlarmsDescription =>
      'Avvisa esattamente quando termina un timer di recupero';

  @override
  String get noAdditionalAndroidAccessNeeded =>
      'Con le impostazioni attuali non è necessario alcun accesso Android aggiuntivo.';

  @override
  String get actionDone => 'Fatto';

  @override
  String get allowed => 'Consentito';

  @override
  String get actionAllow => 'Consenti';

  @override
  String get backupLabel => 'Backup';

  @override
  String get databaseLabel => 'Database';

  @override
  String get deleteRecords => 'Elimina record';

  @override
  String get deleteAllGraphsConfirmation =>
      'Vuoi davvero eliminare tutti i grafici? Questa azione non può essere annullata.';

  @override
  String get deleteAllPlansConfirmation =>
      'Vuoi davvero eliminare tutte le schede? Questa azione non può essere annullata.';

  @override
  String get deleteDatabaseConfirmation =>
      'Vuoi davvero eliminare il database? Questa azione non può essere annullata e cancellerà tutti i tuoi dati.';

  @override
  String get importData => 'Importa dati';

  @override
  String get exportData => 'Esporta dati';

  @override
  String get actionReport => 'Segnala';

  @override
  String get graphDataImported => 'Dati dei grafici importati correttamente!';

  @override
  String get plansImported => 'Schede importate correttamente';

  @override
  String failedToImportDatabase(String error) {
    return 'Impossibile importare il database: $error';
  }

  @override
  String get backupArchiveMissingDatabase =>
      'Il backup non contiene il database di Flexify.';

  @override
  String failedToImportGraphs(String error) {
    return 'Impossibile importare i grafici: $error';
  }

  @override
  String failedToImportPlans(String error) {
    return 'Impossibile importare le schede: $error';
  }

  @override
  String get selectedFileDoesNotExist => 'Il file selezionato non esiste';

  @override
  String get couldNotReadFileData => 'Impossibile leggere i dati del file';

  @override
  String get databaseImportWebUnsupported =>
      'L’importazione del database sul Web richiede una migrazione manuale dei dati. Esporta i dati come file CSV e importa quelli.';

  @override
  String get csvFileEmpty => 'Il file CSV è vuoto';

  @override
  String get csvNeedsDataRow =>
      'Il file CSV deve contenere almeno una riga di dati';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return 'La riga $row contiene colonne insufficienti: $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return 'Valore $field non valido alla riga $row: $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return 'Tipo di dati $field non valido alla riga $row: $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return 'Era previsto un ID scheda intero, ricevuto: \"$value\"';
  }

  @override
  String get unitLabel => 'Unità';

  @override
  String get kilogramsUnit => 'Chilogrammi (kg)';

  @override
  String get poundsUnit => 'Libbre (lb)';

  @override
  String get stoneUnit => 'Stone';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => 'Chilometri (km)';

  @override
  String get milesUnit => 'Miglia (mi)';

  @override
  String get metersUnit => 'Metri (m)';

  @override
  String get kilocaloriesUnit => 'Chilocalorie (kcal)';

  @override
  String get enterWeight => 'Inserisci peso';

  @override
  String get requiredField => 'Obbligatorio';

  @override
  String get invalidNumber => 'Numero non valido';

  @override
  String get previousWeight => 'Peso precedente';

  @override
  String get imageLabel => 'Immagine';

  @override
  String get longPressToDelete => 'Tieni premuto per eliminare';

  @override
  String get imageError => 'Errore immagine';

  @override
  String get actionSave => 'Salva';

  @override
  String get aboutTitle => 'Informazioni';

  @override
  String get donate => 'Fai una donazione';

  @override
  String get helpSupportProject => 'Aiuta a sostenere questo progetto';

  @override
  String get whatsNewAbout => 'Novità';

  @override
  String get whatsNewTitle => 'Novità';

  @override
  String get seeReleaseNotes => 'Vedi note di rilascio';

  @override
  String get versionLabel => 'Versione';

  @override
  String get authorLabel => 'Autore';

  @override
  String get privacyPolicy => 'Informativa sulla privacy';

  @override
  String get privacyPolicyDescription => 'Come Flexify gestisce i tuoi dati';

  @override
  String get licenseLabel => 'Licenza';

  @override
  String get sourceCode => 'Codice sorgente';

  @override
  String get sourceCodeDescription => 'Visualizza su GitHub';

  @override
  String get leaveReview => 'Lascia una recensione';

  @override
  String get leaveReviewDescription => 'Valuta Flexify sul Play Store';

  @override
  String get reportBug => 'Segnala un bug';

  @override
  String get reportBugDescription => 'Apri un ticket su GitHub';

  @override
  String get failedMigrations => 'Migrazioni non riuscite';

  @override
  String get errorMessageLabel => 'Messaggio di errore:';

  @override
  String get createIssue => 'Crea segnalazione';

  @override
  String get addExercise => 'Aggiungi esercizio';

  @override
  String get cardio => 'Cardio';

  @override
  String get strength => 'Forza';

  @override
  String get options => 'Opzioni';

  @override
  String get periodDay => 'Giorno';

  @override
  String get periodWeek => 'Settimana';

  @override
  String get periodMonth => 'Mese';

  @override
  String get periodYear => 'Anno';

  @override
  String noDataFor(String name) {
    return 'Ancora nessun dato per $name';
  }

  @override
  String get noDataYet => 'Ancora nessun dato';

  @override
  String get exerciseNotes => 'Note esercizio';

  @override
  String get notesForExercise => 'Note per questo esercizio';

  @override
  String get useTimeBasedXAxis => 'Usa asse X basato sul tempo';

  @override
  String updateAllNamed(String name) {
    return 'Aggiorna tutti i record $name';
  }

  @override
  String get newName => 'Nuovo nome';

  @override
  String get restMinutes => 'Minuti di recupero';

  @override
  String get restSeconds => 'Secondi di recupero';

  @override
  String get globalProgress => 'Progresso globale';

  @override
  String get curveLineGraphs => 'Smussa linee dei grafici';

  @override
  String get curveLineGraphsDescription =>
      'Disegna le linee dei grafici come curve morbide';

  @override
  String noHistoryFor(String name) {
    return 'Ancora nessuna cronologia per $name';
  }

  @override
  String get cancelSelection => 'Annulla selezione';

  @override
  String get editSelected => 'Modifica selezionati';

  @override
  String get newExercise => 'Nuovo esercizio';

  @override
  String get noGraphsFound => 'Nessun grafico trovato';

  @override
  String get searchGraphs => 'Cerca grafici...';

  @override
  String get actionAdd => 'Aggiungi';

  @override
  String get actionUpdate => 'Aggiorna';

  @override
  String get hideGlobalProgress => 'Nascondi progresso globale';

  @override
  String get chartGroupedByCategory => 'Grafico raggruppato per categoria';

  @override
  String get noExercisesFound => 'Nessun esercizio trovato';

  @override
  String get savePlan => 'Salva scheda';

  @override
  String get titleOptional => 'Titolo (facoltativo)';

  @override
  String get searchExercises => 'Cerca esercizi...';

  @override
  String get warmupSets => 'Serie di riscaldamento';

  @override
  String get workingSetsMax => 'Serie allenanti (max: 20)';

  @override
  String get actionUndo => 'Annulla';

  @override
  String get actionSwap => 'Sostituisci';

  @override
  String get daily => 'Giornaliero';

  @override
  String get weekly => 'Settimanale';

  @override
  String get monthly => 'Mensile';

  @override
  String get yearly => 'Annuale';

  @override
  String get unexpectedError => 'Qualcosa è andato storto. Riprova.';

  @override
  String get loadingExercises => 'Caricamento esercizi...';

  @override
  String get noPlansYet => 'Ancora nessuna scheda';

  @override
  String get noMatchingPlans => 'Nessuna scheda corrispondente';

  @override
  String get newPlan => 'Nuova scheda';

  @override
  String get searchPlans => 'Cerca schede...';

  @override
  String get noExercisesYet => 'Ancora nessun esercizio';

  @override
  String get editPlan => 'Modifica scheda';

  @override
  String get saveSet => 'Salva serie';

  @override
  String get minutesLabel => 'Minuti';

  @override
  String get minutesShort => 'min';

  @override
  String get secondsLabel => 'Secondi';

  @override
  String get distanceLabel => 'Distanza';

  @override
  String get inclinePercent => 'Pendenza %';

  @override
  String weightWithUnit(String unit) {
    return 'Peso ($unit)';
  }

  @override
  String get useBodyWeight => 'Usa peso corporeo';

  @override
  String get noWeightEnteredYet => 'Nessun peso ancora inserito';

  @override
  String get notesLabel => 'Note';

  @override
  String get swapWorkout => 'Sostituisci esercizio';

  @override
  String get addSet => 'Aggiungi serie';

  @override
  String get deleteSet => 'Elimina serie';

  @override
  String get oneRepMaxEstimate => 'Massimale 1RM (stima)';

  @override
  String get valueLabel => 'Valore';

  @override
  String amountWithUnit(String unit) {
    return 'Quantità ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return 'Distanza ($unit)';
  }

  @override
  String get bodyWeightLabel => 'Peso corporeo';

  @override
  String bodyWeightWithUnit(String unit) {
    return 'Peso corporeo ($unit)';
  }

  @override
  String get categoryHelper =>
      'Scegli una categoria esistente o inseriscine una nuova.';

  @override
  String get manageCategories => 'Gestisci categorie';

  @override
  String get manageCategoriesDescription =>
      'Crea, rinomina, unisci o rimuovi categorie';

  @override
  String get newCategory => 'Nuova categoria';

  @override
  String get renameCategory => 'Rinomina categoria';

  @override
  String get mergeCategory => 'Unisci a un\'altra categoria';

  @override
  String get noCategories => 'Nessuna categoria';

  @override
  String get categoryNameRequired => 'Inserisci un nome per la categoria';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Usata da $count voci',
      one: 'Usata da 1 voce',
      zero: 'Non usata da nessuna voce',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Eliminare questa categoria e rimuoverla da $count voci?',
      one: 'Eliminare questa categoria e rimuoverla da 1 voce?',
      zero: 'Eliminare questa categoria?',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => 'Data di creazione';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Modifica $count serie',
      one: 'Modifica 1 serie',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => 'Ancora nessuna voce';

  @override
  String get historyEmptyMessage =>
      'Completa una serie o aggiungine una manualmente per iniziare la cronologia.';

  @override
  String deleteSetConfirmation(String name) {
    return 'Vuoi davvero eliminare $name?';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vuoi davvero eliminare $count voci?',
      one: 'Vuoi davvero eliminare 1 voce?',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => 'Cerca nella cronologia...';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeDark => 'Scuro';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get pureBlackAmoled => 'Nero puro (AMOLED)';

  @override
  String get showImages => 'Mostra immagini';

  @override
  String get peekGraph => 'Anteprima grafico';

  @override
  String get inputStyleLine => 'Linea';

  @override
  String get inputStyleOutlined => 'Contorno';

  @override
  String get inputStyleFilled => 'Riempito';

  @override
  String get inputStyle => 'Stile dei campi';

  @override
  String get appearance => 'Aspetto';

  @override
  String get automaticBackupsEnabled => 'Backup automatici attivati';

  @override
  String get automaticBackup => 'Backup automatico';

  @override
  String get appPermissions => 'Autorizzazioni app';

  @override
  String get shareDatabase => 'Condividi database';

  @override
  String get dataManagement => 'Gestione dati';

  @override
  String get strengthUnit => 'Unità di peso';

  @override
  String get lastEntry => 'Ultima voce';

  @override
  String get cardioUnit => 'Unità cardio';

  @override
  String longDateFormat(String format) {
    return 'Formato data lungo ($format)';
  }

  @override
  String get formats => 'Formati';

  @override
  String get setsPerExerciseMax => 'Serie per esercizio (max: 20)';

  @override
  String get countLabel => 'Conteggio';

  @override
  String get ratioLabel => 'Rapporto';

  @override
  String get reorder => 'Riordina';

  @override
  String get none => 'Nessuno';

  @override
  String get monday => 'Lunedì';

  @override
  String get examplePlanExercises => 'Panca piana, Squat, Stacco da terra';

  @override
  String get tabs => 'Schede';

  @override
  String get swipeBetweenTabs => 'Scorri tra le schede';

  @override
  String get vibrate => 'Vibrazione';

  @override
  String get enableSound => 'Attiva suono';

  @override
  String get keepScreenOn => 'Mantieni schermo acceso';

  @override
  String get alarmSound => 'Suono allarme';

  @override
  String get top => 'In alto';

  @override
  String get bottom => 'In basso';

  @override
  String get removeCustomTimer =>
      'Rimuovi timer personalizzato (usa valore globale)';

  @override
  String get timers => 'Timer';

  @override
  String get timerSettings => 'Impostazioni timer';

  @override
  String get groupHistory => 'Raggruppa cronologia';

  @override
  String get showUnits => 'Mostra unità';

  @override
  String get showBodyWeight => 'Mostra peso corporeo';

  @override
  String get showCategories => 'Mostra categorie';

  @override
  String get showNotes => 'Mostra note';

  @override
  String get repEstimation => 'Stima ripetizioni';

  @override
  String get durationEstimation => 'Stima durata';

  @override
  String get showGraphLimit => 'Mostra limite grafico';

  @override
  String get defaultGraphMetric => 'Metrica grafico predefinita';

  @override
  String get bestWeight => 'Peso migliore';

  @override
  String get bestReps => 'Migliori ripetizioni';

  @override
  String get oneRepMax => 'Massimale 1RM';

  @override
  String get volume => 'Volume';

  @override
  String get paceCardio => 'Passo (cardio)';

  @override
  String get distanceCardio => 'Distanza (cardio)';

  @override
  String get defaultGraphPeriod => 'Periodo grafico predefinito';

  @override
  String get defaultGraphLimit => 'Limite grafico predefinito';

  @override
  String get workouts => 'Allenamenti';

  @override
  String get actionStop => 'Ferma';

  @override
  String get timerFinishedToast => 'Timer terminato!';

  @override
  String get stopTimer => 'Ferma timer';

  @override
  String get actionPause => 'Pausa';

  @override
  String get startStopwatch => 'Avvia cronometro';

  @override
  String get actionStart => 'Avvia';

  @override
  String get actionRestart => 'Riavvia';

  @override
  String get addOneMinute => '+1 minuto';

  @override
  String get addOneMinuteNotification => 'Aggiungi 1 min';

  @override
  String get restTimer => 'Timer di recupero';

  @override
  String get timerUp => 'Tempo scaduto';

  @override
  String get openNotification => 'Apri notifica';

  @override
  String get timerChannelName => 'Canale timer';

  @override
  String get timerChannelDescription =>
      'Avanzamento continuo dei timer di recupero.';

  @override
  String get timerFinishedChannelName => 'Canale timer terminati';

  @override
  String get timerFinishedChannelDescription =>
      'Riproduce un allarme quando termina un timer di recupero.';

  @override
  String get timerFinished => 'Timer terminato';

  @override
  String get batteryOptimizationRequestUnavailable =>
      'Le richieste per ignorare l’ottimizzazione della batteria sono disattivate sul dispositivo.';

  @override
  String get exactAlarmRequestUnavailable =>
      'La richiesta SCHEDULE_EXACT_ALARM è stata rifiutata sul dispositivo';

  @override
  String get databaseMigrationFailureDescription =>
      'Si è verificato un problema durante la creazione o l’aggiornamento del database. Di solito si risolve eliminando e ricreando i record.';

  @override
  String get curveSmoothness => 'Smussatura curva';

  @override
  String get actionBack => 'Indietro';

  @override
  String get atLeastOneTab => 'Devi mantenere almeno una scheda';

  @override
  String get invalidTabSettings => 'Impostazioni delle schede non valide.';

  @override
  String get noSettingsFound => 'Nessuna impostazione trovata';

  @override
  String nothingMatchesSearch(String query) {
    return 'Nessun risultato per “$query”.';
  }

  @override
  String get appearanceDescription => 'Tema, colori e stile dell’interfaccia';

  @override
  String get dataManagementDescription =>
      'Importa, esporta e gestisci i dati di allenamento';

  @override
  String get formatsDescription => 'Formati di date, numeri e misure';

  @override
  String get plansSettingsDescription =>
      'Valori predefiniti e comportamento delle schede di allenamento';

  @override
  String get tabsDescription =>
      'Scegli e organizza le schede di navigazione principali';

  @override
  String get timersDescription =>
      'Durata, suono e comportamento del timer di recupero';

  @override
  String get workoutsDescription =>
      'Monitoraggio esercizi e preferenze di allenamento';

  @override
  String get completeSetForChart =>
      'Completa una serie di questo esercizio per creare il grafico.';

  @override
  String get dateRange => 'Intervallo date';

  @override
  String get stopDate => 'Data di fine';

  @override
  String get dataPoints => 'Punti dati';

  @override
  String get completeSetsForProgress =>
      'Completa alcune serie per creare il grafico dei progressi.';

  @override
  String get relativeStrength => 'Forza relativa';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selezionati',
      one: '1 selezionato',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory =>
      'Completa alcune serie per vedere qui la cronologia di questo esercizio.';

  @override
  String get completeSetForFirstGraph =>
      'Completa una serie per creare il primo grafico dell’esercizio.';

  @override
  String nothingMatchesGraphSearch(String query) {
    return 'Nessun risultato per “$query”. Puoi crearlo come nuovo esercizio.';
  }

  @override
  String addNamed(String name) {
    return 'Aggiungi “$name”';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return 'Verranno eliminati $count record. Vuoi continuare?';
  }

  @override
  String shareWorkout(String summary) {
    return 'Ho appena fatto $summary';
  }

  @override
  String get updateConflict => 'Conflitto di aggiornamento';

  @override
  String updateConflictDescription(int count) {
    return 'Il nuovo nome esiste già per $count record. Vuoi continuare?';
  }

  @override
  String get unitsConflict => 'Conflitto di unità';

  @override
  String unitsConflictDescription(String unit) {
    return 'Non tutti i record usano la stessa unità. Tutte le unità verranno convertite in $unit. Vuoi continuare?';
  }

  @override
  String get durationLabel => 'Durata';

  @override
  String get inclineLabel => 'Pendenza';

  @override
  String get paceDistanceTime => 'Passo (distanza / tempo)';

  @override
  String get adjustedPace => 'Passo corretto';

  @override
  String get oneRepMaxAccuracyWarning =>
      'Le stime del massimale 1RM sono meno precise per serie da 10 o più ripetizioni';

  @override
  String get addPlan => 'Aggiungi scheda';

  @override
  String get planDetails => 'Dettagli scheda';

  @override
  String get exercisesLabel => 'Esercizi';

  @override
  String get addExerciseToPlan => 'Aggiungi un esercizio a questa scheda.';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return 'Nessun risultato per “$query”. Puoi aggiungerlo come nuovo esercizio.';
  }

  @override
  String get selectDays => 'Seleziona giorni';

  @override
  String get selectExercises => 'Seleziona esercizi';

  @override
  String get todayLabel => 'Oggi';

  @override
  String get setDetails => 'Dettagli serie';

  @override
  String get themeLabel => 'Tema';

  @override
  String get pureBlackAmoledDescription => 'Usa nero puro sui display AMOLED';

  @override
  String get systemColorScheme => 'Colori di sistema';

  @override
  String get systemColorSchemeDescription =>
      'Usa il colore principale del dispositivo nell’app';

  @override
  String get showImagesDescription =>
      'Scegli e mostra immagini nella pagina cronologia';

  @override
  String get showGlobalProgress => 'Mostra progresso globale';

  @override
  String get showGlobalProgressDescription =>
      'Aggiungi un grafico che mostra i progressi per categoria';

  @override
  String get peekGraphDescription =>
      'Mostra il primo grafico a linee nella pagina dei grafici';

  @override
  String get inputStyleDescription => 'Stile visivo dei campi di testo';

  @override
  String get automaticBackupNotificationBody =>
      'Flexify eseguirà automaticamente ogni giorno il backup di dati e immagini nella cartella selezionata.';

  @override
  String get backupSettingsChannel => 'Impostazioni backup';

  @override
  String get backupSettingsChannelDescription =>
      'Notifiche relative ai backup automatici';

  @override
  String get backupChannelName => 'Canale backup';

  @override
  String get backupChannelDescription =>
      'Backup automatici di dati e immagini di Flexify';

  @override
  String get backupCompletedTitle => 'Dati e immagini salvati';

  @override
  String get backupFailurePathNotSet =>
      'Backup non riuscito: percorso di backup non impostato. I backup automatici sono stati disattivati.';

  @override
  String get backupFailureDirectoryUnavailable =>
      'Backup non riuscito: impossibile accedere alla cartella di backup. I backup automatici sono stati disattivati.';

  @override
  String get backupFailureCreateFile =>
      'Backup non riuscito: impossibile creare il file di backup. I backup automatici sono stati disattivati.';

  @override
  String get backupFailureAppFilesUnavailable =>
      'Backup non riuscito: impossibile accedere alla cartella dei file dell’app. I backup automatici sono stati disattivati.';

  @override
  String get backupFailureDatabaseMissing =>
      'Backup non riuscito: file del database non trovato. I backup automatici sono stati disattivati.';

  @override
  String get backupFailureOutputUnavailable =>
      'Backup non riuscito: impossibile aprire il flusso di output. I backup automatici sono stati disattivati.';

  @override
  String get backupFailureUnknown =>
      'Backup non riuscito. I backup automatici sono stati disattivati.';

  @override
  String get appPermissionsDescription =>
      'Controlla gli accessi richiesti dalle funzioni attive';

  @override
  String get longDateFormatDescription => 'Usato quando c’è spazio sufficiente';

  @override
  String shortDateFormat(String example) {
    return 'Formato data breve ($example)';
  }

  @override
  String get shortDateFormatDescription =>
      'Per gli spazi ridotti (linee dei grafici)';

  @override
  String get warmupSetsDescription =>
      'Le serie di riscaldamento non avviano timer di recupero';

  @override
  String get setsPerExerciseDescription =>
      'Numero predefinito di serie per ogni esercizio in una scheda';

  @override
  String get planTrailingDisplay => 'Info laterali della scheda';

  @override
  String get planTrailingDisplayDescription =>
      'Informazioni mostrate a destra nell’elenco e nella vista della scheda';

  @override
  String get restTimersDescription =>
      'Allarme che parte dopo aver completato una serie';

  @override
  String get vibrateDescription => 'Fai vibrare i timer di recupero';

  @override
  String get enableSoundDescription =>
      'Riproduci un suono per i timer di recupero';

  @override
  String get keepScreenOnDescription =>
      'Mantieni lo schermo acceso durante i timer di recupero';

  @override
  String get restDurationDescription =>
      'Tempo prima che scatti l’allarme di recupero';

  @override
  String get globalDefault => 'Predefinito globale';

  @override
  String get alarmSoundDescription =>
      'Suono riprodotto al termine di un timer di recupero';

  @override
  String get progressBarPosition => 'Posizione barra di avanzamento';

  @override
  String get progressBarPositionDescription =>
      'Dove mostrare la barra di avanzamento dei timer di recupero';

  @override
  String get perExerciseRestTimes => 'Tempi di recupero per esercizio';

  @override
  String get perExerciseRestTimesDescription =>
      'Questi esercizi hanno tempi di recupero personalizzati';

  @override
  String get audioFeaturesUnavailable =>
      'Le funzioni audio non sono disponibili';

  @override
  String get groupHistoryDescription =>
      'Raggruppa le voci della cronologia per giorno';

  @override
  String get showUnitsDescription =>
      'Mostra km/mi e kg/lb in grafici, cronologia e schede';

  @override
  String get showBodyWeightDescription =>
      'Attiva o disattiva il monitoraggio del peso corporeo';

  @override
  String get showCategoriesDescription =>
      'Attiva o disattiva le categorie di allenamento';

  @override
  String get showNotesDescription =>
      'Registra i dettagli della serie in un campo di testo';

  @override
  String get positiveNotificationsDescription =>
      'Mostra messaggi motivazionali quando stabilisci un nuovo record';

  @override
  String get positiveMessagesEnabled =>
      'I messaggi motivazionali appariranno così!';

  @override
  String get recordEncouragement01 => 'Ottimo lavoro! Sei incredibile.';

  @override
  String get recordEncouragement02 =>
      'Grande! I tuoi progressi sono d’ispirazione.';

  @override
  String get recordEncouragement03 => 'Mi inchino...';

  @override
  String get recordEncouragement04 => 'Cos’è? Un nuovo record!';

  @override
  String get recordEncouragement05 => 'Incredibile! Sei un’ispirazione.';

  @override
  String get recordEncouragement06 => 'Wow. Grande.';

  @override
  String get recordEncouragement07 => 'Sempre più forte, eh?';

  @override
  String get recordEncouragement08 => 'Sì. Stai diventando davvero forte.';

  @override
  String get recordEncouragement09 => 'Fantastico. Incredibile.';

  @override
  String get recordEncouragement10 => 'Arnie sarebbe fiero.';

  @override
  String get recordEncouragement11 => 'Ronnie C ti guarda soddisfatto.';

  @override
  String get recordEncouragement12 => 'YEAH! LIGHTWEIGHT, BABY!!!!!!!';

  @override
  String get recordEncouragement13 =>
      'È un nuovo record? Sapevo che ce l’avresti fatta.';

  @override
  String get recordEncouragement14 => 'Ottimo lavoro! Sono fiero di te.';

  @override
  String get recordEncouragement15 => 'Sì! Leggerissimo!';

  @override
  String get recordEncouragement16 => 'Continua così! Ottimi progressi.';

  @override
  String get recordEncouragement17 => 'Stai andando alla grande.';

  @override
  String get recordEncouragement18 => 'Questo è il mio campione!';

  @override
  String get recordEncouragement19 => 'Continua così.';

  @override
  String get recordEncouragement20 => 'Stai diventando davvero forte.';

  @override
  String get recordEncouragement21 => 'Potente.';

  @override
  String get recordEncouragement22 => 'Che potenza!';

  @override
  String get recordEncouragement23 => 'Sono fiero di te.';

  @override
  String get recordEncouragement24 => 'Continua con questo ottimo lavoro.';

  @override
  String get recordEncouragement25 =>
      'A testa alta! Hai appena stabilito un nuovo record.';

  @override
  String get recordEncouragement26 =>
      'Nuovo record! Sei andato oltre ogni volta precedente!';

  @override
  String get recordEncouragement27 => 'Sì! È un record.';

  @override
  String get recordEncouragement28 => 'Wow! Nuovo record!';

  @override
  String get recordEncouragement29 => 'Davvero ottimo.';

  @override
  String get repEstimationDescription =>
      'Prova a prevedere quante ripetizioni hai appena fatto';

  @override
  String get durationEstimationDescription =>
      'Prova a prevedere la durata del cardio';

  @override
  String get showGraphXAxisToggle => 'Mostra selettore asse X';

  @override
  String get showGraphXAxisToggleDescription =>
      'Mostra nei grafici il selettore dell’asse X basato sul tempo';

  @override
  String get showGraphLimitDescription =>
      'Mostra il cursore del limite nei grafici';

  @override
  String get defaultTimeBasedXAxis => 'Asse X temporale predefinito';

  @override
  String get defaultTimeBasedXAxisDescription =>
      'Usa per impostazione predefinita un asse X basato sul tempo nei grafici';

  @override
  String get createFirstTrainingPlan =>
      'Crea la tua prima scheda di allenamento per iniziare.';

  @override
  String nothingMatchesPlanSearch(String query) {
    return 'Nessun risultato per “$query”. Puoi crearlo come nuova scheda.';
  }

  @override
  String get createPlan => 'Crea scheda';

  @override
  String createNamedPlan(String name) {
    return 'Crea “$name”';
  }

  @override
  String setNumber(int number) {
    return 'Serie $number';
  }
}
