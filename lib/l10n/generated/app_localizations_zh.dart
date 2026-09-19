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
  String get languageNameTurkish => 'Turkish';

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
  String get categoryHelper => '肌群，例如胸部或腿部';

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
  String get languageNameTurkish => 'Turkish';

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
  String get categoryHelper => '肌群，例如胸部或腿部';

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
