// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageDescription => '选择 Flexify 使用的语言';

  @override
  String get languageSystemDefault => '跟随系统';

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
  String get navHistory => '历史';

  @override
  String get navPlans => '计划';

  @override
  String get navGraphs => '图表';

  @override
  String get navTimer => '计时器';

  @override
  String get navSettings => '设置';

  @override
  String get errorLabel => '错误';

  @override
  String get tabContentError => '无法显示此标签页的内容。';

  @override
  String get cannotHideAllTabs => '不能隐藏所有标签页！';

  @override
  String removeTabQuestion(String tab) {
    return '移除“$tab”标签页？';
  }

  @override
  String get restoreTabFromSettings => '之后可以在设置中重新添加。';

  @override
  String removedTab(String tab) {
    return '已移除“$tab”';
  }

  @override
  String newVersion(String version) {
    return '新版本 $version';
  }

  @override
  String get changes => '更新内容';

  @override
  String get searchHint => '搜索...';

  @override
  String get deleteSelected => '删除所选项';

  @override
  String get confirmDelete => '确认删除';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '确定要删除 $count 条记录吗？此操作无法撤销。',
      one: '确定要删除 1 条记录吗？此操作无法撤销。',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => '取消';

  @override
  String get actionDelete => '删除';

  @override
  String get actionRemove => '移除';

  @override
  String get actionEdit => '编辑';

  @override
  String get actionShare => '分享';

  @override
  String get clearSelection => '清除选择';

  @override
  String get clearSearch => '清除搜索';

  @override
  String get showMenu => '显示菜单';

  @override
  String get selectAll => '全选';

  @override
  String get weightLabel => '重量';

  @override
  String get filter => '筛选';

  @override
  String get filters => '筛选条件';

  @override
  String get categoryLabel => '类别';

  @override
  String get repsLabel => '次数';

  @override
  String get repsFilter => '次数筛选';

  @override
  String get weightFilter => '重量筛选';

  @override
  String get greaterThan => '大于';

  @override
  String get lessThan => '小于';

  @override
  String get startDate => '开始日期';

  @override
  String get endDate => '结束日期';

  @override
  String get actionClear => '清除';

  @override
  String get actionOk => '确定';

  @override
  String get actionClose => '关闭';

  @override
  String get sortBy => '排序方式';

  @override
  String get dateNewest => '日期（最新）';

  @override
  String get dateOldest => '日期（最早）';

  @override
  String get nameLabel => '名称';

  @override
  String get missingPermissions => '缺少权限';

  @override
  String get restTimersPermissionsMissing => '已启用休息计时器，但缺少所需权限。';

  @override
  String get restTimersPermissionsOptional => '如果关闭休息计时器，则不需要这些权限。';

  @override
  String get restTimers => '休息计时器';

  @override
  String get disableBatteryOptimizations => '关闭电池优化';

  @override
  String get batteryOptimizationWarning => '如果保持电池优化开启，计时进度可能暂停。';

  @override
  String get scheduleExactAlarm => '设置精确闹钟';

  @override
  String get exactAlarmWarning => '如果关闭此功能，闹钟时间可能不准确。';

  @override
  String get postNotifications => '显示通知';

  @override
  String get notificationBarDescription => '在通知栏中显示计时器进度';

  @override
  String get invalidPermissions => '权限不足';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      '休息计时器已启用，但所需权限不足。确定要继续吗？';

  @override
  String get actionConfirm => '确认';

  @override
  String get appAccess => '应用访问权限';

  @override
  String get appAccessDescription => '已启用的计时器和通知需要这些权限。';

  @override
  String get notifications => '通知';

  @override
  String get timerProgressAndRestAlerts => '计时进度和休息提醒';

  @override
  String get enabledNotificationsDescription => '你已启用的通知';

  @override
  String get backgroundActivity => '后台活动';

  @override
  String get backgroundActivityDescription => '确保计时器在后台稳定运行';

  @override
  String get exactAlarms => '精确闹钟';

  @override
  String get exactAlarmsDescription => '在休息计时器结束时准时提醒';

  @override
  String get noAdditionalAndroidAccessNeeded => '当前设置无需额外的 Android 访问权限。';

  @override
  String get actionDone => '完成';

  @override
  String get allowed => '已允许';

  @override
  String get actionAllow => '允许';

  @override
  String get backupLabel => '备份';

  @override
  String get databaseLabel => '数据库';

  @override
  String get deleteRecords => '删除记录';

  @override
  String get deleteAllGraphsConfirmation => '确定要删除所有图表吗？此操作无法撤销。';

  @override
  String get deleteAllPlansConfirmation => '确定要删除所有计划吗？此操作无法撤销。';

  @override
  String get deleteDatabaseConfirmation => '确定要删除数据库吗？此操作无法撤销，并会清除所有数据。';

  @override
  String get importData => '导入数据';

  @override
  String get exportData => '导出数据';

  @override
  String get actionReport => '报告';

  @override
  String get graphDataImported => '图表数据导入成功！';

  @override
  String get plansImported => '计划导入成功';

  @override
  String failedToImportDatabase(String error) {
    return '数据库导入失败：$error';
  }

  @override
  String get backupArchiveMissingDatabase => '备份中不包含 Flexify 数据库。';

  @override
  String failedToImportGraphs(String error) {
    return '图表导入失败：$error';
  }

  @override
  String failedToImportPlans(String error) {
    return '计划导入失败：$error';
  }

  @override
  String get selectedFileDoesNotExist => '所选文件不存在';

  @override
  String get couldNotReadFileData => '无法读取文件数据';

  @override
  String get databaseImportWebUnsupported =>
      '网页端导入数据库需要手动迁移数据。请将数据导出为 CSV 文件，再导入这些 CSV 文件。';

  @override
  String get csvFileEmpty => 'CSV 文件为空';

  @override
  String get csvNeedsDataRow => 'CSV 文件必须至少包含一行数据';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return '第 $row 行的列数不足：$count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return '第 $row 行的 $field 值无效：$value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return '第 $row 行的 $field 数据类型无效：$type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return '计划 ID 应为整数，但收到“$value”';
  }

  @override
  String get unitLabel => '单位';

  @override
  String get kilogramsUnit => '千克 (kg)';

  @override
  String get poundsUnit => '磅 (lb)';

  @override
  String get stoneUnit => '英石';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => '千米 (km)';

  @override
  String get milesUnit => '英里 (mi)';

  @override
  String get metersUnit => '米 (m)';

  @override
  String get kilocaloriesUnit => '千卡 (kcal)';

  @override
  String get enterWeight => '输入重量';

  @override
  String get requiredField => '必填';

  @override
  String get invalidNumber => '数字无效';

  @override
  String get previousWeight => '上次重量';

  @override
  String get imageLabel => '图片';

  @override
  String get longPressToDelete => '长按删除';

  @override
  String get imageError => '图片错误';

  @override
  String get actionSave => '保存';

  @override
  String get aboutTitle => '关于';

  @override
  String get donate => '捐赠';

  @override
  String get helpSupportProject => '支持此项目';

  @override
  String get whatsNewAbout => '更新内容';

  @override
  String get whatsNewTitle => '更新内容';

  @override
  String get seeReleaseNotes => '查看版本说明';

  @override
  String get versionLabel => '版本';

  @override
  String get authorLabel => '作者';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get privacyPolicyDescription => 'Flexify 如何处理你的数据';

  @override
  String get licenseLabel => '许可证';

  @override
  String get sourceCode => '源代码';

  @override
  String get sourceCodeDescription => '在 GitHub 上查看';

  @override
  String get leaveReview => '留下评价';

  @override
  String get leaveReviewDescription => '在 Play 商店评价 Flexify';

  @override
  String get reportBug => '报告错误';

  @override
  String get reportBugDescription => '在 GitHub 上提交问题';

  @override
  String get failedMigrations => '迁移失败';

  @override
  String get errorMessageLabel => '错误信息：';

  @override
  String get createIssue => '创建问题';

  @override
  String get addExercise => '添加动作';

  @override
  String get cardio => '有氧';

  @override
  String get strength => '力量';

  @override
  String get options => '选项';

  @override
  String get periodDay => '天';

  @override
  String get periodWeek => '周';

  @override
  String get periodMonth => '月';

  @override
  String get periodYear => '年';

  @override
  String noDataFor(String name) {
    return '暂无 $name 的数据';
  }

  @override
  String get noDataYet => '暂无数据';

  @override
  String get exerciseNotes => '动作备注';

  @override
  String get notesForExercise => '此动作的备注';

  @override
  String get useTimeBasedXAxis => '使用基于时间的 X 轴';

  @override
  String updateAllNamed(String name) {
    return '更新所有 $name';
  }

  @override
  String get newName => '新名称';

  @override
  String get restMinutes => '休息分钟数';

  @override
  String get restSeconds => '休息秒数';

  @override
  String get globalProgress => '总体进度';

  @override
  String get curveLineGraphs => '图表曲线';

  @override
  String get curveLineGraphsDescription => '将图表线条绘制为平滑曲线';

  @override
  String noHistoryFor(String name) {
    return '暂无 $name 的历史记录';
  }

  @override
  String get cancelSelection => '取消选择';

  @override
  String get editSelected => '编辑所选项';

  @override
  String get newExercise => '新动作';

  @override
  String get noGraphsFound => '未找到图表';

  @override
  String get searchGraphs => '搜索图表...';

  @override
  String get actionAdd => '添加';

  @override
  String get actionUpdate => '更新';

  @override
  String get hideGlobalProgress => '隐藏总体进度';

  @override
  String get chartGroupedByCategory => '按类别分组的图表';

  @override
  String get noExercisesFound => '未找到动作';

  @override
  String get savePlan => '保存计划';

  @override
  String get titleOptional => '标题（可选）';

  @override
  String get searchExercises => '搜索动作...';

  @override
  String get warmupSets => '热身组';

  @override
  String get workingSetsMax => '正式组（最多：20）';

  @override
  String get actionUndo => '撤销';

  @override
  String get actionSwap => '替换';

  @override
  String get daily => '每天';

  @override
  String get weekly => '每周';

  @override
  String get monthly => '每月';

  @override
  String get yearly => '每年';

  @override
  String get unexpectedError => '出现问题。请重试。';

  @override
  String get loadingExercises => '正在加载动作...';

  @override
  String get noPlansYet => '暂无计划';

  @override
  String get noMatchingPlans => '没有匹配的计划';

  @override
  String get newPlan => '新计划';

  @override
  String get searchPlans => '搜索计划...';

  @override
  String get noExercisesYet => '暂无动作';

  @override
  String get editPlan => '编辑计划';

  @override
  String get saveSet => '保存组';

  @override
  String get minutesLabel => '分钟';

  @override
  String get minutesShort => '分钟';

  @override
  String get secondsLabel => '秒';

  @override
  String get distanceLabel => '距离';

  @override
  String get inclinePercent => '坡度 %';

  @override
  String weightWithUnit(String unit) {
    return '重量 ($unit)';
  }

  @override
  String get useBodyWeight => '使用自重';

  @override
  String get noWeightEnteredYet => '尚未输入重量';

  @override
  String get notesLabel => '备注';

  @override
  String get swapWorkout => '替换训练';

  @override
  String get addSet => '添加一组';

  @override
  String get deleteSet => '删除此组';

  @override
  String get oneRepMaxEstimate => '1RM（估算）';

  @override
  String get valueLabel => '数值';

  @override
  String amountWithUnit(String unit) {
    return '数值 ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return '距离 ($unit)';
  }

  @override
  String get bodyWeightLabel => '体重';

  @override
  String bodyWeightWithUnit(String unit) {
    return '体重 ($unit)';
  }

  @override
  String get categoryHelper => '选择现有分类或输入新分类。';

  @override
  String get manageCategories => '管理分类';

  @override
  String get manageCategoriesDescription => '创建、重命名、合并或删除分类';

  @override
  String get newCategory => '新建分类';

  @override
  String get renameCategory => '重命名分类';

  @override
  String get mergeCategory => '合并到其他分类';

  @override
  String get noCategories => '暂无分类';

  @override
  String get categoryNameRequired => '请输入分类名称';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个条目使用此分类',
      one: '1 个条目使用此分类',
      zero: '没有条目使用此分类',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '删除此分类并将其从 $count 个条目中移除？',
      one: '删除此分类并将其从 1 个条目中移除？',
      zero: '删除此分类？',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => '创建日期';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '编辑 $count 组',
      one: '编辑 1 组',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => '暂无记录';

  @override
  String get historyEmptyMessage => '完成一组或手动添加一组，即可开始记录历史。';

  @override
  String deleteSetConfirmation(String name) {
    return '确定要删除 $name 吗？';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '确定要删除 $count 条记录吗？',
      one: '确定要删除 1 条记录吗？',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => '搜索历史...';

  @override
  String get themeSystem => '系统';

  @override
  String get themeDark => '深色';

  @override
  String get themeLight => '浅色';

  @override
  String get pureBlackAmoled => '纯黑 (AMOLED)';

  @override
  String get showImages => '显示图片';

  @override
  String get peekGraph => '预览图表';

  @override
  String get inputStyleLine => '下划线';

  @override
  String get inputStyleOutlined => '边框';

  @override
  String get inputStyleFilled => '填充';

  @override
  String get inputStyle => '输入框样式';

  @override
  String get appearance => '外观';

  @override
  String get automaticBackupsEnabled => '已启用自动备份';

  @override
  String get automaticBackup => '自动备份';

  @override
  String get appPermissions => '应用权限';

  @override
  String get shareDatabase => '分享数据库';

  @override
  String get dataManagement => '数据管理';

  @override
  String get strengthUnit => '力量单位';

  @override
  String get lastEntry => '最近记录';

  @override
  String get cardioUnit => '有氧单位';

  @override
  String longDateFormat(String format) {
    return '长日期格式 ($format)';
  }

  @override
  String get formats => '格式';

  @override
  String get setsPerExerciseMax => '每个动作的组数（最多：20）';

  @override
  String get countLabel => '数量';

  @override
  String get ratioLabel => '比例';

  @override
  String get reorder => '重新排序';

  @override
  String get none => '无';

  @override
  String get monday => '星期一';

  @override
  String get examplePlanExercises => '卧推、深蹲、硬拉';

  @override
  String get tabs => '标签页';

  @override
  String get swipeBetweenTabs => '滑动切换标签页';

  @override
  String get vibrate => '振动';

  @override
  String get enableSound => '启用声音';

  @override
  String get keepScreenOn => '保持屏幕常亮';

  @override
  String get alarmSound => '闹钟声音';

  @override
  String get top => '顶部';

  @override
  String get bottom => '底部';

  @override
  String get removeCustomTimer => '移除自定义计时器（使用全局默认值）';

  @override
  String get timers => '计时器';

  @override
  String get timerSettings => '计时器设置';

  @override
  String get groupHistory => '合并历史记录';

  @override
  String get showUnits => '显示单位';

  @override
  String get showBodyWeight => '显示体重';

  @override
  String get showCategories => '显示类别';

  @override
  String get showNotes => '显示备注';

  @override
  String get repEstimation => '次数估算';

  @override
  String get durationEstimation => '时长估算';

  @override
  String get showGraphLimit => '显示图表限制';

  @override
  String get defaultGraphMetric => '默认图表指标';

  @override
  String get bestWeight => '最高重量';

  @override
  String get bestReps => '最多次数';

  @override
  String get oneRepMax => '1RM';

  @override
  String get volume => '训练量';

  @override
  String get paceCardio => '配速（有氧）';

  @override
  String get distanceCardio => '距离（有氧）';

  @override
  String get defaultGraphPeriod => '默认图表周期';

  @override
  String get defaultGraphLimit => '默认图表限制';

  @override
  String get workouts => '训练';

  @override
  String get actionStop => '停止';

  @override
  String get timerFinishedToast => '计时结束！';

  @override
  String get stopTimer => '停止计时器';

  @override
  String get actionPause => '暂停';

  @override
  String get startStopwatch => '启动秒表';

  @override
  String get actionStart => '开始';

  @override
  String get actionRestart => '重新开始';

  @override
  String get addOneMinute => '+1 分钟';

  @override
  String get addOneMinuteNotification => '增加 1 分钟';

  @override
  String get restTimer => '休息计时器';

  @override
  String get timerUp => '时间到';

  @override
  String get openNotification => '打开通知';

  @override
  String get timerChannelName => '计时器通知';

  @override
  String get timerChannelDescription => '持续显示休息计时器的进度。';

  @override
  String get timerFinishedChannelName => '计时结束通知';

  @override
  String get timerFinishedChannelDescription => '休息计时器结束时播放闹钟。';

  @override
  String get timerFinished => '计时结束';

  @override
  String get batteryOptimizationRequestUnavailable => '你的设备已禁用忽略电池优化的请求。';

  @override
  String get exactAlarmRequestUnavailable => '你的设备拒绝了 SCHEDULE_EXACT_ALARM 请求';

  @override
  String get databaseMigrationFailureDescription =>
      '创建或升级数据库时出现问题。通常可以通过删除并重新创建记录来修复。';

  @override
  String get curveSmoothness => '曲线平滑度';

  @override
  String get actionBack => '返回';

  @override
  String get atLeastOneTab => '至少需要一个标签页';

  @override
  String get invalidTabSettings => '标签页设置无效。';

  @override
  String get noSettingsFound => '未找到设置';

  @override
  String nothingMatchesSearch(String query) {
    return '没有与“$query”匹配的内容。';
  }

  @override
  String get appearanceDescription => '主题、颜色和界面样式';

  @override
  String get dataManagementDescription => '导入、导出和管理训练数据';

  @override
  String get formatsDescription => '日期、数字和测量单位格式';

  @override
  String get plansSettingsDescription => '训练计划的默认设置和行为';

  @override
  String get tabsDescription => '选择并排列主要导航标签页';

  @override
  String get timersDescription => '休息计时器的时长、声音和行为';

  @override
  String get workoutsDescription => '动作记录和训练偏好';

  @override
  String get completeSetForChart => '完成此动作的一组训练即可生成图表。';

  @override
  String get dateRange => '日期范围';

  @override
  String get stopDate => '结束日期';

  @override
  String get dataPoints => '数据点';

  @override
  String get completeSetsForProgress => '完成几组训练即可生成进度图表。';

  @override
  String get relativeStrength => '相对力量';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已选择 $count 项',
      one: '已选择 1 项',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory => '完成几组训练，即可在此查看该动作的历史记录。';

  @override
  String get completeSetForFirstGraph => '完成一组训练即可创建第一个动作图表。';

  @override
  String nothingMatchesGraphSearch(String query) {
    return '没有与“$query”匹配的内容。你可以将其创建为新动作。';
  }

  @override
  String addNamed(String name) {
    return '添加“$name”';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return '这将删除 $count 条记录。确定吗？';
  }

  @override
  String shareWorkout(String summary) {
    return '我刚完成了 $summary';
  }

  @override
  String get updateConflict => '更新冲突';

  @override
  String updateConflictDescription(int count) {
    return '新名称已存在于 $count 条记录中。确定要继续吗？';
  }

  @override
  String get unitsConflict => '单位冲突';

  @override
  String unitsConflictDescription(String unit) {
    return '并非所有记录都使用相同单位。此操作会将所有单位转换为 $unit。确定要继续吗？';
  }

  @override
  String get durationLabel => '时长';

  @override
  String get inclineLabel => '坡度';

  @override
  String get paceDistanceTime => '配速（距离 / 时间）';

  @override
  String get adjustedPace => '调整后配速';

  @override
  String get oneRepMaxAccuracyWarning => '当一组达到 10 次或更多次数时，1RM 估算的准确度会降低';

  @override
  String get addPlan => '添加计划';

  @override
  String get planDetails => '计划详情';

  @override
  String get exercisesLabel => '动作';

  @override
  String get addExerciseToPlan => '向此计划添加一个动作。';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return '没有与“$query”匹配的内容。你可以将其添加为新动作。';
  }

  @override
  String get selectDays => '选择日期';

  @override
  String get selectExercises => '选择动作';

  @override
  String get todayLabel => '今天';

  @override
  String get setDetails => '组详情';

  @override
  String get themeLabel => '主题';

  @override
  String get pureBlackAmoledDescription => '在 AMOLED 屏幕上使用纯黑色';

  @override
  String get systemColorScheme => '系统配色';

  @override
  String get systemColorSchemeDescription => '使用设备的主色作为应用配色';

  @override
  String get showImagesDescription => '在历史页面选择并显示图片';

  @override
  String get showGlobalProgress => '显示总体进度';

  @override
  String get showGlobalProgressDescription => '在图表中添加按类别展示进度的条目';

  @override
  String get peekGraphDescription => '在图表页面显示第一个折线图';

  @override
  String get inputStyleDescription => '文本输入框的视觉样式';

  @override
  String get automaticBackupNotificationBody => 'Flexify 每天会自动将数据和图片备份到所选文件夹。';

  @override
  String get backupSettingsChannel => '备份设置';

  @override
  String get backupSettingsChannelDescription => '说明自动备份的通知';

  @override
  String get backupChannelName => '备份通知';

  @override
  String get backupChannelDescription => '自动备份 Flexify 的数据和图片';

  @override
  String get backupCompletedTitle => '数据和图片备份完成';

  @override
  String get backupFailurePathNotSet => '备份失败：未设置备份路径。已禁用自动备份。';

  @override
  String get backupFailureDirectoryUnavailable => '备份失败：无法访问备份文件夹。已禁用自动备份。';

  @override
  String get backupFailureCreateFile => '备份失败：无法创建备份文件。已禁用自动备份。';

  @override
  String get backupFailureAppFilesUnavailable => '备份失败：无法访问应用文件目录。已禁用自动备份。';

  @override
  String get backupFailureDatabaseMissing => '备份失败：未找到数据库文件。已禁用自动备份。';

  @override
  String get backupFailureOutputUnavailable => '备份失败：无法打开输出流。已禁用自动备份。';

  @override
  String get backupFailureUnknown => '备份失败。已禁用自动备份。';

  @override
  String get appPermissionsDescription => '检查已启用功能所需的访问权限';

  @override
  String get longDateFormatDescription => '用于空间充足的界面';

  @override
  String shortDateFormat(String example) {
    return '短日期格式 ($example)';
  }

  @override
  String get shortDateFormatDescription => '用于空间较窄的界面（如图表线）';

  @override
  String get warmupSetsDescription => '热身组不使用休息计时器';

  @override
  String get setsPerExerciseDescription => '计划中的默认动作数量';

  @override
  String get planTrailingDisplay => '计划右侧显示内容';

  @override
  String get planTrailingDisplayDescription => '“计划”列表和计划详情右侧显示的内容';

  @override
  String get restTimersDescription => '完成一组后触发的闹钟';

  @override
  String get vibrateDescription => '休息计时器是否振动？';

  @override
  String get enableSoundDescription => '休息计时器是否播放声音？';

  @override
  String get keepScreenOnDescription => '休息计时器运行时保持屏幕常亮';

  @override
  String get restDurationDescription => '休息多久后触发提醒？';

  @override
  String get globalDefault => '全局默认值';

  @override
  String get alarmSoundDescription => '休息计时器结束时播放的音乐';

  @override
  String get progressBarPosition => '进度条位置';

  @override
  String get progressBarPositionDescription => '休息计时器的进度条应显示在哪里？';

  @override
  String get perExerciseRestTimes => '按动作设置休息时间';

  @override
  String get perExerciseRestTimesDescription => '这些动作使用自定义休息时长';

  @override
  String get audioFeaturesUnavailable => '音频功能不可用';

  @override
  String get groupHistoryDescription => '按日期合并历史记录';

  @override
  String get showUnitsDescription => '在图表、历史和计划中显示 km/mi、kg/lb';

  @override
  String get showBodyWeightDescription => '启用或禁用体重记录';

  @override
  String get showCategoriesDescription => '启用或禁用训练类别';

  @override
  String get showNotesDescription => '在文本框中记录训练详情';

  @override
  String get positiveNotificationsDescription => '创造新纪录时显示鼓励消息';

  @override
  String get positiveMessagesEnabled => '鼓励消息现在会这样显示！';

  @override
  String get recordEncouragement01 => '太棒了！你真的很厉害。';

  @override
  String get recordEncouragement02 => '干得漂亮，王者！你的进步令人振奋。';

  @override
  String get recordEncouragement03 => '我服了...';

  @override
  String get recordEncouragement04 => '这是什么？新纪录！';

  @override
  String get recordEncouragement05 => '太厉害了！你真让人受到鼓舞。';

  @override
  String get recordEncouragement06 => '哇。不错。';

  @override
  String get recordEncouragement07 => '越来越强了啊？';

  @override
  String get recordEncouragement08 => '是啊。你块头越来越大了。';

  @override
  String get recordEncouragement09 => '太棒了。真厉害。';

  @override
  String get recordEncouragement10 => '阿诺德会为你骄傲的。';

  @override
  String get recordEncouragement11 => 'Ronnie C 正开心地看着你。';

  @override
  String get recordEncouragement12 => '耶！轻重量，宝贝!!!!!!!';

  @override
  String get recordEncouragement13 => '这是新纪录吗？我就知道你能做到。';

  @override
  String get recordEncouragement14 => '太棒了！我为你骄傲。';

  @override
  String get recordEncouragement15 => '耶宝贝！轻轻松松！';

  @override
  String get recordEncouragement16 => '继续保持！进步很大。';

  @override
  String get recordEncouragement17 => '你做得非常好。';

  @override
  String get recordEncouragement18 => '这才对嘛！';

  @override
  String get recordEncouragement19 => '继续保持。';

  @override
  String get recordEncouragement20 => '你越来越强了。';

  @override
  String get recordEncouragement21 => '强大。';

  @override
  String get recordEncouragement22 => '力量爆棚！';

  @override
  String get recordEncouragement23 => '我为你骄傲。';

  @override
  String get recordEncouragement24 => '继续保持出色表现。';

  @override
  String get recordEncouragement25 => '挺起胸膛！你刚刚创造了新纪录。';

  @override
  String get recordEncouragement26 => '新纪录！你刚刚突破了自己的极限！';

  @override
  String get recordEncouragement27 => '没错！这是新纪录。';

  @override
  String get recordEncouragement28 => '哇！新纪录！';

  @override
  String get recordEncouragement29 => '真的做得很好。';

  @override
  String get repEstimationDescription => '尝试预测你刚完成的次数';

  @override
  String get durationEstimationDescription => '尝试预测有氧运动的持续时间';

  @override
  String get showGraphXAxisToggle => '显示图表 X 轴切换选项';

  @override
  String get showGraphXAxisToggleDescription => '在图表中显示基于时间的 X 轴切换选项';

  @override
  String get showGraphLimitDescription => '在图表中显示限制滑块';

  @override
  String get defaultTimeBasedXAxis => '默认使用基于时间的 X 轴';

  @override
  String get defaultTimeBasedXAxisDescription => '图表默认使用基于时间的 X 轴';

  @override
  String get createFirstTrainingPlan => '创建你的第一个训练计划即可开始。';

  @override
  String nothingMatchesPlanSearch(String query) {
    return '没有与“$query”匹配的内容。你可以将其创建为新计划。';
  }

  @override
  String get createPlan => '创建计划';

  @override
  String createNamedPlan(String name) {
    return '创建“$name”';
  }

  @override
  String setNumber(int number) {
    return '第 $number 组';
  }
}

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn() : super('zh_CN');

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageDescription => '选择 Flexify 使用的语言';

  @override
  String get languageSystemDefault => '跟随系统';

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
  String get navHistory => '历史';

  @override
  String get navPlans => '计划';

  @override
  String get navGraphs => '图表';

  @override
  String get navTimer => '计时器';

  @override
  String get navSettings => '设置';

  @override
  String get errorLabel => '错误';

  @override
  String get tabContentError => '无法显示此标签页的内容。';

  @override
  String get cannotHideAllTabs => '不能隐藏所有标签页！';

  @override
  String removeTabQuestion(String tab) {
    return '移除“$tab”标签页？';
  }

  @override
  String get restoreTabFromSettings => '之后可以在设置中重新添加。';

  @override
  String removedTab(String tab) {
    return '已移除“$tab”';
  }

  @override
  String newVersion(String version) {
    return '新版本 $version';
  }

  @override
  String get changes => '更新内容';

  @override
  String get searchHint => '搜索...';

  @override
  String get deleteSelected => '删除所选项';

  @override
  String get confirmDelete => '确认删除';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '确定要删除 $count 条记录吗？此操作无法撤销。',
      one: '确定要删除 1 条记录吗？此操作无法撤销。',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => '取消';

  @override
  String get actionDelete => '删除';

  @override
  String get actionRemove => '移除';

  @override
  String get actionEdit => '编辑';

  @override
  String get actionShare => '分享';

  @override
  String get clearSelection => '清除选择';

  @override
  String get clearSearch => '清除搜索';

  @override
  String get showMenu => '显示菜单';

  @override
  String get selectAll => '全选';

  @override
  String get weightLabel => '重量';

  @override
  String get filter => '筛选';

  @override
  String get filters => '筛选条件';

  @override
  String get categoryLabel => '类别';

  @override
  String get repsLabel => '次数';

  @override
  String get repsFilter => '次数筛选';

  @override
  String get weightFilter => '重量筛选';

  @override
  String get greaterThan => '大于';

  @override
  String get lessThan => '小于';

  @override
  String get startDate => '开始日期';

  @override
  String get endDate => '结束日期';

  @override
  String get actionClear => '清除';

  @override
  String get actionOk => '确定';

  @override
  String get actionClose => '关闭';

  @override
  String get sortBy => '排序方式';

  @override
  String get dateNewest => '日期（最新）';

  @override
  String get dateOldest => '日期（最早）';

  @override
  String get nameLabel => '名称';

  @override
  String get missingPermissions => '缺少权限';

  @override
  String get restTimersPermissionsMissing => '已启用休息计时器，但缺少所需权限。';

  @override
  String get restTimersPermissionsOptional => '如果关闭休息计时器，则不需要这些权限。';

  @override
  String get restTimers => '休息计时器';

  @override
  String get disableBatteryOptimizations => '关闭电池优化';

  @override
  String get batteryOptimizationWarning => '如果保持电池优化开启，计时进度可能暂停。';

  @override
  String get scheduleExactAlarm => '设置精确闹钟';

  @override
  String get exactAlarmWarning => '如果关闭此功能，闹钟时间可能不准确。';

  @override
  String get postNotifications => '显示通知';

  @override
  String get notificationBarDescription => '在通知栏中显示计时器进度';

  @override
  String get invalidPermissions => '权限不足';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      '休息计时器已启用，但所需权限不足。确定要继续吗？';

  @override
  String get actionConfirm => '确认';

  @override
  String get appAccess => '应用访问权限';

  @override
  String get appAccessDescription => '已启用的计时器和通知需要这些权限。';

  @override
  String get notifications => '通知';

  @override
  String get timerProgressAndRestAlerts => '计时进度和休息提醒';

  @override
  String get enabledNotificationsDescription => '你已启用的通知';

  @override
  String get backgroundActivity => '后台活动';

  @override
  String get backgroundActivityDescription => '确保计时器在后台稳定运行';

  @override
  String get exactAlarms => '精确闹钟';

  @override
  String get exactAlarmsDescription => '在休息计时器结束时准时提醒';

  @override
  String get noAdditionalAndroidAccessNeeded => '当前设置无需额外的 Android 访问权限。';

  @override
  String get actionDone => '完成';

  @override
  String get allowed => '已允许';

  @override
  String get actionAllow => '允许';

  @override
  String get backupLabel => '备份';

  @override
  String get databaseLabel => '数据库';

  @override
  String get deleteRecords => '删除记录';

  @override
  String get deleteAllGraphsConfirmation => '确定要删除所有图表吗？此操作无法撤销。';

  @override
  String get deleteAllPlansConfirmation => '确定要删除所有计划吗？此操作无法撤销。';

  @override
  String get deleteDatabaseConfirmation => '确定要删除数据库吗？此操作无法撤销，并会清除所有数据。';

  @override
  String get importData => '导入数据';

  @override
  String get exportData => '导出数据';

  @override
  String get actionReport => '报告';

  @override
  String get graphDataImported => '图表数据导入成功！';

  @override
  String get plansImported => '计划导入成功';

  @override
  String failedToImportDatabase(String error) {
    return '数据库导入失败：$error';
  }

  @override
  String get backupArchiveMissingDatabase => '备份中不包含 Flexify 数据库。';

  @override
  String failedToImportGraphs(String error) {
    return '图表导入失败：$error';
  }

  @override
  String failedToImportPlans(String error) {
    return '计划导入失败：$error';
  }

  @override
  String get selectedFileDoesNotExist => '所选文件不存在';

  @override
  String get couldNotReadFileData => '无法读取文件数据';

  @override
  String get databaseImportWebUnsupported =>
      '网页端导入数据库需要手动迁移数据。请将数据导出为 CSV 文件，再导入这些 CSV 文件。';

  @override
  String get csvFileEmpty => 'CSV 文件为空';

  @override
  String get csvNeedsDataRow => 'CSV 文件必须至少包含一行数据';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return '第 $row 行的列数不足：$count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return '第 $row 行的 $field 值无效：$value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return '第 $row 行的 $field 数据类型无效：$type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return '计划 ID 应为整数，但收到“$value”';
  }

  @override
  String get unitLabel => '单位';

  @override
  String get kilogramsUnit => '千克 (kg)';

  @override
  String get poundsUnit => '磅 (lb)';

  @override
  String get stoneUnit => '英石';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => '千米 (km)';

  @override
  String get milesUnit => '英里 (mi)';

  @override
  String get metersUnit => '米 (m)';

  @override
  String get kilocaloriesUnit => '千卡 (kcal)';

  @override
  String get enterWeight => '输入重量';

  @override
  String get requiredField => '必填';

  @override
  String get invalidNumber => '数字无效';

  @override
  String get previousWeight => '上次重量';

  @override
  String get imageLabel => '图片';

  @override
  String get longPressToDelete => '长按删除';

  @override
  String get imageError => '图片错误';

  @override
  String get actionSave => '保存';

  @override
  String get aboutTitle => '关于';

  @override
  String get donate => '捐赠';

  @override
  String get helpSupportProject => '支持此项目';

  @override
  String get whatsNewAbout => '更新内容';

  @override
  String get whatsNewTitle => '更新内容';

  @override
  String get seeReleaseNotes => '查看版本说明';

  @override
  String get versionLabel => '版本';

  @override
  String get authorLabel => '作者';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get privacyPolicyDescription => 'Flexify 如何处理你的数据';

  @override
  String get licenseLabel => '许可证';

  @override
  String get sourceCode => '源代码';

  @override
  String get sourceCodeDescription => '在 GitHub 上查看';

  @override
  String get leaveReview => '留下评价';

  @override
  String get leaveReviewDescription => '在 Play 商店评价 Flexify';

  @override
  String get reportBug => '报告错误';

  @override
  String get reportBugDescription => '在 GitHub 上提交问题';

  @override
  String get failedMigrations => '迁移失败';

  @override
  String get errorMessageLabel => '错误信息：';

  @override
  String get createIssue => '创建问题';

  @override
  String get addExercise => '添加动作';

  @override
  String get cardio => '有氧';

  @override
  String get strength => '力量';

  @override
  String get options => '选项';

  @override
  String get periodDay => '天';

  @override
  String get periodWeek => '周';

  @override
  String get periodMonth => '月';

  @override
  String get periodYear => '年';

  @override
  String noDataFor(String name) {
    return '暂无 $name 的数据';
  }

  @override
  String get noDataYet => '暂无数据';

  @override
  String get exerciseNotes => '动作备注';

  @override
  String get notesForExercise => '此动作的备注';

  @override
  String get useTimeBasedXAxis => '使用基于时间的 X 轴';

  @override
  String updateAllNamed(String name) {
    return '更新所有 $name';
  }

  @override
  String get newName => '新名称';

  @override
  String get restMinutes => '休息分钟数';

  @override
  String get restSeconds => '休息秒数';

  @override
  String get globalProgress => '总体进度';

  @override
  String get curveLineGraphs => '图表曲线';

  @override
  String get curveLineGraphsDescription => '将图表线条绘制为平滑曲线';

  @override
  String noHistoryFor(String name) {
    return '暂无 $name 的历史记录';
  }

  @override
  String get cancelSelection => '取消选择';

  @override
  String get editSelected => '编辑所选项';

  @override
  String get newExercise => '新动作';

  @override
  String get noGraphsFound => '未找到图表';

  @override
  String get searchGraphs => '搜索图表...';

  @override
  String get actionAdd => '添加';

  @override
  String get actionUpdate => '更新';

  @override
  String get hideGlobalProgress => '隐藏总体进度';

  @override
  String get chartGroupedByCategory => '按类别分组的图表';

  @override
  String get noExercisesFound => '未找到动作';

  @override
  String get savePlan => '保存计划';

  @override
  String get titleOptional => '标题（可选）';

  @override
  String get searchExercises => '搜索动作...';

  @override
  String get warmupSets => '热身组';

  @override
  String get workingSetsMax => '正式组（最多：20）';

  @override
  String get actionUndo => '撤销';

  @override
  String get actionSwap => '替换';

  @override
  String get daily => '每天';

  @override
  String get weekly => '每周';

  @override
  String get monthly => '每月';

  @override
  String get yearly => '每年';

  @override
  String get unexpectedError => '出现问题。请重试。';

  @override
  String get loadingExercises => '正在加载动作...';

  @override
  String get noPlansYet => '暂无计划';

  @override
  String get noMatchingPlans => '没有匹配的计划';

  @override
  String get newPlan => '新计划';

  @override
  String get searchPlans => '搜索计划...';

  @override
  String get noExercisesYet => '暂无动作';

  @override
  String get editPlan => '编辑计划';

  @override
  String get saveSet => '保存组';

  @override
  String get minutesLabel => '分钟';

  @override
  String get minutesShort => '分钟';

  @override
  String get secondsLabel => '秒';

  @override
  String get distanceLabel => '距离';

  @override
  String get inclinePercent => '坡度 %';

  @override
  String weightWithUnit(String unit) {
    return '重量 ($unit)';
  }

  @override
  String get useBodyWeight => '使用自重';

  @override
  String get noWeightEnteredYet => '尚未输入重量';

  @override
  String get notesLabel => '备注';

  @override
  String get swapWorkout => '替换训练';

  @override
  String get addSet => '添加一组';

  @override
  String get deleteSet => '删除此组';

  @override
  String get oneRepMaxEstimate => '1RM（估算）';

  @override
  String get valueLabel => '数值';

  @override
  String amountWithUnit(String unit) {
    return '数值 ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return '距离 ($unit)';
  }

  @override
  String get bodyWeightLabel => '体重';

  @override
  String bodyWeightWithUnit(String unit) {
    return '体重 ($unit)';
  }

  @override
  String get categoryHelper => '选择现有分类或输入新分类。';

  @override
  String get manageCategories => '管理分类';

  @override
  String get manageCategoriesDescription => '创建、重命名、合并或删除分类';

  @override
  String get newCategory => '新建分类';

  @override
  String get renameCategory => '重命名分类';

  @override
  String get mergeCategory => '合并到其他分类';

  @override
  String get noCategories => '暂无分类';

  @override
  String get categoryNameRequired => '请输入分类名称';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个条目使用此分类',
      one: '1 个条目使用此分类',
      zero: '没有条目使用此分类',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '删除此分类并将其从 $count 个条目中移除？',
      one: '删除此分类并将其从 1 个条目中移除？',
      zero: '删除此分类？',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => '创建日期';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '编辑 $count 组',
      one: '编辑 1 组',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => '暂无记录';

  @override
  String get historyEmptyMessage => '完成一组或手动添加一组，即可开始记录历史。';

  @override
  String deleteSetConfirmation(String name) {
    return '确定要删除 $name 吗？';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '确定要删除 $count 条记录吗？',
      one: '确定要删除 1 条记录吗？',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => '搜索历史...';

  @override
  String get themeSystem => '系统';

  @override
  String get themeDark => '深色';

  @override
  String get themeLight => '浅色';

  @override
  String get pureBlackAmoled => '纯黑 (AMOLED)';

  @override
  String get showImages => '显示图片';

  @override
  String get peekGraph => '预览图表';

  @override
  String get inputStyleLine => '下划线';

  @override
  String get inputStyleOutlined => '边框';

  @override
  String get inputStyleFilled => '填充';

  @override
  String get inputStyle => '输入框样式';

  @override
  String get appearance => '外观';

  @override
  String get automaticBackupsEnabled => '已启用自动备份';

  @override
  String get automaticBackup => '自动备份';

  @override
  String get appPermissions => '应用权限';

  @override
  String get shareDatabase => '分享数据库';

  @override
  String get dataManagement => '数据管理';

  @override
  String get strengthUnit => '力量单位';

  @override
  String get lastEntry => '最近记录';

  @override
  String get cardioUnit => '有氧单位';

  @override
  String longDateFormat(String format) {
    return '长日期格式 ($format)';
  }

  @override
  String get formats => '格式';

  @override
  String get setsPerExerciseMax => '每个动作的组数（最多：20）';

  @override
  String get countLabel => '数量';

  @override
  String get ratioLabel => '比例';

  @override
  String get reorder => '重新排序';

  @override
  String get none => '无';

  @override
  String get monday => '星期一';

  @override
  String get examplePlanExercises => '卧推、深蹲、硬拉';

  @override
  String get tabs => '标签页';

  @override
  String get swipeBetweenTabs => '滑动切换标签页';

  @override
  String get vibrate => '振动';

  @override
  String get enableSound => '启用声音';

  @override
  String get keepScreenOn => '保持屏幕常亮';

  @override
  String get alarmSound => '闹钟声音';

  @override
  String get top => '顶部';

  @override
  String get bottom => '底部';

  @override
  String get removeCustomTimer => '移除自定义计时器（使用全局默认值）';

  @override
  String get timers => '计时器';

  @override
  String get timerSettings => '计时器设置';

  @override
  String get groupHistory => '合并历史记录';

  @override
  String get showUnits => '显示单位';

  @override
  String get showBodyWeight => '显示体重';

  @override
  String get showCategories => '显示类别';

  @override
  String get showNotes => '显示备注';

  @override
  String get repEstimation => '次数估算';

  @override
  String get durationEstimation => '时长估算';

  @override
  String get showGraphLimit => '显示图表限制';

  @override
  String get defaultGraphMetric => '默认图表指标';

  @override
  String get bestWeight => '最高重量';

  @override
  String get bestReps => '最多次数';

  @override
  String get oneRepMax => '1RM';

  @override
  String get volume => '训练量';

  @override
  String get paceCardio => '配速（有氧）';

  @override
  String get distanceCardio => '距离（有氧）';

  @override
  String get defaultGraphPeriod => '默认图表周期';

  @override
  String get defaultGraphLimit => '默认图表限制';

  @override
  String get workouts => '训练';

  @override
  String get actionStop => '停止';

  @override
  String get timerFinishedToast => '计时结束！';

  @override
  String get stopTimer => '停止计时器';

  @override
  String get actionPause => '暂停';

  @override
  String get startStopwatch => '启动秒表';

  @override
  String get actionStart => '开始';

  @override
  String get actionRestart => '重新开始';

  @override
  String get addOneMinute => '+1 分钟';

  @override
  String get addOneMinuteNotification => '增加 1 分钟';

  @override
  String get restTimer => '休息计时器';

  @override
  String get timerUp => '时间到';

  @override
  String get openNotification => '打开通知';

  @override
  String get timerChannelName => '计时器通知';

  @override
  String get timerChannelDescription => '持续显示休息计时器的进度。';

  @override
  String get timerFinishedChannelName => '计时结束通知';

  @override
  String get timerFinishedChannelDescription => '休息计时器结束时播放闹钟。';

  @override
  String get timerFinished => '计时结束';

  @override
  String get batteryOptimizationRequestUnavailable => '你的设备已禁用忽略电池优化的请求。';

  @override
  String get exactAlarmRequestUnavailable => '你的设备拒绝了 SCHEDULE_EXACT_ALARM 请求';

  @override
  String get databaseMigrationFailureDescription =>
      '创建或升级数据库时出现问题。通常可以通过删除并重新创建记录来修复。';

  @override
  String get curveSmoothness => '曲线平滑度';

  @override
  String get actionBack => '返回';

  @override
  String get atLeastOneTab => '至少需要一个标签页';

  @override
  String get invalidTabSettings => '标签页设置无效。';

  @override
  String get noSettingsFound => '未找到设置';

  @override
  String nothingMatchesSearch(String query) {
    return '没有与“$query”匹配的内容。';
  }

  @override
  String get appearanceDescription => '主题、颜色和界面样式';

  @override
  String get dataManagementDescription => '导入、导出和管理训练数据';

  @override
  String get formatsDescription => '日期、数字和测量单位格式';

  @override
  String get plansSettingsDescription => '训练计划的默认设置和行为';

  @override
  String get tabsDescription => '选择并排列主要导航标签页';

  @override
  String get timersDescription => '休息计时器的时长、声音和行为';

  @override
  String get workoutsDescription => '动作记录和训练偏好';

  @override
  String get completeSetForChart => '完成此动作的一组训练即可生成图表。';

  @override
  String get dateRange => '日期范围';

  @override
  String get stopDate => '结束日期';

  @override
  String get dataPoints => '数据点';

  @override
  String get completeSetsForProgress => '完成几组训练即可生成进度图表。';

  @override
  String get relativeStrength => '相对力量';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已选择 $count 项',
      one: '已选择 1 项',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory => '完成几组训练，即可在此查看该动作的历史记录。';

  @override
  String get completeSetForFirstGraph => '完成一组训练即可创建第一个动作图表。';

  @override
  String nothingMatchesGraphSearch(String query) {
    return '没有与“$query”匹配的内容。你可以将其创建为新动作。';
  }

  @override
  String addNamed(String name) {
    return '添加“$name”';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return '这将删除 $count 条记录。确定吗？';
  }

  @override
  String shareWorkout(String summary) {
    return '我刚完成了 $summary';
  }

  @override
  String get updateConflict => '更新冲突';

  @override
  String updateConflictDescription(int count) {
    return '新名称已存在于 $count 条记录中。确定要继续吗？';
  }

  @override
  String get unitsConflict => '单位冲突';

  @override
  String unitsConflictDescription(String unit) {
    return '并非所有记录都使用相同单位。此操作会将所有单位转换为 $unit。确定要继续吗？';
  }

  @override
  String get durationLabel => '时长';

  @override
  String get inclineLabel => '坡度';

  @override
  String get paceDistanceTime => '配速（距离 / 时间）';

  @override
  String get adjustedPace => '调整后配速';

  @override
  String get oneRepMaxAccuracyWarning => '当一组达到 10 次或更多次数时，1RM 估算的准确度会降低';

  @override
  String get addPlan => '添加计划';

  @override
  String get planDetails => '计划详情';

  @override
  String get exercisesLabel => '动作';

  @override
  String get addExerciseToPlan => '向此计划添加一个动作。';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return '没有与“$query”匹配的内容。你可以将其添加为新动作。';
  }

  @override
  String get selectDays => '选择日期';

  @override
  String get selectExercises => '选择动作';

  @override
  String get todayLabel => '今天';

  @override
  String get setDetails => '组详情';

  @override
  String get themeLabel => '主题';

  @override
  String get pureBlackAmoledDescription => '在 AMOLED 屏幕上使用纯黑色';

  @override
  String get systemColorScheme => '系统配色';

  @override
  String get systemColorSchemeDescription => '使用设备的主色作为应用配色';

  @override
  String get showImagesDescription => '在历史页面选择并显示图片';

  @override
  String get showGlobalProgress => '显示总体进度';

  @override
  String get showGlobalProgressDescription => '在图表中添加按类别展示进度的条目';

  @override
  String get peekGraphDescription => '在图表页面显示第一个折线图';

  @override
  String get inputStyleDescription => '文本输入框的视觉样式';

  @override
  String get automaticBackupNotificationBody => 'Flexify 每天会自动将数据和图片备份到所选文件夹。';

  @override
  String get backupSettingsChannel => '备份设置';

  @override
  String get backupSettingsChannelDescription => '说明自动备份的通知';

  @override
  String get backupChannelName => '备份通知';

  @override
  String get backupChannelDescription => '自动备份 Flexify 的数据和图片';

  @override
  String get backupCompletedTitle => '数据和图片备份完成';

  @override
  String get backupFailurePathNotSet => '备份失败：未设置备份路径。已禁用自动备份。';

  @override
  String get backupFailureDirectoryUnavailable => '备份失败：无法访问备份文件夹。已禁用自动备份。';

  @override
  String get backupFailureCreateFile => '备份失败：无法创建备份文件。已禁用自动备份。';

  @override
  String get backupFailureAppFilesUnavailable => '备份失败：无法访问应用文件目录。已禁用自动备份。';

  @override
  String get backupFailureDatabaseMissing => '备份失败：未找到数据库文件。已禁用自动备份。';

  @override
  String get backupFailureOutputUnavailable => '备份失败：无法打开输出流。已禁用自动备份。';

  @override
  String get backupFailureUnknown => '备份失败。已禁用自动备份。';

  @override
  String get appPermissionsDescription => '检查已启用功能所需的访问权限';

  @override
  String get longDateFormatDescription => '用于空间充足的界面';

  @override
  String shortDateFormat(String example) {
    return '短日期格式 ($example)';
  }

  @override
  String get shortDateFormatDescription => '用于空间较窄的界面（如图表线）';

  @override
  String get warmupSetsDescription => '热身组不使用休息计时器';

  @override
  String get setsPerExerciseDescription => '计划中的默认动作数量';

  @override
  String get planTrailingDisplay => '计划右侧显示内容';

  @override
  String get planTrailingDisplayDescription => '“计划”列表和计划详情右侧显示的内容';

  @override
  String get restTimersDescription => '完成一组后触发的闹钟';

  @override
  String get vibrateDescription => '休息计时器是否振动？';

  @override
  String get enableSoundDescription => '休息计时器是否播放声音？';

  @override
  String get keepScreenOnDescription => '休息计时器运行时保持屏幕常亮';

  @override
  String get restDurationDescription => '休息多久后触发提醒？';

  @override
  String get globalDefault => '全局默认值';

  @override
  String get alarmSoundDescription => '休息计时器结束时播放的音乐';

  @override
  String get progressBarPosition => '进度条位置';

  @override
  String get progressBarPositionDescription => '休息计时器的进度条应显示在哪里？';

  @override
  String get perExerciseRestTimes => '按动作设置休息时间';

  @override
  String get perExerciseRestTimesDescription => '这些动作使用自定义休息时长';

  @override
  String get audioFeaturesUnavailable => '音频功能不可用';

  @override
  String get groupHistoryDescription => '按日期合并历史记录';

  @override
  String get showUnitsDescription => '在图表、历史和计划中显示 km/mi、kg/lb';

  @override
  String get showBodyWeightDescription => '启用或禁用体重记录';

  @override
  String get showCategoriesDescription => '启用或禁用训练类别';

  @override
  String get showNotesDescription => '在文本框中记录训练详情';

  @override
  String get positiveNotificationsDescription => '创造新纪录时显示鼓励消息';

  @override
  String get positiveMessagesEnabled => '鼓励消息现在会这样显示！';

  @override
  String get recordEncouragement01 => '太棒了！你真的很厉害。';

  @override
  String get recordEncouragement02 => '干得漂亮，王者！你的进步令人振奋。';

  @override
  String get recordEncouragement03 => '我服了...';

  @override
  String get recordEncouragement04 => '这是什么？新纪录！';

  @override
  String get recordEncouragement05 => '太厉害了！你真让人受到鼓舞。';

  @override
  String get recordEncouragement06 => '哇。不错。';

  @override
  String get recordEncouragement07 => '越来越强了啊？';

  @override
  String get recordEncouragement08 => '是啊。你块头越来越大了。';

  @override
  String get recordEncouragement09 => '太棒了。真厉害。';

  @override
  String get recordEncouragement10 => '阿诺德会为你骄傲的。';

  @override
  String get recordEncouragement11 => 'Ronnie C 正开心地看着你。';

  @override
  String get recordEncouragement12 => '耶！轻重量，宝贝!!!!!!!';

  @override
  String get recordEncouragement13 => '这是新纪录吗？我就知道你能做到。';

  @override
  String get recordEncouragement14 => '太棒了！我为你骄傲。';

  @override
  String get recordEncouragement15 => '耶宝贝！轻轻松松！';

  @override
  String get recordEncouragement16 => '继续保持！进步很大。';

  @override
  String get recordEncouragement17 => '你做得非常好。';

  @override
  String get recordEncouragement18 => '这才对嘛！';

  @override
  String get recordEncouragement19 => '继续保持。';

  @override
  String get recordEncouragement20 => '你越来越强了。';

  @override
  String get recordEncouragement21 => '强大。';

  @override
  String get recordEncouragement22 => '力量爆棚！';

  @override
  String get recordEncouragement23 => '我为你骄傲。';

  @override
  String get recordEncouragement24 => '继续保持出色表现。';

  @override
  String get recordEncouragement25 => '挺起胸膛！你刚刚创造了新纪录。';

  @override
  String get recordEncouragement26 => '新纪录！你刚刚突破了自己的极限！';

  @override
  String get recordEncouragement27 => '没错！这是新纪录。';

  @override
  String get recordEncouragement28 => '哇！新纪录！';

  @override
  String get recordEncouragement29 => '真的做得很好。';

  @override
  String get repEstimationDescription => '尝试预测你刚完成的次数';

  @override
  String get durationEstimationDescription => '尝试预测有氧运动的持续时间';

  @override
  String get showGraphXAxisToggle => '显示图表 X 轴切换选项';

  @override
  String get showGraphXAxisToggleDescription => '在图表中显示基于时间的 X 轴切换选项';

  @override
  String get showGraphLimitDescription => '在图表中显示限制滑块';

  @override
  String get defaultTimeBasedXAxis => '默认使用基于时间的 X 轴';

  @override
  String get defaultTimeBasedXAxisDescription => '图表默认使用基于时间的 X 轴';

  @override
  String get createFirstTrainingPlan => '创建你的第一个训练计划即可开始。';

  @override
  String nothingMatchesPlanSearch(String query) {
    return '没有与“$query”匹配的内容。你可以将其创建为新计划。';
  }

  @override
  String get createPlan => '创建计划';

  @override
  String createNamedPlan(String name) {
    return '创建“$name”';
  }

  @override
  String setNumber(int number) {
    return '第 $number 组';
  }
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => '語言';

  @override
  String get settingsLanguageDescription => '選擇 Flexify 使用的語言';

  @override
  String get languageSystemDefault => '跟隨系統';

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
  String get navHistory => '歷史';

  @override
  String get navPlans => '計畫';

  @override
  String get navGraphs => '圖表';

  @override
  String get navTimer => '計時器';

  @override
  String get navSettings => '設定';

  @override
  String get errorLabel => '錯誤';

  @override
  String get tabContentError => '無法顯示此標籤頁的內容。';

  @override
  String get cannotHideAllTabs => '不能隱藏所有標籤頁！';

  @override
  String removeTabQuestion(String tab) {
    return '移除“$tab”標籤頁？';
  }

  @override
  String get restoreTabFromSettings => '之後可以在設定中重新新增。';

  @override
  String removedTab(String tab) {
    return '已移除“$tab”';
  }

  @override
  String newVersion(String version) {
    return '新版本 $version';
  }

  @override
  String get changes => '更新內容';

  @override
  String get searchHint => '搜尋...';

  @override
  String get deleteSelected => '刪除所選項';

  @override
  String get confirmDelete => '確認刪除';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '確定要刪除 $count 筆紀錄嗎？此操作無法撤銷。',
      one: '確定要刪除 1 筆紀錄嗎？此操作無法撤銷。',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => '取消';

  @override
  String get actionDelete => '刪除';

  @override
  String get actionRemove => '移除';

  @override
  String get actionEdit => '編輯';

  @override
  String get actionShare => '分享';

  @override
  String get clearSelection => '清除選擇';

  @override
  String get clearSearch => '清除搜尋';

  @override
  String get showMenu => '顯示選單';

  @override
  String get selectAll => '全選';

  @override
  String get weightLabel => '重量';

  @override
  String get filter => '篩選';

  @override
  String get filters => '篩選條件';

  @override
  String get categoryLabel => '類別';

  @override
  String get repsLabel => '次數';

  @override
  String get repsFilter => '次數篩選';

  @override
  String get weightFilter => '重量篩選';

  @override
  String get greaterThan => '大於';

  @override
  String get lessThan => '小於';

  @override
  String get startDate => '開始日期';

  @override
  String get endDate => '結束日期';

  @override
  String get actionClear => '清除';

  @override
  String get actionOk => '確定';

  @override
  String get actionClose => '關閉';

  @override
  String get sortBy => '排序方式';

  @override
  String get dateNewest => '日期（最新）';

  @override
  String get dateOldest => '日期（最早）';

  @override
  String get nameLabel => '名稱';

  @override
  String get missingPermissions => '缺少權限';

  @override
  String get restTimersPermissionsMissing => '已啟用休息計時器，但缺少所需權限。';

  @override
  String get restTimersPermissionsOptional => '如果關閉休息計時器，則不需要這些權限。';

  @override
  String get restTimers => '休息計時器';

  @override
  String get disableBatteryOptimizations => '關閉電池最佳化';

  @override
  String get batteryOptimizationWarning => '如果保持電池最佳化開啟，計時進度可能暫停。';

  @override
  String get scheduleExactAlarm => '設定精確鬧鐘';

  @override
  String get exactAlarmWarning => '如果關閉此功能，鬧鐘時間可能不準確。';

  @override
  String get postNotifications => '顯示通知';

  @override
  String get notificationBarDescription => '在通知欄中顯示計時器進度';

  @override
  String get invalidPermissions => '權限不足';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      '休息計時器已啟用，但所需權限不足。確定要繼續嗎？';

  @override
  String get actionConfirm => '確認';

  @override
  String get appAccess => '應用程式存取權限';

  @override
  String get appAccessDescription => '已啟用的計時器和通知需要這些權限。';

  @override
  String get notifications => '通知';

  @override
  String get timerProgressAndRestAlerts => '計時進度和休息提醒';

  @override
  String get enabledNotificationsDescription => '你已啟用的通知';

  @override
  String get backgroundActivity => '後臺活動';

  @override
  String get backgroundActivityDescription => '確保計時器在後臺穩定執行';

  @override
  String get exactAlarms => '精確鬧鐘';

  @override
  String get exactAlarmsDescription => '在休息計時器結束時準時提醒';

  @override
  String get noAdditionalAndroidAccessNeeded => '目前設定無需額外的 Android 存取權限。';

  @override
  String get actionDone => '完成';

  @override
  String get allowed => '已允許';

  @override
  String get actionAllow => '允許';

  @override
  String get backupLabel => '備份';

  @override
  String get databaseLabel => '資料庫';

  @override
  String get deleteRecords => '刪除記錄';

  @override
  String get deleteAllGraphsConfirmation => '確定要刪除所有圖表嗎？此操作無法撤銷。';

  @override
  String get deleteAllPlansConfirmation => '確定要刪除所有計畫嗎？此操作無法撤銷。';

  @override
  String get deleteDatabaseConfirmation => '確定要刪除資料庫嗎？此操作無法撤銷，並會清除所有資料。';

  @override
  String get importData => '匯入資料';

  @override
  String get exportData => '匯出資料';

  @override
  String get actionReport => '報告';

  @override
  String get graphDataImported => '圖表資料匯入成功！';

  @override
  String get plansImported => '計畫匯入成功';

  @override
  String failedToImportDatabase(String error) {
    return '資料庫匯入失敗：$error';
  }

  @override
  String get backupArchiveMissingDatabase => '備份中不包含 Flexify 資料庫。';

  @override
  String failedToImportGraphs(String error) {
    return '圖表匯入失敗：$error';
  }

  @override
  String failedToImportPlans(String error) {
    return '計畫匯入失敗：$error';
  }

  @override
  String get selectedFileDoesNotExist => '所選檔案不存在';

  @override
  String get couldNotReadFileData => '無法讀取檔案資料';

  @override
  String get databaseImportWebUnsupported =>
      '網頁端匯入資料庫需要手動遷移資料。請將資料匯出為 CSV 檔案，再匯入這些 CSV 檔案。';

  @override
  String get csvFileEmpty => 'CSV 檔案為空';

  @override
  String get csvNeedsDataRow => 'CSV 檔案必須至少包含一行資料';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return '第 $row 行的列數不足：$count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return '第 $row 行的 $field 值無效：$value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return '第 $row 行的 $field 資料類型無效：$type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return '計畫 ID 應為整數，但收到“$value”';
  }

  @override
  String get unitLabel => '單位';

  @override
  String get kilogramsUnit => '公斤 (kg)';

  @override
  String get poundsUnit => '磅 (lb)';

  @override
  String get stoneUnit => '英石';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => '公里 (km)';

  @override
  String get milesUnit => '英里 (mi)';

  @override
  String get metersUnit => '米 (m)';

  @override
  String get kilocaloriesUnit => '千卡 (kcal)';

  @override
  String get enterWeight => '輸入重量';

  @override
  String get requiredField => '必填';

  @override
  String get invalidNumber => '數字無效';

  @override
  String get previousWeight => '上次重量';

  @override
  String get imageLabel => '圖片';

  @override
  String get longPressToDelete => '長按刪除';

  @override
  String get imageError => '圖片錯誤';

  @override
  String get actionSave => '儲存';

  @override
  String get aboutTitle => '關於';

  @override
  String get donate => '捐贈';

  @override
  String get helpSupportProject => '支援此專案';

  @override
  String get whatsNewAbout => '更新內容';

  @override
  String get whatsNewTitle => '更新內容';

  @override
  String get seeReleaseNotes => '檢視版本說明';

  @override
  String get versionLabel => '版本';

  @override
  String get authorLabel => '作者';

  @override
  String get privacyPolicy => '隱私政策';

  @override
  String get privacyPolicyDescription => 'Flexify 如何處理你的資料';

  @override
  String get licenseLabel => '許可證';

  @override
  String get sourceCode => '原始碼';

  @override
  String get sourceCodeDescription => '在 GitHub 上檢視';

  @override
  String get leaveReview => '留下評價';

  @override
  String get leaveReviewDescription => '在 Play 商店評價 Flexify';

  @override
  String get reportBug => '報告錯誤';

  @override
  String get reportBugDescription => '在 GitHub 上提交問題';

  @override
  String get failedMigrations => '遷移失敗';

  @override
  String get errorMessageLabel => '錯誤資訊：';

  @override
  String get createIssue => '建立問題';

  @override
  String get addExercise => '新增動作';

  @override
  String get cardio => '有氧';

  @override
  String get strength => '力量';

  @override
  String get options => '選項';

  @override
  String get periodDay => '天';

  @override
  String get periodWeek => '周';

  @override
  String get periodMonth => '月';

  @override
  String get periodYear => '年';

  @override
  String noDataFor(String name) {
    return '暫無 $name 的資料';
  }

  @override
  String get noDataYet => '暫無資料';

  @override
  String get exerciseNotes => '動作備註';

  @override
  String get notesForExercise => '此動作的備註';

  @override
  String get useTimeBasedXAxis => '使用基於時間的 X 軸';

  @override
  String updateAllNamed(String name) {
    return '更新所有 $name';
  }

  @override
  String get newName => '新名稱';

  @override
  String get restMinutes => '休息分鐘數';

  @override
  String get restSeconds => '休息秒數';

  @override
  String get globalProgress => '總體進度';

  @override
  String get curveLineGraphs => '圖表曲線';

  @override
  String get curveLineGraphsDescription => '將圖表線條繪製為平滑曲線';

  @override
  String noHistoryFor(String name) {
    return '暫無 $name 的歷史記錄';
  }

  @override
  String get cancelSelection => '取消選擇';

  @override
  String get editSelected => '編輯所選項';

  @override
  String get newExercise => '新動作';

  @override
  String get noGraphsFound => '未找到圖表';

  @override
  String get searchGraphs => '搜尋圖表...';

  @override
  String get actionAdd => '新增';

  @override
  String get actionUpdate => '更新';

  @override
  String get hideGlobalProgress => '隱藏總體進度';

  @override
  String get chartGroupedByCategory => '按類別分組的圖表';

  @override
  String get noExercisesFound => '未找到動作';

  @override
  String get savePlan => '儲存計畫';

  @override
  String get titleOptional => '標題（可選）';

  @override
  String get searchExercises => '搜尋動作...';

  @override
  String get warmupSets => '熱身組';

  @override
  String get workingSetsMax => '正式組（最多：20）';

  @override
  String get actionUndo => '撤銷';

  @override
  String get actionSwap => '替換';

  @override
  String get daily => '每天';

  @override
  String get weekly => '每週';

  @override
  String get monthly => '每月';

  @override
  String get yearly => '每年';

  @override
  String get unexpectedError => '出現問題。請重試。';

  @override
  String get loadingExercises => '正在載入動作...';

  @override
  String get noPlansYet => '暫無計畫';

  @override
  String get noMatchingPlans => '沒有符合的計畫';

  @override
  String get newPlan => '新計畫';

  @override
  String get searchPlans => '搜尋計畫...';

  @override
  String get noExercisesYet => '暫無動作';

  @override
  String get editPlan => '編輯計畫';

  @override
  String get saveSet => '儲存組';

  @override
  String get minutesLabel => '分鐘';

  @override
  String get minutesShort => '分鐘';

  @override
  String get secondsLabel => '秒';

  @override
  String get distanceLabel => '距離';

  @override
  String get inclinePercent => '坡度 %';

  @override
  String weightWithUnit(String unit) {
    return '重量 ($unit)';
  }

  @override
  String get useBodyWeight => '使用自重';

  @override
  String get noWeightEnteredYet => '尚未輸入重量';

  @override
  String get notesLabel => '備註';

  @override
  String get swapWorkout => '替換訓練';

  @override
  String get addSet => '新增一組';

  @override
  String get deleteSet => '刪除此組';

  @override
  String get oneRepMaxEstimate => '1RM（估算）';

  @override
  String get valueLabel => '數值';

  @override
  String amountWithUnit(String unit) {
    return '數值 ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return '距離 ($unit)';
  }

  @override
  String get bodyWeightLabel => '體重';

  @override
  String bodyWeightWithUnit(String unit) {
    return '體重 ($unit)';
  }

  @override
  String get categoryHelper => '選擇現有分類或輸入新分類。';

  @override
  String get manageCategories => '管理分類';

  @override
  String get manageCategoriesDescription => '建立、重新命名、合併或刪除分類';

  @override
  String get newCategory => '新建分類';

  @override
  String get renameCategory => '重新命名分類';

  @override
  String get mergeCategory => '合併到其他分類';

  @override
  String get noCategories => '暫無分類';

  @override
  String get categoryNameRequired => '請輸入分類名稱';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個條目使用此分類',
      one: '1 個條目使用此分類',
      zero: '沒有條目使用此分類',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '刪除此分類並將其從 $count 個條目中移除？',
      one: '刪除此分類並將其從 1 個條目中移除？',
      zero: '刪除此分類？',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => '建立日期';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '編輯 $count 組',
      one: '編輯 1 組',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => '暫無記錄';

  @override
  String get historyEmptyMessage => '完成一組或手動新增一組，即可開始記錄歷史。';

  @override
  String deleteSetConfirmation(String name) {
    return '確定要刪除 $name 嗎？';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '確定要刪除 $count 筆紀錄嗎？',
      one: '確定要刪除 1 筆紀錄嗎？',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => '搜尋歷史...';

  @override
  String get themeSystem => '系統';

  @override
  String get themeDark => '深色';

  @override
  String get themeLight => '淺色';

  @override
  String get pureBlackAmoled => '純黑 (AMOLED)';

  @override
  String get showImages => '顯示圖片';

  @override
  String get peekGraph => '預覽圖表';

  @override
  String get inputStyleLine => '下劃線';

  @override
  String get inputStyleOutlined => '邊框';

  @override
  String get inputStyleFilled => '填充';

  @override
  String get inputStyle => '輸入框樣式';

  @override
  String get appearance => '外觀';

  @override
  String get automaticBackupsEnabled => '已啟用自動備份';

  @override
  String get automaticBackup => '自動備份';

  @override
  String get appPermissions => '應用程式權限';

  @override
  String get shareDatabase => '分享資料庫';

  @override
  String get dataManagement => '資料管理';

  @override
  String get strengthUnit => '力量單位';

  @override
  String get lastEntry => '最近記錄';

  @override
  String get cardioUnit => '有氧單位';

  @override
  String longDateFormat(String format) {
    return '長日期格式 ($format)';
  }

  @override
  String get formats => '格式';

  @override
  String get setsPerExerciseMax => '每個動作的組數（最多：20）';

  @override
  String get countLabel => '數量';

  @override
  String get ratioLabel => '比例';

  @override
  String get reorder => '重新排序';

  @override
  String get none => '無';

  @override
  String get monday => '星期一';

  @override
  String get examplePlanExercises => '臥推、深蹲、硬拉';

  @override
  String get tabs => '標籤頁';

  @override
  String get swipeBetweenTabs => '滑動切換標籤頁';

  @override
  String get vibrate => '振動';

  @override
  String get enableSound => '啟用聲音';

  @override
  String get keepScreenOn => '保持螢幕常亮';

  @override
  String get alarmSound => '鬧鐘聲音';

  @override
  String get top => '頂部';

  @override
  String get bottom => '底部';

  @override
  String get removeCustomTimer => '移除自訂計時器（使用全域預設值）';

  @override
  String get timers => '計時器';

  @override
  String get timerSettings => '計時器設定';

  @override
  String get groupHistory => '合併歷史記錄';

  @override
  String get showUnits => '顯示單位';

  @override
  String get showBodyWeight => '顯示體重';

  @override
  String get showCategories => '顯示類別';

  @override
  String get showNotes => '顯示備註';

  @override
  String get repEstimation => '次數估算';

  @override
  String get durationEstimation => '時長估算';

  @override
  String get showGraphLimit => '顯示圖表限制';

  @override
  String get defaultGraphMetric => '預設圖表指標';

  @override
  String get bestWeight => '最高重量';

  @override
  String get bestReps => '最多次數';

  @override
  String get oneRepMax => '1RM';

  @override
  String get volume => '訓練量';

  @override
  String get paceCardio => '配速（有氧）';

  @override
  String get distanceCardio => '距離（有氧）';

  @override
  String get defaultGraphPeriod => '預設圖表週期';

  @override
  String get defaultGraphLimit => '預設圖表限制';

  @override
  String get workouts => '訓練';

  @override
  String get actionStop => '停止';

  @override
  String get timerFinishedToast => '計時結束！';

  @override
  String get stopTimer => '停止計時器';

  @override
  String get actionPause => '暫停';

  @override
  String get startStopwatch => '啟動秒錶';

  @override
  String get actionStart => '開始';

  @override
  String get actionRestart => '重新開始';

  @override
  String get addOneMinute => '+1 分鐘';

  @override
  String get addOneMinuteNotification => '增加 1 分鐘';

  @override
  String get restTimer => '休息計時器';

  @override
  String get timerUp => '時間到';

  @override
  String get openNotification => '開啟通知';

  @override
  String get timerChannelName => '計時器通知';

  @override
  String get timerChannelDescription => '持續顯示休息計時器的進度。';

  @override
  String get timerFinishedChannelName => '計時結束通知';

  @override
  String get timerFinishedChannelDescription => '休息計時器結束時播放鬧鐘。';

  @override
  String get timerFinished => '計時結束';

  @override
  String get batteryOptimizationRequestUnavailable => '你的裝置已停用忽略電池最佳化的請求。';

  @override
  String get exactAlarmRequestUnavailable => '你的裝置拒絕了 SCHEDULE_EXACT_ALARM 請求';

  @override
  String get databaseMigrationFailureDescription =>
      '建立或升級資料庫時出現問題。通常可以透過刪除並重新建立記錄來修復。';

  @override
  String get curveSmoothness => '曲線平滑度';

  @override
  String get actionBack => '返回';

  @override
  String get atLeastOneTab => '至少需要一個標籤頁';

  @override
  String get invalidTabSettings => '標籤頁設定無效。';

  @override
  String get noSettingsFound => '未找到設定';

  @override
  String nothingMatchesSearch(String query) {
    return '沒有與“$query”符合的內容。';
  }

  @override
  String get appearanceDescription => '主題、顏色和介面樣式';

  @override
  String get dataManagementDescription => '匯入、匯出和管理訓練資料';

  @override
  String get formatsDescription => '日期、數字和測量單位格式';

  @override
  String get plansSettingsDescription => '訓練計畫的預設設定和行為';

  @override
  String get tabsDescription => '選擇並排列主要導航標籤頁';

  @override
  String get timersDescription => '休息計時器的時長、聲音和行為';

  @override
  String get workoutsDescription => '動作記錄和訓練偏好';

  @override
  String get completeSetForChart => '完成此動作的一組訓練即可生成圖表。';

  @override
  String get dateRange => '日期範圍';

  @override
  String get stopDate => '結束日期';

  @override
  String get dataPoints => '資料點';

  @override
  String get completeSetsForProgress => '完成幾組訓練即可生成進度圖表。';

  @override
  String get relativeStrength => '相對力量';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已選擇 $count 項',
      one: '已選擇 1 項',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory => '完成幾組訓練，即可在此檢視該動作的歷史記錄。';

  @override
  String get completeSetForFirstGraph => '完成一組訓練即可建立第一個動作圖表。';

  @override
  String nothingMatchesGraphSearch(String query) {
    return '沒有與“$query”符合的內容。你可以將其建立為新動作。';
  }

  @override
  String addNamed(String name) {
    return '新增“$name”';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return '這將刪除 $count 筆紀錄。確定嗎？';
  }

  @override
  String shareWorkout(String summary) {
    return '我剛完成了 $summary';
  }

  @override
  String get updateConflict => '更新衝突';

  @override
  String updateConflictDescription(int count) {
    return '新名稱已存在於 $count 筆紀錄中。確定要繼續嗎？';
  }

  @override
  String get unitsConflict => '單位衝突';

  @override
  String unitsConflictDescription(String unit) {
    return '並非所有記錄都使用相同單位。此操作會將所有單位轉換為 $unit。確定要繼續嗎？';
  }

  @override
  String get durationLabel => '時長';

  @override
  String get inclineLabel => '坡度';

  @override
  String get paceDistanceTime => '配速（距離 / 時間）';

  @override
  String get adjustedPace => '調整後配速';

  @override
  String get oneRepMaxAccuracyWarning => '當一組達到 10 次或更多次數時，1RM 估算的準確度會降低';

  @override
  String get addPlan => '新增計畫';

  @override
  String get planDetails => '計畫詳情';

  @override
  String get exercisesLabel => '動作';

  @override
  String get addExerciseToPlan => '向此計畫新增一個動作。';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return '沒有與“$query”符合的內容。你可以將其新增為新動作。';
  }

  @override
  String get selectDays => '選擇日期';

  @override
  String get selectExercises => '選擇動作';

  @override
  String get todayLabel => '今天';

  @override
  String get setDetails => '組詳情';

  @override
  String get themeLabel => '主題';

  @override
  String get pureBlackAmoledDescription => '在 AMOLED 螢幕上使用純黑色';

  @override
  String get systemColorScheme => '系統配色';

  @override
  String get systemColorSchemeDescription => '使用裝置的主色作為應用程式配色';

  @override
  String get showImagesDescription => '在歷史頁面選擇並顯示圖片';

  @override
  String get showGlobalProgress => '顯示總體進度';

  @override
  String get showGlobalProgressDescription => '在圖表中新增按類別展示進度的條目';

  @override
  String get peekGraphDescription => '在圖表頁面顯示第一個折線圖';

  @override
  String get inputStyleDescription => '文字輸入框的視覺樣式';

  @override
  String get automaticBackupNotificationBody => 'Flexify 每天會自動將資料和圖片備份到所選資料夾。';

  @override
  String get backupSettingsChannel => '備份設定';

  @override
  String get backupSettingsChannelDescription => '說明自動備份的通知';

  @override
  String get backupChannelName => '備份通知';

  @override
  String get backupChannelDescription => '自動備份 Flexify 的資料和圖片';

  @override
  String get backupCompletedTitle => '資料和圖片備份完成';

  @override
  String get backupFailurePathNotSet => '備份失敗：未設定備份路徑。已停用自動備份。';

  @override
  String get backupFailureDirectoryUnavailable => '備份失敗：無法存取備份資料夾。已停用自動備份。';

  @override
  String get backupFailureCreateFile => '備份失敗：無法建立備份檔案。已停用自動備份。';

  @override
  String get backupFailureAppFilesUnavailable => '備份失敗：無法存取應用程式檔案目錄。已停用自動備份。';

  @override
  String get backupFailureDatabaseMissing => '備份失敗：未找到資料庫檔案。已停用自動備份。';

  @override
  String get backupFailureOutputUnavailable => '備份失敗：無法開啟輸出流。已停用自動備份。';

  @override
  String get backupFailureUnknown => '備份失敗。已停用自動備份。';

  @override
  String get appPermissionsDescription => '檢查已啟用功能所需的存取權限';

  @override
  String get longDateFormatDescription => '用於空間充足的介面';

  @override
  String shortDateFormat(String example) {
    return '短日期格式 ($example)';
  }

  @override
  String get shortDateFormatDescription => '用於空間較窄的介面（如圖表線）';

  @override
  String get warmupSetsDescription => '熱身組不使用休息計時器';

  @override
  String get setsPerExerciseDescription => '計畫中的預設動作數量';

  @override
  String get planTrailingDisplay => '計畫右側顯示內容';

  @override
  String get planTrailingDisplayDescription => '“計畫”列表和計畫詳情右側顯示的內容';

  @override
  String get restTimersDescription => '完成一組後觸發的鬧鐘';

  @override
  String get vibrateDescription => '休息計時器是否振動？';

  @override
  String get enableSoundDescription => '休息計時器是否播放聲音？';

  @override
  String get keepScreenOnDescription => '休息計時器執行時保持螢幕常亮';

  @override
  String get restDurationDescription => '休息多久後觸發提醒？';

  @override
  String get globalDefault => '全域預設值';

  @override
  String get alarmSoundDescription => '休息計時器結束時播放的音樂';

  @override
  String get progressBarPosition => '進度條位置';

  @override
  String get progressBarPositionDescription => '休息計時器的進度條應顯示在哪裡？';

  @override
  String get perExerciseRestTimes => '按動作設定休息時間';

  @override
  String get perExerciseRestTimesDescription => '這些動作使用自訂休息時長';

  @override
  String get audioFeaturesUnavailable => '音訊功能不可用';

  @override
  String get groupHistoryDescription => '按日期合併歷史記錄';

  @override
  String get showUnitsDescription => '在圖表、歷史和計畫中顯示 km/mi、kg/lb';

  @override
  String get showBodyWeightDescription => '啟用或停用體重記錄';

  @override
  String get showCategoriesDescription => '啟用或停用訓練類別';

  @override
  String get showNotesDescription => '在文字框中記錄訓練詳情';

  @override
  String get positiveNotificationsDescription => '創造新紀錄時顯示鼓勵訊息';

  @override
  String get positiveMessagesEnabled => '鼓勵訊息現在會這樣顯示！';

  @override
  String get recordEncouragement01 => '太棒了！你真的很厲害。';

  @override
  String get recordEncouragement02 => '幹得漂亮，王者！你的進步令人振奮。';

  @override
  String get recordEncouragement03 => '我服了...';

  @override
  String get recordEncouragement04 => '這是什麼？新紀錄！';

  @override
  String get recordEncouragement05 => '太厲害了！你真讓人受到鼓舞。';

  @override
  String get recordEncouragement06 => '哇。不錯。';

  @override
  String get recordEncouragement07 => '越來越強了啊？';

  @override
  String get recordEncouragement08 => '是啊。你塊頭越來越大了。';

  @override
  String get recordEncouragement09 => '太棒了。真厲害。';

  @override
  String get recordEncouragement10 => '阿諾德會為你驕傲的。';

  @override
  String get recordEncouragement11 => 'Ronnie C 正開心地看著你。';

  @override
  String get recordEncouragement12 => '耶！輕重量，寶貝!!!!!!!';

  @override
  String get recordEncouragement13 => '這是新紀錄嗎？我就知道你能做到。';

  @override
  String get recordEncouragement14 => '太棒了！我為你驕傲。';

  @override
  String get recordEncouragement15 => '耶寶貝！輕輕鬆鬆！';

  @override
  String get recordEncouragement16 => '繼續保持！進步很大。';

  @override
  String get recordEncouragement17 => '你做得非常好。';

  @override
  String get recordEncouragement18 => '這才對嘛！';

  @override
  String get recordEncouragement19 => '繼續保持。';

  @override
  String get recordEncouragement20 => '你越來越強了。';

  @override
  String get recordEncouragement21 => '強大。';

  @override
  String get recordEncouragement22 => '力量爆棚！';

  @override
  String get recordEncouragement23 => '我為你驕傲。';

  @override
  String get recordEncouragement24 => '繼續保持出色表現。';

  @override
  String get recordEncouragement25 => '挺起胸膛！你剛剛創造了新紀錄。';

  @override
  String get recordEncouragement26 => '新紀錄！你剛剛突破了自己的極限！';

  @override
  String get recordEncouragement27 => '沒錯！這是新紀錄。';

  @override
  String get recordEncouragement28 => '哇！新紀錄！';

  @override
  String get recordEncouragement29 => '真的做得很好。';

  @override
  String get repEstimationDescription => '嘗試預測你剛完成的次數';

  @override
  String get durationEstimationDescription => '嘗試預測有氧運動的持續時間';

  @override
  String get showGraphXAxisToggle => '顯示圖表 X 軸切換選項';

  @override
  String get showGraphXAxisToggleDescription => '在圖表中顯示基於時間的 X 軸切換選項';

  @override
  String get showGraphLimitDescription => '在圖表中顯示限制滑塊';

  @override
  String get defaultTimeBasedXAxis => '預設使用基於時間的 X 軸';

  @override
  String get defaultTimeBasedXAxisDescription => '圖表預設使用基於時間的 X 軸';

  @override
  String get createFirstTrainingPlan => '建立你的第一個訓練計畫即可開始。';

  @override
  String nothingMatchesPlanSearch(String query) {
    return '沒有與“$query”符合的內容。你可以將其建立為新計畫。';
  }

  @override
  String get createPlan => '建立計畫';

  @override
  String createNamedPlan(String name) {
    return '建立“$name”';
  }

  @override
  String setNumber(int number) {
    return '第 $number 組';
  }
}
