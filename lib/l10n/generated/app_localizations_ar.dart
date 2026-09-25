// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsLanguageDescription => 'اختر اللغة التي يستخدمها Flexify';

  @override
  String get languageSystemDefault => 'إعداد النظام الافتراضي';

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
  String get navHistory => 'السجل';

  @override
  String get navPlans => 'الخطط';

  @override
  String get navGraphs => 'الرسوم البيانية';

  @override
  String get navTimer => 'المؤقت';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get errorLabel => 'خطأ';

  @override
  String get tabContentError => 'تعذر إنشاء محتوى علامة التبويب.';

  @override
  String get cannotHideAllTabs => 'لا يمكن إخفاء كل شيء!';

  @override
  String removeTabQuestion(String tab) {
    return 'إزالة علامة تبويب $tab؟';
  }

  @override
  String get restoreTabFromSettings =>
      'يمكنك إضافتها مرة أخرى لاحقًا من الإعدادات.';

  @override
  String removedTab(String tab) {
    return 'تمت إزالة $tab';
  }

  @override
  String newVersion(String version) {
    return 'الإصدار الجديد $version';
  }

  @override
  String get changes => 'التغييرات';

  @override
  String get searchHint => 'بحث...';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'هل أنت متأكد من حذف $count سجلات؟ لا يمكن التراجع عن هذا الإجراء.',
      one: 'هل أنت متأكد من حذف سجل واحد؟ لا يمكن التراجع عن هذا الإجراء.',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'إلغاء';

  @override
  String get actionDelete => 'حذف';

  @override
  String get actionRemove => 'إزالة';

  @override
  String get actionEdit => 'تعديل';

  @override
  String get actionShare => 'مشاركة';

  @override
  String get clearSelection => 'مسح التحديد';

  @override
  String get clearSearch => 'مسح البحث';

  @override
  String get showMenu => 'إظهار القائمة';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get weightLabel => 'الوزن';

  @override
  String get filter => 'تصفية';

  @override
  String get filters => 'عوامل التصفية';

  @override
  String get categoryLabel => 'الفئة';

  @override
  String get repsLabel => 'التكرارات';

  @override
  String get repsFilter => 'تصفية التكرارات';

  @override
  String get weightFilter => 'تصفية الوزن';

  @override
  String get greaterThan => 'أكبر من';

  @override
  String get lessThan => 'أقل من';

  @override
  String get startDate => 'تاريخ البدء';

  @override
  String get endDate => 'تاريخ الانتهاء';

  @override
  String get actionClear => 'مسح';

  @override
  String get actionOk => 'موافق';

  @override
  String get actionClose => 'إغلاق';

  @override
  String get sortBy => 'الترتيب حسب';

  @override
  String get dateNewest => 'التاريخ (الأحدث)';

  @override
  String get dateOldest => 'التاريخ (الأقدم)';

  @override
  String get nameLabel => 'الاسم';

  @override
  String get missingPermissions => 'أذونات مفقودة';

  @override
  String get restTimersPermissionsMissing =>
      'مؤقتات الراحة مفعلة، لكن بعض الأذونات مفقودة.';

  @override
  String get restTimersPermissionsOptional =>
      'إذا عطلت مؤقتات الراحة، فلن تكون هذه الأذونات مطلوبة.';

  @override
  String get restTimers => 'مؤقتات الراحة';

  @override
  String get disableBatteryOptimizations => 'تعطيل تحسينات البطارية';

  @override
  String get batteryOptimizationWarning =>
      'قد يتوقف التقدم مؤقتًا إذا ظلت تحسينات البطارية مفعلة.';

  @override
  String get scheduleExactAlarm => 'جدولة منبه دقيق';

  @override
  String get exactAlarmWarning =>
      'لا يمكن أن تكون المنبهات دقيقة إذا كان هذا الخيار معطلاً.';

  @override
  String get postNotifications => 'إرسال الإشعارات';

  @override
  String get notificationBarDescription =>
      'يُرسل تقدم المؤقت إلى شريط الإشعارات';

  @override
  String get invalidPermissions => 'أذونات غير صالحة';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      'مؤقتات الراحة مفعلة دون أذونات كافية. هل أنت متأكد؟';

  @override
  String get actionConfirm => 'تأكيد';

  @override
  String get appAccess => 'وصول التطبيق';

  @override
  String get appAccessDescription => 'مطلوب للمؤقتات والإشعارات المفعلة.';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get timerProgressAndRestAlerts => 'تقدم المؤقت وتنبيهات الراحة';

  @override
  String get enabledNotificationsDescription => 'الإشعارات التي فعّلتها';

  @override
  String get backgroundActivity => 'النشاط في الخلفية';

  @override
  String get backgroundActivityDescription =>
      'الحفاظ على موثوقية المؤقتات في الخلفية';

  @override
  String get exactAlarms => 'المنبهات الدقيقة';

  @override
  String get exactAlarmsDescription => 'التنبيه بالضبط عند انتهاء مؤقت الراحة';

  @override
  String get noAdditionalAndroidAccessNeeded =>
      'لا يلزم وصول إضافي إلى Android لإعداداتك الحالية.';

  @override
  String get actionDone => 'تم';

  @override
  String get allowed => 'مسموح';

  @override
  String get actionAllow => 'سماح';

  @override
  String get backupLabel => 'نسخة احتياطية';

  @override
  String get databaseLabel => 'قاعدة البيانات';

  @override
  String get deleteRecords => 'حذف السجلات';

  @override
  String get deleteAllGraphsConfirmation =>
      'هل أنت متأكد من حذف جميع الرسوم البيانية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get deleteAllPlansConfirmation =>
      'هل أنت متأكد من حذف جميع الخطط؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get deleteDatabaseConfirmation =>
      'هل أنت متأكد من حذف قاعدة بياناتك؟ لا يمكن التراجع عن هذا الإجراء وسيؤدي إلى حذف جميع بياناتك.';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get actionReport => 'إبلاغ';

  @override
  String get graphDataImported => 'تم استيراد بيانات الرسوم البيانية بنجاح!';

  @override
  String get plansImported => 'تم استيراد الخطط بنجاح';

  @override
  String failedToImportDatabase(String error) {
    return 'فشل استيراد قاعدة البيانات: $error';
  }

  @override
  String get backupArchiveMissingDatabase =>
      'لا يحتوي أرشيف النسخة الاحتياطية على قاعدة بيانات Flexify.';

  @override
  String failedToImportGraphs(String error) {
    return 'فشل استيراد الرسوم البيانية: $error';
  }

  @override
  String failedToImportPlans(String error) {
    return 'فشل استيراد الخطط: $error';
  }

  @override
  String get selectedFileDoesNotExist => 'الملف المحدد غير موجود';

  @override
  String get couldNotReadFileData => 'تعذرت قراءة بيانات الملف';

  @override
  String get databaseImportWebUnsupported =>
      'يتطلب استيراد قاعدة البيانات على الويب ترحيل البيانات يدويًا. يرجى تصدير بياناتك كملفات CSV واستيرادها بدلاً من ذلك.';

  @override
  String get csvFileEmpty => 'ملف CSV فارغ';

  @override
  String get csvNeedsDataRow =>
      'يجب أن يحتوي ملف CSV على صف بيانات واحد على الأقل';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return 'يحتوي الصف $row على عدد غير كافٍ من الأعمدة: $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return 'قيمة $field غير صالحة في الصف $row: $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return 'نوع بيانات $field غير صالح في الصف $row: $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return 'كان متوقعًا معرّف خطة صحيحًا، لكن تم الحصول على \"$value\"';
  }

  @override
  String get unitLabel => 'الوحدة';

  @override
  String get kilogramsUnit => 'كيلوغرام (كغ)';

  @override
  String get poundsUnit => 'رطل (lb)';

  @override
  String get stoneUnit => 'ستون';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => 'كيلومتر (كم)';

  @override
  String get milesUnit => 'ميل (mi)';

  @override
  String get metersUnit => 'متر (م)';

  @override
  String get kilocaloriesUnit => 'كيلوسعرة (kcal)';

  @override
  String get enterWeight => 'أدخل الوزن';

  @override
  String get requiredField => 'مطلوب';

  @override
  String get invalidNumber => 'رقم غير صالح';

  @override
  String get previousWeight => 'الوزن السابق';

  @override
  String get imageLabel => 'الصورة';

  @override
  String get longPressToDelete => 'اضغط مطولاً للحذف';

  @override
  String get imageError => 'خطأ في الصورة';

  @override
  String get actionSave => 'حفظ';

  @override
  String get aboutTitle => 'حول';

  @override
  String get donate => 'تبرع';

  @override
  String get helpSupportProject => 'ساعد في دعم هذا المشروع';

  @override
  String get whatsNewAbout => 'ما الجديد؟';

  @override
  String get whatsNewTitle => 'ما الجديد؟';

  @override
  String get seeReleaseNotes => 'اطّلع على ملاحظات الإصدار';

  @override
  String get versionLabel => 'الإصدار';

  @override
  String get authorLabel => 'المؤلف';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get privacyPolicyDescription => 'كيف يتعامل Flexify مع بياناتك';

  @override
  String get licenseLabel => 'الترخيص';

  @override
  String get sourceCode => 'الشيفرة المصدرية';

  @override
  String get sourceCodeDescription => 'اطّلع عليها على GitHub';

  @override
  String get leaveReview => 'اكتب مراجعة';

  @override
  String get leaveReviewDescription => 'قيّم Flexify على متجر Play';

  @override
  String get reportBug => 'الإبلاغ عن خطأ';

  @override
  String get reportBugDescription => 'افتح تذكرة على GitHub';

  @override
  String get failedMigrations => 'عمليات ترحيل فاشلة';

  @override
  String get errorMessageLabel => 'رسالة الخطأ:';

  @override
  String get createIssue => 'إنشاء مشكلة';

  @override
  String get addExercise => 'إضافة تمرين';

  @override
  String get cardio => 'تمارين القلب';

  @override
  String get strength => 'القوة';

  @override
  String get options => 'الخيارات';

  @override
  String get periodDay => 'يوم';

  @override
  String get periodWeek => 'أسبوع';

  @override
  String get periodMonth => 'شهر';

  @override
  String get periodYear => 'سنة';

  @override
  String noDataFor(String name) {
    return 'لا توجد بيانات بعد لـ $name';
  }

  @override
  String get noDataYet => 'لا توجد بيانات بعد';

  @override
  String get exerciseNotes => 'ملاحظات التمرين';

  @override
  String get notesForExercise => 'ملاحظات لهذا التمرين';

  @override
  String get useTimeBasedXAxis => 'استخدام محور X المعتمد على الوقت';

  @override
  String updateAllNamed(String name) {
    return 'تحديث كل $name';
  }

  @override
  String get newName => 'اسم جديد';

  @override
  String get restMinutes => 'دقائق الراحة';

  @override
  String get restSeconds => 'ثواني الراحة';

  @override
  String get globalProgress => 'التقدم العام';

  @override
  String get curveLineGraphs => 'رسوم بيانية بخطوط منحنية';

  @override
  String get curveLineGraphsDescription =>
      'رسم خطوط الرسم البياني كمنحنيات سلسة';

  @override
  String noHistoryFor(String name) {
    return 'لا يوجد سجل بعد لـ $name';
  }

  @override
  String get cancelSelection => 'إلغاء التحديد';

  @override
  String get editSelected => 'تعديل المحدد';

  @override
  String get newExercise => 'تمرين جديد';

  @override
  String get noGraphsFound => 'لم يتم العثور على رسوم بيانية';

  @override
  String get searchGraphs => 'البحث في الرسوم البيانية...';

  @override
  String get actionAdd => 'إضافة';

  @override
  String get actionUpdate => 'تحديث';

  @override
  String get hideGlobalProgress => 'إخفاء التقدم العام';

  @override
  String get chartGroupedByCategory => 'مخطط مجمّع حسب الفئة';

  @override
  String get noExercisesFound => 'لم يتم العثور على تمارين';

  @override
  String get savePlan => 'حفظ الخطة';

  @override
  String get titleOptional => 'العنوان (اختياري)';

  @override
  String get searchExercises => 'البحث في التمارين...';

  @override
  String get warmupSets => 'مجموعات الإحماء';

  @override
  String get workingSetsMax => 'مجموعات العمل (الحد الأقصى: 20)';

  @override
  String get actionUndo => 'تراجع';

  @override
  String get actionSwap => 'تبديل';

  @override
  String get daily => 'يوميًا';

  @override
  String get weekly => 'أسبوعيًا';

  @override
  String get monthly => 'شهريًا';

  @override
  String get yearly => 'سنويًا';

  @override
  String get unexpectedError => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get loadingExercises => 'جارٍ تحميل التمارين...';

  @override
  String get noPlansYet => 'لا توجد خطط بعد';

  @override
  String get noMatchingPlans => 'لا توجد خطط مطابقة';

  @override
  String get newPlan => 'خطة جديدة';

  @override
  String get searchPlans => 'البحث في الخطط...';

  @override
  String get noExercisesYet => 'لا توجد تمارين بعد';

  @override
  String get editPlan => 'تعديل الخطة';

  @override
  String get saveSet => 'حفظ المجموعة';

  @override
  String get minutesLabel => 'دقائق';

  @override
  String get minutesShort => 'د';

  @override
  String get secondsLabel => 'ثوانٍ';

  @override
  String get distanceLabel => 'المسافة';

  @override
  String get inclinePercent => 'الميل %';

  @override
  String weightWithUnit(String unit) {
    return 'الوزن ($unit)';
  }

  @override
  String get useBodyWeight => 'استخدام وزن الجسم';

  @override
  String get noWeightEnteredYet => 'لم يتم إدخال وزن بعد';

  @override
  String get notesLabel => 'ملاحظات';

  @override
  String get swapWorkout => 'تبديل التمرين';

  @override
  String get addSet => 'إضافة مجموعة';

  @override
  String get deleteSet => 'حذف المجموعة';

  @override
  String get oneRepMaxEstimate => 'الحد الأقصى لتكرار واحد (تقديري)';

  @override
  String get valueLabel => 'القيمة';

  @override
  String amountWithUnit(String unit) {
    return 'الكمية ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return 'المسافة ($unit)';
  }

  @override
  String get bodyWeightLabel => 'وزن الجسم';

  @override
  String bodyWeightWithUnit(String unit) {
    return 'وزن الجسم ($unit)';
  }

  @override
  String get categoryHelper => 'اختر فئة موجودة أو اكتب فئة جديدة.';

  @override
  String get manageCategories => 'إدارة الفئات';

  @override
  String get manageCategoriesDescription =>
      'إنشاء الفئات أو إعادة تسميتها أو دمجها أو إزالتها';

  @override
  String get newCategory => 'فئة جديدة';

  @override
  String get renameCategory => 'إعادة تسمية الفئة';

  @override
  String get mergeCategory => 'دمج في فئة أخرى';

  @override
  String get noCategories => 'لا توجد فئات بعد';

  @override
  String get categoryNameRequired => 'أدخل اسم الفئة';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'مستخدمة في $count إدخالات',
      one: 'مستخدمة في إدخال واحد',
      zero: 'غير مستخدمة في أي إدخال',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'حذف هذه الفئة وإزالتها من $count إدخالات؟',
      one: 'حذف هذه الفئة وإزالتها من إدخال واحد؟',
      zero: 'حذف هذه الفئة؟',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => 'تاريخ الإنشاء';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تعديل $count مجموعات',
      one: 'تعديل مجموعة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => 'لا توجد إدخالات بعد';

  @override
  String get historyEmptyMessage =>
      'أكمل مجموعة أو أضف واحدة يدويًا لبدء السجل.';

  @override
  String deleteSetConfirmation(String name) {
    return 'هل أنت متأكد من حذف $name؟';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'هل أنت متأكد من حذف $count إدخالات؟',
      one: 'هل أنت متأكد من حذف إدخال واحد؟',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => 'البحث في السجل...';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeLight => 'فاتح';

  @override
  String get pureBlackAmoled => 'أسود خالص (AMOLED)';

  @override
  String get showImages => 'إظهار الصور';

  @override
  String get peekGraph => 'معاينة الرسم البياني';

  @override
  String get inputStyleLine => 'خط';

  @override
  String get inputStyleOutlined => 'بإطار';

  @override
  String get inputStyleFilled => 'معبأ';

  @override
  String get inputStyle => 'نمط الإدخال';

  @override
  String get appearance => 'المظهر';

  @override
  String get automaticBackupsEnabled => 'النسخ الاحتياطي التلقائي مفعّل';

  @override
  String get automaticBackup => 'نسخ احتياطي تلقائي';

  @override
  String get appPermissions => 'أذونات التطبيق';

  @override
  String get shareDatabase => 'مشاركة قاعدة البيانات';

  @override
  String get dataManagement => 'إدارة البيانات';

  @override
  String get strengthUnit => 'وحدة القوة';

  @override
  String get lastEntry => 'آخر إدخال';

  @override
  String get cardioUnit => 'وحدة تمارين القلب';

  @override
  String longDateFormat(String format) {
    return 'تنسيق التاريخ الطويل ($format)';
  }

  @override
  String get formats => 'التنسيقات';

  @override
  String get setsPerExerciseMax => 'المجموعات لكل تمرين (الحد الأقصى: 20)';

  @override
  String get countLabel => 'العدد';

  @override
  String get ratioLabel => 'النسبة';

  @override
  String get reorder => 'إعادة الترتيب';

  @override
  String get none => 'لا شيء';

  @override
  String get monday => 'الاثنين';

  @override
  String get examplePlanExercises => 'ضغط الصدر، القرفصاء، الرفعة المميتة';

  @override
  String get tabs => 'علامات التبويب';

  @override
  String get swipeBetweenTabs => 'السحب بين علامات التبويب';

  @override
  String get vibrate => 'اهتزاز';

  @override
  String get enableSound => 'تفعيل الصوت';

  @override
  String get keepScreenOn => 'إبقاء الشاشة قيد التشغيل';

  @override
  String get alarmSound => 'صوت المنبه';

  @override
  String get top => 'أعلى';

  @override
  String get bottom => 'أسفل';

  @override
  String get removeCustomTimer =>
      'إزالة المؤقت المخصص (استخدام الافتراضي العام)';

  @override
  String get timers => 'المؤقتات';

  @override
  String get timerSettings => 'إعدادات المؤقت';

  @override
  String get groupHistory => 'تجميع السجل';

  @override
  String get showUnits => 'إظهار الوحدات';

  @override
  String get showBodyWeight => 'إظهار وزن الجسم';

  @override
  String get showCategories => 'إظهار الفئات';

  @override
  String get showNotes => 'إظهار الملاحظات';

  @override
  String get repEstimation => 'تقدير التكرارات';

  @override
  String get durationEstimation => 'تقدير المدة';

  @override
  String get showGraphLimit => 'إظهار حد الرسم البياني';

  @override
  String get defaultGraphMetric => 'مقياس الرسم البياني الافتراضي';

  @override
  String get bestWeight => 'أفضل وزن';

  @override
  String get bestReps => 'أفضل تكرارات';

  @override
  String get oneRepMax => 'الحد الأقصى لتكرار واحد';

  @override
  String get volume => 'الحجم';

  @override
  String get paceCardio => 'الوتيرة (تمارين القلب)';

  @override
  String get distanceCardio => 'المسافة (تمارين القلب)';

  @override
  String get defaultGraphPeriod => 'فترة الرسم البياني الافتراضية';

  @override
  String get defaultGraphLimit => 'حد الرسم البياني الافتراضي';

  @override
  String get workouts => 'التمارين';

  @override
  String get actionStop => 'إيقاف';

  @override
  String get timerFinishedToast => 'انتهى المؤقت!';

  @override
  String get stopTimer => 'إيقاف المؤقت';

  @override
  String get actionPause => 'إيقاف مؤقت';

  @override
  String get startStopwatch => 'بدء ساعة الإيقاف';

  @override
  String get actionStart => 'بدء';

  @override
  String get actionRestart => 'إعادة التشغيل';

  @override
  String get addOneMinute => '+1 دقيقة';

  @override
  String get addOneMinuteNotification => 'إضافة دقيقة واحدة';

  @override
  String get restTimer => 'مؤقت الراحة';

  @override
  String get timerUp => 'انتهى الوقت';

  @override
  String get openNotification => 'فتح الإشعار';

  @override
  String get timerChannelName => 'قناة المؤقت';

  @override
  String get timerChannelDescription => 'التقدم المستمر لمؤقتات الراحة.';

  @override
  String get timerFinishedChannelName => 'قناة انتهاء المؤقت';

  @override
  String get timerFinishedChannelDescription =>
      'تشغّل منبهًا عند اكتمال مؤقت الراحة.';

  @override
  String get timerFinished => 'انتهى المؤقت';

  @override
  String get batteryOptimizationRequestUnavailable =>
      'طلبات تجاهل تحسينات البطارية معطلة على جهازك.';

  @override
  String get exactAlarmRequestUnavailable =>
      'تم رفض طلب SCHEDULE_EXACT_ALARM على جهازك';

  @override
  String get databaseMigrationFailureDescription =>
      'حدث خطأ أثناء إنشاء قاعدة البيانات أو ترقيتها. يمكن عادةً إصلاح ذلك بحذف السجلات وإعادة إنشائها.';

  @override
  String get curveSmoothness => 'نعومة المنحنى';

  @override
  String get actionBack => 'رجوع';

  @override
  String get atLeastOneTab => 'تحتاج إلى علامة تبويب واحدة على الأقل';

  @override
  String get invalidTabSettings => 'إعدادات علامات التبويب غير صالحة.';

  @override
  String get noSettingsFound => 'لم يتم العثور على إعدادات';

  @override
  String nothingMatchesSearch(String query) {
    return 'لا شيء يطابق “$query”.';
  }

  @override
  String get appearanceDescription => 'السمة والألوان وتنسيق الواجهة';

  @override
  String get dataManagementDescription =>
      'استيراد بيانات تمارينك وتصديرها وإدارتها';

  @override
  String get formatsDescription => 'تنسيق التواريخ والأرقام والقياسات';

  @override
  String get plansSettingsDescription =>
      'الإعدادات الافتراضية وسلوك خطط التمرين';

  @override
  String get tabsDescription => 'اختيار علامات تبويب التنقل الرئيسية وترتيبها';

  @override
  String get timersDescription => 'مدة مؤقت الراحة والصوت والسلوك';

  @override
  String get workoutsDescription => 'تتبع التمارين وتفضيلات التدريب';

  @override
  String get completeSetForChart => 'أكمل مجموعة لهذا التمرين لإنشاء مخططه.';

  @override
  String get dateRange => 'نطاق التاريخ';

  @override
  String get stopDate => 'تاريخ التوقف';

  @override
  String get dataPoints => 'نقاط البيانات';

  @override
  String get completeSetsForProgress => 'أكمل بعض المجموعات لإنشاء مخطط تقدمك.';

  @override
  String get relativeStrength => 'القوة النسبية';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم تحديد $count',
      one: 'تم تحديد عنصر واحد',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory =>
      'أكمل بعض المجموعات لرؤية سجل هذا التمرين هنا.';

  @override
  String get completeSetForFirstGraph =>
      'أكمل مجموعة لإنشاء أول رسم بياني للتمرين.';

  @override
  String nothingMatchesGraphSearch(String query) {
    return 'لا شيء يطابق “$query”. يمكنك إنشاؤه كتمرين جديد.';
  }

  @override
  String addNamed(String name) {
    return 'إضافة “$name”';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return 'سيؤدي هذا إلى حذف $count سجلات. هل أنت متأكد؟';
  }

  @override
  String shareWorkout(String summary) {
    return 'لقد أنجزت للتو $summary';
  }

  @override
  String get updateConflict => 'تعارض في التحديث';

  @override
  String updateConflictDescription(int count) {
    return 'اسمك الجديد موجود بالفعل في $count سجلات. هل أنت متأكد؟';
  }

  @override
  String get unitsConflict => 'تعارض الوحدات';

  @override
  String unitsConflictDescription(String unit) {
    return 'لا تستخدم جميع سجلاتك الوحدة نفسها. سيحوّل هذا جميع الوحدات إلى $unit. هل أنت متأكد؟';
  }

  @override
  String get durationLabel => 'المدة';

  @override
  String get inclineLabel => 'الميل';

  @override
  String get paceDistanceTime => 'الوتيرة (المسافة / الوقت)';

  @override
  String get adjustedPace => 'الوتيرة المعدلة';

  @override
  String get oneRepMaxAccuracyWarning =>
      'تقديرات الحد الأقصى لتكرار واحد أقل دقة للمجموعات التي تحتوي على 10 تكرارات أو أكثر';

  @override
  String get addPlan => 'إضافة خطة';

  @override
  String get planDetails => 'تفاصيل الخطة';

  @override
  String get exercisesLabel => 'التمارين';

  @override
  String get addExerciseToPlan => 'أضف تمرينًا إلى هذه الخطة.';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return 'لا شيء يطابق “$query”. يمكنك إضافته كتمرين جديد.';
  }

  @override
  String get selectDays => 'اختيار الأيام';

  @override
  String get selectExercises => 'اختيار التمارين';

  @override
  String get todayLabel => 'اليوم';

  @override
  String get setDetails => 'تفاصيل المجموعة';

  @override
  String get themeLabel => 'السمة';

  @override
  String get pureBlackAmoledDescription =>
      'استخدام ألوان سوداء خالصة لشاشات AMOLED';

  @override
  String get systemColorScheme => 'نظام ألوان الجهاز';

  @override
  String get systemColorSchemeDescription =>
      'استخدام اللون الأساسي لجهازك في التطبيق';

  @override
  String get showImagesDescription => 'اختيار/عرض الصور في صفحة السجل';

  @override
  String get showGlobalProgress => 'إظهار التقدم العام';

  @override
  String get showGlobalProgressDescription =>
      'إضافة إدخال رسم بياني يعرض تقدمك حسب الفئة';

  @override
  String get peekGraphDescription =>
      'إظهار أول رسم بياني خطي في صفحة الرسوم البيانية';

  @override
  String get inputStyleDescription => 'النمط المرئي لحقول إدخال النص';

  @override
  String get automaticBackupNotificationBody =>
      'سيقوم Flexify تلقائيًا بنسخ بياناتك وصورك احتياطيًا إلى المجلد المحدد كل يوم.';

  @override
  String get backupSettingsChannel => 'إعدادات النسخ الاحتياطي';

  @override
  String get backupSettingsChannelDescription =>
      'إشعارات تشرح النسخ الاحتياطي التلقائي';

  @override
  String get backupChannelName => 'قناة النسخ الاحتياطي';

  @override
  String get backupChannelDescription =>
      'نسخ احتياطية تلقائية لبيانات Flexify وصوره';

  @override
  String get backupCompletedTitle => 'تم نسخ البيانات والصور احتياطيًا';

  @override
  String get backupFailurePathNotSet =>
      'فشل النسخ الاحتياطي: لم يتم تعيين مسار النسخ الاحتياطي. تم تعطيل النسخ الاحتياطي التلقائي.';

  @override
  String get backupFailureDirectoryUnavailable =>
      'فشل النسخ الاحتياطي: تعذر الوصول إلى مجلد النسخ الاحتياطي. تم تعطيل النسخ الاحتياطي التلقائي.';

  @override
  String get backupFailureCreateFile =>
      'فشل النسخ الاحتياطي: تعذر إنشاء ملف النسخة الاحتياطية. تم تعطيل النسخ الاحتياطي التلقائي.';

  @override
  String get backupFailureAppFilesUnavailable =>
      'فشل النسخ الاحتياطي: تعذر الوصول إلى مجلد ملفات التطبيق. تم تعطيل النسخ الاحتياطي التلقائي.';

  @override
  String get backupFailureDatabaseMissing =>
      'فشل النسخ الاحتياطي: لم يتم العثور على ملف قاعدة البيانات. تم تعطيل النسخ الاحتياطي التلقائي.';

  @override
  String get backupFailureOutputUnavailable =>
      'فشل النسخ الاحتياطي: تعذر فتح دفق الإخراج. تم تعطيل النسخ الاحتياطي التلقائي.';

  @override
  String get backupFailureUnknown =>
      'فشل النسخ الاحتياطي. تم تعطيل النسخ الاحتياطي التلقائي.';

  @override
  String get appPermissionsDescription =>
      'راجع الوصول المطلوب للميزات التي فعّلتها';

  @override
  String get longDateFormatDescription => 'يُستخدم عندما تتوفر مساحة كافية';

  @override
  String shortDateFormat(String example) {
    return 'تنسيق التاريخ القصير ($example)';
  }

  @override
  String get shortDateFormatDescription =>
      'للأماكن ذات المساحة المحدودة (خطوط الرسم البياني)';

  @override
  String get warmupSetsDescription =>
      'مجموعات الإحماء لا تحتوي على مؤقتات راحة';

  @override
  String get setsPerExerciseDescription =>
      'العدد الافتراضي للمجموعات لكل تمرين في الخطة';

  @override
  String get planTrailingDisplay => 'العرض الجانبي للخطة';

  @override
  String get planTrailingDisplayDescription =>
      'ما يظهر في الجانب الأيمن من القائمة في الخطط وعرض الخطة';

  @override
  String get restTimersDescription => 'منبه يعمل بعد إكمال مجموعة';

  @override
  String get vibrateDescription => 'هل يجب أن تهتز مؤقتات الراحة؟';

  @override
  String get enableSoundDescription => 'هل يجب أن تشغّل مؤقتات الراحة صوتًا؟';

  @override
  String get keepScreenOnDescription =>
      'إبقاء الشاشة قيد التشغيل أثناء مؤقتات الراحة';

  @override
  String get restDurationDescription => 'كم من الوقت قبل تشغيل منبهات الراحة؟';

  @override
  String get globalDefault => 'الافتراضي العام';

  @override
  String get alarmSoundDescription =>
      'الموسيقى التي تُشغّل عند انتهاء مؤقت الراحة';

  @override
  String get progressBarPosition => 'موضع شريط التقدم';

  @override
  String get progressBarPositionDescription =>
      'أين يجب وضع شريط تقدم مؤقتات الراحة؟';

  @override
  String get perExerciseRestTimes => 'أوقات الراحة لكل تمرين';

  @override
  String get perExerciseRestTimesDescription => 'لهذه التمارين مدد راحة مخصصة';

  @override
  String get audioFeaturesUnavailable => 'ميزات الصوت غير متاحة';

  @override
  String get groupHistoryDescription => 'دمج إدخالات السجل حسب اليوم';

  @override
  String get showUnitsDescription =>
      'إظهار كم/ميل وكغ/رطل في الرسوم البيانية والسجل والخطط';

  @override
  String get showBodyWeightDescription => 'تفعيل/تعطيل تتبع وزن الجسم';

  @override
  String get showCategoriesDescription => 'تفعيل/تعطيل فئات التمارين';

  @override
  String get showNotesDescription => 'تسجيل تفاصيل رفعتك في منطقة نص';

  @override
  String get positiveNotificationsDescription =>
      'كتابة رسائل مشجعة عند تسجيل رقم قياسي جديد';

  @override
  String get positiveMessagesEnabled => 'ستظهر الرسائل الإيجابية الآن هكذا!';

  @override
  String get recordEncouragement01 => 'عمل رائع! أنت مذهل.';

  @override
  String get recordEncouragement02 => 'أحسنت يا بطل! تقدمك مُلهم.';

  @override
  String get recordEncouragement03 => 'أنحني لك...';

  @override
  String get recordEncouragement04 => 'ما هذا؟ رقم قياسي جديد!';

  @override
  String get recordEncouragement05 => 'شيء مذهل! أنت مصدر إلهام.';

  @override
  String get recordEncouragement06 => 'واو. رائع.';

  @override
  String get recordEncouragement07 => 'تزداد قوة، أليس كذلك؟';

  @override
  String get recordEncouragement08 => 'نعم. أصبحت قويًا جدًا.';

  @override
  String get recordEncouragement09 => 'مذهل. لا يُصدق.';

  @override
  String get recordEncouragement10 => 'كان أرنولد سيفتخر بك.';

  @override
  String get recordEncouragement11 => 'روني كولمان ينظر إليك بسرور.';

  @override
  String get recordEncouragement12 => 'نعم! وزن خفيف يا بطل!!!!!!!';

  @override
  String get recordEncouragement13 =>
      'هل هذا رقم قياسي جديد؟ كنت أعلم أنك تستطيع فعلها.';

  @override
  String get recordEncouragement14 => 'عمل رائع! أنا فخور بك.';

  @override
  String get recordEncouragement15 => 'نعم يا بطل! وزن خفيف!';

  @override
  String get recordEncouragement16 => 'واصل! تقدم رائع.';

  @override
  String get recordEncouragement17 => 'أنت تؤدي بشكل ممتاز.';

  @override
  String get recordEncouragement18 => 'هذا هو بطلي!';

  @override
  String get recordEncouragement19 => 'واصل التقدم.';

  @override
  String get recordEncouragement20 => 'أنت تصبح قويًا جدًا.';

  @override
  String get recordEncouragement21 => 'قوي.';

  @override
  String get recordEncouragement22 => 'أداء قوي!';

  @override
  String get recordEncouragement23 => 'أنا فخور بك.';

  @override
  String get recordEncouragement24 => 'واصل هذا العمل الرائع.';

  @override
  String get recordEncouragement25 =>
      'قف شامخًا! لقد حققت رقمًا قياسيًا جديدًا.';

  @override
  String get recordEncouragement26 =>
      'رقم قياسي جديد! لقد تجاوزت حدودك أكثر من أي وقت مضى!';

  @override
  String get recordEncouragement27 => 'نعم! هذا رقم قياسي.';

  @override
  String get recordEncouragement28 => 'واو! رقم قياسي جديد!';

  @override
  String get recordEncouragement29 => 'أداء ممتاز جدًا.';

  @override
  String get repEstimationDescription =>
      'حاول توقع عدد التكرارات التي أنجزتها للتو';

  @override
  String get durationEstimationDescription => 'حاول توقع مدة تمرين القلب';

  @override
  String get showGraphXAxisToggle => 'إظهار مفتاح محور X للرسم البياني';

  @override
  String get showGraphXAxisToggleDescription =>
      'إظهار مفتاح محور X المعتمد على الوقت في الرسوم البيانية';

  @override
  String get showGraphLimitDescription =>
      'إظهار شريط تمرير الحد في الرسوم البيانية';

  @override
  String get defaultTimeBasedXAxis => 'محور X المعتمد على الوقت افتراضيًا';

  @override
  String get defaultTimeBasedXAxisDescription =>
      'استخدام محور X المعتمد على الوقت افتراضيًا في الرسوم البيانية';

  @override
  String get createFirstTrainingPlan => 'أنشئ أول خطة تدريب لك للبدء.';

  @override
  String nothingMatchesPlanSearch(String query) {
    return 'لا شيء يطابق “$query”. يمكنك إنشاؤه كخطة جديدة.';
  }

  @override
  String get createPlan => 'إنشاء خطة';

  @override
  String createNamedPlan(String name) {
    return 'إنشاء “$name”';
  }

  @override
  String setNumber(int number) {
    return 'المجموعة $number';
  }
}
