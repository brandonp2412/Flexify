// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageDescription =>
      'Escolha o idioma utilizado pelo Flexify';

  @override
  String get languageSystemDefault => 'Predefinição do sistema';

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
  String get languageNamePortuguesePortugal => 'Português (Portugal)';

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
  String get navHistory => 'Histórico';

  @override
  String get navPlans => 'Planos';

  @override
  String get navGraphs => 'Gráficos';

  @override
  String get navTimer => 'Temporizador';

  @override
  String get navSettings => 'Definições';

  @override
  String get navCategories => 'Categorias';

  @override
  String get exerciseAlreadyExists => 'Este exercício já existe';

  @override
  String get errorLabel => 'Erro';

  @override
  String get tabContentError =>
      'Não foi possível apresentar o conteúdo do separador.';

  @override
  String get cannotHideAllTabs =>
      'Não é possível ocultar todos os separadores!';

  @override
  String removeTabQuestion(String tab) {
    return 'Remover o separador $tab?';
  }

  @override
  String get restoreTabFromSettings =>
      'Pode adicioná-lo novamente mais tarde nas definições.';

  @override
  String removedTab(String tab) {
    return '$tab removido';
  }

  @override
  String newVersion(String version) {
    return 'Nova versão $version';
  }

  @override
  String get changes => 'Novidades';

  @override
  String get searchHint => 'Pesquisar...';

  @override
  String get deleteSelected => 'Eliminar selecionados';

  @override
  String get confirmDelete => 'Confirmar eliminação';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Tem a certeza de que pretende eliminar $count registos? Esta ação não pode ser desfeita.',
      one:
          'Tem a certeza de que pretende eliminar 1 registo? Esta ação não pode ser desfeita.',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionDiscard => 'Descartar';

  @override
  String get unsavedChanges => 'Alterações não guardadas';

  @override
  String get discardUnsavedChanges => 'Descartar as alterações não guardadas?';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get actionRemove => 'Remover';

  @override
  String get actionEdit => 'Editar';

  @override
  String get actionShare => 'Partilhar';

  @override
  String get clearSelection => 'Limpar seleção';

  @override
  String get clearSearch => 'Limpar pesquisa';

  @override
  String get showMenu => 'Mostrar menu';

  @override
  String get selectAll => 'Selecionar tudo';

  @override
  String get weightLabel => 'Peso';

  @override
  String get filter => 'Filtro';

  @override
  String get filters => 'Filtros';

  @override
  String get categoryLabel => 'Categoria';

  @override
  String get repsLabel => 'Repetições';

  @override
  String get repsFilter => 'Filtro de repetições';

  @override
  String get weightFilter => 'Filtro de peso';

  @override
  String get greaterThan => 'Maior que';

  @override
  String get lessThan => 'Menor que';

  @override
  String get startDate => 'Data inicial';

  @override
  String get endDate => 'Data final';

  @override
  String get actionClear => 'Limpar';

  @override
  String get actionOk => 'OK';

  @override
  String get actionClose => 'Fechar';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get dateNewest => 'Data (mais recente)';

  @override
  String get dateOldest => 'Data (mais antiga)';

  @override
  String get nameLabel => 'Nome';

  @override
  String get missingPermissions => 'Permissões ausentes';

  @override
  String get restTimersPermissionsMissing =>
      'Os temporizadores de descanso estão ativados, mas faltam permissões.';

  @override
  String get restTimersPermissionsOptional =>
      'Se desativar os temporizadores de descanso, estas permissões não serão necessárias.';

  @override
  String get restTimers => 'Temporizadores de descanso';

  @override
  String get disableBatteryOptimizations => 'Desativar otimizações da bateria';

  @override
  String get batteryOptimizationWarning =>
      'O progresso pode ficar em pausa se as otimizações da bateria permanecerem ativadas.';

  @override
  String get scheduleExactAlarm => 'Agendar alarme exato';

  @override
  String get exactAlarmWarning =>
      'Os alarmes não podem ser precisos se esta opção estiver desativada.';

  @override
  String get postNotifications => 'Mostrar notificações';

  @override
  String get notificationBarDescription =>
      'O progresso do temporizador é apresentado na barra de notificações';

  @override
  String get invalidPermissions => 'Permissões inválidas';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      'Os temporizadores de descanso estão ativados sem permissões suficientes. Pretende continuar?';

  @override
  String get actionConfirm => 'Confirmar';

  @override
  String get appAccess => 'Acesso à aplicação';

  @override
  String get appAccessDescription =>
      'Necessário para temporizadores e notificações ativados.';

  @override
  String get notifications => 'Notificações';

  @override
  String get timerProgressAndRestAlerts =>
      'Progresso do temporizador e alertas de descanso';

  @override
  String get enabledNotificationsDescription => 'Notificações que ativou';

  @override
  String get backgroundActivity => 'Atividade em segundo plano';

  @override
  String get backgroundActivityDescription =>
      'Manter os temporizadores fiáveis em segundo plano';

  @override
  String get exactAlarms => 'Alarmes exatos';

  @override
  String get exactAlarmsDescription =>
      'Avisar exatamente quando um temporizador de descanso terminar';

  @override
  String get noAdditionalAndroidAccessNeeded =>
      'Não é necessário acesso adicional do Android com as definições atuais.';

  @override
  String get actionDone => 'Concluído';

  @override
  String get allowed => 'Permitido';

  @override
  String get actionAllow => 'Permitir';

  @override
  String get backupLabel => 'Cópia de segurança';

  @override
  String get databaseLabel => 'Base de dados';

  @override
  String get deleteRecords => 'Eliminar registos';

  @override
  String get deleteAllGraphsConfirmation =>
      'Tem a certeza de que pretende eliminar todos os gráficos? Esta ação não pode ser desfeita.';

  @override
  String get deleteAllPlansConfirmation =>
      'Tem a certeza de que pretende eliminar todos os planos? Esta ação não pode ser desfeita.';

  @override
  String get deleteDatabaseConfirmation =>
      'Tem a certeza de que pretende eliminar a sua base de dados? Esta ação não pode ser desfeita e apagará todos os seus dados.';

  @override
  String get importData => 'Importar dados';

  @override
  String get exportData => 'Exportar dados';

  @override
  String get actionReport => 'Comunicar';

  @override
  String get graphDataImported => 'Dados dos gráficos importados com êxito!';

  @override
  String get plansImported => 'Planos importados com êxito';

  @override
  String failedToImportDatabase(String error) {
    return 'Não foi possível importar a base de dados: $error';
  }

  @override
  String get backupArchiveMissingDatabase =>
      'A cópia de segurança não contém a base de dados do Flexify.';

  @override
  String failedToImportGraphs(String error) {
    return 'Não foi possível importar os gráficos: $error';
  }

  @override
  String failedToImportPlans(String error) {
    return 'Não foi possível importar os planos: $error';
  }

  @override
  String get selectedFileDoesNotExist => 'O ficheiro selecionado não existe';

  @override
  String get couldNotReadFileData =>
      'Não foi possível ler os dados do ficheiro';

  @override
  String get databaseImportWebUnsupported =>
      'A importação da base de dados na Web exige a migração manual dos dados. Exporte os seus dados como ficheiros CSV e importe-os em vez da base de dados.';

  @override
  String get csvFileEmpty => 'O ficheiro CSV está vazio';

  @override
  String get csvNeedsDataRow =>
      'O ficheiro CSV deve conter pelo menos uma linha de dados';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return 'A linha $row não tem colunas suficientes: $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return 'Valor de $field inválido na linha $row: $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return 'Tipo de dado de $field inválido na linha $row: $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return 'Era esperado um ID de plano inteiro, mas foi recebido \"$value\"';
  }

  @override
  String get unitLabel => 'Unidade';

  @override
  String get kilogramsUnit => 'Quilogramas (kg)';

  @override
  String get poundsUnit => 'Libras (lb)';

  @override
  String get stoneUnit => 'Stone';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => 'Quilómetros (km)';

  @override
  String get milesUnit => 'Milhas (mi)';

  @override
  String get metersUnit => 'Metros (m)';

  @override
  String get kilocaloriesUnit => 'Quilocalorias (kcal)';

  @override
  String get enterWeight => 'Introduzir peso';

  @override
  String get requiredField => 'Obrigatório';

  @override
  String get invalidNumber => 'Número inválido';

  @override
  String get previousWeight => 'Peso anterior';

  @override
  String get imageLabel => 'Imagem';

  @override
  String get longPressToDelete => 'Prima continuamente para eliminar';

  @override
  String get imageError => 'Erro na imagem';

  @override
  String get actionSave => 'Guardar';

  @override
  String get aboutTitle => 'Sobre';

  @override
  String get donate => 'Doar';

  @override
  String get helpSupportProject => 'Ajude a apoiar este projeto';

  @override
  String get whatsNewAbout => 'O que há de novo?';

  @override
  String get whatsNewTitle => 'O que há de novo?';

  @override
  String get seeReleaseNotes => 'Consulte as notas de versão';

  @override
  String get versionLabel => 'Versão';

  @override
  String get authorLabel => 'Autor';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get privacyPolicyDescription => 'Como o Flexify trata os seus dados';

  @override
  String get licenseLabel => 'Licença';

  @override
  String get sourceCode => 'Código-fonte';

  @override
  String get sourceCodeDescription => 'Consulte no GitHub';

  @override
  String get leaveReview => 'Deixar uma avaliação';

  @override
  String get leaveReviewDescription => 'Avalie o Flexify na Play Store';

  @override
  String get reportBug => 'Comunicar um erro';

  @override
  String get reportBugDescription => 'Abra um problema no GitHub';

  @override
  String get failedMigrations => 'Migrações com falha';

  @override
  String get errorMessageLabel => 'Mensagem de erro:';

  @override
  String get createIssue => 'Criar problema';

  @override
  String get addExercise => 'Adicionar exercício';

  @override
  String get cardio => 'Cardio';

  @override
  String get strength => 'Força';

  @override
  String get options => 'Opções';

  @override
  String get periodDay => 'Dia';

  @override
  String get periodWeek => 'Semana';

  @override
  String get periodMonth => 'Mês';

  @override
  String get periodYear => 'Ano';

  @override
  String noDataFor(String name) {
    return 'Ainda não há dados para $name';
  }

  @override
  String get noDataYet => 'Ainda não há dados';

  @override
  String get exerciseNotes => 'Notas do exercício';

  @override
  String get notesForExercise => 'Notas para este exercício';

  @override
  String get useTimeBasedXAxis => 'Usar eixo X baseado em tempo';

  @override
  String updateAllNamed(String name) {
    return 'Atualizar todos os registos de $name';
  }

  @override
  String get newName => 'Novo nome';

  @override
  String get restMinutes => 'Minutos de descanso';

  @override
  String get restSeconds => 'Segundos de descanso';

  @override
  String get globalProgress => 'Progresso global';

  @override
  String get curveLineGraphs => 'Linhas curvas nos gráficos';

  @override
  String get curveLineGraphsDescription =>
      'Desenhar as linhas dos gráficos como curvas suaves';

  @override
  String noHistoryFor(String name) {
    return 'Ainda não há histórico para $name';
  }

  @override
  String get cancelSelection => 'Cancelar seleção';

  @override
  String get editSelected => 'Editar selecionados';

  @override
  String get newExercise => 'Novo exercício';

  @override
  String get noGraphsFound => 'Nenhum gráfico encontrado';

  @override
  String get searchGraphs => 'Pesquisar gráficos...';

  @override
  String get actionAdd => 'Adicionar';

  @override
  String get actionUpdate => 'Atualizar';

  @override
  String get hideGlobalProgress => 'Ocultar progresso geral';

  @override
  String get chartGroupedByCategory => 'Um gráfico agrupado por categoria';

  @override
  String get noExercisesFound => 'Nenhum exercício encontrado';

  @override
  String get savePlan => 'Guardar plano';

  @override
  String get titleOptional => 'Título (opcional)';

  @override
  String get searchExercises => 'Pesquisar exercícios...';

  @override
  String get warmupSets => 'Séries de aquecimento';

  @override
  String get workingSetsMax => 'Séries de trabalho (máx.: 20)';

  @override
  String get actionUndo => 'Desfazer';

  @override
  String get actionSwap => 'Trocar';

  @override
  String get daily => 'Diário';

  @override
  String get weekly => 'Semanal';

  @override
  String get monthly => 'Mensal';

  @override
  String get yearly => 'Anual';

  @override
  String get unexpectedError => 'Algo deu errado. Tente novamente.';

  @override
  String get loadingExercises => 'A carregar exercícios...';

  @override
  String get noPlansYet => 'Ainda não há planos';

  @override
  String get noMatchingPlans => 'Nenhum plano correspondente';

  @override
  String get newPlan => 'Novo plano';

  @override
  String get searchPlans => 'Pesquisar planos...';

  @override
  String get noExercisesYet => 'Ainda não há exercícios';

  @override
  String get editPlan => 'Editar plano';

  @override
  String get saveSet => 'Guardar série';

  @override
  String get minutesLabel => 'Minutos';

  @override
  String get minutesShort => 'min';

  @override
  String get secondsLabel => 'Segundos';

  @override
  String get distanceLabel => 'Distância';

  @override
  String get inclinePercent => 'Inclinação %';

  @override
  String weightWithUnit(String unit) {
    return 'Peso ($unit)';
  }

  @override
  String get useBodyWeight => 'Usar peso corporal';

  @override
  String get noWeightEnteredYet => 'Ainda não foi introduzido nenhum peso';

  @override
  String get notesLabel => 'Notas';

  @override
  String get swapWorkout => 'Trocar treino';

  @override
  String get addSet => 'Adicionar série';

  @override
  String get deleteSet => 'Eliminar série';

  @override
  String get oneRepMaxEstimate => 'Uma repetição máxima (estimativa)';

  @override
  String get valueLabel => 'Valor';

  @override
  String amountWithUnit(String unit) {
    return 'Quantidade ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return 'Distância ($unit)';
  }

  @override
  String get bodyWeightLabel => 'Peso corporal';

  @override
  String bodyWeightWithUnit(String unit) {
    return 'Peso corporal ($unit)';
  }

  @override
  String get categoryHelper =>
      'Escolha uma categoria existente ou introduza uma nova.';

  @override
  String get manageCategories => 'Gerir categorias';

  @override
  String get manageCategoriesDescription =>
      'Crie, renomeie, combine ou remova categorias';

  @override
  String get newCategory => 'Nova categoria';

  @override
  String get renameCategory => 'Renomear categoria';

  @override
  String get mergeCategory => 'Combinar com outra categoria';

  @override
  String get noCategories => 'Ainda não há categorias';

  @override
  String get categoryNameRequired => 'Introduza um nome para a categoria';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Utilizada por $count registos',
      one: 'Utilizada por 1 registo',
      zero: 'Não utilizada por nenhum registo',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Eliminar esta categoria e removê-la de $count registos?',
      one: 'Eliminar esta categoria e removê-la de 1 registo?',
      zero: 'Eliminar esta categoria?',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => 'Data de criação';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Editar $count séries',
      one: 'Editar 1 série',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => 'Ainda não há registos';

  @override
  String get historyEmptyMessage =>
      'Conclua uma série ou adicione uma manualmente para iniciar o histórico.';

  @override
  String deleteSetConfirmation(String name) {
    return 'Tem a certeza de que pretende eliminar $name?';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tem a certeza de que pretende eliminar $count registos?',
      one: 'Tem a certeza de que pretende eliminar 1 registo?',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => 'Pesquisar histórico...';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeLight => 'Claro';

  @override
  String get pureBlackAmoled => 'Preto puro (AMOLED)';

  @override
  String get showImages => 'Mostrar imagens';

  @override
  String get peekGraph => 'Pré-visualização do gráfico';

  @override
  String get inputStyleLine => 'Linha';

  @override
  String get inputStyleOutlined => 'Com contorno';

  @override
  String get inputStyleFilled => 'Preenchido';

  @override
  String get inputStyle => 'Estilo dos campos';

  @override
  String get appearance => 'Aparência';

  @override
  String get automaticBackupsEnabled =>
      'Cópias de segurança automáticas ativadas';

  @override
  String get automaticBackup => 'Cópia de segurança automática';

  @override
  String get appPermissions => 'Permissões da aplicação';

  @override
  String get shareDatabase => 'Partilhar base de dados';

  @override
  String get dataManagement => 'Gestão de dados';

  @override
  String get strengthUnit => 'Unidade de força';

  @override
  String get lastEntry => 'Último registo';

  @override
  String get cardioUnit => 'Unidade de cardio';

  @override
  String longDateFormat(String format) {
    return 'Formato de data longa ($format)';
  }

  @override
  String get formats => 'Formatos';

  @override
  String get setsPerExerciseMax => 'Séries por exercício (máx.: 20)';

  @override
  String get countLabel => 'Quantidade';

  @override
  String get ratioLabel => 'Proporção';

  @override
  String get reorder => 'Reordenar';

  @override
  String get none => 'Nenhum';

  @override
  String get monday => 'Segunda-feira';

  @override
  String get examplePlanExercises => 'Supino, Agachamento, Levantamento terra';

  @override
  String get tabs => 'Separadores';

  @override
  String get swipeBetweenTabs => 'Deslizar entre separadores';

  @override
  String get vibrate => 'Vibrar';

  @override
  String get enableSound => 'Ativar som';

  @override
  String get keepScreenOn => 'Manter o ecrã ligado';

  @override
  String get alarmSound => 'Som do alarme';

  @override
  String get top => 'Superior';

  @override
  String get bottom => 'Inferior';

  @override
  String get removeCustomTimer =>
      'Remover temporizador personalizado (usar predefinição global)';

  @override
  String get timers => 'Temporizadores';

  @override
  String get timerSettings => 'Definições do temporizador';

  @override
  String get groupHistory => 'Agrupar histórico';

  @override
  String get showUnits => 'Mostrar unidades';

  @override
  String get showBodyWeight => 'Mostrar peso corporal';

  @override
  String get showCategories => 'Mostrar categorias';

  @override
  String get showNotes => 'Mostrar notas';

  @override
  String get repEstimation => 'Estimativa de repetições';

  @override
  String get durationEstimation => 'Estimativa de duração';

  @override
  String get showGraphLimit => 'Mostrar limite do gráfico';

  @override
  String get defaultGraphMetric => 'Métrica predefinida do gráfico';

  @override
  String get bestWeight => 'Maior peso';

  @override
  String get bestReps => 'Maior número de repetições';

  @override
  String get oneRepMax => 'Uma repetição máxima';

  @override
  String get volume => 'Volume';

  @override
  String get paceCardio => 'Ritmo (cardio)';

  @override
  String get distanceCardio => 'Distância (cardio)';

  @override
  String get defaultGraphPeriod => 'Período predefinido do gráfico';

  @override
  String get defaultGraphLimit => 'Limite predefinido do gráfico';

  @override
  String get workouts => 'Treinos';

  @override
  String get actionStop => 'Parar';

  @override
  String get timerFinishedToast => 'Temporizador concluído!';

  @override
  String get stopTimer => 'Parar temporizador';

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
  String get addOneMinuteNotification => 'Adicionar 1 min';

  @override
  String get restTimer => 'Temporizador de descanso';

  @override
  String get timerUp => 'Tempo esgotado';

  @override
  String get openNotification => 'Abrir notificação';

  @override
  String get timerChannelName => 'Canal do temporizador';

  @override
  String get timerChannelDescription =>
      'Progresso contínuo dos temporizadores de descanso.';

  @override
  String get timerFinishedChannelName => 'Canal de temporizador concluído';

  @override
  String get timerFinishedChannelDescription =>
      'Toca um alarme quando um temporizador de descanso termina.';

  @override
  String get timerFinished => 'Temporizador concluído';

  @override
  String get batteryOptimizationRequestUnavailable =>
      'Os pedidos para ignorar otimizações da bateria estão desativados no seu dispositivo.';

  @override
  String get exactAlarmRequestUnavailable =>
      'O pedido SCHEDULE_EXACT_ALARM foi rejeitado no seu dispositivo';

  @override
  String get databaseMigrationFailureDescription =>
      'Algo correu mal ao criar ou atualizar a sua base de dados. Em geral, isto pode ser corrigido eliminando e recriando os seus registos.';

  @override
  String get curveSmoothness => 'Suavidade das curvas';

  @override
  String get actionBack => 'Voltar';

  @override
  String get atLeastOneTab => 'Precisa de pelo menos um separador';

  @override
  String get invalidTabSettings => 'Definições de separadores inválidas.';

  @override
  String get noSettingsFound => 'Nenhuma definição encontrada';

  @override
  String nothingMatchesSearch(String query) {
    return 'Nada corresponde a “$query”.';
  }

  @override
  String get appearanceDescription => 'Tema, cores e estilo da interface';

  @override
  String get dataManagementDescription =>
      'Importe, exporte e faça a gestão dos seus dados de treino';

  @override
  String get formatsDescription => 'Datas, números e formatação de medidas';

  @override
  String get plansSettingsDescription =>
      'Predefinições e comportamento dos planos de treino';

  @override
  String get tabsDescription =>
      'Escolha e organize os separadores principais de navegação';

  @override
  String get timersDescription =>
      'Duração, som e comportamento do temporizador de descanso';

  @override
  String get workoutsDescription =>
      'Preferências de exercícios e acompanhamento de treinos';

  @override
  String get completeSetForChart =>
      'Conclua uma série deste exercício para criar o gráfico.';

  @override
  String get dateRange => 'Intervalo de datas';

  @override
  String get stopDate => 'Data final';

  @override
  String get dataPoints => 'Pontos de dados';

  @override
  String get completeSetsForProgress =>
      'Conclua algumas séries para criar seu gráfico de progresso.';

  @override
  String get relativeStrength => 'Força relativa';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selecionados',
      one: '1 selecionado',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory =>
      'Conclua algumas séries para ver aqui o histórico deste exercício.';

  @override
  String get completeSetForFirstGraph =>
      'Conclua uma série para criar seu primeiro gráfico de exercício.';

  @override
  String nothingMatchesGraphSearch(String query) {
    return 'Nada corresponde a “$query”. Pode criá-lo como um novo exercício.';
  }

  @override
  String addNamed(String name) {
    return 'Adicionar “$name”';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return 'Isto eliminará $count registos. Tem a certeza?';
  }

  @override
  String shareWorkout(String summary) {
    return 'Acabei de fazer $summary';
  }

  @override
  String get updateConflict => 'Conflito de atualização';

  @override
  String updateConflictDescription(int count) {
    return 'O novo nome já existe em $count registos. Pretende continuar?';
  }

  @override
  String get unitsConflict => 'Conflito de unidades';

  @override
  String unitsConflictDescription(String unit) {
    return 'Nem todos os seus registos utilizam a mesma unidade. Isto converterá todas as unidades para $unit. Pretende continuar?';
  }

  @override
  String get durationLabel => 'Duração';

  @override
  String get inclineLabel => 'Inclinação';

  @override
  String get paceDistanceTime => 'Ritmo (distância / tempo)';

  @override
  String get adjustedPace => 'Ritmo ajustado';

  @override
  String get oneRepMaxAccuracyWarning =>
      'As estimativas de uma repetição máxima são menos precisas para séries de 10 ou mais repetições';

  @override
  String get addPlan => 'Adicionar plano';

  @override
  String get planDetails => 'Detalhes do plano';

  @override
  String get exercisesLabel => 'Exercícios';

  @override
  String get addExerciseToPlan => 'Adicione um exercício a este plano.';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return 'Nada corresponde a “$query”. Pode adicioná-lo como um novo exercício.';
  }

  @override
  String get selectDays => 'Selecionar dias';

  @override
  String get selectExercises => 'Selecionar exercícios';

  @override
  String get todayLabel => 'Hoje';

  @override
  String get setDetails => 'Detalhes da série';

  @override
  String get themeLabel => 'Tema';

  @override
  String get pureBlackAmoledDescription =>
      'Usar cores em preto puro para ecrãs AMOLED';

  @override
  String get systemColorScheme => 'Esquema de cores do sistema';

  @override
  String get systemColorSchemeDescription =>
      'Usar a cor principal do seu dispositivo na aplicação';

  @override
  String get showImagesDescription =>
      'Escolher e mostrar imagens na página de histórico';

  @override
  String get showGlobalProgress => 'Mostrar progresso geral';

  @override
  String get showGlobalProgressDescription =>
      'Adicionar ao gráfico uma entrada que mostre o seu progresso por categoria';

  @override
  String get peekGraphDescription =>
      'Mostrar o primeiro gráfico de linhas na página de gráficos';

  @override
  String get inputStyleDescription => 'Estilo visual dos campos de texto';

  @override
  String get automaticBackupNotificationBody =>
      'O Flexify fará uma cópia de segurança automática dos seus dados e imagens na pasta selecionada todos os dias.';

  @override
  String get backupSettingsChannel => 'Definições de cópia de segurança';

  @override
  String get backupSettingsChannelDescription =>
      'Notificações que explicam as cópias de segurança automáticas';

  @override
  String get backupChannelName => 'Canal de cópia de segurança';

  @override
  String get backupChannelDescription =>
      'Cópias de segurança automáticas dos dados e imagens do Flexify';

  @override
  String get backupCompletedTitle =>
      'Cópia de segurança dos dados e imagens concluída';

  @override
  String get backupFailurePathNotSet =>
      'Falha na cópia de segurança: caminho da cópia de segurança não definido. Cópias de segurança automáticas desativadas.';

  @override
  String get backupFailureDirectoryUnavailable =>
      'Falha na cópia de segurança: não foi possível aceder à pasta da cópia de segurança. Cópias de segurança automáticas desativadas.';

  @override
  String get backupFailureCreateFile =>
      'Falha na cópia de segurança: não foi possível criar o ficheiro de cópia de segurança. Cópias de segurança automáticas desativadas.';

  @override
  String get backupFailureAppFilesUnavailable =>
      'Falha na cópia de segurança: não foi possível aceder à pasta de ficheiros da aplicação. Cópias de segurança automáticas desativadas.';

  @override
  String get backupFailureDatabaseMissing =>
      'Falha na cópia de segurança: ficheiro da base de dados não encontrado. Cópias de segurança automáticas desativadas.';

  @override
  String get backupFailureOutputUnavailable =>
      'Falha na cópia de segurança: não foi possível abrir o fluxo de saída. Cópias de segurança automáticas desativadas.';

  @override
  String get backupFailureUnknown =>
      'Falha na cópia de segurança. Cópias de segurança automáticas desativadas.';

  @override
  String get appPermissionsDescription =>
      'Reveja o acesso exigido pelas funcionalidades que ativou';

  @override
  String get longDateFormatDescription => 'Usado onde há bastante espaço';

  @override
  String shortDateFormat(String example) {
    return 'Formato de data curta ($example)';
  }

  @override
  String get shortDateFormatDescription =>
      'Usado onde há pouco espaço (linhas dos gráficos)';

  @override
  String get warmupSetsDescription =>
      'Séries de aquecimento não têm temporizadores de descanso';

  @override
  String get setsPerExerciseDescription =>
      'Número predefinido de séries por exercício';

  @override
  String get planTrailingDisplay => 'Apresentação à direita do plano';

  @override
  String get planTrailingDisplayDescription =>
      'Conteúdo apresentado à direita da lista em Planos e na vista do plano';

  @override
  String get restTimersDescription =>
      'Alarme que dispara após concluir uma série';

  @override
  String get vibrateDescription =>
      'Os temporizadores de descanso devem vibrar?';

  @override
  String get enableSoundDescription =>
      'Os temporizadores de descanso devem reproduzir um som?';

  @override
  String get keepScreenOnDescription =>
      'Manter o ecrã ligado durante os temporizadores de descanso';

  @override
  String get restDurationDescription =>
      'Quanto tempo esperar antes de ativar os alarmes de descanso?';

  @override
  String get globalDefault => 'Padrão geral';

  @override
  String get alarmSoundDescription =>
      'Som reproduzido no final de um temporizador de descanso';

  @override
  String get progressBarPosition => 'Posição da barra de progresso';

  @override
  String get progressBarPositionDescription =>
      'Onde deve ficar a barra de progresso dos temporizadores de descanso?';

  @override
  String get perExerciseRestTimes => 'Tempos de descanso por exercício';

  @override
  String get perExerciseRestTimesDescription =>
      'Estes exercícios têm durações de descanso personalizadas';

  @override
  String get audioFeaturesUnavailable =>
      'Funcionalidades de áudio indisponíveis';

  @override
  String get groupHistoryDescription =>
      'Combinar registos do histórico por dia';

  @override
  String get showUnitsDescription =>
      'Mostrar km/mi e kg/lb em gráficos, histórico e planos';

  @override
  String get showBodyWeightDescription =>
      'Ativar ou desativar o acompanhamento do peso corporal';

  @override
  String get showCategoriesDescription =>
      'Ativar ou desativar categorias de treino';

  @override
  String get showNotesDescription =>
      'Registar detalhes do seu exercício numa área de texto';

  @override
  String get positiveReinforcement => 'Reforço positivo';

  @override
  String get positiveNotificationsDescription =>
      'Mostrar mensagens positivas quando for atingido um novo recorde';

  @override
  String get positiveMessagesEnabled =>
      'Agora as mensagens positivas aparecem assim!';

  @override
  String get recordEncouragement01 => 'Excelente trabalho! Está incrível.';

  @override
  String get recordEncouragement02 =>
      'Muito bem, rei! O seu progresso é inspirador.';

  @override
  String get recordEncouragement03 => 'Faço-lhe uma vénia...';

  @override
  String get recordEncouragement04 => 'O que é isto? Um novo recorde!';

  @override
  String get recordEncouragement05 => 'Incrível! É uma inspiração.';

  @override
  String get recordEncouragement06 => 'Uau. Muito bom.';

  @override
  String get recordEncouragement07 => 'A ficar forte, hein?';

  @override
  String get recordEncouragement08 => 'Sim. Está a ficar enorme.';

  @override
  String get recordEncouragement09 => 'Impressionante. Incrível.';

  @override
  String get recordEncouragement10 => 'O Arnie ficaria orgulhoso.';

  @override
  String get recordEncouragement11 => 'Ronnie C olha para si com orgulho.';

  @override
  String get recordEncouragement12 => 'ISSO! PESO LEVE, BEBÉ!!!!!!!';

  @override
  String get recordEncouragement13 =>
      'É um novo recorde? Eu sabia que conseguia.';

  @override
  String get recordEncouragement14 =>
      'Excelente trabalho! Tenho orgulho em si.';

  @override
  String get recordEncouragement15 => 'É isso! Peso leve!';

  @override
  String get recordEncouragement16 => 'Continue assim! Excelente progresso.';

  @override
  String get recordEncouragement17 => 'Está a ir muito bem.';

  @override
  String get recordEncouragement18 => 'Esse é o meu rapaz!';

  @override
  String get recordEncouragement19 => 'Continue assim.';

  @override
  String get recordEncouragement20 => 'Está a ficar muito forte.';

  @override
  String get recordEncouragement21 => 'Poderoso.';

  @override
  String get recordEncouragement22 => 'Isto é força!';

  @override
  String get recordEncouragement23 => 'Tenho orgulho em si.';

  @override
  String get recordEncouragement24 => 'Continue com o excelente trabalho.';

  @override
  String get recordEncouragement25 =>
      'Cabeça erguida! Acabou de bater um novo recorde.';

  @override
  String get recordEncouragement26 =>
      'Novo recorde! Acabou de chegar mais longe do que nunca!';

  @override
  String get recordEncouragement27 => 'Isso! É recorde.';

  @override
  String get recordEncouragement28 => 'Uau! Novo recorde!';

  @override
  String get recordEncouragement29 => 'Muito bom mesmo.';

  @override
  String get repEstimationDescription =>
      'Tentar prever quantas repetições acabou de fazer';

  @override
  String get durationEstimationDescription =>
      'Tentar prever a duração do seu cardio';

  @override
  String get showGraphXAxisToggle => 'Mostrar opção do eixo X do gráfico';

  @override
  String get showGraphXAxisToggleDescription =>
      'Mostrar nos gráficos a opção de eixo X baseado em tempo';

  @override
  String get showGraphLimitDescription =>
      'Mostrar o controlo deslizante de limite nos gráficos';

  @override
  String get defaultTimeBasedXAxis =>
      'Eixo X baseado em tempo por predefinição';

  @override
  String get defaultTimeBasedXAxisDescription =>
      'Usar o eixo X baseado em tempo por predefinição nos gráficos';

  @override
  String get createFirstTrainingPlan =>
      'Crie seu primeiro plano de treino para começar.';

  @override
  String nothingMatchesPlanSearch(String query) {
    return 'Nada corresponde a “$query”. Pode criá-lo como um novo plano.';
  }

  @override
  String get createPlan => 'Criar plano';

  @override
  String createNamedPlan(String name) {
    return 'Criar “$name”';
  }

  @override
  String setNumber(int number) {
    return 'Série $number';
  }
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageDescription =>
      'Escolha o idioma usado pelo Flexify';

  @override
  String get languageSystemDefault => 'Padrão do sistema';

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
  String get languageNamePortuguesePortugal => 'Português (Portugal)';

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
  String get navHistory => 'Histórico';

  @override
  String get navPlans => 'Planos';

  @override
  String get navGraphs => 'Gráficos';

  @override
  String get navTimer => 'Temporizador';

  @override
  String get navSettings => 'Configurações';

  @override
  String get navCategories => 'Categorias';

  @override
  String get exerciseAlreadyExists => 'Este exercício já existe';

  @override
  String get errorLabel => 'Erro';

  @override
  String get tabContentError => 'Não foi possível exibir o conteúdo da aba.';

  @override
  String get cannotHideAllTabs => 'Não é possível ocultar tudo!';

  @override
  String removeTabQuestion(String tab) {
    return 'Remover a aba $tab?';
  }

  @override
  String get restoreTabFromSettings =>
      'Você pode adicioná-la novamente depois nas configurações.';

  @override
  String removedTab(String tab) {
    return '$tab removida';
  }

  @override
  String newVersion(String version) {
    return 'Nova versão $version';
  }

  @override
  String get changes => 'Novidades';

  @override
  String get searchHint => 'Pesquisar...';

  @override
  String get deleteSelected => 'Excluir selecionados';

  @override
  String get confirmDelete => 'Confirmar exclusão';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Tem certeza de que deseja excluir $count registros? Esta ação não pode ser desfeita.',
      one:
          'Tem certeza de que deseja excluir 1 registro? Esta ação não pode ser desfeita.',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionDiscard => 'Descartar';

  @override
  String get unsavedChanges => 'Alterações não salvas';

  @override
  String get discardUnsavedChanges => 'Descartar as alterações não salvas?';

  @override
  String get actionDelete => 'Excluir';

  @override
  String get actionRemove => 'Remover';

  @override
  String get actionEdit => 'Editar';

  @override
  String get actionShare => 'Compartilhar';

  @override
  String get clearSelection => 'Limpar seleção';

  @override
  String get clearSearch => 'Limpar pesquisa';

  @override
  String get showMenu => 'Mostrar menu';

  @override
  String get selectAll => 'Selecionar tudo';

  @override
  String get weightLabel => 'Peso';

  @override
  String get filter => 'Filtro';

  @override
  String get filters => 'Filtros';

  @override
  String get categoryLabel => 'Categoria';

  @override
  String get repsLabel => 'Repetições';

  @override
  String get repsFilter => 'Filtro de repetições';

  @override
  String get weightFilter => 'Filtro de peso';

  @override
  String get greaterThan => 'Maior que';

  @override
  String get lessThan => 'Menor que';

  @override
  String get startDate => 'Data inicial';

  @override
  String get endDate => 'Data final';

  @override
  String get actionClear => 'Limpar';

  @override
  String get actionOk => 'OK';

  @override
  String get actionClose => 'Fechar';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get dateNewest => 'Data (mais recente)';

  @override
  String get dateOldest => 'Data (mais antiga)';

  @override
  String get nameLabel => 'Nome';

  @override
  String get missingPermissions => 'Permissões ausentes';

  @override
  String get restTimersPermissionsMissing =>
      'Os temporizadores de descanso estão ativados, mas faltam permissões.';

  @override
  String get restTimersPermissionsOptional =>
      'Se você desativar os temporizadores de descanso, essas permissões não serão necessárias.';

  @override
  String get restTimers => 'Temporizadores de descanso';

  @override
  String get disableBatteryOptimizations => 'Desativar otimizações de bateria';

  @override
  String get batteryOptimizationWarning =>
      'O progresso pode pausar se as otimizações de bateria permanecerem ativadas.';

  @override
  String get scheduleExactAlarm => 'Agendar alarme exato';

  @override
  String get exactAlarmWarning =>
      'Os alarmes não podem ser precisos se esta opção estiver desativada.';

  @override
  String get postNotifications => 'Exibir notificações';

  @override
  String get notificationBarDescription =>
      'O progresso do temporizador é exibido na barra de notificações';

  @override
  String get invalidPermissions => 'Permissões inválidas';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      'Os temporizadores de descanso estão ativados sem permissões suficientes. Deseja continuar?';

  @override
  String get actionConfirm => 'Confirmar';

  @override
  String get appAccess => 'Acesso ao app';

  @override
  String get appAccessDescription =>
      'Necessário para temporizadores e notificações ativados.';

  @override
  String get notifications => 'Notificações';

  @override
  String get timerProgressAndRestAlerts =>
      'Progresso do temporizador e alertas de descanso';

  @override
  String get enabledNotificationsDescription => 'Notificações que você ativou';

  @override
  String get backgroundActivity => 'Atividade em segundo plano';

  @override
  String get backgroundActivityDescription =>
      'Mantenha os temporizadores confiáveis em segundo plano';

  @override
  String get exactAlarms => 'Alarmes exatos';

  @override
  String get exactAlarmsDescription =>
      'Avise exatamente quando um temporizador de descanso terminar';

  @override
  String get noAdditionalAndroidAccessNeeded =>
      'Nenhum acesso adicional do Android é necessário para suas configurações atuais.';

  @override
  String get actionDone => 'Concluído';

  @override
  String get allowed => 'Permitido';

  @override
  String get actionAllow => 'Permitir';

  @override
  String get backupLabel => 'Backup';

  @override
  String get databaseLabel => 'Banco de dados';

  @override
  String get deleteRecords => 'Excluir registros';

  @override
  String get deleteAllGraphsConfirmation =>
      'Tem certeza de que deseja excluir todos os gráficos? Esta ação não pode ser desfeita.';

  @override
  String get deleteAllPlansConfirmation =>
      'Tem certeza de que deseja excluir todos os planos? Esta ação não pode ser desfeita.';

  @override
  String get deleteDatabaseConfirmation =>
      'Tem certeza de que deseja excluir seu banco de dados? Esta ação não pode ser desfeita e apagará todos os seus dados.';

  @override
  String get importData => 'Importar dados';

  @override
  String get exportData => 'Exportar dados';

  @override
  String get actionReport => 'Relatar';

  @override
  String get graphDataImported => 'Dados dos gráficos importados com sucesso!';

  @override
  String get plansImported => 'Planos importados com sucesso';

  @override
  String failedToImportDatabase(String error) {
    return 'Falha ao importar banco de dados: $error';
  }

  @override
  String get backupArchiveMissingDatabase =>
      'O backup não contém o banco de dados do Flexify.';

  @override
  String failedToImportGraphs(String error) {
    return 'Falha ao importar gráficos: $error';
  }

  @override
  String failedToImportPlans(String error) {
    return 'Falha ao importar planos: $error';
  }

  @override
  String get selectedFileDoesNotExist => 'O arquivo selecionado não existe';

  @override
  String get couldNotReadFileData => 'Não foi possível ler os dados do arquivo';

  @override
  String get databaseImportWebUnsupported =>
      'A importação do banco de dados na web exige migração manual dos dados. Exporte seus dados como arquivos CSV e importe-os no lugar do banco de dados.';

  @override
  String get csvFileEmpty => 'O arquivo CSV está vazio';

  @override
  String get csvNeedsDataRow =>
      'O arquivo CSV deve conter pelo menos uma linha de dados';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return 'A linha $row não tem colunas suficientes: $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return 'Valor de $field inválido na linha $row: $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return 'Tipo de dado de $field inválido na linha $row: $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return 'Era esperado um ID inteiro de plano, mas foi recebido \"$value\"';
  }

  @override
  String get unitLabel => 'Unidade';

  @override
  String get kilogramsUnit => 'Quilogramas (kg)';

  @override
  String get poundsUnit => 'Libras (lb)';

  @override
  String get stoneUnit => 'Stone';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => 'Quilômetros (km)';

  @override
  String get milesUnit => 'Milhas (mi)';

  @override
  String get metersUnit => 'Metros (m)';

  @override
  String get kilocaloriesUnit => 'Quilocalorias (kcal)';

  @override
  String get enterWeight => 'Inserir peso';

  @override
  String get requiredField => 'Obrigatório';

  @override
  String get invalidNumber => 'Número inválido';

  @override
  String get previousWeight => 'Peso anterior';

  @override
  String get imageLabel => 'Imagem';

  @override
  String get longPressToDelete => 'Pressione e segure para excluir';

  @override
  String get imageError => 'Erro na imagem';

  @override
  String get actionSave => 'Salvar';

  @override
  String get aboutTitle => 'Sobre';

  @override
  String get donate => 'Doar';

  @override
  String get helpSupportProject => 'Ajude a apoiar este projeto';

  @override
  String get whatsNewAbout => 'O que há de novo?';

  @override
  String get whatsNewTitle => 'O que há de novo?';

  @override
  String get seeReleaseNotes => 'Veja nossas notas de versão';

  @override
  String get versionLabel => 'Versão';

  @override
  String get authorLabel => 'Autor';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get privacyPolicyDescription => 'Como o Flexify trata seus dados';

  @override
  String get licenseLabel => 'Licença';

  @override
  String get sourceCode => 'Código-fonte';

  @override
  String get sourceCodeDescription => 'Confira no GitHub';

  @override
  String get leaveReview => 'Deixar uma avaliação';

  @override
  String get leaveReviewDescription => 'Avalie o Flexify na Play Store';

  @override
  String get reportBug => 'Relatar um bug';

  @override
  String get reportBugDescription => 'Abra um chamado no GitHub';

  @override
  String get failedMigrations => 'Migrações com falha';

  @override
  String get errorMessageLabel => 'Mensagem de erro:';

  @override
  String get createIssue => 'Criar chamado';

  @override
  String get addExercise => 'Adicionar exercício';

  @override
  String get cardio => 'Cardio';

  @override
  String get strength => 'Força';

  @override
  String get options => 'Opções';

  @override
  String get periodDay => 'Dia';

  @override
  String get periodWeek => 'Semana';

  @override
  String get periodMonth => 'Mês';

  @override
  String get periodYear => 'Ano';

  @override
  String noDataFor(String name) {
    return 'Ainda não há dados para $name';
  }

  @override
  String get noDataYet => 'Ainda não há dados';

  @override
  String get exerciseNotes => 'Notas do exercício';

  @override
  String get notesForExercise => 'Notas para este exercício';

  @override
  String get useTimeBasedXAxis => 'Usar eixo X baseado em tempo';

  @override
  String updateAllNamed(String name) {
    return 'Atualizar todos os registros de $name';
  }

  @override
  String get newName => 'Novo nome';

  @override
  String get restMinutes => 'Minutos de descanso';

  @override
  String get restSeconds => 'Segundos de descanso';

  @override
  String get globalProgress => 'Progresso geral';

  @override
  String get curveLineGraphs => 'Linhas curvas nos gráficos';

  @override
  String get curveLineGraphsDescription =>
      'Desenhar as linhas dos gráficos como curvas suaves';

  @override
  String noHistoryFor(String name) {
    return 'Ainda não há histórico para $name';
  }

  @override
  String get cancelSelection => 'Cancelar seleção';

  @override
  String get editSelected => 'Editar selecionados';

  @override
  String get newExercise => 'Novo exercício';

  @override
  String get noGraphsFound => 'Nenhum gráfico encontrado';

  @override
  String get searchGraphs => 'Pesquisar gráficos...';

  @override
  String get actionAdd => 'Adicionar';

  @override
  String get actionUpdate => 'Atualizar';

  @override
  String get hideGlobalProgress => 'Ocultar progresso geral';

  @override
  String get chartGroupedByCategory => 'Um gráfico agrupado por categoria';

  @override
  String get noExercisesFound => 'Nenhum exercício encontrado';

  @override
  String get savePlan => 'Salvar plano';

  @override
  String get titleOptional => 'Título (opcional)';

  @override
  String get searchExercises => 'Pesquisar exercícios...';

  @override
  String get warmupSets => 'Séries de aquecimento';

  @override
  String get workingSetsMax => 'Séries de trabalho (máx.: 20)';

  @override
  String get actionUndo => 'Desfazer';

  @override
  String get actionSwap => 'Trocar';

  @override
  String get daily => 'Diário';

  @override
  String get weekly => 'Semanal';

  @override
  String get monthly => 'Mensal';

  @override
  String get yearly => 'Anual';

  @override
  String get unexpectedError => 'Algo deu errado. Tente novamente.';

  @override
  String get loadingExercises => 'Carregando exercícios...';

  @override
  String get noPlansYet => 'Ainda não há planos';

  @override
  String get noMatchingPlans => 'Nenhum plano correspondente';

  @override
  String get newPlan => 'Novo plano';

  @override
  String get searchPlans => 'Pesquisar planos...';

  @override
  String get noExercisesYet => 'Ainda não há exercícios';

  @override
  String get editPlan => 'Editar plano';

  @override
  String get saveSet => 'Salvar série';

  @override
  String get minutesLabel => 'Minutos';

  @override
  String get minutesShort => 'min';

  @override
  String get secondsLabel => 'Segundos';

  @override
  String get distanceLabel => 'Distância';

  @override
  String get inclinePercent => 'Inclinação %';

  @override
  String weightWithUnit(String unit) {
    return 'Peso ($unit)';
  }

  @override
  String get useBodyWeight => 'Usar peso corporal';

  @override
  String get noWeightEnteredYet => 'Nenhum peso informado ainda';

  @override
  String get notesLabel => 'Notas';

  @override
  String get swapWorkout => 'Trocar treino';

  @override
  String get addSet => 'Adicionar série';

  @override
  String get deleteSet => 'Excluir série';

  @override
  String get oneRepMaxEstimate => 'Uma repetição máxima (estimativa)';

  @override
  String get valueLabel => 'Valor';

  @override
  String amountWithUnit(String unit) {
    return 'Quantidade ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return 'Distância ($unit)';
  }

  @override
  String get bodyWeightLabel => 'Peso corporal';

  @override
  String bodyWeightWithUnit(String unit) {
    return 'Peso corporal ($unit)';
  }

  @override
  String get categoryHelper =>
      'Escolha uma categoria existente ou digite uma nova.';

  @override
  String get manageCategories => 'Gerenciar categorias';

  @override
  String get manageCategoriesDescription =>
      'Crie, renomeie, mescle ou remova categorias';

  @override
  String get newCategory => 'Nova categoria';

  @override
  String get renameCategory => 'Renomear categoria';

  @override
  String get mergeCategory => 'Mesclar com outra categoria';

  @override
  String get noCategories => 'Nenhuma categoria ainda';

  @override
  String get categoryNameRequired => 'Digite um nome para a categoria';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Usada por $count registros',
      one: 'Usada por 1 registro',
      zero: 'Não usada por nenhum registro',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Excluir esta categoria e removê-la de $count registros?',
      one: 'Excluir esta categoria e removê-la de 1 registro?',
      zero: 'Excluir esta categoria?',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => 'Data de criação';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Editar $count séries',
      one: 'Editar 1 série',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => 'Ainda não há registros';

  @override
  String get historyEmptyMessage =>
      'Conclua uma série ou adicione uma manualmente para iniciar seu histórico.';

  @override
  String deleteSetConfirmation(String name) {
    return 'Tem certeza de que deseja excluir $name?';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tem certeza de que deseja excluir $count registros?',
      one: 'Tem certeza de que deseja excluir 1 registro?',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => 'Pesquisar histórico...';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeLight => 'Claro';

  @override
  String get pureBlackAmoled => 'Preto puro (AMOLED)';

  @override
  String get showImages => 'Mostrar imagens';

  @override
  String get peekGraph => 'Prévia do gráfico';

  @override
  String get inputStyleLine => 'Linha';

  @override
  String get inputStyleOutlined => 'Contornado';

  @override
  String get inputStyleFilled => 'Preenchido';

  @override
  String get inputStyle => 'Estilo dos campos';

  @override
  String get appearance => 'Aparência';

  @override
  String get automaticBackupsEnabled => 'Backups automáticos ativados';

  @override
  String get automaticBackup => 'Backup automático';

  @override
  String get appPermissions => 'Permissões do app';

  @override
  String get shareDatabase => 'Compartilhar banco de dados';

  @override
  String get dataManagement => 'Gerenciamento de dados';

  @override
  String get strengthUnit => 'Unidade de força';

  @override
  String get lastEntry => 'Último registro';

  @override
  String get cardioUnit => 'Unidade de cardio';

  @override
  String longDateFormat(String format) {
    return 'Formato de data longa ($format)';
  }

  @override
  String get formats => 'Formatos';

  @override
  String get setsPerExerciseMax => 'Séries por exercício (máx.: 20)';

  @override
  String get countLabel => 'Quantidade';

  @override
  String get ratioLabel => 'Proporção';

  @override
  String get reorder => 'Reordenar';

  @override
  String get none => 'Nenhum';

  @override
  String get monday => 'Segunda-feira';

  @override
  String get examplePlanExercises => 'Supino, Agachamento, Levantamento terra';

  @override
  String get tabs => 'Abas';

  @override
  String get swipeBetweenTabs => 'Deslizar entre abas';

  @override
  String get vibrate => 'Vibrar';

  @override
  String get enableSound => 'Ativar som';

  @override
  String get keepScreenOn => 'Manter a tela ligada';

  @override
  String get alarmSound => 'Som do alarme';

  @override
  String get top => 'Superior';

  @override
  String get bottom => 'Inferior';

  @override
  String get removeCustomTimer =>
      'Remover temporizador personalizado (usar padrão geral)';

  @override
  String get timers => 'Temporizadores';

  @override
  String get timerSettings => 'Configurações do temporizador';

  @override
  String get groupHistory => 'Agrupar histórico';

  @override
  String get showUnits => 'Mostrar unidades';

  @override
  String get showBodyWeight => 'Mostrar peso corporal';

  @override
  String get showCategories => 'Mostrar categorias';

  @override
  String get showNotes => 'Mostrar notas';

  @override
  String get repEstimation => 'Estimativa de repetições';

  @override
  String get durationEstimation => 'Estimativa de duração';

  @override
  String get showGraphLimit => 'Mostrar limite do gráfico';

  @override
  String get defaultGraphMetric => 'Métrica padrão do gráfico';

  @override
  String get bestWeight => 'Maior peso';

  @override
  String get bestReps => 'Maior número de repetições';

  @override
  String get oneRepMax => 'Uma repetição máxima';

  @override
  String get volume => 'Volume';

  @override
  String get paceCardio => 'Ritmo (cardio)';

  @override
  String get distanceCardio => 'Distância (cardio)';

  @override
  String get defaultGraphPeriod => 'Período padrão do gráfico';

  @override
  String get defaultGraphLimit => 'Limite padrão do gráfico';

  @override
  String get workouts => 'Treinos';

  @override
  String get actionStop => 'Parar';

  @override
  String get timerFinishedToast => 'Temporizador concluído!';

  @override
  String get stopTimer => 'Parar temporizador';

  @override
  String get actionPause => 'Pausar';

  @override
  String get startStopwatch => 'Iniciar cronômetro';

  @override
  String get actionStart => 'Iniciar';

  @override
  String get actionRestart => 'Reiniciar';

  @override
  String get addOneMinute => '+1 minuto';

  @override
  String get addOneMinuteNotification => 'Adicionar 1 min';

  @override
  String get restTimer => 'Temporizador de descanso';

  @override
  String get timerUp => 'Tempo esgotado';

  @override
  String get openNotification => 'Abrir notificação';

  @override
  String get timerChannelName => 'Canal do temporizador';

  @override
  String get timerChannelDescription =>
      'Progresso contínuo dos temporizadores de descanso.';

  @override
  String get timerFinishedChannelName => 'Canal de temporizador concluído';

  @override
  String get timerFinishedChannelDescription =>
      'Toca um alarme quando um temporizador de descanso termina.';

  @override
  String get timerFinished => 'Temporizador concluído';

  @override
  String get batteryOptimizationRequestUnavailable =>
      'As solicitações para ignorar otimizações de bateria estão desativadas no seu dispositivo.';

  @override
  String get exactAlarmRequestUnavailable =>
      'A solicitação de SCHEDULE_EXACT_ALARM foi rejeitada no seu dispositivo';

  @override
  String get databaseMigrationFailureDescription =>
      'Algo deu errado ao criar ou atualizar seu banco de dados. Em geral, isso pode ser corrigido excluindo e recriando seus registros.';

  @override
  String get curveSmoothness => 'Suavidade das curvas';

  @override
  String get actionBack => 'Voltar';

  @override
  String get atLeastOneTab => 'Você precisa de pelo menos uma aba';

  @override
  String get invalidTabSettings => 'Configurações de abas inválidas.';

  @override
  String get noSettingsFound => 'Nenhuma configuração encontrada';

  @override
  String nothingMatchesSearch(String query) {
    return 'Nada corresponde a “$query”.';
  }

  @override
  String get appearanceDescription => 'Tema, cores e estilo da interface';

  @override
  String get dataManagementDescription =>
      'Importe, exporte e gerencie seus dados de treino';

  @override
  String get formatsDescription => 'Datas, números e formatação de medidas';

  @override
  String get plansSettingsDescription =>
      'Padrões e comportamento dos planos de treino';

  @override
  String get tabsDescription =>
      'Escolha e organize as abas principais de navegação';

  @override
  String get timersDescription =>
      'Duração, som e comportamento do temporizador de descanso';

  @override
  String get workoutsDescription =>
      'Preferências de exercícios e acompanhamento de treinos';

  @override
  String get completeSetForChart =>
      'Conclua uma série deste exercício para criar o gráfico.';

  @override
  String get dateRange => 'Intervalo de datas';

  @override
  String get stopDate => 'Data final';

  @override
  String get dataPoints => 'Pontos de dados';

  @override
  String get completeSetsForProgress =>
      'Conclua algumas séries para criar seu gráfico de progresso.';

  @override
  String get relativeStrength => 'Força relativa';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selecionados',
      one: '1 selecionado',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory =>
      'Conclua algumas séries para ver aqui o histórico deste exercício.';

  @override
  String get completeSetForFirstGraph =>
      'Conclua uma série para criar seu primeiro gráfico de exercício.';

  @override
  String nothingMatchesGraphSearch(String query) {
    return 'Nada corresponde a “$query”. Você pode criá-lo como um novo exercício.';
  }

  @override
  String addNamed(String name) {
    return 'Adicionar “$name”';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return 'Isso excluirá $count registros. Tem certeza?';
  }

  @override
  String shareWorkout(String summary) {
    return 'Acabei de fazer $summary';
  }

  @override
  String get updateConflict => 'Conflito de atualização';

  @override
  String updateConflictDescription(int count) {
    return 'Seu novo nome já existe em $count registros. Deseja continuar?';
  }

  @override
  String get unitsConflict => 'Conflito de unidades';

  @override
  String unitsConflictDescription(String unit) {
    return 'Nem todos os seus registros usam a mesma unidade. Isso converterá todas as unidades para $unit. Deseja continuar?';
  }

  @override
  String get durationLabel => 'Duração';

  @override
  String get inclineLabel => 'Inclinação';

  @override
  String get paceDistanceTime => 'Ritmo (distância / tempo)';

  @override
  String get adjustedPace => 'Ritmo ajustado';

  @override
  String get oneRepMaxAccuracyWarning =>
      'As estimativas de uma repetição máxima são menos precisas para séries de 10 ou mais repetições';

  @override
  String get addPlan => 'Adicionar plano';

  @override
  String get planDetails => 'Detalhes do plano';

  @override
  String get exercisesLabel => 'Exercícios';

  @override
  String get addExerciseToPlan => 'Adicione um exercício a este plano.';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return 'Nada corresponde a “$query”. Você pode adicioná-lo como um novo exercício.';
  }

  @override
  String get selectDays => 'Selecionar dias';

  @override
  String get selectExercises => 'Selecionar exercícios';

  @override
  String get todayLabel => 'Hoje';

  @override
  String get setDetails => 'Detalhes da série';

  @override
  String get themeLabel => 'Tema';

  @override
  String get pureBlackAmoledDescription =>
      'Usar cores em preto puro para telas AMOLED';

  @override
  String get systemColorScheme => 'Esquema de cores do sistema';

  @override
  String get systemColorSchemeDescription =>
      'Usar a cor principal do seu dispositivo no app';

  @override
  String get showImagesDescription =>
      'Escolher e exibir imagens na página de histórico';

  @override
  String get showGlobalProgress => 'Mostrar progresso geral';

  @override
  String get showGlobalProgressDescription =>
      'Adicionar ao gráfico uma entrada que mostre seu progresso por categoria';

  @override
  String get peekGraphDescription =>
      'Mostrar o primeiro gráfico de linhas na página de gráficos';

  @override
  String get inputStyleDescription => 'Estilo visual dos campos de texto';

  @override
  String get automaticBackupNotificationBody =>
      'O Flexify fará backup automático dos seus dados e imagens na pasta selecionada todos os dias.';

  @override
  String get backupSettingsChannel => 'Configurações de backup';

  @override
  String get backupSettingsChannelDescription =>
      'Notificações que explicam os backups automáticos';

  @override
  String get backupChannelName => 'Canal de backup';

  @override
  String get backupChannelDescription =>
      'Backups automáticos dos dados e imagens do Flexify';

  @override
  String get backupCompletedTitle => 'Backup de dados e imagens concluído';

  @override
  String get backupFailurePathNotSet =>
      'Falha no backup: caminho de backup não definido. Backups automáticos desativados.';

  @override
  String get backupFailureDirectoryUnavailable =>
      'Falha no backup: não foi possível acessar o diretório de backup. Backups automáticos desativados.';

  @override
  String get backupFailureCreateFile =>
      'Falha no backup: não foi possível criar o arquivo de backup. Backups automáticos desativados.';

  @override
  String get backupFailureAppFilesUnavailable =>
      'Falha no backup: não foi possível acessar o diretório de arquivos do aplicativo. Backups automáticos desativados.';

  @override
  String get backupFailureDatabaseMissing =>
      'Falha no backup: arquivo do banco de dados não encontrado. Backups automáticos desativados.';

  @override
  String get backupFailureOutputUnavailable =>
      'Falha no backup: não foi possível abrir o fluxo de saída. Backups automáticos desativados.';

  @override
  String get backupFailureUnknown =>
      'Falha no backup. Backups automáticos desativados.';

  @override
  String get appPermissionsDescription =>
      'Revise o acesso exigido pelos recursos que você ativou';

  @override
  String get longDateFormatDescription => 'Usado onde há bastante espaço';

  @override
  String shortDateFormat(String example) {
    return 'Formato de data curta ($example)';
  }

  @override
  String get shortDateFormatDescription =>
      'Usado onde há pouco espaço (linhas dos gráficos)';

  @override
  String get warmupSetsDescription =>
      'Séries de aquecimento não têm temporizadores de descanso';

  @override
  String get setsPerExerciseDescription =>
      'Número padrão de exercícios em um plano';

  @override
  String get planTrailingDisplay => 'Exibição à direita do plano';

  @override
  String get planTrailingDisplayDescription =>
      'Conteúdo exibido à direita da lista em Planos e na visualização do plano';

  @override
  String get restTimersDescription =>
      'Alarme que dispara após concluir uma série';

  @override
  String get vibrateDescription =>
      'Os temporizadores de descanso devem vibrar?';

  @override
  String get enableSoundDescription =>
      'Os temporizadores de descanso devem reproduzir um som?';

  @override
  String get keepScreenOnDescription =>
      'Manter a tela ligada durante os temporizadores de descanso';

  @override
  String get restDurationDescription =>
      'Quanto tempo esperar antes de disparar os alarmes de descanso?';

  @override
  String get globalDefault => 'Padrão geral';

  @override
  String get alarmSoundDescription =>
      'Música reproduzida ao final de um temporizador de descanso';

  @override
  String get progressBarPosition => 'Posição da barra de progresso';

  @override
  String get progressBarPositionDescription =>
      'Onde a barra de progresso dos temporizadores de descanso deve ficar?';

  @override
  String get perExerciseRestTimes => 'Tempos de descanso por exercício';

  @override
  String get perExerciseRestTimesDescription =>
      'Estes exercícios têm durações de descanso personalizadas';

  @override
  String get audioFeaturesUnavailable => 'Recursos de áudio indisponíveis';

  @override
  String get groupHistoryDescription =>
      'Combinar registros do histórico por dia';

  @override
  String get showUnitsDescription =>
      'Mostrar km/mi e kg/lb em gráficos, histórico e planos';

  @override
  String get showBodyWeightDescription =>
      'Ativar ou desativar o acompanhamento do peso corporal';

  @override
  String get showCategoriesDescription =>
      'Ativar ou desativar categorias de treino';

  @override
  String get showNotesDescription =>
      'Registrar detalhes do seu exercício em uma área de texto';

  @override
  String get positiveReinforcement => 'Reforço positivo';

  @override
  String get positiveNotificationsDescription =>
      'Exibir mensagens positivas quando um novo recorde for alcançado';

  @override
  String get positiveMessagesEnabled =>
      'Agora as mensagens positivas aparecem assim!';

  @override
  String get recordEncouragement01 => 'Ótimo trabalho! Você é incrível.';

  @override
  String get recordEncouragement02 =>
      'Mandou bem, rei! Seu progresso é inspirador.';

  @override
  String get recordEncouragement03 => 'Eu me curvo...';

  @override
  String get recordEncouragement04 => 'O que é isso? Um novo recorde!';

  @override
  String get recordEncouragement05 => 'Incrível! Você é uma inspiração.';

  @override
  String get recordEncouragement06 => 'Uau. Muito bom.';

  @override
  String get recordEncouragement07 => 'Ficando forte, hein?';

  @override
  String get recordEncouragement08 => 'É. Você está ficando grandão.';

  @override
  String get recordEncouragement09 => 'Impressionante. Incrível.';

  @override
  String get recordEncouragement10 => 'O Arnie ficaria orgulhoso.';

  @override
  String get recordEncouragement11 => 'Ronnie C olha para você com alegria.';

  @override
  String get recordEncouragement12 => 'ISSO! PESO LEVE, BEBÊ!!!!!!!';

  @override
  String get recordEncouragement13 =>
      'Isso é um novo recorde? Eu sabia que você conseguiria.';

  @override
  String get recordEncouragement14 => 'Ótimo trabalho! Tenho orgulho de você.';

  @override
  String get recordEncouragement15 => 'Isso aí! Peso leve!';

  @override
  String get recordEncouragement16 => 'Continue assim! Ótimo progresso.';

  @override
  String get recordEncouragement17 => 'Você está indo muito bem.';

  @override
  String get recordEncouragement18 => 'Esse é o meu garoto!';

  @override
  String get recordEncouragement19 => 'Continue assim.';

  @override
  String get recordEncouragement20 => 'Você está ficando muito forte.';

  @override
  String get recordEncouragement21 => 'Poderoso.';

  @override
  String get recordEncouragement22 => 'Isso é força!';

  @override
  String get recordEncouragement23 => 'Tenho orgulho de você.';

  @override
  String get recordEncouragement24 => 'Continue com o ótimo trabalho.';

  @override
  String get recordEncouragement25 =>
      'Cabeça erguida! Você acabou de bater um novo recorde.';

  @override
  String get recordEncouragement26 =>
      'Novo recorde! Você acabou de ir mais longe do que nunca!';

  @override
  String get recordEncouragement27 => 'Isso! É recorde.';

  @override
  String get recordEncouragement28 => 'Uau! Novo recorde!';

  @override
  String get recordEncouragement29 => 'Muito bom mesmo.';

  @override
  String get repEstimationDescription =>
      'Tentar prever quantas repetições você acabou de fazer';

  @override
  String get durationEstimationDescription =>
      'Tentar prever a duração do seu cardio';

  @override
  String get showGraphXAxisToggle => 'Mostrar opção do eixo X do gráfico';

  @override
  String get showGraphXAxisToggleDescription =>
      'Mostrar nos gráficos a opção de eixo X baseado em tempo';

  @override
  String get showGraphLimitDescription =>
      'Mostrar o controle deslizante de limite nos gráficos';

  @override
  String get defaultTimeBasedXAxis => 'Eixo X baseado em tempo por padrão';

  @override
  String get defaultTimeBasedXAxisDescription =>
      'Usar eixo X baseado em tempo por padrão nos gráficos';

  @override
  String get createFirstTrainingPlan =>
      'Crie seu primeiro plano de treino para começar.';

  @override
  String nothingMatchesPlanSearch(String query) {
    return 'Nada corresponde a “$query”. Você pode criá-lo como um novo plano.';
  }

  @override
  String get createPlan => 'Criar plano';

  @override
  String createNamedPlan(String name) {
    return 'Criar “$name”';
  }

  @override
  String setNumber(int number) {
    return 'Série $number';
  }
}

