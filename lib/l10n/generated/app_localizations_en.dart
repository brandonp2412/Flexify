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
}
