// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get settingsLanguageDescription =>
      'Flexify tarafından kullanılacak dili seçin.';

  @override
  String get languageSystemDefault => 'Sistem Varsayılanı';

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
  String get navHistory => 'Geçmiş';

  @override
  String get navPlans => 'Planlar';

  @override
  String get navGraphs => 'Grafikler';

  @override
  String get navTimer => 'Zamanlayıcı';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get errorLabel => 'Hata';

  @override
  String get tabContentError => 'Sekme içeriği oluşturulamadı.';

  @override
  String get cannotHideAllTabs => 'Her şeyi gizleyemezsin!';

  @override
  String removeTabQuestion(String tab) {
    return '$tab sekmesi silinsin mi?';
  }

  @override
  String get restoreTabFromSettings =>
      'Daha sonra ayarlardan tekrar ekleyebilirsin.';

  @override
  String removedTab(String tab) {
    return '$tab kaldırıldı.';
  }

  @override
  String newVersion(String version) {
    return 'Yeni Sürüm $version';
  }

  @override
  String get changes => 'Değişiklikler';

  @override
  String get searchHint => 'Ara...';

  @override
  String get deleteSelected => 'Seçilenleri Sil';

  @override
  String get confirmDelete => 'Silmeyi Onayla';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gerçekten $count kayıt silmek istediğine emin misin?',
      one: 'Gerçekten bu kaydı silmek istediğine emin misin?',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'İptal';

  @override
  String get actionDelete => 'Sil';

  @override
  String get actionRemove => 'Kaldır';

  @override
  String get actionEdit => 'Düzenle';

  @override
  String get actionShare => 'Paylaş';

  @override
  String get clearSelection => 'Seçimi Temizle';

  @override
  String get clearSearch => 'Aramayı Temizle';

  @override
  String get showMenu => 'Menüyü Göster';

  @override
  String get selectAll => 'Hepsini Seç';

  @override
  String get weightLabel => 'Ağırlık';

  @override
  String get filter => 'Filtre';

  @override
  String get filters => 'Filtreler';

  @override
  String get categoryLabel => 'Kategori';

  @override
  String get repsLabel => 'Tekrar';

  @override
  String get repsFilter => 'Tekrar Filtresi';

  @override
  String get weightFilter => 'Ağırlık Filtresi';

  @override
  String get greaterThan => 'Büyüktür';

  @override
  String get lessThan => 'Küçüktür';

  @override
  String get startDate => 'Başlangıç Tarihi';

  @override
  String get endDate => 'Bitiş Tarihi';

  @override
  String get actionClear => 'Temizle';

  @override
  String get actionOk => 'Tamam';

  @override
  String get actionClose => 'Kapat';

  @override
  String get sortBy => 'Sıralama Ölçütü';

  @override
  String get dateNewest => 'Tarih (En Yeni)';

  @override
  String get dateOldest => 'Tarih (En Eski)';

  @override
  String get nameLabel => 'Ad';

  @override
  String get missingPermissions => 'İzinler Eksik';

  @override
  String get restTimersPermissionsMissing =>
      'Dinlenme zamanlayıcıları aktif ama gerekli izinler eksik.';

  @override
  String get restTimersPermissionsOptional =>
      'Dinlenme zamanlayıcılarını kapatırsan bu izinlere ihtiyacın kalmaz.';

  @override
  String get restTimers => 'Dinlenme zamanlayıcıları';

  @override
  String get disableBatteryOptimizations => 'Pil Optimizasyonlarını Kapat';

  @override
  String get batteryOptimizationWarning =>
      'Pil optimizasyonu açık kalırsa işlem duraklatılabilir.';

  @override
  String get scheduleExactAlarm => 'Tam Zamanlı Alarm İzni';

  @override
  String get exactAlarmWarning =>
      'Devre dışı bırakılırsa alarmlar tam zamanında çalmayabilir.';

  @override
  String get postNotifications => 'Bildirim Gönderme';

  @override
  String get notificationBarDescription =>
      'Zamanlayıcı ilerlemesi bildirim çubuğuna gönderilir.';

  @override
  String get invalidPermissions => 'Geçersiz İzinler';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      'Dinlenme zamanlayıcıları yeterli izinler olmadan etkinleştirildi. Emin misin?';

  @override
  String get actionConfirm => 'Onayla';

  @override
  String get appAccess => 'Uygulama Erişimi';

  @override
  String get appAccessDescription =>
      'Etkin zamanlayıcılar ve bildirimler için gereklidir.';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get timerProgressAndRestAlerts =>
      'Zamanlayıcı ilerlemesi ve dinlenme uyarıları';

  @override
  String get enabledNotificationsDescription => 'Etkinleştirdiğin bildirimler';

  @override
  String get backgroundActivity => 'Arka plan etkinliği';

  @override
  String get backgroundActivityDescription =>
      'Zamanlayıcıların arka planda kararlı çalışmasını sağlar';

  @override
  String get exactAlarms => 'Tam zamanlı alarmlar';

  @override
  String get exactAlarmsDescription =>
      'Dinlenme zamanlayıcısı bittiği an tam zamanında uyarır';

  @override
  String get noAdditionalAndroidAccessNeeded =>
      'Mevcut ayarların için ek bir Android erişimine gerek yok.';

  @override
  String get actionDone => 'Bitti';

  @override
  String get allowed => 'İzin Verildi';

  @override
  String get actionAllow => 'İzin Ver';

  @override
  String get backupLabel => 'Yedekleme';

  @override
  String get databaseLabel => 'Veritabanı';

  @override
  String get deleteRecords => 'Kayıtları Sil';

  @override
  String get deleteAllGraphsConfirmation =>
      'Bütün grafikleri silmek istediğine emin misin? Bu işlem geri alınamaz.';

  @override
  String get deleteAllPlansConfirmation =>
      'Bütün planları silmek istediğine emin misin? Bu işlem geri alınamaz.';

  @override
  String get deleteDatabaseConfirmation =>
      'Veritabanını silmek istediğine emin misin? Bu işlem geri alınamaz.';

  @override
  String get importData => 'İçeri Aktar';

  @override
  String get exportData => 'Dışarı Aktar';

  @override
  String get actionReport => 'Bildir';

  @override
  String get graphDataImported => 'Grafik verisi başarıyla aktarıldı.';

  @override
  String get plansImported => 'Plan verisi başarıyla aktarıldı.';

  @override
  String failedToImportDatabase(String error) {
    return 'Veritabanı içe aktarılamadı: $error';
  }

  @override
  String get backupArchiveMissingDatabase =>
      'Yedekleme arşivi Flexify veritabanını içermiyor.';

  @override
  String failedToImportGraphs(String error) {
    return 'Grafikler içe aktarılamadı: $error';
  }

  @override
  String failedToImportPlans(String error) {
    return 'Planlar içe aktarılamadı: $error';
  }

  @override
  String get selectedFileDoesNotExist => 'Seçilen dosya mevcut değil.';

  @override
  String get couldNotReadFileData => 'Dosya verileri okunamadı.';

  @override
  String get databaseImportWebUnsupported =>
      'Web üzerinde veritabanı içe aktarımı manuel veri taşıması gerektirir. Lütfen verilerini CSV dosyaları olarak dışa aktar ve bunun yerine bunları içe aktar.';

  @override
  String get csvFileEmpty => 'CSV dosyası boş.';

  @override
  String get csvNeedsDataRow =>
      'CSV dosyası en az bir veri satırı içermelidir.';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return '$row. satırda yetersiz sütun var: $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return '$row. satırdaki $field değeri geçersiz: $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return '$row. satırdaki $field veri türü geçersiz: $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return 'Integer tipinde plan ID\'si bekleniyordu, \"$value\" alındı';
  }

  @override
  String get unitLabel => 'Birim';

  @override
  String get kilogramsUnit => 'Kilogram (kg)';

  @override
  String get poundsUnit => 'Pound (lb)';

  @override
  String get stoneUnit => 'Stone';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => 'Kilometre (km)';

  @override
  String get milesUnit => 'Mil (mi)';

  @override
  String get metersUnit => 'Metre (m)';

  @override
  String get kilocaloriesUnit => 'Kilokalori (kcal)';

  @override
  String get enterWeight => 'Ağırlık Girin';

  @override
  String get requiredField => 'Zorunlu';

  @override
  String get invalidNumber => 'Geçersiz Numara';

  @override
  String get previousWeight => 'Önceki Ağırlık';

  @override
  String get imageLabel => 'Görsel';

  @override
  String get longPressToDelete => 'Silmek için basılı tut.';

  @override
  String get imageError => 'Görsel hatası';

  @override
  String get actionSave => 'Kaydet';

  @override
  String get aboutTitle => 'Hakkında';

  @override
  String get donate => 'Bağış Yap';

  @override
  String get helpSupportProject => 'Projeyi destekle';

  @override
  String get whatsNewAbout => 'Yenilikler neler?';

  @override
  String get whatsNewTitle => 'Yenilikler';

  @override
  String get seeReleaseNotes => 'Sürüm Notları';

  @override
  String get versionLabel => 'Sürüm';

  @override
  String get authorLabel => 'Geliştirici';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get privacyPolicyDescription => 'Flexify verilerini nasıl işler';

  @override
  String get licenseLabel => 'Lisans';

  @override
  String get sourceCode => 'Kaynak Kodu';

  @override
  String get sourceCodeDescription => 'GitHub üzerinde incele';

  @override
  String get leaveReview => 'Değerlendir';

  @override
  String get leaveReviewDescription => 'Play Store\'da Flexify\'ı puanla';

  @override
  String get reportBug => 'Hata Bildir';

  @override
  String get reportBugDescription => 'GitHub üzerinde hata bildirin.';

  @override
  String get failedMigrations => 'Başarısız veri tabanı geçişleri (migrations)';

  @override
  String get errorMessageLabel => 'Hata mesajı:';

  @override
  String get createIssue => 'Hata Bildir';

  @override
  String get addExercise => 'Egzersiz Ekle';

  @override
  String get cardio => 'Kardiyo';

  @override
  String get strength => 'Kuvvet';

  @override
  String get options => 'Seçenekler';

  @override
  String get periodDay => 'Gün';

  @override
  String get periodWeek => 'Hafta';

  @override
  String get periodMonth => 'Ay';

  @override
  String get periodYear => 'Yıl';

  @override
  String noDataFor(String name) {
    return '$name için henüz veri yok';
  }

  @override
  String get noDataYet => 'Henüz veri yok';

  @override
  String get exerciseNotes => 'Egzersiz notları';

  @override
  String get notesForExercise => 'Bu egzersiz için notlar';

  @override
  String get useTimeBasedXAxis => 'Zaman tabanlı X ekseni kullan';

  @override
  String updateAllNamed(String name) {
    return 'Tüm $name kayıtlarını güncelle';
  }

  @override
  String get newName => 'Yeni Ad';

  @override
  String get restMinutes => 'Dinlenme Dakikası';

  @override
  String get restSeconds => 'Dinlenme Saniyesi';

  @override
  String get globalProgress => 'Genel İlerleme';

  @override
  String get curveLineGraphs => 'Grafik Eğriliği';

  @override
  String get curveLineGraphsDescription =>
      'Grafik çizgilerini yumuşak eğriler olarak çiz';

  @override
  String noHistoryFor(String name) {
    return '$name için henüz geçmiş yok';
  }

  @override
  String get cancelSelection => 'Seçimi İptal Et';

  @override
  String get editSelected => 'Seçilenleri Düzenle';

  @override
  String get newExercise => 'Yeni Egzersiz';

  @override
  String get noGraphsFound => 'Grafik bulunamadı';

  @override
  String get searchGraphs => 'Grafik ara...';

  @override
  String get actionAdd => 'Ekle';

  @override
  String get actionUpdate => 'Güncelle';

  @override
  String get hideGlobalProgress => 'Genel ilerlemeyi gizle';

  @override
  String get chartGroupedByCategory => 'Kategoriye göre gruplandırılmış grafik';

  @override
  String get noExercisesFound => 'Egzersiz bulunamadı';

  @override
  String get savePlan => 'Planı Kaydet';

  @override
  String get titleOptional => 'Başlık (isteğe bağlı)';

  @override
  String get searchExercises => 'Egzersiz ara...';

  @override
  String get warmupSets => 'Isınma setleri';

  @override
  String get workingSetsMax => 'Çalışma setleri (maks: 20)';

  @override
  String get actionUndo => 'Geri Al';

  @override
  String get actionSwap => 'Değiştir';

  @override
  String get daily => 'Günlük';

  @override
  String get weekly => 'Haftalık';

  @override
  String get monthly => 'Aylık';

  @override
  String get yearly => 'Yıllık';

  @override
  String get unexpectedError => 'Bir şeyler yanlış gitti. Lütfen tekrar dene.';

  @override
  String get loadingExercises => 'Egzersizler yükleniyor...';

  @override
  String get noPlansYet => 'Henüz plan yok';

  @override
  String get noMatchingPlans => 'Eşleşen plan yok';

  @override
  String get newPlan => 'Yeni Plan';

  @override
  String get searchPlans => 'Plan ara...';

  @override
  String get noExercisesYet => 'Henüz egzersiz yok';

  @override
  String get editPlan => 'Planı Düzenle';

  @override
  String get saveSet => 'Seti Kaydet';

  @override
  String get minutesLabel => 'Dakika';

  @override
  String get minutesShort => 'dk';

  @override
  String get secondsLabel => 'Saniye';

  @override
  String get distanceLabel => 'Mesafe';

  @override
  String get inclinePercent => 'Eğim %';

  @override
  String weightWithUnit(String unit) {
    return 'Ağırlık ($unit)';
  }

  @override
  String get useBodyWeight => 'Vücut ağırlığını kullan';

  @override
  String get noWeightEnteredYet => 'Henüz ağırlık girilmedi';

  @override
  String get notesLabel => 'Notlar';

  @override
  String get swapWorkout => 'Antrenmanı Değiştir';

  @override
  String get addSet => 'Set Ekle';

  @override
  String get deleteSet => 'Seti Sil';

  @override
  String get oneRepMaxEstimate => '1 Tekrar Maks (1RM) tahmini';

  @override
  String get valueLabel => 'Değer';

  @override
  String amountWithUnit(String unit) {
    return 'Miktar ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return 'Mesafe ($unit)';
  }

  @override
  String get bodyWeightLabel => 'Vücut Ağırlığı';

  @override
  String bodyWeightWithUnit(String unit) {
    return 'Vücut ağırlığı ($unit)';
  }

  @override
  String get categoryHelper =>
      'Mevcut bir kategori seçin veya yeni bir kategori yazın.';

  @override
  String get manageCategories => 'Kategorileri yönet';

  @override
  String get manageCategoriesDescription =>
      'Kategori oluşturun, yeniden adlandırın, birleştirin veya kaldırın';

  @override
  String get newCategory => 'Yeni kategori';

  @override
  String get renameCategory => 'Kategoriyi yeniden adlandır';

  @override
  String get mergeCategory => 'Başka bir kategoriyle birleştir';

  @override
  String get noCategories => 'Henüz kategori yok';

  @override
  String get categoryNameRequired => 'Bir kategori adı girin';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kayıtta kullanılıyor',
      one: '1 kayıtta kullanılıyor',
      zero: 'Hiçbir kayıtta kullanılmıyor',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bu kategori silinsin ve $count kayıttan kaldırılsın mı?',
      one: 'Bu kategori silinsin ve 1 kayıttan kaldırılsın mı?',
      zero: 'Bu kategori silinsin mi?',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => 'Oluşturulma Tarihi';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seti düzenle',
      one: '1 seti düzenle',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => 'Henüz kayıt yok';

  @override
  String get historyEmptyMessage =>
      'Geçmişini başlatmak için bir seti tamamla veya manuel olarak ekle.';

  @override
  String deleteSetConfirmation(String name) {
    return '$name setini silmek istediğine emin misin?';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kaydı silmek istediğine emin misin?',
      one: '1 kaydı silmek istediğine emin misin?',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => 'Geçmişte ara...';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeDark => 'Koyu';

  @override
  String get themeLight => 'Açık';

  @override
  String get pureBlackAmoled => 'Saf Siyah (AMOLED)';

  @override
  String get showImages => 'Görselleri Göster';

  @override
  String get peekGraph => 'Grafik Önizlemesi';

  @override
  String get inputStyleLine => 'Çizgi';

  @override
  String get inputStyleOutlined => 'Çerçeveli';

  @override
  String get inputStyleFilled => 'Dolgulu';

  @override
  String get inputStyle => 'Girdi Stili';

  @override
  String get appearance => 'Görünüm';

  @override
  String get automaticBackupsEnabled => 'Otomatik yedeklemeler etkinleştirildi';

  @override
  String get automaticBackup => 'Otomatik Yedekleme';

  @override
  String get appPermissions => 'Uygulama İzinleri';

  @override
  String get shareDatabase => 'Veritabanını Paylaş';

  @override
  String get dataManagement => 'Veri Yönetimi';

  @override
  String get strengthUnit => 'Kuvvet Birimi';

  @override
  String get lastEntry => 'Son Kayıt';

  @override
  String get cardioUnit => 'Kardiyo Birimi';

  @override
  String longDateFormat(String format) {
    return 'Uzun tarih biçimi ($format)';
  }

  @override
  String get formats => 'Biçimler';

  @override
  String get setsPerExerciseMax => 'Egzersiz başına set (maks: 20)';

  @override
  String get countLabel => 'Sayı';

  @override
  String get ratioLabel => 'Oran';

  @override
  String get reorder => 'Yeniden Sırala';

  @override
  String get none => 'Hiçbiri';

  @override
  String get monday => 'Pazartesi';

  @override
  String get examplePlanExercises => 'Bench Press, Squat, Deadlift';

  @override
  String get tabs => 'Sekmeler';

  @override
  String get swipeBetweenTabs => 'Sekmeler arası kaydır';

  @override
  String get vibrate => 'Titreşim';

  @override
  String get enableSound => 'Sesi Etkinleştir';

  @override
  String get keepScreenOn => 'Ekranı Açık Tut';

  @override
  String get alarmSound => 'Alarm Sesi';

  @override
  String get top => 'Üst';

  @override
  String get bottom => 'Alt';

  @override
  String get removeCustomTimer =>
      'Özel zamanlayıcıyı kaldır (varsayılanı kullan)';

  @override
  String get timers => 'Zamanlayıcılar';

  @override
  String get timerSettings => 'Zamanlayıcı Ayarları';

  @override
  String get groupHistory => 'Geçmişi Gruplandır';

  @override
  String get showUnits => 'Birimleri Göster';

  @override
  String get showBodyWeight => 'Vücut Ağırlığını Göster';

  @override
  String get showCategories => 'Kategorileri Göster';

  @override
  String get showNotes => 'Notları Göster';

  @override
  String get repEstimation => 'Tekrar Tahmini';

  @override
  String get durationEstimation => 'Süre Tahmini';

  @override
  String get showGraphLimit => 'Grafik sınırını göster';

  @override
  String get defaultGraphMetric => 'Varsayılan Grafik Metriği';

  @override
  String get bestWeight => 'En İyi Ağırlık';

  @override
  String get bestReps => 'En İyi Tekrar';

  @override
  String get oneRepMax => '1 Tekrar Maks (1RM)';

  @override
  String get volume => 'Hacim';

  @override
  String get paceCardio => 'Tempo (kardiyo)';

  @override
  String get distanceCardio => 'Mesafe (kardiyo)';

  @override
  String get defaultGraphPeriod => 'Varsayılan Grafik Periyodu';

  @override
  String get defaultGraphLimit => 'Varsayılan Grafik Sınırı';

  @override
  String get workouts => 'Antrenmanlar';

  @override
  String get actionStop => 'Durdur';

  @override
  String get timerFinishedToast => 'Zamanlayıcı bitti!';

  @override
  String get stopTimer => 'Zamanlayıcıyı Durdur';

  @override
  String get actionPause => 'Duraklat';

  @override
  String get startStopwatch => 'Kronometreyi Başlat';

  @override
  String get actionStart => 'Başlat';

  @override
  String get actionRestart => 'Yeniden Başlat';

  @override
  String get addOneMinute => '+1 dakika';

  @override
  String get addOneMinuteNotification => '+1 dk ekle';

  @override
  String get restTimer => 'Dinlenme Zamanlayıcısı';

  @override
  String get timerUp => 'Süre Doldu';

  @override
  String get openNotification => 'Bildirimi Aç';

  @override
  String get timerChannelName => 'Zamanlayıcı Kanalı';

  @override
  String get timerChannelDescription =>
      'Dinlenme zamanlayıcılarının devam eden ilerlemesi.';

  @override
  String get timerFinishedChannelName => 'Zamanlayıcı Bitti Kanalı';

  @override
  String get timerFinishedChannelDescription =>
      'Dinlenme zamanlayıcısı tamamlandığında alarm çalar.';

  @override
  String get timerFinished => 'Zamanlayıcı Bitti';

  @override
  String get batteryOptimizationRequestUnavailable =>
      'Pil optimizasyonlarını yoksayma istekleri cihazında devre dışı bırakılmış.';

  @override
  String get exactAlarmRequestUnavailable =>
      'Cihazında SCHEDULE_EXACT_ALARM isteği reddedildi.';

  @override
  String get databaseMigrationFailureDescription =>
      'Veritabanın oluşturulurken veya yükseltilirken bir şeyler yanlış gitti. Genellikle kayıtlarını silip yeniden oluşturarak çözülebilir.';

  @override
  String get curveSmoothness => 'Eğri Yumuşaklığı';

  @override
  String get actionBack => 'Geri';

  @override
  String get atLeastOneTab => 'En az bir sekme gereklidir';

  @override
  String get invalidTabSettings => 'Geçersiz sekme ayarları.';

  @override
  String get noSettingsFound => 'Ayar bulunamadı';

  @override
  String nothingMatchesSearch(String query) {
    return '“$query” ile eşleşen sonuç yok.';
  }

  @override
  String get appearanceDescription => 'Tema, renkler ve arayüz biçimlendirmesi';

  @override
  String get dataManagementDescription =>
      'Antrenman verilerini içe aktar, dışa aktar ve yönet';

  @override
  String get formatsDescription => 'Tarihler, sayılar ve ölçü biçimlendirmesi';

  @override
  String get plansSettingsDescription =>
      'Antrenman planları için varsayılanlar ve davranışlar';

  @override
  String get tabsDescription => 'Birincil gezinme sekmelerini seç ve düzenle';

  @override
  String get timersDescription =>
      'Dinlenme zamanlayıcısı süresi, sesi ve davranışı';

  @override
  String get workoutsDescription => 'Egzersiz takibi ve antrenman tercihleri';

  @override
  String get completeSetForChart =>
      'Grafiği oluşturmak için bu egzersizle ilgili bir seti tamamla.';

  @override
  String get dateRange => 'Tarih Aralığı';

  @override
  String get stopDate => 'Bitiş Tarihi';

  @override
  String get dataPoints => 'Veri Noktaları';

  @override
  String get completeSetsForProgress =>
      'İlerleme grafiğini oluşturmak için birkaç seti tamamla.';

  @override
  String get relativeStrength => 'Bağıl Güç';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe seçildi',
      one: '1 öğe seçildi',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory =>
      'Bu egzersiz geçmişini görmek için birkaç seti tamamla.';

  @override
  String get completeSetForFirstGraph =>
      'İlk egzersiz grafiğini oluşturmak için bir seti tamamla.';

  @override
  String nothingMatchesGraphSearch(String query) {
    return '“$query” ile eşleşen sonuç yok. Bunu yeni bir egzersiz olarak oluşturabilirsin.';
  }

  @override
  String addNamed(String name) {
    return '“$name” Ekle';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return 'Bu işlem $count kaydı silecek. Emin misin?';
  }

  @override
  String shareWorkout(String summary) {
    return 'Az önce şunu yaptım: $summary';
  }

  @override
  String get updateConflict => 'Güncelleme Çakışması';

  @override
  String updateConflictDescription(int count) {
    return 'Yeni adın $count kayıt için zaten mevcut. Emin misin?';
  }

  @override
  String get unitsConflict => 'Birim Çakışması';

  @override
  String unitsConflictDescription(String unit) {
    return 'Tüm kayıtların aynı birime sahip değil. Bu işlem tüm birimleri $unit cinsine dönüştürecek. Emin misin?';
  }

  @override
  String get durationLabel => 'Süre';

  @override
  String get inclineLabel => 'Eğim';

  @override
  String get paceDistanceTime => 'Tempo (mesafe / süre)';

  @override
  String get adjustedPace => 'Düzeltilmiş Tempo';

  @override
  String get oneRepMaxAccuracyWarning =>
      '10+ tekrar içeren setler için 1RM tahminleri daha az doğruluk payına sahiptir.';

  @override
  String get addPlan => 'Plan Ekle';

  @override
  String get planDetails => 'Plan Detayları';

  @override
  String get exercisesLabel => 'Egzersizler';

  @override
  String get addExerciseToPlan => 'Bu plana bir egzersiz ekle.';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return '“$query” ile eşleşen sonuç yok. Bunu yeni bir egzersiz olarak ekleyebilirsin.';
  }

  @override
  String get selectDays => 'Günleri seç';

  @override
  String get selectExercises => 'Egzersizleri seç';

  @override
  String get todayLabel => 'Bugün';

  @override
  String get setDetails => 'Set Detayları';

  @override
  String get themeLabel => 'Tema';

  @override
  String get pureBlackAmoledDescription =>
      'AMOLED ekranlar için saf siyah renkleri kullan';

  @override
  String get systemColorScheme => 'Sistem teması';

  @override
  String get systemColorSchemeDescription => 'Cihazının ana rengini kullan';

  @override
  String get showImagesDescription =>
      'Geçmiş sayfasında görselleri seç/görüntüle';

  @override
  String get showGlobalProgress => 'Genel İlerlemeyi Göster';

  @override
  String get showGlobalProgressDescription =>
      'İlerlemeni kategoriye göre grafikleyen bir giriş ekle';

  @override
  String get peekGraphDescription =>
      'Grafikler sayfasında ilk çizgisel grafiği göster';

  @override
  String get inputStyleDescription => 'Metin giriş alanlarının görsel stili';

  @override
  String get automaticBackupNotificationBody =>
      'Flexify, verilerini ve görsellerini her gün otomatik olarak seçilen klasöre yedekler.';

  @override
  String get backupSettingsChannel => 'Yedekleme Ayarları';

  @override
  String get backupSettingsChannelDescription =>
      'Otomatik yedeklemeleri açıklayan bildirimler';

  @override
  String get backupChannelName => 'Yedekleme Kanalı';

  @override
  String get backupChannelDescription =>
      'Flexify verilerinin ve görsellerinin otomatik yedeklemeleri';

  @override
  String get backupCompletedTitle => 'Veriler ve görseller yedeklendi';

  @override
  String get backupFailurePathNotSet =>
      'Yedekleme başarısız: yedekleme yolu ayarlanmadı. Otomatik yedeklemeler devre dışı bırakıldı.';

  @override
  String get backupFailureDirectoryUnavailable =>
      'Yedekleme başarısız: yedekleme dizinine erişilemedi. Otomatik yedeklemeler devre dışı bırakıldı.';

  @override
  String get backupFailureCreateFile =>
      'Yedekleme başarısız: yedekleme dosyası oluşturulamadı. Otomatik yedeklemeler devre dışı bırakıldı.';

  @override
  String get backupFailureAppFilesUnavailable =>
      'Yedekleme başarısız: uygulama dosyaları dizinine erişilemedi. Otomatik yedeklemeler devre dışı bırakıldı.';

  @override
  String get backupFailureDatabaseMissing =>
      'Yedekleme başarısız: veritabanı dosyası bulunamadı. Otomatik yedeklemeler devre dışı bırakıldı.';

  @override
  String get backupFailureOutputUnavailable =>
      'Yedekleme başarısız: çıkış akışı açılamadı. Otomatik yedeklemeler devre dışı bırakıldı.';

  @override
  String get backupFailureUnknown =>
      'Yedekleme başarısız. Otomatik yedeklemeler devre dışı bırakıldı.';

  @override
  String get appPermissionsDescription =>
      'Etkinleştirilmiş özelliklerinin gerektirdiği izinleri gözden geçir';

  @override
  String get longDateFormatDescription => 'Alan bol olduğunda kullanılır';

  @override
  String shortDateFormat(String example) {
    return 'Kısa tarih biçimi ($example)';
  }

  @override
  String get shortDateFormatDescription =>
      'Alan dar olduğunda (Grafik çizgileri)';

  @override
  String get warmupSetsDescription =>
      'Isınma setlerinin dinlenme zamanlayıcıları yoktur';

  @override
  String get setsPerExerciseDescription =>
      'Bir plandaki varsayılan egzersiz sayısı';

  @override
  String get planTrailingDisplay => 'Plan kenar görünümü';

  @override
  String get planTrailingDisplayDescription =>
      'Planlar ve plan görünümünde liste öğelerinin sağ tarafı';

  @override
  String get restTimersDescription =>
      'Bir set tamamlandıktan sonra çalınan alarm';

  @override
  String get vibrateDescription => 'Dinlenme zamanlayıcıları titreşsin mi?';

  @override
  String get enableSoundDescription =>
      'Dinlenme zamanlayıcıları ses çalsın mı?';

  @override
  String get keepScreenOnDescription =>
      'Dinlenme zamanlayıcıları sırasında ekranı açık tut';

  @override
  String get restDurationDescription =>
      'Dinlenme alarmları çalmadan önce ne kadar süre geçsin?';

  @override
  String get globalDefault => 'Genel varsayılan';

  @override
  String get alarmSoundDescription =>
      'Dinlenme zamanlayıcısının sonunda çalınacak müzik';

  @override
  String get progressBarPosition => 'İlerleme Çubuğu Konumu';

  @override
  String get progressBarPositionDescription =>
      'Dinlenme zamanlayıcıları ilerleme çubuğu nereye yerleştirilsin?';

  @override
  String get perExerciseRestTimes => 'Egzersize Özel Dinlenme Süreleri';

  @override
  String get perExerciseRestTimesDescription =>
      'Bu egzersizlerin özel dinlenme süreleri var';

  @override
  String get audioFeaturesUnavailable => 'Ses özellikleri kullanılamıyor';

  @override
  String get groupHistoryDescription =>
      'Geçmiş kayıtlarını güne göre birleştir';

  @override
  String get showUnitsDescription =>
      'Grafikler/geçmiş/planlar için km/mi, kg/lb göster';

  @override
  String get showBodyWeightDescription =>
      'Vücut ağırlığı takibini etkinleştir/devre dışı bırak';

  @override
  String get showCategoriesDescription =>
      'Antrenman kategorilerini etkinleştir/devre dışı bırak';

  @override
  String get showNotesDescription =>
      'Kaldırışının detaylarını bir metin alanına kaydet';

  @override
  String get positiveNotificationsDescription =>
      'Yeni bir rekor kırıldığında güzel mesajlar yaz';

  @override
  String get positiveMessagesEnabled =>
      'Olumlu mesajlar artık bu şekilde görünüyor!';

  @override
  String get recordEncouragement01 => 'Aferin LAN! İnanılmazsın.';

  @override
  String get recordEncouragement02 =>
      'Helal olsun kral! Keşke senin gibi olsam.';

  @override
  String get recordEncouragement03 => 'Saygıyla eğiliyorum...';

  @override
  String get recordEncouragement04 => 'Yeni rekoru kırmışsın. Helal olsun!';

  @override
  String get recordEncouragement05 => 'Yapıyorsun bu sporu!';

  @override
  String get recordEncouragement06 => 'Eski sevgiline ne kaybettiğini göster!';

  @override
  String get recordEncouragement07 => 'Sen bir fazla güçlendin hee.';

  @override
  String get recordEncouragement08 => 'Tuna Tavus olma yolunda ilerliyorsun!';

  @override
  String get recordEncouragement09 => 'Harikasın. Böyle devam.';

  @override
  String get recordEncouragement10 => 'Ege Fitness seninle gurur duyardı.';

  @override
  String get recordEncouragement11 =>
      'Gökalaf seni kıskanıyor haberin olsun kanka.';

  @override
  String get recordEncouragement12 => 'BAS BAS BAAAS LAAN!';

  @override
  String get recordEncouragement13 =>
      'Yeni bir rekor mu yoksa? Yapabileceğini biliyordum.';

  @override
  String get recordEncouragement14 =>
      'Azimle çalıştın! Seninle gurur duyuyorum.';

  @override
  String get recordEncouragement15 =>
      'Çerez gibi yersin sen bu ağırlıkları! Hadi koçum!';

  @override
  String get recordEncouragement16 => 'Aynen böyle devam, harika ilerliyorsun!';

  @override
  String get recordEncouragement17 => 'Çok iyisin.';

  @override
  String get recordEncouragement18 => 'Aslanım benim be!';

  @override
  String get recordEncouragement19 => 'Aynen böyle devam.';

  @override
  String get recordEncouragement20 => 'Bana yaklaşmaya başladın hee.';

  @override
  String get recordEncouragement21 => 'Bu gücün vergisini veriyor musun?';

  @override
  String get recordEncouragement22 =>
      'Bu güç ne böyle? Salondaki herkes seni konuşuyor.';

  @override
  String get recordEncouragement23 =>
      'Demirler bile senden korkmaya başladı kral.';

  @override
  String get recordEncouragement24 =>
      'Taş gibisin maşallah, nazar boncuğu takmak lazım.';

  @override
  String get recordEncouragement25 =>
      'Bileğinin hakkıyla aldın o rekoru, kral hareket!';

  @override
  String get recordEncouragement26 =>
      'Makine bozuldu sandım ama meğer sen çok güçlüymüşsün.';

  @override
  String get recordEncouragement27 =>
      'Pre-workout\'u su yerine mi içiyorsun kanka, bu ne enerji?';

  @override
  String get recordEncouragement28 => 'Yıktın geçtin ortalığı kanka!';

  @override
  String get recordEncouragement29 => 'Yavaş lan canavar, salonu yıkacaksın.';

  @override
  String get repEstimationDescription =>
      'Az önce yaptığın tekrar sayısını tahmin etmeye çalış';

  @override
  String get durationEstimationDescription =>
      'Kardiyonun süresini tahmin etmeye çalış';

  @override
  String get showGraphXAxisToggle => 'Grafik X ekseni düğmesini göster';

  @override
  String get showGraphXAxisToggleDescription =>
      'Grafiklerde zamana dayalı X ekseni düğmesini göster';

  @override
  String get showGraphLimitDescription =>
      'Grafiklerde sınır kaydırıcısını göster';

  @override
  String get defaultTimeBasedXAxis => 'Varsayılan zamana dayalı X ekseni';

  @override
  String get defaultTimeBasedXAxisDescription =>
      'Grafiklerde varsayılan olarak zamana dayalı X ekseni kullan';

  @override
  String get createFirstTrainingPlan =>
      'Başlamak için ilk antrenman planını oluştur.';

  @override
  String nothingMatchesPlanSearch(String query) {
    return '“$query” ile eşleşen sonuç yok. Bunu yeni bir plan olarak oluşturabilirsin.';
  }

  @override
  String get createPlan => 'Plan Oluştur';

  @override
  String createNamedPlan(String name) {
    return '“$name” Oluştur';
  }

  @override
  String setNumber(int number) {
    return '$number. Set';
  }
}
