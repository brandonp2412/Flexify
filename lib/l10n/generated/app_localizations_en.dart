// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageDescription =>
      'Choose the language used by Flexify';

  @override
  String get languageSystemDefault => 'System default';

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
  String get navHistory => 'History';

  @override
  String get navPlans => 'Plans';

  @override
  String get navGraphs => 'Graphs';

  @override
  String get navTimer => 'Timer';

  @override
  String get navSettings => 'Settings';

  @override
  String get errorLabel => 'Error';

  @override
  String get tabContentError => 'Couldn\'t build tab content.';

  @override
  String get cannotHideAllTabs => 'Can\'t hide everything!';

  @override
  String removeTabQuestion(String tab) {
    return 'Remove $tab tab?';
  }

  @override
  String get restoreTabFromSettings =>
      'You can add it back later from settings.';

  @override
  String removedTab(String tab) {
    return 'Removed $tab';
  }

  @override
  String newVersion(String version) {
    return 'New version $version';
  }

  @override
  String get changes => 'Changes';

  @override
  String get searchHint => 'Search...';

  @override
  String get deleteSelected => 'Delete selected';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Are you sure you want to delete $count records? This action is not reversible.',
      one:
          'Are you sure you want to delete 1 record? This action is not reversible.',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionRemove => 'Remove';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionShare => 'Share';

  @override
  String get clearSelection => 'Clear selection';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get showMenu => 'Show menu';

  @override
  String get selectAll => 'Select all';

  @override
  String get weightLabel => 'Weight';

  @override
  String get filter => 'Filter';

  @override
  String get filters => 'Filters';

  @override
  String get categoryLabel => 'Category';

  @override
  String get repsLabel => 'Reps';

  @override
  String get repsFilter => 'Reps filter';

  @override
  String get weightFilter => 'Weight filter';

  @override
  String get greaterThan => 'Greater than';

  @override
  String get lessThan => 'Less than';

  @override
  String get startDate => 'Start date';

  @override
  String get endDate => 'End date';

  @override
  String get actionClear => 'Clear';

  @override
  String get actionOk => 'OK';

  @override
  String get actionClose => 'Close';

  @override
  String get sortBy => 'Sort by';

  @override
  String get dateNewest => 'Date (newest)';

  @override
  String get dateOldest => 'Date (oldest)';

  @override
  String get nameLabel => 'Name';

  @override
  String get missingPermissions => 'Missing permissions';

  @override
  String get restTimersPermissionsMissing =>
      'Rest timers are on, but permissions are missing.';

  @override
  String get restTimersPermissionsOptional =>
      'If you disable rest timers, then these permissions aren\'t needed.';

  @override
  String get restTimers => 'Rest timers';

  @override
  String get disableBatteryOptimizations => 'Disable battery optimizations';

  @override
  String get batteryOptimizationWarning =>
      'Progress may pause if battery optimizations stay on.';

  @override
  String get scheduleExactAlarm => 'Schedule exact alarm';

  @override
  String get exactAlarmWarning =>
      'Alarms cannot be accurate if this is disabled.';

  @override
  String get postNotifications => 'Post notifications';

  @override
  String get notificationBarDescription =>
      'Timer progress is sent to the notification bar';

  @override
  String get invalidPermissions => 'Invalid permissions';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      'Rest timers are enabled without sufficient permissions. Are you sure?';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get appAccess => 'App access';

  @override
  String get appAccessDescription =>
      'Needed for enabled timers and notifications.';

  @override
  String get notifications => 'Notifications';

  @override
  String get timerProgressAndRestAlerts => 'Timer progress and rest alerts';

  @override
  String get enabledNotificationsDescription =>
      'Notifications you have enabled';

  @override
  String get backgroundActivity => 'Background activity';

  @override
  String get backgroundActivityDescription =>
      'Keep timers reliable in the background';

  @override
  String get exactAlarms => 'Exact alarms';

  @override
  String get exactAlarmsDescription => 'Alert exactly when a rest timer ends';

  @override
  String get noAdditionalAndroidAccessNeeded =>
      'No additional Android access is needed for your current settings.';

  @override
  String get actionDone => 'Done';

  @override
  String get allowed => 'Allowed';

  @override
  String get actionAllow => 'Allow';

  @override
  String get backupLabel => 'Backup';

  @override
  String get databaseLabel => 'Database';

  @override
  String get deleteRecords => 'Delete records';

  @override
  String get deleteAllGraphsConfirmation =>
      'Are you sure you want to delete all graphs? This action is not reversible.';

  @override
  String get deleteAllPlansConfirmation =>
      'Are you sure you want to delete all plans? This action is not reversible.';

  @override
  String get deleteDatabaseConfirmation =>
      'Are you sure you want to delete your database? This action is not reversible and will destroy all your data.';

  @override
  String get importData => 'Import data';

  @override
  String get exportData => 'Export data';

  @override
  String get actionReport => 'Report';

  @override
  String get graphDataImported => 'Graph data imported successfully!';

  @override
  String get plansImported => 'Plans imported successfully';

  @override
  String failedToImportDatabase(String error) {
    return 'Failed to import database: $error';
  }

  @override
  String failedToImportGraphs(String error) {
    return 'Failed to import graphs: $error';
  }

  @override
  String failedToImportPlans(String error) {
    return 'Failed to import plans: $error';
  }

  @override
  String get selectedFileDoesNotExist => 'Selected file does not exist';

  @override
  String get couldNotReadFileData => 'Could not read file data';

  @override
  String get databaseImportWebUnsupported =>
      'Database import on web requires manual data migration. Please export your data as CSV files and import those instead.';

  @override
  String get csvFileEmpty => 'CSV file is empty';

  @override
  String get csvNeedsDataRow => 'CSV file must contain at least one data row';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return 'Row $row has insufficient columns: $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return 'Invalid $field value in row $row: $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return 'Invalid $field data type in row $row: $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return 'Expected an integer plan id, got \"$value\"';
  }

  @override
  String get unitLabel => 'Unit';

  @override
  String get kilogramsUnit => 'Kilograms (kg)';

  @override
  String get poundsUnit => 'Pounds (lb)';

  @override
  String get stoneUnit => 'Stone';

  @override
  String get kilometersUnit => 'Kilometers (km)';

  @override
  String get milesUnit => 'Miles (mi)';

  @override
  String get metersUnit => 'Meters (m)';

  @override
  String get kilocaloriesUnit => 'Kilocalories (kcal)';

  @override
  String get enterWeight => 'Enter Weight';

  @override
  String get requiredField => 'Required';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get previousWeight => 'Previous weight';

  @override
  String get imageLabel => 'Image';

  @override
  String get longPressToDelete => 'Long-press to delete';

  @override
  String get imageError => 'Image error';

  @override
  String get actionSave => 'Save';

  @override
  String get aboutTitle => 'About';

  @override
  String get donate => 'Donate';

  @override
  String get helpSupportProject => 'Help support this project';

  @override
  String get whatsNewAbout => 'Whats new?';

  @override
  String get whatsNewTitle => 'What\'s new?';

  @override
  String get seeReleaseNotes => 'See our release notes';

  @override
  String get versionLabel => 'Version';

  @override
  String get authorLabel => 'Author';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get privacyPolicyDescription => 'How Flexify handles your data';

  @override
  String get licenseLabel => 'License';

  @override
  String get sourceCode => 'Source code';

  @override
  String get sourceCodeDescription => 'Check it out on GitHub';

  @override
  String get leaveReview => 'Leave a review';

  @override
  String get leaveReviewDescription => 'Rate Flexify on the Play Store';

  @override
  String get reportBug => 'Report a bug';

  @override
  String get reportBugDescription => 'Open a ticket on GitHub';

  @override
  String get failedMigrations => 'Failed migrations';

  @override
  String get errorMessageLabel => 'Error message:';

  @override
  String get createIssue => 'Create issue';

  @override
  String get addExercise => 'Add exercise';

  @override
  String get cardio => 'Cardio';

  @override
  String get strength => 'Strength';

  @override
  String get options => 'Options';

  @override
  String get periodDay => 'Day';

  @override
  String get periodWeek => 'Week';

  @override
  String get periodMonth => 'Month';

  @override
  String get periodYear => 'Year';

  @override
  String noDataFor(String name) {
    return 'No data yet for $name';
  }

  @override
  String get noDataYet => 'No data yet';

  @override
  String get exerciseNotes => 'Exercise notes';

  @override
  String get notesForExercise => 'Notes for this exercise';

  @override
  String get useTimeBasedXAxis => 'Use time-based X axis';

  @override
  String updateAllNamed(String name) {
    return 'Update all $name';
  }

  @override
  String get newName => 'New name';

  @override
  String get restMinutes => 'Rest minutes';

  @override
  String get restSeconds => 'Rest seconds';

  @override
  String get globalProgress => 'Global progress';

  @override
  String get curveLineGraphs => 'Curve line graphs';

  @override
  String get curveLineGraphsDescription => 'Draw graph lines as smooth curves';

  @override
  String noHistoryFor(String name) {
    return 'No history yet for $name';
  }

  @override
  String get cancelSelection => 'Cancel selection';

  @override
  String get editSelected => 'Edit selected';

  @override
  String get newExercise => 'New exercise';

  @override
  String get noGraphsFound => 'No graphs found';

  @override
  String get searchGraphs => 'Search graphs...';

  @override
  String get actionAdd => 'Add';

  @override
  String get actionUpdate => 'Update';

  @override
  String get hideGlobalProgress => 'Hide global progress';

  @override
  String get chartGroupedByCategory => 'A chart grouped by category';

  @override
  String get noExercisesFound => 'No exercises found';

  @override
  String get savePlan => 'Save plan';

  @override
  String get titleOptional => 'Title (optional)';

  @override
  String get searchExercises => 'Search exercises...';

  @override
  String get warmupSets => 'Warmup sets';

  @override
  String get workingSetsMax => 'Working sets (max: 20)';

  @override
  String get actionUndo => 'Undo';

  @override
  String get actionSwap => 'Swap';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String errorWithMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get loadingExercises => 'Loading exercises...';

  @override
  String get noPlansYet => 'No plans yet';

  @override
  String get noMatchingPlans => 'No matching plans';

  @override
  String get newPlan => 'New plan';

  @override
  String get searchPlans => 'Search plans...';

  @override
  String get noExercisesYet => 'No exercises yet';

  @override
  String get editPlan => 'Edit plan';

  @override
  String get saveSet => 'Save set';

  @override
  String get minutesLabel => 'Minutes';

  @override
  String get minutesShort => 'min';

  @override
  String get secondsLabel => 'Seconds';

  @override
  String get distanceLabel => 'Distance';

  @override
  String get inclinePercent => 'Incline %';

  @override
  String weightWithUnit(String unit) {
    return 'Weight ($unit)';
  }

  @override
  String get useBodyWeight => 'Use body weight';

  @override
  String get noWeightEnteredYet => 'No weight entered yet';

  @override
  String get notesLabel => 'Notes';

  @override
  String get swapWorkout => 'Swap workout';

  @override
  String get addSet => 'Add set';

  @override
  String get deleteSet => 'Delete set';

  @override
  String get oneRepMaxEstimate => 'One rep max (estimate)';

  @override
  String get valueLabel => 'Value';

  @override
  String amountWithUnit(String unit) {
    return 'Amount ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return 'Distance ($unit)';
  }

  @override
  String get bodyWeightLabel => 'Body weight';

  @override
  String bodyWeightWithUnit(String unit) {
    return 'Body weight ($unit)';
  }

  @override
  String get categoryHelper => 'Muscle group, e.g. Chest or Legs';

  @override
  String get createdDate => 'Created date';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Edit $count sets',
      one: 'Edit 1 set',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => 'No entries yet';

  @override
  String get historyEmptyMessage =>
      'Complete a set or add one manually to start your history.';

  @override
  String deleteSetConfirmation(String name) {
    return 'Are you sure you want to delete $name?';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Are you sure you want to delete $count entries?',
      one: 'Are you sure you want to delete 1 entry?',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => 'Search history...';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get pureBlackAmoled => 'Pure black (AMOLED)';

  @override
  String get showImages => 'Show images';

  @override
  String get peekGraph => 'Peek graph';

  @override
  String get inputStyleLine => 'Line';

  @override
  String get inputStyleOutlined => 'Outlined';

  @override
  String get inputStyleFilled => 'Filled';

  @override
  String get inputStyle => 'Input style';

  @override
  String get appearance => 'Appearance';

  @override
  String get automaticBackupsEnabled => 'Automatic backups enabled';

  @override
  String get automaticBackup => 'Automatic backup';

  @override
  String get appPermissions => 'App permissions';

  @override
  String get shareDatabase => 'Share database';

  @override
  String get dataManagement => 'Data management';

  @override
  String get strengthUnit => 'Strength unit';

  @override
  String get lastEntry => 'Last entry';

  @override
  String get cardioUnit => 'Cardio unit';

  @override
  String longDateFormat(String format) {
    return 'Long date format ($format)';
  }

  @override
  String get formats => 'Formats';

  @override
  String get setsPerExerciseMax => 'Sets per exercise (max: 20)';

  @override
  String get countLabel => 'Count';

  @override
  String get ratioLabel => 'Ratio';

  @override
  String get reorder => 'Reorder';

  @override
  String get none => 'None';

  @override
  String get monday => 'Monday';

  @override
  String get examplePlanExercises => 'Bench Press, Squat, Deadlift';

  @override
  String get tabs => 'Tabs';

  @override
  String get swipeBetweenTabs => 'Swipe between tabs';

  @override
  String get vibrate => 'Vibrate';

  @override
  String get enableSound => 'Enable sound';

  @override
  String get keepScreenOn => 'Keep screen on';

  @override
  String get alarmSound => 'Alarm sound';

  @override
  String get top => 'Top';

  @override
  String get bottom => 'Bottom';

  @override
  String get removeCustomTimer => 'Remove custom timer (use global default)';

  @override
  String get timers => 'Timers';

  @override
  String get timerSettings => 'Timer settings';

  @override
  String get groupHistory => 'Group history';

  @override
  String get showUnits => 'Show units';

  @override
  String get showBodyWeight => 'Show body weight';

  @override
  String get showCategories => 'Show categories';

  @override
  String get showNotes => 'Show notes';

  @override
  String get repEstimation => 'Rep estimation';

  @override
  String get durationEstimation => 'Duration estimation';

  @override
  String get showGraphLimit => 'Show graph limit';

  @override
  String get defaultGraphMetric => 'Default graph metric';

  @override
  String get bestWeight => 'Best weight';

  @override
  String get bestReps => 'Best reps';

  @override
  String get oneRepMax => 'One rep max';

  @override
  String get volume => 'Volume';

  @override
  String get paceCardio => 'Pace (cardio)';

  @override
  String get distanceCardio => 'Distance (cardio)';

  @override
  String get defaultGraphPeriod => 'Default graph period';

  @override
  String get defaultGraphLimit => 'Default graph limit';

  @override
  String get workouts => 'Workouts';

  @override
  String get actionStop => 'Stop';

  @override
  String get timerFinishedToast => 'Timer finished!';

  @override
  String get stopTimer => 'Stop timer';

  @override
  String get actionPause => 'Pause';

  @override
  String get startStopwatch => 'Start stopwatch';

  @override
  String get actionStart => 'Start';

  @override
  String get actionRestart => 'Restart';

  @override
  String get addOneMinute => '+1 minute';

  @override
  String get addOneMinuteNotification => 'Add 1 min';

  @override
  String get restTimer => 'Rest timer';

  @override
  String get timerUp => 'Timer up';

  @override
  String get openNotification => 'Open notification';

  @override
  String get timerChannelName => 'Timer Channel';

  @override
  String get timerChannelDescription => 'Ongoing progress of rest timers.';

  @override
  String get timerFinishedChannelName => 'Timer Finished Channel';

  @override
  String get timerFinishedChannelDescription =>
      'Plays an alarm when a rest timer completes.';

  @override
  String get timerFinished => 'Timer finished';

  @override
  String get batteryOptimizationRequestUnavailable =>
      'Requests to ignore battery optimizations are disabled on your device.';

  @override
  String get exactAlarmRequestUnavailable =>
      'Request for SCHEDULE_EXACT_ALARM rejected on your device';

  @override
  String get databaseMigrationFailureDescription =>
      'Something went wrong when creating/upgrading your database. Usually this can be fixed by deleting & re-creating your records.';

  @override
  String get curveSmoothness => 'Curve smoothness';

  @override
  String get actionBack => 'Back';

  @override
  String get atLeastOneTab => 'You need at least one tab';

  @override
  String get invalidTabSettings => 'Invalid tab settings.';

  @override
  String get noSettingsFound => 'No settings found';

  @override
  String nothingMatchesSearch(String query) {
    return 'Nothing matches “$query”.';
  }

  @override
  String get appearanceDescription => 'Theme, colors and interface styling';

  @override
  String get dataManagementDescription =>
      'Import, export and manage your workout data';

  @override
  String get formatsDescription => 'Dates, numbers and measurement formatting';

  @override
  String get plansSettingsDescription =>
      'Defaults and behaviour for workout plans';

  @override
  String get tabsDescription => 'Choose and arrange primary navigation tabs';

  @override
  String get timersDescription => 'Rest timer duration, sound and behaviour';

  @override
  String get workoutsDescription => 'Exercise tracking and workout preferences';

  @override
  String get completeSetForChart =>
      'Complete a set for this exercise to build its chart.';

  @override
  String get dateRange => 'Date range';

  @override
  String get stopDate => 'Stop date';

  @override
  String get dataPoints => 'Data points';

  @override
  String get completeSetsForProgress =>
      'Complete some sets to build your progress chart.';

  @override
  String get relativeStrength => 'Relative strength';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected',
      one: '1 selected',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory =>
      'Complete some sets to see this exercise history here.';

  @override
  String get completeSetForFirstGraph =>
      'Complete a set to create your first exercise graph.';

  @override
  String nothingMatchesGraphSearch(String query) {
    return 'Nothing matches “$query”. You can create it as a new exercise.';
  }

  @override
  String addNamed(String name) {
    return 'Add “$name”';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return 'This will delete $count records. Are you sure?';
  }

  @override
  String shareWorkout(String summary) {
    return 'I just did $summary';
  }

  @override
  String get updateConflict => 'Update conflict';

  @override
  String updateConflictDescription(int count) {
    return 'Your new name exists already for $count records. Are you sure?';
  }

  @override
  String get unitsConflict => 'Units conflict';

  @override
  String unitsConflictDescription(String unit) {
    return 'Not all of your records have the same unit. This will convert all units to $unit. Are you sure?';
  }

  @override
  String get durationLabel => 'Duration';

  @override
  String get inclineLabel => 'Incline';

  @override
  String get paceDistanceTime => 'Pace (distance / time)';

  @override
  String get adjustedPace => 'Adjusted pace';

  @override
  String get oneRepMaxAccuracyWarning =>
      'One rep max estimates are less accurate for sets of 10+ reps';

  @override
  String get addPlan => 'Add plan';

  @override
  String get planDetails => 'Plan details';

  @override
  String get exercisesLabel => 'Exercises';

  @override
  String get addExerciseToPlan => 'Add an exercise to this plan.';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return 'Nothing matches “$query”. You can add it as a new exercise.';
  }

  @override
  String get selectDays => 'Select days';

  @override
  String get selectExercises => 'Select exercises';

  @override
  String get todayLabel => 'Today';

  @override
  String get setDetails => 'Set details';

  @override
  String get themeLabel => 'Theme';

  @override
  String get pureBlackAmoledDescription =>
      'Use pure black colors for AMOLED displays';

  @override
  String get systemColorScheme => 'System color scheme';

  @override
  String get systemColorSchemeDescription =>
      'Use the primary color of your device for the app';

  @override
  String get showImagesDescription => 'Pick/display images on the history page';

  @override
  String get showGlobalProgress => 'Show global progress';

  @override
  String get showGlobalProgressDescription =>
      'Add a graph entry charting your progress by category';

  @override
  String get peekGraphDescription => 'Show the first line graph on graphs page';

  @override
  String get inputStyleDescription => 'Visual style of text input fields';

  @override
  String get automaticBackupNotificationBody =>
      'Flexify will automatically back up your data and images to the selected folder each day.';

  @override
  String get backupSettingsChannel => 'Backup settings';

  @override
  String get backupSettingsChannelDescription =>
      'Notifications explaining automatic backups';

  @override
  String get backupChannelName => 'Backup channel';

  @override
  String get backupChannelDescription =>
      'Automatic backups of Flexify data and images';

  @override
  String get backupCompletedTitle => 'Backed up data and images';

  @override
  String get backupFailurePathNotSet =>
      'Backup failed: backup path not set. Automatic backups disabled.';

  @override
  String get backupFailureDirectoryUnavailable =>
      'Backup failed: could not access backup directory. Automatic backups disabled.';

  @override
  String get backupFailureCreateFile =>
      'Backup failed: could not create backup file. Automatic backups disabled.';

  @override
  String get backupFailureAppFilesUnavailable =>
      'Backup failed: could not access application files directory. Automatic backups disabled.';

  @override
  String get backupFailureDatabaseMissing =>
      'Backup failed: database file not found. Automatic backups disabled.';

  @override
  String get backupFailureOutputUnavailable =>
      'Backup failed: could not open output stream. Automatic backups disabled.';

  @override
  String get backupFailureUnknown =>
      'Backup failed. Automatic backups disabled.';

  @override
  String get appPermissionsDescription =>
      'Review access required by your enabled features';

  @override
  String get longDateFormatDescription => 'Used where space is abundant';

  @override
  String shortDateFormat(String example) {
    return 'Short date format ($example)';
  }

  @override
  String get shortDateFormatDescription =>
      'For where space is cramped (Graph lines)';

  @override
  String get warmupSetsDescription => 'Warmup sets have no rest timers';

  @override
  String get setsPerExerciseDescription => 'Default # of exercises in a plan';

  @override
  String get planTrailingDisplay => 'Plan trailing display';

  @override
  String get planTrailingDisplayDescription =>
      'Right side of list displays in Plans + Plan view';

  @override
  String get restTimersDescription =>
      'Alarm that goes off after completing a set';

  @override
  String get vibrateDescription => 'Should rest timers vibrate?';

  @override
  String get enableSoundDescription => 'Should rest timers play a sound?';

  @override
  String get keepScreenOnDescription => 'Keep the screen on during rest timers';

  @override
  String get restDurationDescription => 'How long before rest alarms go off?';

  @override
  String get globalDefault => 'Global default';

  @override
  String get alarmSoundDescription =>
      'Music to play at the end of a rest timer';

  @override
  String get progressBarPosition => 'Progress bar position';

  @override
  String get progressBarPositionDescription =>
      'Where should the rest timers progress bar be placed?';

  @override
  String get perExerciseRestTimes => 'Per-exercise rest times';

  @override
  String get perExerciseRestTimesDescription =>
      'These exercises have custom rest durations';

  @override
  String get audioFeaturesUnavailable => 'Audio features are not available';

  @override
  String get groupHistoryDescription => 'Combine history entries by day';

  @override
  String get showUnitsDescription =>
      'Show km/mi,kg/lb for graphs/history/plans';

  @override
  String get showBodyWeightDescription => 'Enable/disable tracking body weight';

  @override
  String get showCategoriesDescription => 'Enable/disable workout categories';

  @override
  String get showNotesDescription =>
      'Record details of your lift in a text area';

  @override
  String get positiveNotificationsDescription =>
      'Write nice messages when a new record is hit';

  @override
  String get positiveMessagesEnabled =>
      'Positive messages appear now like this!';

  @override
  String get recordEncouragement01 => 'Great work! You are incredible.';

  @override
  String get recordEncouragement02 => 'Nice king! Your progress is inspiring.';

  @override
  String get recordEncouragement03 => 'I kneel...';

  @override
  String get recordEncouragement04 => 'What\'s that? A new record!';

  @override
  String get recordEncouragement05 =>
      'Incredible stuff! You are an inspiration.';

  @override
  String get recordEncouragement06 => 'Wow. Nice.';

  @override
  String get recordEncouragement07 => 'Getting strong much?';

  @override
  String get recordEncouragement08 => 'Yeah. You\'re a pretty big guy.';

  @override
  String get recordEncouragement09 => 'Amazing. Incredible.';

  @override
  String get recordEncouragement10 => 'Arnie would be proud.';

  @override
  String get recordEncouragement11 => 'Ronnie C looks upon you with glee.';

  @override
  String get recordEncouragement12 => 'YEAH! LIGHTWEIGHT BABY!!!!!!!';

  @override
  String get recordEncouragement13 =>
      'Is that a new record? I knew you could do it.';

  @override
  String get recordEncouragement14 => 'Great work! I am proud of you.';

  @override
  String get recordEncouragement15 => 'Yeah baby! Light weight!';

  @override
  String get recordEncouragement16 => 'Keep it up! Great progress.';

  @override
  String get recordEncouragement17 => 'You are doing so well.';

  @override
  String get recordEncouragement18 => 'That\'s my boy!';

  @override
  String get recordEncouragement19 => 'Keep it up.';

  @override
  String get recordEncouragement20 => 'You are getting very strong.';

  @override
  String get recordEncouragement21 => 'Powerful.';

  @override
  String get recordEncouragement22 => 'Powerful stuff!';

  @override
  String get recordEncouragement23 => 'I am proud of you.';

  @override
  String get recordEncouragement24 => 'Keep up the great work.';

  @override
  String get recordEncouragement25 => 'Stand tall! You just made a new record.';

  @override
  String get recordEncouragement26 =>
      'New record! You just pushed further than ever!';

  @override
  String get recordEncouragement27 => 'Yep! That\'s a record.';

  @override
  String get recordEncouragement28 => 'Wow! New record!';

  @override
  String get recordEncouragement29 => 'Very good stuff.';

  @override
  String get repEstimationDescription =>
      'Try to predict the # of reps you just did';

  @override
  String get durationEstimationDescription =>
      'Try predict the duration of your cardio';

  @override
  String get showGraphXAxisToggle => 'Show graph X axis toggle';

  @override
  String get showGraphXAxisToggleDescription =>
      'Show time-based X axis toggle on graphs';

  @override
  String get showGraphLimitDescription => 'Show the limit slider on graphs';

  @override
  String get defaultTimeBasedXAxis => 'Default time-based X axis';

  @override
  String get defaultTimeBasedXAxisDescription =>
      'Use time-based X axis by default on graphs';

  @override
  String get createFirstTrainingPlan =>
      'Create your first training plan to get started.';

  @override
  String nothingMatchesPlanSearch(String query) {
    return 'Nothing matches “$query”. You can create it as a new plan.';
  }

  @override
  String get createPlan => 'Create plan';

  @override
  String createNamedPlan(String name) {
    return 'Create “$name”';
  }

  @override
  String setNumber(int number) {
    return 'Set $number';
  }
}
