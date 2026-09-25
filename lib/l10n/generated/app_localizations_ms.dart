// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsLanguageDescription =>
      'Pilih bahasa yang digunakan Flexify';

  @override
  String get languageSystemDefault => 'Lalai sistem';

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
  String get navHistory => 'Sejarah';

  @override
  String get navPlans => 'Pelan';

  @override
  String get navGraphs => 'Graf';

  @override
  String get navTimer => 'Pemasa';

  @override
  String get navSettings => 'Tetapan';

  @override
  String get errorLabel => 'Ralat';

  @override
  String get tabContentError => 'Konten tab tidak dapat dibuat.';

  @override
  String get cannotHideAllTabs => 'Tidak boleh menyembunyikan semuanya!';

  @override
  String removeTabQuestion(String tab) {
    return 'Buang tab $tab?';
  }

  @override
  String get restoreTabFromSettings =>
      'Anda boleh menambahkannya semula kemudian daripada tetapan.';

  @override
  String removedTab(String tab) {
    return 'Tab $tab dibuang';
  }

  @override
  String newVersion(String version) {
    return 'Versi baru $version';
  }

  @override
  String get changes => 'Perubahan';

  @override
  String get searchHint => 'Cari...';

  @override
  String get deleteSelected => 'Padam yang dipilih';

  @override
  String get confirmDelete => 'Sahkan pemadaman';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Adakah anda pasti mahu memadam $count rekod? Tindakan ini tidak boleh dibuat asal.',
      one:
          'Adakah anda pasti mahu memadam 1 rekod? Tindakan ini tidak boleh dibuat asal.',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'Batal';

  @override
  String get actionDelete => 'Padam';

  @override
  String get actionRemove => 'Padam';

  @override
  String get actionEdit => 'Sunting';

  @override
  String get actionShare => 'Kongsi';

  @override
  String get clearSelection => 'Padam pilihan';

  @override
  String get clearSearch => 'Padam carian';

  @override
  String get showMenu => 'Tunjukkan menu';

  @override
  String get selectAll => 'Pilih semua';

  @override
  String get weightLabel => 'Berat';

  @override
  String get filter => 'Penyaring';

  @override
  String get filters => 'Penyaring';

  @override
  String get categoryLabel => 'Kategori';

  @override
  String get repsLabel => 'Ulangan';

  @override
  String get repsFilter => 'Filter ulangan';

  @override
  String get weightFilter => 'Filter berat';

  @override
  String get greaterThan => 'Lebih besar dari';

  @override
  String get lessThan => 'Kurang dari';

  @override
  String get startDate => 'Tanggal mulai';

  @override
  String get endDate => 'Tanggal akhir';

  @override
  String get actionClear => 'Bersihkan';

  @override
  String get actionOk => 'OK';

  @override
  String get actionClose => 'Tutup';

  @override
  String get sortBy => 'Urutkan menurut';

  @override
  String get dateNewest => 'Tanggal (terbaru)';

  @override
  String get dateOldest => 'Tanggal (tertua)';

  @override
  String get nameLabel => 'Nama';

  @override
  String get missingPermissions => 'Kebenaran tidak lengkap';

  @override
  String get restTimersPermissionsMissing =>
      'Pemasa rehat dihidupkan, tetapi kebenaran belum diberikan.';

  @override
  String get restTimersPermissionsOptional =>
      'Jika anda mematikan pemasa rehat, kebenaran ini tidak diperlukan.';

  @override
  String get restTimers => 'Pemasa rehat';

  @override
  String get disableBatteryOptimizations => 'Lumpuhkan optimasi baterai';

  @override
  String get batteryOptimizationWarning =>
      'Kemajuan mungkin akan berhenti jika optimasi baterai tetap berjalan.';

  @override
  String get scheduleExactAlarm => 'Jadwalkan alarm tepat masa';

  @override
  String get exactAlarmWarning =>
      'Alarm tidak dapat akurat jika ini dilumpuhkan.';

  @override
  String get postNotifications => 'Hantar pemberitahuan';

  @override
  String get notificationBarDescription =>
      'Kemajuan pemasa dihantar ke bar pemberitahuan';

  @override
  String get invalidPermissions => 'Kebenaran tidak valid';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      'Pemasa rehat dihidupkan tanpa kebenaran yang mencukupi. Adakah anda pasti?';

  @override
  String get actionConfirm => 'Konfirmasi';

  @override
  String get appAccess => 'Akses aplikasi';

  @override
  String get appAccessDescription =>
      'Diperlukan untuk pemasa dan pemberitahuan yang diaktifkan.';

  @override
  String get notifications => 'Pemberitahuan';

  @override
  String get timerProgressAndRestAlerts => 'Kemajuan pemasa dan amaran rehat';

  @override
  String get enabledNotificationsDescription =>
      'Pemberitahuan yang anda aktifkan';

  @override
  String get backgroundActivity => 'Aktivitas latar belakang';

  @override
  String get backgroundActivityDescription =>
      'Jaga agar pemasa tetap andal di latar belakang';

  @override
  String get exactAlarms => 'Alarm tepat masa';

  @override
  String get exactAlarmsDescription =>
      'Beri amaran tepat apabila pemasa rehat tamat';

  @override
  String get noAdditionalAndroidAccessNeeded =>
      'Tiada akses Android tambahan diperlukan untuk tetapan semasa anda.';

  @override
  String get actionDone => 'Selesai';

  @override
  String get allowed => 'Dikebenarankan';

  @override
  String get actionAllow => 'Kebenarankan';

  @override
  String get backupLabel => 'Cadangan';

  @override
  String get databaseLabel => 'Pangkalan data';

  @override
  String get deleteRecords => 'Padam rekod';

  @override
  String get deleteAllGraphsConfirmation =>
      'Adakah anda pasti mahu memadam semua graf? Tindakan ini tidak boleh dibuat asal.';

  @override
  String get deleteAllPlansConfirmation =>
      'Adakah anda pasti mahu memadam semua pelan? Tindakan ini tidak boleh dibuat asal.';

  @override
  String get deleteDatabaseConfirmation =>
      'Adakah anda pasti mahu memadam pangkalan data anda? Tindakan ini tidak boleh dibuat asal dan akan memadam semua data anda.';

  @override
  String get importData => 'Import data';

  @override
  String get exportData => 'Eksport data';

  @override
  String get actionReport => 'Laporkan';

  @override
  String get graphDataImported => 'Data graf diimportt dengan sukses!';

  @override
  String get plansImported => 'Pelan diimportt dengan sukses';

  @override
  String failedToImportDatabase(String error) {
    return 'Gagal mengimportt pangkalan data: $error';
  }

  @override
  String get backupArchiveMissingDatabase =>
      'Arsip cadangan tidak berisi pangkalan data Flexify.';

  @override
  String failedToImportGraphs(String error) {
    return 'Gagal mengimportt graf: $error';
  }

  @override
  String failedToImportPlans(String error) {
    return 'Gagal mengimportt pelan: $error';
  }

  @override
  String get selectedFileDoesNotExist => 'Fail yang dipilih tidak wujud';

  @override
  String get couldNotReadFileData => 'Tidak dapat membaca data fail';

  @override
  String get databaseImportWebUnsupported =>
      'Import pangkalan data di web memerlukan pemindahan data secara manual. Sila eksport data anda sebagai fail CSV dan import fail tersebut.';

  @override
  String get csvFileEmpty => 'Fail CSV kosong';

  @override
  String get csvNeedsDataRow =>
      'Fail CSV mesti mengandungi sekurang-kurangnya satu baris data';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return 'Baris $row tidak mempunyai lajur yang mencukupi: $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return 'Nilai $field tidak sah pada baris $row: $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return 'Jenis data $field tidak sah pada baris $row: $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return 'ID pelan mestilah integer, tetapi menerima \"$value\"';
  }

  @override
  String get unitLabel => 'Satuan';

  @override
  String get kilogramsUnit => 'Kilogram (kg)';

  @override
  String get poundsUnit => 'Pon (lb)';

  @override
  String get stoneUnit => 'Stone (st)';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => 'Kilometer (km)';

  @override
  String get milesUnit => 'Batu (mi)';

  @override
  String get metersUnit => 'Meter (m)';

  @override
  String get kilocaloriesUnit => 'Kilokalori (kcal)';

  @override
  String get enterWeight => 'Masukkan berat';

  @override
  String get requiredField => 'Wajib diisi';

  @override
  String get invalidNumber => 'Nomor tidak valid';

  @override
  String get previousWeight => 'Berat sebelum ini';

  @override
  String get imageLabel => 'Gambar';

  @override
  String get longPressToDelete => 'Tekan lama untuk memadam';

  @override
  String get imageError => 'Ralat imej';

  @override
  String get actionSave => 'Simpan';

  @override
  String get aboutTitle => 'Tentang';

  @override
  String get donate => 'Derma';

  @override
  String get helpSupportProject => 'Bantu mendukung proyek ini';

  @override
  String get whatsNewAbout => 'Apa yang baru?';

  @override
  String get whatsNewTitle => 'Apa yang baru?';

  @override
  String get seeReleaseNotes => 'Lihat nota keluaran kami';

  @override
  String get versionLabel => 'Versi';

  @override
  String get authorLabel => 'Penulis';

  @override
  String get privacyPolicy => 'Kebijakan privasi';

  @override
  String get privacyPolicyDescription => 'Cara Flexify menangani data Anda';

  @override
  String get licenseLabel => 'Lisensi';

  @override
  String get sourceCode => 'Kode sumber';

  @override
  String get sourceCodeDescription => 'Lihat di GitHub';

  @override
  String get leaveReview => 'Beri ulasan';

  @override
  String get leaveReviewDescription => 'Beri nilai Flexify di Play Store';

  @override
  String get reportBug => 'Laporkan bug';

  @override
  String get reportBugDescription => 'Buka tiket di GitHub';

  @override
  String get failedMigrations => 'Migrasi gagal';

  @override
  String get errorMessageLabel => 'Mesej galat:';

  @override
  String get createIssue => 'Buat isu';

  @override
  String get addExercise => 'Tambah senaman';

  @override
  String get cardio => 'Kardio';

  @override
  String get strength => 'Kekuatan';

  @override
  String get options => 'Opsi';

  @override
  String get periodDay => 'Hari';

  @override
  String get periodWeek => 'Minggu';

  @override
  String get periodMonth => 'Bulan';

  @override
  String get periodYear => 'Tahun';

  @override
  String noDataFor(String name) {
    return 'Belum ada data untuk $name';
  }

  @override
  String get noDataYet => 'Belum ada data';

  @override
  String get exerciseNotes => 'Nota senaman';

  @override
  String get notesForExercise => 'Nota untuk senaman ini';

  @override
  String get useTimeBasedXAxis => 'Gunakan paksi X berasaskan masa';

  @override
  String updateAllNamed(String name) {
    return 'Kemas kini semua $name';
  }

  @override
  String get newName => 'Nama baru';

  @override
  String get restMinutes => 'Minit rehat';

  @override
  String get restSeconds => 'Saat rehat';

  @override
  String get globalProgress => 'Kemajuan global';

  @override
  String get curveLineGraphs => 'Lengkungkan graf garis';

  @override
  String get curveLineGraphsDescription =>
      'Gambar garis graf sebagai lengkung halus';

  @override
  String noHistoryFor(String name) {
    return 'Belum ada sejarah untuk $name';
  }

  @override
  String get cancelSelection => 'Batalkan pilihan';

  @override
  String get editSelected => 'Sunting yang dipilih';

  @override
  String get newExercise => 'Senaman baru';

  @override
  String get noGraphsFound => 'Tidak ada graf';

  @override
  String get searchGraphs => 'Cari graf…';

  @override
  String get actionAdd => 'Tambah';

  @override
  String get actionUpdate => 'Kemas kini';

  @override
  String get hideGlobalProgress => 'Sembunyikan kemajuan global';

  @override
  String get chartGroupedByCategory =>
      'Graf yang dikelompokkan berdasarkan kategori';

  @override
  String get noExercisesFound => 'Tidak ada senaman';

  @override
  String get savePlan => 'Simpan pelan';

  @override
  String get titleOptional => 'Tajuk (pilihan)';

  @override
  String get searchExercises => 'Cari senaman…';

  @override
  String get warmupSets => 'Set pemanasan';

  @override
  String get workingSetsMax => 'Set kerja (maks: 20)';

  @override
  String get actionUndo => 'Buat asal';

  @override
  String get actionSwap => 'Tukar';

  @override
  String get daily => 'Harian';

  @override
  String get weekly => 'Mingguan';

  @override
  String get monthly => 'Bulanan';

  @override
  String get yearly => 'Tahunan';

  @override
  String get unexpectedError => 'Terjadi kesalahan. Sila coba lagi.';

  @override
  String get loadingExercises => 'Memuat senaman…';

  @override
  String get noPlansYet => 'Belum ada pelan.';

  @override
  String get noMatchingPlans => 'Tidak ada pelan yang cocok';

  @override
  String get newPlan => 'Pelan baru';

  @override
  String get searchPlans => 'Cari pelan…';

  @override
  String get noExercisesYet => 'Belum ada senaman.';

  @override
  String get editPlan => 'Sunting pelan';

  @override
  String get saveSet => 'Simpan set';

  @override
  String get minutesLabel => 'Minit';

  @override
  String get minutesShort => 'mnt';

  @override
  String get secondsLabel => 'Saat';

  @override
  String get distanceLabel => 'Jarak';

  @override
  String get inclinePercent => 'Kecondongan %';

  @override
  String weightWithUnit(String unit) {
    return 'Berat ($unit)';
  }

  @override
  String get useBodyWeight => 'Gunakan berat badan';

  @override
  String get noWeightEnteredYet => 'Belum ada berat yang dimasukkan';

  @override
  String get notesLabel => 'Nota';

  @override
  String get swapWorkout => 'Tukar senaman';

  @override
  String get addSet => 'Tambah set';

  @override
  String get deleteSet => 'Padam set';

  @override
  String get oneRepMaxEstimate => 'Maksimum 1 ulangan (perkiraan)';

  @override
  String get valueLabel => 'Nilai';

  @override
  String amountWithUnit(String unit) {
    return 'Jumlah ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return 'Jarak ($unit)';
  }

  @override
  String get bodyWeightLabel => 'Berat badan';

  @override
  String bodyWeightWithUnit(String unit) {
    return 'Berat badan ($unit)';
  }

  @override
  String get categoryHelper => 'Pilih kategori yang ada atau ketik yang baru.';

  @override
  String get manageCategories => 'Kelola kategori';

  @override
  String get manageCategoriesDescription =>
      'Buat, ubah nama, gabung atau padam kategori';

  @override
  String get newCategory => 'Kategori baru';

  @override
  String get renameCategory => 'Ubah nama kategori';

  @override
  String get mergeCategory => 'Gabung ke kategori lain';

  @override
  String get noCategories => 'Belum ada kategori';

  @override
  String get categoryNameRequired => 'Masukkan nama kategori';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Digunakan oleh $count entri',
      one: 'Digunakan oleh 1 entri',
      zero: 'Tidak digunakan oleh mana-mana entri',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Padam kategori ini dan keluarkannya daripada $count entri?',
      one: 'Padam kategori ini dan keluarkannya daripada 1 entri?',
      zero: 'Padam kategori ini?',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => 'Tanggal dibuat';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Edit $count set',
      one: 'Edit 1 set',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => 'Belum ada entri';

  @override
  String get historyEmptyMessage =>
      'Lengkapkan satu set atau tambah satu secara manual untuk memulakan sejarah anda.';

  @override
  String deleteSetConfirmation(String name) {
    return 'Adakah anda pasti mahu memadam $name?';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Adakah anda pasti mahu memadam $count entri?',
      one: 'Adakah anda pasti mahu memadam 1 entri?',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => 'Cari sejarah...';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeLight => 'Terang';

  @override
  String get pureBlackAmoled => 'Hitam tulen (AMOLED)';

  @override
  String get showImages => 'Tunjukkan gambar';

  @override
  String get peekGraph => 'Pratinjau graf';

  @override
  String get inputStyleLine => 'Baris';

  @override
  String get inputStyleOutlined => 'Tergaris';

  @override
  String get inputStyleFilled => 'Terisi';

  @override
  String get inputStyle => 'Gaya input';

  @override
  String get appearance => 'Paparan';

  @override
  String get automaticBackupsEnabled => 'Sandaran automatik diaktifkan';

  @override
  String get automaticBackup => 'Sandaran automatik';

  @override
  String get appPermissions => 'Kebenaran aplikasi';

  @override
  String get shareDatabase => 'Kongsi pangkalan data';

  @override
  String get dataManagement => 'Pengelolaan data';

  @override
  String get strengthUnit => 'Satuan kekuatan';

  @override
  String get lastEntry => 'Entri terakhir';

  @override
  String get cardioUnit => 'Satuan kardio';

  @override
  String longDateFormat(String format) {
    return 'Format tanggal panjang ($format)';
  }

  @override
  String get formats => 'Format';

  @override
  String get setsPerExerciseMax => 'Set per senaman (maks: 20)';

  @override
  String get countLabel => 'Kiraan';

  @override
  String get ratioLabel => 'Nisbah';

  @override
  String get reorder => 'Urutkan ulang';

  @override
  String get none => 'Tiada';

  @override
  String get monday => 'Senin';

  @override
  String get examplePlanExercises => 'Bench press, squat, dan deadlift';

  @override
  String get tabs => 'Tab';

  @override
  String get swipeBetweenTabs => 'Leret antara tab';

  @override
  String get vibrate => 'Getar';

  @override
  String get enableSound => 'Aktifkan suara';

  @override
  String get keepScreenOn => 'Biarkan skrin menyala';

  @override
  String get alarmSound => 'Suara alarm';

  @override
  String get top => 'Atas';

  @override
  String get bottom => 'Bawah';

  @override
  String get removeCustomTimer =>
      'Padam pemasa khusus (gunakan default global)';

  @override
  String get timers => 'Pemasa';

  @override
  String get timerSettings => 'Tetapan pemasa';

  @override
  String get groupHistory => 'Kelompokkan sejarah';

  @override
  String get showUnits => 'Tunjukkan satuan';

  @override
  String get showBodyWeight => 'Tunjukkan berat badan';

  @override
  String get showCategories => 'Tunjukkan kategori';

  @override
  String get showNotes => 'Tunjukkan nota';

  @override
  String get repEstimation => 'Perkiraan ulangan';

  @override
  String get durationEstimation => 'Perkiraan durasi';

  @override
  String get showGraphLimit => 'Tunjukkan batas graf';

  @override
  String get defaultGraphMetric => 'Metrik graf default';

  @override
  String get bestWeight => 'Berat terbaik';

  @override
  String get bestReps => 'Ulangan terbaik';

  @override
  String get oneRepMax => 'Maksimum 1 ulangan';

  @override
  String get volume => 'Volume senaman';

  @override
  String get paceCardio => 'Laju (kardio)';

  @override
  String get distanceCardio => 'Jarak (kardio)';

  @override
  String get defaultGraphPeriod => 'Periode graf default';

  @override
  String get defaultGraphLimit => 'Batas graf default';

  @override
  String get workouts => 'Senaman';

  @override
  String get actionStop => 'Berhenti';

  @override
  String get timerFinishedToast => 'Pemasa selesai!';

  @override
  String get stopTimer => 'Hentikan pemasa';

  @override
  String get actionPause => 'Jeda';

  @override
  String get startStopwatch => 'Mulai stopwatch';

  @override
  String get actionStart => 'Mulai';

  @override
  String get actionRestart => 'Mulai ulang';

  @override
  String get addOneMinute => '+1 minit';

  @override
  String get addOneMinuteNotification => 'Tambah 1 minit';

  @override
  String get restTimer => 'Pemasa rehat';

  @override
  String get timerUp => 'Masa habis';

  @override
  String get openNotification => 'Buka pemberitahuan';

  @override
  String get timerChannelName => 'Saluran pemasa';

  @override
  String get timerChannelDescription =>
      'Kemajuan pemasa rehat yang sedang berjalan.';

  @override
  String get timerFinishedChannelName => 'Saluran pemasa selesai';

  @override
  String get timerFinishedChannelDescription =>
      'Mainkan penggera apabila pemasa rehat tamat.';

  @override
  String get timerFinished => 'Pemasa selesai';

  @override
  String get batteryOptimizationRequestUnavailable =>
      'Permintaan untuk mengabaikan pengoptimuman bateri dilumpuhkan pada peranti anda.';

  @override
  String get exactAlarmRequestUnavailable =>
      'Permintaan SCHEDULE_EXACT_ALARM ditolak pada peranti anda';

  @override
  String get databaseMigrationFailureDescription =>
      'Sesuatu tidak kena semasa mencipta atau menaik taraf pangkalan data anda. Biasanya ini boleh diperbaiki dengan memadam dan mencipta semula rekod anda.';

  @override
  String get curveSmoothness => 'Kehalusan lengkung';

  @override
  String get actionBack => 'Kembali';

  @override
  String get atLeastOneTab => 'Anda memerlukan setidaknya satu tab';

  @override
  String get invalidTabSettings => 'Tetapan tab tidak sah.';

  @override
  String get noSettingsFound => 'Tidak ada tetapan yang ditemukan';

  @override
  String nothingMatchesSearch(String query) {
    return 'Tidak ada yang cocok dengan \"$query\".';
  }

  @override
  String get appearanceDescription => 'Tema, warna, dan paparan antarmuka';

  @override
  String get dataManagementDescription =>
      'Import, eksport, dan kelola data senaman Anda';

  @override
  String get formatsDescription => 'Format tanggal, angka, dan pengukuran';

  @override
  String get plansSettingsDescription =>
      'Default dan perilaku untuk pelan senaman';

  @override
  String get tabsDescription => 'Pilih dan atur tab navigasi utama';

  @override
  String get timersDescription => 'Tempoh, bunyi dan tingkah laku pemasa rehat';

  @override
  String get workoutsDescription => 'Preferensi pelacakan senaman dan gerakan';

  @override
  String get completeSetForChart =>
      'Selesaikan satu set untuk senaman ini agar graf dapat dibuat.';

  @override
  String get dateRange => 'Rentang tanggal';

  @override
  String get stopDate => 'Tanggal akhir';

  @override
  String get dataPoints => 'Titik data';

  @override
  String get completeSetsForProgress =>
      'Selesaikan beberapa set untuk membuat graf kemajuan Anda.';

  @override
  String get relativeStrength => 'Kekuatan relatif';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dipilih',
      one: '1 dipilih',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory =>
      'Selesaikan beberapa set untuk melihat sejarah senaman ini di sini.';

  @override
  String get completeSetForFirstGraph =>
      'Selesaikan satu set untuk membuat graf senaman pertama Anda.';

  @override
  String nothingMatchesGraphSearch(String query) {
    return 'Tiada yang sepadan dengan “$query”. Anda boleh menciptanya sebagai senaman baharu.';
  }

  @override
  String addNamed(String name) {
    return 'Tambah “$name”';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return 'Ini akan memadam $count rekod. Adakah anda pasti?';
  }

  @override
  String shareWorkout(String summary) {
    return 'Saya baru sahaja melakukan $summary';
  }

  @override
  String get updateConflict => 'Konflik kemas kini';

  @override
  String updateConflictDescription(int count) {
    return 'Nama baharu anda sudah wujud untuk $count rekod sejarah. Adakah anda pasti?';
  }

  @override
  String get unitsConflict => 'Konflik satuan';

  @override
  String unitsConflictDescription(String unit) {
    return 'Tidak semua rekod anda menggunakan unit yang sama. Ini akan menukar semua unit kepada $unit. Adakah anda pasti?';
  }

  @override
  String get durationLabel => 'Durasi';

  @override
  String get inclineLabel => 'Kecondongan';

  @override
  String get paceDistanceTime => 'Laju (jarak / masa)';

  @override
  String get adjustedPace => 'Laju yang disesuaikan';

  @override
  String get oneRepMaxAccuracyWarning =>
      'Perkiraan maksimum 1 ulangan kurang akurat untuk set dengan 10+ ulangan';

  @override
  String get addPlan => 'Tambah pelan';

  @override
  String get planDetails => 'Rincian pelan';

  @override
  String get exercisesLabel => 'Senaman';

  @override
  String get addExerciseToPlan => 'Tambah senaman ke pelan ini.';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return 'Tiada yang sepadan dengan “$query”. Anda boleh menambahnya sebagai senaman baharu.';
  }

  @override
  String get selectDays => 'Pilih hari';

  @override
  String get selectExercises => 'Pilih senaman';

  @override
  String get todayLabel => 'Hari ini';

  @override
  String get setDetails => 'Detail set';

  @override
  String get themeLabel => 'Tema';

  @override
  String get pureBlackAmoledDescription =>
      'Gunakan warna hitam tulen untuk paparan AMOLED';

  @override
  String get systemColorScheme => 'Skema warna sistem';

  @override
  String get systemColorSchemeDescription =>
      'Gunakan warna utama peranti anda untuk aplikasi';

  @override
  String get showImagesDescription =>
      'Pilih atau tunjukkan gambar di halaman Sejarah';

  @override
  String get showGlobalProgress => 'Tunjukkan kemajuan keseluruhan';

  @override
  String get showGlobalProgressDescription =>
      'Tambah entri graf yang memetakan kemajuan Anda berdasarkan kategori';

  @override
  String get peekGraphDescription =>
      'Tunjukkan graf garis pertama di halaman Graf';

  @override
  String get inputStyleDescription => 'Gaya visual lajur input teks';

  @override
  String get automaticBackupNotificationBody =>
      'Flexify akan mencadangkan data dan gambar Anda secara automatik ke folder yang dipilih setiap hari.';

  @override
  String get backupSettingsChannel => 'Tetapan sandaran';

  @override
  String get backupSettingsChannelDescription =>
      'Pemberitahuan yang menerangkan sandaran automatik';

  @override
  String get backupChannelName => 'Saluran cadangan';

  @override
  String get backupChannelDescription =>
      'Sandaran automatik data dan gambar Flexify';

  @override
  String get backupCompletedTitle => 'Data dan gambar berjaya dicadangkan';

  @override
  String get backupFailurePathNotSet =>
      'Sandaran gagal: laluan sandaran belum ditetapkan. Sandaran automatik dilumpuhkan.';

  @override
  String get backupFailureDirectoryUnavailable =>
      'Sandaran gagal: direktori sandaran tidak dapat diakses. Sandaran automatik dilumpuhkan.';

  @override
  String get backupFailureCreateFile =>
      'Sandaran gagal: tidak dapat mencipta fail sandaran. Sandaran automatik dilumpuhkan.';

  @override
  String get backupFailureAppFilesUnavailable =>
      'Sandaran gagal: tidak dapat mengakses direktori fail aplikasi. Sandaran automatik dilumpuhkan.';

  @override
  String get backupFailureDatabaseMissing =>
      'Sandaran gagal: fail pangkalan data tidak ditemui. Sandaran automatik dilumpuhkan.';

  @override
  String get backupFailureOutputUnavailable =>
      'Sandaran gagal: destinasi output tidak dapat dibuka. Sandaran automatik dilumpuhkan.';

  @override
  String get backupFailureUnknown =>
      'Sandaran gagal secara tidak dijangka. Sandaran automatik dilumpuhkan.';

  @override
  String get appPermissionsDescription =>
      'Tinjau akses yang diperlukan oleh fitur yang Anda aktifkan';

  @override
  String get longDateFormatDescription =>
      'Digunakan saat ruang tersedia cukup luas';

  @override
  String shortDateFormat(String example) {
    return 'Format tanggal pendek ($example)';
  }

  @override
  String get shortDateFormatDescription =>
      'Digunakan saat ruang terbatas (garis graf)';

  @override
  String get warmupSetsDescription =>
      'Set pemanasan tidak mempunyai pemasa rehat';

  @override
  String get setsPerExerciseDescription =>
      'Jumlah senaman default dalam sebuah pelan';

  @override
  String get planTrailingDisplay => 'Paparan sebelah kanan pelan';

  @override
  String get planTrailingDisplayDescription =>
      'Maklumat yang ditunjukkan di sebelah kanan senarai pada paparan Pelan dan butiran pelan';

  @override
  String get restTimersDescription =>
      'Alarm yang berbunyi setelah menyelesaikan satu set';

  @override
  String get vibrateDescription => 'Adakah pemasa rehat perlu bergetar?';

  @override
  String get enableSoundDescription =>
      'Adakah pemasa rehat perlu memainkan bunyi?';

  @override
  String get keepScreenOnDescription =>
      'Kekalkan skrin hidup semasa pemasa rehat';

  @override
  String get restDurationDescription =>
      'Berapa lama sebelum alarm rehat berbunyi?';

  @override
  String get globalDefault => 'Default global';

  @override
  String get alarmSoundDescription =>
      'Muzik yang dimainkan apabila pemasa rehat tamat';

  @override
  String get progressBarPosition => 'Kedudukan bar kemajuan';

  @override
  String get progressBarPositionDescription =>
      'Di manakah bar kemajuan pemasa rehat perlu diletakkan?';

  @override
  String get perExerciseRestTimes => 'Masa rehat bagi setiap senaman';

  @override
  String get perExerciseRestTimesDescription =>
      'Senaman ini mempunyai tempoh rehat tersuai';

  @override
  String get audioFeaturesUnavailable => 'Fitur audio tidak tersedia';

  @override
  String get groupHistoryDescription =>
      'Gabungkan entri sejarah berdasarkan hari';

  @override
  String get showUnitsDescription =>
      'Tunjukkan km/mi dan kg/lb pada graf, sejarah, dan pelan';

  @override
  String get showBodyWeightDescription =>
      'Aktifkan atau lumpuhkan pelacakan berat badan';

  @override
  String get showCategoriesDescription =>
      'Aktifkan atau lumpuhkan kategori senaman';

  @override
  String get showNotesDescription =>
      'Catat detail angkatan Anda dalam lajur teks';

  @override
  String get positiveNotificationsDescription =>
      'Tunjukkan mesej positif saat rekor baru tercapai';

  @override
  String get positiveMessagesEnabled =>
      'Mesej positif kini akan tampil seperti ini!';

  @override
  String get recordEncouragement01 => 'Kerja bagus! Kamu luar biasa.';

  @override
  String get recordEncouragement02 =>
      'Mantap, jagoan! Kemajuanmu menginspirasi.';

  @override
  String get recordEncouragement03 => 'Aku berlutut...';

  @override
  String get recordEncouragement04 => 'Apa itu? Rekor baru!';

  @override
  String get recordEncouragement05 =>
      'Luar biasa! Kamu benar-benar menginspirasi.';

  @override
  String get recordEncouragement06 => 'Wow. Mantap.';

  @override
  String get recordEncouragement07 => 'Makin kuat, ya?';

  @override
  String get recordEncouragement08 => 'Ya. Kamu makin besar dan kuat.';

  @override
  String get recordEncouragement09 => 'Hebat. Luar biasa.';

  @override
  String get recordEncouragement10 => 'Arnie pasti bangga.';

  @override
  String get recordEncouragement11 => 'Ronnie C melihatmu dengan bangga.';

  @override
  String get recordEncouragement12 => 'YA! RINGAN SAHAJA!!!!!!!';

  @override
  String get recordEncouragement13 => 'Rekor baru? Sudah kuduga kamu boleh.';

  @override
  String get recordEncouragement14 => 'Kerja bagus! Aku bangga padamu.';

  @override
  String get recordEncouragement15 => 'YA! RINGAN SAHAJA!';

  @override
  String get recordEncouragement16 => 'Teruskan! Kemajuanmu hebat.';

  @override
  String get recordEncouragement17 => 'Kamu melakukannya dengan sangat baik.';

  @override
  String get recordEncouragement18 => 'Itulah dia!';

  @override
  String get recordEncouragement19 => 'Teruskan.';

  @override
  String get recordEncouragement20 => 'Kamu makin kuat.';

  @override
  String get recordEncouragement21 => 'Kuat.';

  @override
  String get recordEncouragement22 => 'Sangat hebat!';

  @override
  String get recordEncouragement23 => 'Aku bangga padamu.';

  @override
  String get recordEncouragement24 => 'Teruskan usaha hebat ini.';

  @override
  String get recordEncouragement25 =>
      'Berdiri tegak! Kamu baru saja mencetak rekor baru.';

  @override
  String get recordEncouragement26 =>
      'Rekod baharu! Anda baru sahaja melangkaui pencapaian sebelum ini!';

  @override
  String get recordEncouragement27 => 'Yap! Itu rekor.';

  @override
  String get recordEncouragement28 => 'Wow! Rekor baru!';

  @override
  String get recordEncouragement29 => 'Bagus!';

  @override
  String get repEstimationDescription =>
      'Coba perkirakan jumlah ulangan yang baru saja Anda lakukan';

  @override
  String get durationEstimationDescription =>
      'Coba perkirakan durasi kardio Anda';

  @override
  String get showGraphXAxisToggle => 'Suis paksi X berasaskan masa';

  @override
  String get showGraphXAxisToggleDescription =>
      'Tunjukkan suis paksi X berasaskan masa pada graf';

  @override
  String get showGraphLimitDescription => 'Tunjukkan peluncur had pada graf';

  @override
  String get defaultTimeBasedXAxis => 'Paksi X berasaskan masa secara lalai';

  @override
  String get defaultTimeBasedXAxisDescription =>
      'Gunakan paksi X berasaskan masa secara lalai pada graf';

  @override
  String get createFirstTrainingPlan =>
      'Cipta pelan latihan pertama anda untuk bermula.';

  @override
  String nothingMatchesPlanSearch(String query) {
    return 'Tiada yang sepadan dengan “$query”. Anda boleh menciptanya sebagai pelan baharu.';
  }

  @override
  String get createPlan => 'Buat pelan';

  @override
  String createNamedPlan(String name) {
    return 'Buat \"$name\"';
  }

  @override
  String setNumber(int number) {
    return 'Set ke-$number';
  }
}
