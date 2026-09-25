// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get settingsLanguageDescription =>
      'Chọn ngôn ngữ được Flexify sử dụng';

  @override
  String get languageSystemDefault => 'Mặc định hệ thống';

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
  String get navHistory => 'Lịch sử';

  @override
  String get navPlans => 'Kế hoạch';

  @override
  String get navGraphs => 'Đồ thị';

  @override
  String get navTimer => 'Hẹn giờ';

  @override
  String get navSettings => 'Cài đặt';

  @override
  String get errorLabel => 'Lỗi';

  @override
  String get tabContentError => 'Không thể xây dựng nội dung tab.';

  @override
  String get cannotHideAllTabs => 'Không thể che giấu mọi thứ!';

  @override
  String removeTabQuestion(String tab) {
    return 'Xóa tab $tab?';
  }

  @override
  String get restoreTabFromSettings => 'Bạn có thể thêm lại nó sau từ cài đặt.';

  @override
  String removedTab(String tab) {
    return 'Đã xóa $tab';
  }

  @override
  String newVersion(String version) {
    return 'Phiên bản mới $version';
  }

  @override
  String get changes => 'Thay đổi';

  @override
  String get searchHint => 'Tìm kiếm...';

  @override
  String get deleteSelected => 'Xóa đã chọn';

  @override
  String get confirmDelete => 'Xác nhận Xóa';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Bạn có chắc chắn muốn xóa $count bản ghi không? Thao tác này không thể hoàn tác.',
      one:
          'Bạn có chắc chắn muốn xóa 1 bản ghi không? Thao tác này không thể hoàn tác.',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'Hủy bỏ';

  @override
  String get actionDelete => 'Xóa bỏ';

  @override
  String get actionRemove => 'Di dời';

  @override
  String get actionEdit => 'Biên tập';

  @override
  String get actionShare => 'Chia sẻ';

  @override
  String get clearSelection => 'Xóa lựa chọn';

  @override
  String get clearSearch => 'Xóa tìm kiếm';

  @override
  String get showMenu => 'Hiển thị thực đơn';

  @override
  String get selectAll => 'Chọn tất cả';

  @override
  String get weightLabel => 'Cân nặng';

  @override
  String get filter => 'Lọc';

  @override
  String get filters => 'Bộ lọc';

  @override
  String get categoryLabel => 'Loại';

  @override
  String get repsLabel => 'Lần lặp';

  @override
  String get repsFilter => 'Lọc số lần lặp';

  @override
  String get weightFilter => 'Bộ lọc trọng lượng';

  @override
  String get greaterThan => 'Lớn hơn';

  @override
  String get lessThan => 'Ít hơn';

  @override
  String get startDate => 'Ngày bắt đầu';

  @override
  String get endDate => 'Ngày kết thúc';

  @override
  String get actionClear => 'Thông thoáng';

  @override
  String get actionOk => 'ĐƯỢC RỒI';

  @override
  String get actionClose => 'Đóng';

  @override
  String get sortBy => 'Sắp xếp theo';

  @override
  String get dateNewest => 'Ngày (mới nhất)';

  @override
  String get dateOldest => 'Ngày (cũ nhất)';

  @override
  String get nameLabel => 'Tên';

  @override
  String get missingPermissions => 'Thiếu quyền';

  @override
  String get restTimersPermissionsMissing =>
      'Bộ hẹn giờ nghỉ ngơi đang bật nhưng thiếu quyền.';

  @override
  String get restTimersPermissionsOptional =>
      'Nếu bạn tắt tính năng hẹn giờ nghỉ ngơi thì những quyền này sẽ không cần thiết.';

  @override
  String get restTimers => 'Hẹn giờ nghỉ ngơi';

  @override
  String get disableBatteryOptimizations => 'Vô hiệu hóa tối ưu hóa pin';

  @override
  String get batteryOptimizationWarning =>
      'Tiến trình có thể tạm dừng nếu tối ưu hóa pin vẫn tiếp tục.';

  @override
  String get scheduleExactAlarm => 'Lên lịch báo động chính xác';

  @override
  String get exactAlarmWarning =>
      'Cảnh báo không thể chính xác nếu tính năng này bị tắt.';

  @override
  String get postNotifications => 'Đăng thông báo';

  @override
  String get notificationBarDescription =>
      'Tiến trình hẹn giờ được gửi đến thanh thông báo';

  @override
  String get invalidPermissions => 'Quyền không hợp lệ';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      'Bộ hẹn giờ nghỉ ngơi được bật mà không có đủ quyền. Bạn có chắc không?';

  @override
  String get actionConfirm => 'Xác nhận';

  @override
  String get appAccess => 'Quyền truy cập ứng dụng';

  @override
  String get appAccessDescription => 'Cần thiết để bật tính giờ và thông báo.';

  @override
  String get notifications => 'Thông báo';

  @override
  String get timerProgressAndRestAlerts =>
      'Tiến trình hẹn giờ và cảnh báo nghỉ ngơi';

  @override
  String get enabledNotificationsDescription => 'Thông báo bạn đã bật';

  @override
  String get backgroundActivity => 'Hoạt động nền';

  @override
  String get backgroundActivityDescription =>
      'Giữ bộ hẹn giờ đáng tin cậy ở chế độ nền';

  @override
  String get exactAlarms => 'Báo động chính xác';

  @override
  String get exactAlarmsDescription => 'Cảnh báo chính xác khi hết giờ nghỉ';

  @override
  String get noAdditionalAndroidAccessNeeded =>
      'Không cần quyền truy cập Android bổ sung cho cài đặt hiện tại của bạn.';

  @override
  String get actionDone => 'Xong';

  @override
  String get allowed => 'Cho phép';

  @override
  String get actionAllow => 'Cho phép';

  @override
  String get backupLabel => 'Hỗ trợ';

  @override
  String get databaseLabel => 'Cơ sở dữ liệu';

  @override
  String get deleteRecords => 'Xóa bản ghi';

  @override
  String get deleteAllGraphsConfirmation =>
      'Bạn có chắc chắn muốn xóa tất cả các biểu đồ không? Hành động này không thể đảo ngược.';

  @override
  String get deleteAllPlansConfirmation =>
      'Bạn có chắc chắn muốn xóa tất cả kế hoạch không? Thao tác này không thể hoàn tác.';

  @override
  String get deleteDatabaseConfirmation =>
      'Bạn có chắc chắn muốn xóa cơ sở dữ liệu của mình không? Hành động này không thể đảo ngược và sẽ hủy tất cả dữ liệu của bạn.';

  @override
  String get importData => 'Nhập dữ liệu';

  @override
  String get exportData => 'Xuất dữ liệu';

  @override
  String get actionReport => 'Báo cáo';

  @override
  String get graphDataImported => 'Dữ liệu đồ thị đã được nhập thành công!';

  @override
  String get plansImported => 'Kế hoạch đã được nhập thành công';

  @override
  String failedToImportDatabase(String error) {
    return 'Không thể nhập cơ sở dữ liệu: $error';
  }

  @override
  String get backupArchiveMissingDatabase =>
      'Kho lưu trữ sao lưu không chứa cơ sở dữ liệu Flexify.';

  @override
  String failedToImportGraphs(String error) {
    return 'Không thể nhập biểu đồ: $error';
  }

  @override
  String failedToImportPlans(String error) {
    return 'Không thể nhập kế hoạch: $error';
  }

  @override
  String get selectedFileDoesNotExist => 'Tệp đã chọn không tồn tại';

  @override
  String get couldNotReadFileData => 'Không thể đọc dữ liệu tập tin';

  @override
  String get databaseImportWebUnsupported =>
      'Nhập cơ sở dữ liệu trên web yêu cầu di chuyển dữ liệu thủ công. Vui lòng xuất dữ liệu của bạn dưới dạng tệp CSV và nhập chúng thay thế.';

  @override
  String get csvFileEmpty => 'Tệp CSV trống';

  @override
  String get csvNeedsDataRow => 'Tệp CSV phải chứa ít nhất một hàng dữ liệu';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return 'Hàng $row không đủ cột: $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return 'Giá trị $field không hợp lệ trong hàng $row: $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return 'Kiểu dữ liệu $field không hợp lệ trong hàng $row: $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return 'ID kế hoạch phải là số nguyên, nhận được \"$value\"';
  }

  @override
  String get unitLabel => 'Đơn vị';

  @override
  String get kilogramsUnit => 'Kilôgam (kg)';

  @override
  String get poundsUnit => 'Pound (lb)';

  @override
  String get stoneUnit => 'Stone';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => 'Km (km)';

  @override
  String get milesUnit => 'Dặm (mi)';

  @override
  String get metersUnit => 'Mét (m)';

  @override
  String get kilocaloriesUnit => 'Calo (kcal)';

  @override
  String get enterWeight => 'Nhập trọng lượng';

  @override
  String get requiredField => 'Yêu cầu';

  @override
  String get invalidNumber => 'Số không hợp lệ';

  @override
  String get previousWeight => 'Cân nặng trước đây';

  @override
  String get imageLabel => 'Hình ảnh';

  @override
  String get longPressToDelete => 'Nhấn và giữ để xóa';

  @override
  String get imageError => 'Lỗi hình ảnh';

  @override
  String get actionSave => 'Cứu';

  @override
  String get aboutTitle => 'Về';

  @override
  String get donate => 'Quyên tặng';

  @override
  String get helpSupportProject => 'Giúp hỗ trợ dự án này';

  @override
  String get whatsNewAbout => 'Có gì mới?';

  @override
  String get whatsNewTitle => 'Có gì mới?';

  @override
  String get seeReleaseNotes => 'Xem ghi chú phát hành của chúng tôi';

  @override
  String get versionLabel => 'Phiên bản';

  @override
  String get authorLabel => 'Tác giả';

  @override
  String get privacyPolicy => 'Chính sách bảo mật';

  @override
  String get privacyPolicyDescription => 'Cách Flexify xử lý dữ liệu của bạn';

  @override
  String get licenseLabel => 'Giấy phép';

  @override
  String get sourceCode => 'Mã nguồn';

  @override
  String get sourceCodeDescription => 'Hãy kiểm tra nó trên GitHub';

  @override
  String get leaveReview => 'Để lại đánh giá';

  @override
  String get leaveReviewDescription => 'Xếp hạng Flexify trên Cửa hàng Play';

  @override
  String get reportBug => 'Báo cáo lỗi';

  @override
  String get reportBugDescription => 'Mở một issue trên GitHub';

  @override
  String get failedMigrations => 'Di chuyển không thành công';

  @override
  String get errorMessageLabel => 'Thông báo lỗi:';

  @override
  String get createIssue => 'Tạo vấn đề';

  @override
  String get addExercise => 'Thêm bài tập';

  @override
  String get cardio => 'tim mạch';

  @override
  String get strength => 'Sức mạnh';

  @override
  String get options => 'Tùy chọn';

  @override
  String get periodDay => 'Ngày';

  @override
  String get periodWeek => 'Tuần';

  @override
  String get periodMonth => 'Tháng';

  @override
  String get periodYear => 'Năm';

  @override
  String noDataFor(String name) {
    return 'Chưa có dữ liệu cho $name';
  }

  @override
  String get noDataYet => 'Chưa có dữ liệu';

  @override
  String get exerciseNotes => 'Ghi chú bài tập';

  @override
  String get notesForExercise => 'Lưu ý cho bài tập này';

  @override
  String get useTimeBasedXAxis => 'Sử dụng trục X dựa trên thời gian';

  @override
  String updateAllNamed(String name) {
    return 'Cập nhật tất cả $name';
  }

  @override
  String get newName => 'Tên mới';

  @override
  String get restMinutes => 'Phút nghỉ ngơi';

  @override
  String get restSeconds => 'Giây nghỉ ngơi';

  @override
  String get globalProgress => 'Tiến bộ toàn cầu';

  @override
  String get curveLineGraphs => 'Đồ thị đường cong';

  @override
  String get curveLineGraphsDescription =>
      'Vẽ các đường biểu đồ dưới dạng đường cong mượt mà';

  @override
  String noHistoryFor(String name) {
    return 'Chưa có lịch sử nào cho $name';
  }

  @override
  String get cancelSelection => 'Hủy lựa chọn';

  @override
  String get editSelected => 'Đã chọn chỉnh sửa';

  @override
  String get newExercise => 'Bài tập mới';

  @override
  String get noGraphsFound => 'Không tìm thấy biểu đồ nào';

  @override
  String get searchGraphs => 'Tìm kiếm biểu đồ...';

  @override
  String get actionAdd => 'Thêm vào';

  @override
  String get actionUpdate => 'Cập nhật';

  @override
  String get hideGlobalProgress => 'Ẩn tiến trình toàn cầu';

  @override
  String get chartGroupedByCategory => 'Biểu đồ được nhóm theo danh mục';

  @override
  String get noExercisesFound => 'Không tìm thấy bài tập nào';

  @override
  String get savePlan => 'Lưu kế hoạch';

  @override
  String get titleOptional => 'Tiêu đề (tùy chọn)';

  @override
  String get searchExercises => 'Tìm kiếm bài tập...';

  @override
  String get warmupSets => 'Hiệp khởi động';

  @override
  String get workingSetsMax => 'Hiệp tập chính (tối đa: 20)';

  @override
  String get actionUndo => 'Hoàn tác';

  @override
  String get actionSwap => 'Tráo đổi';

  @override
  String get daily => 'Hằng ngày';

  @override
  String get weekly => 'hàng tuần';

  @override
  String get monthly => 'hàng tháng';

  @override
  String get yearly => 'Hàng năm';

  @override
  String get unexpectedError => 'Đã xảy ra lỗi. Vui lòng thử lại.';

  @override
  String get loadingExercises => 'Đang tải bài tập...';

  @override
  String get noPlansYet => 'Chưa có kế hoạch nào';

  @override
  String get noMatchingPlans => 'Không có kế hoạch phù hợp';

  @override
  String get newPlan => 'Kế hoạch mới';

  @override
  String get searchPlans => 'Tìm kiếm kế hoạch...';

  @override
  String get noExercisesYet => 'Chưa có bài tập nào';

  @override
  String get editPlan => 'Chỉnh sửa kế hoạch';

  @override
  String get saveSet => 'Lưu hiệp';

  @override
  String get minutesLabel => 'Phút';

  @override
  String get minutesShort => 'phút';

  @override
  String get secondsLabel => 'Giây';

  @override
  String get distanceLabel => 'Khoảng cách';

  @override
  String get inclinePercent => 'Nghiêng %';

  @override
  String weightWithUnit(String unit) {
    return 'Trọng lượng ($unit)';
  }

  @override
  String get useBodyWeight => 'Sử dụng trọng lượng cơ thể';

  @override
  String get noWeightEnteredYet => 'Chưa nhập cân nặng';

  @override
  String get notesLabel => 'Ghi chú';

  @override
  String get swapWorkout => 'Đổi buổi tập';

  @override
  String get addSet => 'Thêm hiệp';

  @override
  String get deleteSet => 'Xóa hiệp';

  @override
  String get oneRepMaxEstimate => '1RM (ước tính)';

  @override
  String get valueLabel => 'Giá trị';

  @override
  String amountWithUnit(String unit) {
    return 'Số lượng ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return 'Khoảng cách ($unit)';
  }

  @override
  String get bodyWeightLabel => 'Trọng lượng cơ thể';

  @override
  String bodyWeightWithUnit(String unit) {
    return 'Trọng lượng cơ thể ($unit)';
  }

  @override
  String get categoryHelper =>
      'Chọn một danh mục hiện có hoặc nhập một danh mục mới.';

  @override
  String get manageCategories => 'Quản lý danh mục';

  @override
  String get manageCategoriesDescription =>
      'Tạo, đổi tên, hợp nhất hoặc xóa danh mục';

  @override
  String get newCategory => 'Danh mục mới';

  @override
  String get renameCategory => 'Đổi tên danh mục';

  @override
  String get mergeCategory => 'Hợp nhất vào một danh mục khác';

  @override
  String get noCategories => 'Chưa có danh mục nào';

  @override
  String get categoryNameRequired => 'Nhập tên danh mục';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Được $count mục sử dụng',
      one: 'Được 1 mục sử dụng',
      zero: 'Không được mục nào sử dụng',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Xóa danh mục này và xóa nó khỏi $count mục?',
      one: 'Xóa danh mục này và xóa nó khỏi 1 mục?',
      zero: 'Xóa danh mục này?',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => 'Ngày tạo';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chỉnh sửa $count hiệp',
      one: 'Chỉnh sửa 1 hiệp',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => 'Chưa có mục nào';

  @override
  String get historyEmptyMessage =>
      'Hoàn thành một hiệp hoặc thêm thủ công để bắt đầu lịch sử.';

  @override
  String deleteSetConfirmation(String name) {
    return 'Bạn có chắc chắn muốn xóa $name không?';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bạn có chắc chắn muốn xóa $count mục không?',
      one: 'Bạn có chắc chắn muốn xóa 1 mục không?',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => 'Lịch sử tìm kiếm...';

  @override
  String get themeSystem => 'Hệ thống';

  @override
  String get themeDark => 'Tối tăm';

  @override
  String get themeLight => 'Ánh sáng';

  @override
  String get pureBlackAmoled => 'Màu đen tuyền (AMOLED)';

  @override
  String get showImages => 'Hiển thị hình ảnh';

  @override
  String get peekGraph => 'Biểu đồ nhìn trộm';

  @override
  String get inputStyleLine => 'Đường kẻ';

  @override
  String get inputStyleOutlined => 'phác thảo';

  @override
  String get inputStyleFilled => 'Điền';

  @override
  String get inputStyle => 'Kiểu nhập';

  @override
  String get appearance => 'Vẻ bề ngoài';

  @override
  String get automaticBackupsEnabled => 'Đã bật sao lưu tự động';

  @override
  String get automaticBackup => 'Tự động sao lưu';

  @override
  String get appPermissions => 'Quyền ứng dụng';

  @override
  String get shareDatabase => 'Chia sẻ cơ sở dữ liệu';

  @override
  String get dataManagement => 'Quản lý dữ liệu';

  @override
  String get strengthUnit => 'Đơn vị sức mạnh';

  @override
  String get lastEntry => 'Mục nhập cuối cùng';

  @override
  String get cardioUnit => 'Đơn vị tim mạch';

  @override
  String longDateFormat(String format) {
    return 'Định dạng ngày dài ($format)';
  }

  @override
  String get formats => 'Định dạng';

  @override
  String get setsPerExerciseMax => 'Số hiệp cho mỗi bài tập (tối đa: 20)';

  @override
  String get countLabel => 'Đếm';

  @override
  String get ratioLabel => 'Tỷ lệ';

  @override
  String get reorder => 'Sắp xếp lại';

  @override
  String get none => 'Không có';

  @override
  String get monday => 'Thứ hai';

  @override
  String get examplePlanExercises => 'Bench Press, Squat, Deadlift';

  @override
  String get tabs => 'Tab';

  @override
  String get swipeBetweenTabs => 'Vuốt giữa các tab';

  @override
  String get vibrate => 'Rung';

  @override
  String get enableSound => 'Bật âm thanh';

  @override
  String get keepScreenOn => 'Giữ màn hình luôn bật';

  @override
  String get alarmSound => 'Âm thanh báo động';

  @override
  String get top => 'Đứng đầu';

  @override
  String get bottom => 'Đáy';

  @override
  String get removeCustomTimer =>
      'Xóa bộ hẹn giờ tùy chỉnh (sử dụng mặc định chung)';

  @override
  String get timers => 'Bộ hẹn giờ';

  @override
  String get timerSettings => 'Cài đặt hẹn giờ';

  @override
  String get groupHistory => 'Lịch sử nhóm';

  @override
  String get showUnits => 'Hiển thị đơn vị';

  @override
  String get showBodyWeight => 'Hiển thị trọng lượng cơ thể';

  @override
  String get showCategories => 'Hiển thị danh mục';

  @override
  String get showNotes => 'Hiển thị ghi chú';

  @override
  String get repEstimation => 'Ước tính số lần lặp';

  @override
  String get durationEstimation => 'Ước tính thời lượng';

  @override
  String get showGraphLimit => 'Hiển thị giới hạn biểu đồ';

  @override
  String get defaultGraphMetric => 'Chỉ số biểu đồ mặc định';

  @override
  String get bestWeight => 'Trọng lượng tốt nhất';

  @override
  String get bestReps => 'Số lần lặp tốt nhất';

  @override
  String get oneRepMax => '1RM';

  @override
  String get volume => 'Khối lượng tập';

  @override
  String get paceCardio => 'Nhịp độ (tim mạch)';

  @override
  String get distanceCardio => 'Khoảng cách (tim mạch)';

  @override
  String get defaultGraphPeriod => 'Khoảng thời gian biểu đồ mặc định';

  @override
  String get defaultGraphLimit => 'Giới hạn biểu đồ mặc định';

  @override
  String get workouts => 'Buổi tập';

  @override
  String get actionStop => 'Dừng lại';

  @override
  String get timerFinishedToast => 'Đã hết giờ!';

  @override
  String get stopTimer => 'Dừng hẹn giờ';

  @override
  String get actionPause => 'Tạm dừng';

  @override
  String get startStopwatch => 'Bắt đầu đồng hồ bấm giờ';

  @override
  String get actionStart => 'Bắt đầu';

  @override
  String get actionRestart => 'Khởi động lại';

  @override
  String get addOneMinute => '+1 phút';

  @override
  String get addOneMinuteNotification => 'Thêm 1 phút';

  @override
  String get restTimer => 'Hẹn giờ nghỉ ngơi';

  @override
  String get timerUp => 'Hẹn giờ lên';

  @override
  String get openNotification => 'Mở thông báo';

  @override
  String get timerChannelName => 'Kênh hẹn giờ';

  @override
  String get timerChannelDescription =>
      'Tiến trình liên tục của bộ tính giờ nghỉ ngơi.';

  @override
  String get timerFinishedChannelName => 'Kênh hẹn giờ đã kết thúc';

  @override
  String get timerFinishedChannelDescription =>
      'Phát báo thức khi hết giờ nghỉ.';

  @override
  String get timerFinished => 'Đã hết giờ';

  @override
  String get batteryOptimizationRequestUnavailable =>
      'Yêu cầu bỏ qua tối ưu hóa pin bị tắt trên thiết bị của bạn.';

  @override
  String get exactAlarmRequestUnavailable =>
      'Yêu cầu SCHEDULE_EXACT_ALARM bị từ chối trên thiết bị của bạn';

  @override
  String get databaseMigrationFailureDescription =>
      'Đã xảy ra lỗi khi tạo/nâng cấp cơ sở dữ liệu của bạn. Thông thường điều này có thể được khắc phục bằng cách xóa và tạo lại hồ sơ của bạn.';

  @override
  String get curveSmoothness => 'Độ mịn của đường cong';

  @override
  String get actionBack => 'Mặt sau';

  @override
  String get atLeastOneTab => 'Bạn cần ít nhất một tab';

  @override
  String get invalidTabSettings => 'Cài đặt tab không hợp lệ.';

  @override
  String get noSettingsFound => 'Không tìm thấy cài đặt nào';

  @override
  String nothingMatchesSearch(String query) {
    return 'Không có gì khớp với “$query”.';
  }

  @override
  String get appearanceDescription => 'Chủ đề, màu sắc và kiểu dáng giao diện';

  @override
  String get dataManagementDescription =>
      'Nhập, xuất và quản lý dữ liệu tập luyện của bạn';

  @override
  String get formatsDescription => 'Ngày, số và định dạng đo lường';

  @override
  String get plansSettingsDescription =>
      'Mặc định và hành vi cho kế hoạch tập luyện';

  @override
  String get tabsDescription => 'Chọn và sắp xếp các tab điều hướng chính';

  @override
  String get timersDescription =>
      'Thời lượng, âm thanh và hành vi của bộ hẹn giờ nghỉ ngơi';

  @override
  String get workoutsDescription => 'Theo dõi bài tập và sở thích tập luyện';

  @override
  String get completeSetForChart =>
      'Hoàn thành một hiệp cho bài tập này để tạo biểu đồ.';

  @override
  String get dateRange => 'Phạm vi ngày';

  @override
  String get stopDate => 'Ngày dừng';

  @override
  String get dataPoints => 'Điểm dữ liệu';

  @override
  String get completeSetsForProgress =>
      'Hoàn thành một vài hiệp để tạo biểu đồ tiến trình.';

  @override
  String get relativeStrength => 'Sức mạnh tương đối';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã chọn $count',
      one: 'Đã chọn 1',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory =>
      'Hoàn thành một vài hiệp để xem lịch sử bài tập tại đây.';

  @override
  String get completeSetForFirstGraph =>
      'Hoàn thành một hiệp để tạo biểu đồ bài tập đầu tiên.';

  @override
  String nothingMatchesGraphSearch(String query) {
    return 'Không có gì khớp với “$query”. Bạn có thể tạo nó như một bài tập mới.';
  }

  @override
  String addNamed(String name) {
    return 'Thêm “$name”';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return 'Thao tác này sẽ xóa bản ghi $count. Bạn có chắc không?';
  }

  @override
  String shareWorkout(String summary) {
    return 'Tôi vừa làm $summary';
  }

  @override
  String get updateConflict => 'Cập nhật xung đột';

  @override
  String updateConflictDescription(int count) {
    return 'Tên mới của bạn đã tồn tại trong bản ghi $count. Bạn có chắc không?';
  }

  @override
  String get unitsConflict => 'Xung đột đơn vị';

  @override
  String unitsConflictDescription(String unit) {
    return 'Không phải tất cả hồ sơ của bạn đều có cùng đơn vị. Điều này sẽ chuyển đổi tất cả các đơn vị thành $unit. Bạn có chắc không?';
  }

  @override
  String get durationLabel => 'Khoảng thời gian';

  @override
  String get inclineLabel => 'Nghiêng';

  @override
  String get paceDistanceTime => 'Tốc độ (quãng đường/thời gian)';

  @override
  String get adjustedPace => 'Nhịp độ điều chỉnh';

  @override
  String get oneRepMaxAccuracyWarning =>
      'Ước tính 1RM kém chính xác hơn với các hiệp từ 10 lần lặp trở lên';

  @override
  String get addPlan => 'Thêm kế hoạch';

  @override
  String get planDetails => 'Chi tiết kế hoạch';

  @override
  String get exercisesLabel => 'Bài tập';

  @override
  String get addExerciseToPlan => 'Thêm một bài tập vào kế hoạch này.';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return 'Không có gì khớp với “$query”. Bạn có thể thêm nó như một bài tập mới.';
  }

  @override
  String get selectDays => 'Chọn ngày';

  @override
  String get selectExercises => 'Chọn bài tập';

  @override
  String get todayLabel => 'Hôm nay';

  @override
  String get setDetails => 'Chi tiết hiệp';

  @override
  String get themeLabel => 'chủ đề';

  @override
  String get pureBlackAmoledDescription =>
      'Sử dụng màu đen tuyền cho màn hình AMOLED';

  @override
  String get systemColorScheme => 'Bảng màu hệ thống';

  @override
  String get systemColorSchemeDescription =>
      'Sử dụng màu chính của thiết bị cho ứng dụng';

  @override
  String get showImagesDescription =>
      'Chọn/hiển thị hình ảnh trên trang lịch sử';

  @override
  String get showGlobalProgress => 'Hiển thị tiến bộ toàn cầu';

  @override
  String get showGlobalProgressDescription =>
      'Thêm mục nhập biểu đồ biểu đồ tiến trình của bạn theo danh mục';

  @override
  String get peekGraphDescription =>
      'Hiển thị biểu đồ dòng đầu tiên trên trang biểu đồ';

  @override
  String get inputStyleDescription => 'Kiểu trực quan của trường nhập văn bản';

  @override
  String get automaticBackupNotificationBody =>
      'Flexify sẽ tự động sao lưu dữ liệu và hình ảnh của bạn vào thư mục đã chọn mỗi ngày.';

  @override
  String get backupSettingsChannel => 'Cài đặt sao lưu';

  @override
  String get backupSettingsChannelDescription =>
      'Thông báo giải thích sao lưu tự động';

  @override
  String get backupChannelName => 'Kênh dự phòng';

  @override
  String get backupChannelDescription =>
      'Tự động sao lưu dữ liệu và hình ảnh Flexify';

  @override
  String get backupCompletedTitle => 'Sao lưu dữ liệu và hình ảnh';

  @override
  String get backupFailurePathNotSet =>
      'Sao lưu không thành công: đường dẫn sao lưu chưa được đặt. Sao lưu tự động bị vô hiệu hóa.';

  @override
  String get backupFailureDirectoryUnavailable =>
      'Sao lưu không thành công: không thể truy cập thư mục sao lưu. Sao lưu tự động bị vô hiệu hóa.';

  @override
  String get backupFailureCreateFile =>
      'Sao lưu không thành công: không thể tạo tập tin sao lưu. Sao lưu tự động bị vô hiệu hóa.';

  @override
  String get backupFailureAppFilesUnavailable =>
      'Sao lưu không thành công: không thể truy cập thư mục tệp ứng dụng. Sao lưu tự động bị vô hiệu hóa.';

  @override
  String get backupFailureDatabaseMissing =>
      'Sao lưu không thành công: không tìm thấy tệp cơ sở dữ liệu. Sao lưu tự động bị vô hiệu hóa.';

  @override
  String get backupFailureOutputUnavailable =>
      'Sao lưu không thành công: không thể mở luồng đầu ra. Sao lưu tự động bị vô hiệu hóa.';

  @override
  String get backupFailureUnknown =>
      'Sao lưu không thành công. Sao lưu tự động bị vô hiệu hóa.';

  @override
  String get appPermissionsDescription =>
      'Xem lại quyền truy cập mà các tính năng đã bật của bạn yêu cầu';

  @override
  String get longDateFormatDescription =>
      'Được sử dụng ở nơi có nhiều không gian';

  @override
  String shortDateFormat(String example) {
    return 'Định dạng ngày ngắn ($example)';
  }

  @override
  String get shortDateFormatDescription =>
      'Dành cho nơi không gian chật hẹp (Đường biểu đồ)';

  @override
  String get warmupSetsDescription =>
      'Các hiệp khởi động không có bộ hẹn giờ nghỉ';

  @override
  String get setsPerExerciseDescription =>
      'Số lượng bài tập mặc định trong một kế hoạch';

  @override
  String get planTrailingDisplay => 'Hiển thị theo dõi kế hoạch';

  @override
  String get planTrailingDisplayDescription =>
      'Phía bên phải của danh sách hiển thị trong chế độ xem Kế hoạch + Kế hoạch';

  @override
  String get restTimersDescription =>
      'Báo thức vang lên sau khi hoàn thành một hiệp';

  @override
  String get vibrateDescription => 'Có nên hẹn giờ nghỉ ngơi rung?';

  @override
  String get enableSoundDescription =>
      'Bộ hẹn giờ nghỉ ngơi có nên phát âm thanh không?';

  @override
  String get keepScreenOnDescription =>
      'Giữ màn hình bật trong thời gian nghỉ ngơi';

  @override
  String get restDurationDescription =>
      'Bao lâu trước khi báo thức nghỉ ngơi vang lên?';

  @override
  String get globalDefault => 'Mặc định toàn cầu';

  @override
  String get alarmSoundDescription =>
      'Nhạc để phát khi kết thúc thời gian nghỉ ngơi';

  @override
  String get progressBarPosition => 'Vị trí thanh tiến trình';

  @override
  String get progressBarPositionDescription =>
      'Thanh tiến trình của bộ tính giờ nghỉ ngơi nên được đặt ở đâu?';

  @override
  String get perExerciseRestTimes => 'Thời gian nghỉ ngơi mỗi bài tập';

  @override
  String get perExerciseRestTimesDescription =>
      'Những bài tập này có thời gian nghỉ ngơi tùy chỉnh';

  @override
  String get audioFeaturesUnavailable => 'Tính năng âm thanh không có sẵn';

  @override
  String get groupHistoryDescription => 'Tổng hợp các mục lịch sử theo ngày';

  @override
  String get showUnitsDescription =>
      'Hiển thị km/mi,kg/lb cho biểu đồ/lịch sử/kế hoạch';

  @override
  String get showBodyWeightDescription =>
      'Bật/tắt tính năng theo dõi trọng lượng cơ thể';

  @override
  String get showCategoriesDescription => 'Bật/tắt danh mục tập luyện';

  @override
  String get showNotesDescription =>
      'Ghi lại chi tiết về thang máy của bạn trong vùng văn bản';

  @override
  String get positiveNotificationsDescription =>
      'Viết tin nhắn hay khi đạt kỷ lục mới';

  @override
  String get positiveMessagesEnabled =>
      'Những thông điệp tích cực bây giờ xuất hiện như thế này!';

  @override
  String get recordEncouragement01 =>
      'Công việc tuyệt vời! Bạn thật tuyệt vời.';

  @override
  String get recordEncouragement02 =>
      'Vua tốt bụng! Sự tiến bộ của bạn thật đáng khích lệ.';

  @override
  String get recordEncouragement03 => 'Tôi quỳ...';

  @override
  String get recordEncouragement04 => 'Đó là cái gì vậy? Một kỷ lục mới!';

  @override
  String get recordEncouragement05 =>
      'Những thứ đáng kinh ngạc! Bạn là một nguồn cảm hứng.';

  @override
  String get recordEncouragement06 => 'Ồ. Đẹp.';

  @override
  String get recordEncouragement07 => 'Trở nên mạnh mẽ nhiều?';

  @override
  String get recordEncouragement08 => 'Vâng. Bạn là một chàng trai khá lớn.';

  @override
  String get recordEncouragement09 => 'Tuyệt vời. Đáng kinh ngạc.';

  @override
  String get recordEncouragement10 => 'Arnie sẽ tự hào.';

  @override
  String get recordEncouragement11 => 'Ronnie C nhìn bạn với niềm hân hoan.';

  @override
  String get recordEncouragement12 => 'VÂNG! TRỌNG LƯỢNG NHẸ BÉ!!!!!!';

  @override
  String get recordEncouragement13 =>
      'Đó có phải là một kỷ lục mới? Tôi biết bạn có thể làm được điều đó.';

  @override
  String get recordEncouragement14 => 'Công việc tuyệt vời! Tôi tự hào về bạn.';

  @override
  String get recordEncouragement15 => 'Ừ em yêu! Trọng lượng nhẹ!';

  @override
  String get recordEncouragement16 => 'Giữ nó lên! Tiến bộ lớn.';

  @override
  String get recordEncouragement17 => 'Bạn đang làm rất tốt.';

  @override
  String get recordEncouragement18 => 'Đó là chàng trai của tôi!';

  @override
  String get recordEncouragement19 => 'Giữ nó lên.';

  @override
  String get recordEncouragement20 => 'Bạn đang trở nên rất mạnh mẽ.';

  @override
  String get recordEncouragement21 => 'Mạnh mẽ.';

  @override
  String get recordEncouragement22 => 'Thứ mạnh mẽ!';

  @override
  String get recordEncouragement23 => 'Tôi tự hào về bạn.';

  @override
  String get recordEncouragement24 => 'Hãy tiếp tục công việc tuyệt vời này.';

  @override
  String get recordEncouragement25 => 'Đứng cao! Bạn vừa lập một kỷ lục mới.';

  @override
  String get recordEncouragement26 =>
      'Kỷ lục mới! Bạn vừa đẩy xa hơn bao giờ hết!';

  @override
  String get recordEncouragement27 => 'Chuẩn rồi! Đó là một kỷ lục.';

  @override
  String get recordEncouragement28 => 'Ồ! Kỷ lục mới!';

  @override
  String get recordEncouragement29 => 'Thứ rất tốt.';

  @override
  String get repEstimationDescription =>
      'Hãy thử dự đoán số lần bạn vừa thực hiện';

  @override
  String get durationEstimationDescription =>
      'Hãy thử dự đoán thời gian tập tim mạch của bạn';

  @override
  String get showGraphXAxisToggle => 'Hiển thị chuyển đổi trục X của biểu đồ';

  @override
  String get showGraphXAxisToggleDescription =>
      'Hiển thị chuyển đổi trục X dựa trên thời gian trên biểu đồ';

  @override
  String get showGraphLimitDescription =>
      'Hiển thị thanh trượt giới hạn trên biểu đồ';

  @override
  String get defaultTimeBasedXAxis => 'Trục X dựa trên thời gian mặc định';

  @override
  String get defaultTimeBasedXAxisDescription =>
      'Sử dụng trục X dựa trên thời gian theo mặc định trên biểu đồ';

  @override
  String get createFirstTrainingPlan =>
      'Tạo kế hoạch tập luyện đầu tiên của bạn để bắt đầu.';

  @override
  String nothingMatchesPlanSearch(String query) {
    return 'Không có gì khớp với “$query”. Bạn có thể tạo nó như một kế hoạch mới.';
  }

  @override
  String get createPlan => 'Tạo kế hoạch';

  @override
  String createNamedPlan(String name) {
    return 'Tạo “$name”';
  }

  @override
  String setNumber(int number) {
    return 'Hiệp $number';
  }
}
