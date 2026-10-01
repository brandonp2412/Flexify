// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => 'Мова';

  @override
  String get settingsLanguageDescription => 'Виберіть мову інтерфейсу Flexify';

  @override
  String get languageSystemDefault => 'Системна за замовчуванням';

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
  String get languageNameMalay => 'Bahasa Melayu';

  @override
  String get languageNameUkrainian => 'Українська';

  @override
  String get navHistory => 'Історія';

  @override
  String get navPlans => 'Плани';

  @override
  String get navGraphs => 'Графіки';

  @override
  String get navTimer => 'Таймер';

  @override
  String get navSettings => 'Налаштування';

  @override
  String get errorLabel => 'Помилка';

  @override
  String get tabContentError => 'Не вдалося створити вміст вкладки.';

  @override
  String get cannotHideAllTabs => 'Не можна приховати всі вкладки!';

  @override
  String removeTabQuestion(String tab) {
    return 'Видалити вкладку $tab?';
  }

  @override
  String get restoreTabFromSettings =>
      'Її можна буде додати назад пізніше в налаштуваннях.';

  @override
  String removedTab(String tab) {
    return 'Вкладку $tab видалено';
  }

  @override
  String newVersion(String version) {
    return 'Нова версія $version';
  }

  @override
  String get changes => 'Зміни';

  @override
  String get searchHint => 'Пошук…';

  @override
  String get deleteSelected => 'Видалити вибране';

  @override
  String get confirmDelete => 'Підтвердити видалення';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Ви впевнені, що хочете видалити $count запису? Цю дію не можна скасувати.',
      many:
          'Ви впевнені, що хочете видалити $count записів? Цю дію не можна скасувати.',
      few:
          'Ви впевнені, що хочете видалити $count записи? Цю дію не можна скасувати.',
      one:
          'Ви впевнені, що хочете видалити $count запис? Цю дію не можна скасувати.',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'Скасувати';

  @override
  String get actionDiscard => 'Відкинути';

  @override
  String get unsavedChanges => 'Незбережені зміни';

  @override
  String get discardUnsavedChanges => 'Відкинути незбережені зміни?';

  @override
  String get actionDelete => 'Видалити';

  @override
  String get actionRemove => 'Вилучити';

  @override
  String get actionEdit => 'Редагувати';

  @override
  String get actionShare => 'Поділитися';

  @override
  String get clearSelection => 'Очистити вибір';

  @override
  String get clearSearch => 'Очистити пошук';

  @override
  String get showMenu => 'Показати меню';

  @override
  String get selectAll => 'Вибрати все';

  @override
  String get weightLabel => 'Вага';

  @override
  String get filter => 'Фільтр';

  @override
  String get filters => 'Фільтри';

  @override
  String get categoryLabel => 'Категорія';

  @override
  String get repsLabel => 'Повторення';

  @override
  String get repsFilter => 'Фільтр повторень';

  @override
  String get weightFilter => 'Фільтр ваги';

  @override
  String get greaterThan => 'Більше ніж';

  @override
  String get lessThan => 'Менше ніж';

  @override
  String get startDate => 'Дата початку';

  @override
  String get endDate => 'Дата завершення';

  @override
  String get actionClear => 'Очистити';

  @override
  String get actionOk => 'Гаразд';

  @override
  String get actionClose => 'Закрити';

  @override
  String get sortBy => 'Сортувати за';

  @override
  String get dateNewest => 'Дата (спочатку нові)';

  @override
  String get dateOldest => 'Дата (спочатку старі)';

  @override
  String get nameLabel => 'Назва';

  @override
  String get missingPermissions => 'Відсутні дозволи';

  @override
  String get restTimersPermissionsMissing =>
      'Таймери відпочинку ввімкнено, але потрібних дозволів немає.';

  @override
  String get restTimersPermissionsOptional =>
      'Якщо вимкнути таймери відпочинку, ці дозволи не потрібні.';

  @override
  String get restTimers => 'Таймери відпочинку';

  @override
  String get disableBatteryOptimizations => 'Вимкнути оптимізацію батареї';

  @override
  String get batteryOptimizationWarning =>
      'Якщо оптимізація батареї залишиться ввімкненою, прогрес може призупинятися.';

  @override
  String get scheduleExactAlarm => 'Запланувати точний будильник';

  @override
  String get exactAlarmWarning =>
      'Якщо це вимкнено, будильники можуть спрацьовувати неточно.';

  @override
  String get postNotifications => 'Надсилати сповіщення';

  @override
  String get notificationBarDescription =>
      'Перебіг таймера показується на панелі сповіщень';

  @override
  String get invalidPermissions => 'Недостатні дозволи';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      'Таймери відпочинку ввімкнено без усіх потрібних дозволів. Продовжити?';

  @override
  String get actionConfirm => 'Підтвердити';

  @override
  String get appAccess => 'Доступ застосунку';

  @override
  String get appAccessDescription =>
      'Потрібен для ввімкнених таймерів і сповіщень.';

  @override
  String get notifications => 'Сповіщення';

  @override
  String get timerProgressAndRestAlerts =>
      'Перебіг таймера та сповіщення про відпочинок';

  @override
  String get enabledNotificationsDescription => 'Сповіщення, які ви ввімкнули';

  @override
  String get backgroundActivity => 'Фонова активність';

  @override
  String get backgroundActivityDescription =>
      'Забезпечує надійну роботу таймерів у фоновому режимі';

  @override
  String get exactAlarms => 'Точні будильники';

  @override
  String get exactAlarmsDescription =>
      'Сповіщає точно в момент завершення таймера відпочинку';

  @override
  String get noAdditionalAndroidAccessNeeded =>
      'Для поточних налаштувань додатковий доступ Android не потрібен.';

  @override
  String get actionDone => 'Готово';

  @override
  String get allowed => 'Дозволено';

  @override
  String get actionAllow => 'Дозволити';

  @override
  String get backupLabel => 'Резервна копія';

  @override
  String get databaseLabel => 'База даних';

  @override
  String get deleteRecords => 'Видалити записи';

  @override
  String get deleteAllGraphsConfirmation =>
      'Ви впевнені, що хочете видалити всі графіки? Цю дію не можна скасувати.';

  @override
  String get deleteAllPlansConfirmation =>
      'Ви впевнені, що хочете видалити всі плани? Цю дію не можна скасувати.';

  @override
  String get deleteDatabaseConfirmation =>
      'Ви впевнені, що хочете видалити базу даних? Цю дію не можна скасувати, і всі ваші дані буде знищено.';

  @override
  String get importData => 'Імпортувати дані';

  @override
  String get exportData => 'Експортувати дані';

  @override
  String get actionReport => 'Звіт';

  @override
  String get graphDataImported => 'Дані графіків успішно імпортовано!';

  @override
  String get plansImported => 'Плани успішно імпортовано';

  @override
  String failedToImportDatabase(String error) {
    return 'Не вдалося імпортувати базу даних: $error';
  }

  @override
  String get backupArchiveMissingDatabase =>
      'Архів резервної копії не містить бази даних Flexify.';

  @override
  String failedToImportGraphs(String error) {
    return 'Не вдалося імпортувати графіки: $error';
  }

  @override
  String failedToImportPlans(String error) {
    return 'Не вдалося імпортувати плани: $error';
  }

  @override
  String get selectedFileDoesNotExist => 'Вибраного файлу не існує';

  @override
  String get couldNotReadFileData => 'Не вдалося прочитати дані файлу';

  @override
  String get databaseImportWebUnsupported =>
      'Імпорт бази даних у вебверсії потребує ручного перенесення даних. Експортуйте дані у файли CSV та імпортуйте їх натомість.';

  @override
  String get csvFileEmpty => 'Файл CSV порожній';

  @override
  String get csvNeedsDataRow =>
      'Файл CSV має містити щонайменше один рядок даних';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return 'У рядку $row недостатньо стовпців: $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return 'Некоректне значення $field у рядку $row: $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return 'Некоректний тип даних $field у рядку $row: $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return 'Очікувався цілий ідентифікатор плану, отримано «$value»';
  }

  @override
  String get unitLabel => 'Одиниця';

  @override
  String get kilogramsUnit => 'Кілограми (кг)';

  @override
  String get poundsUnit => 'Фунти (lb)';

  @override
  String get stoneUnit => 'Стоун';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => 'Кілометри (км)';

  @override
  String get milesUnit => 'Милі (mi)';

  @override
  String get metersUnit => 'Метри (м)';

  @override
  String get kilocaloriesUnit => 'Кілокалорії (ккал)';

  @override
  String get enterWeight => 'Введіть вагу';

  @override
  String get requiredField => 'Обов’язково';

  @override
  String get invalidNumber => 'Некоректне число';

  @override
  String get previousWeight => 'Попередня вага';

  @override
  String get imageLabel => 'Зображення';

  @override
  String get longPressToDelete => 'Утримуйте, щоб видалити';

  @override
  String get imageError => 'Помилка зображення';

  @override
  String get actionSave => 'Зберегти';

  @override
  String get aboutTitle => 'Про застосунок';

  @override
  String get donate => 'Підтримати';

  @override
  String get helpSupportProject => 'Допоможіть підтримати цей проєкт';

  @override
  String get whatsNewAbout => 'Що нового?';

  @override
  String get whatsNewTitle => 'Що нового?';

  @override
  String get seeReleaseNotes => 'Переглянути примітки до випуску';

  @override
  String get versionLabel => 'Версія';

  @override
  String get authorLabel => 'Автор';

  @override
  String get privacyPolicy => 'Політика конфіденційності';

  @override
  String get privacyPolicyDescription => 'Як Flexify обробляє ваші дані';

  @override
  String get licenseLabel => 'Ліцензія';

  @override
  String get sourceCode => 'Вихідний код';

  @override
  String get sourceCodeDescription => 'Переглянути на GitHub';

  @override
  String get leaveReview => 'Залишити відгук';

  @override
  String get leaveReviewDescription => 'Оцінити Flexify у Play Store';

  @override
  String get reportBug => 'Повідомити про помилку';

  @override
  String get reportBugDescription => 'Створити звернення на GitHub';

  @override
  String get failedMigrations => 'Невдалі міграції';

  @override
  String get errorMessageLabel => 'Повідомлення про помилку:';

  @override
  String get createIssue => 'Створити звернення';

  @override
  String get addExercise => 'Додати вправу';

  @override
  String get cardio => 'Кардіо';

  @override
  String get strength => 'Силові';

  @override
  String get options => 'Параметри';

  @override
  String get periodDay => 'День';

  @override
  String get periodWeek => 'Тиждень';

  @override
  String get periodMonth => 'Місяць';

  @override
  String get periodYear => 'Рік';

  @override
  String noDataFor(String name) {
    return 'Ще немає даних для $name';
  }

  @override
  String get noDataYet => 'Даних ще немає';

  @override
  String get exerciseNotes => 'Нотатки до вправи';

  @override
  String get notesForExercise => 'Нотатки для цієї вправи';

  @override
  String get useTimeBasedXAxis => 'Використовувати часову вісь X';

  @override
  String updateAllNamed(String name) {
    return 'Оновити всі $name';
  }

  @override
  String get newName => 'Нова назва';

  @override
  String get restMinutes => 'Хвилини відпочинку';

  @override
  String get restSeconds => 'Секунди відпочинку';

  @override
  String get globalProgress => 'Загальний прогрес';

  @override
  String get curveLineGraphs => 'Плавні лінії графіків';

  @override
  String get curveLineGraphsDescription =>
      'Малювати лінії графіків плавними кривими';

  @override
  String noHistoryFor(String name) {
    return 'Для $name ще немає історії';
  }

  @override
  String get cancelSelection => 'Скасувати вибір';

  @override
  String get editSelected => 'Редагувати вибране';

  @override
  String get newExercise => 'Нова вправа';

  @override
  String get noGraphsFound => 'Графіків не знайдено';

  @override
  String get searchGraphs => 'Пошук графіків…';

  @override
  String get actionAdd => 'Додати';

  @override
  String get actionUpdate => 'Оновити';

  @override
  String get hideGlobalProgress => 'Приховати загальний прогрес';

  @override
  String get chartGroupedByCategory => 'Діаграма, згрупована за категоріями';

  @override
  String get noExercisesFound => 'Вправ не знайдено';

  @override
  String get savePlan => 'Зберегти план';

  @override
  String get titleOptional => 'Назва (необов’язково)';

  @override
  String get searchExercises => 'Пошук вправ…';

  @override
  String get warmupSets => 'Розминкові підходи';

  @override
  String get workingSetsMax => 'Робочі підходи (макс.: 20)';

  @override
  String get actionUndo => 'Скасувати';

  @override
  String get actionSwap => 'Поміняти';

  @override
  String get daily => 'Щодня';

  @override
  String get weekly => 'Щотижня';

  @override
  String get monthly => 'Щомісяця';

  @override
  String get yearly => 'Щороку';

  @override
  String get unexpectedError => 'Щось пішло не так. Спробуйте ще раз.';

  @override
  String get loadingExercises => 'Завантаження вправ…';

  @override
  String get noPlansYet => 'Планів ще немає';

  @override
  String get noMatchingPlans => 'Відповідних планів немає';

  @override
  String get newPlan => 'Новий план';

  @override
  String get searchPlans => 'Пошук планів…';

  @override
  String get noExercisesYet => 'Вправ ще немає';

  @override
  String get editPlan => 'Редагувати план';

  @override
  String get saveSet => 'Зберегти підхід';

  @override
  String get minutesLabel => 'Хвилини';

  @override
  String get minutesShort => 'хв';

  @override
  String get secondsLabel => 'Секунди';

  @override
  String get distanceLabel => 'Відстань';

  @override
  String get inclinePercent => 'Нахил %';

  @override
  String weightWithUnit(String unit) {
    return 'Вага ($unit)';
  }

  @override
  String get useBodyWeight => 'Використовувати вагу тіла';

  @override
  String get noWeightEnteredYet => 'Вагу ще не введено';

  @override
  String get notesLabel => 'Нотатки';

  @override
  String get swapWorkout => 'Замінити тренування';

  @override
  String get addSet => 'Додати підхід';

  @override
  String get deleteSet => 'Видалити підхід';

  @override
  String get oneRepMaxEstimate => 'Максимум на одне повторення (оцінка)';

  @override
  String get valueLabel => 'Значення';

  @override
  String amountWithUnit(String unit) {
    return 'Кількість ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return 'Відстань ($unit)';
  }

  @override
  String get bodyWeightLabel => 'Вага тіла';

  @override
  String bodyWeightWithUnit(String unit) {
    return 'Вага тіла ($unit)';
  }

  @override
  String get categoryHelper => 'Виберіть наявну категорію або введіть нову.';

  @override
  String get manageCategories => 'Керування категоріями';

  @override
  String get manageCategoriesDescription =>
      'Створюйте, перейменовуйте, об’єднуйте або видаляйте категорії';

  @override
  String get newCategory => 'Нова категорія';

  @override
  String get renameCategory => 'Перейменувати категорію';

  @override
  String get mergeCategory => 'Об’єднати з іншою категорією';

  @override
  String get noCategories => 'Категорій ще немає';

  @override
  String get categoryNameRequired => 'Введіть назву категорії';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Використовується в $count запису',
      many: 'Використовується в $count записах',
      few: 'Використовується в $count записах',
      one: 'Використовується в $count записі',
      zero: 'Не використовується в жодному записі',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Видалити цю категорію та прибрати її з $count запису?',
      many: 'Видалити цю категорію та прибрати її з $count записів?',
      few: 'Видалити цю категорію та прибрати її з $count записів?',
      one: 'Видалити цю категорію та прибрати її з $count запису?',
      zero: 'Видалити цю категорію?',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => 'Дата створення';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Редагувати $count підходу',
      many: 'Редагувати $count підходів',
      few: 'Редагувати $count підходи',
      one: 'Редагувати $count підхід',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => 'Записів ще немає';

  @override
  String get historyEmptyMessage =>
      'Завершіть підхід або додайте його вручну, щоб почати історію.';

  @override
  String deleteSetConfirmation(String name) {
    return 'Ви впевнені, що хочете видалити $name?';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ви впевнені, що хочете видалити $count запису?',
      many: 'Ви впевнені, що хочете видалити $count записів?',
      few: 'Ви впевнені, що хочете видалити $count записи?',
      one: 'Ви впевнені, що хочете видалити $count запис?',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => 'Пошук в історії…';

  @override
  String get themeSystem => 'Системна';

  @override
  String get themeDark => 'Темна';

  @override
  String get themeLight => 'Світла';

  @override
  String get pureBlackAmoled => 'Чистий чорний (AMOLED)';

  @override
  String get showImages => 'Показувати зображення';

  @override
  String get peekGraph => 'Попередній перегляд графіка';

  @override
  String get inputStyleLine => 'Лінія';

  @override
  String get inputStyleOutlined => 'Контур';

  @override
  String get inputStyleFilled => 'Заповнене';

  @override
  String get inputStyle => 'Стиль введення';

  @override
  String get appearance => 'Вигляд';

  @override
  String get automaticBackupsEnabled => 'Автоматичні резервні копії ввімкнено';

  @override
  String get automaticBackup => 'Автоматичне резервне копіювання';

  @override
  String get appPermissions => 'Дозволи застосунку';

  @override
  String get shareDatabase => 'Поділитися базою даних';

  @override
  String get dataManagement => 'Керування даними';

  @override
  String get strengthUnit => 'Одиниця силових вправ';

  @override
  String get lastEntry => 'Останній запис';

  @override
  String get cardioUnit => 'Одиниця кардіо';

  @override
  String longDateFormat(String format) {
    return 'Довгий формат дати ($format)';
  }

  @override
  String get formats => 'Формати';

  @override
  String get setsPerExerciseMax => 'Підходів на вправу (макс.: 20)';

  @override
  String get countLabel => 'Кількість';

  @override
  String get ratioLabel => 'Співвідношення';

  @override
  String get reorder => 'Змінити порядок';

  @override
  String get none => 'Немає';

  @override
  String get monday => 'Понеділок';

  @override
  String get examplePlanExercises => 'Жим лежачи, присідання, станова тяга';

  @override
  String get tabs => 'Вкладки';

  @override
  String get swipeBetweenTabs => 'Гортати між вкладками';

  @override
  String get vibrate => 'Вібрація';

  @override
  String get enableSound => 'Увімкнути звук';

  @override
  String get keepScreenOn => 'Не вимикати екран';

  @override
  String get alarmSound => 'Звук будильника';

  @override
  String get top => 'Зверху';

  @override
  String get bottom => 'Знизу';

  @override
  String get removeCustomTimer =>
      'Прибрати власний таймер (використовувати загальне значення)';

  @override
  String get timers => 'Таймери';

  @override
  String get timerSettings => 'Налаштування таймера';

  @override
  String get groupHistory => 'Групувати історію';

  @override
  String get showUnits => 'Показувати одиниці';

  @override
  String get showBodyWeight => 'Показувати вагу тіла';

  @override
  String get showCategories => 'Показувати категорії';

  @override
  String get showNotes => 'Показувати нотатки';

  @override
  String get repEstimation => 'Оцінювання повторень';

  @override
  String get durationEstimation => 'Оцінювання тривалості';

  @override
  String get showGraphLimit => 'Показувати обмеження графіка';

  @override
  String get defaultGraphMetric => 'Типовий показник графіка';

  @override
  String get bestWeight => 'Найкраща вага';

  @override
  String get bestReps => 'Найбільше повторень';

  @override
  String get oneRepMax => 'Максимум на одне повторення';

  @override
  String get volume => 'Обсяг';

  @override
  String get paceCardio => 'Темп (кардіо)';

  @override
  String get distanceCardio => 'Відстань (кардіо)';

  @override
  String get defaultGraphPeriod => 'Типовий період графіка';

  @override
  String get defaultGraphLimit => 'Типове обмеження графіка';

  @override
  String get workouts => 'Тренування';

  @override
  String get actionStop => 'Зупинити';

  @override
  String get timerFinishedToast => 'Таймер завершено!';

  @override
  String get stopTimer => 'Зупинити таймер';

  @override
  String get actionPause => 'Призупинити';

  @override
  String get startStopwatch => 'Запустити секундомір';

  @override
  String get actionStart => 'Почати';

  @override
  String get actionRestart => 'Перезапустити';

  @override
  String get addOneMinute => '+1 хвилина';

  @override
  String get addOneMinuteNotification => 'Додати 1 хв';

  @override
  String get restTimer => 'Таймер відпочинку';

  @override
  String get timerUp => 'Час вийшов';

  @override
  String get openNotification => 'Відкрити сповіщення';

  @override
  String get timerChannelName => 'Канал таймера';

  @override
  String get timerChannelDescription => 'Поточний перебіг таймерів відпочинку.';

  @override
  String get timerFinishedChannelName => 'Канал завершення таймера';

  @override
  String get timerFinishedChannelDescription =>
      'Відтворює сигнал після завершення таймера відпочинку.';

  @override
  String get timerFinished => 'Таймер завершено';

  @override
  String get batteryOptimizationRequestUnavailable =>
      'Запити на ігнорування оптимізації батареї вимкнено на вашому пристрої.';

  @override
  String get exactAlarmRequestUnavailable =>
      'Запит SCHEDULE_EXACT_ALARM відхилено на вашому пристрої';

  @override
  String get databaseMigrationFailureDescription =>
      'Під час створення або оновлення бази даних сталася помилка. Зазвичай це можна виправити, видаливши й створивши записи заново.';

  @override
  String get curveSmoothness => 'Плавність кривої';

  @override
  String get actionBack => 'Назад';

  @override
  String get atLeastOneTab => 'Потрібна щонайменше одна вкладка';

  @override
  String get invalidTabSettings => 'Некоректні налаштування вкладок.';

  @override
  String get noSettingsFound => 'Налаштувань не знайдено';

  @override
  String nothingMatchesSearch(String query) {
    return 'Нічого не знайдено за запитом «$query».';
  }

  @override
  String get appearanceDescription => 'Тема, кольори й оформлення інтерфейсу';

  @override
  String get dataManagementDescription =>
      'Імпорт, експорт і керування даними тренувань';

  @override
  String get formatsDescription =>
      'Форматування дат, чисел і одиниць вимірювання';

  @override
  String get plansSettingsDescription =>
      'Типові значення й поведінка планів тренувань';

  @override
  String get tabsDescription =>
      'Виберіть і впорядкуйте основні вкладки навігації';

  @override
  String get timersDescription =>
      'Тривалість, звук і поведінка таймера відпочинку';

  @override
  String get workoutsDescription =>
      'Відстеження вправ і налаштування тренувань';

  @override
  String get completeSetForChart =>
      'Завершіть підхід цієї вправи, щоб побудувати її графік.';

  @override
  String get dateRange => 'Діапазон дат';

  @override
  String get stopDate => 'Дата завершення';

  @override
  String get dataPoints => 'Точки даних';

  @override
  String get completeSetsForProgress =>
      'Завершіть кілька підходів, щоб побудувати графік прогресу.';

  @override
  String get relativeStrength => 'Відносна сила';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вибрано $count',
      many: 'Вибрано $count',
      few: 'Вибрано $count',
      one: 'Вибрано $count',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory =>
      'Завершіть кілька підходів, щоб побачити тут історію цієї вправи.';

  @override
  String get completeSetForFirstGraph =>
      'Завершіть підхід, щоб створити перший графік вправи.';

  @override
  String nothingMatchesGraphSearch(String query) {
    return 'Нічого не знайдено за запитом «$query». Можна створити нову вправу.';
  }

  @override
  String addNamed(String name) {
    return 'Додати «$name»';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return 'Буде видалено $count записів. Продовжити?';
  }

  @override
  String shareWorkout(String summary) {
    return 'Я щойно виконав(ла) $summary';
  }

  @override
  String get updateConflict => 'Конфлікт оновлення';

  @override
  String updateConflictDescription(int count) {
    return 'Нова назва вже використовується в $count записах. Продовжити?';
  }

  @override
  String get unitsConflict => 'Конфлікт одиниць';

  @override
  String unitsConflictDescription(String unit) {
    return 'Не всі записи мають однакову одиницю. Усі одиниці буде перетворено на $unit. Продовжити?';
  }

  @override
  String get durationLabel => 'Тривалість';

  @override
  String get inclineLabel => 'Нахил';

  @override
  String get paceDistanceTime => 'Темп (відстань / час)';

  @override
  String get adjustedPace => 'Скоригований темп';

  @override
  String get oneRepMaxAccuracyWarning =>
      'Оцінка максимуму на одне повторення менш точна для підходів із 10+ повтореннями';

  @override
  String get addPlan => 'Додати план';

  @override
  String get planDetails => 'Відомості про план';

  @override
  String get exercisesLabel => 'Вправи';

  @override
  String get addExerciseToPlan => 'Додайте вправу до цього плану.';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return 'Нічого не знайдено за запитом «$query». Можна додати нову вправу.';
  }

  @override
  String get selectDays => 'Виберіть дні';

  @override
  String get selectExercises => 'Виберіть вправи';

  @override
  String get todayLabel => 'Сьогодні';

  @override
  String get setDetails => 'Відомості про підхід';

  @override
  String get themeLabel => 'Тема';

  @override
  String get pureBlackAmoledDescription =>
      'Використовувати чистий чорний колір для AMOLED-дисплеїв';

  @override
  String get systemColorScheme => 'Системна колірна схема';

  @override
  String get systemColorSchemeDescription =>
      'Використовувати основний колір пристрою в застосунку';

  @override
  String get showImagesDescription =>
      'Вибирати й показувати зображення на сторінці історії';

  @override
  String get showGlobalProgress => 'Показувати загальний прогрес';

  @override
  String get showGlobalProgressDescription =>
      'Додати до графіків діаграму прогресу за категоріями';

  @override
  String get peekGraphDescription =>
      'Показувати перший лінійний графік на сторінці графіків';

  @override
  String get inputStyleDescription => 'Візуальний стиль полів введення тексту';

  @override
  String get automaticBackupNotificationBody =>
      'Flexify автоматично створюватиме резервну копію даних і зображень у вибраній папці щодня.';

  @override
  String get backupSettingsChannel => 'Налаштування резервного копіювання';

  @override
  String get backupSettingsChannelDescription =>
      'Сповіщення з поясненнями про автоматичні резервні копії';

  @override
  String get backupChannelName => 'Канал резервного копіювання';

  @override
  String get backupChannelDescription =>
      'Автоматичні резервні копії даних і зображень Flexify';

  @override
  String get backupCompletedTitle =>
      'Дані й зображення збережено в резервній копії';

  @override
  String get backupFailurePathNotSet =>
      'Не вдалося створити резервну копію: шлях не вказано. Автоматичне резервне копіювання вимкнено.';

  @override
  String get backupFailureDirectoryUnavailable =>
      'Не вдалося створити резервну копію: немає доступу до папки резервних копій. Автоматичне резервне копіювання вимкнено.';

  @override
  String get backupFailureCreateFile =>
      'Не вдалося створити резервну копію: не вдалося створити файл. Автоматичне резервне копіювання вимкнено.';

  @override
  String get backupFailureAppFilesUnavailable =>
      'Не вдалося створити резервну копію: немає доступу до папки файлів застосунку. Автоматичне резервне копіювання вимкнено.';

  @override
  String get backupFailureDatabaseMissing =>
      'Не вдалося створити резервну копію: файл бази даних не знайдено. Автоматичне резервне копіювання вимкнено.';

  @override
  String get backupFailureOutputUnavailable =>
      'Не вдалося створити резервну копію: не вдалося відкрити потік виводу. Автоматичне резервне копіювання вимкнено.';

  @override
  String get backupFailureUnknown =>
      'Не вдалося створити резервну копію. Автоматичне резервне копіювання вимкнено.';

  @override
  String get appPermissionsDescription =>
      'Перегляньте доступ, потрібний увімкненим функціям';

  @override
  String get longDateFormatDescription =>
      'Використовується там, де достатньо місця';

  @override
  String shortDateFormat(String example) {
    return 'Короткий формат дати ($example)';
  }

  @override
  String get shortDateFormatDescription =>
      'Для місць із обмеженим простором (лінії графіка)';

  @override
  String get warmupSetsDescription =>
      'Для розминкових підходів таймери відпочинку не запускаються';

  @override
  String get setsPerExerciseDescription => 'Типова кількість вправ у плані';

  @override
  String get planTrailingDisplay => 'Вміст праворуч у плані';

  @override
  String get planTrailingDisplayDescription =>
      'Що показувати праворуч у списку планів і в перегляді плану';

  @override
  String get restTimersDescription => 'Сигнал після завершення підходу';

  @override
  String get vibrateDescription => 'Чи мають таймери відпочинку вібрувати?';

  @override
  String get enableSoundDescription =>
      'Чи мають таймери відпочинку відтворювати звук?';

  @override
  String get keepScreenOnDescription =>
      'Не вимикати екран під час роботи таймерів відпочинку';

  @override
  String get restDurationDescription =>
      'Через який час має спрацювати сигнал відпочинку?';

  @override
  String get globalDefault => 'Загальне значення';

  @override
  String get alarmSoundDescription =>
      'Мелодія, що відтворюється після завершення таймера відпочинку';

  @override
  String get progressBarPosition => 'Розташування індикатора прогресу';

  @override
  String get progressBarPositionDescription =>
      'Де розміщувати індикатор прогресу таймерів відпочинку?';

  @override
  String get perExerciseRestTimes => 'Час відпочинку для окремих вправ';

  @override
  String get perExerciseRestTimesDescription =>
      'Для цих вправ задано власну тривалість відпочинку';

  @override
  String get audioFeaturesUnavailable => 'Аудіофункції недоступні';

  @override
  String get groupHistoryDescription => 'Об’єднувати записи історії за днями';

  @override
  String get showUnitsDescription =>
      'Показувати км/mi та кг/lb у графіках, історії й планах';

  @override
  String get showBodyWeightDescription =>
      'Увімкнути або вимкнути відстеження ваги тіла';

  @override
  String get showCategoriesDescription =>
      'Увімкнути або вимкнути категорії тренувань';

  @override
  String get showNotesDescription =>
      'Записувати подробиці вправи в текстовому полі';

  @override
  String get positiveNotificationsDescription =>
      'Показувати приємні повідомлення після встановлення нового рекорду';

  @override
  String get positiveMessagesEnabled =>
      'Позитивні повідомлення тепер виглядають ось так!';

  @override
  String get recordEncouragement01 => 'Чудова робота! Ти неймовірний!';

  @override
  String get recordEncouragement02 => 'Красунчик! Твій прогрес надихає.';

  @override
  String get recordEncouragement03 => 'Схиляю коліно…';

  @override
  String get recordEncouragement04 => 'Що це? Новий рекорд!';

  @override
  String get recordEncouragement05 => 'Неймовірно! Ти надихаєш.';

  @override
  String get recordEncouragement06 => 'Ого. Клас.';

  @override
  String get recordEncouragement07 => 'Стаєш сильнішим, еге ж?';

  @override
  String get recordEncouragement08 => 'Так. Ти справді великий хлопець.';

  @override
  String get recordEncouragement09 => 'Дивовижно. Неймовірно.';

  @override
  String get recordEncouragement10 => 'Арні пишався б.';

  @override
  String get recordEncouragement11 =>
      'Ронні Коулмен дивиться на тебе з радістю.';

  @override
  String get recordEncouragement12 => 'ТАК! ЛЕГКА ВАГА, ДИТИНКО!!!!!!!';

  @override
  String get recordEncouragement13 => 'Це новий рекорд? Я знав, що ти зможеш.';

  @override
  String get recordEncouragement14 => 'Чудова робота! Я пишаюся тобою.';

  @override
  String get recordEncouragement15 => 'Так, дитинко! Легка вага!';

  @override
  String get recordEncouragement16 => 'Так тримати! Чудовий прогрес.';

  @override
  String get recordEncouragement17 => 'У тебе все чудово виходить.';

  @override
  String get recordEncouragement18 => 'Оце мій хлопець!';

  @override
  String get recordEncouragement19 => 'Так тримати.';

  @override
  String get recordEncouragement20 => 'Ти стаєш дуже сильним.';

  @override
  String get recordEncouragement21 => 'Потужно.';

  @override
  String get recordEncouragement22 => 'Оце сила!';

  @override
  String get recordEncouragement23 => 'Я пишаюся тобою.';

  @override
  String get recordEncouragement24 => 'Продовжуй у тому ж дусі.';

  @override
  String get recordEncouragement25 =>
      'Вище голову! Ти щойно встановив новий рекорд.';

  @override
  String get recordEncouragement26 =>
      'Новий рекорд! Ти перевершив усе, що було раніше!';

  @override
  String get recordEncouragement27 => 'Так! Це рекорд.';

  @override
  String get recordEncouragement28 => 'Ого! Новий рекорд!';

  @override
  String get recordEncouragement29 => 'Дуже круто.';

  @override
  String get repEstimationDescription =>
      'Спробувати передбачити кількість щойно виконаних повторень';

  @override
  String get durationEstimationDescription =>
      'Спробувати передбачити тривалість кардіо';

  @override
  String get showGraphXAxisToggle => 'Показувати перемикач осі X графіка';

  @override
  String get showGraphXAxisToggleDescription =>
      'Показувати на графіках перемикач часової осі X';

  @override
  String get showGraphLimitDescription =>
      'Показувати на графіках повзунок обмеження';

  @override
  String get defaultTimeBasedXAxis => 'Типова часова вісь X';

  @override
  String get defaultTimeBasedXAxisDescription =>
      'За замовчуванням використовувати на графіках часову вісь X';

  @override
  String get createFirstTrainingPlan =>
      'Створіть перший план тренувань, щоб почати.';

  @override
  String nothingMatchesPlanSearch(String query) {
    return 'Нічого не знайдено за запитом «$query». Можна створити новий план.';
  }

  @override
  String get createPlan => 'Створити план';

  @override
  String createNamedPlan(String name) {
    return 'Створити «$name»';
  }

  @override
  String setNumber(int number) {
    return 'Підхід $number';
  }
}
