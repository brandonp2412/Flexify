// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsLanguageDescription => 'Flexifyで使用する言語を選択します';

  @override
  String get languageSystemDefault => 'システムのデフォルト';

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
  String get navHistory => '履歴';

  @override
  String get navPlans => 'プラン';

  @override
  String get navGraphs => 'グラフ';

  @override
  String get navTimer => 'タイマー';

  @override
  String get navSettings => '設定';

  @override
  String get errorLabel => 'エラー';

  @override
  String get tabContentError => 'タブの内容を表示できませんでした。';

  @override
  String get cannotHideAllTabs => 'すべてのタブを非表示にはできません。';

  @override
  String removeTabQuestion(String tab) {
    return '$tabタブを削除しますか？';
  }

  @override
  String get restoreTabFromSettings => 'あとで設定から再追加できます。';

  @override
  String removedTab(String tab) {
    return '$tabを削除しました';
  }

  @override
  String newVersion(String version) {
    return '新しいバージョン $version';
  }

  @override
  String get changes => '変更点';

  @override
  String get searchHint => '検索...';

  @override
  String get deleteSelected => '選択項目を削除';

  @override
  String get confirmDelete => '削除の確認';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件の記録を削除しますか？この操作は元に戻せません。',
      one: '1件の記録を削除しますか？この操作は元に戻せません。',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'キャンセル';

  @override
  String get actionDelete => '削除';

  @override
  String get actionRemove => '削除';

  @override
  String get actionEdit => '編集';

  @override
  String get actionShare => '共有';

  @override
  String get clearSelection => '選択を解除';

  @override
  String get clearSearch => '検索をクリア';

  @override
  String get showMenu => 'メニューを表示';

  @override
  String get selectAll => 'すべて選択';

  @override
  String get weightLabel => '重量';

  @override
  String get filter => 'フィルター';

  @override
  String get filters => 'フィルター';

  @override
  String get categoryLabel => 'カテゴリー';

  @override
  String get repsLabel => '回数';

  @override
  String get repsFilter => '回数フィルター';

  @override
  String get weightFilter => '重量フィルター';

  @override
  String get greaterThan => 'より大きい';

  @override
  String get lessThan => 'より小さい';

  @override
  String get startDate => '開始日';

  @override
  String get endDate => '終了日';

  @override
  String get actionClear => 'クリア';

  @override
  String get actionOk => 'OK';

  @override
  String get actionClose => '閉じる';

  @override
  String get sortBy => '並べ替え';

  @override
  String get dateNewest => '日付（新しい順）';

  @override
  String get dateOldest => '日付（古い順）';

  @override
  String get nameLabel => '名前';

  @override
  String get missingPermissions => '権限が不足しています';

  @override
  String get restTimersPermissionsMissing => '休憩タイマーは有効ですが、必要な権限がありません。';

  @override
  String get restTimersPermissionsOptional => '休憩タイマーを無効にすると、これらの権限は不要です。';

  @override
  String get restTimers => '休憩タイマー';

  @override
  String get disableBatteryOptimizations => 'バッテリー最適化を無効化';

  @override
  String get batteryOptimizationWarning => 'バッテリー最適化が有効なままだと、進行が停止することがあります。';

  @override
  String get scheduleExactAlarm => '正確なアラームを設定';

  @override
  String get exactAlarmWarning => '無効にするとアラームの時刻が正確でない場合があります。';

  @override
  String get postNotifications => '通知を表示';

  @override
  String get notificationBarDescription => 'タイマーの進行状況を通知バーに表示します';

  @override
  String get invalidPermissions => '権限が不十分です';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      '必要な権限が不足したまま休憩タイマーが有効です。続行しますか？';

  @override
  String get actionConfirm => '確認';

  @override
  String get appAccess => 'アプリのアクセス権';

  @override
  String get appAccessDescription => '有効なタイマーと通知に必要です。';

  @override
  String get notifications => '通知';

  @override
  String get timerProgressAndRestAlerts => 'タイマーの進行状況と休憩アラート';

  @override
  String get enabledNotificationsDescription => '有効にしている通知';

  @override
  String get backgroundActivity => 'バックグラウンド動作';

  @override
  String get backgroundActivityDescription => 'バックグラウンドでもタイマーを安定して動作させます';

  @override
  String get exactAlarms => '正確なアラーム';

  @override
  String get exactAlarmsDescription => '休憩タイマー終了時に正確に通知します';

  @override
  String get noAdditionalAndroidAccessNeeded => '現在の設定では追加のAndroidアクセス権は不要です。';

  @override
  String get actionDone => '完了';

  @override
  String get allowed => '許可済み';

  @override
  String get actionAllow => '許可';

  @override
  String get backupLabel => 'バックアップ';

  @override
  String get databaseLabel => 'データベース';

  @override
  String get deleteRecords => '記録を削除';

  @override
  String get deleteAllGraphsConfirmation => 'すべてのグラフを削除しますか？この操作は元に戻せません。';

  @override
  String get deleteAllPlansConfirmation => 'すべてのプランを削除しますか？この操作は元に戻せません。';

  @override
  String get deleteDatabaseConfirmation =>
      'データベースを削除しますか？この操作は元に戻せず、すべてのデータが失われます。';

  @override
  String get importData => 'データをインポート';

  @override
  String get exportData => 'データをエクスポート';

  @override
  String get actionReport => '報告';

  @override
  String get graphDataImported => 'グラフデータをインポートしました。';

  @override
  String get plansImported => 'プランをインポートしました';

  @override
  String failedToImportDatabase(String error) {
    return 'データベースのインポートに失敗しました: $error';
  }

  @override
  String get backupArchiveMissingDatabase =>
      'バックアップに Flexify のデータベースが含まれていません。';

  @override
  String failedToImportGraphs(String error) {
    return 'グラフのインポートに失敗しました: $error';
  }

  @override
  String failedToImportPlans(String error) {
    return 'プランのインポートに失敗しました: $error';
  }

  @override
  String get selectedFileDoesNotExist => '選択したファイルが存在しません';

  @override
  String get couldNotReadFileData => 'ファイルデータを読み取れませんでした';

  @override
  String get databaseImportWebUnsupported =>
      'Webでのデータベースインポートには手動のデータ移行が必要です。データをCSVファイルとしてエクスポートし、そのCSVをインポートしてください。';

  @override
  String get csvFileEmpty => 'CSVファイルが空です';

  @override
  String get csvNeedsDataRow => 'CSVファイルには少なくとも1行のデータが必要です';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return '$row行目の列数が不足しています: $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return '$row行目の$fieldの値が無効です: $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return '$row行目の$fieldのデータ型が無効です: $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return 'プランIDには整数が必要ですが、\"$value\" が指定されました';
  }

  @override
  String get unitLabel => '単位';

  @override
  String get kilogramsUnit => 'キログラム (kg)';

  @override
  String get poundsUnit => 'ポンド (lb)';

  @override
  String get stoneUnit => 'ストーン';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => 'キロメートル (km)';

  @override
  String get milesUnit => 'マイル (mi)';

  @override
  String get metersUnit => 'メートル (m)';

  @override
  String get kilocaloriesUnit => 'キロカロリー (kcal)';

  @override
  String get enterWeight => '重量を入力';

  @override
  String get requiredField => '必須';

  @override
  String get invalidNumber => '無効な数値';

  @override
  String get previousWeight => '前回の重量';

  @override
  String get imageLabel => '画像';

  @override
  String get longPressToDelete => '長押しで削除';

  @override
  String get imageError => '画像エラー';

  @override
  String get actionSave => '保存';

  @override
  String get aboutTitle => 'このアプリについて';

  @override
  String get donate => '寄付';

  @override
  String get helpSupportProject => 'このプロジェクトを支援する';

  @override
  String get whatsNewAbout => '新着情報';

  @override
  String get whatsNewTitle => '新着情報';

  @override
  String get seeReleaseNotes => 'リリースノートを見る';

  @override
  String get versionLabel => 'バージョン';

  @override
  String get authorLabel => '作者';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get privacyPolicyDescription => 'Flexifyによるデータの取り扱い';

  @override
  String get licenseLabel => 'ライセンス';

  @override
  String get sourceCode => 'ソースコード';

  @override
  String get sourceCodeDescription => 'GitHubで確認';

  @override
  String get leaveReview => 'レビューを書く';

  @override
  String get leaveReviewDescription => 'Play ストアでFlexifyを評価';

  @override
  String get reportBug => 'バグを報告';

  @override
  String get reportBugDescription => 'GitHubでIssueを作成';

  @override
  String get failedMigrations => '失敗した移行';

  @override
  String get errorMessageLabel => 'エラーメッセージ:';

  @override
  String get createIssue => 'Issueを作成';

  @override
  String get addExercise => '種目を追加';

  @override
  String get cardio => '有酸素運動';

  @override
  String get strength => '筋力';

  @override
  String get options => 'オプション';

  @override
  String get periodDay => '日';

  @override
  String get periodWeek => '週';

  @override
  String get periodMonth => '月';

  @override
  String get periodYear => '年';

  @override
  String noDataFor(String name) {
    return '$nameのデータはまだありません';
  }

  @override
  String get noDataYet => 'データはまだありません';

  @override
  String get exerciseNotes => '種目メモ';

  @override
  String get notesForExercise => 'この種目のメモ';

  @override
  String get useTimeBasedXAxis => '時間ベースのX軸を使用';

  @override
  String updateAllNamed(String name) {
    return '$nameをすべて更新';
  }

  @override
  String get newName => '新しい名前';

  @override
  String get restMinutes => '休憩（分）';

  @override
  String get restSeconds => '休憩（秒）';

  @override
  String get globalProgress => '全体の進捗';

  @override
  String get curveLineGraphs => 'グラフの線を曲線にする';

  @override
  String get curveLineGraphsDescription => 'グラフの線を滑らかな曲線で描画します';

  @override
  String noHistoryFor(String name) {
    return '$nameの履歴はまだありません';
  }

  @override
  String get cancelSelection => '選択をキャンセル';

  @override
  String get editSelected => '選択項目を編集';

  @override
  String get newExercise => '新しい種目';

  @override
  String get noGraphsFound => 'グラフが見つかりません';

  @override
  String get searchGraphs => 'グラフを検索...';

  @override
  String get actionAdd => '追加';

  @override
  String get actionUpdate => '更新';

  @override
  String get hideGlobalProgress => '全体の進捗を非表示';

  @override
  String get chartGroupedByCategory => 'カテゴリー別にまとめたグラフ';

  @override
  String get noExercisesFound => '種目が見つかりません';

  @override
  String get savePlan => 'プランを保存';

  @override
  String get titleOptional => 'タイトル（任意）';

  @override
  String get searchExercises => '種目を検索...';

  @override
  String get warmupSets => 'ウォームアップセット';

  @override
  String get workingSetsMax => 'ワーキングセット（最大: 20）';

  @override
  String get actionUndo => '元に戻す';

  @override
  String get actionSwap => '入れ替え';

  @override
  String get daily => '毎日';

  @override
  String get weekly => '毎週';

  @override
  String get monthly => '毎月';

  @override
  String get yearly => '毎年';

  @override
  String get unexpectedError => '問題が発生しました。もう一度お試しください。';

  @override
  String get loadingExercises => '種目を読み込み中...';

  @override
  String get noPlansYet => 'プランはまだありません';

  @override
  String get noMatchingPlans => '一致するプランがありません';

  @override
  String get newPlan => '新しいプラン';

  @override
  String get searchPlans => 'プランを検索...';

  @override
  String get noExercisesYet => '種目はまだありません';

  @override
  String get editPlan => 'プランを編集';

  @override
  String get saveSet => 'セットを保存';

  @override
  String get minutesLabel => '分';

  @override
  String get minutesShort => '分';

  @override
  String get secondsLabel => '秒';

  @override
  String get distanceLabel => '距離';

  @override
  String get inclinePercent => '傾斜 %';

  @override
  String weightWithUnit(String unit) {
    return '重量 ($unit)';
  }

  @override
  String get useBodyWeight => '自重を使用';

  @override
  String get noWeightEnteredYet => '重量はまだ入力されていません';

  @override
  String get notesLabel => 'メモ';

  @override
  String get swapWorkout => 'トレーニングを入れ替え';

  @override
  String get addSet => 'セットを追加';

  @override
  String get deleteSet => 'セットを削除';

  @override
  String get oneRepMaxEstimate => '1RM（推定）';

  @override
  String get valueLabel => '値';

  @override
  String amountWithUnit(String unit) {
    return '量 ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return '距離 ($unit)';
  }

  @override
  String get bodyWeightLabel => '体重';

  @override
  String bodyWeightWithUnit(String unit) {
    return '体重 ($unit)';
  }

  @override
  String get categoryHelper => '既存のカテゴリを選ぶか、新しいカテゴリ名を入力してください。';

  @override
  String get manageCategories => 'カテゴリを管理';

  @override
  String get manageCategoriesDescription => 'カテゴリの作成、名前変更、統合、削除';

  @override
  String get newCategory => '新しいカテゴリ';

  @override
  String get renameCategory => 'カテゴリ名を変更';

  @override
  String get mergeCategory => '別のカテゴリに統合';

  @override
  String get noCategories => 'カテゴリはまだありません';

  @override
  String get categoryNameRequired => 'カテゴリ名を入力してください';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件の項目で使用中',
      one: '1件の項目で使用中',
      zero: '使用している項目はありません',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'このカテゴリを削除し、$count件の項目から解除しますか？',
      one: 'このカテゴリを削除し、1件の項目から解除しますか？',
      zero: 'このカテゴリを削除しますか？',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => '作成日';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countセットを編集',
      one: '1セットを編集',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => '記録はまだありません';

  @override
  String get historyEmptyMessage => 'セットを完了するか手動で追加すると、履歴が始まります。';

  @override
  String deleteSetConfirmation(String name) {
    return '$nameを削除しますか？';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件の項目を削除しますか？',
      one: '1件の項目を削除しますか？',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => '履歴を検索...';

  @override
  String get themeSystem => 'システム';

  @override
  String get themeDark => 'ダーク';

  @override
  String get themeLight => 'ライト';

  @override
  String get pureBlackAmoled => '完全な黒 (AMOLED)';

  @override
  String get showImages => '画像を表示';

  @override
  String get peekGraph => 'グラフをプレビュー';

  @override
  String get inputStyleLine => '下線';

  @override
  String get inputStyleOutlined => '枠線';

  @override
  String get inputStyleFilled => '塗りつぶし';

  @override
  String get inputStyle => '入力欄のスタイル';

  @override
  String get appearance => '外観';

  @override
  String get automaticBackupsEnabled => '自動バックアップが有効です';

  @override
  String get automaticBackup => '自動バックアップ';

  @override
  String get appPermissions => 'アプリの権限';

  @override
  String get shareDatabase => 'データベースを共有';

  @override
  String get dataManagement => 'データ管理';

  @override
  String get strengthUnit => '筋力の単位';

  @override
  String get lastEntry => '最後の記録';

  @override
  String get cardioUnit => '有酸素運動の単位';

  @override
  String longDateFormat(String format) {
    return '長い日付形式 ($format)';
  }

  @override
  String get formats => '形式';

  @override
  String get setsPerExerciseMax => '種目ごとのセット数（最大: 20）';

  @override
  String get countLabel => '回数';

  @override
  String get ratioLabel => '比率';

  @override
  String get reorder => '並べ替え';

  @override
  String get none => 'なし';

  @override
  String get monday => '月曜日';

  @override
  String get examplePlanExercises => 'ベンチプレス、スクワット、デッドリフト';

  @override
  String get tabs => 'タブ';

  @override
  String get swipeBetweenTabs => 'スワイプでタブを切り替え';

  @override
  String get vibrate => 'バイブレーション';

  @override
  String get enableSound => '音を有効にする';

  @override
  String get keepScreenOn => '画面をオンのままにする';

  @override
  String get alarmSound => 'アラーム音';

  @override
  String get top => '上';

  @override
  String get bottom => '下';

  @override
  String get removeCustomTimer => 'カスタムタイマーを削除（全体のデフォルトを使用）';

  @override
  String get timers => 'タイマー';

  @override
  String get timerSettings => 'タイマー設定';

  @override
  String get groupHistory => '履歴をまとめる';

  @override
  String get showUnits => '単位を表示';

  @override
  String get showBodyWeight => '体重を表示';

  @override
  String get showCategories => 'カテゴリーを表示';

  @override
  String get showNotes => 'メモを表示';

  @override
  String get repEstimation => '回数の推定';

  @override
  String get durationEstimation => '時間の推定';

  @override
  String get showGraphLimit => 'グラフの上限を表示';

  @override
  String get defaultGraphMetric => 'デフォルトのグラフ指標';

  @override
  String get bestWeight => '最高重量';

  @override
  String get bestReps => '最多回数';

  @override
  String get oneRepMax => '1RM';

  @override
  String get volume => 'ボリューム';

  @override
  String get paceCardio => 'ペース（有酸素）';

  @override
  String get distanceCardio => '距離（有酸素）';

  @override
  String get defaultGraphPeriod => 'デフォルトのグラフ期間';

  @override
  String get defaultGraphLimit => 'デフォルトのグラフ上限';

  @override
  String get workouts => 'トレーニング';

  @override
  String get actionStop => '停止';

  @override
  String get timerFinishedToast => 'タイマーが終了しました。';

  @override
  String get stopTimer => 'タイマーを停止';

  @override
  String get actionPause => '一時停止';

  @override
  String get startStopwatch => 'ストップウォッチを開始';

  @override
  String get actionStart => '開始';

  @override
  String get actionRestart => '再開';

  @override
  String get addOneMinute => '+1分';

  @override
  String get addOneMinuteNotification => '1分追加';

  @override
  String get restTimer => '休憩タイマー';

  @override
  String get timerUp => '時間です';

  @override
  String get openNotification => '通知を開く';

  @override
  String get timerChannelName => 'タイマーチャンネル';

  @override
  String get timerChannelDescription => '休憩タイマーの継続的な進行状況。';

  @override
  String get timerFinishedChannelName => 'タイマー終了チャンネル';

  @override
  String get timerFinishedChannelDescription => '休憩タイマーの終了時にアラームを鳴らします。';

  @override
  String get timerFinished => 'タイマー終了';

  @override
  String get batteryOptimizationRequestUnavailable =>
      'この端末ではバッテリー最適化を無視する要求が無効になっています。';

  @override
  String get exactAlarmRequestUnavailable =>
      'この端末でSCHEDULE_EXACT_ALARMの要求が拒否されました';

  @override
  String get databaseMigrationFailureDescription =>
      'データベースの作成または更新中に問題が発生しました。通常は記録を削除して再作成すると修正できます。';

  @override
  String get curveSmoothness => '曲線の滑らかさ';

  @override
  String get actionBack => '戻る';

  @override
  String get atLeastOneTab => '少なくとも1つのタブが必要です';

  @override
  String get invalidTabSettings => 'タブ設定が無効です。';

  @override
  String get noSettingsFound => '設定が見つかりません';

  @override
  String nothingMatchesSearch(String query) {
    return '「$query」に一致する項目はありません。';
  }

  @override
  String get appearanceDescription => 'テーマ、色、インターフェースの外観';

  @override
  String get dataManagementDescription => 'トレーニングデータのインポート、エクスポート、管理';

  @override
  String get formatsDescription => '日付、数値、測定単位の表示形式';

  @override
  String get plansSettingsDescription => 'トレーニングプランのデフォルト設定と動作';

  @override
  String get tabsDescription => 'メインのナビゲーションタブを選択して並べ替えます';

  @override
  String get timersDescription => '休憩タイマーの時間、音、動作';

  @override
  String get workoutsDescription => '種目の記録とトレーニング設定';

  @override
  String get completeSetForChart => 'この種目のセットを完了するとグラフを作成できます。';

  @override
  String get dateRange => '日付範囲';

  @override
  String get stopDate => '終了日';

  @override
  String get dataPoints => 'データポイント';

  @override
  String get completeSetsForProgress => 'いくつかのセットを完了すると進捗グラフを作成できます。';

  @override
  String get relativeStrength => '相対筋力';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件選択中',
      one: '1件選択中',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory => 'いくつかのセットを完了すると、この種目の履歴をここで確認できます。';

  @override
  String get completeSetForFirstGraph => 'セットを完了すると最初の種目グラフを作成できます。';

  @override
  String nothingMatchesGraphSearch(String query) {
    return '「$query」に一致する項目はありません。新しい種目として作成できます。';
  }

  @override
  String addNamed(String name) {
    return '「$name」を追加';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return '$count件の記録を削除します。よろしいですか？';
  }

  @override
  String shareWorkout(String summary) {
    return '$summaryをやりました';
  }

  @override
  String get updateConflict => '更新の競合';

  @override
  String updateConflictDescription(int count) {
    return '新しい名前はすでに$count件の記録で使われています。続行しますか？';
  }

  @override
  String get unitsConflict => '単位の競合';

  @override
  String unitsConflictDescription(String unit) {
    return 'すべての記録で同じ単位が使われていません。すべての単位を$unitに変換します。続行しますか？';
  }

  @override
  String get durationLabel => '時間';

  @override
  String get inclineLabel => '傾斜';

  @override
  String get paceDistanceTime => 'ペース（距離 / 時間）';

  @override
  String get adjustedPace => '調整後ペース';

  @override
  String get oneRepMaxAccuracyWarning => '1RMの推定値は10回以上のセットでは精度が低くなります';

  @override
  String get addPlan => 'プランを追加';

  @override
  String get planDetails => 'プランの詳細';

  @override
  String get exercisesLabel => '種目';

  @override
  String get addExerciseToPlan => 'このプランに種目を追加します。';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return '「$query」に一致する項目はありません。新しい種目として追加できます。';
  }

  @override
  String get selectDays => '曜日を選択';

  @override
  String get selectExercises => '種目を選択';

  @override
  String get todayLabel => '今日';

  @override
  String get setDetails => 'セットの詳細';

  @override
  String get themeLabel => 'テーマ';

  @override
  String get pureBlackAmoledDescription => 'AMOLEDディスプレイでは完全な黒を使用します';

  @override
  String get systemColorScheme => 'システムのカラースキーム';

  @override
  String get systemColorSchemeDescription => '端末のメインカラーをアプリで使用します';

  @override
  String get showImagesDescription => '履歴ページで画像を選択・表示します';

  @override
  String get showGlobalProgress => '全体の進捗を表示';

  @override
  String get showGlobalProgressDescription => 'カテゴリーごとの進捗を示す項目をグラフに追加します';

  @override
  String get peekGraphDescription => 'グラフページに最初の折れ線グラフを表示します';

  @override
  String get inputStyleDescription => 'テキスト入力欄の見た目';

  @override
  String get automaticBackupNotificationBody =>
      'Flexifyは毎日、データと画像を選択したフォルダーへ自動的にバックアップします。';

  @override
  String get backupSettingsChannel => 'バックアップ設定';

  @override
  String get backupSettingsChannelDescription => '自動バックアップについて説明する通知';

  @override
  String get backupChannelName => 'バックアップチャンネル';

  @override
  String get backupChannelDescription => 'Flexifyのデータと画像の自動バックアップ';

  @override
  String get backupCompletedTitle => 'データと画像をバックアップしました';

  @override
  String get backupFailurePathNotSet =>
      'バックアップに失敗しました: 保存先が設定されていません。自動バックアップを無効にしました。';

  @override
  String get backupFailureDirectoryUnavailable =>
      'バックアップに失敗しました: バックアップフォルダーにアクセスできません。自動バックアップを無効にしました。';

  @override
  String get backupFailureCreateFile =>
      'バックアップに失敗しました: バックアップファイルを作成できません。自動バックアップを無効にしました。';

  @override
  String get backupFailureAppFilesUnavailable =>
      'バックアップに失敗しました: アプリのファイルフォルダーにアクセスできません。自動バックアップを無効にしました。';

  @override
  String get backupFailureDatabaseMissing =>
      'バックアップに失敗しました: データベースファイルが見つかりません。自動バックアップを無効にしました。';

  @override
  String get backupFailureOutputUnavailable =>
      'バックアップに失敗しました: 出力ストリームを開けません。自動バックアップを無効にしました。';

  @override
  String get backupFailureUnknown => 'バックアップに失敗しました。自動バックアップを無効にしました。';

  @override
  String get appPermissionsDescription => '有効にした機能に必要なアクセス権を確認します';

  @override
  String get longDateFormatDescription => '十分な表示領域がある場所で使用します';

  @override
  String shortDateFormat(String example) {
    return '短い日付形式 ($example)';
  }

  @override
  String get shortDateFormatDescription => '表示領域が狭い場所で使用します（グラフ線など）';

  @override
  String get warmupSetsDescription => 'ウォームアップセットでは休憩タイマーを使いません';

  @override
  String get setsPerExerciseDescription => 'プラン内の種目数のデフォルト値';

  @override
  String get planTrailingDisplay => 'プラン右側の表示';

  @override
  String get planTrailingDisplayDescription => 'プラン一覧とプラン画面の右側に表示する内容';

  @override
  String get restTimersDescription => 'セット完了後に鳴るアラーム';

  @override
  String get vibrateDescription => '休憩タイマーでバイブレーションしますか？';

  @override
  String get enableSoundDescription => '休憩タイマーで音を鳴らしますか？';

  @override
  String get keepScreenOnDescription => '休憩タイマー中は画面をオンのままにします';

  @override
  String get restDurationDescription => '休憩アラームが鳴るまでの時間';

  @override
  String get globalDefault => '全体のデフォルト';

  @override
  String get alarmSoundDescription => '休憩タイマー終了時に再生する音楽';

  @override
  String get progressBarPosition => '進捗バーの位置';

  @override
  String get progressBarPositionDescription => '休憩タイマーの進捗バーを表示する位置';

  @override
  String get perExerciseRestTimes => '種目ごとの休憩時間';

  @override
  String get perExerciseRestTimesDescription => 'これらの種目には個別の休憩時間が設定されています';

  @override
  String get audioFeaturesUnavailable => '音声機能は利用できません';

  @override
  String get groupHistoryDescription => '履歴の記録を日ごとにまとめます';

  @override
  String get showUnitsDescription => 'グラフ、履歴、プランでkm/mi、kg/lbを表示します';

  @override
  String get showBodyWeightDescription => '体重の記録を有効または無効にします';

  @override
  String get showCategoriesDescription => 'トレーニングカテゴリーを有効または無効にします';

  @override
  String get showNotesDescription => 'トレーニングの詳細をテキスト欄に記録します';

  @override
  String get positiveNotificationsDescription => '新記録を達成したときに励ましのメッセージを表示します';

  @override
  String get positiveMessagesEnabled => 'ポジティブメッセージはこのように表示されます。';

  @override
  String get recordEncouragement01 => 'よくできました！最高です。';

  @override
  String get recordEncouragement02 => 'いいぞ、王者！その成長は刺激になります。';

  @override
  String get recordEncouragement03 => 'ひれ伏します...';

  @override
  String get recordEncouragement04 => 'これは？新記録！';

  @override
  String get recordEncouragement05 => 'すごい！本当に刺激になります。';

  @override
  String get recordEncouragement06 => 'すごい。いいね。';

  @override
  String get recordEncouragement07 => 'かなり強くなってきた？';

  @override
  String get recordEncouragement08 => 'うん。かなり大きくなってきたね。';

  @override
  String get recordEncouragement09 => 'すごい。圧巻です。';

  @override
  String get recordEncouragement10 => 'アーニーも誇りに思うはず。';

  @override
  String get recordEncouragement11 => 'ロニーCも喜んで見ています。';

  @override
  String get recordEncouragement12 => 'イェーイ！ライトウェイト、ベイビー!!!!!!!';

  @override
  String get recordEncouragement13 => '新記録？できると思っていました。';

  @override
  String get recordEncouragement14 => 'よくできました！誇りに思います。';

  @override
  String get recordEncouragement15 => 'イェーイ！軽い軽い！';

  @override
  String get recordEncouragement16 => 'その調子！すばらしい進歩です。';

  @override
  String get recordEncouragement17 => 'とても順調です。';

  @override
  String get recordEncouragement18 => 'さすが！';

  @override
  String get recordEncouragement19 => 'その調子。';

  @override
  String get recordEncouragement20 => 'どんどん強くなっています。';

  @override
  String get recordEncouragement21 => '力強い。';

  @override
  String get recordEncouragement22 => 'すごいパワー！';

  @override
  String get recordEncouragement23 => '誇りに思います。';

  @override
  String get recordEncouragement24 => 'この調子で頑張ってください。';

  @override
  String get recordEncouragement25 => '胸を張って！新記録を達成しました。';

  @override
  String get recordEncouragement26 => '新記録！これまで以上に伸ばしました！';

  @override
  String get recordEncouragement27 => 'そう！新記録です。';

  @override
  String get recordEncouragement28 => 'すごい！新記録！';

  @override
  String get recordEncouragement29 => '本当によくできました。';

  @override
  String get repEstimationDescription => '今行った回数を予測します';

  @override
  String get durationEstimationDescription => '有酸素運動の時間を予測します';

  @override
  String get showGraphXAxisToggle => 'グラフのX軸切り替えを表示';

  @override
  String get showGraphXAxisToggleDescription => 'グラフに時間ベースのX軸切り替えを表示します';

  @override
  String get showGraphLimitDescription => 'グラフに上限スライダーを表示します';

  @override
  String get defaultTimeBasedXAxis => '時間ベースのX軸をデフォルトにする';

  @override
  String get defaultTimeBasedXAxisDescription => 'グラフでは時間ベースのX軸をデフォルトで使用します';

  @override
  String get createFirstTrainingPlan => '最初のトレーニングプランを作成して始めましょう。';

  @override
  String nothingMatchesPlanSearch(String query) {
    return '「$query」に一致する項目はありません。新しいプランとして作成できます。';
  }

  @override
  String get createPlan => 'プランを作成';

  @override
  String createNamedPlan(String name) {
    return '「$name」を作成';
  }

  @override
  String setNumber(int number) {
    return 'セット $number';
  }
}
