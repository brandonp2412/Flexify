// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsLanguageDescription =>
      'Flexify में इस्तेमाल होने वाली भाषा चुनें';

  @override
  String get languageSystemDefault => 'सिस्टम डिफ़ॉल्ट';

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
  String get navHistory => 'इतिहास';

  @override
  String get navPlans => 'प्लान';

  @override
  String get navGraphs => 'ग्राफ़';

  @override
  String get navTimer => 'टाइमर';

  @override
  String get navSettings => 'सेटिंग्स';

  @override
  String get errorLabel => 'त्रुटि';

  @override
  String get tabContentError => 'टैब की सामग्री नहीं बनाई जा सकी।';

  @override
  String get cannotHideAllTabs => 'सभी टैब छिपाए नहीं जा सकते!';

  @override
  String removeTabQuestion(String tab) {
    return '$tab टैब हटाएँ?';
  }

  @override
  String get restoreTabFromSettings =>
      'आप इसे बाद में सेटिंग्स से फिर जोड़ सकते हैं।';

  @override
  String removedTab(String tab) {
    return '$tab हटाया गया';
  }

  @override
  String newVersion(String version) {
    return 'नया संस्करण $version';
  }

  @override
  String get changes => 'बदलाव';

  @override
  String get searchHint => 'खोजें...';

  @override
  String get deleteSelected => 'चुने हुए हटाएँ';

  @override
  String get confirmDelete => 'हटाने की पुष्टि करें';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'क्या आप वाकई $count रिकॉर्ड हटाना चाहते हैं? यह कार्रवाई वापस नहीं ली जा सकती।',
      one:
          'क्या आप वाकई 1 रिकॉर्ड हटाना चाहते हैं? यह कार्रवाई वापस नहीं ली जा सकती।',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'रद्द करें';

  @override
  String get actionDelete => 'हटाएँ';

  @override
  String get actionRemove => 'निकालें';

  @override
  String get actionEdit => 'संपादित करें';

  @override
  String get actionShare => 'साझा करें';

  @override
  String get clearSelection => 'चयन साफ़ करें';

  @override
  String get clearSearch => 'खोज साफ़ करें';

  @override
  String get showMenu => 'मेनू दिखाएँ';

  @override
  String get selectAll => 'सभी चुनें';

  @override
  String get weightLabel => 'वज़न';

  @override
  String get filter => 'फ़िल्टर';

  @override
  String get filters => 'फ़िल्टर';

  @override
  String get categoryLabel => 'श्रेणी';

  @override
  String get repsLabel => 'रेप्स';

  @override
  String get repsFilter => 'रेप्स फ़िल्टर';

  @override
  String get weightFilter => 'वज़न फ़िल्टर';

  @override
  String get greaterThan => 'इससे अधिक';

  @override
  String get lessThan => 'इससे कम';

  @override
  String get startDate => 'शुरू होने की तारीख';

  @override
  String get endDate => 'समाप्ति की तारीख';

  @override
  String get actionClear => 'साफ़ करें';

  @override
  String get actionOk => 'ठीक है';

  @override
  String get actionClose => 'बंद करें';

  @override
  String get sortBy => 'इसके अनुसार क्रमित करें';

  @override
  String get dateNewest => 'तारीख (नवीनतम)';

  @override
  String get dateOldest => 'तारीख (सबसे पुरानी)';

  @override
  String get nameLabel => 'नाम';

  @override
  String get missingPermissions => 'अनुमतियाँ नहीं मिलीं';

  @override
  String get restTimersPermissionsMissing =>
      'रेस्ट टाइमर चालू हैं, लेकिन आवश्यक अनुमतियाँ नहीं मिली हैं।';

  @override
  String get restTimersPermissionsOptional =>
      'यदि आप रेस्ट टाइमर बंद कर दें, तो इन अनुमतियों की आवश्यकता नहीं होगी।';

  @override
  String get restTimers => 'रेस्ट टाइमर';

  @override
  String get disableBatteryOptimizations => 'बैटरी ऑप्टिमाइज़ेशन बंद करें';

  @override
  String get batteryOptimizationWarning =>
      'बैटरी ऑप्टिमाइज़ेशन चालू रहने पर प्रगति रुक सकती है।';

  @override
  String get scheduleExactAlarm => 'सटीक अलार्म शेड्यूल करें';

  @override
  String get exactAlarmWarning => 'यह बंद होने पर अलार्म सटीक नहीं हो सकते।';

  @override
  String get postNotifications => 'नोटिफ़िकेशन भेजें';

  @override
  String get notificationBarDescription =>
      'टाइमर की प्रगति नोटिफ़िकेशन बार में दिखाई जाती है';

  @override
  String get invalidPermissions => 'अमान्य अनुमतियाँ';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      'पर्याप्त अनुमतियों के बिना रेस्ट टाइमर चालू हैं। क्या आप सुनिश्चित हैं?';

  @override
  String get actionConfirm => 'पुष्टि करें';

  @override
  String get appAccess => 'ऐप एक्सेस';

  @override
  String get appAccessDescription => 'चालू टाइमर और नोटिफ़िकेशन के लिए आवश्यक।';

  @override
  String get notifications => 'नोटिफ़िकेशन';

  @override
  String get timerProgressAndRestAlerts => 'टाइमर की प्रगति और रेस्ट अलर्ट';

  @override
  String get enabledNotificationsDescription =>
      'आपके द्वारा चालू किए गए नोटिफ़िकेशन';

  @override
  String get backgroundActivity => 'बैकग्राउंड गतिविधि';

  @override
  String get backgroundActivityDescription =>
      'बैकग्राउंड में टाइमर भरोसेमंद बनाए रखें';

  @override
  String get exactAlarms => 'सटीक अलार्म';

  @override
  String get exactAlarmsDescription =>
      'रेस्ट टाइमर समाप्त होते ही ठीक समय पर अलर्ट करें';

  @override
  String get noAdditionalAndroidAccessNeeded =>
      'आपकी मौजूदा सेटिंग्स के लिए किसी अतिरिक्त Android एक्सेस की आवश्यकता नहीं है।';

  @override
  String get actionDone => 'हो गया';

  @override
  String get allowed => 'अनुमति है';

  @override
  String get actionAllow => 'अनुमति दें';

  @override
  String get backupLabel => 'बैकअप';

  @override
  String get databaseLabel => 'डेटाबेस';

  @override
  String get deleteRecords => 'रिकॉर्ड हटाएँ';

  @override
  String get deleteAllGraphsConfirmation =>
      'क्या आप वाकई सभी ग्राफ़ हटाना चाहते हैं? यह कार्रवाई वापस नहीं ली जा सकती।';

  @override
  String get deleteAllPlansConfirmation =>
      'क्या आप वाकई सभी प्लान हटाना चाहते हैं? यह कार्रवाई वापस नहीं ली जा सकती।';

  @override
  String get deleteDatabaseConfirmation =>
      'क्या आप वाकई अपना डेटाबेस हटाना चाहते हैं? यह कार्रवाई वापस नहीं ली जा सकती और आपका सारा डेटा नष्ट हो जाएगा।';

  @override
  String get importData => 'डेटा आयात करें';

  @override
  String get exportData => 'डेटा निर्यात करें';

  @override
  String get actionReport => 'रिपोर्ट करें';

  @override
  String get graphDataImported => 'ग्राफ़ डेटा सफलतापूर्वक आयात हो गया!';

  @override
  String get plansImported => 'प्लान सफलतापूर्वक आयात हो गए';

  @override
  String failedToImportDatabase(String error) {
    return 'डेटाबेस आयात नहीं हो सका: $error';
  }

  @override
  String get backupArchiveMissingDatabase =>
      'बैकअप आर्काइव में Flexify डेटाबेस नहीं है।';

  @override
  String failedToImportGraphs(String error) {
    return 'ग्राफ़ आयात नहीं हो सके: $error';
  }

  @override
  String failedToImportPlans(String error) {
    return 'प्लान आयात नहीं हो सके: $error';
  }

  @override
  String get selectedFileDoesNotExist => 'चुनी गई फ़ाइल मौजूद नहीं है';

  @override
  String get couldNotReadFileData => 'फ़ाइल का डेटा पढ़ा नहीं जा सका';

  @override
  String get databaseImportWebUnsupported =>
      'वेब पर डेटाबेस आयात के लिए मैन्युअल डेटा माइग्रेशन आवश्यक है। कृपया अपना डेटा CSV फ़ाइलों के रूप में निर्यात करें और उन्हें आयात करें।';

  @override
  String get csvFileEmpty => 'CSV फ़ाइल खाली है';

  @override
  String get csvNeedsDataRow =>
      'CSV फ़ाइल में कम से कम एक डेटा पंक्ति होनी चाहिए';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return 'पंक्ति $row में पर्याप्त कॉलम नहीं हैं: $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return 'पंक्ति $row में अमान्य $field मान: $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return 'पंक्ति $row में अमान्य $field डेटा प्रकार: $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return 'पूर्णांक प्लान आईडी अपेक्षित थी, मिला \"$value\"';
  }

  @override
  String get unitLabel => 'इकाई';

  @override
  String get kilogramsUnit => 'किलोग्राम (kg)';

  @override
  String get poundsUnit => 'पाउंड (lb)';

  @override
  String get stoneUnit => 'स्टोन';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => 'किलोमीटर (km)';

  @override
  String get milesUnit => 'मील (mi)';

  @override
  String get metersUnit => 'मीटर (m)';

  @override
  String get kilocaloriesUnit => 'किलोकैलोरी (kcal)';

  @override
  String get enterWeight => 'वज़न दर्ज करें';

  @override
  String get requiredField => 'आवश्यक';

  @override
  String get invalidNumber => 'अमान्य संख्या';

  @override
  String get previousWeight => 'पिछला वज़न';

  @override
  String get imageLabel => 'चित्र';

  @override
  String get longPressToDelete => 'हटाने के लिए देर तक दबाएँ';

  @override
  String get imageError => 'चित्र त्रुटि';

  @override
  String get actionSave => 'सहेजें';

  @override
  String get aboutTitle => 'परिचय';

  @override
  String get donate => 'दान करें';

  @override
  String get helpSupportProject => 'इस प्रोजेक्ट को सहयोग दें';

  @override
  String get whatsNewAbout => 'नया क्या है?';

  @override
  String get whatsNewTitle => 'नया क्या है?';

  @override
  String get seeReleaseNotes => 'रिलीज़ नोट्स देखें';

  @override
  String get versionLabel => 'संस्करण';

  @override
  String get authorLabel => 'लेखक';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get privacyPolicyDescription => 'Flexify आपके डेटा को कैसे संभालता है';

  @override
  String get licenseLabel => 'लाइसेंस';

  @override
  String get sourceCode => 'स्रोत कोड';

  @override
  String get sourceCodeDescription => 'GitHub पर देखें';

  @override
  String get leaveReview => 'समीक्षा दें';

  @override
  String get leaveReviewDescription => 'Play Store पर Flexify को रेट करें';

  @override
  String get reportBug => 'बग रिपोर्ट करें';

  @override
  String get reportBugDescription => 'GitHub पर टिकट खोलें';

  @override
  String get failedMigrations => 'असफल माइग्रेशन';

  @override
  String get errorMessageLabel => 'त्रुटि संदेश:';

  @override
  String get createIssue => 'इश्यू बनाएँ';

  @override
  String get addExercise => 'व्यायाम जोड़ें';

  @override
  String get cardio => 'कार्डियो';

  @override
  String get strength => 'स्ट्रेंथ';

  @override
  String get options => 'विकल्प';

  @override
  String get periodDay => 'दिन';

  @override
  String get periodWeek => 'सप्ताह';

  @override
  String get periodMonth => 'महीना';

  @override
  String get periodYear => 'वर्ष';

  @override
  String noDataFor(String name) {
    return '$name के लिए अभी कोई डेटा नहीं';
  }

  @override
  String get noDataYet => 'अभी कोई डेटा नहीं';

  @override
  String get exerciseNotes => 'व्यायाम नोट्स';

  @override
  String get notesForExercise => 'इस व्यायाम के लिए नोट्स';

  @override
  String get useTimeBasedXAxis => 'समय-आधारित X अक्ष का उपयोग करें';

  @override
  String updateAllNamed(String name) {
    return 'सभी $name अपडेट करें';
  }

  @override
  String get newName => 'नया नाम';

  @override
  String get restMinutes => 'रेस्ट मिनट';

  @override
  String get restSeconds => 'रेस्ट सेकंड';

  @override
  String get globalProgress => 'कुल प्रगति';

  @override
  String get curveLineGraphs => 'वक्र रेखा ग्राफ़';

  @override
  String get curveLineGraphsDescription =>
      'ग्राफ़ की रेखाएँ चिकने वक्रों के रूप में बनाएँ';

  @override
  String noHistoryFor(String name) {
    return '$name के लिए अभी कोई इतिहास नहीं';
  }

  @override
  String get cancelSelection => 'चयन रद्द करें';

  @override
  String get editSelected => 'चुने हुए संपादित करें';

  @override
  String get newExercise => 'नया व्यायाम';

  @override
  String get noGraphsFound => 'कोई ग्राफ़ नहीं मिला';

  @override
  String get searchGraphs => 'ग्राफ़ खोजें...';

  @override
  String get actionAdd => 'जोड़ें';

  @override
  String get actionUpdate => 'अपडेट करें';

  @override
  String get hideGlobalProgress => 'कुल प्रगति छिपाएँ';

  @override
  String get chartGroupedByCategory => 'श्रेणी के अनुसार समूहित चार्ट';

  @override
  String get noExercisesFound => 'कोई व्यायाम नहीं मिला';

  @override
  String get savePlan => 'प्लान सहेजें';

  @override
  String get titleOptional => 'शीर्षक (वैकल्पिक)';

  @override
  String get searchExercises => 'व्यायाम खोजें...';

  @override
  String get warmupSets => 'वार्मअप सेट';

  @override
  String get workingSetsMax => 'वर्किंग सेट (अधिकतम: 20)';

  @override
  String get actionUndo => 'पूर्ववत करें';

  @override
  String get actionSwap => 'बदलें';

  @override
  String get daily => 'दैनिक';

  @override
  String get weekly => 'साप्ताहिक';

  @override
  String get monthly => 'मासिक';

  @override
  String get yearly => 'वार्षिक';

  @override
  String get unexpectedError => 'कुछ गलत हो गया। कृपया फिर कोशिश करें।';

  @override
  String get loadingExercises => 'व्यायाम लोड हो रहे हैं...';

  @override
  String get noPlansYet => 'अभी कोई प्लान नहीं';

  @override
  String get noMatchingPlans => 'कोई मेल खाता प्लान नहीं';

  @override
  String get newPlan => 'नया प्लान';

  @override
  String get searchPlans => 'प्लान खोजें...';

  @override
  String get noExercisesYet => 'अभी कोई व्यायाम नहीं';

  @override
  String get editPlan => 'प्लान संपादित करें';

  @override
  String get saveSet => 'सेट सहेजें';

  @override
  String get minutesLabel => 'मिनट';

  @override
  String get minutesShort => 'मि';

  @override
  String get secondsLabel => 'सेकंड';

  @override
  String get distanceLabel => 'दूरी';

  @override
  String get inclinePercent => 'ढलान %';

  @override
  String weightWithUnit(String unit) {
    return 'वज़न ($unit)';
  }

  @override
  String get useBodyWeight => 'शरीर का वज़न इस्तेमाल करें';

  @override
  String get noWeightEnteredYet => 'अभी कोई वज़न दर्ज नहीं किया गया';

  @override
  String get notesLabel => 'नोट्स';

  @override
  String get swapWorkout => 'वर्कआउट बदलें';

  @override
  String get addSet => 'सेट जोड़ें';

  @override
  String get deleteSet => 'सेट हटाएँ';

  @override
  String get oneRepMaxEstimate => 'एक रेप अधिकतम (अनुमान)';

  @override
  String get valueLabel => 'मान';

  @override
  String amountWithUnit(String unit) {
    return 'मात्रा ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return 'दूरी ($unit)';
  }

  @override
  String get bodyWeightLabel => 'शरीर का वज़न';

  @override
  String bodyWeightWithUnit(String unit) {
    return 'शरीर का वज़न ($unit)';
  }

  @override
  String get categoryHelper => 'मौजूदा श्रेणी चुनें या नई श्रेणी लिखें।';

  @override
  String get manageCategories => 'श्रेणियाँ प्रबंधित करें';

  @override
  String get manageCategoriesDescription =>
      'श्रेणियाँ बनाएँ, नाम बदलें, मिलाएँ या हटाएँ';

  @override
  String get newCategory => 'नई श्रेणी';

  @override
  String get renameCategory => 'श्रेणी का नाम बदलें';

  @override
  String get mergeCategory => 'दूसरी श्रेणी में मिलाएँ';

  @override
  String get noCategories => 'अभी कोई श्रेणी नहीं';

  @override
  String get categoryNameRequired => 'श्रेणी का नाम दर्ज करें';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count प्रविष्टियों में उपयोग',
      one: '1 प्रविष्टि में उपयोग',
      zero: 'किसी प्रविष्टि में उपयोग नहीं',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'यह श्रेणी हटाकर इसे $count प्रविष्टियों से भी निकालें?',
      one: 'यह श्रेणी हटाकर इसे 1 प्रविष्टि से भी निकालें?',
      zero: 'यह श्रेणी हटाएँ?',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => 'बनाने की तारीख';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सेट संपादित करें',
      one: '1 सेट संपादित करें',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => 'अभी कोई प्रविष्टि नहीं';

  @override
  String get historyEmptyMessage =>
      'अपना इतिहास शुरू करने के लिए कोई सेट पूरा करें या मैन्युअल रूप से जोड़ें।';

  @override
  String deleteSetConfirmation(String name) {
    return 'क्या आप वाकई $name हटाना चाहते हैं?';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'क्या आप वाकई $count प्रविष्टियाँ हटाना चाहते हैं?',
      one: 'क्या आप वाकई 1 प्रविष्टि हटाना चाहते हैं?',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => 'इतिहास खोजें...';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get themeDark => 'गहरा';

  @override
  String get themeLight => 'हल्का';

  @override
  String get pureBlackAmoled => 'शुद्ध काला (AMOLED)';

  @override
  String get showImages => 'चित्र दिखाएँ';

  @override
  String get peekGraph => 'ग्राफ़ की झलक';

  @override
  String get inputStyleLine => 'रेखा';

  @override
  String get inputStyleOutlined => 'आउटलाइन';

  @override
  String get inputStyleFilled => 'भरा हुआ';

  @override
  String get inputStyle => 'इनपुट शैली';

  @override
  String get appearance => 'रूप-रंग';

  @override
  String get automaticBackupsEnabled => 'स्वचालित बैकअप चालू';

  @override
  String get automaticBackup => 'स्वचालित बैकअप';

  @override
  String get appPermissions => 'ऐप अनुमतियाँ';

  @override
  String get shareDatabase => 'डेटाबेस साझा करें';

  @override
  String get dataManagement => 'डेटा प्रबंधन';

  @override
  String get strengthUnit => 'स्ट्रेंथ इकाई';

  @override
  String get lastEntry => 'पिछली प्रविष्टि';

  @override
  String get cardioUnit => 'कार्डियो इकाई';

  @override
  String longDateFormat(String format) {
    return 'लंबा तारीख प्रारूप ($format)';
  }

  @override
  String get formats => 'प्रारूप';

  @override
  String get setsPerExerciseMax => 'प्रति व्यायाम सेट (अधिकतम: 20)';

  @override
  String get countLabel => 'गिनती';

  @override
  String get ratioLabel => 'अनुपात';

  @override
  String get reorder => 'क्रम बदलें';

  @override
  String get none => 'कोई नहीं';

  @override
  String get monday => 'सोमवार';

  @override
  String get examplePlanExercises => 'बेंच प्रेस, स्क्वाट, डेडलिफ्ट';

  @override
  String get tabs => 'टैब';

  @override
  String get swipeBetweenTabs => 'टैब के बीच स्वाइप करें';

  @override
  String get vibrate => 'कंपन';

  @override
  String get enableSound => 'ध्वनि चालू करें';

  @override
  String get keepScreenOn => 'स्क्रीन चालू रखें';

  @override
  String get alarmSound => 'अलार्म ध्वनि';

  @override
  String get top => 'ऊपर';

  @override
  String get bottom => 'नीचे';

  @override
  String get removeCustomTimer =>
      'कस्टम टाइमर हटाएँ (कुल डिफ़ॉल्ट इस्तेमाल करें)';

  @override
  String get timers => 'टाइमर';

  @override
  String get timerSettings => 'टाइमर सेटिंग्स';

  @override
  String get groupHistory => 'इतिहास समूहित करें';

  @override
  String get showUnits => 'इकाइयाँ दिखाएँ';

  @override
  String get showBodyWeight => 'शरीर का वज़न दिखाएँ';

  @override
  String get showCategories => 'श्रेणियाँ दिखाएँ';

  @override
  String get showNotes => 'नोट्स दिखाएँ';

  @override
  String get repEstimation => 'रेप अनुमान';

  @override
  String get durationEstimation => 'अवधि अनुमान';

  @override
  String get showGraphLimit => 'ग्राफ़ सीमा दिखाएँ';

  @override
  String get defaultGraphMetric => 'डिफ़ॉल्ट ग्राफ़ मेट्रिक';

  @override
  String get bestWeight => 'सर्वश्रेष्ठ वज़न';

  @override
  String get bestReps => 'सर्वश्रेष्ठ रेप्स';

  @override
  String get oneRepMax => 'एक रेप अधिकतम';

  @override
  String get volume => 'वॉल्यूम';

  @override
  String get paceCardio => 'गति (कार्डियो)';

  @override
  String get distanceCardio => 'दूरी (कार्डियो)';

  @override
  String get defaultGraphPeriod => 'डिफ़ॉल्ट ग्राफ़ अवधि';

  @override
  String get defaultGraphLimit => 'डिफ़ॉल्ट ग्राफ़ सीमा';

  @override
  String get workouts => 'वर्कआउट';

  @override
  String get actionStop => 'रोकें';

  @override
  String get timerFinishedToast => 'टाइमर समाप्त!';

  @override
  String get stopTimer => 'टाइमर रोकें';

  @override
  String get actionPause => 'रोकें';

  @override
  String get startStopwatch => 'स्टॉपवॉच शुरू करें';

  @override
  String get actionStart => 'शुरू करें';

  @override
  String get actionRestart => 'फिर शुरू करें';

  @override
  String get addOneMinute => '+1 मिनट';

  @override
  String get addOneMinuteNotification => '1 मिनट जोड़ें';

  @override
  String get restTimer => 'रेस्ट टाइमर';

  @override
  String get timerUp => 'टाइमर पूरा';

  @override
  String get openNotification => 'नोटिफ़िकेशन खोलें';

  @override
  String get timerChannelName => 'टाइमर चैनल';

  @override
  String get timerChannelDescription => 'रेस्ट टाइमर की जारी प्रगति।';

  @override
  String get timerFinishedChannelName => 'टाइमर समाप्त चैनल';

  @override
  String get timerFinishedChannelDescription =>
      'रेस्ट टाइमर पूरा होने पर अलार्म बजाता है।';

  @override
  String get timerFinished => 'टाइमर समाप्त';

  @override
  String get batteryOptimizationRequestUnavailable =>
      'आपके डिवाइस पर बैटरी ऑप्टिमाइज़ेशन अनदेखा करने का अनुरोध बंद है।';

  @override
  String get exactAlarmRequestUnavailable =>
      'आपके डिवाइस ने SCHEDULE_EXACT_ALARM का अनुरोध अस्वीकार कर दिया';

  @override
  String get databaseMigrationFailureDescription =>
      'डेटाबेस बनाते या अपग्रेड करते समय कुछ गलत हो गया। आम तौर पर रिकॉर्ड हटाकर और फिर से बनाकर इसे ठीक किया जा सकता है।';

  @override
  String get curveSmoothness => 'वक्र की चिकनाई';

  @override
  String get actionBack => 'वापस';

  @override
  String get atLeastOneTab => 'कम से कम एक टैब आवश्यक है';

  @override
  String get invalidTabSettings => 'अमान्य टैब सेटिंग्स।';

  @override
  String get noSettingsFound => 'कोई सेटिंग नहीं मिली';

  @override
  String nothingMatchesSearch(String query) {
    return '“$query” से कुछ मेल नहीं खाता।';
  }

  @override
  String get appearanceDescription => 'थीम, रंग और इंटरफ़ेस शैली';

  @override
  String get dataManagementDescription =>
      'अपना वर्कआउट डेटा आयात, निर्यात और प्रबंधित करें';

  @override
  String get formatsDescription => 'तारीख, संख्या और माप के प्रारूप';

  @override
  String get plansSettingsDescription => 'वर्कआउट प्लान के डिफ़ॉल्ट और व्यवहार';

  @override
  String get tabsDescription => 'मुख्य नेविगेशन टैब चुनें और व्यवस्थित करें';

  @override
  String get timersDescription => 'रेस्ट टाइमर की अवधि, ध्वनि और व्यवहार';

  @override
  String get workoutsDescription => 'व्यायाम ट्रैकिंग और वर्कआउट प्राथमिकताएँ';

  @override
  String get completeSetForChart =>
      'चार्ट बनाने के लिए इस व्यायाम का एक सेट पूरा करें।';

  @override
  String get dateRange => 'तारीख सीमा';

  @override
  String get stopDate => 'समाप्ति तारीख';

  @override
  String get dataPoints => 'डेटा बिंदु';

  @override
  String get completeSetsForProgress =>
      'अपना प्रगति चार्ट बनाने के लिए कुछ सेट पूरे करें।';

  @override
  String get relativeStrength => 'सापेक्ष स्ट्रेंथ';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count चुने गए',
      one: '1 चुना गया',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory =>
      'इस व्यायाम का इतिहास देखने के लिए कुछ सेट पूरे करें।';

  @override
  String get completeSetForFirstGraph =>
      'अपना पहला व्यायाम ग्राफ़ बनाने के लिए एक सेट पूरा करें।';

  @override
  String nothingMatchesGraphSearch(String query) {
    return '“$query” से कुछ मेल नहीं खाता। आप इसे नए व्यायाम के रूप में बना सकते हैं।';
  }

  @override
  String addNamed(String name) {
    return '“$name” जोड़ें';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return 'इससे $count रिकॉर्ड हट जाएँगे। क्या आप सुनिश्चित हैं?';
  }

  @override
  String shareWorkout(String summary) {
    return 'मैंने अभी $summary किया';
  }

  @override
  String get updateConflict => 'अपडेट टकराव';

  @override
  String updateConflictDescription(int count) {
    return 'आपका नया नाम पहले से $count रिकॉर्ड के लिए मौजूद है। क्या आप सुनिश्चित हैं?';
  }

  @override
  String get unitsConflict => 'इकाइयों का टकराव';

  @override
  String unitsConflictDescription(String unit) {
    return 'आपके सभी रिकॉर्ड की इकाई एक जैसी नहीं है। इससे सभी इकाइयाँ $unit में बदल जाएँगी। क्या आप सुनिश्चित हैं?';
  }

  @override
  String get durationLabel => 'अवधि';

  @override
  String get inclineLabel => 'ढलान';

  @override
  String get paceDistanceTime => 'गति (दूरी / समय)';

  @override
  String get adjustedPace => 'समायोजित गति';

  @override
  String get oneRepMaxAccuracyWarning =>
      '10+ रेप वाले सेट के लिए एक रेप अधिकतम का अनुमान कम सटीक होता है';

  @override
  String get addPlan => 'प्लान जोड़ें';

  @override
  String get planDetails => 'प्लान विवरण';

  @override
  String get exercisesLabel => 'व्यायाम';

  @override
  String get addExerciseToPlan => 'इस प्लान में एक व्यायाम जोड़ें।';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return '“$query” से कुछ मेल नहीं खाता। आप इसे नए व्यायाम के रूप में जोड़ सकते हैं।';
  }

  @override
  String get selectDays => 'दिन चुनें';

  @override
  String get selectExercises => 'व्यायाम चुनें';

  @override
  String get todayLabel => 'आज';

  @override
  String get setDetails => 'सेट विवरण';

  @override
  String get themeLabel => 'थीम';

  @override
  String get pureBlackAmoledDescription =>
      'AMOLED डिस्प्ले के लिए शुद्ध काले रंग इस्तेमाल करें';

  @override
  String get systemColorScheme => 'सिस्टम रंग योजना';

  @override
  String get systemColorSchemeDescription =>
      'ऐप के लिए अपने डिवाइस का मुख्य रंग इस्तेमाल करें';

  @override
  String get showImagesDescription => 'इतिहास पेज पर चित्र चुनें/दिखाएँ';

  @override
  String get showGlobalProgress => 'कुल प्रगति दिखाएँ';

  @override
  String get showGlobalProgressDescription =>
      'श्रेणी के अनुसार आपकी प्रगति का चार्ट दिखाने वाली ग्राफ़ प्रविष्टि जोड़ें';

  @override
  String get peekGraphDescription => 'ग्राफ़ पेज पर पहला लाइन ग्राफ़ दिखाएँ';

  @override
  String get inputStyleDescription => 'टेक्स्ट इनपुट फ़ील्ड की दृश्य शैली';

  @override
  String get automaticBackupNotificationBody =>
      'Flexify हर दिन चुने हुए फ़ोल्डर में आपके डेटा और चित्रों का स्वचालित बैकअप बनाएगा।';

  @override
  String get backupSettingsChannel => 'बैकअप सेटिंग्स';

  @override
  String get backupSettingsChannelDescription =>
      'स्वचालित बैकअप की जानकारी देने वाले नोटिफ़िकेशन';

  @override
  String get backupChannelName => 'बैकअप चैनल';

  @override
  String get backupChannelDescription =>
      'Flexify डेटा और चित्रों के स्वचालित बैकअप';

  @override
  String get backupCompletedTitle => 'डेटा और चित्रों का बैकअप हो गया';

  @override
  String get backupFailurePathNotSet =>
      'बैकअप असफल: बैकअप पथ सेट नहीं है। स्वचालित बैकअप बंद कर दिए गए।';

  @override
  String get backupFailureDirectoryUnavailable =>
      'बैकअप असफल: बैकअप डायरेक्टरी तक पहुँच नहीं मिली। स्वचालित बैकअप बंद कर दिए गए।';

  @override
  String get backupFailureCreateFile =>
      'बैकअप असफल: बैकअप फ़ाइल नहीं बनाई जा सकी। स्वचालित बैकअप बंद कर दिए गए।';

  @override
  String get backupFailureAppFilesUnavailable =>
      'बैकअप असफल: ऐप फ़ाइल डायरेक्टरी तक पहुँच नहीं मिली। स्वचालित बैकअप बंद कर दिए गए।';

  @override
  String get backupFailureDatabaseMissing =>
      'बैकअप असफल: डेटाबेस फ़ाइल नहीं मिली। स्वचालित बैकअप बंद कर दिए गए।';

  @override
  String get backupFailureOutputUnavailable =>
      'बैकअप असफल: आउटपुट स्ट्रीम नहीं खोली जा सकी। स्वचालित बैकअप बंद कर दिए गए।';

  @override
  String get backupFailureUnknown =>
      'बैकअप असफल। स्वचालित बैकअप बंद कर दिए गए।';

  @override
  String get appPermissionsDescription =>
      'आपके चालू फ़ीचर्स के लिए आवश्यक एक्सेस की समीक्षा करें';

  @override
  String get longDateFormatDescription =>
      'जहाँ पर्याप्त जगह हो वहाँ इस्तेमाल होता है';

  @override
  String shortDateFormat(String example) {
    return 'छोटा तारीख प्रारूप ($example)';
  }

  @override
  String get shortDateFormatDescription =>
      'जहाँ जगह कम हो वहाँ (ग्राफ़ रेखाएँ)';

  @override
  String get warmupSetsDescription => 'वार्मअप सेट में रेस्ट टाइमर नहीं होते';

  @override
  String get setsPerExerciseDescription =>
      'प्लान में व्यायामों की डिफ़ॉल्ट संख्या';

  @override
  String get planTrailingDisplay => 'प्लान का दायाँ प्रदर्शन';

  @override
  String get planTrailingDisplayDescription =>
      'प्लान + प्लान दृश्य में सूची के दाएँ हिस्से में क्या दिखे';

  @override
  String get restTimersDescription => 'सेट पूरा करने के बाद बजने वाला अलार्म';

  @override
  String get vibrateDescription => 'क्या रेस्ट टाइमर में कंपन होना चाहिए?';

  @override
  String get enableSoundDescription => 'क्या रेस्ट टाइमर में ध्वनि बजनी चाहिए?';

  @override
  String get keepScreenOnDescription =>
      'रेस्ट टाइमर के दौरान स्क्रीन चालू रखें';

  @override
  String get restDurationDescription => 'रेस्ट अलार्म बजने में कितना समय लगे?';

  @override
  String get globalDefault => 'कुल डिफ़ॉल्ट';

  @override
  String get alarmSoundDescription => 'रेस्ट टाइमर के अंत में बजने वाला संगीत';

  @override
  String get progressBarPosition => 'प्रगति बार की स्थिति';

  @override
  String get progressBarPositionDescription =>
      'रेस्ट टाइमर का प्रगति बार कहाँ रखा जाए?';

  @override
  String get perExerciseRestTimes => 'प्रति-व्यायाम रेस्ट समय';

  @override
  String get perExerciseRestTimesDescription =>
      'इन व्यायामों की कस्टम रेस्ट अवधि है';

  @override
  String get audioFeaturesUnavailable => 'ऑडियो फ़ीचर उपलब्ध नहीं हैं';

  @override
  String get groupHistoryDescription =>
      'इतिहास प्रविष्टियों को दिन के अनुसार मिलाएँ';

  @override
  String get showUnitsDescription =>
      'ग्राफ़/इतिहास/प्लान में km/mi, kg/lb दिखाएँ';

  @override
  String get showBodyWeightDescription =>
      'शरीर के वज़न की ट्रैकिंग चालू/बंद करें';

  @override
  String get showCategoriesDescription => 'वर्कआउट श्रेणियाँ चालू/बंद करें';

  @override
  String get showNotesDescription =>
      'अपने लिफ्ट का विवरण टेक्स्ट क्षेत्र में दर्ज करें';

  @override
  String get positiveNotificationsDescription =>
      'नया रिकॉर्ड बनने पर उत्साहवर्धक संदेश दिखाएँ';

  @override
  String get positiveMessagesEnabled => 'सकारात्मक संदेश अब ऐसे दिखाई देंगे!';

  @override
  String get recordEncouragement01 => 'बहुत बढ़िया! आप कमाल हैं।';

  @override
  String get recordEncouragement02 => 'शानदार! आपकी प्रगति प्रेरणादायक है।';

  @override
  String get recordEncouragement03 => 'मैं नतमस्तक हूँ...';

  @override
  String get recordEncouragement04 => 'यह क्या? नया रिकॉर्ड!';

  @override
  String get recordEncouragement05 => 'कमाल का काम! आप प्रेरणा हैं।';

  @override
  String get recordEncouragement06 => 'वाह। बढ़िया।';

  @override
  String get recordEncouragement07 => 'काफ़ी ताकतवर हो रहे हैं, है ना?';

  @override
  String get recordEncouragement08 => 'हाँ। आप काफ़ी मजबूत हैं।';

  @override
  String get recordEncouragement09 => 'अद्भुत। अविश्वसनीय।';

  @override
  String get recordEncouragement10 => 'आर्नी को आप पर गर्व होता।';

  @override
  String get recordEncouragement11 => 'रॉनी सी आपको खुशी से देख रहे हैं।';

  @override
  String get recordEncouragement12 => 'हाँ! हल्का वज़न, बेबी!!!!!!!';

  @override
  String get recordEncouragement13 =>
      'क्या यह नया रिकॉर्ड है? मुझे पता था आप कर सकते हैं।';

  @override
  String get recordEncouragement14 => 'बहुत बढ़िया! मुझे आप पर गर्व है।';

  @override
  String get recordEncouragement15 => 'हाँ बेबी! हल्का वज़न!';

  @override
  String get recordEncouragement16 => 'जारी रखें! शानदार प्रगति।';

  @override
  String get recordEncouragement17 => 'आप बहुत अच्छा कर रहे हैं।';

  @override
  String get recordEncouragement18 => 'यही बात है!';

  @override
  String get recordEncouragement19 => 'जारी रखें।';

  @override
  String get recordEncouragement20 => 'आप बहुत ताकतवर हो रहे हैं।';

  @override
  String get recordEncouragement21 => 'दमदार।';

  @override
  String get recordEncouragement22 => 'दमदार काम!';

  @override
  String get recordEncouragement23 => 'मुझे आप पर गर्व है।';

  @override
  String get recordEncouragement24 => 'शानदार काम जारी रखें।';

  @override
  String get recordEncouragement25 =>
      'सीना तानकर खड़े हों! आपने नया रिकॉर्ड बनाया है।';

  @override
  String get recordEncouragement26 => 'नया रिकॉर्ड! आपने पहले से भी आगे धकेला!';

  @override
  String get recordEncouragement27 => 'हाँ! यह रिकॉर्ड है।';

  @override
  String get recordEncouragement28 => 'वाह! नया रिकॉर्ड!';

  @override
  String get recordEncouragement29 => 'बहुत बढ़िया काम।';

  @override
  String get repEstimationDescription =>
      'आपने अभी कितने रेप किए, इसका अनुमान लगाने की कोशिश करें';

  @override
  String get durationEstimationDescription =>
      'अपने कार्डियो की अवधि का अनुमान लगाने की कोशिश करें';

  @override
  String get showGraphXAxisToggle => 'ग्राफ़ X अक्ष टॉगल दिखाएँ';

  @override
  String get showGraphXAxisToggleDescription =>
      'ग्राफ़ पर समय-आधारित X अक्ष का टॉगल दिखाएँ';

  @override
  String get showGraphLimitDescription => 'ग्राफ़ पर सीमा स्लाइडर दिखाएँ';

  @override
  String get defaultTimeBasedXAxis => 'डिफ़ॉल्ट समय-आधारित X अक्ष';

  @override
  String get defaultTimeBasedXAxisDescription =>
      'ग्राफ़ पर डिफ़ॉल्ट रूप से समय-आधारित X अक्ष इस्तेमाल करें';

  @override
  String get createFirstTrainingPlan =>
      'शुरू करने के लिए अपना पहला ट्रेनिंग प्लान बनाएँ।';

  @override
  String nothingMatchesPlanSearch(String query) {
    return '“$query” से कुछ मेल नहीं खाता। आप इसे नए प्लान के रूप में बना सकते हैं।';
  }

  @override
  String get createPlan => 'प्लान बनाएँ';

  @override
  String createNamedPlan(String name) {
    return '“$name” बनाएँ';
  }

  @override
  String setNumber(int number) {
    return 'सेट $number';
  }
}
