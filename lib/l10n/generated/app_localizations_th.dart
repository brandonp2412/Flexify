// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => 'ภาษา';

  @override
  String get settingsLanguageDescription => 'เลือกภาษาที่ใช้ใน Flexify';

  @override
  String get languageSystemDefault => 'ค่าเริ่มต้นของระบบ';

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
  String get navHistory => 'ประวัติ';

  @override
  String get navPlans => 'แผน';

  @override
  String get navGraphs => 'กราฟ';

  @override
  String get navTimer => 'ตัวจับเวลา';

  @override
  String get navSettings => 'การตั้งค่า';

  @override
  String get errorLabel => 'ข้อผิดพลาด';

  @override
  String get tabContentError => 'ไม่สามารถสร้างเนื้อหาแท็บได้';

  @override
  String get cannotHideAllTabs => 'ไม่สามารถซ่อนทุกอย่างได้!';

  @override
  String removeTabQuestion(String tab) {
    return 'ลบแท็บ $tab หรือไม่?';
  }

  @override
  String get restoreTabFromSettings =>
      'คุณสามารถเพิ่มกลับได้ภายหลังจากการตั้งค่า';

  @override
  String removedTab(String tab) {
    return 'ลบ $tab แล้ว';
  }

  @override
  String newVersion(String version) {
    return 'เวอร์ชันใหม่ $version';
  }

  @override
  String get changes => 'การเปลี่ยนแปลง';

  @override
  String get searchHint => 'ค้นหา...';

  @override
  String get deleteSelected => 'ลบที่เลือก';

  @override
  String get confirmDelete => 'ยืนยันการลบ';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'คุณแน่ใจหรือไม่ว่าต้องการลบ $count รายการ? การดำเนินการนี้ย้อนกลับไม่ได้',
      one:
          'คุณแน่ใจหรือไม่ว่าต้องการลบ 1 รายการ? การดำเนินการนี้ย้อนกลับไม่ได้',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'ยกเลิก';

  @override
  String get actionDelete => 'ลบ';

  @override
  String get actionRemove => 'เอาออก';

  @override
  String get actionEdit => 'แก้ไข';

  @override
  String get actionShare => 'แชร์';

  @override
  String get clearSelection => 'ล้างการเลือก';

  @override
  String get clearSearch => 'ล้างการค้นหา';

  @override
  String get showMenu => 'แสดงเมนู';

  @override
  String get selectAll => 'เลือกทั้งหมด';

  @override
  String get weightLabel => 'น้ำหนัก';

  @override
  String get filter => 'ตัวกรอง';

  @override
  String get filters => 'ตัวกรอง';

  @override
  String get categoryLabel => 'หมวดหมู่';

  @override
  String get repsLabel => 'จำนวนครั้ง';

  @override
  String get repsFilter => 'ตัวกรองจำนวนครั้ง';

  @override
  String get weightFilter => 'ตัวกรองน้ำหนัก';

  @override
  String get greaterThan => 'มากกว่า';

  @override
  String get lessThan => 'น้อยกว่า';

  @override
  String get startDate => 'วันที่เริ่มต้น';

  @override
  String get endDate => 'วันที่สิ้นสุด';

  @override
  String get actionClear => 'ล้าง';

  @override
  String get actionOk => 'ตกลง';

  @override
  String get actionClose => 'ปิด';

  @override
  String get sortBy => 'เรียงตาม';

  @override
  String get dateNewest => 'วันที่ (ใหม่สุด)';

  @override
  String get dateOldest => 'วันที่ (เก่าสุด)';

  @override
  String get nameLabel => 'ชื่อ';

  @override
  String get missingPermissions => 'ไม่มีสิทธิ์ที่จำเป็น';

  @override
  String get restTimersPermissionsMissing =>
      'ตัวจับเวลาพักเปิดอยู่ แต่ไม่มีสิทธิ์ที่จำเป็น';

  @override
  String get restTimersPermissionsOptional =>
      'หากปิดตัวจับเวลาพัก ก็ไม่จำเป็นต้องใช้สิทธิ์เหล่านี้';

  @override
  String get restTimers => 'ตัวจับเวลาพัก';

  @override
  String get disableBatteryOptimizations => 'ปิดการเพิ่มประสิทธิภาพแบตเตอรี่';

  @override
  String get batteryOptimizationWarning =>
      'ความคืบหน้าอาจหยุดชั่วคราวหากยังเปิดการเพิ่มประสิทธิภาพแบตเตอรี่';

  @override
  String get scheduleExactAlarm => 'ตั้งเวลาปลุกแบบแม่นยำ';

  @override
  String get exactAlarmWarning => 'การปลุกอาจไม่ตรงเวลาหากปิดตัวเลือกนี้';

  @override
  String get postNotifications => 'แสดงการแจ้งเตือน';

  @override
  String get notificationBarDescription =>
      'ความคืบหน้าของตัวจับเวลาจะแสดงในแถบการแจ้งเตือน';

  @override
  String get invalidPermissions => 'สิทธิ์ไม่ถูกต้อง';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      'เปิดตัวจับเวลาพักโดยไม่มีสิทธิ์เพียงพอ คุณแน่ใจหรือไม่?';

  @override
  String get actionConfirm => 'ยืนยัน';

  @override
  String get appAccess => 'การเข้าถึงแอป';

  @override
  String get appAccessDescription =>
      'จำเป็นสำหรับตัวจับเวลาและการแจ้งเตือนที่เปิดใช้งาน';

  @override
  String get notifications => 'การแจ้งเตือน';

  @override
  String get timerProgressAndRestAlerts =>
      'ความคืบหน้าของตัวจับเวลาและการแจ้งเตือนพัก';

  @override
  String get enabledNotificationsDescription => 'การแจ้งเตือนที่คุณเปิดใช้งาน';

  @override
  String get backgroundActivity => 'กิจกรรมเบื้องหลัง';

  @override
  String get backgroundActivityDescription =>
      'ทำให้ตัวจับเวลาทำงานได้อย่างน่าเชื่อถือในเบื้องหลัง';

  @override
  String get exactAlarms => 'การปลุกแบบแม่นยำ';

  @override
  String get exactAlarmsDescription =>
      'แจ้งเตือนทันทีเมื่อตัวจับเวลาพักสิ้นสุด';

  @override
  String get noAdditionalAndroidAccessNeeded =>
      'ไม่จำเป็นต้องให้สิทธิ์ Android เพิ่มเติมสำหรับการตั้งค่าปัจจุบัน';

  @override
  String get actionDone => 'เสร็จสิ้น';

  @override
  String get allowed => 'อนุญาตแล้ว';

  @override
  String get actionAllow => 'อนุญาต';

  @override
  String get backupLabel => 'สำรองข้อมูล';

  @override
  String get databaseLabel => 'ฐานข้อมูล';

  @override
  String get deleteRecords => 'ลบรายการ';

  @override
  String get deleteAllGraphsConfirmation =>
      'คุณแน่ใจหรือไม่ว่าต้องการลบกราฟทั้งหมด? การดำเนินการนี้ย้อนกลับไม่ได้';

  @override
  String get deleteAllPlansConfirmation =>
      'คุณแน่ใจหรือไม่ว่าต้องการลบแผนทั้งหมด? การดำเนินการนี้ย้อนกลับไม่ได้';

  @override
  String get deleteDatabaseConfirmation =>
      'คุณแน่ใจหรือไม่ว่าต้องการลบฐานข้อมูล? การดำเนินการนี้ย้อนกลับไม่ได้และจะทำลายข้อมูลทั้งหมดของคุณ';

  @override
  String get importData => 'นำเข้าข้อมูล';

  @override
  String get exportData => 'ส่งออกข้อมูล';

  @override
  String get actionReport => 'รายงาน';

  @override
  String get graphDataImported => 'นำเข้าข้อมูลกราฟสำเร็จ!';

  @override
  String get plansImported => 'นำเข้าแผนสำเร็จ';

  @override
  String failedToImportDatabase(String error) {
    return 'ไม่สามารถนำเข้าฐานข้อมูล: $error';
  }

  @override
  String get backupArchiveMissingDatabase => 'ไฟล์สำรองไม่มีฐานข้อมูล Flexify';

  @override
  String failedToImportGraphs(String error) {
    return 'ไม่สามารถนำเข้ากราฟ: $error';
  }

  @override
  String failedToImportPlans(String error) {
    return 'ไม่สามารถนำเข้าแผน: $error';
  }

  @override
  String get selectedFileDoesNotExist => 'ไฟล์ที่เลือกไม่มีอยู่';

  @override
  String get couldNotReadFileData => 'ไม่สามารถอ่านข้อมูลไฟล์ได้';

  @override
  String get databaseImportWebUnsupported =>
      'การนำเข้าฐานข้อมูลบนเว็บต้องย้ายข้อมูลด้วยตนเอง โปรดส่งออกข้อมูลเป็นไฟล์ CSV แล้วนำเข้าไฟล์เหล่านั้นแทน';

  @override
  String get csvFileEmpty => 'ไฟล์ CSV ว่างเปล่า';

  @override
  String get csvNeedsDataRow => 'ไฟล์ CSV ต้องมีข้อมูลอย่างน้อยหนึ่งแถว';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return 'แถว $row มีคอลัมน์ไม่เพียงพอ: $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return 'ค่า $field ในแถว $row ไม่ถูกต้อง: $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return 'ชนิดข้อมูล $field ในแถว $row ไม่ถูกต้อง: $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return 'คาดว่า plan id เป็นจำนวนเต็ม แต่ได้ \"$value\"';
  }

  @override
  String get unitLabel => 'หน่วย';

  @override
  String get kilogramsUnit => 'กิโลกรัม (kg)';

  @override
  String get poundsUnit => 'ปอนด์ (lb)';

  @override
  String get stoneUnit => 'สโตน';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => 'กิโลเมตร (km)';

  @override
  String get milesUnit => 'ไมล์ (mi)';

  @override
  String get metersUnit => 'เมตร (m)';

  @override
  String get kilocaloriesUnit => 'กิโลแคลอรี (kcal)';

  @override
  String get enterWeight => 'ป้อนน้ำหนัก';

  @override
  String get requiredField => 'จำเป็น';

  @override
  String get invalidNumber => 'ตัวเลขไม่ถูกต้อง';

  @override
  String get previousWeight => 'น้ำหนักก่อนหน้า';

  @override
  String get imageLabel => 'รูปภาพ';

  @override
  String get longPressToDelete => 'กดค้างเพื่อลบ';

  @override
  String get imageError => 'ข้อผิดพลาดของรูปภาพ';

  @override
  String get actionSave => 'บันทึก';

  @override
  String get aboutTitle => 'เกี่ยวกับ';

  @override
  String get donate => 'บริจาค';

  @override
  String get helpSupportProject => 'ช่วยสนับสนุนโครงการนี้';

  @override
  String get whatsNewAbout => 'มีอะไรใหม่?';

  @override
  String get whatsNewTitle => 'มีอะไรใหม่?';

  @override
  String get seeReleaseNotes => 'ดูบันทึกประจำรุ่น';

  @override
  String get versionLabel => 'เวอร์ชัน';

  @override
  String get authorLabel => 'ผู้เขียน';

  @override
  String get privacyPolicy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get privacyPolicyDescription => 'Flexify จัดการข้อมูลของคุณอย่างไร';

  @override
  String get licenseLabel => 'ใบอนุญาต';

  @override
  String get sourceCode => 'ซอร์สโค้ด';

  @override
  String get sourceCodeDescription => 'ดูได้บน GitHub';

  @override
  String get leaveReview => 'เขียนรีวิว';

  @override
  String get leaveReviewDescription => 'ให้คะแนน Flexify บน Play Store';

  @override
  String get reportBug => 'รายงานข้อบกพร่อง';

  @override
  String get reportBugDescription => 'เปิดตั๋วบน GitHub';

  @override
  String get failedMigrations => 'การย้ายข้อมูลที่ล้มเหลว';

  @override
  String get errorMessageLabel => 'ข้อความข้อผิดพลาด:';

  @override
  String get createIssue => 'สร้างอิชชู';

  @override
  String get addExercise => 'เพิ่มการออกกำลังกาย';

  @override
  String get cardio => 'คาร์ดิโอ';

  @override
  String get strength => 'ความแข็งแรง';

  @override
  String get options => 'ตัวเลือก';

  @override
  String get periodDay => 'วัน';

  @override
  String get periodWeek => 'สัปดาห์';

  @override
  String get periodMonth => 'เดือน';

  @override
  String get periodYear => 'ปี';

  @override
  String noDataFor(String name) {
    return 'ยังไม่มีข้อมูลสำหรับ $name';
  }

  @override
  String get noDataYet => 'ยังไม่มีข้อมูล';

  @override
  String get exerciseNotes => 'หมายเหตุการออกกำลังกาย';

  @override
  String get notesForExercise => 'หมายเหตุสำหรับการออกกำลังกายนี้';

  @override
  String get useTimeBasedXAxis => 'ใช้แกน X ตามเวลา';

  @override
  String updateAllNamed(String name) {
    return 'อัปเดต $name ทั้งหมด';
  }

  @override
  String get newName => 'ชื่อใหม่';

  @override
  String get restMinutes => 'นาทีพัก';

  @override
  String get restSeconds => 'วินาทีพัก';

  @override
  String get globalProgress => 'ความคืบหน้าโดยรวม';

  @override
  String get curveLineGraphs => 'ทำเส้นกราฟให้โค้ง';

  @override
  String get curveLineGraphsDescription => 'วาดเส้นกราฟเป็นเส้นโค้งเรียบ';

  @override
  String noHistoryFor(String name) {
    return 'ยังไม่มีประวัติสำหรับ $name';
  }

  @override
  String get cancelSelection => 'ยกเลิกการเลือก';

  @override
  String get editSelected => 'แก้ไขที่เลือก';

  @override
  String get newExercise => 'การออกกำลังกายใหม่';

  @override
  String get noGraphsFound => 'ไม่พบกราฟ';

  @override
  String get searchGraphs => 'ค้นหากราฟ...';

  @override
  String get actionAdd => 'เพิ่ม';

  @override
  String get actionUpdate => 'อัปเดต';

  @override
  String get hideGlobalProgress => 'ซ่อนความคืบหน้าโดยรวม';

  @override
  String get chartGroupedByCategory => 'แผนภูมิที่จัดกลุ่มตามหมวดหมู่';

  @override
  String get noExercisesFound => 'ไม่พบการออกกำลังกาย';

  @override
  String get savePlan => 'บันทึกแผน';

  @override
  String get titleOptional => 'ชื่อเรื่อง (ไม่บังคับ)';

  @override
  String get searchExercises => 'ค้นหาการออกกำลังกาย...';

  @override
  String get warmupSets => 'เซ็ตวอร์มอัป';

  @override
  String get workingSetsMax => 'เซ็ตหลัก (สูงสุด: 20)';

  @override
  String get actionUndo => 'เลิกทำ';

  @override
  String get actionSwap => 'สลับ';

  @override
  String get daily => 'รายวัน';

  @override
  String get weekly => 'รายสัปดาห์';

  @override
  String get monthly => 'รายเดือน';

  @override
  String get yearly => 'รายปี';

  @override
  String get unexpectedError => 'เกิดข้อผิดพลาด โปรดลองอีกครั้ง';

  @override
  String get loadingExercises => 'กำลังโหลดการออกกำลังกาย...';

  @override
  String get noPlansYet => 'ยังไม่มีแผน';

  @override
  String get noMatchingPlans => 'ไม่พบแผนที่ตรงกัน';

  @override
  String get newPlan => 'แผนใหม่';

  @override
  String get searchPlans => 'ค้นหาแผน...';

  @override
  String get noExercisesYet => 'ยังไม่มีการออกกำลังกาย';

  @override
  String get editPlan => 'แก้ไขแผน';

  @override
  String get saveSet => 'บันทึกเซ็ต';

  @override
  String get minutesLabel => 'นาที';

  @override
  String get minutesShort => 'นาที';

  @override
  String get secondsLabel => 'วินาที';

  @override
  String get distanceLabel => 'ระยะทาง';

  @override
  String get inclinePercent => 'ความชัน %';

  @override
  String weightWithUnit(String unit) {
    return 'น้ำหนัก ($unit)';
  }

  @override
  String get useBodyWeight => 'ใช้น้ำหนักตัว';

  @override
  String get noWeightEnteredYet => 'ยังไม่ได้ป้อนน้ำหนัก';

  @override
  String get notesLabel => 'หมายเหตุ';

  @override
  String get swapWorkout => 'สลับเวิร์กเอาต์';

  @override
  String get addSet => 'เพิ่มเซ็ต';

  @override
  String get deleteSet => 'ลบเซ็ต';

  @override
  String get oneRepMaxEstimate => 'หนึ่งครั้งสูงสุด (ประมาณการ)';

  @override
  String get valueLabel => 'ค่า';

  @override
  String amountWithUnit(String unit) {
    return 'ปริมาณ ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return 'ระยะทาง ($unit)';
  }

  @override
  String get bodyWeightLabel => 'น้ำหนักตัว';

  @override
  String bodyWeightWithUnit(String unit) {
    return 'น้ำหนักตัว ($unit)';
  }

  @override
  String get categoryHelper => 'เลือกหมวดหมู่ที่มีอยู่หรือพิมพ์หมวดหมู่ใหม่';

  @override
  String get manageCategories => 'จัดการหมวดหมู่';

  @override
  String get manageCategoriesDescription =>
      'สร้าง เปลี่ยนชื่อ รวม หรือลบหมวดหมู่';

  @override
  String get newCategory => 'หมวดหมู่ใหม่';

  @override
  String get renameCategory => 'เปลี่ยนชื่อหมวดหมู่';

  @override
  String get mergeCategory => 'รวมเข้ากับหมวดหมู่อื่น';

  @override
  String get noCategories => 'ยังไม่มีหมวดหมู่';

  @override
  String get categoryNameRequired => 'ป้อนชื่อหมวดหมู่';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ใช้กับ $count รายการ',
      one: 'ใช้กับ 1 รายการ',
      zero: 'ไม่ได้ใช้กับรายการใด',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ลบหมวดหมู่นี้และนำออกจาก $count รายการหรือไม่?',
      one: 'ลบหมวดหมู่นี้และนำออกจาก 1 รายการหรือไม่?',
      zero: 'ลบหมวดหมู่นี้หรือไม่?',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => 'วันที่สร้าง';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'แก้ไข $count เซ็ต',
      one: 'แก้ไข 1 เซ็ต',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => 'ยังไม่มีรายการ';

  @override
  String get historyEmptyMessage =>
      'ทำเซ็ตให้เสร็จหรือเพิ่มด้วยตนเองเพื่อเริ่มประวัติของคุณ';

  @override
  String deleteSetConfirmation(String name) {
    return 'คุณแน่ใจหรือไม่ว่าต้องการลบ $name?';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'คุณแน่ใจหรือไม่ว่าต้องการลบ $count รายการ?',
      one: 'คุณแน่ใจหรือไม่ว่าต้องการลบ 1 รายการ?',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => 'ค้นหาประวัติ...';

  @override
  String get themeSystem => 'ระบบ';

  @override
  String get themeDark => 'มืด';

  @override
  String get themeLight => 'สว่าง';

  @override
  String get pureBlackAmoled => 'ดำสนิท (AMOLED)';

  @override
  String get showImages => 'แสดงรูปภาพ';

  @override
  String get peekGraph => 'แสดงกราฟตัวอย่าง';

  @override
  String get inputStyleLine => 'เส้น';

  @override
  String get inputStyleOutlined => 'มีเส้นขอบ';

  @override
  String get inputStyleFilled => 'เติมพื้น';

  @override
  String get inputStyle => 'รูปแบบช่องป้อนข้อมูล';

  @override
  String get appearance => 'รูปลักษณ์';

  @override
  String get automaticBackupsEnabled => 'เปิดการสำรองข้อมูลอัตโนมัติ';

  @override
  String get automaticBackup => 'สำรองข้อมูลอัตโนมัติ';

  @override
  String get appPermissions => 'สิทธิ์ของแอป';

  @override
  String get shareDatabase => 'แชร์ฐานข้อมูล';

  @override
  String get dataManagement => 'การจัดการข้อมูล';

  @override
  String get strengthUnit => 'หน่วยความแข็งแรง';

  @override
  String get lastEntry => 'รายการล่าสุด';

  @override
  String get cardioUnit => 'หน่วยคาร์ดิโอ';

  @override
  String longDateFormat(String format) {
    return 'รูปแบบวันที่แบบยาว ($format)';
  }

  @override
  String get formats => 'รูปแบบ';

  @override
  String get setsPerExerciseMax => 'เซ็ตต่อการออกกำลังกาย (สูงสุด: 20)';

  @override
  String get countLabel => 'จำนวน';

  @override
  String get ratioLabel => 'อัตราส่วน';

  @override
  String get reorder => 'จัดเรียงใหม่';

  @override
  String get none => 'ไม่มี';

  @override
  String get monday => 'วันจันทร์';

  @override
  String get examplePlanExercises => 'เบนช์เพรส, สควอต, เดดลิฟต์';

  @override
  String get tabs => 'แท็บ';

  @override
  String get swipeBetweenTabs => 'ปัดสลับระหว่างแท็บ';

  @override
  String get vibrate => 'สั่น';

  @override
  String get enableSound => 'เปิดเสียง';

  @override
  String get keepScreenOn => 'เปิดหน้าจอค้างไว้';

  @override
  String get alarmSound => 'เสียงปลุก';

  @override
  String get top => 'ด้านบน';

  @override
  String get bottom => 'ด้านล่าง';

  @override
  String get removeCustomTimer =>
      'ลบตัวจับเวลาแบบกำหนดเอง (ใช้ค่าเริ่มต้นส่วนกลาง)';

  @override
  String get timers => 'ตัวจับเวลา';

  @override
  String get timerSettings => 'การตั้งค่าตัวจับเวลา';

  @override
  String get groupHistory => 'จัดกลุ่มประวัติ';

  @override
  String get showUnits => 'แสดงหน่วย';

  @override
  String get showBodyWeight => 'แสดงน้ำหนักตัว';

  @override
  String get showCategories => 'แสดงหมวดหมู่';

  @override
  String get showNotes => 'แสดงหมายเหตุ';

  @override
  String get repEstimation => 'การประมาณจำนวนครั้ง';

  @override
  String get durationEstimation => 'การประมาณระยะเวลา';

  @override
  String get showGraphLimit => 'แสดงขีดจำกัดกราฟ';

  @override
  String get defaultGraphMetric => 'เมตริกกราฟเริ่มต้น';

  @override
  String get bestWeight => 'น้ำหนักสูงสุด';

  @override
  String get bestReps => 'จำนวนครั้งสูงสุด';

  @override
  String get oneRepMax => 'หนึ่งครั้งสูงสุด';

  @override
  String get volume => 'ปริมาตร';

  @override
  String get paceCardio => 'เพซ (คาร์ดิโอ)';

  @override
  String get distanceCardio => 'ระยะทาง (คาร์ดิโอ)';

  @override
  String get defaultGraphPeriod => 'ช่วงเวลากราฟเริ่มต้น';

  @override
  String get defaultGraphLimit => 'ขีดจำกัดกราฟเริ่มต้น';

  @override
  String get workouts => 'เวิร์กเอาต์';

  @override
  String get actionStop => 'หยุด';

  @override
  String get timerFinishedToast => 'ตัวจับเวลาเสร็จแล้ว!';

  @override
  String get stopTimer => 'หยุดตัวจับเวลา';

  @override
  String get actionPause => 'หยุดชั่วคราว';

  @override
  String get startStopwatch => 'เริ่มนาฬิกาจับเวลา';

  @override
  String get actionStart => 'เริ่ม';

  @override
  String get actionRestart => 'เริ่มใหม่';

  @override
  String get addOneMinute => '+1 นาที';

  @override
  String get addOneMinuteNotification => 'เพิ่ม 1 นาที';

  @override
  String get restTimer => 'ตัวจับเวลาพัก';

  @override
  String get timerUp => 'หมดเวลา';

  @override
  String get openNotification => 'เปิดการแจ้งเตือน';

  @override
  String get timerChannelName => 'ช่องตัวจับเวลา';

  @override
  String get timerChannelDescription => 'ความคืบหน้าต่อเนื่องของตัวจับเวลาพัก';

  @override
  String get timerFinishedChannelName => 'ช่องตัวจับเวลาเสร็จสิ้น';

  @override
  String get timerFinishedChannelDescription =>
      'เล่นเสียงปลุกเมื่อตัวจับเวลาพักสิ้นสุด';

  @override
  String get timerFinished => 'ตัวจับเวลาเสร็จแล้ว';

  @override
  String get batteryOptimizationRequestUnavailable =>
      'อุปกรณ์ของคุณปิดใช้งานคำขอให้ละเว้นการเพิ่มประสิทธิภาพแบตเตอรี่';

  @override
  String get exactAlarmRequestUnavailable =>
      'อุปกรณ์ของคุณปฏิเสธคำขอ SCHEDULE_EXACT_ALARM';

  @override
  String get databaseMigrationFailureDescription =>
      'เกิดข้อผิดพลาดขณะสร้างหรืออัปเกรดฐานข้อมูล โดยปกติแก้ไขได้โดยลบแล้วสร้างรายการใหม่';

  @override
  String get curveSmoothness => 'ความเรียบของเส้นโค้ง';

  @override
  String get actionBack => 'ย้อนกลับ';

  @override
  String get atLeastOneTab => 'คุณต้องมีอย่างน้อยหนึ่งแท็บ';

  @override
  String get invalidTabSettings => 'การตั้งค่าแท็บไม่ถูกต้อง';

  @override
  String get noSettingsFound => 'ไม่พบการตั้งค่า';

  @override
  String nothingMatchesSearch(String query) {
    return 'ไม่มีรายการที่ตรงกับ “$query”';
  }

  @override
  String get appearanceDescription => 'ธีม สี และรูปแบบอินเทอร์เฟซ';

  @override
  String get dataManagementDescription =>
      'นำเข้า ส่งออก และจัดการข้อมูลการออกกำลังกายของคุณ';

  @override
  String get formatsDescription => 'รูปแบบวันที่ ตัวเลข และหน่วยวัด';

  @override
  String get plansSettingsDescription =>
      'ค่าเริ่มต้นและลักษณะการทำงานของแผนการออกกำลังกาย';

  @override
  String get tabsDescription => 'เลือกและจัดเรียงแท็บการนำทางหลัก';

  @override
  String get timersDescription =>
      'ระยะเวลาพัก เสียง และลักษณะการทำงานของตัวจับเวลา';

  @override
  String get workoutsDescription =>
      'การติดตามการออกกำลังกายและการตั้งค่าเวิร์กเอาต์';

  @override
  String get completeSetForChart =>
      'ทำหนึ่งเซ็ตของการออกกำลังกายนี้ให้เสร็จเพื่อสร้างกราฟ';

  @override
  String get dateRange => 'ช่วงวันที่';

  @override
  String get stopDate => 'วันที่สิ้นสุด';

  @override
  String get dataPoints => 'จุดข้อมูล';

  @override
  String get completeSetsForProgress =>
      'ทำบางเซ็ตให้เสร็จเพื่อสร้างกราฟความคืบหน้าของคุณ';

  @override
  String get relativeStrength => 'ความแข็งแรงสัมพัทธ์';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'เลือก $count รายการ',
      one: 'เลือก 1 รายการ',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory =>
      'ทำบางเซ็ตให้เสร็จเพื่อดูประวัติการออกกำลังกายนี้ที่นี่';

  @override
  String get completeSetForFirstGraph =>
      'ทำหนึ่งเซ็ตให้เสร็จเพื่อสร้างกราฟการออกกำลังกายแรกของคุณ';

  @override
  String nothingMatchesGraphSearch(String query) {
    return 'ไม่มีรายการที่ตรงกับ “$query” คุณสามารถสร้างเป็นการออกกำลังกายใหม่ได้';
  }

  @override
  String addNamed(String name) {
    return 'เพิ่ม “$name”';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return 'การดำเนินการนี้จะลบ $count รายการ คุณแน่ใจหรือไม่?';
  }

  @override
  String shareWorkout(String summary) {
    return 'ฉันเพิ่งทำ $summary';
  }

  @override
  String get updateConflict => 'ข้อมูลอัปเดตขัดแย้งกัน';

  @override
  String updateConflictDescription(int count) {
    return 'ชื่อใหม่ของคุณมีอยู่แล้วใน $count รายการ คุณแน่ใจหรือไม่?';
  }

  @override
  String get unitsConflict => 'หน่วยขัดแย้งกัน';

  @override
  String unitsConflictDescription(String unit) {
    return 'รายการของคุณไม่ได้ใช้หน่วยเดียวกันทั้งหมด การดำเนินการนี้จะแปลงหน่วยทั้งหมดเป็น $unit คุณแน่ใจหรือไม่?';
  }

  @override
  String get durationLabel => 'ระยะเวลา';

  @override
  String get inclineLabel => 'ความชัน';

  @override
  String get paceDistanceTime => 'เพซ (ระยะทาง / เวลา)';

  @override
  String get adjustedPace => 'เพซที่ปรับแล้ว';

  @override
  String get oneRepMaxAccuracyWarning =>
      'การประมาณหนึ่งครั้งสูงสุดจะแม่นยำน้อยลงสำหรับเซ็ตตั้งแต่ 10 ครั้งขึ้นไป';

  @override
  String get addPlan => 'เพิ่มแผน';

  @override
  String get planDetails => 'รายละเอียดแผน';

  @override
  String get exercisesLabel => 'การออกกำลังกาย';

  @override
  String get addExerciseToPlan => 'เพิ่มการออกกำลังกายลงในแผนนี้';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return 'ไม่มีรายการที่ตรงกับ “$query” คุณสามารถเพิ่มเป็นการออกกำลังกายใหม่ได้';
  }

  @override
  String get selectDays => 'เลือกวัน';

  @override
  String get selectExercises => 'เลือกการออกกำลังกาย';

  @override
  String get todayLabel => 'วันนี้';

  @override
  String get setDetails => 'รายละเอียดเซ็ต';

  @override
  String get themeLabel => 'ธีม';

  @override
  String get pureBlackAmoledDescription => 'ใช้สีดำสนิทสำหรับหน้าจอ AMOLED';

  @override
  String get systemColorScheme => 'โทนสีของระบบ';

  @override
  String get systemColorSchemeDescription =>
      'ใช้สีหลักของอุปกรณ์เป็นสีหลักของแอป';

  @override
  String get showImagesDescription => 'เลือกและแสดงรูปภาพในหน้าประวัติ';

  @override
  String get showGlobalProgress => 'แสดงความคืบหน้าโดยรวม';

  @override
  String get showGlobalProgressDescription =>
      'เพิ่มรายการกราฟที่แสดงความคืบหน้าของคุณตามหมวดหมู่';

  @override
  String get peekGraphDescription => 'แสดงกราฟเส้นแรกในหน้ากราฟ';

  @override
  String get inputStyleDescription => 'รูปแบบภาพของช่องป้อนข้อความ';

  @override
  String get automaticBackupNotificationBody =>
      'Flexify จะสำรองข้อมูลและรูปภาพของคุณไปยังโฟลเดอร์ที่เลือกโดยอัตโนมัติทุกวัน';

  @override
  String get backupSettingsChannel => 'การตั้งค่าการสำรองข้อมูล';

  @override
  String get backupSettingsChannelDescription =>
      'การแจ้งเตือนที่อธิบายการสำรองข้อมูลอัตโนมัติ';

  @override
  String get backupChannelName => 'ช่องการสำรองข้อมูล';

  @override
  String get backupChannelDescription =>
      'การสำรองข้อมูลและรูปภาพของ Flexify โดยอัตโนมัติ';

  @override
  String get backupCompletedTitle => 'สำรองข้อมูลและรูปภาพแล้ว';

  @override
  String get backupFailurePathNotSet =>
      'สำรองข้อมูลไม่สำเร็จ: ยังไม่ได้ตั้งค่าตำแหน่งสำรองข้อมูล ปิดการสำรองข้อมูลอัตโนมัติแล้ว';

  @override
  String get backupFailureDirectoryUnavailable =>
      'สำรองข้อมูลไม่สำเร็จ: ไม่สามารถเข้าถึงโฟลเดอร์สำรองข้อมูลได้ ปิดการสำรองข้อมูลอัตโนมัติแล้ว';

  @override
  String get backupFailureCreateFile =>
      'สำรองข้อมูลไม่สำเร็จ: ไม่สามารถสร้างไฟล์สำรองข้อมูลได้ ปิดการสำรองข้อมูลอัตโนมัติแล้ว';

  @override
  String get backupFailureAppFilesUnavailable =>
      'สำรองข้อมูลไม่สำเร็จ: ไม่สามารถเข้าถึงโฟลเดอร์ไฟล์ของแอปได้ ปิดการสำรองข้อมูลอัตโนมัติแล้ว';

  @override
  String get backupFailureDatabaseMissing =>
      'สำรองข้อมูลไม่สำเร็จ: ไม่พบไฟล์ฐานข้อมูล ปิดการสำรองข้อมูลอัตโนมัติแล้ว';

  @override
  String get backupFailureOutputUnavailable =>
      'สำรองข้อมูลไม่สำเร็จ: ไม่สามารถเปิดสตรีมเอาต์พุตได้ ปิดการสำรองข้อมูลอัตโนมัติแล้ว';

  @override
  String get backupFailureUnknown =>
      'สำรองข้อมูลไม่สำเร็จ ปิดการสำรองข้อมูลอัตโนมัติแล้ว';

  @override
  String get appPermissionsDescription =>
      'ตรวจสอบสิทธิ์การเข้าถึงที่ฟีเจอร์ที่คุณเปิดใช้งานต้องใช้';

  @override
  String get longDateFormatDescription => 'ใช้ในพื้นที่ที่มีเนื้อที่เพียงพอ';

  @override
  String shortDateFormat(String example) {
    return 'รูปแบบวันที่แบบสั้น ($example)';
  }

  @override
  String get shortDateFormatDescription => 'ใช้ในพื้นที่จำกัด (เส้นกราฟ)';

  @override
  String get warmupSetsDescription => 'เซ็ตวอร์มอัปจะไม่มีตัวจับเวลาพัก';

  @override
  String get setsPerExerciseDescription => 'จำนวนการออกกำลังกายเริ่มต้นในแผน';

  @override
  String get planTrailingDisplay => 'ข้อมูลท้ายรายการแผน';

  @override
  String get planTrailingDisplayDescription =>
      'ข้อมูลที่แสดงด้านขวาของรายการในหน้าแผนและมุมมองแผน';

  @override
  String get restTimersDescription => 'เสียงปลุกที่ดังหลังจากทำเซ็ตเสร็จ';

  @override
  String get vibrateDescription => 'ให้ตัวจับเวลาพักสั่นหรือไม่?';

  @override
  String get enableSoundDescription => 'ให้ตัวจับเวลาพักเล่นเสียงหรือไม่?';

  @override
  String get keepScreenOnDescription => 'เปิดหน้าจอค้างไว้ระหว่างตัวจับเวลาพัก';

  @override
  String get restDurationDescription => 'ระยะเวลาก่อนที่เสียงปลุกพักจะดัง';

  @override
  String get globalDefault => 'ค่าเริ่มต้นส่วนกลาง';

  @override
  String get alarmSoundDescription => 'เพลงที่จะเล่นเมื่อตัวจับเวลาพักสิ้นสุด';

  @override
  String get progressBarPosition => 'ตำแหน่งแถบความคืบหน้า';

  @override
  String get progressBarPositionDescription =>
      'ควรวางแถบความคืบหน้าของตัวจับเวลาพักไว้ที่ใด?';

  @override
  String get perExerciseRestTimes => 'เวลาพักแยกตามการออกกำลังกาย';

  @override
  String get perExerciseRestTimesDescription =>
      'การออกกำลังกายเหล่านี้มีระยะเวลาพักที่กำหนดเอง';

  @override
  String get audioFeaturesUnavailable => 'ไม่สามารถใช้ฟีเจอร์เสียงได้';

  @override
  String get groupHistoryDescription => 'รวมรายการประวัติตามวัน';

  @override
  String get showUnitsDescription =>
      'แสดง km/mi, kg/lb สำหรับกราฟ ประวัติ และแผน';

  @override
  String get showBodyWeightDescription => 'เปิดหรือปิดการติดตามน้ำหนักตัว';

  @override
  String get showCategoriesDescription => 'เปิดหรือปิดหมวดหมู่การออกกำลังกาย';

  @override
  String get showNotesDescription => 'บันทึกรายละเอียดการยกของคุณในช่องข้อความ';

  @override
  String get positiveNotificationsDescription =>
      'แสดงข้อความให้กำลังใจเมื่อทำสถิติใหม่';

  @override
  String get positiveMessagesEnabled => 'ตอนนี้ข้อความให้กำลังใจจะแสดงแบบนี้!';

  @override
  String get recordEncouragement01 => 'เยี่ยมมาก! คุณสุดยอดจริง ๆ';

  @override
  String get recordEncouragement02 =>
      'เยี่ยมเลยราชา! ความก้าวหน้าของคุณน่าทึ่งมาก';

  @override
  String get recordEncouragement03 => 'ข้าขอคารวะ...';

  @override
  String get recordEncouragement04 => 'นั่นอะไรน่ะ? สถิติใหม่!';

  @override
  String get recordEncouragement05 => 'สุดยอดมาก! คุณเป็นแรงบันดาลใจจริง ๆ';

  @override
  String get recordEncouragement06 => 'ว้าว เยี่ยมเลย';

  @override
  String get recordEncouragement07 => 'แข็งแรงขึ้นมากเลยใช่ไหม?';

  @override
  String get recordEncouragement08 => 'ใช่เลย คุณตัวใหญ่ไม่เบานะ';

  @override
  String get recordEncouragement09 => 'ยอดเยี่ยม เหลือเชื่อ';

  @override
  String get recordEncouragement10 => 'อาร์นี่ต้องภูมิใจแน่';

  @override
  String get recordEncouragement11 => 'รอนนี่ ซี คงมองคุณด้วยความปลื้มใจ';

  @override
  String get recordEncouragement12 => 'เย้! เบา ๆ เองพวก!!!!!!!';

  @override
  String get recordEncouragement13 =>
      'นั่นสถิติใหม่หรือเปล่า? รู้อยู่แล้วว่าคุณทำได้';

  @override
  String get recordEncouragement14 => 'เยี่ยมมาก! ภูมิใจในตัวคุณนะ';

  @override
  String get recordEncouragement15 => 'เย้! เบา ๆ เอง!';

  @override
  String get recordEncouragement16 => 'ทำต่อไป! ก้าวหน้าได้ดีมาก';

  @override
  String get recordEncouragement17 => 'คุณทำได้ดีมากเลย';

  @override
  String get recordEncouragement18 => 'นั่นแหละคนเก่ง!';

  @override
  String get recordEncouragement19 => 'ทำต่อไป';

  @override
  String get recordEncouragement20 => 'คุณแข็งแรงขึ้นมาก';

  @override
  String get recordEncouragement21 => 'ทรงพลัง';

  @override
  String get recordEncouragement22 => 'พลังสุดยอด!';

  @override
  String get recordEncouragement23 => 'ภูมิใจในตัวคุณนะ';

  @override
  String get recordEncouragement24 => 'รักษาผลงานดี ๆ แบบนี้ต่อไป';

  @override
  String get recordEncouragement25 => 'ยืดอกไว้! คุณเพิ่งทำสถิติใหม่';

  @override
  String get recordEncouragement26 => 'สถิติใหม่! คุณไปได้ไกลกว่าที่เคย!';

  @override
  String get recordEncouragement27 => 'ใช่เลย! นั่นคือสถิติใหม่';

  @override
  String get recordEncouragement28 => 'ว้าว! สถิติใหม่!';

  @override
  String get recordEncouragement29 => 'ดีมากเลย';

  @override
  String get repEstimationDescription => 'ลองคาดเดาจำนวนครั้งที่คุณเพิ่งทำไป';

  @override
  String get durationEstimationDescription => 'ลองคาดเดาระยะเวลาคาร์ดิโอของคุณ';

  @override
  String get showGraphXAxisToggle => 'แสดงสวิตช์แกน X ของกราฟ';

  @override
  String get showGraphXAxisToggleDescription =>
      'แสดงสวิตช์แกน X แบบอิงเวลาในกราฟ';

  @override
  String get showGraphLimitDescription => 'แสดงแถบเลื่อนขีดจำกัดในกราฟ';

  @override
  String get defaultTimeBasedXAxis => 'ใช้แกน X แบบอิงเวลาเป็นค่าเริ่มต้น';

  @override
  String get defaultTimeBasedXAxisDescription =>
      'ใช้แกน X แบบอิงเวลาเป็นค่าเริ่มต้นในกราฟ';

  @override
  String get createFirstTrainingPlan => 'สร้างแผนการฝึกแรกของคุณเพื่อเริ่มต้น';

  @override
  String nothingMatchesPlanSearch(String query) {
    return 'ไม่มีรายการที่ตรงกับ “$query” คุณสามารถสร้างเป็นแผนใหม่ได้';
  }

  @override
  String get createPlan => 'สร้างแผน';

  @override
  String createNamedPlan(String name) {
    return 'สร้าง “$name”';
  }

  @override
  String setNumber(int number) {
    return 'เซ็ต $number';
  }
}
