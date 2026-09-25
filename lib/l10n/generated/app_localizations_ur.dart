// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => 'زبان';

  @override
  String get settingsLanguageDescription =>
      'Flexify میں استعمال ہونے والی زبان منتخب کریں';

  @override
  String get languageSystemDefault => 'سسٹم ڈیفالٹ';

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
  String get navHistory => 'تاریخ';

  @override
  String get navPlans => 'منصوبے';

  @override
  String get navGraphs => 'گراف';

  @override
  String get navTimer => 'ٹائمر';

  @override
  String get navSettings => 'ترتیبات';

  @override
  String get errorLabel => 'خرابی';

  @override
  String get tabContentError => 'ٹیب کا مواد تیار نہیں ہو سکا۔';

  @override
  String get cannotHideAllTabs => 'سب کچھ نہیں چھپایا جا سکتا!';

  @override
  String removeTabQuestion(String tab) {
    return '$tab ٹیب ہٹائیں؟';
  }

  @override
  String get restoreTabFromSettings =>
      'آپ اسے بعد میں ترتیبات سے دوبارہ شامل کر سکتے ہیں۔';

  @override
  String removedTab(String tab) {
    return '$tab ہٹا دیا گیا';
  }

  @override
  String newVersion(String version) {
    return 'نیا ورژن $version';
  }

  @override
  String get changes => 'تبدیلیاں';

  @override
  String get searchHint => 'تلاش کریں...';

  @override
  String get deleteSelected => 'منتخب شدہ حذف کریں';

  @override
  String get confirmDelete => 'حذف کرنے کی تصدیق';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'کیا آپ واقعی $count ریکارڈ حذف کرنا چاہتے ہیں؟ یہ عمل واپس نہیں لیا جا سکتا۔',
      one:
          'کیا آپ واقعی 1 ریکارڈ حذف کرنا چاہتے ہیں؟ یہ عمل واپس نہیں لیا جا سکتا۔',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'منسوخ کریں';

  @override
  String get actionDelete => 'حذف کریں';

  @override
  String get actionRemove => 'ہٹائیں';

  @override
  String get actionEdit => 'ترمیم';

  @override
  String get actionShare => 'شیئر کریں';

  @override
  String get clearSelection => 'انتخاب صاف کریں';

  @override
  String get clearSearch => 'تلاش صاف کریں';

  @override
  String get showMenu => 'مینو دکھائیں';

  @override
  String get selectAll => 'سب منتخب کریں';

  @override
  String get weightLabel => 'وزن';

  @override
  String get filter => 'فلٹر';

  @override
  String get filters => 'فلٹرز';

  @override
  String get categoryLabel => 'زمرہ';

  @override
  String get repsLabel => 'ریپس';

  @override
  String get repsFilter => 'ریپس فلٹر';

  @override
  String get weightFilter => 'وزن فلٹر';

  @override
  String get greaterThan => 'سے زیادہ';

  @override
  String get lessThan => 'سے کم';

  @override
  String get startDate => 'شروع کی تاریخ';

  @override
  String get endDate => 'اختتامی تاریخ';

  @override
  String get actionClear => 'صاف کریں';

  @override
  String get actionOk => 'ٹھیک ہے';

  @override
  String get actionClose => 'بند کریں';

  @override
  String get sortBy => 'ترتیب دیں';

  @override
  String get dateNewest => 'تاریخ (نئی پہلے)';

  @override
  String get dateOldest => 'تاریخ (پرانی پہلے)';

  @override
  String get nameLabel => 'نام';

  @override
  String get missingPermissions => 'اجازتیں موجود نہیں';

  @override
  String get restTimersPermissionsMissing =>
      'آرام کے ٹائمر فعال ہیں، لیکن اجازتیں موجود نہیں ہیں۔';

  @override
  String get restTimersPermissionsOptional =>
      'اگر آپ آرام کے ٹائمر بند کر دیں تو ان اجازتوں کی ضرورت نہیں رہے گی۔';

  @override
  String get restTimers => 'آرام کے ٹائمر';

  @override
  String get disableBatteryOptimizations => 'بیٹری آپٹیمائزیشن بند کریں';

  @override
  String get batteryOptimizationWarning =>
      'اگر بیٹری آپٹیمائزیشن فعال رہی تو پیش رفت رک سکتی ہے۔';

  @override
  String get scheduleExactAlarm => 'عین وقت کا الارم شیڈول کریں';

  @override
  String get exactAlarmWarning =>
      'اگر یہ بند ہو تو الارم درست وقت پر نہیں بج سکتے۔';

  @override
  String get postNotifications => 'نوٹیفکیشنز دکھائیں';

  @override
  String get notificationBarDescription =>
      'ٹائمر کی پیش رفت نوٹیفکیشن بار میں دکھائی جاتی ہے';

  @override
  String get invalidPermissions => 'غلط اجازتیں';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      'کافی اجازتوں کے بغیر آرام کے ٹائمر فعال ہیں۔ کیا آپ کو یقین ہے؟';

  @override
  String get actionConfirm => 'تصدیق کریں';

  @override
  String get appAccess => 'ایپ رسائی';

  @override
  String get appAccessDescription =>
      'فعال ٹائمرز اور نوٹیفکیشنز کے لیے درکار ہے۔';

  @override
  String get notifications => 'نوٹیفکیشنز';

  @override
  String get timerProgressAndRestAlerts =>
      'ٹائمر کی پیش رفت اور آرام کے انتباہات';

  @override
  String get enabledNotificationsDescription =>
      'وہ نوٹیفکیشنز جو آپ نے فعال کیے ہیں';

  @override
  String get backgroundActivity => 'پس منظر کی سرگرمی';

  @override
  String get backgroundActivityDescription =>
      'پس منظر میں بھی ٹائمرز کو قابلِ اعتماد رکھیں';

  @override
  String get exactAlarms => 'عین وقت کے الارم';

  @override
  String get exactAlarmsDescription =>
      'آرام کا ٹائمر ختم ہوتے ہی بالکل اسی وقت اطلاع دیں';

  @override
  String get noAdditionalAndroidAccessNeeded =>
      'آپ کی موجودہ ترتیبات کے لیے کسی اضافی Android رسائی کی ضرورت نہیں۔';

  @override
  String get actionDone => 'مکمل';

  @override
  String get allowed => 'اجازت یافتہ';

  @override
  String get actionAllow => 'اجازت دیں';

  @override
  String get backupLabel => 'بیک اپ';

  @override
  String get databaseLabel => 'ڈیٹابیس';

  @override
  String get deleteRecords => 'ریکارڈز حذف کریں';

  @override
  String get deleteAllGraphsConfirmation =>
      'کیا آپ واقعی تمام گراف حذف کرنا چاہتے ہیں؟ یہ عمل واپس نہیں لیا جا سکتا۔';

  @override
  String get deleteAllPlansConfirmation =>
      'کیا آپ واقعی تمام منصوبے حذف کرنا چاہتے ہیں؟ یہ عمل واپس نہیں لیا جا سکتا۔';

  @override
  String get deleteDatabaseConfirmation =>
      'کیا آپ واقعی اپنا ڈیٹابیس حذف کرنا چاہتے ہیں؟ یہ عمل واپس نہیں لیا جا سکتا اور آپ کا تمام ڈیٹا ضائع ہو جائے گا۔';

  @override
  String get importData => 'ڈیٹا درآمد کریں';

  @override
  String get exportData => 'ڈیٹا برآمد کریں';

  @override
  String get actionReport => 'رپورٹ کریں';

  @override
  String get graphDataImported => 'گراف ڈیٹا کامیابی سے درآمد ہو گیا!';

  @override
  String get plansImported => 'منصوبے کامیابی سے درآمد ہو گئے';

  @override
  String failedToImportDatabase(String error) {
    return 'ڈیٹابیس درآمد نہیں ہو سکا: $error';
  }

  @override
  String get backupArchiveMissingDatabase =>
      'بیک اپ آرکائیو میں Flexify ڈیٹابیس موجود نہیں ہے۔';

  @override
  String failedToImportGraphs(String error) {
    return 'گراف درآمد نہیں ہو سکے: $error';
  }

  @override
  String failedToImportPlans(String error) {
    return 'منصوبے درآمد نہیں ہو سکے: $error';
  }

  @override
  String get selectedFileDoesNotExist => 'منتخب فائل موجود نہیں ہے';

  @override
  String get couldNotReadFileData => 'فائل کا ڈیٹا پڑھا نہیں جا سکا';

  @override
  String get databaseImportWebUnsupported =>
      'ویب پر ڈیٹابیس درآمد کرنے کے لیے ڈیٹا کو دستی طور پر منتقل کرنا ضروری ہے۔ براہِ کرم اپنا ڈیٹا CSV فائلوں کے طور پر برآمد کریں اور پھر انہیں درآمد کریں۔';

  @override
  String get csvFileEmpty => 'CSV فائل خالی ہے';

  @override
  String get csvNeedsDataRow =>
      'CSV فائل میں کم از کم ایک ڈیٹا قطار ہونی چاہیے';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return 'قطار $row میں کافی کالم نہیں ہیں: $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return 'قطار $row میں $field کی قدر غلط ہے: $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return 'قطار $row میں $field کا ڈیٹا ٹائپ غلط ہے: $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return 'صحیح عدد plan id درکار تھا، ملا \"$value\"';
  }

  @override
  String get unitLabel => 'اکائی';

  @override
  String get kilogramsUnit => 'کلوگرام (kg)';

  @override
  String get poundsUnit => 'پاؤنڈ (lb)';

  @override
  String get stoneUnit => 'اسٹون';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => 'کلومیٹر (km)';

  @override
  String get milesUnit => 'میل (mi)';

  @override
  String get metersUnit => 'میٹر (m)';

  @override
  String get kilocaloriesUnit => 'کلوکیلوریز (kcal)';

  @override
  String get enterWeight => 'وزن درج کریں';

  @override
  String get requiredField => 'ضروری';

  @override
  String get invalidNumber => 'غلط عدد';

  @override
  String get previousWeight => 'پچھلا وزن';

  @override
  String get imageLabel => 'تصویر';

  @override
  String get longPressToDelete => 'حذف کرنے کے لیے دیر تک دبائیں';

  @override
  String get imageError => 'تصویر کی خرابی';

  @override
  String get actionSave => 'محفوظ کریں';

  @override
  String get aboutTitle => 'بارے میں';

  @override
  String get donate => 'عطیہ دیں';

  @override
  String get helpSupportProject => 'اس منصوبے کی حمایت کریں';

  @override
  String get whatsNewAbout => 'نیا کیا ہے؟';

  @override
  String get whatsNewTitle => 'نیا کیا ہے؟';

  @override
  String get seeReleaseNotes => 'ہمارے ریلیز نوٹس دیکھیں';

  @override
  String get versionLabel => 'ورژن';

  @override
  String get authorLabel => 'مصنف';

  @override
  String get privacyPolicy => 'رازداری کی پالیسی';

  @override
  String get privacyPolicyDescription =>
      'Flexify آپ کے ڈیٹا کو کیسے سنبھالتا ہے';

  @override
  String get licenseLabel => 'لائسنس';

  @override
  String get sourceCode => 'سورس کوڈ';

  @override
  String get sourceCodeDescription => 'GitHub پر دیکھیں';

  @override
  String get leaveReview => 'جائزہ دیں';

  @override
  String get leaveReviewDescription =>
      'Play Store پر Flexify کی درجہ بندی کریں';

  @override
  String get reportBug => 'بگ رپورٹ کریں';

  @override
  String get reportBugDescription => 'GitHub پر ٹکٹ کھولیں';

  @override
  String get failedMigrations => 'ناکام مائیگریشنز';

  @override
  String get errorMessageLabel => 'خرابی کا پیغام:';

  @override
  String get createIssue => 'ایشو بنائیں';

  @override
  String get addExercise => 'ورزش شامل کریں';

  @override
  String get cardio => 'کارڈیو';

  @override
  String get strength => 'طاقت';

  @override
  String get options => 'اختیارات';

  @override
  String get periodDay => 'دن';

  @override
  String get periodWeek => 'ہفتہ';

  @override
  String get periodMonth => 'مہینہ';

  @override
  String get periodYear => 'سال';

  @override
  String noDataFor(String name) {
    return '$name کے لیے ابھی کوئی ڈیٹا نہیں';
  }

  @override
  String get noDataYet => 'ابھی کوئی ڈیٹا نہیں';

  @override
  String get exerciseNotes => 'ورزش کے نوٹس';

  @override
  String get notesForExercise => 'اس ورزش کے لیے نوٹس';

  @override
  String get useTimeBasedXAxis => 'وقت پر مبنی X محور استعمال کریں';

  @override
  String updateAllNamed(String name) {
    return 'تمام $name اپ ڈیٹ کریں';
  }

  @override
  String get newName => 'نیا نام';

  @override
  String get restMinutes => 'آرام کے منٹ';

  @override
  String get restSeconds => 'آرام کے سیکنڈ';

  @override
  String get globalProgress => 'مجموعی پیش رفت';

  @override
  String get curveLineGraphs => 'گراف کی لائنیں خم دار کریں';

  @override
  String get curveLineGraphsDescription =>
      'گراف کی لائنیں ہموار منحنی خطوط کے طور پر بنائیں';

  @override
  String noHistoryFor(String name) {
    return '$name کے لیے ابھی کوئی تاریخچہ نہیں';
  }

  @override
  String get cancelSelection => 'انتخاب منسوخ کریں';

  @override
  String get editSelected => 'منتخب شدہ میں ترمیم کریں';

  @override
  String get newExercise => 'نئی ورزش';

  @override
  String get noGraphsFound => 'کوئی گراف نہیں ملا';

  @override
  String get searchGraphs => 'گراف تلاش کریں...';

  @override
  String get actionAdd => 'شامل کریں';

  @override
  String get actionUpdate => 'اپ ڈیٹ کریں';

  @override
  String get hideGlobalProgress => 'مجموعی پیش رفت چھپائیں';

  @override
  String get chartGroupedByCategory => 'زمرے کے لحاظ سے گروپ کیا گیا چارٹ';

  @override
  String get noExercisesFound => 'کوئی ورزش نہیں ملی';

  @override
  String get savePlan => 'منصوبہ محفوظ کریں';

  @override
  String get titleOptional => 'عنوان (اختیاری)';

  @override
  String get searchExercises => 'ورزشیں تلاش کریں...';

  @override
  String get warmupSets => 'وارم اپ سیٹس';

  @override
  String get workingSetsMax => 'ورکنگ سیٹس (زیادہ سے زیادہ: 20)';

  @override
  String get actionUndo => 'واپس کریں';

  @override
  String get actionSwap => 'تبدیل کریں';

  @override
  String get daily => 'روزانہ';

  @override
  String get weekly => 'ہفتہ وار';

  @override
  String get monthly => 'ماہانہ';

  @override
  String get yearly => 'سالانہ';

  @override
  String get unexpectedError => 'کچھ غلط ہو گیا۔ دوبارہ کوشش کریں۔';

  @override
  String get loadingExercises => 'ورزشیں لوڈ ہو رہی ہیں...';

  @override
  String get noPlansYet => 'ابھی کوئی منصوبہ نہیں';

  @override
  String get noMatchingPlans => 'کوئی مماثل منصوبہ نہیں';

  @override
  String get newPlan => 'نیا منصوبہ';

  @override
  String get searchPlans => 'منصوبے تلاش کریں...';

  @override
  String get noExercisesYet => 'ابھی کوئی ورزش نہیں';

  @override
  String get editPlan => 'منصوبے میں ترمیم کریں';

  @override
  String get saveSet => 'سیٹ محفوظ کریں';

  @override
  String get minutesLabel => 'منٹ';

  @override
  String get minutesShort => 'منٹ';

  @override
  String get secondsLabel => 'سیکنڈ';

  @override
  String get distanceLabel => 'فاصلہ';

  @override
  String get inclinePercent => 'ڈھلوان %';

  @override
  String weightWithUnit(String unit) {
    return 'وزن ($unit)';
  }

  @override
  String get useBodyWeight => 'جسمانی وزن استعمال کریں';

  @override
  String get noWeightEnteredYet => 'ابھی کوئی وزن درج نہیں کیا گیا';

  @override
  String get notesLabel => 'نوٹس';

  @override
  String get swapWorkout => 'ورک آؤٹ تبدیل کریں';

  @override
  String get addSet => 'سیٹ شامل کریں';

  @override
  String get deleteSet => 'سیٹ حذف کریں';

  @override
  String get oneRepMaxEstimate => 'ایک ریپ زیادہ سے زیادہ (تخمینہ)';

  @override
  String get valueLabel => 'قدر';

  @override
  String amountWithUnit(String unit) {
    return 'مقدار ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return 'فاصلہ ($unit)';
  }

  @override
  String get bodyWeightLabel => 'جسمانی وزن';

  @override
  String bodyWeightWithUnit(String unit) {
    return 'جسمانی وزن ($unit)';
  }

  @override
  String get categoryHelper => 'موجودہ زمرہ منتخب کریں یا نیا لکھیں۔';

  @override
  String get manageCategories => 'زمروں کا انتظام کریں';

  @override
  String get manageCategoriesDescription =>
      'زمرے بنائیں، نام بدلیں، ضم کریں یا ہٹائیں';

  @override
  String get newCategory => 'نیا زمرہ';

  @override
  String get renameCategory => 'زمرے کا نام بدلیں';

  @override
  String get mergeCategory => 'دوسرے زمرے میں ضم کریں';

  @override
  String get noCategories => 'ابھی کوئی زمرہ نہیں';

  @override
  String get categoryNameRequired => 'زمرے کا نام درج کریں';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count اندراجات میں استعمال ہوا',
      one: '1 اندراج میں استعمال ہوا',
      zero: 'کسی اندراج میں استعمال نہیں ہوا',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'یہ زمرہ حذف کر کے اسے $count اندراجات سے ہٹائیں؟',
      one: 'یہ زمرہ حذف کر کے اسے 1 اندراج سے ہٹائیں؟',
      zero: 'یہ زمرہ حذف کریں؟',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => 'تخلیق کی تاریخ';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سیٹس میں ترمیم کریں',
      one: '1 سیٹ میں ترمیم کریں',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => 'ابھی کوئی اندراج نہیں';

  @override
  String get historyEmptyMessage =>
      'اپنا تاریخچہ شروع کرنے کے لیے ایک سیٹ مکمل کریں یا دستی طور پر شامل کریں۔';

  @override
  String deleteSetConfirmation(String name) {
    return 'کیا آپ واقعی $name حذف کرنا چاہتے ہیں؟';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'کیا آپ واقعی $count اندراجات حذف کرنا چاہتے ہیں؟',
      one: 'کیا آپ واقعی 1 اندراج حذف کرنا چاہتے ہیں؟',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => 'تاریخچہ تلاش کریں...';

  @override
  String get themeSystem => 'سسٹم';

  @override
  String get themeDark => 'ڈارک';

  @override
  String get themeLight => 'لائٹ';

  @override
  String get pureBlackAmoled => 'مکمل سیاہ (AMOLED)';

  @override
  String get showImages => 'تصاویر دکھائیں';

  @override
  String get peekGraph => 'گراف کی جھلک دکھائیں';

  @override
  String get inputStyleLine => 'لائن';

  @override
  String get inputStyleOutlined => 'آؤٹ لائن';

  @override
  String get inputStyleFilled => 'بھرا ہوا';

  @override
  String get inputStyle => 'ان پٹ اسٹائل';

  @override
  String get appearance => 'ظاہری شکل';

  @override
  String get automaticBackupsEnabled => 'خودکار بیک اپ فعال ہیں';

  @override
  String get automaticBackup => 'خودکار بیک اپ';

  @override
  String get appPermissions => 'ایپ کی اجازتیں';

  @override
  String get shareDatabase => 'ڈیٹابیس شیئر کریں';

  @override
  String get dataManagement => 'ڈیٹا کا انتظام';

  @override
  String get strengthUnit => 'طاقت کی اکائی';

  @override
  String get lastEntry => 'آخری اندراج';

  @override
  String get cardioUnit => 'کارڈیو اکائی';

  @override
  String longDateFormat(String format) {
    return 'طویل تاریخ کا فارمیٹ ($format)';
  }

  @override
  String get formats => 'فارمیٹس';

  @override
  String get setsPerExerciseMax => 'فی ورزش سیٹس (زیادہ سے زیادہ: 20)';

  @override
  String get countLabel => 'تعداد';

  @override
  String get ratioLabel => 'تناسب';

  @override
  String get reorder => 'دوبارہ ترتیب دیں';

  @override
  String get none => 'کوئی نہیں';

  @override
  String get monday => 'پیر';

  @override
  String get examplePlanExercises => 'بینچ پریس، اسکواٹ، ڈیڈ لفٹ';

  @override
  String get tabs => 'ٹیبز';

  @override
  String get swipeBetweenTabs => 'ٹیبز کے درمیان سوائپ کریں';

  @override
  String get vibrate => 'وائبریٹ';

  @override
  String get enableSound => 'آواز فعال کریں';

  @override
  String get keepScreenOn => 'اسکرین روشن رکھیں';

  @override
  String get alarmSound => 'الارم کی آواز';

  @override
  String get top => 'اوپر';

  @override
  String get bottom => 'نیچے';

  @override
  String get removeCustomTimer =>
      'کسٹم ٹائمر ہٹائیں (عالمی ڈیفالٹ استعمال کریں)';

  @override
  String get timers => 'ٹائمرز';

  @override
  String get timerSettings => 'ٹائمر کی ترتیبات';

  @override
  String get groupHistory => 'تاریخچہ گروپ کریں';

  @override
  String get showUnits => 'اکائیاں دکھائیں';

  @override
  String get showBodyWeight => 'جسمانی وزن دکھائیں';

  @override
  String get showCategories => 'زمرے دکھائیں';

  @override
  String get showNotes => 'نوٹس دکھائیں';

  @override
  String get repEstimation => 'ریپس کا تخمینہ';

  @override
  String get durationEstimation => 'دورانیے کا تخمینہ';

  @override
  String get showGraphLimit => 'گراف کی حد دکھائیں';

  @override
  String get defaultGraphMetric => 'ڈیفالٹ گراف میٹرک';

  @override
  String get bestWeight => 'بہترین وزن';

  @override
  String get bestReps => 'بہترین ریپس';

  @override
  String get oneRepMax => 'ایک ریپ زیادہ سے زیادہ';

  @override
  String get volume => 'حجم';

  @override
  String get paceCardio => 'رفتار (کارڈیو)';

  @override
  String get distanceCardio => 'فاصلہ (کارڈیو)';

  @override
  String get defaultGraphPeriod => 'ڈیفالٹ گراف مدت';

  @override
  String get defaultGraphLimit => 'ڈیفالٹ گراف حد';

  @override
  String get workouts => 'ورک آؤٹس';

  @override
  String get actionStop => 'روکیں';

  @override
  String get timerFinishedToast => 'ٹائمر ختم ہو گیا!';

  @override
  String get stopTimer => 'ٹائمر روکیں';

  @override
  String get actionPause => 'وقفہ';

  @override
  String get startStopwatch => 'اسٹاپ واچ شروع کریں';

  @override
  String get actionStart => 'شروع کریں';

  @override
  String get actionRestart => 'دوبارہ شروع کریں';

  @override
  String get addOneMinute => '+1 منٹ';

  @override
  String get addOneMinuteNotification => '1 منٹ شامل کریں';

  @override
  String get restTimer => 'آرام کا ٹائمر';

  @override
  String get timerUp => 'ٹائمر ختم';

  @override
  String get openNotification => 'نوٹیفکیشن کھولیں';

  @override
  String get timerChannelName => 'ٹائمر چینل';

  @override
  String get timerChannelDescription => 'آرام کے ٹائمرز کی جاری پیش رفت۔';

  @override
  String get timerFinishedChannelName => 'ٹائمر اختتام چینل';

  @override
  String get timerFinishedChannelDescription =>
      'آرام کا ٹائمر مکمل ہونے پر الارم بجاتا ہے۔';

  @override
  String get timerFinished => 'ٹائمر ختم ہو گیا';

  @override
  String get batteryOptimizationRequestUnavailable =>
      'آپ کے آلے پر بیٹری آپٹیمائزیشن نظرانداز کرنے کی درخواستیں غیر فعال ہیں۔';

  @override
  String get exactAlarmRequestUnavailable =>
      'آپ کے آلے پر SCHEDULE_EXACT_ALARM کی درخواست مسترد کر دی گئی';

  @override
  String get databaseMigrationFailureDescription =>
      'ڈیٹابیس بناتے یا اپ گریڈ کرتے وقت کچھ غلط ہو گیا۔ عموماً ریکارڈز حذف کر کے دوبارہ بنانے سے یہ ٹھیک ہو جاتا ہے۔';

  @override
  String get curveSmoothness => 'منحنی لکیر کی ہمواری';

  @override
  String get actionBack => 'واپس';

  @override
  String get atLeastOneTab => 'کم از کم ایک ٹیب ضروری ہے';

  @override
  String get invalidTabSettings => 'ٹیب کی ترتیبات غلط ہیں۔';

  @override
  String get noSettingsFound => 'کوئی ترتیبات نہیں ملیں';

  @override
  String nothingMatchesSearch(String query) {
    return '“$query” سے کچھ نہیں ملا۔';
  }

  @override
  String get appearanceDescription => 'تھیم، رنگ اور انٹرفیس کا انداز';

  @override
  String get dataManagementDescription =>
      'اپنے ورک آؤٹ ڈیٹا کو درآمد، برآمد اور منظم کریں';

  @override
  String get formatsDescription => 'تاریخ، اعداد اور پیمائش کی فارمیٹنگ';

  @override
  String get plansSettingsDescription => 'ورک آؤٹ منصوبوں کے ڈیفالٹس اور رویہ';

  @override
  String get tabsDescription => 'بنیادی نیویگیشن ٹیبز منتخب اور ترتیب دیں';

  @override
  String get timersDescription => 'آرام کے ٹائمر کا دورانیہ، آواز اور رویہ';

  @override
  String get workoutsDescription => 'ورزش کی ٹریکنگ اور ورک آؤٹ ترجیحات';

  @override
  String get completeSetForChart =>
      'اس ورزش کا چارٹ بنانے کے لیے ایک سیٹ مکمل کریں۔';

  @override
  String get dateRange => 'تاریخ کی حد';

  @override
  String get stopDate => 'اختتامی تاریخ';

  @override
  String get dataPoints => 'ڈیٹا پوائنٹس';

  @override
  String get completeSetsForProgress =>
      'اپنی پیش رفت کا چارٹ بنانے کے لیے کچھ سیٹس مکمل کریں۔';

  @override
  String get relativeStrength => 'نسبتی طاقت';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منتخب',
      one: '1 منتخب',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory =>
      'اس ورزش کا تاریخچہ یہاں دیکھنے کے لیے کچھ سیٹس مکمل کریں۔';

  @override
  String get completeSetForFirstGraph =>
      'اپنا پہلا ورزش گراف بنانے کے لیے ایک سیٹ مکمل کریں۔';

  @override
  String nothingMatchesGraphSearch(String query) {
    return '“$query” سے کچھ نہیں ملا۔ آپ اسے نئی ورزش کے طور پر بنا سکتے ہیں۔';
  }

  @override
  String addNamed(String name) {
    return '“$name” شامل کریں';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return 'اس سے $count ریکارڈز حذف ہو جائیں گے۔ کیا آپ کو یقین ہے؟';
  }

  @override
  String shareWorkout(String summary) {
    return 'میں نے ابھی $summary کیا';
  }

  @override
  String get updateConflict => 'اپ ڈیٹ کا تنازع';

  @override
  String updateConflictDescription(int count) {
    return 'آپ کا نیا نام پہلے ہی $count ریکارڈز میں موجود ہے۔ کیا آپ کو یقین ہے؟';
  }

  @override
  String get unitsConflict => 'اکائیوں کا تنازع';

  @override
  String unitsConflictDescription(String unit) {
    return 'آپ کے تمام ریکارڈز میں ایک ہی اکائی نہیں ہے۔ اس سے تمام اکائیاں $unit میں تبدیل ہو جائیں گی۔ کیا آپ کو یقین ہے؟';
  }

  @override
  String get durationLabel => 'دورانیہ';

  @override
  String get inclineLabel => 'ڈھلوان';

  @override
  String get paceDistanceTime => 'رفتار (فاصلہ / وقت)';

  @override
  String get adjustedPace => 'ایڈجسٹ شدہ رفتار';

  @override
  String get oneRepMaxAccuracyWarning =>
      '10 یا اس سے زیادہ ریپس والے سیٹس میں ایک ریپ زیادہ سے زیادہ کا تخمینہ کم درست ہوتا ہے';

  @override
  String get addPlan => 'منصوبہ شامل کریں';

  @override
  String get planDetails => 'منصوبے کی تفصیلات';

  @override
  String get exercisesLabel => 'ورزشیں';

  @override
  String get addExerciseToPlan => 'اس منصوبے میں ایک ورزش شامل کریں۔';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return '“$query” سے کچھ نہیں ملا۔ آپ اسے نئی ورزش کے طور پر شامل کر سکتے ہیں۔';
  }

  @override
  String get selectDays => 'دن منتخب کریں';

  @override
  String get selectExercises => 'ورزشیں منتخب کریں';

  @override
  String get todayLabel => 'آج';

  @override
  String get setDetails => 'سیٹ کی تفصیلات';

  @override
  String get themeLabel => 'تھیم';

  @override
  String get pureBlackAmoledDescription =>
      'AMOLED ڈسپلے کے لیے مکمل سیاہ رنگ استعمال کریں';

  @override
  String get systemColorScheme => 'سسٹم رنگ اسکیم';

  @override
  String get systemColorSchemeDescription =>
      'ایپ کے لیے اپنے آلے کا بنیادی رنگ استعمال کریں';

  @override
  String get showImagesDescription =>
      'تاریخچے کے صفحے پر تصاویر منتخب یا دکھائیں';

  @override
  String get showGlobalProgress => 'مجموعی پیش رفت دکھائیں';

  @override
  String get showGlobalProgressDescription =>
      'زمرے کے لحاظ سے اپنی پیش رفت دکھانے والا گراف اندراج شامل کریں';

  @override
  String get peekGraphDescription => 'گراف کے صفحے پر پہلا لائن گراف دکھائیں';

  @override
  String get inputStyleDescription => 'ٹیکسٹ ان پٹ فیلڈز کا بصری انداز';

  @override
  String get automaticBackupNotificationBody =>
      'Flexify ہر روز منتخب فولڈر میں آپ کے ڈیٹا اور تصاویر کا خودکار بیک اپ بنائے گا۔';

  @override
  String get backupSettingsChannel => 'بیک اپ ترتیبات';

  @override
  String get backupSettingsChannelDescription =>
      'خودکار بیک اپ کی وضاحت کرنے والے نوٹیفکیشنز';

  @override
  String get backupChannelName => 'بیک اپ چینل';

  @override
  String get backupChannelDescription =>
      'Flexify کے ڈیٹا اور تصاویر کے خودکار بیک اپ';

  @override
  String get backupCompletedTitle => 'ڈیٹا اور تصاویر کا بیک اپ مکمل';

  @override
  String get backupFailurePathNotSet =>
      'بیک اپ ناکام: بیک اپ راستہ مقرر نہیں ہے۔ خودکار بیک اپ غیر فعال کر دیے گئے۔';

  @override
  String get backupFailureDirectoryUnavailable =>
      'بیک اپ ناکام: بیک اپ ڈائریکٹری تک رسائی نہیں ہو سکی۔ خودکار بیک اپ غیر فعال کر دیے گئے۔';

  @override
  String get backupFailureCreateFile =>
      'بیک اپ ناکام: بیک اپ فائل نہیں بن سکی۔ خودکار بیک اپ غیر فعال کر دیے گئے۔';

  @override
  String get backupFailureAppFilesUnavailable =>
      'بیک اپ ناکام: ایپلیکیشن فائلز ڈائریکٹری تک رسائی نہیں ہو سکی۔ خودکار بیک اپ غیر فعال کر دیے گئے۔';

  @override
  String get backupFailureDatabaseMissing =>
      'بیک اپ ناکام: ڈیٹابیس فائل نہیں ملی۔ خودکار بیک اپ غیر فعال کر دیے گئے۔';

  @override
  String get backupFailureOutputUnavailable =>
      'بیک اپ ناکام: آؤٹ پٹ اسٹریم نہیں کھل سکی۔ خودکار بیک اپ غیر فعال کر دیے گئے۔';

  @override
  String get backupFailureUnknown =>
      'بیک اپ ناکام۔ خودکار بیک اپ غیر فعال کر دیے گئے۔';

  @override
  String get appPermissionsDescription =>
      'اپنے فعال فیچرز کے لیے درکار رسائی کا جائزہ لیں';

  @override
  String get longDateFormatDescription =>
      'جہاں کافی جگہ ہو وہاں استعمال ہوتا ہے';

  @override
  String shortDateFormat(String example) {
    return 'مختصر تاریخ کا فارمیٹ ($example)';
  }

  @override
  String get shortDateFormatDescription =>
      'جہاں جگہ کم ہو وہاں کے لیے (گراف لائنیں)';

  @override
  String get warmupSetsDescription =>
      'وارم اپ سیٹس میں آرام کے ٹائمر نہیں ہوتے';

  @override
  String get setsPerExerciseDescription => 'منصوبے میں ورزشوں کی ڈیفالٹ تعداد';

  @override
  String get planTrailingDisplay => 'منصوبے کے آخر کی معلومات';

  @override
  String get planTrailingDisplayDescription =>
      'Plans + Plan منظر میں فہرست کے دائیں جانب کیا دکھایا جائے';

  @override
  String get restTimersDescription => 'سیٹ مکمل کرنے کے بعد بجنے والا الارم';

  @override
  String get vibrateDescription => 'کیا آرام کے ٹائمرز وائبریٹ کریں؟';

  @override
  String get enableSoundDescription => 'کیا آرام کے ٹائمرز آواز چلائیں؟';

  @override
  String get keepScreenOnDescription =>
      'آرام کے ٹائمرز کے دوران اسکرین روشن رکھیں';

  @override
  String get restDurationDescription => 'آرام کا الارم بجنے میں کتنا وقت لگے؟';

  @override
  String get globalDefault => 'عالمی ڈیفالٹ';

  @override
  String get alarmSoundDescription =>
      'آرام کا ٹائمر ختم ہونے پر چلنے والی موسیقی';

  @override
  String get progressBarPosition => 'پروگریس بار کی جگہ';

  @override
  String get progressBarPositionDescription =>
      'آرام کے ٹائمرز کی پروگریس بار کہاں رکھی جائے؟';

  @override
  String get perExerciseRestTimes => 'ہر ورزش کے لیے آرام کا وقت';

  @override
  String get perExerciseRestTimesDescription =>
      'ان ورزشوں کے لیے حسبِ ضرورت آرام کے دورانیے ہیں';

  @override
  String get audioFeaturesUnavailable => 'آڈیو فیچرز دستیاب نہیں ہیں';

  @override
  String get groupHistoryDescription =>
      'تاریخچے کے اندراجات کو دن کے لحاظ سے یکجا کریں';

  @override
  String get showUnitsDescription =>
      'گراف/تاریخچہ/منصوبوں میں km/mi، kg/lb دکھائیں';

  @override
  String get showBodyWeightDescription =>
      'جسمانی وزن کی ٹریکنگ فعال/غیر فعال کریں';

  @override
  String get showCategoriesDescription => 'ورک آؤٹ زمرے فعال/غیر فعال کریں';

  @override
  String get showNotesDescription =>
      'ٹیکسٹ ایریا میں اپنی لفٹ کی تفصیلات درج کریں';

  @override
  String get positiveNotificationsDescription =>
      'نیا ریکارڈ بننے پر حوصلہ افزا پیغامات لکھیں';

  @override
  String get positiveMessagesEnabled => 'مثبت پیغامات اب اس طرح نظر آئیں گے!';

  @override
  String get recordEncouragement01 => 'زبردست کام! آپ کمال ہیں۔';

  @override
  String get recordEncouragement02 => 'واہ کنگ! آپ کی پیش رفت متاثر کن ہے۔';

  @override
  String get recordEncouragement03 => 'میں جھک گیا...';

  @override
  String get recordEncouragement04 => 'یہ کیا؟ نیا ریکارڈ!';

  @override
  String get recordEncouragement05 => 'کمال کر دیا! آپ واقعی مثال ہیں۔';

  @override
  String get recordEncouragement06 => 'واہ۔ خوب۔';

  @override
  String get recordEncouragement07 => 'کافی طاقتور ہو رہے ہیں، ہے نا؟';

  @override
  String get recordEncouragement08 => 'ہاں۔ آپ تو خاصے بڑے ہو گئے ہیں۔';

  @override
  String get recordEncouragement09 => 'شاندار۔ ناقابلِ یقین۔';

  @override
  String get recordEncouragement10 => 'آرنی کو آپ پر فخر ہوتا۔';

  @override
  String get recordEncouragement11 => 'رونی سی خوشی سے آپ کو دیکھ رہے ہیں۔';

  @override
  String get recordEncouragement12 => 'ہاں! لائٹ ویٹ بیبی!!!!!!!';

  @override
  String get recordEncouragement13 =>
      'کیا یہ نیا ریکارڈ ہے؟ مجھے معلوم تھا آپ کر سکتے ہیں۔';

  @override
  String get recordEncouragement14 => 'زبردست کام! مجھے آپ پر فخر ہے۔';

  @override
  String get recordEncouragement15 => 'ہاں بیبی! لائٹ ویٹ!';

  @override
  String get recordEncouragement16 => 'جاری رکھیں! شاندار پیش رفت۔';

  @override
  String get recordEncouragement17 => 'آپ بہت اچھا کر رہے ہیں۔';

  @override
  String get recordEncouragement18 => 'شاباش میرے شیر!';

  @override
  String get recordEncouragement19 => 'جاری رکھیں۔';

  @override
  String get recordEncouragement20 => 'آپ بہت طاقتور ہو رہے ہیں۔';

  @override
  String get recordEncouragement21 => 'طاقتور۔';

  @override
  String get recordEncouragement22 => 'زبردست طاقت!';

  @override
  String get recordEncouragement23 => 'مجھے آپ پر فخر ہے۔';

  @override
  String get recordEncouragement24 => 'یہ شاندار کام جاری رکھیں۔';

  @override
  String get recordEncouragement25 =>
      'سینہ تان کر کھڑے ہوں! آپ نے نیا ریکارڈ بنایا ہے۔';

  @override
  String get recordEncouragement26 => 'نیا ریکارڈ! آپ پہلے سے بھی آگے نکل گئے!';

  @override
  String get recordEncouragement27 => 'جی ہاں! یہ ریکارڈ ہے۔';

  @override
  String get recordEncouragement28 => 'واہ! نیا ریکارڈ!';

  @override
  String get recordEncouragement29 => 'بہت خوب۔';

  @override
  String get repEstimationDescription =>
      'اندازہ لگائیں کہ آپ نے ابھی کتنے ریپس کیے';

  @override
  String get durationEstimationDescription =>
      'اپنے کارڈیو کے دورانیے کا اندازہ لگائیں';

  @override
  String get showGraphXAxisToggle => 'گراف X محور ٹوگل دکھائیں';

  @override
  String get showGraphXAxisToggleDescription =>
      'گراف پر وقت پر مبنی X محور کا ٹوگل دکھائیں';

  @override
  String get showGraphLimitDescription => 'گراف پر حد کا سلائیڈر دکھائیں';

  @override
  String get defaultTimeBasedXAxis => 'ڈیفالٹ وقت پر مبنی X محور';

  @override
  String get defaultTimeBasedXAxisDescription =>
      'گراف پر ڈیفالٹ طور پر وقت پر مبنی X محور استعمال کریں';

  @override
  String get createFirstTrainingPlan =>
      'شروع کرنے کے لیے اپنا پہلا ٹریننگ منصوبہ بنائیں۔';

  @override
  String nothingMatchesPlanSearch(String query) {
    return '“$query” سے کچھ نہیں ملا۔ آپ اسے نئے منصوبے کے طور پر بنا سکتے ہیں۔';
  }

  @override
  String get createPlan => 'منصوبہ بنائیں';

  @override
  String createNamedPlan(String name) {
    return '“$name” بنائیں';
  }

  @override
  String setNumber(int number) {
    return 'سیٹ $number';
  }
}