/// The translations for Portuguese, as used in Portugal (`pt_PT`).
class AppLocalizationsPtPt extends AppLocalizationsPt {
  AppLocalizationsPtPt() : super('pt_PT');

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageDescription =>
      'Escolha o idioma utilizado pelo Flexify';

  @override
  String get languageSystemDefault => 'Predefinição do sistema';

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
  String get languageNamePortuguesePortugal => 'Português (Portugal)';

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
  String get navHistory => 'Histórico';

  @override
  String get navPlans => 'Planos';

  @override
  String get navGraphs => 'Gráficos';

  @override
  String get navTimer => 'Temporizador';

  @override
  String get navSettings => 'Definições';

  @override
  String get navCategories => 'Categorias';

  @override
  String get exerciseAlreadyExists => 'Este exercício já existe';

  @override
  String get errorLabel => 'Erro';

  @override
  String get tabContentError =>
      'Não foi possível apresentar o conteúdo do separador.';

  @override
  String get cannotHideAllTabs =>
      'Não é possível ocultar todos os separadores!';

  @override
  String removeTabQuestion(String tab) {
    return 'Remover o separador $tab?';
  }

  @override
  String get restoreTabFromSettings =>
      'Pode adicioná-lo novamente mais tarde nas definições.';

  @override
  String removedTab(String tab) {
    return '$tab removido';
  }

