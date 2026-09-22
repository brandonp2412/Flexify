// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsLanguageDescription => 'Flexify에서 사용할 언어를 선택하세요';

  @override
  String get languageSystemDefault => '시스템 기본값';

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
  String get languageNameTurkish => 'Turkish';

  @override
  String get navHistory => '기록';

  @override
  String get navPlans => '플랜';

  @override
  String get navGraphs => '그래프';

  @override
  String get navTimer => '타이머';

  @override
  String get navSettings => '설정';

  @override
  String get errorLabel => '오류';

  @override
  String get tabContentError => '탭 내용을 표시할 수 없습니다.';

  @override
  String get cannotHideAllTabs => '모든 탭을 숨길 수 없습니다!';

  @override
  String removeTabQuestion(String tab) {
    return '$tab 탭을 제거할까요?';
  }

  @override
  String get restoreTabFromSettings => '나중에 설정에서 다시 추가할 수 있습니다.';

  @override
  String removedTab(String tab) {
    return '$tab 제거됨';
  }

  @override
  String newVersion(String version) {
    return '새 버전 $version';
  }

  @override
  String get changes => '변경 사항';

  @override
  String get searchHint => '검색...';

  @override
  String get deleteSelected => '선택 항목 삭제';

  @override
  String get confirmDelete => '삭제 확인';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '기록 $count개를 삭제할까요? 이 작업은 되돌릴 수 없습니다.',
      one: '기록 1개를 삭제할까요? 이 작업은 되돌릴 수 없습니다.',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => '취소';

  @override
  String get actionDelete => '삭제';

  @override
  String get actionRemove => '제거';

  @override
  String get actionEdit => '편집';

  @override
  String get actionShare => '공유';

  @override
  String get clearSelection => '선택 해제';

  @override
  String get clearSearch => '검색 지우기';

  @override
  String get showMenu => '메뉴 표시';

  @override
  String get selectAll => '모두 선택';

  @override
  String get weightLabel => '중량';

  @override
  String get filter => '필터';

  @override
  String get filters => '필터';

  @override
  String get categoryLabel => '카테고리';

  @override
  String get repsLabel => '반복 횟수';

  @override
  String get repsFilter => '반복 횟수 필터';

  @override
  String get weightFilter => '중량 필터';

  @override
  String get greaterThan => '초과';

  @override
  String get lessThan => '미만';

  @override
  String get startDate => '시작 날짜';

  @override
  String get endDate => '종료 날짜';

  @override
  String get actionClear => '지우기';

  @override
  String get actionOk => '확인';

  @override
  String get actionClose => '닫기';

  @override
  String get sortBy => '정렬 기준';

  @override
  String get dateNewest => '날짜 (최신순)';

  @override
  String get dateOldest => '날짜 (오래된순)';

  @override
  String get nameLabel => '이름';

  @override
  String get missingPermissions => '권한이 부족합니다';

  @override
  String get restTimersPermissionsMissing => '휴식 타이머가 켜져 있지만 필요한 권한이 없습니다.';

  @override
  String get restTimersPermissionsOptional => '휴식 타이머를 끄면 이 권한들은 필요하지 않습니다.';

  @override
  String get restTimers => '휴식 타이머';

  @override
  String get disableBatteryOptimizations => '배터리 최적화 사용 안 함';

  @override
  String get batteryOptimizationWarning => '배터리 최적화가 켜져 있으면 진행이 일시 중지될 수 있습니다.';

  @override
  String get scheduleExactAlarm => '정확한 알람 예약';

  @override
  String get exactAlarmWarning => '이 기능을 끄면 알람 시간이 정확하지 않을 수 있습니다.';

  @override
  String get postNotifications => '알림 표시';

  @override
  String get notificationBarDescription => '타이머 진행 상황을 알림 표시줄에 표시합니다';

  @override
  String get invalidPermissions => '유효하지 않은 권한';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      '필요한 권한이 충분하지 않은 상태에서 휴식 타이머가 켜져 있습니다. 계속할까요?';

  @override
  String get actionConfirm => '확인';

  @override
  String get appAccess => '앱 접근 권한';

  @override
  String get appAccessDescription => '활성화된 타이머와 알림에 필요합니다.';

  @override
  String get notifications => '알림';

  @override
  String get timerProgressAndRestAlerts => '타이머 진행 상황 및 휴식 알림';

  @override
  String get enabledNotificationsDescription => '활성화한 알림';

  @override
  String get backgroundActivity => '백그라운드 활동';

  @override
  String get backgroundActivityDescription => '백그라운드에서도 타이머를 안정적으로 유지합니다';

  @override
  String get exactAlarms => '정확한 알람';

  @override
  String get exactAlarmsDescription => '휴식 타이머 종료 시 정확히 알립니다';

  @override
  String get noAdditionalAndroidAccessNeeded =>
      '현재 설정에는 추가 Android 접근 권한이 필요하지 않습니다.';

  @override
  String get actionDone => '완료';

  @override
  String get allowed => '허용됨';

  @override
  String get actionAllow => '허용';

  @override
  String get backupLabel => '백업';

  @override
  String get databaseLabel => '데이터베이스';

  @override
  String get deleteRecords => '기록 삭제';

  @override
  String get deleteAllGraphsConfirmation => '모든 그래프를 삭제할까요? 이 작업은 되돌릴 수 없습니다.';

  @override
  String get deleteAllPlansConfirmation => '모든 플랜을 삭제할까요? 이 작업은 되돌릴 수 없습니다.';

  @override
  String get deleteDatabaseConfirmation =>
      '데이터베이스를 삭제할까요? 이 작업은 되돌릴 수 없으며 모든 데이터가 삭제됩니다.';

  @override
  String get importData => '데이터 가져오기';

  @override
  String get exportData => '데이터 내보내기';

  @override
  String get actionReport => '신고';

  @override
  String get graphDataImported => '그래프 데이터를 가져왔습니다!';

  @override
  String get plansImported => '플랜을 가져왔습니다';

  @override
  String failedToImportDatabase(String error) {
    return '데이터베이스 가져오기 실패: $error';
  }

  @override
  String get backupArchiveMissingDatabase =>
      '백업에 Flexify 데이터베이스가 포함되어 있지 않습니다.';

  @override
  String failedToImportGraphs(String error) {
    return '그래프 가져오기 실패: $error';
  }

  @override
  String failedToImportPlans(String error) {
    return '플랜 가져오기 실패: $error';
  }

  @override
  String get selectedFileDoesNotExist => '선택한 파일이 존재하지 않습니다';

  @override
  String get couldNotReadFileData => '파일 데이터를 읽을 수 없습니다';

  @override
  String get databaseImportWebUnsupported =>
      '웹에서 데이터베이스를 가져오려면 데이터를 수동으로 이전해야 합니다. 데이터를 CSV 파일로 내보낸 뒤 해당 파일을 가져오세요.';

  @override
  String get csvFileEmpty => 'CSV 파일이 비어 있습니다';

  @override
  String get csvNeedsDataRow => 'CSV 파일에는 데이터 행이 하나 이상 있어야 합니다';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return '$row행의 열 수가 부족합니다: $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return '$row행의 $field 값이 잘못되었습니다: $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return '$row행의 $field 데이터 형식이 잘못되었습니다: $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return '플랜 ID는 정수여야 하지만 \"$value\"이(가) 입력되었습니다';
  }

  @override
  String get unitLabel => '단위';

  @override
  String get kilogramsUnit => '킬로그램 (kg)';

  @override
  String get poundsUnit => '파운드 (lb)';

  @override
  String get stoneUnit => '스톤';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => '킬로미터 (km)';

  @override
  String get milesUnit => '마일 (mi)';

  @override
  String get metersUnit => '미터 (m)';

  @override
  String get kilocaloriesUnit => '킬로칼로리 (kcal)';

  @override
  String get enterWeight => '중량 입력';

  @override
  String get requiredField => '필수';

  @override
  String get invalidNumber => '잘못된 숫자';

  @override
  String get previousWeight => '이전 중량';

  @override
  String get imageLabel => '이미지';

  @override
  String get longPressToDelete => '길게 눌러 삭제';

  @override
  String get imageError => '이미지 오류';

  @override
  String get actionSave => '저장';

  @override
  String get aboutTitle => '정보';

  @override
  String get donate => '후원';

  @override
  String get helpSupportProject => '이 프로젝트 후원하기';

  @override
  String get whatsNewAbout => '새로운 기능';

  @override
  String get whatsNewTitle => '새로운 기능';

  @override
  String get seeReleaseNotes => '릴리스 노트 보기';

  @override
  String get versionLabel => '버전';

  @override
  String get authorLabel => '작성자';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get privacyPolicyDescription => 'Flexify의 데이터 처리 방식';

  @override
  String get licenseLabel => '라이선스';

  @override
  String get sourceCode => '소스 코드';

  @override
  String get sourceCodeDescription => 'GitHub에서 보기';

  @override
  String get leaveReview => '리뷰 남기기';

  @override
  String get leaveReviewDescription => 'Play 스토어에서 Flexify 평가하기';

  @override
  String get reportBug => '버그 신고';

  @override
  String get reportBugDescription => 'GitHub에서 이슈 열기';

  @override
  String get failedMigrations => '실패한 마이그레이션';

  @override
  String get errorMessageLabel => '오류 메시지:';

  @override
  String get createIssue => '이슈 만들기';

  @override
  String get addExercise => '운동 추가';

  @override
  String get cardio => '유산소';

  @override
  String get strength => '근력';

  @override
  String get options => '옵션';

  @override
  String get periodDay => '일';

  @override
  String get periodWeek => '주';

  @override
  String get periodMonth => '월';

  @override
  String get periodYear => '년';

  @override
  String noDataFor(String name) {
    return '$name 데이터가 아직 없습니다';
  }

  @override
  String get noDataYet => '아직 데이터가 없습니다';

  @override
  String get exerciseNotes => '운동 메모';

  @override
  String get notesForExercise => '이 운동에 대한 메모';

  @override
  String get useTimeBasedXAxis => '시간 기반 X축 사용';

  @override
  String updateAllNamed(String name) {
    return '모든 $name 업데이트';
  }

  @override
  String get newName => '새 이름';

  @override
  String get restMinutes => '휴식 시간 (분)';

  @override
  String get restSeconds => '휴식 시간 (초)';

  @override
  String get globalProgress => '전체 진행 상황';

  @override
  String get curveLineGraphs => '그래프 선 곡선으로 표시';

  @override
  String get curveLineGraphsDescription => '그래프 선을 부드러운 곡선으로 그립니다';

  @override
  String noHistoryFor(String name) {
    return '$name 기록이 아직 없습니다';
  }

  @override
  String get cancelSelection => '선택 취소';

  @override
  String get editSelected => '선택 항목 편집';

  @override
  String get newExercise => '새 운동';

  @override
  String get noGraphsFound => '그래프를 찾을 수 없습니다';

  @override
  String get searchGraphs => '그래프 검색...';

  @override
  String get actionAdd => '추가';

  @override
  String get actionUpdate => '업데이트';

  @override
  String get hideGlobalProgress => '전체 진행 상황 숨기기';

  @override
  String get chartGroupedByCategory => '카테고리별로 묶은 차트';

  @override
  String get noExercisesFound => '운동을 찾을 수 없습니다';

  @override
  String get savePlan => '플랜 저장';

  @override
  String get titleOptional => '제목 (선택 사항)';

  @override
  String get searchExercises => '운동 검색...';

  @override
  String get warmupSets => '워밍업 세트';

  @override
  String get workingSetsMax => '본 세트 (최대: 20)';

  @override
  String get actionUndo => '실행 취소';

  @override
  String get actionSwap => '교체';

  @override
  String get daily => '매일';

  @override
  String get weekly => '매주';

  @override
  String get monthly => '매월';

  @override
  String get yearly => '매년';

  @override
  String get unexpectedError => '문제가 발생했습니다. 다시 시도해 주세요.';

  @override
  String get loadingExercises => '운동 불러오는 중...';

  @override
  String get noPlansYet => '아직 플랜이 없습니다';

  @override
  String get noMatchingPlans => '일치하는 플랜이 없습니다';

  @override
  String get newPlan => '새 플랜';

  @override
  String get searchPlans => '플랜 검색...';

  @override
  String get noExercisesYet => '아직 운동이 없습니다';

  @override
  String get editPlan => '플랜 편집';

  @override
  String get saveSet => '세트 저장';

  @override
  String get minutesLabel => '분';

  @override
  String get minutesShort => '분';

  @override
  String get secondsLabel => '초';

  @override
  String get distanceLabel => '거리';

  @override
  String get inclinePercent => '경사 %';

  @override
  String weightWithUnit(String unit) {
    return '중량 ($unit)';
  }

  @override
  String get useBodyWeight => '체중 사용';

  @override
  String get noWeightEnteredYet => '아직 중량을 입력하지 않았습니다';

  @override
  String get notesLabel => '메모';

  @override
  String get swapWorkout => '운동 교체';

  @override
  String get addSet => '세트 추가';

  @override
  String get deleteSet => '세트 삭제';

  @override
  String get oneRepMaxEstimate => '1RM (추정)';

  @override
  String get valueLabel => '값';

  @override
  String amountWithUnit(String unit) {
    return '수치 ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return '거리 ($unit)';
  }

  @override
  String get bodyWeightLabel => '체중';

  @override
  String bodyWeightWithUnit(String unit) {
    return '체중 ($unit)';
  }

  @override
  String get categoryHelper => '근육 부위 (예: 가슴 또는 하체)';

  @override
  String get manageCategories => 'Manage categories';

  @override
  String get manageCategoriesDescription =>
      'Create, rename, merge or remove categories';

  @override
  String get newCategory => 'New category';

  @override
  String get renameCategory => 'Rename category';

  @override
  String get mergeCategory => 'Merge into another category';

  @override
  String get noCategories => 'No categories yet';

  @override
  String get categoryNameRequired => 'Enter a category name';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Used by $count entries',
      one: 'Used by 1 entry',
      zero: 'Not used by any entries',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete this category and remove it from $count entries?',
      one: 'Delete this category and remove it from 1 entry?',
      zero: 'Delete this category?',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => '생성 날짜';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '세트 $count개 편집',
      one: '세트 1개 편집',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => '아직 항목이 없습니다';

  @override
  String get historyEmptyMessage => '세트를 완료하거나 직접 추가하면 기록이 시작됩니다.';

  @override
  String deleteSetConfirmation(String name) {
    return '$name을(를) 삭제할까요?';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '항목 $count개를 삭제할까요?',
      one: '항목 1개를 삭제할까요?',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => '기록 검색...';

  @override
  String get themeSystem => '시스템';

  @override
  String get themeDark => '다크';

  @override
  String get themeLight => '라이트';

  @override
  String get pureBlackAmoled => '완전한 검정 (AMOLED)';

  @override
  String get showImages => '이미지 표시';

  @override
  String get peekGraph => '그래프 미리보기';

  @override
  String get inputStyleLine => '밑줄';

  @override
  String get inputStyleOutlined => '테두리';

  @override
  String get inputStyleFilled => '채움';

  @override
  String get inputStyle => '입력 필드 스타일';

  @override
  String get appearance => '디자인';

  @override
  String get automaticBackupsEnabled => '자동 백업 사용 중';

  @override
  String get automaticBackup => '자동 백업';

  @override
  String get appPermissions => '앱 권한';

  @override
  String get shareDatabase => '데이터베이스 공유';

  @override
  String get dataManagement => '데이터 관리';

  @override
  String get strengthUnit => '근력 단위';

  @override
  String get lastEntry => '최근 기록';

  @override
  String get cardioUnit => '유산소 단위';

  @override
  String longDateFormat(String format) {
    return '긴 날짜 형식 ($format)';
  }

  @override
  String get formats => '형식';

  @override
  String get setsPerExerciseMax => '운동별 세트 수 (최대: 20)';

  @override
  String get countLabel => '개수';

  @override
  String get ratioLabel => '비율';

  @override
  String get reorder => '순서 변경';

  @override
  String get none => '없음';

  @override
  String get monday => '월요일';

  @override
  String get examplePlanExercises => '벤치프레스, 스쿼트, 데드리프트';

  @override
  String get tabs => '탭';

  @override
  String get swipeBetweenTabs => '스와이프로 탭 전환';

  @override
  String get vibrate => '진동';

  @override
  String get enableSound => '소리 사용';

  @override
  String get keepScreenOn => '화면 켜짐 유지';

  @override
  String get alarmSound => '알람 소리';

  @override
  String get top => '위';

  @override
  String get bottom => '아래';

  @override
  String get removeCustomTimer => '사용자 지정 타이머 제거 (전체 기본값 사용)';

  @override
  String get timers => '타이머';

  @override
  String get timerSettings => '타이머 설정';

  @override
  String get groupHistory => '기록 묶기';

  @override
  String get showUnits => '단위 표시';

  @override
  String get showBodyWeight => '체중 표시';

  @override
  String get showCategories => '카테고리 표시';

  @override
  String get showNotes => '메모 표시';

  @override
  String get repEstimation => '반복 횟수 추정';

  @override
  String get durationEstimation => '시간 추정';

  @override
  String get showGraphLimit => '그래프 제한 표시';

  @override
  String get defaultGraphMetric => '기본 그래프 지표';

  @override
  String get bestWeight => '최고 중량';

  @override
  String get bestReps => '최다 반복 횟수';

  @override
  String get oneRepMax => '1RM';

  @override
  String get volume => '볼륨';

  @override
  String get paceCardio => '페이스 (유산소)';

  @override
  String get distanceCardio => '거리 (유산소)';

  @override
  String get defaultGraphPeriod => '기본 그래프 기간';

  @override
  String get defaultGraphLimit => '기본 그래프 제한';

  @override
  String get workouts => '운동';

  @override
  String get actionStop => '중지';

  @override
  String get timerFinishedToast => '타이머가 끝났습니다!';

  @override
  String get stopTimer => '타이머 중지';

  @override
  String get actionPause => '일시 중지';

  @override
  String get startStopwatch => '스톱워치 시작';

  @override
  String get actionStart => '시작';

  @override
  String get actionRestart => '다시 시작';

  @override
  String get addOneMinute => '+1분';

  @override
  String get addOneMinuteNotification => '1분 추가';

  @override
  String get restTimer => '휴식 타이머';

  @override
  String get timerUp => '시간 종료';

  @override
  String get openNotification => '알림 열기';

  @override
  String get timerChannelName => '타이머 채널';

  @override
  String get timerChannelDescription => '휴식 타이머의 진행 상황을 계속 표시합니다.';

  @override
  String get timerFinishedChannelName => '타이머 종료 채널';

  @override
  String get timerFinishedChannelDescription => '휴식 타이머가 끝나면 알람을 재생합니다.';

  @override
  String get timerFinished => '타이머 종료';

  @override
  String get batteryOptimizationRequestUnavailable =>
      '이 기기에서는 배터리 최적화 무시 요청이 비활성화되어 있습니다.';

  @override
  String get exactAlarmRequestUnavailable =>
      '이 기기에서 SCHEDULE_EXACT_ALARM 요청이 거부되었습니다';

  @override
  String get databaseMigrationFailureDescription =>
      '데이터베이스를 만들거나 업그레이드하는 중 문제가 발생했습니다. 보통 기록을 삭제한 뒤 다시 만들면 해결할 수 있습니다.';

  @override
  String get curveSmoothness => '곡선 부드러움';

  @override
  String get actionBack => '뒤로';

  @override
  String get atLeastOneTab => '탭이 하나 이상 필요합니다';

  @override
  String get invalidTabSettings => '탭 설정이 잘못되었습니다.';

  @override
  String get noSettingsFound => '설정을 찾을 수 없습니다';

  @override
  String nothingMatchesSearch(String query) {
    return '“$query”와 일치하는 항목이 없습니다.';
  }

  @override
  String get appearanceDescription => '테마, 색상 및 인터페이스 스타일';

  @override
  String get dataManagementDescription => '운동 데이터 가져오기, 내보내기 및 관리';

  @override
  String get formatsDescription => '날짜, 숫자 및 측정 단위 형식';

  @override
  String get plansSettingsDescription => '운동 플랜 기본값 및 동작';

  @override
  String get tabsDescription => '기본 탐색 탭을 선택하고 순서를 정합니다';

  @override
  String get timersDescription => '휴식 타이머 시간, 소리 및 동작';

  @override
  String get workoutsDescription => '운동 기록 및 운동 설정';

  @override
  String get completeSetForChart => '이 운동의 세트를 완료하면 그래프를 만들 수 있습니다.';

  @override
  String get dateRange => '날짜 범위';

  @override
  String get stopDate => '종료 날짜';

  @override
  String get dataPoints => '데이터 포인트';

  @override
  String get completeSetsForProgress => '세트를 몇 개 완료하면 진행 그래프를 만들 수 있습니다.';

  @override
  String get relativeStrength => '상대 근력';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개 선택됨',
      one: '1개 선택됨',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory => '세트를 몇 개 완료하면 이 운동의 기록을 여기서 볼 수 있습니다.';

  @override
  String get completeSetForFirstGraph => '세트를 완료하면 첫 운동 그래프를 만들 수 있습니다.';

  @override
  String nothingMatchesGraphSearch(String query) {
    return '“$query”와 일치하는 항목이 없습니다. 새 운동으로 만들 수 있습니다.';
  }

  @override
  String addNamed(String name) {
    return '“$name” 추가';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return '기록 $count개가 삭제됩니다. 계속할까요?';
  }

  @override
  String shareWorkout(String summary) {
    return '방금 $summary 했어요';
  }

  @override
  String get updateConflict => '업데이트 충돌';

  @override
  String updateConflictDescription(int count) {
    return '새 이름이 이미 $count개의 기록에 존재합니다. 계속할까요?';
  }

  @override
  String get unitsConflict => '단위 충돌';

  @override
  String unitsConflictDescription(String unit) {
    return '모든 기록의 단위가 같지 않습니다. 모든 단위를 $unit(으)로 변환합니다. 계속할까요?';
  }

  @override
  String get durationLabel => '시간';

  @override
  String get inclineLabel => '경사';

  @override
  String get paceDistanceTime => '페이스 (거리 / 시간)';

  @override
  String get adjustedPace => '보정 페이스';

  @override
  String get oneRepMaxAccuracyWarning => '1RM 추정치는 10회 이상 반복한 세트에서 정확도가 낮습니다';

  @override
  String get addPlan => '플랜 추가';

  @override
  String get planDetails => '플랜 세부 정보';

  @override
  String get exercisesLabel => '운동';

  @override
  String get addExerciseToPlan => '이 플랜에 운동을 추가하세요.';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return '“$query”와 일치하는 항목이 없습니다. 새 운동으로 추가할 수 있습니다.';
  }

  @override
  String get selectDays => '요일 선택';

  @override
  String get selectExercises => '운동 선택';

  @override
  String get todayLabel => '오늘';

  @override
  String get setDetails => '세트 세부 정보';

  @override
  String get themeLabel => '테마';

  @override
  String get pureBlackAmoledDescription => 'AMOLED 화면에서 완전한 검정색을 사용합니다';

  @override
  String get systemColorScheme => '시스템 색상 구성';

  @override
  String get systemColorSchemeDescription => '기기의 기본 색상을 앱에 사용합니다';

  @override
  String get showImagesDescription => '기록 페이지에서 이미지를 선택하고 표시합니다';

  @override
  String get showGlobalProgress => '전체 진행 상황 표시';

  @override
  String get showGlobalProgressDescription =>
      '카테고리별 진행 상황을 나타내는 항목을 그래프에 추가합니다';

  @override
  String get peekGraphDescription => '그래프 페이지에 첫 번째 선 그래프를 표시합니다';

  @override
  String get inputStyleDescription => '텍스트 입력 필드의 시각적 스타일';

  @override
  String get automaticBackupNotificationBody =>
      'Flexify가 매일 선택한 폴더에 데이터와 이미지를 자동으로 백업합니다.';

  @override
  String get backupSettingsChannel => '백업 설정';

  @override
  String get backupSettingsChannelDescription => '자동 백업을 설명하는 알림';

  @override
  String get backupChannelName => '백업 채널';

  @override
  String get backupChannelDescription => 'Flexify 데이터와 이미지의 자동 백업';

  @override
  String get backupCompletedTitle => '데이터와 이미지 백업 완료';

  @override
  String get backupFailurePathNotSet =>
      '백업 실패: 백업 경로가 설정되지 않았습니다. 자동 백업을 비활성화했습니다.';

  @override
  String get backupFailureDirectoryUnavailable =>
      '백업 실패: 백업 폴더에 접근할 수 없습니다. 자동 백업을 비활성화했습니다.';

  @override
  String get backupFailureCreateFile =>
      '백업 실패: 백업 파일을 만들 수 없습니다. 자동 백업을 비활성화했습니다.';

  @override
  String get backupFailureAppFilesUnavailable =>
      '백업 실패: 앱 파일 폴더에 접근할 수 없습니다. 자동 백업을 비활성화했습니다.';

  @override
  String get backupFailureDatabaseMissing =>
      '백업 실패: 데이터베이스 파일을 찾을 수 없습니다. 자동 백업을 비활성화했습니다.';

  @override
  String get backupFailureOutputUnavailable =>
      '백업 실패: 출력 스트림을 열 수 없습니다. 자동 백업을 비활성화했습니다.';

  @override
  String get backupFailureUnknown => '백업에 실패했습니다. 자동 백업을 비활성화했습니다.';

  @override
  String get appPermissionsDescription => '활성화한 기능에 필요한 접근 권한을 확인하세요';

  @override
  String get longDateFormatDescription => '공간이 충분한 곳에서 사용합니다';

  @override
  String shortDateFormat(String example) {
    return '짧은 날짜 형식 ($example)';
  }

  @override
  String get shortDateFormatDescription => '공간이 좁은 곳에서 사용합니다 (그래프 선 등)';

  @override
  String get warmupSetsDescription => '워밍업 세트에는 휴식 타이머가 없습니다';

  @override
  String get setsPerExerciseDescription => '플랜의 기본 운동 개수';

  @override
  String get planTrailingDisplay => '플랜 오른쪽 표시';

  @override
  String get planTrailingDisplayDescription => '플랜 목록과 플랜 보기의 오른쪽에 표시할 내용';

  @override
  String get restTimersDescription => '세트 완료 후 울리는 알람';

  @override
  String get vibrateDescription => '휴식 타이머에서 진동할까요?';

  @override
  String get enableSoundDescription => '휴식 타이머에서 소리를 재생할까요?';

  @override
  String get keepScreenOnDescription => '휴식 타이머 동안 화면을 켜 둡니다';

  @override
  String get restDurationDescription => '휴식 알람이 울리기까지의 시간';

  @override
  String get globalDefault => '전체 기본값';

  @override
  String get alarmSoundDescription => '휴식 타이머 종료 시 재생할 음악';

  @override
  String get progressBarPosition => '진행 표시줄 위치';

  @override
  String get progressBarPositionDescription => '휴식 타이머 진행 표시줄을 어디에 둘까요?';

  @override
  String get perExerciseRestTimes => '운동별 휴식 시간';

  @override
  String get perExerciseRestTimesDescription => '이 운동들은 사용자 지정 휴식 시간이 있습니다';

  @override
  String get audioFeaturesUnavailable => '오디오 기능을 사용할 수 없습니다';

  @override
  String get groupHistoryDescription => '기록을 날짜별로 묶습니다';

  @override
  String get showUnitsDescription => '그래프, 기록, 플랜에 km/mi와 kg/lb를 표시합니다';

  @override
  String get showBodyWeightDescription => '체중 기록을 켜거나 끕니다';

  @override
  String get showCategoriesDescription => '운동 카테고리를 켜거나 끕니다';

  @override
  String get showNotesDescription => '운동 세부 내용을 텍스트 영역에 기록합니다';

  @override
  String get positiveNotificationsDescription => '새 기록을 달성하면 응원 메시지를 표시합니다';

  @override
  String get positiveMessagesEnabled => '긍정적인 메시지가 이제 이렇게 표시됩니다!';

  @override
  String get recordEncouragement01 => '잘했어요! 정말 대단합니다.';

  @override
  String get recordEncouragement02 => '멋져요, 왕이여! 발전이 정말 인상적입니다.';

  @override
  String get recordEncouragement03 => '무릎을 꿇습니다...';

  @override
  String get recordEncouragement04 => '이게 뭐죠? 새 기록!';

  @override
  String get recordEncouragement05 => '정말 대단해요! 큰 자극이 됩니다.';

  @override
  String get recordEncouragement06 => '와. 좋네요.';

  @override
  String get recordEncouragement07 => '점점 강해지는데요?';

  @override
  String get recordEncouragement08 => '그래요. 꽤 커지고 있네요.';

  @override
  String get recordEncouragement09 => '놀랍습니다. 대단해요.';

  @override
  String get recordEncouragement10 => '아놀드도 자랑스러워할 거예요.';

  @override
  String get recordEncouragement11 => '로니 C도 기쁘게 바라보고 있습니다.';

  @override
  String get recordEncouragement12 => '예아! 라이트웨이트 베이비!!!!!!!';

  @override
  String get recordEncouragement13 => '새 기록인가요? 해낼 줄 알았어요.';

  @override
  String get recordEncouragement14 => '잘했어요! 자랑스럽습니다.';

  @override
  String get recordEncouragement15 => '예아 베이비! 가벼워요!';

  @override
  String get recordEncouragement16 => '계속하세요! 멋진 발전입니다.';

  @override
  String get recordEncouragement17 => '정말 잘하고 있어요.';

  @override
  String get recordEncouragement18 => '바로 그거예요!';

  @override
  String get recordEncouragement19 => '계속하세요.';

  @override
  String get recordEncouragement20 => '정말 강해지고 있어요.';

  @override
  String get recordEncouragement21 => '강력합니다.';

  @override
  String get recordEncouragement22 => '엄청난 힘이에요!';

  @override
  String get recordEncouragement23 => '자랑스럽습니다.';

  @override
  String get recordEncouragement24 => '계속 멋지게 해내세요.';

  @override
  String get recordEncouragement25 => '당당하게 서세요! 방금 새 기록을 세웠습니다.';

  @override
  String get recordEncouragement26 => '새 기록! 지금까지보다 더 멀리 나아갔습니다!';

  @override
  String get recordEncouragement27 => '맞아요! 새 기록입니다.';

  @override
  String get recordEncouragement28 => '와! 새 기록!';

  @override
  String get recordEncouragement29 => '정말 잘했어요.';

  @override
  String get repEstimationDescription => '방금 수행한 반복 횟수를 예측합니다';

  @override
  String get durationEstimationDescription => '유산소 운동 시간을 예측합니다';

  @override
  String get showGraphXAxisToggle => '그래프 X축 전환 표시';

  @override
  String get showGraphXAxisToggleDescription => '그래프에 시간 기반 X축 전환을 표시합니다';

  @override
  String get showGraphLimitDescription => '그래프에 제한 슬라이더를 표시합니다';

  @override
  String get defaultTimeBasedXAxis => '시간 기반 X축을 기본값으로 사용';

  @override
  String get defaultTimeBasedXAxisDescription => '그래프에서 시간 기반 X축을 기본으로 사용합니다';

  @override
  String get createFirstTrainingPlan => '첫 운동 플랜을 만들어 시작하세요.';

  @override
  String nothingMatchesPlanSearch(String query) {
    return '“$query”와 일치하는 항목이 없습니다. 새 플랜으로 만들 수 있습니다.';
  }

  @override
  String get createPlan => '플랜 만들기';

  @override
  String createNamedPlan(String name) {
    return '“$name” 만들기';
  }

  @override
  String setNumber(int number) {
    return '세트 $number';
  }
}
