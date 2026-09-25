// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsLanguageDescription => 'Выберите язык интерфейса Flexify';

  @override
  String get languageSystemDefault => 'Система по умолчанию';

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
  String get navHistory => 'История';

  @override
  String get navPlans => 'Планы';

  @override
  String get navGraphs => 'Графики';

  @override
  String get navTimer => 'таймер';

  @override
  String get navSettings => 'Настройки';

  @override
  String get errorLabel => 'ошибка';

  @override
  String get tabContentError => 'Не смог создать содержимое вкладки.';

  @override
  String get cannotHideAllTabs => 'Не могу все скрыть!';

  @override
  String removeTabQuestion(String tab) {
    return 'Удалить вкладку $tab?';
  }

  @override
  String get restoreTabFromSettings =>
      'Вы можете добавить его позже из настроек.';

  @override
  String removedTab(String tab) {
    return 'Вкладка «$tab» удалена';
  }

  @override
  String newVersion(String version) {
    return 'Новая версия $version';
  }

  @override
  String get changes => 'Изменения';

  @override
  String get searchHint => 'Поиск...';

  @override
  String get deleteSelected => 'Выбранное исключение';

  @override
  String get confirmDelete => 'Подтвердить удаление';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Вы уверены, что хотите удалить $count записи? Это действие нельзя отменить.',
      many:
          'Вы уверены, что хотите удалить $count записей? Это действие нельзя отменить.',
      few:
          'Вы уверены, что хотите удалить $count записи? Это действие нельзя отменить.',
      one:
          'Вы уверены, что хотите удалить $count запись? Это действие нельзя отменить.',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'отменить';

  @override
  String get actionDelete => 'Исключить';

  @override
  String get actionRemove => 'Удалить';

  @override
  String get actionEdit => 'Редактировать';

  @override
  String get actionShare => 'Доля';

  @override
  String get clearSelection => 'Ясный выбор';

  @override
  String get clearSearch => 'Четкий поиск';

  @override
  String get showMenu => 'Показать меню';

  @override
  String get selectAll => 'Выберите все';

  @override
  String get weightLabel => 'вес';

  @override
  String get filter => 'фильтр';

  @override
  String get filters => 'Фильтры';

  @override
  String get categoryLabel => 'Категория';

  @override
  String get repsLabel => 'Ответы';

  @override
  String get repsFilter => 'Фильтр повторений';

  @override
  String get weightFilter => 'Весовой фильтр';

  @override
  String get greaterThan => 'Больше, чем';

  @override
  String get lessThan => 'меньше чем';

  @override
  String get startDate => 'Дата начала';

  @override
  String get endDate => 'Дата окончания';

  @override
  String get actionClear => 'Чисто.';

  @override
  String get actionOk => 'ОК';

  @override
  String get actionClose => 'Закрыть';

  @override
  String get sortBy => 'Сортировать по';

  @override
  String get dateNewest => 'Дата (новейшая)';

  @override
  String get dateOldest => 'Дата (самая старая)';

  @override
  String get nameLabel => 'Имя';

  @override
  String get missingPermissions => 'Пропущенные разрешения';

  @override
  String get restTimersPermissionsMissing =>
      'Время отдыха включено, но разрешения отсутствуют.';

  @override
  String get restTimersPermissionsOptional =>
      'Если вы отключите таймеры отдыха, то эти разрешения не нужны.';

  @override
  String get restTimers => 'Время отдыха';

  @override
  String get disableBatteryOptimizations => 'Отключите оптимизацию батареи';

  @override
  String get batteryOptimizationWarning =>
      'Прогресс может приостановиться, если оптимизация батареи будет продолжаться.';

  @override
  String get scheduleExactAlarm => 'Расписание точной тревоги';

  @override
  String get exactAlarmWarning =>
      'Сигнал тревоги не может быть точным, если он отключен.';

  @override
  String get postNotifications => 'Пост уведомления';

  @override
  String get notificationBarDescription =>
      'Прогресс таймера отображается в панели уведомлений';

  @override
  String get invalidPermissions => 'Недействительные разрешения';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      'Время отдыха включено без достаточных разрешений. Ты уверен?';

  @override
  String get actionConfirm => 'Подтвердите';

  @override
  String get appAccess => 'Доступ к приложению';

  @override
  String get appAccessDescription =>
      'Требуется для включения таймеров и уведомлений.';

  @override
  String get notifications => 'Уведомления';

  @override
  String get timerProgressAndRestAlerts =>
      'Прогресс таймера и предупреждения об отдыхе';

  @override
  String get enabledNotificationsDescription =>
      'Уведомления, которые вы включили';

  @override
  String get backgroundActivity => 'Справочная деятельность';

  @override
  String get backgroundActivityDescription =>
      'Держите таймеры надежными в фоновом режиме';

  @override
  String get exactAlarms => 'Точная тревога';

  @override
  String get exactAlarmsDescription =>
      'Оповещение, когда заканчивается таймер отдыха';

  @override
  String get noAdditionalAndroidAccessNeeded =>
      'Для текущих настроек дополнительный доступ Android не требуется.';

  @override
  String get actionDone => 'Сделано';

  @override
  String get allowed => 'допускается';

  @override
  String get actionAllow => 'Разрешить';

  @override
  String get backupLabel => 'Резервное копирование';

  @override
  String get databaseLabel => 'База данных';

  @override
  String get deleteRecords => 'Исключить записи';

  @override
  String get deleteAllGraphsConfirmation =>
      'Вы уверены, что хотите удалить все графы? Это действие не обратимо.';

  @override
  String get deleteAllPlansConfirmation =>
      'Вы уверены, что хотите удалить все планы? Это действие не обратимо.';

  @override
  String get deleteDatabaseConfirmation =>
      'Вы уверены, что хотите удалить свою базу данных? Это действие не является обратимым и уничтожит все ваши данные.';

  @override
  String get importData => 'Данные импорта';

  @override
  String get exportData => 'Экспортные данные';

  @override
  String get actionReport => 'Доклад';

  @override
  String get graphDataImported => 'Графические данные успешно импортированы!';

  @override
  String get plansImported => 'Планы импорта успешно';

  @override
  String failedToImportDatabase(String error) {
    return 'Не удалось импортировать базу данных: $error';
  }

  @override
  String get backupArchiveMissingDatabase =>
      'В архиве резервной копии нет базы данных Flexify.';

  @override
  String failedToImportGraphs(String error) {
    return 'Не удалось импортировать графики: $error';
  }

  @override
  String failedToImportPlans(String error) {
    return 'Не удалось импортировать планы: $error';
  }

  @override
  String get selectedFileDoesNotExist => 'Выбранного файла не существует';

  @override
  String get couldNotReadFileData => 'Не читать файловые данные';

  @override
  String get databaseImportWebUnsupported =>
      'Импорт базы данных в веб-версии требует ручного переноса данных. Экспортируйте данные в CSV и импортируйте эти файлы.';

  @override
  String get csvFileEmpty => 'Файл CSV пуст';

  @override
  String get csvNeedsDataRow =>
      'Файл CSV должен содержать как минимум одну строку данных.';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return 'В строке $row недостаточно столбцов: $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return 'Недопустимое значение $field в строке $row: $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return 'Недопустимый тип данных $field в строке $row: $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return 'Ожидался целочисленный идентификатор плана, получено «$value»';
  }

  @override
  String get unitLabel => 'Подразделение';

  @override
  String get kilogramsUnit => 'Килограммы (кг)';

  @override
  String get poundsUnit => 'Фунты (lb)';

  @override
  String get stoneUnit => 'Камень';

  @override
  String get stoneUnitShort => 'ствол';

  @override
  String get kilometersUnit => 'Километры (км)';

  @override
  String get milesUnit => 'Майлз (ми)';

  @override
  String get metersUnit => 'Метры (м)';

  @override
  String get kilocaloriesUnit => 'Килокалории (ккал)';

  @override
  String get enterWeight => 'Введите вес';

  @override
  String get requiredField => 'требуемый';

  @override
  String get invalidNumber => 'Недействительное число';

  @override
  String get previousWeight => 'Предыдущий вес';

  @override
  String get imageLabel => 'Изображение';

  @override
  String get longPressToDelete => 'Нажмите и удерживайте, чтобы удалить';

  @override
  String get imageError => 'Ошибка изображения';

  @override
  String get actionSave => 'Спасти';

  @override
  String get aboutTitle => 'О нас';

  @override
  String get donate => 'Пожертвование';

  @override
  String get helpSupportProject => 'Помогите поддержать этот проект';

  @override
  String get whatsNewAbout => 'Что нового?';

  @override
  String get whatsNewTitle => 'Что нового?';

  @override
  String get seeReleaseNotes => 'См. наши выпускные заметки';

  @override
  String get versionLabel => 'Версия';

  @override
  String get authorLabel => 'Автор';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get privacyPolicyDescription => 'Как Flexify обрабатывает ваши данные';

  @override
  String get licenseLabel => 'Лицензия';

  @override
  String get sourceCode => 'Исходный код';

  @override
  String get sourceCodeDescription => 'Открыть исходный код на GitHub';

  @override
  String get leaveReview => 'Оставить отзыв';

  @override
  String get leaveReviewDescription => 'Оцените Flexify в Play Store';

  @override
  String get reportBug => 'Сообщить об ошибке';

  @override
  String get reportBugDescription => 'Создать обращение на GitHub';

  @override
  String get failedMigrations => 'Неудачные миграции';

  @override
  String get errorMessageLabel => 'Сообщение об ошибке:';

  @override
  String get createIssue => 'Создать проблему';

  @override
  String get addExercise => 'Добавить упражнение';

  @override
  String get cardio => 'Кардио';

  @override
  String get strength => 'Сила';

  @override
  String get options => 'Варианты';

  @override
  String get periodDay => 'День';

  @override
  String get periodWeek => 'Неделя';

  @override
  String get periodMonth => 'месяц';

  @override
  String get periodYear => 'Год';

  @override
  String noDataFor(String name) {
    return 'Пока нет данных по $name';
  }

  @override
  String get noDataYet => 'Нет данных пока';

  @override
  String get exerciseNotes => 'Записи упражнений';

  @override
  String get notesForExercise => 'Примечания к этому упражнению';

  @override
  String get useTimeBasedXAxis => 'Использовать временную ось X';

  @override
  String updateAllNamed(String name) {
    return 'Обновить все «$name»';
  }

  @override
  String get newName => 'Новое имя';

  @override
  String get restMinutes => 'Время отдыха';

  @override
  String get restSeconds => 'секунды отдыха';

  @override
  String get globalProgress => 'Глобальный прогресс';

  @override
  String get curveLineGraphs => 'Графики кривых линий';

  @override
  String get curveLineGraphsDescription =>
      'Нарисуйте графовые линии как плавные кривые';

  @override
  String noHistoryFor(String name) {
    return 'Пока нет истории для $name';
  }

  @override
  String get cancelSelection => 'Отменить выбор';

  @override
  String get editSelected => 'Избранный редактор';

  @override
  String get newExercise => 'Новое упражнение';

  @override
  String get noGraphsFound => 'Графики не найдены';

  @override
  String get searchGraphs => 'Поисковые графы...';

  @override
  String get actionAdd => 'Добавить';

  @override
  String get actionUpdate => 'обновление';

  @override
  String get hideGlobalProgress => 'Скрыть глобальный прогресс';

  @override
  String get chartGroupedByCategory => 'График, сгруппированный по категориям';

  @override
  String get noExercisesFound => 'Никаких упражнений не найдено';

  @override
  String get savePlan => 'План спасения';

  @override
  String get titleOptional => 'Название (факультативно)';

  @override
  String get searchExercises => 'Поисковые упражнения...';

  @override
  String get warmupSets => 'Разминочные подходы';

  @override
  String get workingSetsMax => 'Рабочие наборы (максимум: 20)';

  @override
  String get actionUndo => 'Снять';

  @override
  String get actionSwap => 'Своп';

  @override
  String get daily => 'ежедневно';

  @override
  String get weekly => 'еженедельно';

  @override
  String get monthly => 'ежемесячно';

  @override
  String get yearly => 'ежегодно';

  @override
  String get unexpectedError =>
      'Что-то пошло не так. Пожалуйста, попробуйте еще раз.';

  @override
  String get loadingExercises => 'Загрузочные упражнения...';

  @override
  String get noPlansYet => 'Никаких планов пока';

  @override
  String get noMatchingPlans => 'Никаких планов соответствия';

  @override
  String get newPlan => 'Новый план';

  @override
  String get searchPlans => 'Планы поиска...';

  @override
  String get noExercisesYet => 'Никаких упражнений пока';

  @override
  String get editPlan => 'Редактировать план';

  @override
  String get saveSet => 'Сохранить';

  @override
  String get minutesLabel => 'Минуты';

  @override
  String get minutesShort => 'мин.';

  @override
  String get secondsLabel => 'секунды';

  @override
  String get distanceLabel => 'расстояние';

  @override
  String get inclinePercent => 'Наклон %';

  @override
  String weightWithUnit(String unit) {
    return 'Вес ($unit)';
  }

  @override
  String get useBodyWeight => 'Используйте вес тела';

  @override
  String get noWeightEnteredYet => 'Веса еще не было';

  @override
  String get notesLabel => 'Заметки';

  @override
  String get swapWorkout => 'Тренировка по свопу';

  @override
  String get addSet => 'Добавить';

  @override
  String get deleteSet => 'Удалить набор';

  @override
  String get oneRepMaxEstimate => 'Максимум на одно повторение (оценка)';

  @override
  String get valueLabel => 'ценность';

  @override
  String amountWithUnit(String unit) {
    return 'Количество ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return 'Расстояние ($unit)';
  }

  @override
  String get bodyWeightLabel => 'Вес тела';

  @override
  String bodyWeightWithUnit(String unit) {
    return 'Масса тела ($unit)';
  }

  @override
  String get categoryHelper =>
      'Выберите существующую категорию или наберите новую.';

  @override
  String get manageCategories => 'Управление категориями';

  @override
  String get manageCategoriesDescription =>
      'Создание, переименование, слияние или удаление категорий';

  @override
  String get newCategory => 'Новая категория';

  @override
  String get renameCategory => 'Категория имен';

  @override
  String get mergeCategory => 'Слиться в другую категорию';

  @override
  String get noCategories => 'Пока нет категорий';

  @override
  String get categoryNameRequired => 'Введите название категории';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Используется в $count записях',
      many: 'Используется в $count записях',
      few: 'Используется в $count записях',
      one: 'Используется в $count записи',
      zero: 'Не используется ни в одной записи',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Удалить эту категорию и убрать её из $count записи?',
      many: 'Удалить эту категорию и убрать её из $count записей?',
      few: 'Удалить эту категорию и убрать её из $count записей?',
      one: 'Удалить эту категорию и убрать её из $count записи?',
      zero: 'Удалить эту категорию?',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => 'Созданная дата';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Изменить $count подхода',
      many: 'Изменить $count подходов',
      few: 'Изменить $count подхода',
      one: 'Изменить $count подход',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => 'Пока нет записей';

  @override
  String get historyEmptyMessage =>
      'Заполните набор или добавьте его вручную, чтобы начать свою историю.';

  @override
  String deleteSetConfirmation(String name) {
    return 'Хотите удалить $name?';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вы уверены, что хотите удалить $count записи?',
      many: 'Вы уверены, что хотите удалить $count записей?',
      few: 'Вы уверены, что хотите удалить $count записи?',
      one: 'Вы уверены, что хотите удалить $count запись?',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => 'Поиск истории...';

  @override
  String get themeSystem => 'Система';

  @override
  String get themeDark => 'темный';

  @override
  String get themeLight => 'Свет';

  @override
  String get pureBlackAmoled => 'Чистый черный (AMOLED)';

  @override
  String get showImages => 'Показать изображения';

  @override
  String get peekGraph => 'Пик-граф';

  @override
  String get inputStyleLine => 'линия';

  @override
  String get inputStyleOutlined => 'изложенный';

  @override
  String get inputStyleFilled => 'заполненный';

  @override
  String get inputStyle => 'Стиль ввода';

  @override
  String get appearance => 'внешний вид';

  @override
  String get automaticBackupsEnabled =>
      'Автоматическое резервное копирование включено';

  @override
  String get automaticBackup => 'Автоматическое резервное копирование';

  @override
  String get appPermissions => 'Разрешения приложения';

  @override
  String get shareDatabase => 'Поделиться базой данных';

  @override
  String get dataManagement => 'Управление данными';

  @override
  String get strengthUnit => 'Силовой блок';

  @override
  String get lastEntry => 'Последняя запись';

  @override
  String get cardioUnit => 'Кардиосистема';

  @override
  String longDateFormat(String format) {
    return 'Формат длинной даты ($format)';
  }

  @override
  String get formats => 'Форматы';

  @override
  String get setsPerExerciseMax => 'Наборы за упражнение (максимум: 20)';

  @override
  String get countLabel => 'граф';

  @override
  String get ratioLabel => 'Соотношение';

  @override
  String get reorder => 'порядок';

  @override
  String get none => 'Никто';

  @override
  String get monday => 'понедельник';

  @override
  String get examplePlanExercises => 'Жим лёжа, приседания, становая тяга';

  @override
  String get tabs => 'Закладки';

  @override
  String get swipeBetweenTabs => 'Прокрутка между вкладками';

  @override
  String get vibrate => 'Вибрировать';

  @override
  String get enableSound => 'Включить звук';

  @override
  String get keepScreenOn => 'Держите экран';

  @override
  String get alarmSound => 'Тревожный звук';

  @override
  String get top => 'Топ';

  @override
  String get bottom => 'нижняя часть';

  @override
  String get removeCustomTimer =>
      'Удалить пользовательский таймер (использовать глобальный дефолт)';

  @override
  String get timers => 'Тимерс';

  @override
  String get timerSettings => 'Настройки таймера';

  @override
  String get groupHistory => 'История группы';

  @override
  String get showUnits => 'Показать единицы';

  @override
  String get showBodyWeight => 'Показать вес тела';

  @override
  String get showCategories => 'Показать категории';

  @override
  String get showNotes => 'Показать ноты';

  @override
  String get repEstimation => 'Оценка';

  @override
  String get durationEstimation => 'Оценка продолжительности';

  @override
  String get showGraphLimit => 'Показать лимит графа';

  @override
  String get defaultGraphMetric => 'Метрика графа по умолчанию';

  @override
  String get bestWeight => 'Лучший вес';

  @override
  String get bestReps => 'Лучшие реплики';

  @override
  String get oneRepMax => 'Максимум на одно повторение';

  @override
  String get volume => 'Объем';

  @override
  String get paceCardio => 'Темп (кардио)';

  @override
  String get distanceCardio => 'Расстояние (кардио)';

  @override
  String get defaultGraphPeriod => 'Период графа по умолчанию';

  @override
  String get defaultGraphLimit => 'Предел графа по умолчанию';

  @override
  String get workouts => 'тренировки';

  @override
  String get actionStop => 'Стоп!';

  @override
  String get timerFinishedToast => 'Таймер закончил!';

  @override
  String get stopTimer => 'Остановить таймер';

  @override
  String get actionPause => 'Пауза';

  @override
  String get startStopwatch => 'Запустить секундомер';

  @override
  String get actionStart => 'Начинать';

  @override
  String get actionRestart => 'Перезапустить';

  @override
  String get addOneMinute => '+1 минута';

  @override
  String get addOneMinuteNotification => 'Добавить 1 мин.';

  @override
  String get restTimer => 'Время отдыха';

  @override
  String get timerUp => 'Время';

  @override
  String get openNotification => 'Открытое уведомление';

  @override
  String get timerChannelName => 'Таймер';

  @override
  String get timerChannelDescription => 'Текущий прогресс таймеров отдыха.';

  @override
  String get timerFinishedChannelName => 'Завершение таймера';

  @override
  String get timerFinishedChannelDescription =>
      'Воспроизводит сигнал после завершения таймера отдыха.';

  @override
  String get timerFinished => 'Таймер закончил';

  @override
  String get batteryOptimizationRequestUnavailable =>
      'Запросы на игнорирование оптимизации батареи отключены на вашем устройстве.';

  @override
  String get exactAlarmRequestUnavailable =>
      'Запрос SCHEDULE_EXACT_ALARM отклонён на вашем устройстве';

  @override
  String get databaseMigrationFailureDescription =>
      'Что-то пошло не так при создании или обновлении базы данных. Обычно это может быть исправлено путем удаления и повторного создания ваших записей.';

  @override
  String get curveSmoothness => 'гладкость кривой';

  @override
  String get actionBack => 'Назад';

  @override
  String get atLeastOneTab => 'Вам нужна хотя бы одна вкладка';

  @override
  String get invalidTabSettings => 'Недействительные настройки вкладки.';

  @override
  String get noSettingsFound => 'Настройки не найдены';

  @override
  String nothingMatchesSearch(String query) {
    return 'Ничто не совпадает с «$query».';
  }

  @override
  String get appearanceDescription => 'Тема, цвета и дизайн интерфейса';

  @override
  String get dataManagementDescription =>
      'Импорт, экспорт и управление данными тренировки';

  @override
  String get formatsDescription => 'Даты, цифры и форматирование измерений';

  @override
  String get plansSettingsDescription =>
      'Дефолты и поведение для планов тренировок';

  @override
  String get tabsDescription =>
      'Выберите и устройте основные навигационные вкладки';

  @override
  String get timersDescription => 'Продолжительность отдыха, звук и поведение';

  @override
  String get workoutsDescription =>
      'Отслеживание упражнений и предпочтения в тренировках';

  @override
  String get completeSetForChart =>
      'Заполните набор для этого упражнения, чтобы построить свою диаграмму.';

  @override
  String get dateRange => 'диапазон дат';

  @override
  String get stopDate => 'Остановить дату';

  @override
  String get dataPoints => 'Пункты данных';

  @override
  String get completeSetsForProgress =>
      'Заполните несколько наборов, чтобы построить свою диаграмму прогресса.';

  @override
  String get relativeStrength => 'Относительная сила';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Выбрано $count',
      many: 'Выбрано $count',
      few: 'Выбрано $count',
      one: 'Выбрана $count',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory =>
      'Заполните некоторые наборы, чтобы увидеть эту историю упражнений здесь.';

  @override
  String get completeSetForFirstGraph =>
      'Заполните набор, чтобы создать свой первый график упражнений.';

  @override
  String nothingMatchesGraphSearch(String query) {
    return 'Ничто не совпадает с «$query». Вы можете сделать это как новое упражнение.';
  }

  @override
  String addNamed(String name) {
    return 'Добавить «$name»';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return 'Это позволит удалить записи $count. Ты уверен?';
  }

  @override
  String shareWorkout(String summary) {
    return 'Я только что сделал $summary';
  }

  @override
  String get updateConflict => 'Обновление конфликта';

  @override
  String updateConflictDescription(int count) {
    return 'Ваше новое имя уже существует для записей $count. Ты уверен?';
  }

  @override
  String get unitsConflict => 'Единицы конфликта';

  @override
  String unitsConflictDescription(String unit) {
    return 'Не все ваши записи имеют одинаковую единицу. Это позволит конвертировать все агрегаты в $unit. Ты уверен?';
  }

  @override
  String get durationLabel => 'Продолжительность';

  @override
  String get inclineLabel => 'Наклон';

  @override
  String get paceDistanceTime => 'Расстояние/время';

  @override
  String get adjustedPace => 'Скорректированный темп';

  @override
  String get oneRepMaxAccuracyWarning =>
      'Оценки максимума одного повторения менее точны для наборов 10+ повторений';

  @override
  String get addPlan => 'Добавить план';

  @override
  String get planDetails => 'Подробности плана';

  @override
  String get exercisesLabel => 'упражнения';

  @override
  String get addExerciseToPlan => 'Добавьте упражнение к этому плану.';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return 'Ничто не совпадает с «$query». Вы можете добавить его в качестве нового упражнения.';
  }

  @override
  String get selectDays => 'Выбрать дни';

  @override
  String get selectExercises => 'Выберите упражнения';

  @override
  String get todayLabel => 'Сегодня';

  @override
  String get setDetails => 'Установить детали';

  @override
  String get themeLabel => 'Тема';

  @override
  String get pureBlackAmoledDescription =>
      'Используйте чистые черные цвета для дисплеев AMOLED';

  @override
  String get systemColorScheme => 'Система цветовых схем';

  @override
  String get systemColorSchemeDescription =>
      'Используйте основной цвет вашего устройства для приложения';

  @override
  String get showImagesDescription =>
      'Выберите / отобразите изображения на странице истории';

  @override
  String get showGlobalProgress => 'Показать глобальный прогресс';

  @override
  String get showGlobalProgressDescription =>
      'Добавьте запись графа, отображающую ваш прогресс по категориям';

  @override
  String get peekGraphDescription =>
      'Показать первую строку графа на странице графов';

  @override
  String get inputStyleDescription => 'Визуальный стиль текстовых полей ввода';

  @override
  String get automaticBackupNotificationBody =>
      'Flexify будет автоматически копировать ваши данные и изображения в выбранную папку каждый день.';

  @override
  String get backupSettingsChannel => 'Настройки резервного копирования';

  @override
  String get backupSettingsChannelDescription =>
      'Уведомления, объясняющие автоматическое резервное копирование';

  @override
  String get backupChannelName => 'Резервный канал';

  @override
  String get backupChannelDescription =>
      'Автоматические резервные копии данных и изображений Flexify';

  @override
  String get backupCompletedTitle =>
      'Резервное копирование данных и изображений';

  @override
  String get backupFailurePathNotSet =>
      'Резервное копирование не удалось: путь резервного копирования не установлен. Автоматическое резервное копирование отключено.';

  @override
  String get backupFailureDirectoryUnavailable =>
      'Резервное копирование не удалось: не удалось получить доступ к каталогу резервного копирования. Автоматическое резервное копирование отключено.';

  @override
  String get backupFailureCreateFile =>
      'Резервное копирование не удалось: не удалось создать резервный файл. Автоматическое резервное копирование отключено.';

  @override
  String get backupFailureAppFilesUnavailable =>
      'Резервное копирование не удалось: не удалось получить доступ к каталогу файлов приложений. Автоматическое резервное копирование отключено.';

  @override
  String get backupFailureDatabaseMissing =>
      'Резервное копирование не удалось: файл базы данных не найден. Автоматическое резервное копирование отключено.';

  @override
  String get backupFailureOutputUnavailable =>
      'Резервное копирование не удалось: не удалось открыть выходной поток. Автоматическое резервное копирование отключено.';

  @override
  String get backupFailureUnknown =>
      'Резервное копирование провалилось. Автоматическое резервное копирование отключено.';

  @override
  String get appPermissionsDescription =>
      'Доступ к обзору, требуемый вашими включенными функциями';

  @override
  String get longDateFormatDescription => 'Используется там, где много места';

  @override
  String shortDateFormat(String example) {
    return 'Формат короткой даты ($example)';
  }

  @override
  String get shortDateFormatDescription =>
      'Для того, где пространство ограничено (линии Графа)';

  @override
  String get warmupSetsDescription =>
      'Разминочные подходы не запускают таймер отдыха';

  @override
  String get setsPerExerciseDescription => 'Дефолт #упражнения в плане';

  @override
  String get planTrailingDisplay => 'Дополнительная информация плана';

  @override
  String get planTrailingDisplayDescription =>
      'Правая сторона списка в разделах «Планы» и «План»';

  @override
  String get restTimersDescription =>
      'Тревога, которая срабатывает после завершения набора';

  @override
  String get vibrateDescription => 'Должны ли таймеры отдыха вибрировать?';

  @override
  String get enableSoundDescription =>
      'Должны ли таймеры отдыха воспроизводить звук?';

  @override
  String get keepScreenOnDescription =>
      'Держите экран включенным во время отдыха';

  @override
  String get restDurationDescription =>
      'Как долго, прежде чем сработает сигнализация?';

  @override
  String get globalDefault => 'Глобальный дефолт';

  @override
  String get alarmSoundDescription => 'Музыка для игры в конце таймера отдыха';

  @override
  String get progressBarPosition => 'Прогресс бар позиции';

  @override
  String get progressBarPositionDescription =>
      'Где должны быть размещены таймеры прогресса?';

  @override
  String get perExerciseRestTimes => 'Время отдыха на тренировках';

  @override
  String get perExerciseRestTimesDescription =>
      'Эти упражнения имеют собственную продолжительность отдыха';

  @override
  String get audioFeaturesUnavailable => 'Аудио функции недоступны';

  @override
  String get groupHistoryDescription => 'Объединить записи истории по дням';

  @override
  String get showUnitsDescription =>
      'Показывать км/мили и кг/фунты в графиках, истории и планах';

  @override
  String get showBodyWeightDescription =>
      'Включить/отключить отслеживание массы тела';

  @override
  String get showCategoriesDescription =>
      'Категории включения/отключения тренировки';

  @override
  String get showNotesDescription =>
      'Запись деталей вашего лифта в текстовой области';

  @override
  String get positiveNotificationsDescription =>
      'Пишите хорошие сообщения, когда побит новый рекорд';

  @override
  String get positiveMessagesEnabled =>
      'Позитивные сообщения появляются вот так!';

  @override
  String get recordEncouragement01 => 'Отличная работа! Ты невероятен.';

  @override
  String get recordEncouragement02 =>
      'Отлично, король! Твой прогресс вдохновляет.';

  @override
  String get recordEncouragement03 => 'Я на коленях...';

  @override
  String get recordEncouragement04 => 'Что это? Новый рекорд!';

  @override
  String get recordEncouragement05 => 'Невероятные вещи! Ты - вдохновение.';

  @override
  String get recordEncouragement06 => 'Вау. Мило.';

  @override
  String get recordEncouragement07 => 'Становишься сильным?';

  @override
  String get recordEncouragement08 => 'Ага. Ты довольно большой парень.';

  @override
  String get recordEncouragement09 => 'Удивительно. Невероятно.';

  @override
  String get recordEncouragement10 => 'Арни был бы горд.';

  @override
  String get recordEncouragement11 => 'Ронни Си смотрит на тебя с радостью.';

  @override
  String get recordEncouragement12 => 'ДА! ЛЁГКИЙ ВЕС, ДЕТКА!!!!!!!';

  @override
  String get recordEncouragement13 =>
      'Это новый рекорд? Я знал, что ты сможешь.';

  @override
  String get recordEncouragement14 => 'Отличная работа! Я горжусь тобой.';

  @override
  String get recordEncouragement15 => 'Да, детка! Легкий вес!';

  @override
  String get recordEncouragement16 => 'Продолжай! Большой прогресс.';

  @override
  String get recordEncouragement17 => 'Ты так хорошо справляешься.';

  @override
  String get recordEncouragement18 => 'Это мой мальчик!';

  @override
  String get recordEncouragement19 => 'Продолжай.';

  @override
  String get recordEncouragement20 => 'Ты становишься очень сильным.';

  @override
  String get recordEncouragement21 => 'Мощный.';

  @override
  String get recordEncouragement22 => 'Мощная штука!';

  @override
  String get recordEncouragement23 => 'Я горжусь тобой.';

  @override
  String get recordEncouragement24 => 'Продолжайте большую работу.';

  @override
  String get recordEncouragement25 =>
      'Стоять высоко! Вы только что сделали новый рекорд.';

  @override
  String get recordEncouragement26 =>
      'Новый рекорд! Вы просто продвинулись дальше, чем когда-либо!';

  @override
  String get recordEncouragement27 => 'Ага! Это рекорд.';

  @override
  String get recordEncouragement28 => 'Вау! Новый рекорд!';

  @override
  String get recordEncouragement29 => 'Очень хорошие вещи.';

  @override
  String get repEstimationDescription =>
      'Попробуйте предсказать # повторений, которые вы только что сделали';

  @override
  String get durationEstimationDescription =>
      'Попробуйте предсказать продолжительность вашего кардио';

  @override
  String get showGraphXAxisToggle => 'Показывать переключатель оси X графика';

  @override
  String get showGraphXAxisToggleDescription =>
      'Показывать переключатель временной оси X на графиках';

  @override
  String get showGraphLimitDescription =>
      'Показать лимитный ползунок на графиках';

  @override
  String get defaultTimeBasedXAxis => 'Временная ось X по умолчанию';

  @override
  String get defaultTimeBasedXAxisDescription =>
      'Использовать временную ось X на графиках по умолчанию';

  @override
  String get createFirstTrainingPlan =>
      'Создайте свой первый учебный план, чтобы начать.';

  @override
  String nothingMatchesPlanSearch(String query) {
    return 'Ничто не совпадает с «$query». Вы можете создать его как новый план.';
  }

  @override
  String get createPlan => 'Создать план';

  @override
  String createNamedPlan(String name) {
    return 'Создание «$name»';
  }

  @override
  String setNumber(int number) {
    return 'Подход $number';
  }
}