  @override
  String newVersion(String version) {
    return 'Nova versão $version';
  }

  @override
  String get changes => 'Novidades';

  @override
  String get searchHint => 'Pesquisar...';

  @override
  String get deleteSelected => 'Eliminar selecionados';

  @override
  String get confirmDelete => 'Confirmar eliminação';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Tem a certeza de que pretende eliminar $count registos? Esta ação não pode ser desfeita.',
      one:
          'Tem a certeza de que pretende eliminar 1 registo? Esta ação não pode ser desfeita.',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionDiscard => 'Descartar';

  @override
  String get unsavedChanges => 'Alterações não guardadas';

  @override
  String get discardUnsavedChanges => 'Descartar as alterações não guardadas?';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get actionRemove => 'Remover';

  @override
  String get actionEdit => 'Editar';

  @override
  String get actionShare => 'Partilhar';

  @override
  String get clearSelection => 'Limpar seleção';

  @override
  String get clearSearch => 'Limpar pesquisa';

  @override
  String get showMenu => 'Mostrar menu';

  @override
  String get selectAll => 'Selecionar tudo';

  @override
  String get weightLabel => 'Peso';

  @override
  String get filter => 'Filtro';

  @override
  String get filters => 'Filtros';

  @override
  String get categoryLabel => 'Categoria';

