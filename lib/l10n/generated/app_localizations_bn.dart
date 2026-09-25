// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => 'ভাষা';

  @override
  String get settingsLanguageDescription => 'Flexify-এ ব্যবহৃত ভাষা বেছে নিন';

  @override
  String get languageSystemDefault => 'সিস্টেমের ডিফল্ট';

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
  String get navHistory => 'ইতিহাস';

  @override
  String get navPlans => 'পরিকল্পনা';

  @override
  String get navGraphs => 'গ্রাফ';

  @override
  String get navTimer => 'টাইমার';

  @override
  String get navSettings => 'সেটিংস';

  @override
  String get errorLabel => 'ত্রুটি';

  @override
  String get tabContentError => 'ট্যাবের বিষয়বস্তু তৈরি করা যায়নি।';

  @override
  String get cannotHideAllTabs => 'সবকিছু লুকানো যাবে না!';

  @override
  String removeTabQuestion(String tab) {
    return '$tab ট্যাবটি সরাবেন?';
  }

  @override
  String get restoreTabFromSettings =>
      'পরে সেটিংস থেকে এটি আবার যোগ করতে পারবেন।';

  @override
  String removedTab(String tab) {
    return '$tab সরানো হয়েছে';
  }

  @override
  String newVersion(String version) {
    return 'নতুন সংস্করণ $version';
  }

  @override
  String get changes => 'পরিবর্তন';

  @override
  String get searchHint => 'খুঁজুন...';

  @override
  String get deleteSelected => 'নির্বাচিতগুলো মুছুন';

  @override
  String get confirmDelete => 'মুছে ফেলা নিশ্চিত করুন';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'আপনি কি নিশ্চিত যে $countটি রেকর্ড মুছতে চান? এই কাজটি ফিরিয়ে নেওয়া যাবে না।',
      one:
          'আপনি কি নিশ্চিত যে ১টি রেকর্ড মুছতে চান? এই কাজটি ফিরিয়ে নেওয়া যাবে না।',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'বাতিল';

  @override
  String get actionDelete => 'মুছুন';

  @override
  String get actionRemove => 'সরান';

  @override
  String get actionEdit => 'সম্পাদনা';

  @override
  String get actionShare => 'শেয়ার';

  @override
  String get clearSelection => 'নির্বাচন পরিষ্কার করুন';

  @override
  String get clearSearch => 'অনুসন্ধান পরিষ্কার করুন';

  @override
  String get showMenu => 'মেনু দেখান';

  @override
  String get selectAll => 'সব নির্বাচন করুন';

  @override
  String get weightLabel => 'ওজন';

  @override
  String get filter => 'ফিল্টার';

  @override
  String get filters => 'ফিল্টারসমূহ';

  @override
  String get categoryLabel => 'বিভাগ';

  @override
  String get repsLabel => 'রেপ';

  @override
  String get repsFilter => 'রেপ ফিল্টার';

  @override
  String get weightFilter => 'ওজন ফিল্টার';

  @override
  String get greaterThan => 'এর চেয়ে বেশি';

  @override
  String get lessThan => 'এর চেয়ে কম';

  @override
  String get startDate => 'শুরুর তারিখ';

  @override
  String get endDate => 'শেষের তারিখ';

  @override
  String get actionClear => 'পরিষ্কার করুন';

  @override
  String get actionOk => 'ঠিক আছে';

  @override
  String get actionClose => 'বন্ধ করুন';

  @override
  String get sortBy => 'সাজান';

  @override
  String get dateNewest => 'তারিখ (নতুন আগে)';

  @override
  String get dateOldest => 'তারিখ (পুরোনো আগে)';

  @override
  String get nameLabel => 'নাম';

  @override
  String get missingPermissions => 'অনুমতি নেই';

  @override
  String get restTimersPermissionsMissing =>
      'বিশ্রাম টাইমার চালু আছে, কিন্তু প্রয়োজনীয় অনুমতি নেই।';

  @override
  String get restTimersPermissionsOptional =>
      'বিশ্রাম টাইমার বন্ধ করলে এই অনুমতিগুলোর আর প্রয়োজন নেই।';

  @override
  String get restTimers => 'বিশ্রাম টাইমার';

  @override
  String get disableBatteryOptimizations => 'ব্যাটারি অপ্টিমাইজেশন বন্ধ করুন';

  @override
  String get batteryOptimizationWarning =>
      'ব্যাটারি অপ্টিমাইজেশন চালু থাকলে অগ্রগতি থেমে যেতে পারে।';

  @override
  String get scheduleExactAlarm => 'নির্দিষ্ট সময়ের অ্যালার্ম নির্ধারণ করুন';

  @override
  String get exactAlarmWarning =>
      'এটি বন্ধ থাকলে অ্যালার্ম সঠিক সময়ে নাও বাজতে পারে।';

  @override
  String get postNotifications => 'নোটিফিকেশন দেখান';

  @override
  String get notificationBarDescription =>
      'টাইমারের অগ্রগতি নোটিফিকেশন বারে দেখানো হয়';

  @override
  String get invalidPermissions => 'অনুমতি সঠিক নয়';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      'যথেষ্ট অনুমতি ছাড়াই বিশ্রাম টাইমার চালু আছে। আপনি কি নিশ্চিত?';

  @override
  String get actionConfirm => 'নিশ্চিত করুন';

  @override
  String get appAccess => 'অ্যাপ অ্যাক্সেস';

  @override
  String get appAccessDescription =>
      'চালু থাকা টাইমার ও নোটিফিকেশনের জন্য প্রয়োজন।';

  @override
  String get notifications => 'নোটিফিকেশন';

  @override
  String get timerProgressAndRestAlerts =>
      'টাইমারের অগ্রগতি ও বিশ্রামের সতর্কতা';

  @override
  String get enabledNotificationsDescription =>
      'আপনি যে নোটিফিকেশনগুলো চালু করেছেন';

  @override
  String get backgroundActivity => 'ব্যাকগ্রাউন্ড কার্যকলাপ';

  @override
  String get backgroundActivityDescription =>
      'ব্যাকগ্রাউন্ডেও টাইমার নির্ভরযোগ্য রাখুন';

  @override
  String get exactAlarms => 'নির্দিষ্ট সময়ের অ্যালার্ম';

  @override
  String get exactAlarmsDescription =>
      'বিশ্রাম টাইমার শেষ হওয়ার ঠিক সময়ে সতর্ক করুন';

  @override
  String get noAdditionalAndroidAccessNeeded =>
      'বর্তমান সেটিংসের জন্য অতিরিক্ত Android অ্যাক্সেসের প্রয়োজন নেই।';

  @override
  String get actionDone => 'সম্পন্ন';

  @override
  String get allowed => 'অনুমোদিত';

  @override
  String get actionAllow => 'অনুমতি দিন';

  @override
  String get backupLabel => 'ব্যাকআপ';

  @override
  String get databaseLabel => 'ডেটাবেস';

  @override
  String get deleteRecords => 'রেকর্ড মুছুন';

  @override
  String get deleteAllGraphsConfirmation =>
      'আপনি কি নিশ্চিত যে সব গ্রাফ মুছতে চান? এই কাজটি ফিরিয়ে নেওয়া যাবে না।';

  @override
  String get deleteAllPlansConfirmation =>
      'আপনি কি নিশ্চিত যে সব পরিকল্পনা মুছতে চান? এই কাজটি ফিরিয়ে নেওয়া যাবে না।';

  @override
  String get deleteDatabaseConfirmation =>
      'আপনি কি নিশ্চিত যে আপনার ডেটাবেস মুছতে চান? এই কাজটি ফিরিয়ে নেওয়া যাবে না এবং আপনার সব ডেটা নষ্ট হবে।';

  @override
  String get importData => 'ডেটা আমদানি করুন';

  @override
  String get exportData => 'ডেটা রপ্তানি করুন';

  @override
  String get actionReport => 'রিপোর্ট করুন';

  @override
  String get graphDataImported => 'গ্রাফের ডেটা সফলভাবে আমদানি হয়েছে!';

  @override
  String get plansImported => 'পরিকল্পনা সফলভাবে আমদানি হয়েছে';

  @override
  String failedToImportDatabase(String error) {
    return 'ডেটাবেস আমদানি ব্যর্থ হয়েছে: $error';
  }

  @override
  String get backupArchiveMissingDatabase =>
      'ব্যাকআপ আর্কাইভে Flexify ডেটাবেস নেই।';

  @override
  String failedToImportGraphs(String error) {
    return 'গ্রাফ আমদানি ব্যর্থ হয়েছে: $error';
  }

  @override
  String failedToImportPlans(String error) {
    return 'পরিকল্পনা আমদানি ব্যর্থ হয়েছে: $error';
  }

  @override
  String get selectedFileDoesNotExist => 'নির্বাচিত ফাইলটি নেই';

  @override
  String get couldNotReadFileData => 'ফাইলের ডেটা পড়া যায়নি';

  @override
  String get databaseImportWebUnsupported =>
      'ওয়েবে ডেটাবেস আমদানির জন্য হাতে ডেটা স্থানান্তর করতে হবে। অনুগ্রহ করে ডেটা CSV ফাইল হিসেবে রপ্তানি করে সেগুলো আমদানি করুন।';

  @override
  String get csvFileEmpty => 'CSV ফাইলটি খালি';

  @override
  String get csvNeedsDataRow => 'CSV ফাইলে অন্তত একটি ডেটা সারি থাকতে হবে';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return 'সারি $row-এ যথেষ্ট কলাম নেই: $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return 'সারি $row-এ $field-এর মান সঠিক নয়: $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return 'সারি $row-এ $field-এর ডেটা টাইপ সঠিক নয়: $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return 'পূর্ণসংখ্যার plan id প্রত্যাশিত ছিল, পাওয়া গেছে \"$value\"';
  }

  @override
  String get unitLabel => 'একক';

  @override
  String get kilogramsUnit => 'কিলোগ্রাম (kg)';

  @override
  String get poundsUnit => 'পাউন্ড (lb)';

  @override
  String get stoneUnit => 'স্টোন';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => 'কিলোমিটার (km)';

  @override
  String get milesUnit => 'মাইল (mi)';

  @override
  String get metersUnit => 'মিটার (m)';

  @override
  String get kilocaloriesUnit => 'কিলোক্যালরি (kcal)';

  @override
  String get enterWeight => 'ওজন লিখুন';

  @override
  String get requiredField => 'আবশ্যক';

  @override
  String get invalidNumber => 'সঠিক সংখ্যা নয়';

  @override
  String get previousWeight => 'আগের ওজন';

  @override
  String get imageLabel => 'ছবি';

  @override
  String get longPressToDelete => 'মুছতে দীর্ঘক্ষণ চাপুন';

  @override
  String get imageError => 'ছবির ত্রুটি';

  @override
  String get actionSave => 'সংরক্ষণ করুন';

  @override
  String get aboutTitle => 'সম্পর্কে';

  @override
  String get donate => 'অনুদান';

  @override
  String get helpSupportProject => 'এই প্রকল্পকে সহায়তা করুন';

  @override
  String get whatsNewAbout => 'নতুন কী?';

  @override
  String get whatsNewTitle => 'নতুন কী?';

  @override
  String get seeReleaseNotes => 'আমাদের রিলিজ নোট দেখুন';

  @override
  String get versionLabel => 'সংস্করণ';

  @override
  String get authorLabel => 'লেখক';

  @override
  String get privacyPolicy => 'গোপনীয়তা নীতি';

  @override
  String get privacyPolicyDescription =>
      'Flexify কীভাবে আপনার ডেটা ব্যবহার করে';

  @override
  String get licenseLabel => 'লাইসেন্স';

  @override
  String get sourceCode => 'সোর্স কোড';

  @override
  String get sourceCodeDescription => 'GitHub-এ দেখে নিন';

  @override
  String get leaveReview => 'রিভিউ দিন';

  @override
  String get leaveReviewDescription => 'Play Store-এ Flexify-কে রেট দিন';

  @override
  String get reportBug => 'বাগ রিপোর্ট করুন';

  @override
  String get reportBugDescription => 'GitHub-এ একটি টিকিট খুলুন';

  @override
  String get failedMigrations => 'ব্যর্থ মাইগ্রেশন';

  @override
  String get errorMessageLabel => 'ত্রুটির বার্তা:';

  @override
  String get createIssue => 'ইস্যু তৈরি করুন';

  @override
  String get addExercise => 'ব্যায়াম যোগ করুন';

  @override
  String get cardio => 'কার্ডিও';

  @override
  String get strength => 'শক্তিবর্ধক';

  @override
  String get options => 'বিকল্প';

  @override
  String get periodDay => 'দিন';

  @override
  String get periodWeek => 'সপ্তাহ';

  @override
  String get periodMonth => 'মাস';

  @override
  String get periodYear => 'বছর';

  @override
  String noDataFor(String name) {
    return '$name-এর জন্য এখনো কোনো ডেটা নেই';
  }

  @override
  String get noDataYet => 'এখনো কোনো ডেটা নেই';

  @override
  String get exerciseNotes => 'ব্যায়ামের নোট';

  @override
  String get notesForExercise => 'এই ব্যায়ামের নোট';

  @override
  String get useTimeBasedXAxis => 'সময়ভিত্তিক X অক্ষ ব্যবহার করুন';

  @override
  String updateAllNamed(String name) {
    return 'সব $name আপডেট করুন';
  }

  @override
  String get newName => 'নতুন নাম';

  @override
  String get restMinutes => 'বিশ্রামের মিনিট';

  @override
  String get restSeconds => 'বিশ্রামের সেকেন্ড';

  @override
  String get globalProgress => 'সামগ্রিক অগ্রগতি';

  @override
  String get curveLineGraphs => 'গ্রাফের রেখা বাঁকানো রাখুন';

  @override
  String get curveLineGraphsDescription =>
      'গ্রাফের রেখাগুলো মসৃণ বক্ররেখা হিসেবে আঁকুন';

  @override
  String noHistoryFor(String name) {
    return '$name-এর এখনো কোনো ইতিহাস নেই';
  }

  @override
  String get cancelSelection => 'নির্বাচন বাতিল করুন';

  @override
  String get editSelected => 'নির্বাচিতগুলো সম্পাদনা করুন';

  @override
  String get newExercise => 'নতুন ব্যায়াম';

  @override
  String get noGraphsFound => 'কোনো গ্রাফ পাওয়া যায়নি';

  @override
  String get searchGraphs => 'গ্রাফ খুঁজুন...';

  @override
  String get actionAdd => 'যোগ করুন';

  @override
  String get actionUpdate => 'আপডেট করুন';

  @override
  String get hideGlobalProgress => 'সামগ্রিক অগ্রগতি লুকান';

  @override
  String get chartGroupedByCategory => 'বিভাগ অনুযায়ী সাজানো চার্ট';

  @override
  String get noExercisesFound => 'কোনো ব্যায়াম পাওয়া যায়নি';

  @override
  String get savePlan => 'পরিকল্পনা সংরক্ষণ করুন';

  @override
  String get titleOptional => 'শিরোনাম (ঐচ্ছিক)';

  @override
  String get searchExercises => 'ব্যায়াম খুঁজুন...';

  @override
  String get warmupSets => 'ওয়ার্ম-আপ সেট';

  @override
  String get workingSetsMax => 'ওয়ার্কিং সেট (সর্বোচ্চ: 20)';

  @override
  String get actionUndo => 'পূর্বাবস্থায় ফেরান';

  @override
  String get actionSwap => 'অদলবদল';

  @override
  String get daily => 'দৈনিক';

  @override
  String get weekly => 'সাপ্তাহিক';

  @override
  String get monthly => 'মাসিক';

  @override
  String get yearly => 'বার্ষিক';

  @override
  String get unexpectedError => 'কিছু একটা ভুল হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get loadingExercises => 'ব্যায়াম লোড হচ্ছে...';

  @override
  String get noPlansYet => 'এখনো কোনো পরিকল্পনা নেই';

  @override
  String get noMatchingPlans => 'মিলছে এমন কোনো পরিকল্পনা নেই';

  @override
  String get newPlan => 'নতুন পরিকল্পনা';

  @override
  String get searchPlans => 'পরিকল্পনা খুঁজুন...';

  @override
  String get noExercisesYet => 'এখনো কোনো ব্যায়াম নেই';

  @override
  String get editPlan => 'পরিকল্পনা সম্পাদনা করুন';

  @override
  String get saveSet => 'সেট সংরক্ষণ করুন';

  @override
  String get minutesLabel => 'মিনিট';

  @override
  String get minutesShort => 'মিনিট';

  @override
  String get secondsLabel => 'সেকেন্ড';

  @override
  String get distanceLabel => 'দূরত্ব';

  @override
  String get inclinePercent => 'ঢাল %';

  @override
  String weightWithUnit(String unit) {
    return 'ওজন ($unit)';
  }

  @override
  String get useBodyWeight => 'শরীরের ওজন ব্যবহার করুন';

  @override
  String get noWeightEnteredYet => 'এখনো কোনো ওজন লেখা হয়নি';

  @override
  String get notesLabel => 'নোট';

  @override
  String get swapWorkout => 'ওয়ার্কআউট বদলান';

  @override
  String get addSet => 'সেট যোগ করুন';

  @override
  String get deleteSet => 'সেট মুছুন';

  @override
  String get oneRepMaxEstimate => 'এক রেপ সর্বোচ্চ (আনুমানিক)';

  @override
  String get valueLabel => 'মান';

  @override
  String amountWithUnit(String unit) {
    return 'পরিমাণ ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return 'দূরত্ব ($unit)';
  }

  @override
  String get bodyWeightLabel => 'শরীরের ওজন';

  @override
  String bodyWeightWithUnit(String unit) {
    return 'শরীরের ওজন ($unit)';
  }

  @override
  String get categoryHelper => 'বিদ্যমান বিভাগ বেছে নিন অথবা নতুন একটি লিখুন।';

  @override
  String get manageCategories => 'বিভাগ পরিচালনা করুন';

  @override
  String get manageCategoriesDescription =>
      'বিভাগ তৈরি, নাম বদল, একীভূত বা সরান';

  @override
  String get newCategory => 'নতুন বিভাগ';

  @override
  String get renameCategory => 'বিভাগের নাম বদলান';

  @override
  String get mergeCategory => 'অন্য বিভাগে একীভূত করুন';

  @override
  String get noCategories => 'এখনো কোনো বিভাগ নেই';

  @override
  String get categoryNameRequired => 'একটি বিভাগের নাম লিখুন';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি এন্ট্রিতে ব্যবহৃত',
      one: '১টি এন্ট্রিতে ব্যবহৃত',
      zero: 'কোনো এন্ট্রিতে ব্যবহৃত নয়',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'এই বিভাগটি মুছে $countটি এন্ট্রি থেকে সরাবেন?',
      one: 'এই বিভাগটি মুছে ১টি এন্ট্রি থেকে সরাবেন?',
      zero: 'এই বিভাগটি মুছবেন?',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => 'তৈরির তারিখ';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি সেট সম্পাদনা করুন',
      one: '১টি সেট সম্পাদনা করুন',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => 'এখনো কোনো এন্ট্রি নেই';

  @override
  String get historyEmptyMessage =>
      'ইতিহাস শুরু করতে একটি সেট সম্পন্ন করুন বা হাতে একটি যোগ করুন।';

  @override
  String deleteSetConfirmation(String name) {
    return 'আপনি কি নিশ্চিত যে $name মুছতে চান?';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'আপনি কি নিশ্চিত যে $countটি এন্ট্রি মুছতে চান?',
      one: 'আপনি কি নিশ্চিত যে ১টি এন্ট্রি মুছতে চান?',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => 'ইতিহাস খুঁজুন...';

  @override
  String get themeSystem => 'সিস্টেম';

  @override
  String get themeDark => 'ডার্ক';

  @override
  String get themeLight => 'লাইট';

  @override
  String get pureBlackAmoled => 'সম্পূর্ণ কালো (AMOLED)';

  @override
  String get showImages => 'ছবি দেখান';

  @override
  String get peekGraph => 'গ্রাফের ঝলক দেখান';

  @override
  String get inputStyleLine => 'লাইন';

  @override
  String get inputStyleOutlined => 'আউটলাইন';

  @override
  String get inputStyleFilled => 'ভরাট';

  @override
  String get inputStyle => 'ইনপুট স্টাইল';

  @override
  String get appearance => 'চেহারা';

  @override
  String get automaticBackupsEnabled => 'স্বয়ংক্রিয় ব্যাকআপ চালু';

  @override
  String get automaticBackup => 'স্বয়ংক্রিয় ব্যাকআপ';

  @override
  String get appPermissions => 'অ্যাপের অনুমতি';

  @override
  String get shareDatabase => 'ডেটাবেস শেয়ার করুন';

  @override
  String get dataManagement => 'ডেটা ব্যবস্থাপনা';

  @override
  String get strengthUnit => 'শক্তির একক';

  @override
  String get lastEntry => 'শেষ এন্ট্রি';

  @override
  String get cardioUnit => 'কার্ডিও একক';

  @override
  String longDateFormat(String format) {
    return 'দীর্ঘ তারিখের ফরম্যাট ($format)';
  }

  @override
  String get formats => 'ফরম্যাট';

  @override
  String get setsPerExerciseMax => 'প্রতি ব্যায়ামে সেট (সর্বোচ্চ: 20)';

  @override
  String get countLabel => 'সংখ্যা';

  @override
  String get ratioLabel => 'অনুপাত';

  @override
  String get reorder => 'ক্রম বদলান';

  @override
  String get none => 'কোনোটিই নয়';

  @override
  String get monday => 'সোমবার';

  @override
  String get examplePlanExercises => 'বেঞ্চ প্রেস, স্কোয়াট, ডেডলিফট';

  @override
  String get tabs => 'ট্যাব';

  @override
  String get swipeBetweenTabs => 'ট্যাবের মধ্যে সোয়াইপ করুন';

  @override
  String get vibrate => 'ভাইব্রেট';

  @override
  String get enableSound => 'শব্দ চালু করুন';

  @override
  String get keepScreenOn => 'স্ক্রিন চালু রাখুন';

  @override
  String get alarmSound => 'অ্যালার্মের শব্দ';

  @override
  String get top => 'উপরে';

  @override
  String get bottom => 'নিচে';

  @override
  String get removeCustomTimer =>
      'কাস্টম টাইমার সরান (গ্লোবাল ডিফল্ট ব্যবহার করুন)';

  @override
  String get timers => 'টাইমার';

  @override
  String get timerSettings => 'টাইমার সেটিংস';

  @override
  String get groupHistory => 'ইতিহাস গ্রুপ করুন';

  @override
  String get showUnits => 'একক দেখান';

  @override
  String get showBodyWeight => 'শরীরের ওজন দেখান';

  @override
  String get showCategories => 'বিভাগ দেখান';

  @override
  String get showNotes => 'নোট দেখান';

  @override
  String get repEstimation => 'রেপ অনুমান';

  @override
  String get durationEstimation => 'সময়কাল অনুমান';

  @override
  String get showGraphLimit => 'গ্রাফ সীমা দেখান';

  @override
  String get defaultGraphMetric => 'ডিফল্ট গ্রাফ মেট্রিক';

  @override
  String get bestWeight => 'সর্বোচ্চ ওজন';

  @override
  String get bestReps => 'সর্বোচ্চ রেপ';

  @override
  String get oneRepMax => 'এক রেপ সর্বোচ্চ';

  @override
  String get volume => 'ভলিউম';

  @override
  String get paceCardio => 'গতি (কার্ডিও)';

  @override
  String get distanceCardio => 'দূরত্ব (কার্ডিও)';

  @override
  String get defaultGraphPeriod => 'ডিফল্ট গ্রাফ সময়কাল';

  @override
  String get defaultGraphLimit => 'ডিফল্ট গ্রাফ সীমা';

  @override
  String get workouts => 'ওয়ার্কআউট';

  @override
  String get actionStop => 'থামান';

  @override
  String get timerFinishedToast => 'টাইমার শেষ!';

  @override
  String get stopTimer => 'টাইমার থামান';

  @override
  String get actionPause => 'বিরতি';

  @override
  String get startStopwatch => 'স্টপওয়াচ শুরু করুন';

  @override
  String get actionStart => 'শুরু করুন';

  @override
  String get actionRestart => 'আবার শুরু করুন';

  @override
  String get addOneMinute => '+১ মিনিট';

  @override
  String get addOneMinuteNotification => '১ মিনিট যোগ করুন';

  @override
  String get restTimer => 'বিশ্রাম টাইমার';

  @override
  String get timerUp => 'টাইমার শেষ';

  @override
  String get openNotification => 'নোটিফিকেশন খুলুন';

  @override
  String get timerChannelName => 'টাইমার চ্যানেল';

  @override
  String get timerChannelDescription => 'বিশ্রাম টাইমারের চলমান অগ্রগতি।';

  @override
  String get timerFinishedChannelName => 'টাইমার শেষ চ্যানেল';

  @override
  String get timerFinishedChannelDescription =>
      'বিশ্রাম টাইমার শেষ হলে অ্যালার্ম বাজায়।';

  @override
  String get timerFinished => 'টাইমার শেষ';

  @override
  String get batteryOptimizationRequestUnavailable =>
      'আপনার ডিভাইসে ব্যাটারি অপ্টিমাইজেশন উপেক্ষা করার অনুরোধ বন্ধ করা আছে।';

  @override
  String get exactAlarmRequestUnavailable =>
      'আপনার ডিভাইসে SCHEDULE_EXACT_ALARM-এর অনুরোধ প্রত্যাখ্যাত হয়েছে';

  @override
  String get databaseMigrationFailureDescription =>
      'ডেটাবেস তৈরি বা আপগ্রেড করার সময় কিছু ভুল হয়েছে। সাধারণত রেকর্ড মুছে আবার তৈরি করলে এটি ঠিক হয়।';

  @override
  String get curveSmoothness => 'বক্ররেখার মসৃণতা';

  @override
  String get actionBack => 'পেছনে';

  @override
  String get atLeastOneTab => 'অন্তত একটি ট্যাব প্রয়োজন';

  @override
  String get invalidTabSettings => 'ট্যাব সেটিংস সঠিক নয়।';

  @override
  String get noSettingsFound => 'কোনো সেটিংস পাওয়া যায়নি';

  @override
  String nothingMatchesSearch(String query) {
    return '“$query”-এর সঙ্গে কিছুই মেলেনি।';
  }

  @override
  String get appearanceDescription => 'থিম, রং এবং ইন্টারফেসের স্টাইল';

  @override
  String get dataManagementDescription =>
      'আপনার ওয়ার্কআউট ডেটা আমদানি, রপ্তানি ও পরিচালনা করুন';

  @override
  String get formatsDescription => 'তারিখ, সংখ্যা ও পরিমাপের ফরম্যাট';

  @override
  String get plansSettingsDescription => 'ওয়ার্কআউট পরিকল্পনার ডিফল্ট ও আচরণ';

  @override
  String get tabsDescription => 'প্রধান নেভিগেশন ট্যাব বেছে নিয়ে সাজান';

  @override
  String get timersDescription => 'বিশ্রাম টাইমারের সময়কাল, শব্দ ও আচরণ';

  @override
  String get workoutsDescription => 'ব্যায়াম ট্র্যাকিং ও ওয়ার্কআউট পছন্দ';

  @override
  String get completeSetForChart =>
      'এই ব্যায়ামের চার্ট তৈরি করতে একটি সেট সম্পন্ন করুন।';

  @override
  String get dateRange => 'তারিখের সীমা';

  @override
  String get stopDate => 'শেষের তারিখ';

  @override
  String get dataPoints => 'ডেটা পয়েন্ট';

  @override
  String get completeSetsForProgress =>
      'আপনার অগ্রগতির চার্ট তৈরি করতে কয়েকটি সেট সম্পন্ন করুন।';

  @override
  String get relativeStrength => 'আপেক্ষিক শক্তি';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি নির্বাচিত',
      one: '১টি নির্বাচিত',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory =>
      'এই ব্যায়ামের ইতিহাস এখানে দেখতে কয়েকটি সেট সম্পন্ন করুন।';

  @override
  String get completeSetForFirstGraph =>
      'প্রথম ব্যায়াম গ্রাফ তৈরি করতে একটি সেট সম্পন্ন করুন।';

  @override
  String nothingMatchesGraphSearch(String query) {
    return '“$query”-এর সঙ্গে কিছুই মেলেনি। এটিকে নতুন ব্যায়াম হিসেবে তৈরি করতে পারেন।';
  }

  @override
  String addNamed(String name) {
    return '“$name” যোগ করুন';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return 'এতে $countটি রেকর্ড মুছে যাবে। আপনি কি নিশ্চিত?';
  }

  @override
  String shareWorkout(String summary) {
    return 'আমি এইমাত্র $summary করেছি';
  }

  @override
  String get updateConflict => 'আপডেট দ্বন্দ্ব';

  @override
  String updateConflictDescription(int count) {
    return 'আপনার নতুন নামটি ইতিমধ্যে $countটি রেকর্ডে আছে। আপনি কি নিশ্চিত?';
  }

  @override
  String get unitsConflict => 'এককের দ্বন্দ্ব';

  @override
  String unitsConflictDescription(String unit) {
    return 'আপনার সব রেকর্ডে একই একক নেই। এতে সব একক $unit-এ রূপান্তর হবে। আপনি কি নিশ্চিত?';
  }

  @override
  String get durationLabel => 'সময়কাল';

  @override
  String get inclineLabel => 'ঢাল';

  @override
  String get paceDistanceTime => 'গতি (দূরত্ব / সময়)';

  @override
  String get adjustedPace => 'সমন্বিত গতি';

  @override
  String get oneRepMaxAccuracyWarning =>
      '১০ বা তার বেশি রেপের সেটে এক রেপ সর্বোচ্চের অনুমান কম নির্ভুল';

  @override
  String get addPlan => 'পরিকল্পনা যোগ করুন';

  @override
  String get planDetails => 'পরিকল্পনার বিবরণ';

  @override
  String get exercisesLabel => 'ব্যায়ামসমূহ';

  @override
  String get addExerciseToPlan => 'এই পরিকল্পনায় একটি ব্যায়াম যোগ করুন।';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return '“$query”-এর সঙ্গে কিছুই মেলেনি। এটিকে নতুন ব্যায়াম হিসেবে যোগ করতে পারেন।';
  }

  @override
  String get selectDays => 'দিন নির্বাচন করুন';

  @override
  String get selectExercises => 'ব্যায়াম নির্বাচন করুন';

  @override
  String get todayLabel => 'আজ';

  @override
  String get setDetails => 'সেটের বিবরণ';

  @override
  String get themeLabel => 'থিম';

  @override
  String get pureBlackAmoledDescription =>
      'AMOLED ডিসপ্লের জন্য সম্পূর্ণ কালো রং ব্যবহার করুন';

  @override
  String get systemColorScheme => 'সিস্টেমের রঙের স্কিম';

  @override
  String get systemColorSchemeDescription =>
      'অ্যাপে আপনার ডিভাইসের প্রধান রং ব্যবহার করুন';

  @override
  String get showImagesDescription => 'ইতিহাস পৃষ্ঠায় ছবি বাছুন ও দেখান';

  @override
  String get showGlobalProgress => 'সামগ্রিক অগ্রগতি দেখান';

  @override
  String get showGlobalProgressDescription =>
      'বিভাগ অনুযায়ী আপনার অগ্রগতি দেখাতে একটি গ্রাফ এন্ট্রি যোগ করুন';

  @override
  String get peekGraphDescription => 'গ্রাফ পৃষ্ঠায় প্রথম লাইন গ্রাফটি দেখান';

  @override
  String get inputStyleDescription => 'টেক্সট ইনপুট ফিল্ডের দৃশ্যমান স্টাইল';

  @override
  String get automaticBackupNotificationBody =>
      'Flexify প্রতিদিন নির্বাচিত ফোল্ডারে আপনার ডেটা ও ছবি স্বয়ংক্রিয়ভাবে ব্যাকআপ করবে।';

  @override
  String get backupSettingsChannel => 'ব্যাকআপ সেটিংস';

  @override
  String get backupSettingsChannelDescription =>
      'স্বয়ংক্রিয় ব্যাকআপ ব্যাখ্যা করা নোটিফিকেশন';

  @override
  String get backupChannelName => 'ব্যাকআপ চ্যানেল';

  @override
  String get backupChannelDescription =>
      'Flexify-এর ডেটা ও ছবির স্বয়ংক্রিয় ব্যাকআপ';

  @override
  String get backupCompletedTitle => 'ডেটা ও ছবি ব্যাকআপ হয়েছে';

  @override
  String get backupFailurePathNotSet =>
      'ব্যাকআপ ব্যর্থ: ব্যাকআপ পথ সেট করা নেই। স্বয়ংক্রিয় ব্যাকআপ বন্ধ করা হয়েছে।';

  @override
  String get backupFailureDirectoryUnavailable =>
      'ব্যাকআপ ব্যর্থ: ব্যাকআপ ডিরেক্টরি অ্যাক্সেস করা যায়নি। স্বয়ংক্রিয় ব্যাকআপ বন্ধ করা হয়েছে।';

  @override
  String get backupFailureCreateFile =>
      'ব্যাকআপ ব্যর্থ: ব্যাকআপ ফাইল তৈরি করা যায়নি। স্বয়ংক্রিয় ব্যাকআপ বন্ধ করা হয়েছে।';

  @override
  String get backupFailureAppFilesUnavailable =>
      'ব্যাকআপ ব্যর্থ: অ্যাপ্লিকেশনের ফাইল ডিরেক্টরি অ্যাক্সেস করা যায়নি। স্বয়ংক্রিয় ব্যাকআপ বন্ধ করা হয়েছে।';

  @override
  String get backupFailureDatabaseMissing =>
      'ব্যাকআপ ব্যর্থ: ডেটাবেস ফাইল পাওয়া যায়নি। স্বয়ংক্রিয় ব্যাকআপ বন্ধ করা হয়েছে।';

  @override
  String get backupFailureOutputUnavailable =>
      'ব্যাকআপ ব্যর্থ: আউটপুট স্ট্রিম খোলা যায়নি। স্বয়ংক্রিয় ব্যাকআপ বন্ধ করা হয়েছে।';

  @override
  String get backupFailureUnknown =>
      'ব্যাকআপ ব্যর্থ হয়েছে। স্বয়ংক্রিয় ব্যাকআপ বন্ধ করা হয়েছে।';

  @override
  String get appPermissionsDescription =>
      'চালু থাকা ফিচারগুলোর জন্য প্রয়োজনীয় অ্যাক্সেস পর্যালোচনা করুন';

  @override
  String get longDateFormatDescription =>
      'যেখানে পর্যাপ্ত জায়গা আছে সেখানে ব্যবহৃত হয়';

  @override
  String shortDateFormat(String example) {
    return 'সংক্ষিপ্ত তারিখের ফরম্যাট ($example)';
  }

  @override
  String get shortDateFormatDescription => 'যেখানে জায়গা কম (গ্রাফের লাইন)';

  @override
  String get warmupSetsDescription => 'ওয়ার্ম-আপ সেটে বিশ্রাম টাইমার থাকে না';

  @override
  String get setsPerExerciseDescription =>
      'একটি পরিকল্পনায় ব্যায়ামের ডিফল্ট সংখ্যা';

  @override
  String get planTrailingDisplay => 'পরিকল্পনার শেষাংশের প্রদর্শন';

  @override
  String get planTrailingDisplayDescription =>
      'Plans ও Plan ভিউয়ের তালিকার ডান পাশে যা দেখানো হবে';

  @override
  String get restTimersDescription =>
      'একটি সেট সম্পন্ন করার পর যে অ্যালার্ম বাজে';

  @override
  String get vibrateDescription => 'বিশ্রাম টাইমারে ভাইব্রেশন হবে?';

  @override
  String get enableSoundDescription => 'বিশ্রাম টাইমারে শব্দ বাজবে?';

  @override
  String get keepScreenOnDescription =>
      'বিশ্রাম টাইমার চলার সময় স্ক্রিন চালু রাখুন';

  @override
  String get restDurationDescription =>
      'বিশ্রামের অ্যালার্ম বাজতে কতক্ষণ অপেক্ষা করবে?';

  @override
  String get globalDefault => 'গ্লোবাল ডিফল্ট';

  @override
  String get alarmSoundDescription => 'বিশ্রাম টাইমার শেষে যে সঙ্গীত বাজবে';

  @override
  String get progressBarPosition => 'প্রগ্রেস বারের অবস্থান';

  @override
  String get progressBarPositionDescription =>
      'বিশ্রাম টাইমারের প্রগ্রেস বার কোথায় থাকবে?';

  @override
  String get perExerciseRestTimes => 'ব্যায়ামভিত্তিক বিশ্রামের সময়';

  @override
  String get perExerciseRestTimesDescription =>
      'এই ব্যায়ামগুলোর জন্য কাস্টম বিশ্রামের সময় আছে';

  @override
  String get audioFeaturesUnavailable => 'অডিও ফিচার উপলভ্য নয়';

  @override
  String get groupHistoryDescription =>
      'দিন অনুযায়ী ইতিহাসের এন্ট্রিগুলো একত্র করুন';

  @override
  String get showUnitsDescription =>
      'গ্রাফ/ইতিহাস/পরিকল্পনায় km/mi, kg/lb দেখান';

  @override
  String get showBodyWeightDescription => 'শরীরের ওজন ট্র্যাকিং চালু/বন্ধ করুন';

  @override
  String get showCategoriesDescription => 'ওয়ার্কআউট বিভাগ চালু/বন্ধ করুন';

  @override
  String get showNotesDescription => 'টেক্সট বক্সে আপনার লিফটের বিবরণ লিখুন';

  @override
  String get positiveNotificationsDescription =>
      'নতুন রেকর্ড হলে উৎসাহমূলক বার্তা লিখুন';

  @override
  String get positiveMessagesEnabled => 'ইতিবাচক বার্তা এখন এভাবেই দেখাবে!';

  @override
  String get recordEncouragement01 => 'দারুণ কাজ! আপনি অসাধারণ।';

  @override
  String get recordEncouragement02 =>
      'দারুণ, কিং! আপনার অগ্রগতি অনুপ্রেরণাদায়ক।';

  @override
  String get recordEncouragement03 => 'আমি নত হলাম...';

  @override
  String get recordEncouragement04 => 'এটা কী? নতুন রেকর্ড!';

  @override
  String get recordEncouragement05 => 'অসাধারণ! আপনি সত্যিই অনুপ্রেরণা।';

  @override
  String get recordEncouragement06 => 'ওয়াও। দারুণ।';

  @override
  String get recordEncouragement07 => 'বেশ শক্তিশালী হয়ে উঠছেন, তাই না?';

  @override
  String get recordEncouragement08 => 'হ্যাঁ। আপনি তো বেশ বড়সড় হয়ে উঠেছেন।';

  @override
  String get recordEncouragement09 => 'চমৎকার। অবিশ্বাস্য।';

  @override
  String get recordEncouragement10 => 'আর্নি গর্বিত হতেন।';

  @override
  String get recordEncouragement11 => 'রনি সি আনন্দে আপনার দিকে তাকিয়ে আছেন।';

  @override
  String get recordEncouragement12 => 'হ্যাঁ! লাইটওয়েট বেবি!!!!!!!';

  @override
  String get recordEncouragement13 => 'এটা কি নতুন রেকর্ড? জানতাম আপনি পারবেন।';

  @override
  String get recordEncouragement14 => 'দারুণ কাজ! আপনাকে নিয়ে আমি গর্বিত।';

  @override
  String get recordEncouragement15 => 'হ্যাঁ বেবি! লাইট ওয়েট!';

  @override
  String get recordEncouragement16 => 'চালিয়ে যান! দারুণ অগ্রগতি।';

  @override
  String get recordEncouragement17 => 'আপনি খুব ভালো করছেন।';

  @override
  String get recordEncouragement18 => 'এই তো আমার ছেলে!';

  @override
  String get recordEncouragement19 => 'চালিয়ে যান।';

  @override
  String get recordEncouragement20 => 'আপনি খুব শক্তিশালী হয়ে উঠছেন।';

  @override
  String get recordEncouragement21 => 'শক্তিশালী।';

  @override
  String get recordEncouragement22 => 'দারুণ শক্তি!';

  @override
  String get recordEncouragement23 => 'আপনাকে নিয়ে আমি গর্বিত।';

  @override
  String get recordEncouragement24 => 'এই দারুণ কাজ চালিয়ে যান।';

  @override
  String get recordEncouragement25 =>
      'বুক উঁচু করে দাঁড়ান! আপনি নতুন রেকর্ড করেছেন।';

  @override
  String get recordEncouragement26 =>
      'নতুন রেকর্ড! আপনি আগের সব সীমা ছাড়িয়ে গেছেন!';

  @override
  String get recordEncouragement27 => 'হ্যাঁ! এটা রেকর্ড।';

  @override
  String get recordEncouragement28 => 'ওয়াও! নতুন রেকর্ড!';

  @override
  String get recordEncouragement29 => 'খুব ভালো কাজ।';

  @override
  String get repEstimationDescription =>
      'আপনি এইমাত্র কত রেপ করেছেন তা অনুমান করার চেষ্টা করুন';

  @override
  String get durationEstimationDescription =>
      'আপনার কার্ডিও কতক্ষণ চলেছে তা অনুমান করার চেষ্টা করুন';

  @override
  String get showGraphXAxisToggle => 'গ্রাফের X অক্ষ টগল দেখান';

  @override
  String get showGraphXAxisToggleDescription =>
      'গ্রাফে সময়ভিত্তিক X অক্ষের টগল দেখান';

  @override
  String get showGraphLimitDescription => 'গ্রাফে সীমা স্লাইডার দেখান';

  @override
  String get defaultTimeBasedXAxis => 'ডিফল্ট সময়ভিত্তিক X অক্ষ';

  @override
  String get defaultTimeBasedXAxisDescription =>
      'গ্রাফে ডিফল্টভাবে সময়ভিত্তিক X অক্ষ ব্যবহার করুন';

  @override
  String get createFirstTrainingPlan =>
      'শুরু করতে আপনার প্রথম ট্রেনিং পরিকল্পনা তৈরি করুন।';

  @override
  String nothingMatchesPlanSearch(String query) {
    return '“$query”-এর সঙ্গে কিছুই মেলেনি। এটিকে নতুন পরিকল্পনা হিসেবে তৈরি করতে পারেন।';
  }

  @override
  String get createPlan => 'পরিকল্পনা তৈরি করুন';

  @override
  String createNamedPlan(String name) {
    return '“$name” তৈরি করুন';
  }

  @override
  String setNumber(int number) {
    return 'সেট $number';
  }
}
