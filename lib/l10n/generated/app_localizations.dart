import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ru'),
    Locale('tr'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh'),
    Locale('zh', 'CN'),
    Locale('zh', 'TW'),
  ];

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

  /// Display name for Traditional Chinese in the language picker.
  ///
  /// In en, this message translates to:
  /// **'繁體中文'**
  String get languageNameTraditionalChinese;

  /// Stable native display name for the Turkish locale.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get languageNameTurkish;

  /// Stable native display name for the Russian locale.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageNameRussian;

  /// Stable native display name for the Hindi locale.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageNameHindi;

  /// Stable native display name for the Arabic locale.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageNameArabic;

  /// Stable native display name for the Indonesian locale.
  ///
  /// In en, this message translates to:
  /// **'Bahasa Indonesia'**
  String get languageNameIndonesian;

  /// Stable native display name for the Vietnamese locale.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get languageNameVietnamese;

  /// Stable native display name for the Bengali locale.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get languageNameBengali;

  /// Stable native display name for the Urdu locale.
  ///
  /// In en, this message translates to:
  /// **'اردو'**
  String get languageNameUrdu;

  /// Stable native display name for the Persian locale.
  ///
  /// In en, this message translates to:
  /// **'فارسی'**
  String get languageNamePersian;

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

  /// Validation error shown when an imported backup archive is missing the Flexify database file.
  ///
  /// In en, this message translates to:
  /// **'The backup archive does not contain the Flexify database.'**
  String get backupArchiveMissingDatabase;

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

  /// Generic label for measurement units.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unitLabel;

  /// Display label for the kilogram unit option.
  ///
  /// In en, this message translates to:
  /// **'Kilograms (kg)'**
  String get kilogramsUnit;

  /// Display label for the pound unit option.
  ///
  /// In en, this message translates to:
  /// **'Pounds (lb)'**
  String get poundsUnit;

  /// Display label for the stone weight unit option.
  ///
  /// In en, this message translates to:
  /// **'Stone'**
  String get stoneUnit;

  /// Compact stone weight unit shown beside measurement values.
  ///
  /// In en, this message translates to:
  /// **'st'**
  String get stoneUnitShort;

  /// Display label for the kilometer unit option.
  ///
  /// In en, this message translates to:
  /// **'Kilometers (km)'**
  String get kilometersUnit;

  /// Display label for the mile unit option.
  ///
  /// In en, this message translates to:
  /// **'Miles (mi)'**
  String get milesUnit;

  /// Display label for the meter unit option.
  ///
  /// In en, this message translates to:
  /// **'Meters (m)'**
  String get metersUnit;

  /// Display label for the kilocalorie unit option.
  ///
  /// In en, this message translates to:
  /// **'Kilocalories (kcal)'**
  String get kilocaloriesUnit;

  /// Title for the bodyweight entry page.
  ///
  /// In en, this message translates to:
  /// **'Enter Weight'**
  String get enterWeight;

  /// Validation message for a required input.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// Validation message for a malformed numeric input.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// Label for the previously recorded bodyweight.
  ///
  /// In en, this message translates to:
  /// **'Previous weight'**
  String get previousWeight;

  /// Generic label for an attached image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get imageLabel;

  /// Tooltip explaining how to remove an attached image.
  ///
  /// In en, this message translates to:
  /// **'Long-press to delete'**
  String get longPressToDelete;

  /// Action label shown when an attached image cannot be rendered.
  ///
  /// In en, this message translates to:
  /// **'Image error'**
  String get imageError;

  /// Generic save action.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// Title for the About page.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// Action for opening the project donation page.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get donate;

  /// Description for the donation action.
  ///
  /// In en, this message translates to:
  /// **'Help support this project'**
  String get helpSupportProject;

  /// About-page label for opening release notes.
  ///
  /// In en, this message translates to:
  /// **'Whats new?'**
  String get whatsNewAbout;

  /// Title for the in-app changelog page.
  ///
  /// In en, this message translates to:
  /// **'What\'s new?'**
  String get whatsNewTitle;

  /// Description for the in-app changelog action.
  ///
  /// In en, this message translates to:
  /// **'See our release notes'**
  String get seeReleaseNotes;

  /// Label for the installed app version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionLabel;

  /// Label for the app author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get authorLabel;

  /// Label for opening the privacy policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// Description for the privacy policy action.
  ///
  /// In en, this message translates to:
  /// **'How Flexify handles your data'**
  String get privacyPolicyDescription;

  /// Label for opening the software license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get licenseLabel;

  /// Label for opening the source-code repository.
  ///
  /// In en, this message translates to:
  /// **'Source code'**
  String get sourceCode;

  /// Description for the source-code repository action.
  ///
  /// In en, this message translates to:
  /// **'Check it out on GitHub'**
  String get sourceCodeDescription;

  /// Label for opening the app-store review page.
  ///
  /// In en, this message translates to:
  /// **'Leave a review'**
  String get leaveReview;

  /// Description for the app-store review action.
  ///
  /// In en, this message translates to:
  /// **'Rate Flexify on the Play Store'**
  String get leaveReviewDescription;

  /// Label for opening the bug-report form.
  ///
  /// In en, this message translates to:
  /// **'Report a bug'**
  String get reportBug;

  /// Description for the bug-report action.
  ///
  /// In en, this message translates to:
  /// **'Open a ticket on GitHub'**
  String get reportBugDescription;

  /// Title for the database migration failure page.
  ///
  /// In en, this message translates to:
  /// **'Failed migrations'**
  String get failedMigrations;

  /// Label preceding a database migration error message.
  ///
  /// In en, this message translates to:
  /// **'Error message:'**
  String get errorMessageLabel;

  /// Action for opening a new issue report.
  ///
  /// In en, this message translates to:
  /// **'Create issue'**
  String get createIssue;

  /// Title and action for adding an exercise graph.
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get addExercise;

  /// Label for cardiovascular exercises.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get cardio;

  /// Label for strength exercises.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get strength;

  /// Tooltip for opening view options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// One-day graph period.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get periodDay;

  /// One-week graph period.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get periodWeek;

  /// One-month graph period.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get periodMonth;

  /// One-year graph period.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get periodYear;

  /// Empty-state message for an exercise without graph data.
  ///
  /// In en, this message translates to:
  /// **'No data yet for {name}'**
  String noDataFor(String name);

  /// Generic empty state when a graph has no data.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get noDataYet;

  /// Label and title for notes attached to an exercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise notes'**
  String get exerciseNotes;

  /// Hint for exercise notes.
  ///
  /// In en, this message translates to:
  /// **'Notes for this exercise'**
  String get notesForExercise;

  /// Graph option that uses elapsed time on the horizontal axis.
  ///
  /// In en, this message translates to:
  /// **'Use time-based X axis'**
  String get useTimeBasedXAxis;

  /// Title for updating all records for a named exercise.
  ///
  /// In en, this message translates to:
  /// **'Update all {name}'**
  String updateAllNamed(String name);

  /// Label for renaming an exercise.
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get newName;

  /// Label for the minutes component of an exercise rest timer.
  ///
  /// In en, this message translates to:
  /// **'Rest minutes'**
  String get restMinutes;

  /// Label for the seconds component of an exercise rest timer.
  ///
  /// In en, this message translates to:
  /// **'Rest seconds'**
  String get restSeconds;

  /// Title for the global progress graph.
  ///
  /// In en, this message translates to:
  /// **'Global progress'**
  String get globalProgress;

  /// Setting that renders graph lines as curves.
  ///
  /// In en, this message translates to:
  /// **'Curve line graphs'**
  String get curveLineGraphs;

  /// Description for the curved graph-line setting.
  ///
  /// In en, this message translates to:
  /// **'Draw graph lines as smooth curves'**
  String get curveLineGraphsDescription;

  /// Empty history message for a named exercise.
  ///
  /// In en, this message translates to:
  /// **'No history yet for {name}'**
  String noHistoryFor(String name);

  /// Tooltip for leaving multi-select mode.
  ///
  /// In en, this message translates to:
  /// **'Cancel selection'**
  String get cancelSelection;

  /// Tooltip for editing selected records.
  ///
  /// In en, this message translates to:
  /// **'Edit selected'**
  String get editSelected;

  /// Action for creating a new exercise graph.
  ///
  /// In en, this message translates to:
  /// **'New exercise'**
  String get newExercise;

  /// Empty state after graph search or filtering.
  ///
  /// In en, this message translates to:
  /// **'No graphs found'**
  String get noGraphsFound;

  /// Hint for searching exercise graphs.
  ///
  /// In en, this message translates to:
  /// **'Search graphs...'**
  String get searchGraphs;

  /// Generic add action.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// Generic update action.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get actionUpdate;

  /// Action for hiding the global progress graph.
  ///
  /// In en, this message translates to:
  /// **'Hide global progress'**
  String get hideGlobalProgress;

  /// Description of the global progress chart.
  ///
  /// In en, this message translates to:
  /// **'A chart grouped by category'**
  String get chartGroupedByCategory;

  /// Empty state after searching for exercises.
  ///
  /// In en, this message translates to:
  /// **'No exercises found'**
  String get noExercisesFound;

  /// Action for saving a workout plan.
  ///
  /// In en, this message translates to:
  /// **'Save plan'**
  String get savePlan;

  /// Optional plan title field label.
  ///
  /// In en, this message translates to:
  /// **'Title (optional)'**
  String get titleOptional;

  /// Hint for searching exercises.
  ///
  /// In en, this message translates to:
  /// **'Search exercises...'**
  String get searchExercises;

  /// Label for the number of warmup sets.
  ///
  /// In en, this message translates to:
  /// **'Warmup sets'**
  String get warmupSets;

  /// Label for the maximum number of working sets.
  ///
  /// In en, this message translates to:
  /// **'Working sets (max: 20)'**
  String get workingSetsMax;

  /// Generic undo action.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get actionUndo;

  /// Generic swap action.
  ///
  /// In en, this message translates to:
  /// **'Swap'**
  String get actionSwap;

  /// Daily interval label.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// Weekly interval label.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// Monthly interval label.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// Yearly interval label.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// Generic user-facing message for an unexpected runtime or data-loading failure.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get unexpectedError;

  /// Progress message while plan exercises load.
  ///
  /// In en, this message translates to:
  /// **'Loading exercises...'**
  String get loadingExercises;

  /// Empty state when no workout plans exist.
  ///
  /// In en, this message translates to:
  /// **'No plans yet'**
  String get noPlansYet;

  /// Empty state when no plans match a search.
  ///
  /// In en, this message translates to:
  /// **'No matching plans'**
  String get noMatchingPlans;

  /// Action for creating a workout plan.
  ///
  /// In en, this message translates to:
  /// **'New plan'**
  String get newPlan;

  /// Hint for searching workout plans.
  ///
  /// In en, this message translates to:
  /// **'Search plans...'**
  String get searchPlans;

  /// Empty state for a plan without exercises.
  ///
  /// In en, this message translates to:
  /// **'No exercises yet'**
  String get noExercisesYet;

  /// Tooltip and action for editing a workout plan.
  ///
  /// In en, this message translates to:
  /// **'Edit plan'**
  String get editPlan;

  /// Action for saving a workout set.
  ///
  /// In en, this message translates to:
  /// **'Save set'**
  String get saveSet;

  /// Label for a duration in minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutesLabel;

  /// Compact abbreviation for minutes in pace and duration labels.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesShort;

  /// Label for a duration in seconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get secondsLabel;

  /// Generic distance label.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distanceLabel;

  /// Label for incline as a percentage.
  ///
  /// In en, this message translates to:
  /// **'Incline %'**
  String get inclinePercent;

  /// Weight field label including the selected unit.
  ///
  /// In en, this message translates to:
  /// **'Weight ({unit})'**
  String weightWithUnit(String unit);

  /// Tooltip for filling a set with the recorded bodyweight.
  ///
  /// In en, this message translates to:
  /// **'Use body weight'**
  String get useBodyWeight;

  /// Message shown when body weight cannot be used because no weight has been recorded.
  ///
  /// In en, this message translates to:
  /// **'No weight entered yet'**
  String get noWeightEnteredYet;

  /// Generic notes field label.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// Title for replacing an exercise in a workout.
  ///
  /// In en, this message translates to:
  /// **'Swap workout'**
  String get swapWorkout;

  /// Action and title for adding a workout set.
  ///
  /// In en, this message translates to:
  /// **'Add set'**
  String get addSet;

  /// Tooltip for deleting a workout set.
  ///
  /// In en, this message translates to:
  /// **'Delete set'**
  String get deleteSet;

  /// Label for an estimated one-repetition maximum.
  ///
  /// In en, this message translates to:
  /// **'One rep max (estimate)'**
  String get oneRepMaxEstimate;

  /// Generic numeric value field label.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get valueLabel;

  /// Amount field label including the selected unit.
  ///
  /// In en, this message translates to:
  /// **'Amount ({unit})'**
  String amountWithUnit(String unit);

  /// Distance field label including the selected unit.
  ///
  /// In en, this message translates to:
  /// **'Distance ({unit})'**
  String distanceWithUnit(String unit);

  /// Generic bodyweight field label.
  ///
  /// In en, this message translates to:
  /// **'Body weight'**
  String get bodyWeightLabel;

  /// Bodyweight field label including the selected unit.
  ///
  /// In en, this message translates to:
  /// **'Body weight ({unit})'**
  String bodyWeightWithUnit(String unit);

  /// Helper text explaining the exercise category field.
  ///
  /// In en, this message translates to:
  /// **'Choose an existing category or type a new one.'**
  String get categoryHelper;

  /// Navigation label for the workout category manager.
  ///
  /// In en, this message translates to:
  /// **'Manage categories'**
  String get manageCategories;

  /// Description of the category management screen.
  ///
  /// In en, this message translates to:
  /// **'Create, rename, merge or remove categories'**
  String get manageCategoriesDescription;

  /// Action for creating a workout category.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get newCategory;

  /// Action for renaming a workout category.
  ///
  /// In en, this message translates to:
  /// **'Rename category'**
  String get renameCategory;

  /// Action for moving a category's workout entries to another category.
  ///
  /// In en, this message translates to:
  /// **'Merge into another category'**
  String get mergeCategory;

  /// Empty state for the category manager.
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get noCategories;

  /// Validation error for an empty category name.
  ///
  /// In en, this message translates to:
  /// **'Enter a category name'**
  String get categoryNameRequired;

  /// Number of workout entries using a category.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Not used by any entries} =1{Used by 1 entry} other{Used by {count} entries}}'**
  String categoryUsageCount(int count);

  /// Confirmation shown before removing a category and clearing it from workout entries.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Delete this category?} =1{Delete this category and remove it from 1 entry?} other{Delete this category and remove it from {count} entries?}}'**
  String deleteCategoryConfirmation(int count);

  /// Label for the date a workout record was created.
  ///
  /// In en, this message translates to:
  /// **'Created date'**
  String get createdDate;

  /// Title for bulk editing workout sets.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Edit 1 set} other{Edit {count} sets}}'**
  String editSets(int count);

  /// Empty state when workout history has no entries.
  ///
  /// In en, this message translates to:
  /// **'No entries yet'**
  String get noEntriesYet;

  /// Explanation shown when workout history has no entries.
  ///
  /// In en, this message translates to:
  /// **'Complete a set or add one manually to start your history.'**
  String get historyEmptyMessage;

  /// Confirmation shown before deleting one workout set for a named exercise.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}?'**
  String deleteSetConfirmation(String name);

  /// Confirmation shown before deleting one or more selected workout history entries.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Are you sure you want to delete 1 entry?} other{Are you sure you want to delete {count} entries?}}'**
  String deleteEntriesConfirmation(int count);

  /// Hint for searching workout history.
  ///
  /// In en, this message translates to:
  /// **'Search history...'**
  String get searchHistory;

  /// Theme option that follows the system appearance.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// Dark theme option.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// Light theme option.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Appearance setting for pure-black dark surfaces.
  ///
  /// In en, this message translates to:
  /// **'Pure black (AMOLED)'**
  String get pureBlackAmoled;

  /// Appearance setting for exercise images.
  ///
  /// In en, this message translates to:
  /// **'Show images'**
  String get showImages;

  /// Appearance setting for graph previews.
  ///
  /// In en, this message translates to:
  /// **'Peek graph'**
  String get peekGraph;

  /// Line input-field style.
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get inputStyleLine;

  /// Outlined input-field style.
  ///
  /// In en, this message translates to:
  /// **'Outlined'**
  String get inputStyleOutlined;

  /// Filled input-field style.
  ///
  /// In en, this message translates to:
  /// **'Filled'**
  String get inputStyleFilled;

  /// Label for choosing the text-input style.
  ///
  /// In en, this message translates to:
  /// **'Input style'**
  String get inputStyle;

  /// Title for appearance settings.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Status text confirming automatic backups are enabled.
  ///
  /// In en, this message translates to:
  /// **'Automatic backups enabled'**
  String get automaticBackupsEnabled;

  /// Data setting for automatic backups.
  ///
  /// In en, this message translates to:
  /// **'Automatic backup'**
  String get automaticBackup;

  /// Data/settings action for app permissions.
  ///
  /// In en, this message translates to:
  /// **'App permissions'**
  String get appPermissions;

  /// Action for sharing the app database file.
  ///
  /// In en, this message translates to:
  /// **'Share database'**
  String get shareDatabase;

  /// Title for data-management settings.
  ///
  /// In en, this message translates to:
  /// **'Data management'**
  String get dataManagement;

  /// Label for the default strength measurement unit.
  ///
  /// In en, this message translates to:
  /// **'Strength unit'**
  String get strengthUnit;

  /// Option that reuses the unit from the previous entry.
  ///
  /// In en, this message translates to:
  /// **'Last entry'**
  String get lastEntry;

  /// Label for the default cardio measurement unit.
  ///
  /// In en, this message translates to:
  /// **'Cardio unit'**
  String get cardioUnit;

  /// Label for the long date format preview.
  ///
  /// In en, this message translates to:
  /// **'Long date format ({format})'**
  String longDateFormat(String format);

  /// Title for measurement and date formatting settings.
  ///
  /// In en, this message translates to:
  /// **'Formats'**
  String get formats;

  /// Plan setting for the maximum working sets per exercise.
  ///
  /// In en, this message translates to:
  /// **'Sets per exercise (max: 20)'**
  String get setsPerExerciseMax;

  /// Label for count-based plan distribution.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get countLabel;

  /// Label for ratio-based plan distribution.
  ///
  /// In en, this message translates to:
  /// **'Ratio'**
  String get ratioLabel;

  /// Action or option for reordering exercises.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get reorder;

  /// Generic option indicating no selection.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// Monday weekday label in the plan example.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// Example list of exercises shown in plan settings.
  ///
  /// In en, this message translates to:
  /// **'Bench Press, Squat, Deadlift'**
  String get examplePlanExercises;

  /// Title for navigation tab settings.
  ///
  /// In en, this message translates to:
  /// **'Tabs'**
  String get tabs;

  /// Setting for swipe navigation between tabs.
  ///
  /// In en, this message translates to:
  /// **'Swipe between tabs'**
  String get swipeBetweenTabs;

  /// Timer setting for vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibrate'**
  String get vibrate;

  /// Timer setting for alarm sound playback.
  ///
  /// In en, this message translates to:
  /// **'Enable sound'**
  String get enableSound;

  /// Timer setting that prevents screen sleep.
  ///
  /// In en, this message translates to:
  /// **'Keep screen on'**
  String get keepScreenOn;

  /// Label for choosing a timer alarm sound.
  ///
  /// In en, this message translates to:
  /// **'Alarm sound'**
  String get alarmSound;

  /// Top position option.
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get top;

  /// Bottom position option.
  ///
  /// In en, this message translates to:
  /// **'Bottom'**
  String get bottom;

  /// Tooltip for removing an exercise-specific rest timer.
  ///
  /// In en, this message translates to:
  /// **'Remove custom timer (use global default)'**
  String get removeCustomTimer;

  /// Title for timer settings.
  ///
  /// In en, this message translates to:
  /// **'Timers'**
  String get timers;

  /// Heading for timer configuration.
  ///
  /// In en, this message translates to:
  /// **'Timer settings'**
  String get timerSettings;

  /// Workout setting for grouping history entries.
  ///
  /// In en, this message translates to:
  /// **'Group history'**
  String get groupHistory;

  /// Workout setting for displaying measurement units.
  ///
  /// In en, this message translates to:
  /// **'Show units'**
  String get showUnits;

  /// Workout setting for displaying bodyweight input.
  ///
  /// In en, this message translates to:
  /// **'Show body weight'**
  String get showBodyWeight;

  /// Workout setting for exercise categories.
  ///
  /// In en, this message translates to:
  /// **'Show categories'**
  String get showCategories;

  /// Workout setting for exercise notes.
  ///
  /// In en, this message translates to:
  /// **'Show notes'**
  String get showNotes;

  /// Workout setting for repetition estimation.
  ///
  /// In en, this message translates to:
  /// **'Rep estimation'**
  String get repEstimation;

  /// Workout setting for duration estimation.
  ///
  /// In en, this message translates to:
  /// **'Duration estimation'**
  String get durationEstimation;

  /// Workout setting controlling graph-limit display.
  ///
  /// In en, this message translates to:
  /// **'Show graph limit'**
  String get showGraphLimit;

  /// Label for choosing the default graph metric.
  ///
  /// In en, this message translates to:
  /// **'Default graph metric'**
  String get defaultGraphMetric;

  /// Graph metric for highest weight.
  ///
  /// In en, this message translates to:
  /// **'Best weight'**
  String get bestWeight;

  /// Graph metric for highest repetition count.
  ///
  /// In en, this message translates to:
  /// **'Best reps'**
  String get bestReps;

  /// Graph metric for one-repetition maximum.
  ///
  /// In en, this message translates to:
  /// **'One rep max'**
  String get oneRepMax;

  /// Graph metric for training volume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// Cardio graph metric for pace.
  ///
  /// In en, this message translates to:
  /// **'Pace (cardio)'**
  String get paceCardio;

  /// Cardio graph metric for distance.
  ///
  /// In en, this message translates to:
  /// **'Distance (cardio)'**
  String get distanceCardio;

  /// Label for choosing the default graph period.
  ///
  /// In en, this message translates to:
  /// **'Default graph period'**
  String get defaultGraphPeriod;

  /// Label for choosing the default graph record limit.
  ///
  /// In en, this message translates to:
  /// **'Default graph limit'**
  String get defaultGraphLimit;

  /// Title for workout settings.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get workouts;

  /// Generic stop action.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get actionStop;

  /// In-app toast shown when a non-Android timer finishes.
  ///
  /// In en, this message translates to:
  /// **'Timer finished!'**
  String get timerFinishedToast;

  /// Action for stopping the active timer.
  ///
  /// In en, this message translates to:
  /// **'Stop timer'**
  String get stopTimer;

  /// Generic pause action.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get actionPause;

  /// Action for starting the stopwatch.
  ///
  /// In en, this message translates to:
  /// **'Start stopwatch'**
  String get startStopwatch;

  /// Generic start action.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get actionStart;

  /// Generic restart action.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get actionRestart;

  /// Timer action that adds one minute.
  ///
  /// In en, this message translates to:
  /// **'+1 minute'**
  String get addOneMinute;

  /// Compact Android notification action that adds one minute.
  ///
  /// In en, this message translates to:
  /// **'Add 1 min'**
  String get addOneMinuteNotification;

  /// Generic rest timer title used when restarting a timer from a notification.
  ///
  /// In en, this message translates to:
  /// **'Rest timer'**
  String get restTimer;

  /// Default notification title when a timer expires.
  ///
  /// In en, this message translates to:
  /// **'Timer up'**
  String get timerUp;

  /// Desktop notification action label.
  ///
  /// In en, this message translates to:
  /// **'Open notification'**
  String get openNotification;

  /// Android notification channel name for ongoing timers.
  ///
  /// In en, this message translates to:
  /// **'Timer Channel'**
  String get timerChannelName;

  /// Android notification channel description for ongoing timers.
  ///
  /// In en, this message translates to:
  /// **'Ongoing progress of rest timers.'**
  String get timerChannelDescription;

  /// Android notification channel name for completed timers.
  ///
  /// In en, this message translates to:
  /// **'Timer Finished Channel'**
  String get timerFinishedChannelName;

  /// Android notification channel description for completed timers.
  ///
  /// In en, this message translates to:
  /// **'Plays an alarm when a rest timer completes.'**
  String get timerFinishedChannelDescription;

  /// Android notification title for a completed timer.
  ///
  /// In en, this message translates to:
  /// **'Timer finished'**
  String get timerFinished;

  /// Android toast shown when the system battery optimization exemption screen is unavailable.
  ///
  /// In en, this message translates to:
  /// **'Requests to ignore battery optimizations are disabled on your device.'**
  String get batteryOptimizationRequestUnavailable;

  /// Android toast shown when the exact alarm permission screen is unavailable.
  ///
  /// In en, this message translates to:
  /// **'Request for SCHEDULE_EXACT_ALARM rejected on your device'**
  String get exactAlarmRequestUnavailable;

  /// Explanation shown when a database migration fails.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong when creating/upgrading your database. Usually this can be fixed by deleting & re-creating your records.'**
  String get databaseMigrationFailureDescription;

  /// Label for graph curve smoothness.
  ///
  /// In en, this message translates to:
  /// **'Curve smoothness'**
  String get curveSmoothness;

  /// Generic back-navigation tooltip.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// Toast shown when trying to disable the final visible tab.
  ///
  /// In en, this message translates to:
  /// **'You need at least one tab'**
  String get atLeastOneTab;

  /// Error shown when a saved tab identifier is unsupported.
  ///
  /// In en, this message translates to:
  /// **'Invalid tab settings.'**
  String get invalidTabSettings;

  /// Empty state when settings search has no matches.
  ///
  /// In en, this message translates to:
  /// **'No settings found'**
  String get noSettingsFound;

  /// Settings-search empty-state detail.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches “{query}”.'**
  String nothingMatchesSearch(String query);

  /// Description of appearance settings.
  ///
  /// In en, this message translates to:
  /// **'Theme, colors and interface styling'**
  String get appearanceDescription;

  /// Description of data-management settings.
  ///
  /// In en, this message translates to:
  /// **'Import, export and manage your workout data'**
  String get dataManagementDescription;

  /// Description of format settings.
  ///
  /// In en, this message translates to:
  /// **'Dates, numbers and measurement formatting'**
  String get formatsDescription;

  /// Description of plan settings.
  ///
  /// In en, this message translates to:
  /// **'Defaults and behaviour for workout plans'**
  String get plansSettingsDescription;

  /// Description of tab settings.
  ///
  /// In en, this message translates to:
  /// **'Choose and arrange primary navigation tabs'**
  String get tabsDescription;

  /// Description of timer settings.
  ///
  /// In en, this message translates to:
  /// **'Rest timer duration, sound and behaviour'**
  String get timersDescription;

  /// Description of workout settings.
  ///
  /// In en, this message translates to:
  /// **'Exercise tracking and workout preferences'**
  String get workoutsDescription;

  /// Empty graph guidance for a specific exercise.
  ///
  /// In en, this message translates to:
  /// **'Complete a set for this exercise to build its chart.'**
  String get completeSetForChart;

  /// Label for graph date-range controls.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get dateRange;

  /// Label for the end of a graph date range.
  ///
  /// In en, this message translates to:
  /// **'Stop date'**
  String get stopDate;

  /// Label for the number of graph data points.
  ///
  /// In en, this message translates to:
  /// **'Data points'**
  String get dataPoints;

  /// Empty guidance for the global progress graph.
  ///
  /// In en, this message translates to:
  /// **'Complete some sets to build your progress chart.'**
  String get completeSetsForProgress;

  /// Strength graph metric relative to bodyweight.
  ///
  /// In en, this message translates to:
  /// **'Relative strength'**
  String get relativeStrength;

  /// Number of currently selected records.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 selected} other{{count} selected}}'**
  String selectedCount(int count);

  /// Empty guidance for exercise history.
  ///
  /// In en, this message translates to:
  /// **'Complete some sets to see this exercise history here.'**
  String get completeSetsForHistory;

  /// Empty guidance when no exercise graphs exist.
  ///
  /// In en, this message translates to:
  /// **'Complete a set to create your first exercise graph.'**
  String get completeSetForFirstGraph;

  /// Empty graph search guidance.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches “{query}”. You can create it as a new exercise.'**
  String nothingMatchesGraphSearch(String query);

  /// Action for adding an item with a typed name.
  ///
  /// In en, this message translates to:
  /// **'Add “{name}”'**
  String addNamed(String name);

  /// Confirmation for deleting records associated with selected graphs.
  ///
  /// In en, this message translates to:
  /// **'This will delete {count} records. Are you sure?'**
  String deleteGraphRecordsConfirmation(int count);

  /// Text shared from the workout graph screen.
  ///
  /// In en, this message translates to:
  /// **'I just did {summary}'**
  String shareWorkout(String summary);

  /// Title for an exercise rename conflict dialog.
  ///
  /// In en, this message translates to:
  /// **'Update conflict'**
  String get updateConflict;

  /// Explanation for an exercise rename conflict.
  ///
  /// In en, this message translates to:
  /// **'Your new name exists already for {count} records. Are you sure?'**
  String updateConflictDescription(int count);

  /// Title for an exercise unit conversion conflict dialog.
  ///
  /// In en, this message translates to:
  /// **'Units conflict'**
  String get unitsConflict;

  /// Explanation before converting mixed exercise units.
  ///
  /// In en, this message translates to:
  /// **'Not all of your records have the same unit. This will convert all units to {unit}. Are you sure?'**
  String unitsConflictDescription(String unit);

  /// Generic duration label.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// Generic incline label.
  ///
  /// In en, this message translates to:
  /// **'Incline'**
  String get inclineLabel;

  /// Cardio graph metric for distance divided by time.
  ///
  /// In en, this message translates to:
  /// **'Pace (distance / time)'**
  String get paceDistanceTime;

  /// Cardio graph metric adjusted for incline.
  ///
  /// In en, this message translates to:
  /// **'Adjusted pace'**
  String get adjustedPace;

  /// Warning about one-repetition maximum estimate accuracy.
  ///
  /// In en, this message translates to:
  /// **'One rep max estimates are less accurate for sets of 10+ reps'**
  String get oneRepMaxAccuracyWarning;

  /// Action or title for creating a workout plan.
  ///
  /// In en, this message translates to:
  /// **'Add plan'**
  String get addPlan;

  /// Heading for editable workout plan details.
  ///
  /// In en, this message translates to:
  /// **'Plan details'**
  String get planDetails;

  /// Generic heading for exercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercisesLabel;

  /// Empty-state guidance for a workout plan with no exercises.
  ///
  /// In en, this message translates to:
  /// **'Add an exercise to this plan.'**
  String get addExerciseToPlan;

  /// Empty-state guidance when a plan exercise search has no matches.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches “{query}”. You can add it as a new exercise.'**
  String nothingMatchesExerciseSearch(String query);

  /// Validation message requiring at least one workout plan day.
  ///
  /// In en, this message translates to:
  /// **'Select days'**
  String get selectDays;

  /// Validation message requiring at least one workout plan exercise.
  ///
  /// In en, this message translates to:
  /// **'Select exercises'**
  String get selectExercises;

  /// Label indicating the current day.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// Heading for workout set entry fields.
  ///
  /// In en, this message translates to:
  /// **'Set details'**
  String get setDetails;

  /// Label for choosing the application theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeLabel;

  /// Description of the AMOLED pure-black appearance option.
  ///
  /// In en, this message translates to:
  /// **'Use pure black colors for AMOLED displays'**
  String get pureBlackAmoledDescription;

  /// Appearance setting for using system colors.
  ///
  /// In en, this message translates to:
  /// **'System color scheme'**
  String get systemColorScheme;

  /// Description of the system color scheme setting.
  ///
  /// In en, this message translates to:
  /// **'Use the primary color of your device for the app'**
  String get systemColorSchemeDescription;

  /// Description of the setting that shows workout images.
  ///
  /// In en, this message translates to:
  /// **'Pick/display images on the history page'**
  String get showImagesDescription;

  /// Setting that controls the global progress graph.
  ///
  /// In en, this message translates to:
  /// **'Show global progress'**
  String get showGlobalProgress;

  /// Description of the global progress setting.
  ///
  /// In en, this message translates to:
  /// **'Add a graph entry charting your progress by category'**
  String get showGlobalProgressDescription;

  /// Description of the graph preview setting.
  ///
  /// In en, this message translates to:
  /// **'Show the first line graph on graphs page'**
  String get peekGraphDescription;

  /// Description of the text input style setting.
  ///
  /// In en, this message translates to:
  /// **'Visual style of text input fields'**
  String get inputStyleDescription;

  /// Notification body shown when automatic backups are enabled.
  ///
  /// In en, this message translates to:
  /// **'Flexify will automatically back up your data and images to the selected folder each day.'**
  String get automaticBackupNotificationBody;

  /// Notification channel name for backup settings.
  ///
  /// In en, this message translates to:
  /// **'Backup settings'**
  String get backupSettingsChannel;

  /// Notification channel description for automatic backups.
  ///
  /// In en, this message translates to:
  /// **'Notifications explaining automatic backups'**
  String get backupSettingsChannelDescription;

  /// Android notification channel name for completed automatic backups.
  ///
  /// In en, this message translates to:
  /// **'Backup channel'**
  String get backupChannelName;

  /// Android notification channel description for automatic backups.
  ///
  /// In en, this message translates to:
  /// **'Automatic backups of Flexify data and images'**
  String get backupChannelDescription;

  /// Android notification title shown after an automatic backup succeeds.
  ///
  /// In en, this message translates to:
  /// **'Backed up data and images'**
  String get backupCompletedTitle;

  /// Android toast shown when an automatic backup has no destination path.
  ///
  /// In en, this message translates to:
  /// **'Backup failed: backup path not set. Automatic backups disabled.'**
  String get backupFailurePathNotSet;

  /// Android toast shown when the automatic backup directory cannot be accessed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed: could not access backup directory. Automatic backups disabled.'**
  String get backupFailureDirectoryUnavailable;

  /// Android toast shown when an automatic backup archive cannot be created.
  ///
  /// In en, this message translates to:
  /// **'Backup failed: could not create backup file. Automatic backups disabled.'**
  String get backupFailureCreateFile;

  /// Android toast shown when app files are unavailable during automatic backup.
  ///
  /// In en, this message translates to:
  /// **'Backup failed: could not access application files directory. Automatic backups disabled.'**
  String get backupFailureAppFilesUnavailable;

  /// Android toast shown when the database is missing during automatic backup.
  ///
  /// In en, this message translates to:
  /// **'Backup failed: database file not found. Automatic backups disabled.'**
  String get backupFailureDatabaseMissing;

  /// Android toast shown when the automatic backup destination cannot be opened.
  ///
  /// In en, this message translates to:
  /// **'Backup failed: could not open output stream. Automatic backups disabled.'**
  String get backupFailureOutputUnavailable;

  /// Android toast shown for an unexpected automatic backup failure.
  ///
  /// In en, this message translates to:
  /// **'Backup failed. Automatic backups disabled.'**
  String get backupFailureUnknown;

  /// Description for the app permissions settings entry.
  ///
  /// In en, this message translates to:
  /// **'Review access required by your enabled features'**
  String get appPermissionsDescription;

  /// Description of the long date-format setting.
  ///
  /// In en, this message translates to:
  /// **'Used where space is abundant'**
  String get longDateFormatDescription;

  /// Label for short date formatting with an example.
  ///
  /// In en, this message translates to:
  /// **'Short date format ({example})'**
  String shortDateFormat(String example);

  /// Description of the short date-format setting.
  ///
  /// In en, this message translates to:
  /// **'For where space is cramped (Graph lines)'**
  String get shortDateFormatDescription;

  /// Description of the default warmup sets setting.
  ///
  /// In en, this message translates to:
  /// **'Warmup sets have no rest timers'**
  String get warmupSetsDescription;

  /// Description of the default sets-per-exercise setting.
  ///
  /// In en, this message translates to:
  /// **'Default # of exercises in a plan'**
  String get setsPerExerciseDescription;

  /// Label for choosing information shown on the right side of plan rows.
  ///
  /// In en, this message translates to:
  /// **'Plan trailing display'**
  String get planTrailingDisplay;

  /// Description of the plan trailing display setting.
  ///
  /// In en, this message translates to:
  /// **'Right side of list displays in Plans + Plan view'**
  String get planTrailingDisplayDescription;

  /// Description of rest timers.
  ///
  /// In en, this message translates to:
  /// **'Alarm that goes off after completing a set'**
  String get restTimersDescription;

  /// Description of timer vibration.
  ///
  /// In en, this message translates to:
  /// **'Should rest timers vibrate?'**
  String get vibrateDescription;

  /// Description of timer sound.
  ///
  /// In en, this message translates to:
  /// **'Should rest timers play a sound?'**
  String get enableSoundDescription;

  /// Description of keeping the display awake during timers.
  ///
  /// In en, this message translates to:
  /// **'Keep the screen on during rest timers'**
  String get keepScreenOnDescription;

  /// Description of the default rest duration.
  ///
  /// In en, this message translates to:
  /// **'How long before rest alarms go off?'**
  String get restDurationDescription;

  /// Label for a global default setting value.
  ///
  /// In en, this message translates to:
  /// **'Global default'**
  String get globalDefault;

  /// Description of the timer alarm sound setting.
  ///
  /// In en, this message translates to:
  /// **'Music to play at the end of a rest timer'**
  String get alarmSoundDescription;

  /// Label for choosing the rest timer progress bar position.
  ///
  /// In en, this message translates to:
  /// **'Progress bar position'**
  String get progressBarPosition;

  /// Description of the rest timer progress bar position setting.
  ///
  /// In en, this message translates to:
  /// **'Where should the rest timers progress bar be placed?'**
  String get progressBarPositionDescription;

  /// Heading for exercise-specific rest timer durations.
  ///
  /// In en, this message translates to:
  /// **'Per-exercise rest times'**
  String get perExerciseRestTimes;

  /// Description of exercise-specific rest timer durations.
  ///
  /// In en, this message translates to:
  /// **'These exercises have custom rest durations'**
  String get perExerciseRestTimesDescription;

  /// Message shown when timer audio features cannot be initialized.
  ///
  /// In en, this message translates to:
  /// **'Audio features are not available'**
  String get audioFeaturesUnavailable;

  /// Description of history grouping.
  ///
  /// In en, this message translates to:
  /// **'Combine history entries by day'**
  String get groupHistoryDescription;

  /// Description of displaying measurement units.
  ///
  /// In en, this message translates to:
  /// **'Show km/mi,kg/lb for graphs/history/plans'**
  String get showUnitsDescription;

  /// Description of bodyweight tracking.
  ///
  /// In en, this message translates to:
  /// **'Enable/disable tracking body weight'**
  String get showBodyWeightDescription;

  /// Description of workout categories.
  ///
  /// In en, this message translates to:
  /// **'Enable/disable workout categories'**
  String get showCategoriesDescription;

  /// Description of workout notes.
  ///
  /// In en, this message translates to:
  /// **'Record details of your lift in a text area'**
  String get showNotesDescription;

  /// Description of positive record notifications.
  ///
  /// In en, this message translates to:
  /// **'Write nice messages when a new record is hit'**
  String get positiveNotificationsDescription;

  /// Example toast shown when positive messages are enabled.
  ///
  /// In en, this message translates to:
  /// **'Positive messages appear now like this!'**
  String get positiveMessagesEnabled;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'Great work! You are incredible.'**
  String get recordEncouragement01;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'Nice king! Your progress is inspiring.'**
  String get recordEncouragement02;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'I kneel...'**
  String get recordEncouragement03;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'What\'s that? A new record!'**
  String get recordEncouragement04;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'Incredible stuff! You are an inspiration.'**
  String get recordEncouragement05;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'Wow. Nice.'**
  String get recordEncouragement06;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'Getting strong much?'**
  String get recordEncouragement07;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'Yeah. You\'re a pretty big guy.'**
  String get recordEncouragement08;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'Amazing. Incredible.'**
  String get recordEncouragement09;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'Arnie would be proud.'**
  String get recordEncouragement10;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'Ronnie C looks upon you with glee.'**
  String get recordEncouragement11;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'YEAH! LIGHTWEIGHT BABY!!!!!!!'**
  String get recordEncouragement12;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'Is that a new record? I knew you could do it.'**
  String get recordEncouragement13;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'Great work! I am proud of you.'**
  String get recordEncouragement14;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'Yeah baby! Light weight!'**
  String get recordEncouragement15;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'Keep it up! Great progress.'**
  String get recordEncouragement16;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'You are doing so well.'**
  String get recordEncouragement17;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'That\'s my boy!'**
  String get recordEncouragement18;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'Keep it up.'**
  String get recordEncouragement19;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'You are getting very strong.'**
  String get recordEncouragement20;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'Powerful.'**
  String get recordEncouragement21;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'Powerful stuff!'**
  String get recordEncouragement22;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'I am proud of you.'**
  String get recordEncouragement23;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'Keep up the great work.'**
  String get recordEncouragement24;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'Stand tall! You just made a new record.'**
  String get recordEncouragement25;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'New record! You just pushed further than ever!'**
  String get recordEncouragement26;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'Yep! That\'s a record.'**
  String get recordEncouragement27;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'Wow! New record!'**
  String get recordEncouragement28;

  /// Positive message shown after a new exercise record.
  ///
  /// In en, this message translates to:
  /// **'Very good stuff.'**
  String get recordEncouragement29;

  /// Description of repetition estimation.
  ///
  /// In en, this message translates to:
  /// **'Try to predict the # of reps you just did'**
  String get repEstimationDescription;

  /// Description of cardio duration estimation.
  ///
  /// In en, this message translates to:
  /// **'Try predict the duration of your cardio'**
  String get durationEstimationDescription;

  /// Setting for showing the graph X-axis mode toggle.
  ///
  /// In en, this message translates to:
  /// **'Show graph X axis toggle'**
  String get showGraphXAxisToggle;

  /// Description of the graph X-axis toggle setting.
  ///
  /// In en, this message translates to:
  /// **'Show time-based X axis toggle on graphs'**
  String get showGraphXAxisToggleDescription;

  /// Description of the graph limit setting.
  ///
  /// In en, this message translates to:
  /// **'Show the limit slider on graphs'**
  String get showGraphLimitDescription;

  /// Setting for using time-based graph X axes by default.
  ///
  /// In en, this message translates to:
  /// **'Default time-based X axis'**
  String get defaultTimeBasedXAxis;

  /// Description of the default time-based X-axis setting.
  ///
  /// In en, this message translates to:
  /// **'Use time-based X axis by default on graphs'**
  String get defaultTimeBasedXAxisDescription;

  /// Empty-state guidance when no workout plans exist.
  ///
  /// In en, this message translates to:
  /// **'Create your first training plan to get started.'**
  String get createFirstTrainingPlan;

  /// Empty-state guidance when a plan search has no matches.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches “{query}”. You can create it as a new plan.'**
  String nothingMatchesPlanSearch(String query);

  /// Action for creating a workout plan.
  ///
  /// In en, this message translates to:
  /// **'Create plan'**
  String get createPlan;

  /// Action for creating a plan with a typed name.
  ///
  /// In en, this message translates to:
  /// **'Create “{name}”'**
  String createNamedPlan(String name);

  /// Label for a numbered workout set.
  ///
  /// In en, this message translates to:
  /// **'Set {number}'**
  String setNumber(int number);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bn',
    'de',
    'en',
    'es',
    'fa',
    'fr',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'nl',
    'pl',
    'pt',
    'ru',
    'tr',
    'ur',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return AppLocalizationsZhCn();
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fa':
      return AppLocalizationsFa();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'ur':
      return AppLocalizationsUr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