  @override
  String get repsLabel => 'Repetições';

  @override
  String get repsFilter => 'Filtro de repetições';

  @override
  String get weightFilter => 'Filtro de peso';

  @override
  String get greaterThan => 'Maior que';

  @override
  String get lessThan => 'Menor que';

  @override
  String get startDate => 'Data inicial';

  @override
  String get endDate => 'Data final';

  @override
  String get actionClear => 'Limpar';

  @override
  String get actionOk => 'OK';

  @override
  String get actionClose => 'Fechar';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get dateNewest => 'Data (mais recente)';

  @override
  String get dateOldest => 'Data (mais antiga)';

  @override
  String get nameLabel => 'Nome';

  @override
  String get missingPermissions => 'Permissões ausentes';

  @override
  String get restTimersPermissionsMissing =>
      'Os temporizadores de descanso estão ativados, mas faltam permissões.';

  @override
  String get restTimersPermissionsOptional =>
      'Se desativar os temporizadores de descanso, estas permissões não serão necessárias.';

  @override
  String get restTimers => 'Temporizadores de descanso';

  @override
  String get disableBatteryOptimizations => 'Desativar otimizações da bateria';

  @override
  String get batteryOptimizationWarning =>
      'O progresso pode ficar em pausa se as otimizações da bateria permanecerem ativadas.';

