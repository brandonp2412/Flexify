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
  String errorWithMessage(String error) {
    return 'Erro: $error';
  }

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
  String get categoryHelper => 'Grupo muscular, por exemplo Peito ou Pernas';

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
  String errorWithMessage(String error) {
    return 'Erro: $error';
  }

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
  String get categoryHelper => 'Grupo muscular, por exemplo Peito ou Pernas';

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
