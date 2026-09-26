// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageDescription =>
      'Choisissez la langue utilisée par Flexify';

  @override
  String get languageSystemDefault => 'Langue du système';

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
  String get languageNamePersian => 'فارسی';

  @override
  String get languageNameThai => 'ไทย';

  @override
  String get languageNameMalay => 'Bahasa Melayu';

  @override
  String get navHistory => 'Historique';

  @override
  String get navPlans => 'Programmes';

  @override
  String get navGraphs => 'Graphiques';

  @override
  String get navTimer => 'Minuteur';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get errorLabel => 'Erreur';

  @override
  String get tabContentError => 'Impossible d’afficher le contenu de l’onglet.';

  @override
  String get cannotHideAllTabs => 'Impossible de tout masquer !';

  @override
  String removeTabQuestion(String tab) {
    return 'Retirer l’onglet $tab ?';
  }

  @override
  String get restoreTabFromSettings =>
      'Vous pourrez le rajouter plus tard depuis les paramètres.';

  @override
  String removedTab(String tab) {
    return '$tab retiré';
  }

  @override
  String newVersion(String version) {
    return 'Nouvelle version $version';
  }

  @override
  String get changes => 'Nouveautés';

  @override
  String get searchHint => 'Rechercher...';

  @override
  String get deleteSelected => 'Supprimer la sélection';

  @override
  String get confirmDelete => 'Confirmer la suppression';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Voulez-vous vraiment supprimer $count enregistrements ? Cette action est irréversible.',
      one:
          'Voulez-vous vraiment supprimer 1 enregistrement ? Cette action est irréversible.',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionDelete => 'Supprimer';

  @override
  String get actionRemove => 'Retirer';

  @override
  String get actionEdit => 'Modifier';

  @override
  String get actionShare => 'Partager';

  @override
  String get clearSelection => 'Effacer la sélection';

  @override
  String get clearSearch => 'Effacer la recherche';

  @override
  String get showMenu => 'Afficher le menu';

  @override
  String get selectAll => 'Tout sélectionner';

  @override
  String get weightLabel => 'Poids';

  @override
  String get filter => 'Filtrer';

  @override
  String get filters => 'Filtres';

  @override
  String get categoryLabel => 'Catégorie';

  @override
  String get repsLabel => 'Répétitions';

  @override
  String get repsFilter => 'Filtre de répétitions';

  @override
  String get weightFilter => 'Filtre de poids';

  @override
  String get greaterThan => 'Supérieur à';

  @override
  String get lessThan => 'Inférieur à';

  @override
  String get startDate => 'Date de début';

  @override
  String get endDate => 'Date de fin';

  @override
  String get actionClear => 'Effacer';

  @override
  String get actionOk => 'OK';

  @override
  String get actionClose => 'Fermer';

  @override
  String get sortBy => 'Trier par';

  @override
  String get dateNewest => 'Date (plus récentes)';

  @override
  String get dateOldest => 'Date (plus anciennes)';

  @override
  String get nameLabel => 'Nom';

  @override
  String get missingPermissions => 'Autorisations manquantes';

  @override
  String get restTimersPermissionsMissing =>
      'Les minuteurs de repos sont activés, mais certaines autorisations manquent.';

  @override
  String get restTimersPermissionsOptional =>
      'Si vous désactivez les minuteurs de repos, ces autorisations ne sont pas nécessaires.';

  @override
  String get restTimers => 'Minuteurs de repos';

  @override
  String get disableBatteryOptimizations =>
      'Désactiver l’optimisation de la batterie';

  @override
  String get batteryOptimizationWarning =>
      'La progression peut s’interrompre si l’optimisation de la batterie reste activée.';

  @override
  String get scheduleExactAlarm => 'Programmer une alarme exacte';

  @override
  String get exactAlarmWarning =>
      'Les alarmes ne peuvent pas être précises si cette option est désactivée.';

  @override
  String get postNotifications => 'Afficher les notifications';

  @override
  String get notificationBarDescription =>
      'La progression du minuteur est affichée dans la barre de notifications';

  @override
  String get invalidPermissions => 'Autorisations non valides';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      'Les minuteurs de repos sont activés sans les autorisations nécessaires. Continuer ?';

  @override
  String get actionConfirm => 'Confirmer';

  @override
  String get appAccess => 'Accès de l’application';

  @override
  String get appAccessDescription =>
      'Nécessaire pour les minuteurs et notifications activés.';

  @override
  String get notifications => 'Notifications';

  @override
  String get timerProgressAndRestAlerts =>
      'Progression du minuteur et alertes de repos';

  @override
  String get enabledNotificationsDescription =>
      'Notifications que vous avez activées';

  @override
  String get backgroundActivity => 'Activité en arrière-plan';

  @override
  String get backgroundActivityDescription =>
      'Maintient les minuteurs fiables en arrière-plan';

  @override
  String get exactAlarms => 'Alarmes exactes';

  @override
  String get exactAlarmsDescription =>
      'Alerte exactement à la fin d’un minuteur de repos';

  @override
  String get noAdditionalAndroidAccessNeeded =>
      'Aucun accès Android supplémentaire n’est nécessaire avec vos paramètres actuels.';

  @override
  String get actionDone => 'Terminé';

  @override
  String get allowed => 'Autorisé';

  @override
  String get actionAllow => 'Autoriser';

  @override
  String get backupLabel => 'Sauvegarde';

  @override
  String get databaseLabel => 'Base de données';

  @override
  String get deleteRecords => 'Supprimer des enregistrements';

  @override
  String get deleteAllGraphsConfirmation =>
      'Voulez-vous vraiment supprimer tous les graphiques ? Cette action est irréversible.';

  @override
  String get deleteAllPlansConfirmation =>
      'Voulez-vous vraiment supprimer tous les programmes ? Cette action est irréversible.';

  @override
  String get deleteDatabaseConfirmation =>
      'Voulez-vous vraiment supprimer votre base de données ? Cette action est irréversible et supprimera toutes vos données.';

  @override
  String get importData => 'Importer des données';

  @override
  String get exportData => 'Exporter des données';

  @override
  String get actionReport => 'Signaler';

  @override
  String get graphDataImported =>
      'Données de graphiques importées avec succès !';

  @override
  String get plansImported => 'Programmes importés avec succès';

  @override
  String failedToImportDatabase(String error) {
    return 'Échec de l’importation de la base de données : $error';
  }

  @override
  String get backupArchiveMissingDatabase =>
      'La sauvegarde ne contient pas la base de données Flexify.';

  @override
  String failedToImportGraphs(String error) {
    return 'Échec de l’importation des graphiques : $error';
  }

  @override
  String failedToImportPlans(String error) {
    return 'Échec de l’importation des programmes : $error';
  }

  @override
  String get selectedFileDoesNotExist => 'Le fichier sélectionné n’existe pas';

  @override
  String get couldNotReadFileData =>
      'Impossible de lire les données du fichier';

  @override
  String get databaseImportWebUnsupported =>
      'L’importation d’une base de données sur le Web nécessite une migration manuelle des données. Exportez vos données sous forme de fichiers CSV, puis importez-les.';

  @override
  String get csvFileEmpty => 'Le fichier CSV est vide';

  @override
  String get csvNeedsDataRow =>
      'Le fichier CSV doit contenir au moins une ligne de données';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return 'La ligne $row ne contient pas assez de colonnes : $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return 'Valeur $field non valide à la ligne $row : $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return 'Type de données $field non valide à la ligne $row : $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return 'Un identifiant de programme entier était attendu, valeur reçue : \"$value\"';
  }

  @override
  String get unitLabel => 'Unité';

  @override
  String get kilogramsUnit => 'Kilogrammes (kg)';

  @override
  String get poundsUnit => 'Livres (lb)';

  @override
  String get stoneUnit => 'Stone';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => 'Kilomètres (km)';

  @override
  String get milesUnit => 'Miles (mi)';

  @override
  String get metersUnit => 'Mètres (m)';

  @override
  String get kilocaloriesUnit => 'Kilocalories (kcal)';

  @override
  String get enterWeight => 'Saisir le poids';

  @override
  String get requiredField => 'Obligatoire';

  @override
  String get invalidNumber => 'Nombre non valide';

  @override
  String get previousWeight => 'Poids précédent';

  @override
  String get imageLabel => 'Image';

  @override
  String get longPressToDelete => 'Appui long pour supprimer';

  @override
  String get imageError => 'Erreur d’image';

  @override
  String get actionSave => 'Enregistrer';

  @override
  String get aboutTitle => 'À propos';

  @override
  String get donate => 'Faire un don';

  @override
  String get helpSupportProject => 'Soutenez ce projet';

  @override
  String get whatsNewAbout => 'Quoi de neuf ?';

  @override
  String get whatsNewTitle => 'Quoi de neuf ?';

  @override
  String get seeReleaseNotes => 'Voir les notes de version';

  @override
  String get versionLabel => 'Version';

  @override
  String get authorLabel => 'Auteur';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get privacyPolicyDescription => 'Comment Flexify traite vos données';

  @override
  String get licenseLabel => 'Licence';

  @override
  String get sourceCode => 'Code source';

  @override
  String get sourceCodeDescription => 'Voir sur GitHub';

  @override
  String get leaveReview => 'Laisser un avis';

  @override
  String get leaveReviewDescription => 'Noter Flexify sur le Play Store';

  @override
  String get reportBug => 'Signaler un bug';

  @override
  String get reportBugDescription => 'Ouvrir un ticket sur GitHub';

  @override
  String get failedMigrations => 'Échec des migrations';

  @override
  String get errorMessageLabel => 'Message d’erreur :';

  @override
  String get createIssue => 'Créer un ticket';

  @override
  String get addExercise => 'Ajouter un exercice';

  @override
  String get cardio => 'Cardio';

  @override
  String get strength => 'Musculation';

  @override
  String get options => 'Options';

  @override
  String get periodDay => 'Jour';

  @override
  String get periodWeek => 'Semaine';

  @override
  String get periodMonth => 'Mois';

  @override
  String get periodYear => 'Année';

  @override
  String noDataFor(String name) {
    return 'Pas encore de données pour $name';
  }

  @override
  String get noDataYet => 'Pas encore de données';

  @override
  String get exerciseNotes => 'Notes de l’exercice';

  @override
  String get notesForExercise => 'Notes pour cet exercice';

  @override
  String get useTimeBasedXAxis => 'Utiliser un axe X basé sur le temps';

  @override
  String updateAllNamed(String name) {
    return 'Mettre à jour tous les $name';
  }

  @override
  String get newName => 'Nouveau nom';

  @override
  String get restMinutes => 'Minutes de repos';

  @override
  String get restSeconds => 'Secondes de repos';

  @override
  String get globalProgress => 'Progression globale';

  @override
  String get curveLineGraphs => 'Courber les lignes des graphiques';

  @override
  String get curveLineGraphsDescription =>
      'Dessiner les lignes des graphiques sous forme de courbes lisses';

  @override
  String noHistoryFor(String name) {
    return 'Pas encore d’historique pour $name';
  }

  @override
  String get cancelSelection => 'Annuler la sélection';

  @override
  String get editSelected => 'Modifier la sélection';

  @override
  String get noGraphsFound => 'Aucun graphique trouvé';

  @override
  String get searchGraphs => 'Rechercher des graphiques...';

  @override
  String get actionAdd => 'Ajouter';

  @override
  String get actionUpdate => 'Mettre à jour';

  @override
  String get hideGlobalProgress => 'Masquer la progression globale';

  @override
  String get chartGroupedByCategory => 'Graphique regroupé par catégorie';

  @override
  String get noExercisesFound => 'Aucun exercice trouvé';

  @override
  String get savePlan => 'Enregistrer le programme';

  @override
  String get titleOptional => 'Titre (facultatif)';

  @override
  String get searchExercises => 'Rechercher des exercices...';

  @override
  String get warmupSets => 'Séries d’échauffement';

  @override
  String get workingSetsMax => 'Séries de travail (max. : 20)';

  @override
  String get actionUndo => 'Annuler';

  @override
  String get actionSwap => 'Remplacer';

  @override
  String get daily => 'Quotidien';

  @override
  String get weekly => 'Hebdomadaire';

  @override
  String get monthly => 'Mensuel';

  @override
  String get yearly => 'Annuel';

  @override
  String get unexpectedError =>
      'Une erreur s’est produite. Veuillez réessayer.';

  @override
  String get loadingExercises => 'Chargement des exercices...';

  @override
  String get noPlansYet => 'Aucun programme pour le moment';

  @override
  String get noMatchingPlans => 'Aucun programme correspondant';

  @override
  String get newPlan => 'Nouveau programme';

  @override
  String get searchPlans => 'Rechercher des programmes...';

  @override
  String get noExercisesYet => 'Aucun exercice pour le moment';

  @override
  String get editPlan => 'Modifier le programme';

  @override
  String get saveSet => 'Enregistrer la série';

  @override
  String get minutesLabel => 'Minutes';

  @override
  String get minutesShort => 'min';

  @override
  String get secondsLabel => 'Secondes';

  @override
  String get distanceLabel => 'Distance';

  @override
  String get inclinePercent => 'Inclinaison %';

  @override
  String weightWithUnit(String unit) {
    return 'Poids ($unit)';
  }

  @override
  String get useBodyWeight => 'Utiliser le poids du corps';

  @override
  String get noWeightEnteredYet => 'Aucun poids n’a encore été saisi';

  @override
  String get notesLabel => 'Notes';

  @override
  String get swapWorkout => 'Remplacer l’exercice';

  @override
  String get addSet => 'Ajouter une série';

  @override
  String get deleteSet => 'Supprimer la série';

  @override
  String get oneRepMaxEstimate => 'Maximum sur 1 répétition (estimé)';

  @override
  String get valueLabel => 'Valeur';

  @override
  String amountWithUnit(String unit) {
    return 'Quantité ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return 'Distance ($unit)';
  }

  @override
  String get bodyWeightLabel => 'Poids du corps';

  @override
  String bodyWeightWithUnit(String unit) {
    return 'Poids du corps ($unit)';
  }

  @override
  String get categoryHelper =>
      'Choisissez une catégorie existante ou saisissez-en une nouvelle.';

  @override
  String get manageCategories => 'Gérer les catégories';

  @override
  String get manageCategoriesDescription =>
      'Créer, renommer, fusionner ou supprimer des catégories';

  @override
  String get newCategory => 'Nouvelle catégorie';

  @override
  String get renameCategory => 'Renommer la catégorie';

  @override
  String get mergeCategory => 'Fusionner avec une autre catégorie';

  @override
  String get noCategories => 'Aucune catégorie pour le moment';

  @override
  String get categoryNameRequired => 'Saisissez un nom de catégorie';

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Supprimer cette catégorie et la retirer de $count entrées ?',
      one: 'Supprimer cette catégorie et la retirer de 1 entrée ?',
      zero: 'Supprimer cette catégorie ?',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => 'Date de création';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Modifier $count séries',
      one: 'Modifier 1 série',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => 'Aucune entrée pour le moment';

  @override
  String get historyEmptyMessage =>
      'Terminez une série ou ajoutez-en une manuellement pour commencer votre historique.';

  @override
  String deleteSetConfirmation(String name) {
    return 'Voulez-vous vraiment supprimer $name ?';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Voulez-vous vraiment supprimer $count entrées ?',
      one: 'Voulez-vous vraiment supprimer 1 entrée ?',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => 'Rechercher dans l’historique...';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeLight => 'Clair';

  @override
  String get pureBlackAmoled => 'Noir pur (AMOLED)';

  @override
  String get showImages => 'Afficher les images';

  @override
  String get peekGraph => 'Aperçu du graphique';

  @override
  String get inputStyleLine => 'Ligne';

  @override
  String get inputStyleOutlined => 'Contour';

  @override
  String get inputStyleFilled => 'Rempli';

  @override
  String get inputStyle => 'Style des champs';

  @override
  String get appearance => 'Apparence';

  @override
  String get automaticBackupsEnabled => 'Sauvegardes automatiques activées';

  @override
  String get automaticBackup => 'Sauvegarde automatique';

  @override
  String get appPermissions => 'Autorisations de l’application';

  @override
  String get shareDatabase => 'Partager la base de données';

  @override
  String get dataManagement => 'Gestion des données';

  @override
  String get strengthUnit => 'Unité de poids';

  @override
  String get lastEntry => 'Dernière entrée';

  @override
  String get cardioUnit => 'Unité cardio';

  @override
  String longDateFormat(String format) {
    return 'Format de date long ($format)';
  }

  @override
  String get formats => 'Formats';

  @override
  String get setsPerExerciseMax => 'Séries par exercice (max. : 20)';

  @override
  String get countLabel => 'Nombre';

  @override
  String get ratioLabel => 'Rapport';

  @override
  String get reorder => 'Réorganiser';

  @override
  String get none => 'Aucun';

  @override
  String get monday => 'Lundi';

  @override
  String get examplePlanExercises =>
      'Développé couché, Squat, Soulevé de terre';

  @override
  String get tabs => 'Onglets';

  @override
  String get swipeBetweenTabs => 'Balayer entre les onglets';

  @override
  String get vibrate => 'Vibrer';

  @override
  String get enableSound => 'Activer le son';

  @override
  String get keepScreenOn => 'Garder l’écran allumé';

  @override
  String get alarmSound => 'Son de l’alarme';

  @override
  String get top => 'En haut';

  @override
  String get bottom => 'En bas';

  @override
  String get removeCustomTimer =>
      'Supprimer le minuteur personnalisé (utiliser la valeur globale par défaut)';

  @override
  String get timers => 'Minuteurs';

  @override
  String get timerSettings => 'Paramètres du minuteur';

  @override
  String get groupHistory => 'Regrouper l’historique';

  @override
  String get showUnits => 'Afficher les unités';

  @override
  String get showBodyWeight => 'Afficher le poids du corps';

  @override
  String get showNotes => 'Afficher les notes';

  @override
  String get repEstimation => 'Estimation des répétitions';

  @override
  String get durationEstimation => 'Estimation de la durée';

  @override
  String get showGraphLimit => 'Afficher la limite du graphique';

  @override
  String get defaultGraphMetric => 'Mesure par défaut du graphique';

  @override
  String get bestWeight => 'Meilleur poids';

  @override
  String get bestReps => 'Meilleures répétitions';

  @override
  String get oneRepMax => 'Maximum sur 1 répétition';

  @override
  String get volume => 'Volume';

  @override
  String get paceCardio => 'Allure (cardio)';

  @override
  String get distanceCardio => 'Distance (cardio)';

  @override
  String get defaultGraphPeriod => 'Période par défaut du graphique';

  @override
  String get defaultGraphLimit => 'Limite par défaut du graphique';

  @override
  String get workouts => 'Entraînements';

  @override
  String get actionStop => 'Arrêter';

  @override
  String get timerFinishedToast => 'Minuteur terminé !';

  @override
  String get stopTimer => 'Arrêter le minuteur';

  @override
  String get actionPause => 'Pause';

  @override
  String get startStopwatch => 'Démarrer le chronomètre';

  @override
  String get actionStart => 'Démarrer';

  @override
  String get actionRestart => 'Redémarrer';

  @override
  String get addOneMinute => '+1 minute';

  @override
  String get addOneMinuteNotification => 'Ajouter 1 min';

  @override
  String get restTimer => 'Minuteur de repos';

  @override
  String get timerUp => 'Temps écoulé';

  @override
  String get openNotification => 'Ouvrir la notification';

  @override
  String get timerChannelName => 'Canal des minuteurs';

  @override
  String get timerChannelDescription =>
      'Progression continue des minuteurs de repos.';

  @override
  String get timerFinishedChannelName => 'Canal de fin de minuteur';

  @override
  String get timerFinishedChannelDescription =>
      'Joue une alarme lorsqu’un minuteur de repos se termine.';

  @override
  String get timerFinished => 'Minuteur terminé';

  @override
  String get batteryOptimizationRequestUnavailable =>
      'Les demandes d’exclusion de l’optimisation de la batterie sont désactivées sur votre appareil.';

  @override
  String get exactAlarmRequestUnavailable =>
      'La demande SCHEDULE_EXACT_ALARM a été refusée sur votre appareil';

  @override
  String get databaseMigrationFailureDescription =>
      'Un problème est survenu lors de la création ou de la mise à niveau de votre base de données. Le supprimer puis recréer vos enregistrements résout généralement le problème.';

  @override
  String get curveSmoothness => 'Lissage de la courbe';

  @override
  String get actionBack => 'Retour';

  @override
  String get atLeastOneTab => 'Vous devez conserver au moins un onglet';

  @override
  String get invalidTabSettings => 'Paramètres d’onglets non valides.';

  @override
  String get noSettingsFound => 'Aucun paramètre trouvé';

  @override
  String nothingMatchesSearch(String query) {
    return 'Aucun résultat pour « $query ».';
  }

  @override
  String get appearanceDescription => 'Thème, couleurs et style de l’interface';

  @override
  String get dataManagementDescription =>
      'Importer, exporter et gérer vos données d’entraînement';

  @override
  String get formatsDescription => 'Formats des dates, nombres et mesures';

  @override
  String get plansSettingsDescription =>
      'Valeurs par défaut et comportement des programmes d’entraînement';

  @override
  String get tabsDescription =>
      'Choisir et organiser les onglets de navigation principaux';

  @override
  String get timersDescription =>
      'Durée, son et comportement du minuteur de repos';

  @override
  String get workoutsDescription =>
      'Suivi des exercices et préférences d’entraînement';

  @override
  String get completeSetForChart =>
      'Terminez une série de cet exercice pour créer son graphique.';

  @override
  String get dateRange => 'Plage de dates';

  @override
  String get stopDate => 'Date de fin';

  @override
  String get dataPoints => 'Points de données';

  @override
  String get completeSetsForProgress =>
      'Terminez quelques séries pour créer votre graphique de progression.';

  @override
  String get relativeStrength => 'Force relative';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments sélectionnés',
      one: '1 élément sélectionné',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory =>
      'Terminez quelques séries pour afficher ici l’historique de cet exercice.';

  @override
  String nothingMatchesGraphSearch(String query) {
    return 'Aucun résultat pour « $query ». Vous pouvez le créer comme nouvel exercice.';
  }

  @override
  String addNamed(String name) {
    return 'Ajouter « $name »';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return 'Cette opération supprimera $count enregistrements. Continuer ?';
  }

  @override
  String shareWorkout(String summary) {
    return 'Je viens de faire $summary';
  }

  @override
  String get updateConflict => 'Conflit de mise à jour';

  @override
  String updateConflictDescription(int count) {
    return 'Le nouveau nom existe déjà pour $count enregistrements. Continuer ?';
  }

  @override
  String get unitsConflict => 'Conflit d’unités';

  @override
  String unitsConflictDescription(String unit) {
    return 'Tous vos enregistrements n’utilisent pas la même unité. Toutes les unités seront converties en $unit. Continuer ?';
  }

  @override
  String get durationLabel => 'Durée';

  @override
  String get inclineLabel => 'Inclinaison';

  @override
  String get paceDistanceTime => 'Allure (distance / temps)';

  @override
  String get adjustedPace => 'Allure ajustée';

  @override
  String get oneRepMaxAccuracyWarning =>
      'Les estimations du maximum sur 1 répétition sont moins précises pour les séries de 10 répétitions ou plus';

  @override
  String get addPlan => 'Ajouter un programme';

  @override
  String get planDetails => 'Détails du programme';

  @override
  String get exercisesLabel => 'Exercices';

  @override
  String get addExerciseToPlan => 'Ajoutez un exercice à ce programme.';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return 'Aucun résultat pour « $query ». Vous pouvez l’ajouter comme nouvel exercice.';
  }

  @override
  String get selectDays => 'Sélectionnez les jours';

  @override
  String get selectExercises => 'Sélectionnez les exercices';

  @override
  String get todayLabel => 'Aujourd’hui';

  @override
  String get setDetails => 'Détails de la série';

  @override
  String get themeLabel => 'Thème';

  @override
  String get pureBlackAmoledDescription =>
      'Utiliser du noir pur sur les écrans AMOLED';

  @override
  String get systemColorScheme => 'Palette de couleurs du système';

  @override
  String get systemColorSchemeDescription =>
      'Utiliser la couleur principale de votre appareil dans l’application';

  @override
  String get showImagesDescription =>
      'Choisir et afficher des images dans la page d’historique';

  @override
  String get showGlobalProgress => 'Afficher la progression globale';

  @override
  String get showGlobalProgressDescription =>
      'Ajouter un graphique montrant votre progression par catégorie';

  @override
  String get peekGraphDescription =>
      'Afficher le premier graphique en courbes sur la page des graphiques';

  @override
  String get inputStyleDescription => 'Style visuel des champs de saisie';

  @override
  String get automaticBackupNotificationBody =>
      'Flexify sauvegardera automatiquement vos données et images dans le dossier sélectionné chaque jour.';

  @override
  String get backupSettingsChannel => 'Paramètres de sauvegarde';

  @override
  String get backupSettingsChannelDescription =>
      'Notifications concernant les sauvegardes automatiques';

  @override
  String get backupChannelName => 'Canal des sauvegardes';

  @override
  String get backupChannelDescription =>
      'Sauvegardes automatiques des données et images de Flexify';

  @override
  String get backupCompletedTitle => 'Données et images sauvegardées';

  @override
  String get backupFailurePathNotSet =>
      'Échec de la sauvegarde : chemin de sauvegarde non défini. Les sauvegardes automatiques ont été désactivées.';

  @override
  String get backupFailureDirectoryUnavailable =>
      'Échec de la sauvegarde : impossible d’accéder au dossier de sauvegarde. Les sauvegardes automatiques ont été désactivées.';

  @override
  String get backupFailureCreateFile =>
      'Échec de la sauvegarde : impossible de créer le fichier de sauvegarde. Les sauvegardes automatiques ont été désactivées.';

  @override
  String get backupFailureAppFilesUnavailable =>
      'Échec de la sauvegarde : impossible d’accéder au dossier des fichiers de l’application. Les sauvegardes automatiques ont été désactivées.';

  @override
  String get backupFailureDatabaseMissing =>
      'Échec de la sauvegarde : fichier de base de données introuvable. Les sauvegardes automatiques ont été désactivées.';

  @override
  String get backupFailureOutputUnavailable =>
      'Échec de la sauvegarde : impossible d’ouvrir le flux de sortie. Les sauvegardes automatiques ont été désactivées.';

  @override
  String get backupFailureUnknown =>
      'Échec de la sauvegarde. Les sauvegardes automatiques ont été désactivées.';

  @override
  String get appPermissionsDescription =>
      'Vérifier les accès requis par les fonctionnalités activées';

  @override
  String get longDateFormatDescription =>
      'Utilisé lorsque l’espace est suffisant';

  @override
  String shortDateFormat(String example) {
    return 'Format de date court ($example)';
  }

  @override
  String get shortDateFormatDescription =>
      'Pour les espaces restreints (lignes des graphiques)';

  @override
  String get warmupSetsDescription =>
      'Les séries d’échauffement n’ont pas de minuteur de repos';

  @override
  String get setsPerExerciseDescription =>
      'Nombre de séries par défaut pour chaque exercice d’un programme';

  @override
  String get planTrailingDisplay => 'Informations en fin de ligne';

  @override
  String get planTrailingDisplayDescription =>
      'Informations affichées à droite dans la liste des programmes et dans la vue du programme';

  @override
  String get restTimersDescription =>
      'Alarme déclenchée après avoir terminé une série';

  @override
  String get vibrateDescription => 'Faire vibrer les minuteurs de repos';

  @override
  String get enableSoundDescription =>
      'Faire jouer un son aux minuteurs de repos';

  @override
  String get keepScreenOnDescription =>
      'Garder l’écran allumé pendant les minuteurs de repos';

  @override
  String get restDurationDescription =>
      'Durée avant le déclenchement de l’alarme de repos';

  @override
  String get globalDefault => 'Valeur globale par défaut';

  @override
  String get alarmSoundDescription =>
      'Son joué à la fin d’un minuteur de repos';

  @override
  String get progressBarPosition => 'Position de la barre de progression';

  @override
  String get progressBarPositionDescription =>
      'Emplacement de la barre de progression du minuteur de repos';

  @override
  String get perExerciseRestTimes => 'Temps de repos par exercice';

  @override
  String get perExerciseRestTimesDescription =>
      'Ces exercices ont des durées de repos personnalisées';

  @override
  String get audioFeaturesUnavailable =>
      'Les fonctions audio ne sont pas disponibles';

  @override
  String get groupHistoryDescription =>
      'Regrouper les entrées de l’historique par jour';

  @override
  String get showUnitsDescription =>
      'Afficher km/mi et kg/lb dans les graphiques, l’historique et les programmes';

  @override
  String get showBodyWeightDescription =>
      'Activer ou désactiver le suivi du poids du corps';

  @override
  String get showNotesDescription =>
      'Enregistrer les détails de votre série dans une zone de texte';

  @override
  String get positiveNotificationsDescription =>
      'Afficher des messages d’encouragement lorsqu’un nouveau record est atteint';

  @override
  String get positiveMessagesEnabled =>
      'Les messages d’encouragement s’afficheront comme ceci !';

  @override
  String get recordEncouragement01 =>
      'Excellent travail ! Vous êtes incroyable.';

  @override
  String get recordEncouragement02 => 'Bravo ! Vos progrès sont inspirants.';

  @override
  String get recordEncouragement03 => 'Je m’incline...';

  @override
  String get recordEncouragement04 =>
      'Qu’est-ce que c’est ? Un nouveau record !';

  @override
  String get recordEncouragement05 =>
      'Incroyable ! Vous êtes une source d’inspiration.';

  @override
  String get recordEncouragement06 => 'Waouh. Bien joué.';

  @override
  String get recordEncouragement07 => 'Ça devient puissant, non ?';

  @override
  String get recordEncouragement08 => 'Oui. Vous devenez vraiment solide.';

  @override
  String get recordEncouragement09 => 'Impressionnant. Incroyable.';

  @override
  String get recordEncouragement10 => 'Arnie serait fier.';

  @override
  String get recordEncouragement11 => 'Ronnie C vous regarde avec le sourire.';

  @override
  String get recordEncouragement12 => 'OUAIS ! POIDS PLUME, BÉBÉ !!!!!!!!';

  @override
  String get recordEncouragement13 =>
      'C’est un nouveau record ? Je savais que vous pouviez le faire.';

  @override
  String get recordEncouragement14 =>
      'Excellent travail ! Je suis fier de vous.';

  @override
  String get recordEncouragement15 => 'Oui ! Facile !';

  @override
  String get recordEncouragement16 =>
      'Continuez comme ça ! Excellents progrès.';

  @override
  String get recordEncouragement17 => 'Vous vous en sortez très bien.';

  @override
  String get recordEncouragement18 => 'Voilà mon champion !';

  @override
  String get recordEncouragement19 => 'Continuez comme ça.';

  @override
  String get recordEncouragement20 => 'Vous devenez vraiment fort.';

  @override
  String get recordEncouragement21 => 'Puissant.';

  @override
  String get recordEncouragement22 => 'Quelle puissance !';

  @override
  String get recordEncouragement23 => 'Je suis fier de vous.';

  @override
  String get recordEncouragement24 => 'Continuez cet excellent travail.';

  @override
  String get recordEncouragement25 =>
      'Tenez-vous droit ! Vous venez de battre un nouveau record.';

  @override
  String get recordEncouragement26 =>
      'Nouveau record ! Vous venez d’aller plus loin que jamais !';

  @override
  String get recordEncouragement27 => 'Oui ! C’est un record.';

  @override
  String get recordEncouragement28 => 'Waouh ! Nouveau record !';

  @override
  String get recordEncouragement29 => 'Très bon travail.';

  @override
  String get repEstimationDescription =>
      'Essayer de prédire le nombre de répétitions que vous venez d’effectuer';

  @override
  String get durationEstimationDescription =>
      'Essayer de prédire la durée de votre cardio';

  @override
  String get showGraphXAxisToggle =>
      'Afficher le sélecteur d’axe X du graphique';

  @override
  String get showGraphXAxisToggleDescription =>
      'Afficher dans les graphiques le sélecteur d’axe X basé sur le temps';

  @override
  String get showGraphLimitDescription =>
      'Afficher le curseur de limite dans les graphiques';

  @override
  String get defaultTimeBasedXAxis => 'Axe X temporel par défaut';

  @override
  String get defaultTimeBasedXAxisDescription =>
      'Utiliser par défaut un axe X basé sur le temps dans les graphiques';

  @override
  String get createFirstTrainingPlan =>
      'Créez votre premier programme d’entraînement pour commencer.';

  @override
  String nothingMatchesPlanSearch(String query) {
    return 'Aucun résultat pour « $query ». Vous pouvez le créer comme nouveau programme.';
  }

  @override
  String get createPlan => 'Créer un programme';

  @override
  String createNamedPlan(String name) {
    return 'Créer « $name »';
  }

  @override
  String setNumber(int number) {
    return 'Série $number';
  }

  @override
  String get navCategories => 'Catégories';

  @override
  String get uncategorized => 'Sans catégorie';

  @override
  String exerciseInCategory(String exercise, String category) {
    return '$exercise · $category';
  }

  @override
  String exerciseExistsInCategory(String exercise, String category) {
    return '$exercise existe déjà dans $category';
  }

  @override
  String get actionOpen => 'Ouvrir';

  @override
  String get chooseCategory => 'Choisissez une catégorie';

  @override
  String get copyFromOtherCategory =>
      'Déjà dans une autre catégorie ? Sélectionnez-le pour copier ses informations.';

  @override
  String categoryExerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercices',
      one: '1 exercice',
      zero: 'Aucun exercice',
    );
    return '$_temp0';
  }

  @override
  String noExercisesInCategory(String category) {
    return 'Aucun exercice dans $category pour le moment';
  }

  @override
  String get addExerciseToCategory =>
      'Ajoutez un exercice pour commencer à le suivre dans cette catégorie.';

  @override
  String get addExercisesFromCategories =>
      'Enregistrez une série ou ajoutez des exercices depuis l’onglet Catégories.';

  @override
  String categoryAndDate(String category, String date) {
    return '$category · $date';
  }
}