  @override
  String get scheduleExactAlarm => 'Agendar alarme exato';

  @override
  String get exactAlarmWarning =>
      'Os alarmes não podem ser precisos se esta opção estiver desativada.';

  @override
  String get postNotifications => 'Mostrar notificações';

  @override
  String get notificationBarDescription =>
      'O progresso do temporizador é apresentado na barra de notificações';

  @override
  String get invalidPermissions => 'Permissões inválidas';

  @override
  String get insufficientTimerPermissionsConfirmation =>
      'Os temporizadores de descanso estão ativados sem permissões suficientes. Pretende continuar?';

  @override
  String get actionConfirm => 'Confirmar';

  @override
  String get appAccess => 'Acesso à aplicação';

  @override
  String get appAccessDescription =>
      'Necessário para temporizadores e notificações ativados.';

  @override
  String get notifications => 'Notificações';

  @override
  String get timerProgressAndRestAlerts =>
      'Progresso do temporizador e alertas de descanso';

  @override
  String get enabledNotificationsDescription => 'Notificações que ativou';

  @override
  String get backgroundActivity => 'Atividade em segundo plano';

  @override
  String get backgroundActivityDescription =>
      'Manter os temporizadores fiáveis em segundo plano';

  @override
  String get exactAlarms => 'Alarmes exatos';

