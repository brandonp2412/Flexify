import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Application title shown by the operating system and app shell.
  ///
  /// In en, this message translates to:
  /// **'Flexify'**
  String get appTitle;

  /// Title for the application language preference.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Description for the application language preference.
  ///
  /// In en, this message translates to:
  /// **'Choose the language used by Flexify'**
  String get settingsLanguageDescription;

  /// Language option that follows the device or operating system locale.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystemDefault;

  /// Stable display name for the English locale.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageNameEnglish;

  /// Stable native display name for the Spanish locale.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageNameSpanish;

  /// Stable native display name for the French locale.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageNameFrench;

  /// Stable native display name for the German locale.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageNameGerman;

  /// Stable native display name for the Italian locale.
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get languageNameItalian;

  /// Stable native display name for the Brazilian Portuguese locale.
  ///
  /// In en, this message translates to:
  /// **'Português (Brasil)'**
  String get languageNamePortugueseBrazil;

  /// Stable native display name for the Dutch locale.
  ///
  /// In en, this message translates to:
  /// **'Nederlands'**
  String get languageNameDutch;

  /// Stable native display name for the Polish locale.
  ///
  /// In en, this message translates to:
  /// **'Polski'**
  String get languageNamePolish;

  /// Stable native display name for the Japanese locale.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get languageNameJapanese;

  /// Stable native display name for the Korean locale.
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get languageNameKorean;

  /// Stable native display name for the Simplified Chinese locale.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get languageNameSimplifiedChinese;

  /// Navigation label for workout history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// Navigation label for workout plans.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get navPlans;

  /// Navigation label for exercise graphs.
  ///
  /// In en, this message translates to:
  /// **'Graphs'**
  String get navGraphs;

  /// Navigation label for the rest timer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get navTimer;

  /// Navigation label for app settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Generic short error label.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorLabel;

  /// Error shown when a configured app tab cannot be rendered.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t build tab content.'**
  String get tabContentError;

  /// Message shown when the user tries to hide the last visible navigation tab.
  ///
  /// In en, this message translates to:
  /// **'Can\'t hide everything!'**
  String get cannotHideAllTabs;

  /// Confirmation title shown before hiding a navigation tab.
  ///
  /// In en, this message translates to:
  /// **'Remove {tab} tab?'**
  String removeTabQuestion(String tab);

  /// Explanation shown when removing a navigation tab.
  ///
  /// In en, this message translates to:
  /// **'You can add it back later from settings.'**
  String get restoreTabFromSettings;

  /// Toast shown after a navigation tab has been hidden.
  ///
  /// In en, this message translates to:
  /// **'Removed {tab}'**
  String removedTab(String tab);

  /// Toast announcing that the installed app version changed.
  ///
  /// In en, this message translates to:
  /// **'New version {version}'**
  String newVersion(String version);

  /// Action that opens the app changelog.
  ///
  /// In en, this message translates to:
  /// **'Changes'**
  String get changes;

  /// Default hint shown in reusable search fields.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHint;

  /// Tooltip for deleting the currently selected records.
  ///
  /// In en, this message translates to:
  /// **'Delete selected'**
  String get deleteSelected;

  /// Title for a generic delete confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// Generic confirmation text for deleting one or more records.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Are you sure you want to delete 1 record? This action is not reversible.} other{Are you sure you want to delete {count} records? This action is not reversible.}}'**
  String deleteRecordsConfirmation(int count);

  /// Generic cancel action.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// Generic delete action.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// Generic remove action.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get actionRemove;

  /// Generic edit action.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// Generic share action.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// Action or tooltip for clearing selected records.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get clearSelection;

  /// Tooltip for clearing the current search query.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// Tooltip for opening a contextual actions menu.
  ///
  /// In en, this message translates to:
  /// **'Show menu'**
  String get showMenu;

  /// Action for selecting every visible record.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// Generic label for body or exercise weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightLabel;

  /// Tooltip for opening filtering controls.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// Title for a filtering dialog.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// Generic exercise category label.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// Short label for exercise repetitions.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get repsLabel;

  /// Title for filtering records by repetition count.
  ///
  /// In en, this message translates to:
  /// **'Reps filter'**
  String get repsFilter;

  /// Title for filtering records by weight.
  ///
  /// In en, this message translates to:
  /// **'Weight filter'**
  String get weightFilter;

  /// Label for a numeric lower-bound filter.
  ///
  /// In en, this message translates to:
  /// **'Greater than'**
  String get greaterThan;

  /// Label for a numeric upper-bound filter.
  ///
  /// In en, this message translates to:
  /// **'Less than'**
  String get lessThan;

  /// Label for the beginning of a date range.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// Label for the end of a date range.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get endDate;

  /// Generic action for clearing a value, selection, or filter.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get actionClear;

  /// Generic confirmation action.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get actionOk;

  /// Generic close action.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// Label for selecting a sort order.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// Sort option that places newest records first.
  ///
  /// In en, this message translates to:
  /// **'Date (newest)'**
  String get dateNewest;

  /// Sort option that places oldest records first.
  ///
  /// In en, this message translates to:
  /// **'Date (oldest)'**
  String get dateOldest;

  /// Generic name label and sort option.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// Title for the page explaining missing Android permissions.
  ///
  /// In en, this message translates to:
  /// **'Missing permissions'**
  String get missingPermissions;

  /// Message explaining that enabled rest timers require additional permissions.
  ///
  /// In en, this message translates to:
  /// **'Rest timers are on, but permissions are missing.'**
  String get restTimersPermissionsMissing;

  /// Explanation that timer permissions are unnecessary when rest timers are disabled.
  ///
  /// In en, this message translates to:
  /// **'If you disable rest timers, then these permissions aren\'t needed.'**
  String get restTimersPermissionsOptional;

  /// Label for the rest timer feature.
  ///
  /// In en, this message translates to:
  /// **'Rest timers'**
  String get restTimers;

  /// Android permission action for excluding Flexify from battery optimizations.
  ///
  /// In en, this message translates to:
  /// **'Disable battery optimizations'**
  String get disableBatteryOptimizations;

  /// Explanation of why battery optimization access is requested.
  ///
  /// In en, this message translates to:
  /// **'Progress may pause if battery optimizations stay on.'**
  String get batteryOptimizationWarning;

  /// Android permission action for scheduling exact alarms.
  ///
  /// In en, this message translates to:
  /// **'Schedule exact alarm'**
  String get scheduleExactAlarm;

  /// Explanation of why exact alarm access is requested.
  ///
  /// In en, this message translates to:
  /// **'Alarms cannot be accurate if this is disabled.'**
  String get exactAlarmWarning;

  /// Android permission action for posting notifications.
  ///
  /// In en, this message translates to:
  /// **'Post notifications'**
  String get postNotifications;

  /// Explanation of how rest timer notifications are used.
  ///
  /// In en, this message translates to:
  /// **'Timer progress is sent to the notification bar'**
  String get notificationBarDescription;

  /// Title for the warning shown when rest timers lack required permissions.
  ///
  /// In en, this message translates to:
  /// **'Invalid permissions'**
  String get invalidPermissions;

  /// Confirmation shown when leaving timer permissions incomplete.
  ///
  /// In en, this message translates to:
  /// **'Rest timers are enabled without sufficient permissions. Are you sure?'**
  String get insufficientTimerPermissionsConfirmation;

  /// Generic confirmation action.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get actionConfirm;

  /// Title for the Android app access dialog.
  ///
  /// In en, this message translates to:
  /// **'App access'**
  String get appAccess;

  /// Short explanation of why Android app access is requested.
  ///
  /// In en, this message translates to:
  /// **'Needed for enabled timers and notifications.'**
  String get appAccessDescription;

  /// Generic label for notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Description of notifications used when rest timers are enabled.
  ///
  /// In en, this message translates to:
  /// **'Timer progress and rest alerts'**
  String get timerProgressAndRestAlerts;

  /// Description of notification access when notifications are enabled without rest timers.
  ///
  /// In en, this message translates to:
  /// **'Notifications you have enabled'**
  String get enabledNotificationsDescription;

  /// Android app access label for background activity.
  ///
  /// In en, this message translates to:
  /// **'Background activity'**
  String get backgroundActivity;

  /// Description of background activity access for timers.
  ///
  /// In en, this message translates to:
  /// **'Keep timers reliable in the background'**
  String get backgroundActivityDescription;

  /// Android app access label for exact alarms.
  ///
  /// In en, this message translates to:
  /// **'Exact alarms'**
  String get exactAlarms;

  /// Description of exact alarm access for rest timers.
  ///
  /// In en, this message translates to:
  /// **'Alert exactly when a rest timer ends'**
  String get exactAlarmsDescription;

  /// Message shown when current settings need no extra Android permissions.
  ///
  /// In en, this message translates to:
  /// **'No additional Android access is needed for your current settings.'**
  String get noAdditionalAndroidAccessNeeded;

  /// Generic action for finishing or dismissing a flow.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// Status tooltip indicating that an Android permission is granted.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get allowed;

  /// Generic action for granting requested access.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get actionAllow;

  /// Label for backup import, export, and data-management actions.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backupLabel;

  /// Label for database data-management actions.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get databaseLabel;

  /// Action for opening destructive data deletion options.
  ///
  /// In en, this message translates to:
  /// **'Delete records'**
  String get deleteRecords;

  /// Confirmation text for deleting all graph records.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all graphs? This action is not reversible.'**
  String get deleteAllGraphsConfirmation;

  /// Confirmation text for deleting all plans.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all plans? This action is not reversible.'**
  String get deleteAllPlansConfirmation;

  /// Confirmation text for deleting the complete Flexify database.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your database? This action is not reversible and will destroy all your data.'**
  String get deleteDatabaseConfirmation;

  /// Action for opening data import options.
  ///
  /// In en, this message translates to:
  /// **'Import data'**
  String get importData;

  /// Action for opening data export options.
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get exportData;

  /// Action for reporting an import failure.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get actionReport;

  /// Toast shown after graph CSV data is imported.
  ///
  /// In en, this message translates to:
  /// **'Graph data imported successfully!'**
  String get graphDataImported;

  /// Toast shown after plan CSV data is imported.
  ///
  /// In en, this message translates to:
  /// **'Plans imported successfully'**
  String get plansImported;

  /// Toast shown when a database import fails.
  ///
  /// In en, this message translates to:
  /// **'Failed to import database: {error}'**
  String failedToImportDatabase(String error);

  /// Toast shown when a graph CSV import fails.
  ///
  /// In en, this message translates to:
  /// **'Failed to import graphs: {error}'**
  String failedToImportGraphs(String error);

  /// Toast shown when a plan CSV import fails.
  ///
  /// In en, this message translates to:
  /// **'Failed to import plans: {error}'**
  String failedToImportPlans(String error);

  /// Validation error when an import file no longer exists.
  ///
  /// In en, this message translates to:
  /// **'Selected file does not exist'**
  String get selectedFileDoesNotExist;

  /// Validation error when import file bytes cannot be read.
  ///
  /// In en, this message translates to:
  /// **'Could not read file data'**
  String get couldNotReadFileData;

  /// Validation error explaining the supported web data-import workflow.
  ///
  /// In en, this message translates to:
  /// **'Database import on web requires manual data migration. Please export your data as CSV files and import those instead.'**
  String get databaseImportWebUnsupported;

  /// Validation error for an empty CSV import file.
  ///
  /// In en, this message translates to:
  /// **'CSV file is empty'**
  String get csvFileEmpty;

  /// Validation error for a CSV containing only headings.
  ///
  /// In en, this message translates to:
  /// **'CSV file must contain at least one data row'**
  String get csvNeedsDataRow;

  /// Validation error when an imported CSV row has too few columns.
  ///
  /// In en, this message translates to:
  /// **'Row {row} has insufficient columns: {count}'**
  String csvRowInsufficientColumns(int row, int count);

  /// Validation error for a malformed value in an imported CSV row.
  ///
  /// In en, this message translates to:
  /// **'Invalid {field} value in row {row}: {value}'**
  String invalidCsvValue(String field, int row, String value);

  /// Validation error for an unsupported value type in an imported CSV row.
  ///
  /// In en, this message translates to:
  /// **'Invalid {field} data type in row {row}: {type}'**
  String invalidCsvDataType(String field, int row, String type);

  /// Validation error for a non-integer plan identifier in an imported CSV file.
  ///
  /// In en, this message translates to:
  /// **'Expected an integer plan id, got \"{value}\"'**
  String expectedIntegerPlanId(String value);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
