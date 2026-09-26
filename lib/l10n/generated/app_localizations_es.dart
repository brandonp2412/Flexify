// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageDescription => 'Elige el idioma que usa Flexify';

  @override
  String get languageSystemDefault => 'Predeterminado del sistema';

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
  String get navHistory => 'Historial';

  @override
  String get navPlans => 'Planes';

  @override
  String get navGraphs => 'Gráficos';

  @override
  String get navTimer => 'Temporizador';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get errorLabel => 'Error';

  @override
  String get tabContentError =>
      'No se pudo mostrar el contenido de la pestaña.';

  @override
  String get cannotHideAllTabs => '¡No puedes ocultarlo todo!';

  @override
  String removeTabQuestion(String tab) {
    return '¿Quitar la pestaña $tab?';
  }

  @override
  String get restoreTabFromSettings =>
      'Puedes volver a añadirla más tarde desde los ajustes.';

  @override
  String removedTab(String tab) {
    return 'Se quitó $tab';
  }

  @override
  String newVersion(String version) {
    return 'Nueva versión $version';
  }

  @override
  String get changes => 'Cambios';

  @override
  String get searchHint => 'Buscar...';

  @override
  String get deleteSelected => 'Eliminar seleccionados';

  @override
  String get confirmDelete => 'Confirmar eliminación';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '¿Seguro que quieres eliminar $count registros? Esta acción no se puede deshacer.',
      one:
          '¿Seguro que quieres eliminar 1 registro? Esta acción no se puede deshacer.',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get actionRemove => 'Quitar';

  @override
  String get actionEdit => 'Editar';

  @override
  String get actionShare => 'Compartir';

  @override
  String get clearSelection => 'Borrar selección';

  @override
  String get clearSearch => 'Borrar búsqueda';

  @override
  String get showMenu => 'Mostrar menú';

  @override
  String get selectAll => 'Seleccionar todo';

  @override
  String get weightLabel => 'Peso';

  @override
  String get filter => 'Filtrar';

  @override
  String get filters => 'Filtros';

  @override
  String get categoryLabel => 'Categoría';

  @override
  String get repsLabel => 'Repeticiones';

  @override
  String get repsFilter => 'Filtro de repeticiones';

  @override
  String get weightFilter => 'Filtro de peso';

  @override
  String get greaterThan => 'Mayor que';

  @override
  String get lessThan => 'Menor que';

  @override
  String get startDate => 'Fecha de inicio';

  @override
  String get endDate => 'Fecha de fin';

  @override
  String get actionClear => 'Borrar';

  @override
  String get actionOk => 'Aceptar';

  @override
  String get actionClose => 'Cerrar';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get dateNewest => 'Fecha (más recientes)';

  @override
  String get dateOldest => 'Fecha (más antiguas)';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get missingPermissions => 'Faltan permisos';

  @override
  String get restTimersPermissionsMissing =>
      'Los temporizadores de descanso están activados, pero faltan permisos.';

  @override
  String get restTimersPermissionsOptional =>
      'Si desactivas los temporizadores de descanso, estos permisos no son necesarios.';

  @override
  String get restTimers => 'Temporizadores de descanso';

  @override
  String get disableBatteryOptimizations =>
      'Desactivar optimizaciones de batería';

  @override
  String get batteryOptimizationWarning =>
      'El progreso puede detenerse si las optimizaciones de batería siguen activadas.';

  @override
  String get scheduleExactAlarm => 'Programar alarma exacta';

  @override
  String get exactAlarmWarning =>
      'Las alarmas no pueden ser precisas si esta opción está desactivada.';

  @override
  String get postNotifications => 'Mostrar notificaciones';

  @override
  String get notificationBarDescription =>
      'El progreso del temporizador se muestra en la barra de notificaciones';

  @override
  String get invalidPermissions => 'Permisos no válidos';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      'Los temporizadores de descanso están activados sin los permisos necesarios. ¿Seguro?';

  @override
  String get actionConfirm => 'Confirmar';

  @override
  String get appAccess => 'Acceso de la aplicación';

  @override
  String get appAccessDescription =>
      'Necesario para los temporizadores y las notificaciones que tengas activados.';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get timerProgressAndRestAlerts =>
      'Progreso del temporizador y avisos de descanso';

  @override
  String get enabledNotificationsDescription =>
      'Notificaciones que has activado';

  @override
  String get backgroundActivity => 'Actividad en segundo plano';

  @override
  String get backgroundActivityDescription =>
      'Mantén los temporizadores funcionando de forma fiable en segundo plano';

  @override
  String get exactAlarms => 'Alarmas exactas';

  @override
  String get exactAlarmsDescription =>
      'Avisa justo cuando termina un temporizador de descanso';

  @override
  String get noAdditionalAndroidAccessNeeded =>
      'No se necesita ningún acceso adicional de Android con tus ajustes actuales.';

  @override
  String get actionDone => 'Listo';

  @override
  String get allowed => 'Permitido';

  @override
  String get actionAllow => 'Permitir';

  @override
  String get backupLabel => 'Copia de seguridad';

  @override
  String get databaseLabel => 'Base de datos';

  @override
  String get deleteRecords => 'Eliminar registros';

  @override
  String get deleteAllGraphsConfirmation =>
      '¿Seguro que quieres eliminar todos los gráficos? Esta acción no se puede deshacer.';

  @override
  String get deleteAllPlansConfirmation =>
      '¿Seguro que quieres eliminar todos los planes? Esta acción no se puede deshacer.';

  @override
  String get deleteDatabaseConfirmation =>
      '¿Seguro que quieres eliminar tu base de datos? Esta acción no se puede deshacer y destruirá todos tus datos.';

  @override
  String get importData => 'Importar datos';

  @override
  String get exportData => 'Exportar datos';

  @override
  String get actionReport => 'Informar';

  @override
  String get graphDataImported =>
      '¡Los datos de gráficos se importaron correctamente!';

  @override
  String get plansImported => 'Los planes se importaron correctamente';

  @override
  String failedToImportDatabase(String error) {
    return 'No se pudo importar la base de datos: $error';
  }

  @override
  String get backupArchiveMissingDatabase =>
      'La copia de seguridad no contiene la base de datos de Flexify.';

  @override
  String failedToImportGraphs(String error) {
    return 'No se pudieron importar los gráficos: $error';
  }

  @override
  String failedToImportPlans(String error) {
    return 'No se pudieron importar los planes: $error';
  }

  @override
  String get selectedFileDoesNotExist => 'El archivo seleccionado no existe';

  @override
  String get couldNotReadFileData =>
      'No se pudieron leer los datos del archivo';

  @override
  String get databaseImportWebUnsupported =>
      'Importar una base de datos en la web requiere migrar los datos manualmente. Exporta tus datos como archivos CSV e impórtalos en su lugar.';

  @override
  String get csvFileEmpty => 'El archivo CSV está vacío';

  @override
  String get csvNeedsDataRow =>
      'El archivo CSV debe contener al menos una fila de datos';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return 'La fila $row no tiene suficientes columnas: $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return 'Valor de $field no válido en la fila $row: $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return 'Tipo de dato de $field no válido en la fila $row: $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return 'Se esperaba un identificador de plan entero, pero se recibió \"$value\"';
  }

  @override
  String get unitLabel => 'Unidad';

  @override
  String get kilogramsUnit => 'Kilogramos (kg)';

  @override
  String get poundsUnit => 'Libras (lb)';

  @override
  String get stoneUnit => 'Stone';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => 'Kilómetros (km)';

  @override
  String get milesUnit => 'Millas (mi)';

  @override
  String get metersUnit => 'Metros (m)';

  @override
  String get kilocaloriesUnit => 'Kilocalorías (kcal)';

  @override
  String get enterWeight => 'Registrar peso';

  @override
  String get requiredField => 'Obligatorio';

  @override
  String get invalidNumber => 'Número no válido';

  @override
  String get previousWeight => 'Peso anterior';

  @override
  String get imageLabel => 'Imagen';

  @override
  String get longPressToDelete => 'Mantén pulsado para eliminar';

  @override
  String get imageError => 'Error de imagen';

  @override
  String get actionSave => 'Guardar';

  @override
  String get aboutTitle => 'Acerca de';

  @override
  String get donate => 'Donar';

  @override
  String get helpSupportProject => 'Ayuda a apoyar este proyecto';

  @override
  String get whatsNewAbout => '¿Qué hay de nuevo?';

  @override
  String get whatsNewTitle => '¿Qué hay de nuevo?';

  @override
  String get seeReleaseNotes => 'Ver las notas de la versión';

  @override
  String get versionLabel => 'Versión';

  @override
  String get authorLabel => 'Autor';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get privacyPolicyDescription => 'Cómo gestiona Flexify tus datos';

  @override
  String get licenseLabel => 'Licencia';

  @override
  String get sourceCode => 'Código fuente';

  @override
  String get sourceCodeDescription => 'Ver en GitHub';

  @override
  String get leaveReview => 'Dejar una reseña';

  @override
  String get leaveReviewDescription => 'Valora Flexify en Play Store';

  @override
  String get reportBug => 'Informar de un error';

  @override
  String get reportBugDescription => 'Abrir una incidencia en GitHub';

  @override
  String get failedMigrations => 'Migraciones fallidas';

  @override
  String get errorMessageLabel => 'Mensaje de error:';

  @override
  String get createIssue => 'Crear incidencia';

  @override
  String get addExercise => 'Añadir ejercicio';

  @override
  String get cardio => 'Cardio';

  @override
  String get strength => 'Fuerza';

  @override
  String get options => 'Opciones';

  @override
  String get periodDay => 'Día';

  @override
  String get periodWeek => 'Semana';

  @override
  String get periodMonth => 'Mes';

  @override
  String get periodYear => 'Año';

  @override
  String noDataFor(String name) {
    return 'Aún no hay datos de $name';
  }

  @override
  String get noDataYet => 'Aún no hay datos';

  @override
  String get exerciseNotes => 'Notas del ejercicio';

  @override
  String get notesForExercise => 'Notas para este ejercicio';

  @override
  String get useTimeBasedXAxis => 'Usar eje X basado en el tiempo';

  @override
  String updateAllNamed(String name) {
    return 'Actualizar todos los $name';
  }

  @override
  String get newName => 'Nombre nuevo';

  @override
  String get restMinutes => 'Minutos de descanso';

  @override
  String get restSeconds => 'Segundos de descanso';

  @override
  String get globalProgress => 'Progreso global';

  @override
  String get curveLineGraphs => 'Curvar líneas de los gráficos';

  @override
  String get curveLineGraphsDescription =>
      'Dibujar las líneas de los gráficos como curvas suaves';

  @override
  String noHistoryFor(String name) {
    return 'Aún no hay historial de $name';
  }

  @override
  String get cancelSelection => 'Cancelar selección';

  @override
  String get editSelected => 'Editar seleccionados';

  @override
  String get noGraphsFound => 'No se encontraron gráficos';

  @override
  String get searchGraphs => 'Buscar gráficos...';

  @override
  String get actionAdd => 'Añadir';

  @override
  String get actionUpdate => 'Actualizar';

  @override
  String get hideGlobalProgress => 'Ocultar progreso global';

  @override
  String get chartGroupedByCategory => 'Gráfico agrupado por categoría';

  @override
  String get noExercisesFound => 'No se encontraron ejercicios';

  @override
  String get savePlan => 'Guardar plan';

  @override
  String get titleOptional => 'Título (opcional)';

  @override
  String get searchExercises => 'Buscar ejercicios...';

  @override
  String get warmupSets => 'Series de calentamiento';

  @override
  String get workingSetsMax => 'Series efectivas (máx.: 20)';

  @override
  String get actionUndo => 'Deshacer';

  @override
  String get actionSwap => 'Cambiar';

  @override
  String get daily => 'Diario';

  @override
  String get weekly => 'Semanal';

  @override
  String get monthly => 'Mensual';

  @override
  String get yearly => 'Anual';

  @override
  String get unexpectedError => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get loadingExercises => 'Cargando ejercicios...';

  @override
  String get noPlansYet => 'Aún no hay planes';

  @override
  String get noMatchingPlans => 'No hay planes coincidentes';

  @override
  String get newPlan => 'Plan nuevo';

  @override
  String get searchPlans => 'Buscar planes...';

  @override
  String get noExercisesYet => 'Aún no hay ejercicios';

  @override
  String get editPlan => 'Editar plan';

  @override
  String get saveSet => 'Guardar serie';

  @override
  String get minutesLabel => 'Minutos';

  @override
  String get minutesShort => 'min';

  @override
  String get secondsLabel => 'Segundos';

  @override
  String get distanceLabel => 'Distancia';

  @override
  String get inclinePercent => 'Inclinación %';

  @override
  String weightWithUnit(String unit) {
    return 'Peso ($unit)';
  }

  @override
  String get useBodyWeight => 'Usar peso corporal';

  @override
  String get noWeightEnteredYet => 'Aún no se ha registrado ningún peso';

  @override
  String get notesLabel => 'Notas';

  @override
  String get swapWorkout => 'Cambiar entrenamiento';

  @override
  String get addSet => 'Añadir serie';

  @override
  String get deleteSet => 'Eliminar serie';

  @override
  String get oneRepMaxEstimate => 'Máximo de una repetición (estimado)';

  @override
  String get valueLabel => 'Valor';

  @override
  String amountWithUnit(String unit) {
    return 'Cantidad ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return 'Distancia ($unit)';
  }

  @override
  String get bodyWeightLabel => 'Peso corporal';

  @override
  String bodyWeightWithUnit(String unit) {
    return 'Peso corporal ($unit)';
  }

  @override
  String get categoryHelper =>
      'Elige una categoría existente o escribe una nueva.';

  @override
  String get manageCategories => 'Gestionar categorías';

  @override
  String get manageCategoriesDescription =>
      'Crea, cambia el nombre, combina o elimina categorías';

  @override
  String get newCategory => 'Nueva categoría';

  @override
  String get renameCategory => 'Renombrar categoría';

  @override
  String get mergeCategory => 'Combinar con otra categoría';

  @override
  String get noCategories => 'Aún no hay categorías';

  @override
  String get categoryNameRequired => 'Introduce un nombre de categoría';

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¿Eliminar esta categoría y quitarla de $count entradas?',
      one: '¿Eliminar esta categoría y quitarla de 1 entrada?',
      zero: '¿Eliminar esta categoría?',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => 'Fecha de creación';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Editar $count series',
      one: 'Editar 1 serie',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => 'Aún no hay entradas';

  @override
  String get historyEmptyMessage =>
      'Completa una serie o añádela manualmente para empezar tu historial.';

  @override
  String deleteSetConfirmation(String name) {
    return '¿Seguro que quieres eliminar $name?';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¿Seguro que quieres eliminar $count entradas?',
      one: '¿Seguro que quieres eliminar 1 entrada?',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => 'Buscar en el historial...';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeLight => 'Claro';

  @override
  String get pureBlackAmoled => 'Negro puro (AMOLED)';

  @override
  String get showImages => 'Mostrar imágenes';

  @override
  String get peekGraph => 'Vista previa del gráfico';

  @override
  String get inputStyleLine => 'Línea';

  @override
  String get inputStyleOutlined => 'Contorno';

  @override
  String get inputStyleFilled => 'Relleno';

  @override
  String get inputStyle => 'Estilo de entrada';

  @override
  String get appearance => 'Apariencia';

  @override
  String get automaticBackupsEnabled =>
      'Copias de seguridad automáticas activadas';

  @override
  String get automaticBackup => 'Copia de seguridad automática';

  @override
  String get appPermissions => 'Permisos de la aplicación';

  @override
  String get shareDatabase => 'Compartir base de datos';

  @override
  String get dataManagement => 'Gestión de datos';

  @override
  String get strengthUnit => 'Unidad de peso';

  @override
  String get lastEntry => 'Última entrada';

  @override
  String get cardioUnit => 'Unidad de cardio';

  @override
  String longDateFormat(String format) {
    return 'Formato de fecha largo ($format)';
  }

  @override
  String get formats => 'Formatos';

  @override
  String get setsPerExerciseMax => 'Series por ejercicio (máx.: 20)';

  @override
  String get countLabel => 'Cantidad';

  @override
  String get ratioLabel => 'Proporción';

  @override
  String get reorder => 'Reordenar';

  @override
  String get none => 'Ninguno';

  @override
  String get monday => 'Lunes';

  @override
  String get examplePlanExercises => 'Press de banca, Sentadilla, Peso muerto';

  @override
  String get tabs => 'Pestañas';

  @override
  String get swipeBetweenTabs => 'Deslizar entre pestañas';

  @override
  String get vibrate => 'Vibrar';

  @override
  String get enableSound => 'Activar sonido';

  @override
  String get keepScreenOn => 'Mantener pantalla encendida';

  @override
  String get alarmSound => 'Sonido de alarma';

  @override
  String get top => 'Arriba';

  @override
  String get bottom => 'Abajo';

  @override
  String get removeCustomTimer =>
      'Quitar temporizador personalizado (usar valor global predeterminado)';

  @override
  String get timers => 'Temporizadores';

  @override
  String get timerSettings => 'Ajustes del temporizador';

  @override
  String get groupHistory => 'Agrupar historial';

  @override
  String get showUnits => 'Mostrar unidades';

  @override
  String get showBodyWeight => 'Mostrar peso corporal';

  @override
  String get showNotes => 'Mostrar notas';

  @override
  String get repEstimation => 'Estimación de repeticiones';

  @override
  String get durationEstimation => 'Estimación de duración';

  @override
  String get showGraphLimit => 'Mostrar límite del gráfico';

  @override
  String get defaultGraphMetric => 'Métrica predeterminada del gráfico';

  @override
  String get bestWeight => 'Mejor peso';

  @override
  String get bestReps => 'Mejores repeticiones';

  @override
  String get oneRepMax => 'Máximo de una repetición';

  @override
  String get volume => 'Volumen';

  @override
  String get paceCardio => 'Ritmo (cardio)';

  @override
  String get distanceCardio => 'Distancia (cardio)';

  @override
  String get defaultGraphPeriod => 'Periodo predeterminado del gráfico';

  @override
  String get defaultGraphLimit => 'Límite predeterminado del gráfico';

  @override
  String get workouts => 'Entrenamientos';

  @override
  String get actionStop => 'Detener';

  @override
  String get timerFinishedToast => '¡Temporizador terminado!';

  @override
  String get stopTimer => 'Detener temporizador';

  @override
  String get actionPause => 'Pausar';

  @override
  String get startStopwatch => 'Iniciar cronómetro';

  @override
  String get actionStart => 'Iniciar';

  @override
  String get actionRestart => 'Reiniciar';

  @override
  String get addOneMinute => '+1 minuto';

  @override
  String get addOneMinuteNotification => 'Añadir 1 min';

  @override
  String get restTimer => 'Temporizador de descanso';

  @override
  String get timerUp => 'Tiempo agotado';

  @override
  String get openNotification => 'Abrir notificación';

  @override
  String get timerChannelName => 'Canal del temporizador';

  @override
  String get timerChannelDescription =>
      'Progreso continuo de los temporizadores de descanso.';

  @override
  String get timerFinishedChannelName => 'Canal de temporizador terminado';

  @override
  String get timerFinishedChannelDescription =>
      'Reproduce una alarma cuando termina un temporizador de descanso.';

  @override
  String get timerFinished => 'Temporizador terminado';

  @override
  String get batteryOptimizationRequestUnavailable =>
      'Las solicitudes para ignorar las optimizaciones de batería están desactivadas en tu dispositivo.';

  @override
  String get exactAlarmRequestUnavailable =>
      'La solicitud de SCHEDULE_EXACT_ALARM fue rechazada en tu dispositivo';

  @override
  String get databaseMigrationFailureDescription =>
      'Se produjo un error al crear o actualizar tu base de datos. Normalmente se puede solucionar eliminando y volviendo a crear tus registros.';

  @override
  String get curveSmoothness => 'Suavidad de la curva';

  @override
  String get actionBack => 'Atrás';

  @override
  String get atLeastOneTab => 'Necesitas al menos una pestaña';

  @override
  String get invalidTabSettings => 'Ajustes de pestañas no válidos.';

  @override
  String get noSettingsFound => 'No se encontraron ajustes';

  @override
  String nothingMatchesSearch(String query) {
    return 'Nada coincide con “$query”.';
  }

  @override
  String get appearanceDescription => 'Tema, colores y estilo de la interfaz';

  @override
  String get dataManagementDescription =>
      'Importa, exporta y gestiona tus datos de entrenamiento';

  @override
  String get formatsDescription => 'Fechas, números y formato de medidas';

  @override
  String get plansSettingsDescription =>
      'Valores predeterminados y comportamiento de los planes de entrenamiento';

  @override
  String get tabsDescription =>
      'Elige y ordena las pestañas de navegación principales';

  @override
  String get timersDescription =>
      'Duración, sonido y comportamiento del temporizador de descanso';

  @override
  String get workoutsDescription =>
      'Seguimiento de ejercicios y preferencias de entrenamiento';

  @override
  String get completeSetForChart =>
      'Completa una serie de este ejercicio para crear su gráfico.';

  @override
  String get dateRange => 'Intervalo de fechas';

  @override
  String get stopDate => 'Fecha de fin';

  @override
  String get dataPoints => 'Puntos de datos';

  @override
  String get completeSetsForProgress =>
      'Completa algunas series para crear tu gráfico de progreso.';

  @override
  String get relativeStrength => 'Fuerza relativa';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seleccionados',
      one: '1 seleccionado',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory =>
      'Completa algunas series para ver aquí el historial de este ejercicio.';

  @override
  String nothingMatchesGraphSearch(String query) {
    return 'Nada coincide con “$query”. Puedes crearlo como ejercicio nuevo.';
  }

  @override
  String addNamed(String name) {
    return 'Añadir “$name”';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return 'Esto eliminará $count registros. ¿Seguro?';
  }

  @override
  String shareWorkout(String summary) {
    return 'Acabo de hacer $summary';
  }

  @override
  String get updateConflict => 'Conflicto de actualización';

  @override
  String updateConflictDescription(int count) {
    return 'El nombre nuevo ya existe en $count registros. ¿Seguro?';
  }

  @override
  String get unitsConflict => 'Conflicto de unidades';

  @override
  String unitsConflictDescription(String unit) {
    return 'No todos tus registros tienen la misma unidad. Esto convertirá todas las unidades a $unit. ¿Seguro?';
  }

  @override
  String get durationLabel => 'Duración';

  @override
  String get inclineLabel => 'Inclinación';

  @override
  String get paceDistanceTime => 'Ritmo (distancia / tiempo)';

  @override
  String get adjustedPace => 'Ritmo ajustado';

  @override
  String get oneRepMaxAccuracyWarning =>
      'Las estimaciones del máximo de una repetición son menos precisas en series de 10 o más repeticiones';

  @override
  String get addPlan => 'Añadir plan';

  @override
  String get planDetails => 'Detalles del plan';

  @override
  String get exercisesLabel => 'Ejercicios';

  @override
  String get addExerciseToPlan => 'Añade un ejercicio a este plan.';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return 'Nada coincide con “$query”. Puedes añadirlo como ejercicio nuevo.';
  }

  @override
  String get selectDays => 'Selecciona los días';

  @override
  String get selectExercises => 'Selecciona los ejercicios';

  @override
  String get todayLabel => 'Hoy';

  @override
  String get setDetails => 'Detalles de la serie';

  @override
  String get themeLabel => 'Tema';

  @override
  String get pureBlackAmoledDescription =>
      'Usar negro puro en pantallas AMOLED';

  @override
  String get systemColorScheme => 'Esquema de colores del sistema';

  @override
  String get systemColorSchemeDescription =>
      'Usar el color principal de tu dispositivo en la aplicación';

  @override
  String get showImagesDescription =>
      'Elegir y mostrar imágenes en la página de historial';

  @override
  String get showGlobalProgress => 'Mostrar progreso global';

  @override
  String get showGlobalProgressDescription =>
      'Añadir un gráfico que muestre tu progreso por categoría';

  @override
  String get peekGraphDescription =>
      'Mostrar el primer gráfico de líneas en la página de gráficos';

  @override
  String get inputStyleDescription => 'Estilo visual de los campos de texto';

  @override
  String get automaticBackupNotificationBody =>
      'Flexify hará automáticamente una copia de seguridad de tus datos e imágenes en la carpeta seleccionada cada día.';

  @override
  String get backupSettingsChannel => 'Ajustes de copia de seguridad';

  @override
  String get backupSettingsChannelDescription =>
      'Notificaciones que explican las copias de seguridad automáticas';

  @override
  String get backupChannelName => 'Canal de copias de seguridad';

  @override
  String get backupChannelDescription =>
      'Copias de seguridad automáticas de los datos e imágenes de Flexify';

  @override
  String get backupCompletedTitle => 'Datos e imágenes guardados';

  @override
  String get backupFailurePathNotSet =>
      'Error de copia de seguridad: no se ha definido una ruta. Se desactivaron las copias de seguridad automáticas.';

  @override
  String get backupFailureDirectoryUnavailable =>
      'Error de copia de seguridad: no se pudo acceder al directorio. Se desactivaron las copias de seguridad automáticas.';

  @override
  String get backupFailureCreateFile =>
      'Error de copia de seguridad: no se pudo crear el archivo de copia de seguridad. Se desactivaron las copias de seguridad automáticas.';

  @override
  String get backupFailureAppFilesUnavailable =>
      'Error de copia de seguridad: no se pudo acceder al directorio de archivos de la aplicación. Se desactivaron las copias de seguridad automáticas.';

  @override
  String get backupFailureDatabaseMissing =>
      'Error de copia de seguridad: no se encontró el archivo de la base de datos. Se desactivaron las copias de seguridad automáticas.';

  @override
  String get backupFailureOutputUnavailable =>
      'Error de copia de seguridad: no se pudo abrir el flujo de salida. Se desactivaron las copias de seguridad automáticas.';

  @override
  String get backupFailureUnknown =>
      'Error de copia de seguridad. Se desactivaron las copias de seguridad automáticas.';

  @override
  String get appPermissionsDescription =>
      'Revisa los accesos necesarios para las funciones que tienes activadas';

  @override
  String get longDateFormatDescription =>
      'Se usa cuando hay espacio suficiente';

  @override
  String shortDateFormat(String example) {
    return 'Formato de fecha corto ($example)';
  }

  @override
  String get shortDateFormatDescription =>
      'Para lugares con poco espacio (líneas de gráficos)';

  @override
  String get warmupSetsDescription =>
      'Las series de calentamiento no tienen temporizadores de descanso';

  @override
  String get setsPerExerciseDescription =>
      'Número predeterminado de series por ejercicio en un plan';

  @override
  String get planTrailingDisplay => 'Información al final del plan';

  @override
  String get planTrailingDisplayDescription =>
      'Contenido mostrado a la derecha de la lista en Planes y en la vista del plan';

  @override
  String get restTimersDescription =>
      'Alarma que suena después de completar una serie';

  @override
  String get vibrateDescription =>
      'Indica si los temporizadores de descanso deben vibrar';

  @override
  String get enableSoundDescription =>
      'Indica si los temporizadores de descanso deben reproducir un sonido';

  @override
  String get keepScreenOnDescription =>
      'Mantener la pantalla encendida durante los temporizadores de descanso';

  @override
  String get restDurationDescription =>
      'Tiempo que transcurre antes de que suene la alarma de descanso';

  @override
  String get globalDefault => 'Valor global predeterminado';

  @override
  String get alarmSoundDescription =>
      'Sonido que se reproduce al terminar un temporizador de descanso';

  @override
  String get progressBarPosition => 'Posición de la barra de progreso';

  @override
  String get progressBarPositionDescription =>
      'Dónde se muestra la barra de progreso del temporizador de descanso';

  @override
  String get perExerciseRestTimes => 'Descanso por ejercicio';

  @override
  String get perExerciseRestTimesDescription =>
      'Estos ejercicios tienen duraciones de descanso personalizadas';

  @override
  String get audioFeaturesUnavailable =>
      'Las funciones de audio no están disponibles';

  @override
  String get groupHistoryDescription =>
      'Combinar las entradas del historial por día';

  @override
  String get showUnitsDescription =>
      'Mostrar km/mi y kg/lb en gráficos, historial y planes';

  @override
  String get showBodyWeightDescription =>
      'Activar o desactivar el seguimiento del peso corporal';

  @override
  String get showNotesDescription =>
      'Registrar detalles del levantamiento en un campo de texto';

  @override
  String get positiveNotificationsDescription =>
      'Mostrar mensajes de ánimo al conseguir un nuevo récord';

  @override
  String get positiveMessagesEnabled =>
      '¡Los mensajes de ánimo aparecerán así!';

  @override
  String get recordEncouragement01 => '¡Buen trabajo! Eres increíble.';

  @override
  String get recordEncouragement02 => '¡Muy bien! Tu progreso es inspirador.';

  @override
  String get recordEncouragement03 => 'Me inclino ante ti...';

  @override
  String get recordEncouragement04 => '¿Qué es eso? ¡Un nuevo récord!';

  @override
  String get recordEncouragement05 => '¡Increíble! Eres toda una inspiración.';

  @override
  String get recordEncouragement06 => 'Guau. Muy bien.';

  @override
  String get recordEncouragement07 => '¿Cada vez más fuerte, eh?';

  @override
  String get recordEncouragement08 => 'Sí. Estás hecho una bestia.';

  @override
  String get recordEncouragement09 => 'Increíble. Impresionante.';

  @override
  String get recordEncouragement10 => 'Arnie estaría orgulloso.';

  @override
  String get recordEncouragement11 => 'Ronnie C te mira encantado.';

  @override
  String get recordEncouragement12 => '¡SÍ! ¡¡PESO PLUMA, NENEEEEEE!!';

  @override
  String get recordEncouragement13 =>
      '¿Eso es un nuevo récord? Sabía que podías hacerlo.';

  @override
  String get recordEncouragement14 => '¡Buen trabajo! Estoy orgulloso de ti.';

  @override
  String get recordEncouragement15 => '¡Sí, vamos! ¡Peso ligero!';

  @override
  String get recordEncouragement16 => '¡Sigue así! Gran progreso.';

  @override
  String get recordEncouragement17 => 'Lo estás haciendo genial.';

  @override
  String get recordEncouragement18 => '¡Ese es mi campeón!';

  @override
  String get recordEncouragement19 => 'Sigue así.';

  @override
  String get recordEncouragement20 => 'Te estás poniendo muy fuerte.';

  @override
  String get recordEncouragement21 => 'Potente.';

  @override
  String get recordEncouragement22 => '¡Qué potencia!';

  @override
  String get recordEncouragement23 => 'Estoy orgulloso de ti.';

  @override
  String get recordEncouragement24 => 'Sigue con ese gran trabajo.';

  @override
  String get recordEncouragement25 =>
      '¡Saca pecho! Acabas de batir un nuevo récord.';

  @override
  String get recordEncouragement26 =>
      '¡Nuevo récord! ¡Acabas de llegar más lejos que nunca!';

  @override
  String get recordEncouragement27 => '¡Sí! Eso es un récord.';

  @override
  String get recordEncouragement28 => '¡Guau! ¡Nuevo récord!';

  @override
  String get recordEncouragement29 => 'Muy buen trabajo.';

  @override
  String get repEstimationDescription =>
      'Intentar predecir cuántas repeticiones acabas de hacer';

  @override
  String get durationEstimationDescription =>
      'Intentar predecir la duración de tu cardio';

  @override
  String get showGraphXAxisToggle => 'Mostrar selector del eje X del gráfico';

  @override
  String get showGraphXAxisToggleDescription =>
      'Mostrar en los gráficos el selector de eje X basado en el tiempo';

  @override
  String get showGraphLimitDescription =>
      'Mostrar el control deslizante de límite en los gráficos';

  @override
  String get defaultTimeBasedXAxis =>
      'Eje X basado en el tiempo de forma predeterminada';

  @override
  String get defaultTimeBasedXAxisDescription =>
      'Usar de forma predeterminada un eje X basado en el tiempo en los gráficos';

  @override
  String get createFirstTrainingPlan =>
      'Crea tu primer plan de entrenamiento para empezar.';

  @override
  String nothingMatchesPlanSearch(String query) {
    return 'Nada coincide con “$query”. Puedes crearlo como un plan nuevo.';
  }

  @override
  String get createPlan => 'Crear plan';

  @override
  String createNamedPlan(String name) {
    return 'Crear “$name”';
  }

  @override
  String setNumber(int number) {
    return 'Serie $number';
  }

  @override
  String get navCategories => 'Categorías';

  @override
  String get uncategorized => 'Sin categoría';

  @override
  String exerciseInCategory(String exercise, String category) {
    return '$exercise · $category';
  }

  @override
  String exerciseExistsInCategory(String exercise, String category) {
    return '$exercise ya existe en $category';
  }

  @override
  String get actionOpen => 'Abrir';

  @override
  String get chooseCategory => 'Elige una categoría';

  @override
  String get copyFromOtherCategory =>
      '¿Ya está en otra categoría? Selecciónalo para copiar sus datos.';

  @override
  String categoryExerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ejercicios',
      one: '1 ejercicio',
      zero: 'Sin ejercicios',
    );
    return '$_temp0';
  }

  @override
  String noExercisesInCategory(String category) {
    return 'Aún no hay ejercicios en $category';
  }

  @override
  String get addExerciseToCategory =>
      'Añade un ejercicio para empezar a registrarlo en esta categoría.';

  @override
  String get addExercisesFromCategories =>
      'Registra una serie o añade ejercicios desde la pestaña Categorías.';

  @override
  String categoryAndDate(String category, String date) {
    return '$category · $date';
  }
}