  @override
  String get exactAlarmsDescription =>
      'Avisar exatamente quando um temporizador de descanso terminar';

  @override
  String get noAdditionalAndroidAccessNeeded =>
      'Não é necessário acesso adicional do Android com as definições atuais.';

  @override
  String get actionDone => 'Concluído';

  @override
  String get allowed => 'Permitido';

  @override
  String get actionAllow => 'Permitir';

  @override
  String get backupLabel => 'Cópia de segurança';

  @override
  String get databaseLabel => 'Base de dados';

  @override
  String get deleteRecords => 'Eliminar registos';

  @override
  String get deleteAllGraphsConfirmation =>
      'Tem a certeza de que pretende eliminar todos os gráficos? Esta ação não pode ser desfeita.';

  @override
  String get deleteAllPlansConfirmation =>
      'Tem a certeza de que pretende eliminar todos os planos? Esta ação não pode ser desfeita.';

  @override
  String get deleteDatabaseConfirmation =>
      'Tem a certeza de que pretende eliminar a sua base de dados? Esta ação não pode ser desfeita e apagará todos os seus dados.';

  @override
  String get importData => 'Importar dados';

  @override
  String get exportData => 'Exportar dados';

  @override
  String get actionReport => 'Comunicar';

  @override
  String get graphDataImported => 'Dados dos gráficos importados com êxito!';

  @override
  String get plansImported => 'Planos importados com êxito';

  @override
  String failedToImportDatabase(String error) {
    return 'Não foi possível importar a base de dados: $error';
  }

  @override
  String get backupArchiveMissingDatabase =>
      'A cópia de segurança não contém a base de dados do Flexify.';

  @override
  String failedToImportGraphs(String error) {
    return 'Não foi possível importar os gráficos: $error';
  }

  @override
  String failedToImportPlans(String error) {
    return 'Não foi possível importar os planos: $error';
  }

  @override
  String get selectedFileDoesNotExist => 'O ficheiro selecionado não existe';

  @override
  String get couldNotReadFileData =>
      'Não foi possível ler os dados do ficheiro';

  @override
  String get databaseImportWebUnsupported =>
      'A importação da base de dados na Web exige a migração manual dos dados. Exporte os seus dados como ficheiros CSV e importe-os em vez da base de dados.';

  @override
  String get csvFileEmpty => 'O ficheiro CSV está vazio';

  @override
  String get csvNeedsDataRow =>
      'O ficheiro CSV deve conter pelo menos uma linha de dados';

  @override
  String csvRowInsufficientColumns(int row, int count) {
    return 'A linha $row não tem colunas suficientes: $count';
  }

  @override
  String invalidCsvValue(String field, int row, String value) {
    return 'Valor de $field inválido na linha $row: $value';
  }

  @override
  String invalidCsvDataType(String field, int row, String type) {
    return 'Tipo de dado de $field inválido na linha $row: $type';
  }

  @override
  String expectedIntegerPlanId(String value) {
    return 'Era esperado um ID de plano inteiro, mas foi recebido \"$value\"';
  }

  @override
  String get unitLabel => 'Unidade';

  @override
  String get kilogramsUnit => 'Quilogramas (kg)';

  @override
  String get poundsUnit => 'Libras (lb)';

  @override
  String get stoneUnit => 'Stone';

  @override
  String get stoneUnitShort => 'st';

  @override
  String get kilometersUnit => 'Quilómetros (km)';

  @override
  String get milesUnit => 'Milhas (mi)';

  @override
  String get metersUnit => 'Metros (m)';

  @override
  String get kilocaloriesUnit => 'Quilocalorias (kcal)';

  @override
  String get enterWeight => 'Introduzir peso';

  @override
  String get requiredField => 'Obrigatório';

  @override
  String get invalidNumber => 'Número inválido';

  @override
  String get previousWeight => 'Peso anterior';

  @override
  String get imageLabel => 'Imagem';

  @override
  String get longPressToDelete => 'Prima continuamente para eliminar';

  @override
  String get imageError => 'Erro na imagem';

  @override
  String get actionSave => 'Guardar';

  @override
  String get aboutTitle => 'Sobre';

  @override
  String get donate => 'Doar';

  @override
  String get helpSupportProject => 'Ajude a apoiar este projeto';

  @override
  String get whatsNewAbout => 'O que há de novo?';

  @override
  String get whatsNewTitle => 'O que há de novo?';

  @override
  String get seeReleaseNotes => 'Consulte as notas de versão';

  @override
  String get versionLabel => 'Versão';

  @override
  String get authorLabel => 'Autor';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get privacyPolicyDescription => 'Como o Flexify trata os seus dados';

  @override
  String get licenseLabel => 'Licença';

  @override
  String get sourceCode => 'Código-fonte';

  @override
  String get sourceCodeDescription => 'Consulte no GitHub';

  @override
  String get leaveReview => 'Deixar uma avaliação';

  @override
  String get leaveReviewDescription => 'Avalie o Flexify na Play Store';

  @override
  String get reportBug => 'Comunicar um erro';

  @override
  String get reportBugDescription => 'Abra um problema no GitHub';

  @override
  String get failedMigrations => 'Migrações com falha';

  @override
  String get errorMessageLabel => 'Mensagem de erro:';

  @override
  String get createIssue => 'Criar problema';

  @override
  String get addExercise => 'Adicionar exercício';

  @override
  String get cardio => 'Cardio';

  @override
  String get strength => 'Força';

  @override
  String get options => 'Opções';

  @override
  String get periodDay => 'Dia';

  @override
  String get periodWeek => 'Semana';

  @override
  String get periodMonth => 'Mês';

  @override
  String get periodYear => 'Ano';

  @override
  String noDataFor(String name) {
    return 'Ainda não há dados para $name';
  }

  @override
  String get noDataYet => 'Ainda não há dados';

  @override
  String get exerciseNotes => 'Notas do exercício';

  @override
  String get notesForExercise => 'Notas para este exercício';

  @override
  String get useTimeBasedXAxis => 'Usar eixo X baseado em tempo';

  @override
  String updateAllNamed(String name) {
    return 'Atualizar todos os registos de $name';
  }

  @override
  String get newName => 'Novo nome';

  @override
  String get restMinutes => 'Minutos de descanso';

  @override
  String get restSeconds => 'Segundos de descanso';

  @override
  String get globalProgress => 'Progresso global';

  @override
  String get curveLineGraphs => 'Linhas curvas nos gráficos';

  @override
  String get curveLineGraphsDescription =>
      'Desenhar as linhas dos gráficos como curvas suaves';

  @override
  String noHistoryFor(String name) {
    return 'Ainda não há histórico para $name';
  }

  @override
  String get cancelSelection => 'Cancelar seleção';

  @override
  String get editSelected => 'Editar selecionados';

  @override
  String get newExercise => 'Novo exercício';

  @override
  String get noGraphsFound => 'Nenhum gráfico encontrado';

  @override
  String get searchGraphs => 'Pesquisar gráficos...';

  @override
  String get actionAdd => 'Adicionar';

  @override
  String get actionUpdate => 'Atualizar';

  @override
  String get hideGlobalProgress => 'Ocultar progresso geral';

  @override
  String get chartGroupedByCategory => 'Um gráfico agrupado por categoria';

  @override
  String get noExercisesFound => 'Nenhum exercício encontrado';

  @override
  String get savePlan => 'Guardar plano';

  @override
  String get titleOptional => 'Título (opcional)';

  @override
  String get searchExercises => 'Pesquisar exercícios...';

  @override
  String get warmupSets => 'Séries de aquecimento';

  @override
  String get workingSetsMax => 'Séries de trabalho (máx.: 20)';

  @override
  String get actionUndo => 'Desfazer';

  @override
  String get actionSwap => 'Trocar';

  @override
  String get daily => 'Diário';

  @override
  String get weekly => 'Semanal';

  @override
  String get monthly => 'Mensal';

  @override
  String get yearly => 'Anual';

  @override
  String get unexpectedError => 'Algo deu errado. Tente novamente.';

  @override
  String get loadingExercises => 'A carregar exercícios...';

  @override
  String get noPlansYet => 'Ainda não há planos';

  @override
  String get noMatchingPlans => 'Nenhum plano correspondente';

  @override
  String get newPlan => 'Novo plano';

  @override
  String get searchPlans => 'Pesquisar planos...';

  @override
  String get noExercisesYet => 'Ainda não há exercícios';

  @override
  String get editPlan => 'Editar plano';

  @override
  String get saveSet => 'Guardar série';

  @override
  String get minutesLabel => 'Minutos';

  @override
  String get minutesShort => 'min';

  @override
  String get secondsLabel => 'Segundos';

  @override
  String get distanceLabel => 'Distância';

  @override
  String get inclinePercent => 'Inclinação %';

  @override
  String weightWithUnit(String unit) {
    return 'Peso ($unit)';
  }

  @override
  String get useBodyWeight => 'Usar peso corporal';

  @override
  String get noWeightEnteredYet => 'Ainda não foi introduzido nenhum peso';

  @override
  String get notesLabel => 'Notas';

  @override
  String get swapWorkout => 'Trocar treino';

  @override
  String get addSet => 'Adicionar série';

  @override
  String get deleteSet => 'Eliminar série';

  @override
  String get oneRepMaxEstimate => 'Uma repetição máxima (estimativa)';

  @override
  String get valueLabel => 'Valor';

  @override
  String amountWithUnit(String unit) {
    return 'Quantidade ($unit)';
  }

  @override
  String distanceWithUnit(String unit) {
    return 'Distância ($unit)';
  }

  @override
  String get bodyWeightLabel => 'Peso corporal';

  @override
  String bodyWeightWithUnit(String unit) {
    return 'Peso corporal ($unit)';
  }

  @override
  String get categoryHelper =>
      'Escolha uma categoria existente ou introduza uma nova.';

  @override
  String get manageCategories => 'Gerir categorias';

  @override
  String get manageCategoriesDescription =>
      'Crie, renomeie, combine ou remova categorias';

  @override
  String get newCategory => 'Nova categoria';

  @override
  String get renameCategory => 'Renomear categoria';

  @override
  String get mergeCategory => 'Combinar com outra categoria';

  @override
  String get noCategories => 'Ainda não há categorias';

  @override
  String get categoryNameRequired => 'Introduza um nome para a categoria';

  @override
  String categoryUsageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Utilizada por $count registos',
      one: 'Utilizada por 1 registo',
      zero: 'Não utilizada por nenhum registo',
    );
    return '$_temp0';
  }

  @override
  String deleteCategoryConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Eliminar esta categoria e removê-la de $count registos?',
      one: 'Eliminar esta categoria e removê-la de 1 registo?',
      zero: 'Eliminar esta categoria?',
    );
    return '$_temp0';
  }

  @override
  String get createdDate => 'Data de criação';

  @override
  String editSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Editar $count séries',
      one: 'Editar 1 série',
    );
    return '$_temp0';
  }

  @override
  String get noEntriesYet => 'Ainda não há registos';

  @override
  String get historyEmptyMessage =>
      'Conclua uma série ou adicione uma manualmente para iniciar o histórico.';

  @override
  String deleteSetConfirmation(String name) {
    return 'Tem a certeza de que pretende eliminar $name?';
  }

  @override
  String deleteEntriesConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tem a certeza de que pretende eliminar $count registos?',
      one: 'Tem a certeza de que pretende eliminar 1 registo?',
    );
    return '$_temp0';
  }

  @override
  String get searchHistory => 'Pesquisar histórico...';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeLight => 'Claro';

  @override
  String get pureBlackAmoled => 'Preto puro (AMOLED)';

  @override
  String get showImages => 'Mostrar imagens';

  @override
  String get peekGraph => 'Pré-visualização do gráfico';

  @override
  String get inputStyleLine => 'Linha';

  @override
  String get inputStyleOutlined => 'Com contorno';

  @override
  String get inputStyleFilled => 'Preenchido';

  @override
  String get inputStyle => 'Estilo dos campos';

  @override
  String get appearance => 'Aparência';

  @override
  String get automaticBackupsEnabled =>
      'Cópias de segurança automáticas ativadas';

  @override
  String get automaticBackup => 'Cópia de segurança automática';

  @override
  String get appPermissions => 'Permissões da aplicação';

  @override
  String get shareDatabase => 'Partilhar base de dados';

  @override
  String get dataManagement => 'Gestão de dados';

  @override
  String get strengthUnit => 'Unidade de força';

  @override
  String get lastEntry => 'Último registo';

  @override
  String get cardioUnit => 'Unidade de cardio';

  @override
  String longDateFormat(String format) {
    return 'Formato de data longa ($format)';
  }

  @override
  String get formats => 'Formatos';

  @override
  String get setsPerExerciseMax => 'Séries por exercício (máx.: 20)';

  @override
  String get countLabel => 'Quantidade';

  @override
  String get ratioLabel => 'Proporção';

  @override
  String get reorder => 'Reordenar';

  @override
  String get none => 'Nenhum';

  @override
  String get monday => 'Segunda-feira';

  @override
  String get examplePlanExercises => 'Supino, Agachamento, Levantamento terra';

  @override
  String get tabs => 'Separadores';

  @override
  String get swipeBetweenTabs => 'Deslizar entre separadores';

  @override
  String get vibrate => 'Vibrar';

  @override
  String get enableSound => 'Ativar som';

  @override
  String get keepScreenOn => 'Manter o ecrã ligado';

  @override
  String get alarmSound => 'Som do alarme';

  @override
  String get top => 'Superior';

  @override
  String get bottom => 'Inferior';

  @override
  String get removeCustomTimer =>
      'Remover temporizador personalizado (usar predefinição global)';

  @override
  String get timers => 'Temporizadores';

  @override
  String get timerSettings => 'Definições do temporizador';

  @override
  String get groupHistory => 'Agrupar histórico';

  @override
  String get showUnits => 'Mostrar unidades';

  @override
  String get showBodyWeight => 'Mostrar peso corporal';

  @override
  String get showCategories => 'Mostrar categorias';

  @override
  String get showNotes => 'Mostrar notas';

  @override
  String get repEstimation => 'Estimativa de repetições';

  @override
  String get durationEstimation => 'Estimativa de duração';

  @override
  String get showGraphLimit => 'Mostrar limite do gráfico';

  @override
  String get defaultGraphMetric => 'Métrica predefinida do gráfico';

  @override
  String get bestWeight => 'Maior peso';

  @override
  String get bestReps => 'Maior número de repetições';

  @override
  String get oneRepMax => 'Uma repetição máxima';

  @override
  String get volume => 'Volume';

  @override
  String get paceCardio => 'Ritmo (cardio)';

  @override
  String get distanceCardio => 'Distância (cardio)';

  @override
  String get defaultGraphPeriod => 'Período predefinido do gráfico';

  @override
  String get defaultGraphLimit => 'Limite predefinido do gráfico';

  @override
  String get workouts => 'Treinos';

  @override
  String get actionStop => 'Parar';

  @override
  String get timerFinishedToast => 'Temporizador concluído!';

  @override
  String get stopTimer => 'Parar temporizador';

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
  String get addOneMinuteNotification => 'Adicionar 1 min';

  @override
  String get restTimer => 'Temporizador de descanso';

  @override
  String get timerUp => 'Tempo esgotado';

  @override
  String get openNotification => 'Abrir notificação';

  @override
  String get timerChannelName => 'Canal do temporizador';

  @override
  String get timerChannelDescription =>
      'Progresso contínuo dos temporizadores de descanso.';

  @override
  String get timerFinishedChannelName => 'Canal de temporizador concluído';

  @override
  String get timerFinishedChannelDescription =>
      'Toca um alarme quando um temporizador de descanso termina.';

  @override
  String get timerFinished => 'Temporizador concluído';

  @override
  String get batteryOptimizationRequestUnavailable =>
      'Os pedidos para ignorar otimizações da bateria estão desativados no seu dispositivo.';

  @override
  String get exactAlarmRequestUnavailable =>
      'O pedido SCHEDULE_EXACT_ALARM foi rejeitado no seu dispositivo';

  @override
  String get databaseMigrationFailureDescription =>
      'Algo correu mal ao criar ou atualizar a sua base de dados. Em geral, isto pode ser corrigido eliminando e recriando os seus registos.';

  @override
  String get curveSmoothness => 'Suavidade das curvas';

  @override
  String get actionBack => 'Voltar';

  @override
  String get atLeastOneTab => 'Precisa de pelo menos um separador';

  @override
  String get invalidTabSettings => 'Definições de separadores inválidas.';

  @override
  String get noSettingsFound => 'Nenhuma definição encontrada';

  @override
  String nothingMatchesSearch(String query) {
    return 'Nada corresponde a “$query”.';
  }

  @override
  String get appearanceDescription => 'Tema, cores e estilo da interface';

  @override
  String get dataManagementDescription =>
      'Importe, exporte e faça a gestão dos seus dados de treino';

  @override
  String get formatsDescription => 'Datas, números e formatação de medidas';

  @override
  String get plansSettingsDescription =>
      'Predefinições e comportamento dos planos de treino';

  @override
  String get tabsDescription =>
      'Escolha e organize os separadores principais de navegação';

  @override
  String get timersDescription =>
      'Duração, som e comportamento do temporizador de descanso';

  @override
  String get workoutsDescription =>
      'Preferências de exercícios e acompanhamento de treinos';

  @override
  String get completeSetForChart =>
      'Conclua uma série deste exercício para criar o gráfico.';

  @override
  String get dateRange => 'Intervalo de datas';

  @override
  String get stopDate => 'Data final';

  @override
  String get dataPoints => 'Pontos de dados';

  @override
  String get completeSetsForProgress =>
      'Conclua algumas séries para criar seu gráfico de progresso.';

  @override
  String get relativeStrength => 'Força relativa';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selecionados',
      one: '1 selecionado',
    );
    return '$_temp0';
  }

  @override
  String get completeSetsForHistory =>
      'Conclua algumas séries para ver aqui o histórico deste exercício.';

  @override
  String get completeSetForFirstGraph =>
      'Conclua uma série para criar seu primeiro gráfico de exercício.';

  @override
  String nothingMatchesGraphSearch(String query) {
    return 'Nada corresponde a “$query”. Pode criá-lo como um novo exercício.';
  }

  @override
  String addNamed(String name) {
    return 'Adicionar “$name”';
  }

  @override
  String deleteGraphRecordsConfirmation(int count) {
    return 'Isto eliminará $count registos. Tem a certeza?';
  }

  @override
  String shareWorkout(String summary) {
    return 'Acabei de fazer $summary';
  }

  @override
  String get updateConflict => 'Conflito de atualização';

  @override
  String updateConflictDescription(int count) {
    return 'O novo nome já existe em $count registos. Pretende continuar?';
  }

  @override
  String get unitsConflict => 'Conflito de unidades';

  @override
  String unitsConflictDescription(String unit) {
    return 'Nem todos os seus registos utilizam a mesma unidade. Isto converterá todas as unidades para $unit. Pretende continuar?';
  }

  @override
  String get durationLabel => 'Duração';

  @override
  String get inclineLabel => 'Inclinação';

  @override
  String get paceDistanceTime => 'Ritmo (distância / tempo)';

  @override
  String get adjustedPace => 'Ritmo ajustado';

  @override
  String get oneRepMaxAccuracyWarning =>
      'As estimativas de uma repetição máxima são menos precisas para séries de 10 ou mais repetições';

  @override
  String get addPlan => 'Adicionar plano';

  @override
  String get planDetails => 'Detalhes do plano';

  @override
  String get exercisesLabel => 'Exercícios';

  @override
  String get addExerciseToPlan => 'Adicione um exercício a este plano.';

  @override
  String nothingMatchesExerciseSearch(String query) {
    return 'Nada corresponde a “$query”. Pode adicioná-lo como um novo exercício.';
  }

  @override
  String get selectDays => 'Selecionar dias';

  @override
  String get selectExercises => 'Selecionar exercícios';

  @override
  String get todayLabel => 'Hoje';

  @override
  String get setDetails => 'Detalhes da série';

  @override
  String get themeLabel => 'Tema';

  @override
  String get pureBlackAmoledDescription =>
      'Usar cores em preto puro para ecrãs AMOLED';

  @override
  String get systemColorScheme => 'Esquema de cores do sistema';

  @override
  String get systemColorSchemeDescription =>
      'Usar a cor principal do seu dispositivo na aplicação';

  @override
  String get showImagesDescription =>
      'Escolher e mostrar imagens na página de histórico';

  @override
  String get showGlobalProgress => 'Mostrar progresso geral';

  @override
  String get showGlobalProgressDescription =>
      'Adicionar ao gráfico uma entrada que mostre o seu progresso por categoria';

  @override
  String get peekGraphDescription =>
      'Mostrar o primeiro gráfico de linhas na página de gráficos';

  @override
  String get inputStyleDescription => 'Estilo visual dos campos de texto';

  @override
  String get automaticBackupNotificationBody =>
      'O Flexify fará uma cópia de segurança automática dos seus dados e imagens na pasta selecionada todos os dias.';

  @override
  String get backupSettingsChannel => 'Definições de cópia de segurança';

  @override
  String get backupSettingsChannelDescription =>
      'Notificações que explicam as cópias de segurança automáticas';

  @override
  String get backupChannelName => 'Canal de cópia de segurança';

  @override
  String get backupChannelDescription =>
      'Cópias de segurança automáticas dos dados e imagens do Flexify';

  @override
  String get backupCompletedTitle =>
      'Cópia de segurança dos dados e imagens concluída';

  @override
  String get backupFailurePathNotSet =>
      'Falha na cópia de segurança: caminho da cópia de segurança não definido. Cópias de segurança automáticas desativadas.';

  @override
  String get backupFailureDirectoryUnavailable =>
      'Falha na cópia de segurança: não foi possível aceder à pasta da cópia de segurança. Cópias de segurança automáticas desativadas.';

  @override
  String get backupFailureCreateFile =>
      'Falha na cópia de segurança: não foi possível criar o ficheiro de cópia de segurança. Cópias de segurança automáticas desativadas.';

  @override
  String get backupFailureAppFilesUnavailable =>
      'Falha na cópia de segurança: não foi possível aceder à pasta de ficheiros da aplicação. Cópias de segurança automáticas desativadas.';

  @override
  String get backupFailureDatabaseMissing =>
      'Falha na cópia de segurança: ficheiro da base de dados não encontrado. Cópias de segurança automáticas desativadas.';

  @override
  String get backupFailureOutputUnavailable =>
      'Falha na cópia de segurança: não foi possível abrir o fluxo de saída. Cópias de segurança automáticas desativadas.';

  @override
  String get backupFailureUnknown =>
      'Falha na cópia de segurança. Cópias de segurança automáticas desativadas.';

  @override
  String get appPermissionsDescription =>
      'Reveja o acesso exigido pelas funcionalidades que ativou';

  @override
  String get longDateFormatDescription => 'Usado onde há bastante espaço';

  @override
  String shortDateFormat(String example) {
    return 'Formato de data curta ($example)';
  }

  @override
  String get shortDateFormatDescription =>
      'Usado onde há pouco espaço (linhas dos gráficos)';

  @override
  String get warmupSetsDescription =>
      'Séries de aquecimento não têm temporizadores de descanso';

  @override
  String get setsPerExerciseDescription =>
      'Número predefinido de séries por exercício';

  @override
  String get planTrailingDisplay => 'Apresentação à direita do plano';

  @override
  String get planTrailingDisplayDescription =>
      'Conteúdo apresentado à direita da lista em Planos e na vista do plano';

  @override
  String get restTimersDescription =>
      'Alarme que dispara após concluir uma série';

  @override
  String get vibrateDescription =>
      'Os temporizadores de descanso devem vibrar?';

  @override
  String get enableSoundDescription =>
      'Os temporizadores de descanso devem reproduzir um som?';

  @override
  String get keepScreenOnDescription =>
      'Manter o ecrã ligado durante os temporizadores de descanso';

  @override
  String get restDurationDescription =>
      'Quanto tempo esperar antes de ativar os alarmes de descanso?';

  @override
  String get globalDefault => 'Padrão geral';

  @override
  String get alarmSoundDescription =>
      'Som reproduzido no final de um temporizador de descanso';

  @override
  String get progressBarPosition => 'Posição da barra de progresso';

  @override
  String get progressBarPositionDescription =>
      'Onde deve ficar a barra de progresso dos temporizadores de descanso?';

  @override
  String get perExerciseRestTimes => 'Tempos de descanso por exercício';

  @override
  String get perExerciseRestTimesDescription =>
      'Estes exercícios têm durações de descanso personalizadas';

  @override
  String get audioFeaturesUnavailable =>
      'Funcionalidades de áudio indisponíveis';

  @override
  String get groupHistoryDescription =>
      'Combinar registos do histórico por dia';

  @override
  String get showUnitsDescription =>
      'Mostrar km/mi e kg/lb em gráficos, histórico e planos';

  @override
  String get showBodyWeightDescription =>
      'Ativar ou desativar o acompanhamento do peso corporal';

  @override
  String get showCategoriesDescription =>
      'Ativar ou desativar categorias de treino';

  @override
  String get showNotesDescription =>
      'Registar detalhes do seu exercício numa área de texto';

  @override
  String get positiveReinforcement => 'Reforço positivo';

  @override
  String get positiveNotificationsDescription =>
      'Mostrar mensagens positivas quando for atingido um novo recorde';

  @override
  String get positiveMessagesEnabled =>
      'Agora as mensagens positivas aparecem assim!';

  @override
  String get recordEncouragement01 => 'Excelente trabalho! Está incrível.';

  @override
  String get recordEncouragement02 =>
      'Muito bem, rei! O seu progresso é inspirador.';

  @override
  String get recordEncouragement03 => 'Faço-lhe uma vénia...';

  @override
  String get recordEncouragement04 => 'O que é isto? Um novo recorde!';

  @override
  String get recordEncouragement05 => 'Incrível! É uma inspiração.';

  @override
  String get recordEncouragement06 => 'Uau. Muito bom.';

  @override
  String get recordEncouragement07 => 'A ficar forte, hein?';

  @override
  String get recordEncouragement08 => 'Sim. Está a ficar enorme.';

  @override
  String get recordEncouragement09 => 'Impressionante. Incrível.';

  @override
  String get recordEncouragement10 => 'O Arnie ficaria orgulhoso.';

  @override
  String get recordEncouragement11 => 'Ronnie C olha para si com orgulho.';

  @override
  String get recordEncouragement12 => 'ISSO! PESO LEVE, BEBÉ!!!!!!!';

  @override
  String get recordEncouragement13 =>
      'É um novo recorde? Eu sabia que conseguia.';

  @override
  String get recordEncouragement14 =>
      'Excelente trabalho! Tenho orgulho em si.';

  @override
  String get recordEncouragement15 => 'É isso! Peso leve!';

  @override
  String get recordEncouragement16 => 'Continue assim! Excelente progresso.';

  @override
  String get recordEncouragement17 => 'Está a ir muito bem.';

  @override
  String get recordEncouragement18 => 'Esse é o meu rapaz!';

  @override
  String get recordEncouragement19 => 'Continue assim.';

  @override
  String get recordEncouragement20 => 'Está a ficar muito forte.';

  @override
  String get recordEncouragement21 => 'Poderoso.';

  @override
  String get recordEncouragement22 => 'Isto é força!';

  @override
  String get recordEncouragement23 => 'Tenho orgulho em si.';

  @override
  String get recordEncouragement24 => 'Continue com o excelente trabalho.';

  @override
  String get recordEncouragement25 =>
      'Cabeça erguida! Acabou de bater um novo recorde.';

  @override
  String get recordEncouragement26 =>
      'Novo recorde! Acabou de chegar mais longe do que nunca!';

  @override
  String get recordEncouragement27 => 'Isso! É recorde.';

  @override
  String get recordEncouragement28 => 'Uau! Novo recorde!';

  @override
  String get recordEncouragement29 => 'Muito bom mesmo.';

  @override
  String get repEstimationDescription =>
      'Tentar prever quantas repetições acabou de fazer';

  @override
  String get durationEstimationDescription =>
      'Tentar prever a duração do seu cardio';

  @override
  String get showGraphXAxisToggle => 'Mostrar opção do eixo X do gráfico';

  @override
  String get showGraphXAxisToggleDescription =>
      'Mostrar nos gráficos a opção de eixo X baseado em tempo';

  @override
  String get showGraphLimitDescription =>
      'Mostrar o controlo deslizante de limite nos gráficos';

  @override
  String get defaultTimeBasedXAxis =>
      'Eixo X baseado em tempo por predefinição';

  @override
  String get defaultTimeBasedXAxisDescription =>
      'Usar o eixo X baseado em tempo por predefinição nos gráficos';

  @override
  String get createFirstTrainingPlan =>
      'Crie seu primeiro plano de treino para começar.';

  @override
  String nothingMatchesPlanSearch(String query) {
    return 'Nada corresponde a “$query”. Pode criá-lo como um novo plano.';
  }

  @override
  String get createPlan => 'Criar plano';

  @override
  String createNamedPlan(String name) {
    return 'Criar “$name”';
  }

  @override
  String setNumber(int number) {
    return 'Série $number';
  }
}
