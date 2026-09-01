import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart' as app;
import 'package:flexify/plan/plan_tile.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_progress_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

const _allTabs = 'HistoryPage,PlansPage,GraphsPage,TimerPage,SettingsPage';

Future<SettingsState> _pumpIsolatedApp(
  WidgetTester tester, {
  Size? surfaceSize,
}) async {
  if (surfaceSize != null) {
    await tester.binding.setSurfaceSize(surfaceSize);
    addTearDown(() => tester.binding.setSurfaceSize(null));
  }

  final database = AppDatabase(
    DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ),
  );
  app.db = database;
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await database.close();
  });

  await database.settings.update().write(
    const SettingsCompanion(
      tabs: Value(_allTabs),
      explainedPermissions: Value(true),
      notificationPermissionRequested: Value(true),
      restTimers: Value(false),
      notifications: Value(false),
      groupHistory: Value(false),
      showBodyWeight: Value(true),
      showCategories: Value(true),
      showNotes: Value(true),
      showUnits: Value(true),
      scrollableTabs: Value(true),
      systemColors: Value(false),
    ),
  );

  final setting = await (database.settings.select()..limit(1)).getSingle();
  final settingsState = SettingsState(setting);

  await tester.pumpWidget(app.appProviders(settingsState));
  await tester.pumpAndSettle();
  return settingsState;
}

Future<void> _tapTab(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(Key(key)));
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

Future<void> _openSettings(WidgetTester tester) async {
  await _tapTab(tester, 'SettingsPage');
  expect(find.text('Settings'), findsWidgets);
}

Future<void> _openSettingsSection(WidgetTester tester, String section) async {
  await _openSettings(tester);
  final sectionFinder = find.text(section);
  await tester.ensureVisible(sectionFinder);
  await tester.pumpAndSettle();
  await tester.tap(sectionFinder);
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

Finder _textFieldWithLabel(String label) => find.byWidgetPredicate(
  (widget) => widget is TextField && widget.decoration?.labelText == label,
);

Finder _dropdownWithLabel(String label) => find.byWidgetPredicate(
  (widget) =>
      widget is DropdownButtonFormField &&
      widget.decoration.labelText?.startsWith(label) == true,
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetController.hitTestWarningShouldBeFatal = true;

  testWidgets('Linux desktop renders every primary tab', (tester) async {
    await _pumpIsolatedApp(tester);

    for (final tab in const [
      'HistoryPage',
      'PlansPage',
      'GraphsPage',
      'TimerPage',
      'SettingsPage',
    ]) {
      await _tapTab(tester, tab);
    }
  });

  testWidgets('Linux desktop can swipe through every primary tab', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester);
    final tabs = find.byType(TabBarView);

    for (var i = 0; i < 4; i++) {
      await tester.drag(tabs, const Offset(-700, 0));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }

    for (var i = 0; i < 4; i++) {
      await tester.drag(tabs, const Offset(700, 0));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Plans add flow uses human-readable labels', (tester) async {
    await _pumpIsolatedApp(tester);
    await _tapTab(tester, 'PlansPage');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Search exercises...'), findsOneWidget);
    expect(find.textContaining('_exercises'), findsNothing);
    expect(find.textContaining('_days'), findsNothing);
  });

  testWidgets('Plans save validation uses human-readable copy', (tester) async {
    await _pumpIsolatedApp(tester);
    await _tapTab(tester, 'PlansPage');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Select days'), findsOneWidget);
    expect(find.textContaining('_days'), findsNothing);
    app.rootScaffoldMessenger.currentState!.removeCurrentSnackBar();
    await tester.pumpAndSettle();
    await tester.enterText(
      _textFieldWithLabel('Title (optional)'),
      'Validation only',
    );
    final enabledExerciseSwitches = tester
        .widgetList<Switch>(find.byType(Switch))
        .where((widget) => widget.value)
        .length;
    expect(enabledExerciseSwitches, 0);
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('Select exercises'), findsOneWidget);
  });

  testWidgets('History add flow uses body weight label', (tester) async {
    await _pumpIsolatedApp(tester);
    await _tapTab(tester, 'HistoryPage');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Body weight ('), findsOneWidget);
    expect(find.textContaining('Body _weight'), findsNothing);
  });

  testWidgets('History cardio switch preserves the selected unit', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester);
    await _tapTab(tester, 'HistoryPage');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    final cardioTile = find.widgetWithText(ListTile, 'Cardio');
    final cardioSwitch = find.descendant(
      of: cardioTile,
      matching: find.byType(Switch),
    );
    await tester.tap(cardioSwitch);
    await tester.pumpAndSettle();

    expect(find.text('Weight (kg)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Graph add exercise cardio switch preserves the selected unit', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester);
    await _tapTab(tester, 'GraphsPage');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    final cardioTile = find.widgetWithText(ListTile, 'Strength');
    final cardioSwitch = find.descendant(
      of: cardioTile,
      matching: find.byType(Switch),
    );
    await tester.tap(cardioSwitch);
    await tester.pumpAndSettle();

    final dropdown = tester.widget<DropdownButtonFormField<String>>(
      find.byType(DropdownButtonFormField<String>),
    );
    expect(dropdown.initialValue, 'kg');
  });

  testWidgets('Settings empty search result uses normal copy', (tester) async {
    await _pumpIsolatedApp(tester);
    await _openSettings(tester);

    await tester.enterText(find.byType(SearchBar), 'zzzz-no-match');
    await tester.pumpAndSettle();

    expect(find.text('No settings found'), findsOneWidget);
    expect(find.textContaining('_settings'), findsNothing);
  });

  testWidgets('Tab settings uses human-readable copy', (tester) async {
    await _pumpIsolatedApp(tester);
    await _openSettingsSection(tester, 'Tabs');

    expect(find.text('Swipe between tabs'), findsOneWidget);
    expect(find.textContaining('_tabs'), findsNothing);
  });

  testWidgets('Tab settings can disable and re-enable a tab', (tester) async {
    await _pumpIsolatedApp(tester);
    await _openSettingsSection(tester, 'Tabs');

    await tester.tap(find.byKey(const Key('GraphsPage')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('GraphsPage')), findsOneWidget);

    await tester.tap(find.byKey(const Key('GraphsPage')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Disabled swipe keeps tab fixed while click navigation works', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 700));
    await _openSettingsSection(tester, 'Tabs');
    await tester.tap(find.text('Swipe between tabs'));
    await tester.pumpAndSettle();
    var settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.scrollableTabs, isFalse);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await _tapTab(tester, 'HistoryPage');
    expect(find.text('No entries yet'), findsOneWidget);
    await tester.drag(find.byType(TabBarView), const Offset(-700, 0));
    await tester.pumpAndSettle();
    expect(find.text('No entries yet'), findsOneWidget);
    expect(find.byType(PlanTile), findsNothing);

    await _tapTab(tester, 'PlansPage');
    expect(find.byType(PlanTile), findsWidgets);
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.scrollableTabs, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Tab drag reorder persists navigation order', (tester) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await _openSettingsSection(tester, 'Tabs');
    final historyHandle = find.descendant(
      of: find.byKey(const Key('HistoryPage')),
      matching: find.byIcon(Icons.drag_handle),
    );
    await tester.drag(historyHandle, const Offset(0, 150));
    await tester.pumpAndSettle();

    final settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.tabs, isNot(_allTabs));
    expect(settings.tabs.split(',').toSet(), _allTabs.split(',').toSet());
    expect(tester.takeException(), isNull);
  });

  testWidgets('Repeated Linux resize and navigation remains stable', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    for (final size in const [
      Size(640, 480),
      Size(1000, 700),
      Size(480, 360),
      Size(800, 500),
    ]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpAndSettle();
      for (final tab in const [
        'HistoryPage',
        'PlansPage',
        'GraphsPage',
        'TimerPage',
        'SettingsPage',
      ]) {
        await _tapTab(tester, tab);
      }
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('Long-press tab removal updates home navigation safely', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester);

    await tester.longPress(find.byKey(const Key('GraphsPage')));
    await tester.pumpAndSettle();
    expect(find.text('Remove Graphs tab?'), findsOneWidget);
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('GraphsPage')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Timer settings open and close on Linux', (tester) async {
    await _pumpIsolatedApp(tester);
    await _openSettingsSection(tester, 'Timers');
    expect(find.text('Timers'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Timer page nested settings back works on Linux', (tester) async {
    await _pumpIsolatedApp(tester);
    await _tapTab(tester, 'TimerPage');

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Start'), findsOneWidget);
  });

  testWidgets('Rest timer setting does not call Android APIs on Linux', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester);
    await _openSettingsSection(tester, 'Timers');

    final restTimers = find.widgetWithText(ListTile, 'Rest timers');
    await tester.tap(restTimers);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Appearance settings render without overflow on desktop', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(640, 480));
    await _openSettingsSection(tester, 'Appearance');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Plan settings render without overflow on desktop', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(640, 480));
    await _openSettingsSection(tester, 'Plans');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Format settings render without overflow on desktop', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(640, 480));
    await _openSettingsSection(tester, 'Formats');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Workout settings render without overflow on desktop', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(640, 480));
    await _openSettingsSection(tester, 'Workouts');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Plan settings accept an empty warmup set value', (tester) async {
    await _pumpIsolatedApp(tester);
    await _openSettingsSection(tester, 'Plans');

    final field = _textFieldWithLabel('Warmup sets');
    await tester.enterText(field, '');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Plan settings accept non-numeric warmup input', (tester) async {
    await _pumpIsolatedApp(tester);
    await _openSettingsSection(tester, 'Plans');

    final field = _textFieldWithLabel('Warmup sets');
    await tester.enterText(field, 'abc');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Plan settings accept an empty working set value', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester);
    await _openSettingsSection(tester, 'Plans');

    final field = _textFieldWithLabel('Sets per exercise (max: 20)');
    await tester.enterText(field, '');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Plan search finds plans by exercise name', (tester) async {
    await _pumpIsolatedApp(tester);
    await _tapTab(tester, 'PlansPage');

    await tester.enterText(find.byType(SearchBar), 'Squat');
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('1')), findsOneWidget);
    expect(find.byKey(const Key('2')), findsNothing);
    expect(find.byKey(const Key('3')), findsNothing);
    expect(find.text('No plans found'), findsNothing);
  });

  testWidgets('Plan search treats percent as literal text', (tester) async {
    await _pumpIsolatedApp(tester);
    await _tapTab(tester, 'PlansPage');

    await tester.enterText(find.byType(SearchBar), '%');
    await tester.pumpAndSettle();

    expect(find.text('No plans found'), findsOneWidget);
  });

  testWidgets('Plan search treats underscore as literal text', (tester) async {
    await _pumpIsolatedApp(tester);
    await _tapTab(tester, 'PlansPage');

    await tester.enterText(find.byType(SearchBar), '_');
    await tester.pumpAndSettle();

    expect(find.text('No plans found'), findsOneWidget);
  });

  testWidgets('Per-exercise working set input tolerates invalid text', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester);
    await _tapTab(tester, 'PlansPage');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    final settingsButtons = find.byIcon(Icons.settings);
    expect(settingsButtons, findsWidgets);
    await tester.tap(settingsButtons.first);
    await tester.pumpAndSettle();

    await tester.enterText(
      _textFieldWithLabel('Working sets (max: 20)'),
      'abc',
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Global progress opens on Linux desktop', (tester) async {
    await _pumpIsolatedApp(tester);
    await app.db.settings.update().write(
      const SettingsCompanion(showGlobalProgress: Value(true)),
    );
    await tester.pumpAndSettle();
    await _tapTab(tester, 'GraphsPage');

    await tester.tap(find.text('Global progress'));
    await tester.pumpAndSettle();
    expect(find.text('Global progress'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Graph history opens on Linux desktop', (tester) async {
    await _pumpIsolatedApp(tester);
    await _tapTab(tester, 'GraphsPage');

    await tester.tap(find.text('Barbell bench press'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Graph selection, curve options, and history multi-delete work', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester);
    final now = DateTime(2026, 8, 30, 12);
    for (var index = 0; index < 2; index++) {
      await app.db
          .into(app.db.gymSets)
          .insert(
            GymSetsCompanion.insert(
              name: 'Selection E2E',
              reps: (5 + index).toDouble(),
              weight: (50 + index).toDouble(),
              unit: 'kg',
              created: now.subtract(Duration(days: index)),
            ),
          );
    }
    await _tapTab(tester, 'GraphsPage');
    await tester.enterText(find.byType(SearchBar), 'Selection E2E');
    await tester.pumpAndSettle();

    await tester.longPress(find.widgetWithText(ListTile, 'Selection E2E'));
    await tester.pumpAndSettle();
    expect(find.text('S'), findsOneWidget);
    await tester.tap(find.text('S'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ListTile, 'Selection E2E'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();
    expect(find.text('Curve line graphs'), findsOneWidget);
    expect(find.text('Curve smoothness'), findsOneWidget);
    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsNWidgets(2));
    await tester.longPress(find.byType(ListTile).first);
    await tester.pumpAndSettle();
    expect(find.text('1 selected'), findsOneWidget);
    expect(find.text('S'), findsNWidgets(2));
    await tester.tap(find.byKey(const ValueKey('selectAllGraphHistory')));
    await tester.pumpAndSettle();
    expect(find.text('2 selected'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('deleteGraphHistorySelection')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('2 selected'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('clearGraphHistorySelection')));
    await tester.pumpAndSettle();

    await tester.longPress(find.byType(ListTile).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ListTile).last);
    await tester.pumpAndSettle();
    expect(find.text('2 selected'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('deleteGraphHistorySelection')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.text('No data yet for Selection E2E'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Graph sort, category filter, global progress, and hide work', (
    tester,
  ) async {
    final settingsState = await _pumpIsolatedApp(
      tester,
      surfaceSize: const Size(1000, 950),
    );
    await app.db.settings.update().write(
      const SettingsCompanion(showGlobalProgress: Value(true)),
    );
    final now = DateTime.now();
    await app.db.gymSets.insertAll([
      GymSetsCompanion.insert(
        name: 'Linux E2E graph Zebra',
        reps: 5,
        weight: 60,
        unit: 'kg',
        created: now.subtract(const Duration(days: 2)),
        category: const Value('Linux Cat B'),
      ),
      GymSetsCompanion.insert(
        name: 'Linux E2E graph Alpha',
        reps: 6,
        weight: 65,
        unit: 'kg',
        created: now.subtract(const Duration(days: 1)),
        category: const Value('Linux Cat A'),
      ),
      GymSetsCompanion.insert(
        name: 'Linux E2E graph Beta',
        reps: 7,
        weight: 70,
        unit: 'kg',
        created: now,
        category: const Value('Linux Cat A'),
      ),
    ]);
    await tester.pumpAndSettle();
    expect(settingsState.value.showGlobalProgress, isTrue);
    await _tapTab(tester, 'GraphsPage');
    expect(find.text('Global progress'), findsOneWidget);
    await tester.enterText(find.byType(SearchBar), 'Linux E2E graph');
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Filter'));
    await tester.pumpAndSettle();
    await tester.tap(_dropdownWithLabel('Sort by'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Name').last);
    await tester.pumpAndSettle();
    var alphaY = tester.getTopLeft(find.text('Linux E2E graph Alpha')).dy;
    var betaY = tester.getTopLeft(find.text('Linux E2E graph Beta')).dy;
    var zebraY = tester.getTopLeft(find.text('Linux E2E graph Zebra')).dy;
    expect(alphaY, lessThan(betaY));
    expect(betaY, lessThan(zebraY));

    await tester.tap(find.byTooltip('Filter'));
    await tester.pumpAndSettle();
    await tester.tap(_dropdownWithLabel('Sort by'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Date (newest)').last);
    await tester.pumpAndSettle();
    alphaY = tester.getTopLeft(find.text('Linux E2E graph Alpha')).dy;
    betaY = tester.getTopLeft(find.text('Linux E2E graph Beta')).dy;
    zebraY = tester.getTopLeft(find.text('Linux E2E graph Zebra')).dy;
    expect(betaY, lessThan(alphaY));
    expect(alphaY, lessThan(zebraY));

    await tester.tap(find.byTooltip('Filter'));
    await tester.pumpAndSettle();
    await tester.tap(_dropdownWithLabel('Sort by'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Date (oldest)').last);
    await tester.pumpAndSettle();
    alphaY = tester.getTopLeft(find.text('Linux E2E graph Alpha')).dy;
    betaY = tester.getTopLeft(find.text('Linux E2E graph Beta')).dy;
    zebraY = tester.getTopLeft(find.text('Linux E2E graph Zebra')).dy;
    expect(zebraY, lessThan(alphaY));
    expect(alphaY, lessThan(betaY));

    await tester.tap(find.byTooltip('Filter'));
    await tester.pumpAndSettle();
    await tester.tap(_dropdownWithLabel('Category'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Linux Cat A').last);
    await tester.pumpAndSettle();
    expect(find.text('Linux E2E graph Alpha'), findsOneWidget);
    expect(find.text('Linux E2E graph Beta'), findsOneWidget);
    expect(find.text('Linux E2E graph Zebra'), findsNothing);
    expect(find.text('Global progress'), findsNothing);

    await tester.tap(find.byTooltip('Filter'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Clear'));
    await tester.pumpAndSettle();
    expect(find.text('Linux E2E graph Zebra'), findsOneWidget);
    expect(settingsState.value.showGlobalProgress, isTrue);
    final clearSearch = find.descendant(
      of: find.byType(SearchBar),
      matching: find.byIcon(Icons.arrow_back),
    );
    await tester.tap(clearSearch);
    await tester.pumpAndSettle();
    expect(find.text('Global progress'), findsOneWidget);

    await tester.tap(find.text('Global progress'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Best weight'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Volume').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Week'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Options'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pounds (lb)').last);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Slider).first, const Offset(100, 0));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.longPress(find.text('Global progress'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Hide global progress'));
    await tester.pumpAndSettle();
    expect(find.text('Global progress'), findsNothing);
    final settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.showGlobalProgress, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Automatic backup is hidden on Linux', (tester) async {
    await _pumpIsolatedApp(tester);
    await _openSettingsSection(tester, 'Data management');

    expect(find.text('Automatic backup'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Primary tabs survive a compact Linux window', (tester) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(480, 360));

    for (final tab in const [
      'HistoryPage',
      'PlansPage',
      'GraphsPage',
      'TimerPage',
      'SettingsPage',
    ]) {
      await _tapTab(tester, tab);
    }
  });

  testWidgets('History strength CRUD propagates to Graphs', (tester) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await _tapTab(tester, 'HistoryPage');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    await tester.enterText(find.bySemanticsLabel('Name'), 'Linux E2E press');
    await tester.enterText(find.bySemanticsLabel('Reps'), '8');
    await tester.enterText(find.bySemanticsLabel('Weight (kg)'), '72.5');
    await tester.enterText(find.bySemanticsLabel('Body weight (kg)'), '81.2');
    await tester.enterText(find.bySemanticsLabel('Category'), 'E2E Chest');
    await tester.enterText(
      find.bySemanticsLabel('Notes'),
      'Linux strength CRUD',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    var row =
        await (app.db.gymSets.select()
              ..where((tbl) => tbl.name.equals('Linux E2E press')))
            .getSingle();
    expect(row.reps, 8);
    expect(row.weight, 72.5);
    expect(row.bodyWeight, 81.2);
    expect(row.category, 'E2E Chest');
    expect(row.notes, 'Linux strength CRUD');
    expect(find.text('Linux E2E press'), findsOneWidget);

    await _tapTab(tester, 'GraphsPage');
    expect(find.text('Linux E2E press'), findsOneWidget);

    await _tapTab(tester, 'HistoryPage');
    await tester.tap(find.widgetWithText(ListTile, 'Linux E2E press'));
    await tester.pumpAndSettle();
    await tester.enterText(find.bySemanticsLabel('Reps'), '9');
    await tester.enterText(find.bySemanticsLabel('Weight (kg)'), '77.5');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    row =
        await (app.db.gymSets.select()
              ..where((tbl) => tbl.name.equals('Linux E2E press')))
            .getSingle();
    expect(row.reps, 9);
    expect(row.weight, 77.5);

    await tester.tap(find.widgetWithText(ListTile, 'Linux E2E press'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(
      await (app.db.gymSets.select()
            ..where((tbl) => tbl.name.equals('Linux E2E press')))
          .getSingleOrNull(),
      isNotNull,
    );

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(
      await (app.db.gymSets.select()
            ..where((tbl) => tbl.name.equals('Linux E2E press')))
          .getSingleOrNull(),
      isNull,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('History cardio entry persists Linux-specific fields', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await _tapTab(tester, 'HistoryPage');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    final cardioTile = find.widgetWithText(ListTile, 'Cardio');
    await tester.ensureVisible(cardioTile);
    await tester.tap(cardioTile);
    await tester.pumpAndSettle();

    await tester.tap(_dropdownWithLabel('Unit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kilometers (km)').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.bySemanticsLabel('Name'), 'Linux E2E run');
    await tester.enterText(find.bySemanticsLabel('Distance (km)'), '5.25');
    await tester.enterText(find.bySemanticsLabel('Minutes'), '24');
    await tester.enterText(find.bySemanticsLabel('Seconds'), '30');
    await tester.enterText(find.bySemanticsLabel('Incline %'), '3');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final row =
        await (app.db.gymSets.select()
              ..where((tbl) => tbl.name.equals('Linux E2E run')))
            .getSingle();
    expect(row.cardio, isTrue);
    expect(row.unit, 'km');
    expect(row.distance, 5.25);
    expect(row.duration, 24.5);
    expect(row.incline, 3);

    await tester.tap(find.widgetWithText(ListTile, 'Linux E2E run'));
    await tester.pumpAndSettle();
    await tester.enterText(find.bySemanticsLabel('Distance (km)'), '6.5');
    await tester.enterText(find.bySemanticsLabel('Minutes'), '30');
    await tester.enterText(find.bySemanticsLabel('Seconds'), '15');
    await tester.enterText(find.bySemanticsLabel('Incline %'), '4');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final edited =
        await (app.db.gymSets.select()
              ..where((tbl) => tbl.name.equals('Linux E2E run')))
            .getSingle();
    expect(edited.distance, 6.5);
    expect(edited.duration, 30.25);
    expect(edited.incline, 4);
    expect(edited.cardio, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Grouped History and start-date filter behave correctly', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(1000, 900));
    final now = DateTime.now();
    await app.db.gymSets.insertAll([
      GymSetsCompanion.insert(
        name: 'Linux E2E grouped',
        reps: 5,
        weight: 50,
        unit: 'kg',
        created: now.subtract(const Duration(hours: 1)),
      ),
      GymSetsCompanion.insert(
        name: 'Linux E2E grouped',
        reps: 6,
        weight: 52,
        unit: 'kg',
        created: now.subtract(const Duration(hours: 2)),
      ),
      GymSetsCompanion.insert(
        name: 'Linux E2E old',
        reps: 7,
        weight: 55,
        unit: 'kg',
        created: now.subtract(const Duration(days: 3)),
      ),
    ]);
    await app.db.settings.update().write(
      const SettingsCompanion(groupHistory: Value(true)),
    );
    await tester.pumpAndSettle();
    await _tapTab(tester, 'HistoryPage');

    expect(find.text('Linux E2E grouped (2)'), findsOneWidget);
    await tester.tap(find.text('Linux E2E grouped (2)'));
    await tester.pumpAndSettle();
    expect(find.text('5 x 50 kg'), findsOneWidget);
    expect(find.text('6 x 52 kg'), findsOneWidget);

    await tester.tap(find.byTooltip('Filter'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Start date'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('${now.day}').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Linux E2E old (1)'), findsNothing);
    expect(find.text('Linux E2E grouped (2)'), findsOneWidget);

    await tester.tap(find.byTooltip('Filter'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Clear'));
    await tester.pumpAndSettle();
    expect(find.text('Linux E2E old (1)'), findsOneWidget);

    if (find.text('5 x 50 kg').evaluate().isEmpty) {
      await tester.tap(find.text('Linux E2E grouped (2)'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('5 x 50 kg'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Linux E2E grouped'),
      ),
      findsOneWidget,
    );
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Starter plan can save a workout set end to end', (tester) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await _tapTab(tester, 'PlansPage');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PlanTile).first);
    await tester.pumpAndSettle();
    expect(find.text('Barbell bench press'), findsWidgets);

    await tester.enterText(find.bySemanticsLabel('Reps'), '6');
    await tester.enterText(find.bySemanticsLabel('Weight (kg)'), '83');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final rows =
        await (app.db.gymSets.select()..where(
              (tbl) =>
                  tbl.name.equals('Barbell bench press') & tbl.planId.equals(1),
            ))
            .get();
    expect(rows, hasLength(1));
    expect(rows.single.reps, 6);
    expect(rows.single.weight, 83);
    expect(find.text('Set 1'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await _tapTab(tester, 'GraphsPage');
    expect(find.text('Barbell bench press'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Plan auto-advances across exercises and survives re-entry', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(1000, 1000));
    await app.db.settings.update().write(
      const SettingsCompanion(maxSets: Value(1)),
    );
    await tester.pumpAndSettle();
    final plan = await (app.db.plans.select()..where((tbl) => tbl.id.equals(1)))
        .getSingle();
    final exercises =
        await (app.db.planExercises.select()
              ..where((tbl) => tbl.planId.equals(plan.id) & tbl.enabled)
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.sequence)]))
            .get();
    expect(exercises.length, greaterThanOrEqualTo(2));
    final first = exercises[0].exercise;
    final second = exercises[1].exercise;

    await _tapTab(tester, 'PlansPage');
    await tester.tap(find.byType(PlanTile).first);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<Radio<bool>>(
            find.descendant(
              of: find.byKey(Key(first)),
              matching: find.byType(Radio<bool>),
            ),
          )
          .value,
      isTrue,
    );

    await tester.enterText(find.bySemanticsLabel('Reps'), '5');
    await tester.enterText(find.bySemanticsLabel('Weight (kg)'), '60');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<Radio<bool>>(
            find.descendant(
              of: find.byKey(Key(second)),
              matching: find.byType(Radio<bool>),
            ),
          )
          .value,
      isTrue,
    );

    await tester.enterText(find.bySemanticsLabel('Reps'), '6');
    await tester.enterText(find.bySemanticsLabel('Weight (kg)'), '70');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    final logged =
        await (app.db.gymSets.select()..where(
              (tbl) => tbl.planId.equals(plan.id) & tbl.hidden.equals(false),
            ))
            .get();
    expect(logged.map((row) => row.name).toSet(), containsAll({first, second}));

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PlanTile).first);
    await tester.pumpAndSettle();
    expect(find.text('Set 1'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await _tapTab(tester, 'GraphsPage');
    expect(find.text(first), findsOneWidget);
    expect(find.text(second), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Active plan exercise drag reorder persists sequence', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(1000, 1000));
    await _tapTab(tester, 'PlansPage');
    final plan = await (app.db.plans.select()..where((tbl) => tbl.id.equals(1)))
        .getSingle();
    var exercises =
        await (app.db.planExercises.select()
              ..where((tbl) => tbl.planId.equals(plan.id) & tbl.enabled)
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.sequence)]))
            .get();
    expect(exercises.length, greaterThanOrEqualTo(2));
    final originalFirst = exercises.first.exercise;
    final originalSecond = exercises[1].exercise;

    await tester.tap(find.byType(PlanTile).first);
    await tester.pumpAndSettle();
    final firstHandle = find.descendant(
      of: find.byKey(Key(originalFirst)),
      matching: find.byIcon(Icons.drag_handle),
    );
    await tester.drag(firstHandle, const Offset(0, 120));
    await tester.pumpAndSettle();

    exercises =
        await (app.db.planExercises.select()
              ..where((tbl) => tbl.planId.equals(plan.id) & tbl.enabled)
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.sequence)]))
            .get();
    expect(exercises.first.exercise, originalSecond);
    expect(exercises[1].exercise, originalFirst);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Timer stopwatch and countdown controls work on Linux', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 700));
    await _tapTab(tester, 'TimerPage');

    expect(find.text('Start'), findsOneWidget);
    await tester.tap(find.text('Start'));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Pause'), findsOneWidget);
    expect(find.text('Restart'), findsOneWidget);

    await tester.tap(find.text('Pause'));
    await tester.pumpAndSettle();
    expect(find.text('Start'), findsOneWidget);
    await tester.tap(find.text('Restart'));
    await tester.pumpAndSettle();
    expect(find.text('+1 minute'), findsOneWidget);

    await tester.tap(find.text('+1 minute'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Stop'), findsOneWidget);
    expect(find.byType(TimerCircularProgressIndicator), findsOneWidget);
    await tester.tap(find.text('Stop'));
    await tester.pumpAndSettle();
    expect(find.text('Start'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Appearance changes write through live SettingsState', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await _openSettingsSection(tester, 'Appearance');

    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();
    var settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.themeMode, 'ThemeMode.light');

    final showImages = find.widgetWithText(ListTile, 'Show images');
    await tester.ensureVisible(showImages);
    await tester.tap(showImages);
    await tester.pumpAndSettle();
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.showImages, isFalse);

    await tester.ensureVisible(find.text('Outlined'));
    await tester.tap(find.text('Outlined'));
    await tester.pumpAndSettle();
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.inputStyle, 'outlined');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Format and workout settings persist through database streams', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await _openSettingsSection(tester, 'Formats');

    await tester.tap(_dropdownWithLabel('Strength unit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pounds (lb)').last);
    await tester.pumpAndSettle();
    var settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.strengthUnit, 'lb');

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Workouts'));
    await tester.pumpAndSettle();
    final showNotes = find.widgetWithText(ListTile, 'Show notes');
    await tester.ensureVisible(showNotes);
    await tester.tap(showNotes);
    await tester.pumpAndSettle();
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.showNotes, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Data management exposes Linux-safe import and export choices', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await _openSettingsSection(tester, 'Data management');

    expect(find.text('Share database'), findsNothing);
    await tester.tap(find.text('Export data'));
    await tester.pumpAndSettle();
    expect(find.text('Graphs'), findsOneWidget);
    expect(find.text('Plans'), findsOneWidget);
    expect(find.text('Database'), findsOneWidget);
    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Import data'));
    await tester.pumpAndSettle();
    expect(find.text('Graphs'), findsOneWidget);
    expect(find.text('Plans'), findsOneWidget);
    expect(find.text('Database'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Graphs zero-exercise state remains usable', (tester) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await app.db.gymSets.deleteAll();
    await tester.pumpAndSettle();
    await _tapTab(tester, 'GraphsPage');
    expect(find.text('Global progress'), findsOneWidget);
    expect(find.text('No graphs found'), findsNothing);
    expect(find.text('Add'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Graph no-result flow creates a strength exercise', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await _tapTab(tester, 'GraphsPage');
    final search = find.byType(SearchBar);

    await tester.enterText(search, 'Linux E2E new strength graph');
    await tester.pumpAndSettle();
    expect(find.text('No graphs found'), findsOneWidget);
    await tester.tap(find.widgetWithText(ListTile, 'No graphs found'));
    await tester.pumpAndSettle();
    expect(find.text('Add exercise'), findsOneWidget);
    expect(find.bySemanticsLabel('Name'), findsOneWidget);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    var template =
        await (app.db.gymSets.select()
              ..where((tbl) => tbl.name.equals('Linux E2E new strength graph')))
            .getSingle();
    expect(template.hidden, isTrue);
    expect(template.cardio, isFalse);
    expect(template.unit, 'kg');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Graph no-result flow creates a distance-cardio exercise', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await _tapTab(tester, 'GraphsPage');
    await tester.enterText(
      find.byType(SearchBar),
      'Linux E2E new cardio graph',
    );
    await tester.pumpAndSettle();
    expect(find.text('No graphs found'), findsOneWidget);
    await tester.tap(find.widgetWithText(ListTile, 'No graphs found'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Strength'));
    await tester.pumpAndSettle();
    await tester.tap(_dropdownWithLabel('Unit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Miles (mi)').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final template =
        await (app.db.gymSets.select()
              ..where((tbl) => tbl.name.equals('Linux E2E new cardio graph')))
            .getSingle();
    expect(template.hidden, isTrue);
    expect(template.cardio, isTrue);
    expect(template.unit, 'mi');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Plan editor can create a weighted-cardio exercise', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(1000, 900));
    await _tapTab(tester, 'PlansPage');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    await tester.enterText(
      _textFieldWithLabel('Title (optional)'),
      'Linux E2E weighted plan',
    );
    await tester.tap(find.text('Mon'));
    await tester.tap(find.text('Wed'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(SearchBar), 'Linux E2E weighted hang');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add "Linux E2E weighted hang"'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Strength'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<DropdownButtonFormField<String>>(
            find.byType(DropdownButtonFormField<String>),
          )
          .initialValue,
      'kg',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(
      find.widgetWithText(ListTile, 'Linux E2E weighted hang'),
      findsOneWidget,
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final plan =
        await (app.db.plans.select()
              ..where((tbl) => tbl.title.equals('Linux E2E weighted plan')))
            .getSingle();
    expect(plan.days.split(',').toSet(), {'Monday', 'Wednesday'});
    final planExercise =
        await (app.db.planExercises.select()..where(
              (tbl) =>
                  tbl.planId.equals(plan.id) &
                  tbl.exercise.equals('Linux E2E weighted hang'),
            ))
            .getSingle();
    expect(planExercise.enabled, isTrue);
    final template =
        await (app.db.gymSets.select()
              ..where((tbl) => tbl.name.equals('Linux E2E weighted hang')))
            .getSingle();
    expect(template.hidden, isTrue);
    expect(template.cardio, isTrue);
    expect(template.unit, 'kg');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Graph rename conflict cancel and confirm are safe', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await app.db.gymSets.insertAll([
      GymSetsCompanion.insert(
        name: 'Linux E2E rename source',
        reps: 5,
        weight: 50,
        unit: 'kg',
        created: DateTime(2026, 9, 1, 10),
      ),
      GymSetsCompanion.insert(
        name: 'Linux E2E rename target',
        reps: 6,
        weight: 60,
        unit: 'kg',
        created: DateTime(2026, 9, 1, 11),
      ),
    ]);
    await _tapTab(tester, 'GraphsPage');
    await tester.enterText(find.byType(SearchBar), 'Linux E2E rename source');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Linux E2E rename source'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(
      _textFieldWithLabel('New name'),
      'Linux E2E rename target',
    );
    await tester.tap(find.text('Update'));
    await tester.pumpAndSettle();
    expect(find.text('Update conflict'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Update'), findsOneWidget);
    expect(
      await (app.db.gymSets.select()
            ..where((tbl) => tbl.name.equals('Linux E2E rename source')))
          .get(),
      hasLength(1),
    );

    await tester.tap(find.text('Update'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Confirm'));
    await tester.pumpAndSettle();
    expect(
      await (app.db.gymSets.select()
            ..where((tbl) => tbl.name.equals('Linux E2E rename source')))
          .get(),
      isEmpty,
    );
    expect(
      await (app.db.gymSets.select()
            ..where((tbl) => tbl.name.equals('Linux E2E rename target')))
          .get(),
      hasLength(2),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Graph select-all delete cancel and confirm work', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await app.db.gymSets.insertAll([
      GymSetsCompanion.insert(
        name: 'Linux E2E selectable graph A',
        reps: 5,
        weight: 50,
        unit: 'kg',
        created: DateTime(2026, 9, 1, 10),
      ),
      GymSetsCompanion.insert(
        name: 'Linux E2E selectable graph B',
        reps: 6,
        weight: 60,
        unit: 'kg',
        created: DateTime(2026, 9, 1, 11),
      ),
    ]);
    await _tapTab(tester, 'GraphsPage');
    await tester.enterText(
      find.byType(SearchBar),
      'Linux E2E selectable graph',
    );
    await tester.pumpAndSettle();
    await tester.longPress(
      find.widgetWithText(ListTile, 'Linux E2E selectable graph A'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Show menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Select all'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('deleteButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(
      await (app.db.gymSets.select()
            ..where((tbl) => tbl.name.contains('Linux E2E selectable graph')))
          .get(),
      hasLength(2),
    );
    await tester.tap(find.byKey(const ValueKey('deleteButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(
      await (app.db.gymSets.select()
            ..where((tbl) => tbl.name.contains('Linux E2E selectable graph')))
          .get(),
      isEmpty,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Graph bulk unit edit converts cardio distance', (tester) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await app.db.gymSets.insertOne(
      GymSetsCompanion.insert(
        name: 'Linux E2E cardio conversion',
        reps: 0,
        weight: 0,
        unit: 'km',
        created: DateTime(2026, 8, 31, 12),
        cardio: const Value(true),
        duration: const Value(50),
        distance: const Value(10),
      ),
    );
    await tester.pumpAndSettle();

    await _tapTab(tester, 'GraphsPage');
    await tester.enterText(
      find.byType(SearchBar),
      'Linux E2E cardio conversion',
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(ListTile, 'Linux E2E cardio conversion'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();

    await tester.tap(_dropdownWithLabel('Unit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Miles (mi)').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Update'));
    await tester.pumpAndSettle();

    final row =
        await (app.db.gymSets.select()
              ..where((tbl) => tbl.name.equals('Linux E2E cardio conversion')))
            .getSingle();
    expect(row.unit, 'mi');
    expect(row.distance, closeTo(6.21371, 0.0001));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Graph bulk unit edit converts strength weight', (tester) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await app.db.gymSets.insertAll([
      GymSetsCompanion.insert(
        name: 'Linux E2E strength conversion',
        reps: 5,
        weight: 100,
        unit: 'kg',
        created: DateTime(2026, 8, 31, 12),
        category: const Value('Linux Original Category'),
      ),
      GymSetsCompanion.insert(
        name: 'Linux E2E category source',
        reps: 0,
        weight: 0,
        unit: 'kg',
        created: DateTime(2026, 8, 31, 11),
        hidden: const Value(true),
        category: const Value('Linux Target Category'),
      ),
    ]);
    await tester.pumpAndSettle();

    await _tapTab(tester, 'GraphsPage');
    await tester.enterText(
      find.byType(SearchBar),
      'Linux E2E strength conversion',
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(ListTile, 'Linux E2E strength conversion'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();
    await tester.tap(_dropdownWithLabel('Category'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Linux Target Category').last);
    await tester.pumpAndSettle();
    await tester.tap(_dropdownWithLabel('Unit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pounds (lb)').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Update'));
    await tester.pumpAndSettle();

    final row =
        await (app.db.gymSets.select()..where(
              (tbl) => tbl.name.equals('Linux E2E strength conversion'),
            ))
            .getSingle();
    expect(row.unit, 'lb');
    expect(row.weight, closeTo(220.462262, 0.0001));
    expect(row.category, 'Linux Target Category');
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Graph mixed-unit conversion cancel keeps editor and data intact',
    (tester) async {
      await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
      await app.db.gymSets.insertAll([
        GymSetsCompanion.insert(
          name: 'Linux E2E mixed units',
          reps: 5,
          weight: 100,
          unit: 'kg',
          created: DateTime(2026, 8, 31, 12),
        ),
        GymSetsCompanion.insert(
          name: 'Linux E2E mixed units',
          reps: 5,
          weight: 220.462262,
          unit: 'lb',
          created: DateTime(2026, 9, 1, 12),
        ),
      ]);
      await tester.pumpAndSettle();

      await _tapTab(tester, 'GraphsPage');
      await tester.enterText(find.byType(SearchBar), 'Linux E2E mixed units');
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ListTile, 'Linux E2E mixed units'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Edit'));
      await tester.pumpAndSettle();
      await tester.tap(_dropdownWithLabel('Unit'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Stone').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();

      expect(find.text('Units conflict'), findsOneWidget);
      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Update'), findsOneWidget);
      var rows =
          await (app.db.gymSets.select()
                ..where((tbl) => tbl.name.equals('Linux E2E mixed units')))
              .get();
      expect(rows.map((row) => row.unit).toSet(), {'kg', 'lb'});

      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Confirm'));
      await tester.pumpAndSettle();
      rows =
          await (app.db.gymSets.select()
                ..where((tbl) => tbl.name.equals('Linux E2E mixed units')))
              .get();
      expect(rows.map((row) => row.unit).toSet(), {'stone'});
      for (final row in rows) {
        expect(row.weight, closeTo(15.7473, 0.001));
      }
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('History empty state and validation paths are safe', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await _tapTab(tester, 'HistoryPage');
    expect(find.text('No entries yet'), findsOneWidget);

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Required'), findsWidgets);

    await tester.enterText(find.bySemanticsLabel('Name'), 'Invalid E2E set');
    await tester.enterText(find.bySemanticsLabel('Reps'), 'abc');
    await tester.enterText(find.bySemanticsLabel('Weight (kg)'), 'xyz');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Invalid number'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('History search and numeric/category filters work', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await app.db.gymSets.insertAll([
      GymSetsCompanion.insert(
        name: 'Linux E2E filter light',
        reps: 5,
        weight: 40,
        unit: 'kg',
        created: DateTime(2026, 8, 30, 12),
        category: const Value('E2E Light'),
      ),
      GymSetsCompanion.insert(
        name: 'Linux E2E filter heavy',
        reps: 12,
        weight: 100,
        unit: 'kg',
        created: DateTime(2026, 9, 1, 12),
        category: const Value('E2E Heavy'),
      ),
    ]);
    await tester.pumpAndSettle();
    await _tapTab(tester, 'HistoryPage');

    final search = find.byType(SearchBar);
    await tester.enterText(search, 'filter heavy');
    await tester.pumpAndSettle();
    expect(find.text('Linux E2E filter heavy'), findsOneWidget);
    expect(find.text('Linux E2E filter light'), findsNothing);
    await tester.enterText(search, '');
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Filter'));
    await tester.pumpAndSettle();
    await tester.tap(_dropdownWithLabel('Category'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('E2E Heavy').last);
    await tester.pumpAndSettle();
    expect(find.text('Linux E2E filter heavy'), findsOneWidget);
    expect(find.text('Linux E2E filter light'), findsNothing);

    await tester.tap(find.byTooltip('Filter'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Clear'));
    await tester.pumpAndSettle();
    expect(find.text('Linux E2E filter light'), findsOneWidget);

    await tester.tap(find.byTooltip('Filter'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Reps'));
    await tester.pumpAndSettle();
    await tester.enterText(_textFieldWithLabel('Greater than'), '8');
    await tester.tap(find.widgetWithText(TextButton, 'OK'));
    await tester.pumpAndSettle();
    expect(find.text('Linux E2E filter heavy'), findsOneWidget);
    expect(find.text('Linux E2E filter light'), findsNothing);

    await tester.tap(find.byTooltip('Filter'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Clear'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Filter'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Weight'));
    await tester.pumpAndSettle();
    await tester.enterText(_textFieldWithLabel('Greater than'), '50');
    await tester.tap(find.widgetWithText(TextButton, 'OK'));
    await tester.pumpAndSettle();
    expect(find.text('Linux E2E filter heavy'), findsOneWidget);
    expect(find.text('Linux E2E filter light'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('History multi-select bulk edit, select-all, and delete work', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await app.db.gymSets.insertAll([
      GymSetsCompanion.insert(
        name: 'Linux E2E bulk A',
        reps: 5,
        weight: 50,
        unit: 'kg',
        created: DateTime(2026, 9, 1, 10),
      ),
      GymSetsCompanion.insert(
        name: 'Linux E2E bulk B',
        reps: 6,
        weight: 60,
        unit: 'kg',
        created: DateTime(2026, 9, 1, 11),
      ),
    ]);
    await tester.pumpAndSettle();
    await _tapTab(tester, 'HistoryPage');
    await tester.enterText(find.byType(SearchBar), 'Linux E2E bulk');
    await tester.pumpAndSettle();

    await tester.longPress(find.widgetWithText(ListTile, 'Linux E2E bulk A'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Linux E2E bulk B'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Show menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Edit'));
    await tester.pumpAndSettle();
    expect(find.text('Edit 2 sets'), findsOneWidget);
    await tester.enterText(_textFieldWithLabel('Reps'), '10');
    await tester.tap(find.text('Update'));
    await tester.pumpAndSettle();

    var rows =
        await (app.db.gymSets.select()
              ..where((tbl) => tbl.name.contains('Linux E2E bulk')))
            .get();
    expect(rows, hasLength(2));
    expect(rows.every((row) => row.reps == 10), isTrue);

    final clearSelection = find.byIcon(Icons.arrow_back);
    if (clearSelection.evaluate().isNotEmpty) {
      await tester.tap(clearSelection.first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(SearchBar), 'Linux E2E bulk');
      await tester.pumpAndSettle();
    }
    await tester.tap(find.byTooltip('Show menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Select all'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('deleteButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(
      await (app.db.gymSets.select()
            ..where((tbl) => tbl.name.contains('Linux E2E bulk')))
          .get(),
      hasLength(2),
    );

    await tester.tap(find.byKey(const ValueKey('deleteButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();
    rows =
        await (app.db.gymSets.select()
              ..where((tbl) => tbl.name.contains('Linux E2E bulk')))
            .get();
    expect(rows, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Enter Weight validates, saves unit, and backfills body weight', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    final baselineId = await app.db.gymSets.insertOne(
      GymSetsCompanion.insert(
        name: 'Linux E2E bodyweight baseline',
        reps: 5,
        weight: 50,
        unit: 'kg',
        created: DateTime(2026, 9, 1, 9),
      ),
    );
    await tester.pumpAndSettle();
    await _tapTab(tester, 'HistoryPage');
    await tester.tap(find.byTooltip('Show menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Weight'));
    await tester.pumpAndSettle();
    expect(find.text('Enter Weight'), findsOneWidget);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Required'), findsOneWidget);
    await tester.enterText(_textFieldWithLabel('Weight'), '82');
    await tester.tap(_dropdownWithLabel('Unit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pounds (lb)').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final weightRow =
        await (app.db.gymSets.select()
              ..where((tbl) => tbl.name.equals('Weight'))
              ..orderBy([(tbl) => OrderingTerm.desc(tbl.created)])
              ..limit(1))
            .getSingle();
    expect(weightRow.weight, 82);
    expect(weightRow.unit, 'lb');
    final baseline =
        await (app.db.gymSets.select()
              ..where((tbl) => tbl.id.equals(baselineId)))
            .getSingle();
    expect(baseline.bodyWeight, 82);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Plan create, title/day search, edit, select-all and delete work',
    (tester) async {
      await _pumpIsolatedApp(tester, surfaceSize: const Size(1000, 900));
      await _tapTab(tester, 'PlansPage');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();
      await tester.enterText(
        _textFieldWithLabel('Title (optional)'),
        'Linux E2E custom plan',
      );
      await tester.tap(find.text('Mon'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(SearchBar), 'Barbell bench press');
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ListTile, 'Barbell bench press'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      var plan =
          await (app.db.plans.select()
                ..where((tbl) => tbl.title.equals('Linux E2E custom plan')))
              .getSingle();
      expect(plan.days, 'Monday');
      expect(
        await (app.db.planExercises.select()..where(
              (tbl) =>
                  tbl.planId.equals(plan.id) &
                  tbl.exercise.equals('Barbell bench press') &
                  tbl.enabled,
            ))
            .getSingleOrNull(),
        isNotNull,
      );

      final planSearch = find.byType(SearchBar);
      await tester.enterText(planSearch, 'Linux E2E custom plan');
      await tester.pumpAndSettle();
      expect(
        find.widgetWithText(ListTile, 'Linux E2E custom plan'),
        findsOneWidget,
      );
      await tester.enterText(planSearch, 'Monday');
      await tester.pumpAndSettle();
      expect(
        find.widgetWithText(ListTile, 'Linux E2E custom plan'),
        findsOneWidget,
      );
      await tester.enterText(planSearch, 'Linux E2E custom plan');
      await tester.pumpAndSettle();

      await tester.longPress(
        find.widgetWithText(ListTile, 'Linux E2E custom plan'),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Show menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ListTile, 'Edit'));
      await tester.pumpAndSettle();
      await tester.enterText(
        _textFieldWithLabel('Title (optional)'),
        'Linux E2E edited plan',
      );
      await tester.tap(find.text('Tue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      plan =
          await (app.db.plans.select()..where((tbl) => tbl.id.equals(plan.id)))
              .getSingle();
      expect(plan.title, 'Linux E2E edited plan');
      expect(plan.days.split(',').toSet(), {'Monday', 'Tuesday'});

      final clearSelection = find.byIcon(Icons.arrow_back);
      if (clearSelection.evaluate().isNotEmpty) {
        await tester.tap(clearSelection.first);
        await tester.pumpAndSettle();
      }
      await tester.enterText(find.byType(SearchBar), 'Linux E2E edited plan');
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Show menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ListTile, 'Select all'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('deleteButton')));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();
      expect(
        await (app.db.plans.select()..where((tbl) => tbl.id.equals(plan.id)))
            .getSingleOrNull(),
        isNotNull,
      );
      await tester.tap(find.byKey(const ValueKey('deleteButton')));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Delete'));
      await tester.pumpAndSettle();
      expect(
        await (app.db.plans.select()..where((tbl) => tbl.id.equals(plan.id)))
            .getSingleOrNull(),
        isNull,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Strength graph metric, period, options, and notes persist', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(1000, 900));
    await app.db.gymSets.insertAll([
      GymSetsCompanion.insert(
        name: 'Linux E2E strength detail',
        reps: 5,
        weight: 80,
        unit: 'kg',
        created: DateTime(2026, 8, 31, 12),
      ),
      GymSetsCompanion.insert(
        name: 'Linux E2E strength detail',
        reps: 6,
        weight: 82,
        unit: 'kg',
        created: DateTime(2026, 9, 1, 12),
      ),
    ]);
    await tester.pumpAndSettle();
    await _tapTab(tester, 'GraphsPage');
    await tester.enterText(find.byType(SearchBar), 'Linux E2E strength detail');
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(ListTile, 'Linux E2E strength detail'),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Best weight'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Volume').last);
    await tester.pumpAndSettle();
    for (final period in ['Day', 'Week', 'Year', 'Month']) {
      await tester.tap(find.text(period));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
    await tester.tap(find.byTooltip('Options'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(SwitchListTile, 'Use time-based X axis'),
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Slider).first, const Offset(150, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start date'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1').last);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Stop date'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1').last);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Exercise notes'));
    await tester.pumpAndSettle();
    expect(find.text('Exercise notes'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Linux E2E graph notes');
    await tester.pump(const Duration(milliseconds: 700));
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    final pref =
        await (app.db.graphPreferences.select()
              ..where((tbl) => tbl.name.equals('Linux E2E strength detail')))
            .getSingle();
    expect(pref.metric, 'volume');
    expect(pref.period, 'month');
    expect(pref.timeBasedXAxis, isTrue);
    expect(pref.limit, greaterThan(10));
    expect(pref.notes, 'Linux E2E graph notes');

    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(
      _textFieldWithLabel('New name'),
      'Linux E2E strength renamed',
    );
    await tester.tap(find.text('Update'));
    await tester.pumpAndSettle();
    expect(find.text('Linux E2E strength renamed'), findsOneWidget);
    expect(find.text('Linux E2E strength detail'), findsNothing);
    expect(
      await (app.db.graphPreferences.select()
            ..where((tbl) => tbl.name.equals('Linux E2E strength detail')))
          .getSingleOrNull(),
      isNull,
    );
    final renamedPref =
        await (app.db.graphPreferences.select()
              ..where((tbl) => tbl.name.equals('Linux E2E strength renamed')))
            .getSingle();
    expect(renamedPref.metric, 'volume');
    expect(renamedPref.period, 'month');
    expect(renamedPref.notes, 'Linux E2E graph notes');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Weighted cardio uses weight in History and Graphs', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(1000, 900));
    await _tapTab(tester, 'HistoryPage');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ListTile, 'Cardio'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Weight (kg)'), findsOneWidget);
    expect(find.bySemanticsLabel('Distance (kg)'), findsNothing);
    await tester.enterText(
      find.bySemanticsLabel('Name'),
      'Linux E2E dead hang',
    );
    await tester.enterText(find.bySemanticsLabel('Weight (kg)'), '20');
    await tester.enterText(find.bySemanticsLabel('Minutes'), '1');
    await tester.enterText(find.bySemanticsLabel('Seconds'), '30');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    var row =
        await (app.db.gymSets.select()
              ..where((tbl) => tbl.name.equals('Linux E2E dead hang')))
            .getSingle();
    expect(row.cardio, isTrue);
    expect(row.unit, 'kg');
    expect(row.weight, 20);
    expect(row.distance, 0);
    expect(row.duration, 1.5);

    await _tapTab(tester, 'GraphsPage');
    await tester.enterText(find.byType(SearchBar), 'Linux E2E dead hang');
    await tester.pumpAndSettle();
    expect(find.text('20 kg / 1:30'), findsOneWidget);
    await tester.tap(find.widgetWithText(ListTile, 'Linux E2E dead hang'));
    await tester.pumpAndSettle();
    expect(find.text('Weight'), findsOneWidget);
    expect(find.text('Pace (distance / time)'), findsNothing);
    expect(find.text('No data yet for Linux E2E dead hang'), findsNothing);

    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();
    await tester.tap(_dropdownWithLabel('Unit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pounds (lb)').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Update'));
    await tester.pumpAndSettle();

    row =
        await (app.db.gymSets.select()
              ..where((tbl) => tbl.name.equals('Linux E2E dead hang')))
            .getSingle();
    expect(row.unit, 'lb');
    expect(row.weight, closeTo(44.09245, 0.0001));
    expect(row.distance, 0);
    expect(find.text('Weight'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Cardio graph rename updates the active detail page', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(1000, 900));
    await app.db.gymSets.insertOne(
      GymSetsCompanion.insert(
        name: 'Linux E2E cardio old',
        reps: 0,
        weight: 0,
        unit: 'km',
        created: DateTime(2026, 9, 1, 12),
        cardio: const Value(true),
        duration: const Value(30),
        distance: const Value(5),
      ),
    );
    await tester.pumpAndSettle();
    await _tapTab(tester, 'GraphsPage');
    await tester.enterText(find.byType(SearchBar), 'Linux E2E cardio old');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Linux E2E cardio old'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(
      _textFieldWithLabel('New name'),
      'Linux E2E cardio renamed',
    );
    await tester.tap(find.text('Update'));
    await tester.pumpAndSettle();

    expect(
      await (app.db.gymSets.select()
            ..where((tbl) => tbl.name.equals('Linux E2E cardio renamed')))
          .getSingleOrNull(),
      isNotNull,
    );
    expect(find.text('Linux E2E cardio renamed'), findsOneWidget);
    expect(find.text('Linux E2E cardio old'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Active plan settings, swap, save, edit, and undo work', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(1000, 1000));
    await _tapTab(tester, 'PlansPage');
    await tester.tap(find.byType(PlanTile).first);
    await tester.pumpAndSettle();

    await tester.longPress(find.byKey(const Key('Barbell bench press')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Settings'));
    await tester.pumpAndSettle();
    await tester.enterText(_textFieldWithLabel('Warmup sets'), '1');
    await tester.enterText(_textFieldWithLabel('Working sets (max: 20)'), '2');
    await tester.tap(
      find.descendant(
        of: find.widgetWithText(ListTile, 'Rest timers'),
        matching: find.byType(Switch),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'OK'));
    await tester.pumpAndSettle();

    var planExercise =
        await (app.db.planExercises.select()..where(
              (tbl) =>
                  tbl.planId.equals(1) &
                  tbl.exercise.equals('Barbell bench press'),
            ))
            .getSingle();
    expect(planExercise.warmupSets, 1);
    expect(planExercise.maxSets, 2);
    expect(planExercise.timers, isFalse);

    await tester.longPress(find.byKey(const Key('Squat')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Swap'));
    await tester.pumpAndSettle();
    expect(find.text('Swap workout'), findsOneWidget);
    await tester.enterText(
      _textFieldWithLabel('Search Exercises'),
      'Arnold press',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Arnold press'));
    await tester.pumpAndSettle();

    expect(
      await (app.db.planExercises.select()..where(
            (tbl) => tbl.planId.equals(1) & tbl.exercise.equals('Squat'),
          ))
          .getSingleOrNull(),
      isNull,
    );
    expect(
      await (app.db.planExercises.select()..where(
            (tbl) => tbl.planId.equals(1) & tbl.exercise.equals('Arnold press'),
          ))
          .getSingleOrNull(),
      isNotNull,
    );
    expect(find.byKey(const Key('Arnold press')), findsOneWidget);

    await tester.enterText(find.bySemanticsLabel('Reps'), '5');
    await tester.enterText(find.bySemanticsLabel('Weight (kg)'), '50');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Set 1'), findsOneWidget);

    var logged =
        await (app.db.gymSets.select()
              ..where((tbl) => tbl.planId.equals(1) & tbl.hidden.equals(false)))
            .get();
    expect(logged, hasLength(1));
    final loggedName = logged.single.name;

    await tester.tap(find.text('Set 1'));
    await tester.pumpAndSettle();
    await tester.enterText(find.bySemanticsLabel('Reps'), '7');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    logged =
        await (app.db.gymSets.select()
              ..where((tbl) => tbl.planId.equals(1) & tbl.hidden.equals(false)))
            .get();
    expect(logged.single.reps, 7);

    await tester.longPress(find.byKey(Key(loggedName)));
    await tester.pumpAndSettle();
    expect(find.text('Undo'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
    await tester.tap(find.widgetWithText(ListTile, 'Undo'));
    await tester.pumpAndSettle();
    logged =
        await (app.db.gymSets.select()
              ..where((tbl) => tbl.planId.equals(1) & tbl.hidden.equals(false)))
            .get();
    expect(logged, isEmpty);
    expect(find.text('Set 1'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Desktop rest timer expires and clears running state', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await app.db.settings.update().write(
      const SettingsCompanion(
        restTimers: Value(true),
        timerDuration: Value(400),
        enableSound: Value(false),
        vibrate: Value(false),
      ),
    );
    await tester.pumpAndSettle();
    await _tapTab(tester, 'PlansPage');
    await tester.tap(find.byType(PlanTile).first);
    await tester.pumpAndSettle();
    await tester.enterText(find.bySemanticsLabel('Reps'), '5');
    await tester.enterText(find.bySemanticsLabel('Weight (kg)'), '50');
    await tester.tap(find.text('Save'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    await _tapTab(tester, 'TimerPage');
    expect(find.text('+1 minute'), findsOneWidget);
    expect(find.text('Stop'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Timer settings persist and custom exercise rest times work', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(1000, 1000));
    await app.db.gymSets.insertOne(
      GymSetsCompanion.insert(
        name: 'Linux E2E custom rest',
        reps: 5,
        weight: 50,
        unit: 'kg',
        created: DateTime(2026, 9, 1, 12),
        restMs: const Value(90000),
      ),
    );
    await _openSettingsSection(tester, 'Timers');

    var settings = await (app.db.settings.select()..limit(1)).getSingle();
    final originalVibrate = settings.vibrate;
    final originalSound = settings.enableSound;
    final originalKeepScreenOn = settings.keepScreenOn;

    for (final title in [
      'Rest timers',
      'Vibrate',
      'Enable sound',
      'Keep screen on',
    ]) {
      final tile = find.widgetWithText(ListTile, title);
      await tester.ensureVisible(tile);
      await tester.tap(tile);
      await tester.pumpAndSettle();
    }
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.restTimers, isTrue);
    expect(settings.vibrate, !originalVibrate);
    expect(settings.enableSound, !originalSound);
    expect(settings.keepScreenOn, !originalKeepScreenOn);

    final restMinutes = _textFieldWithLabel('Rest minutes');
    final restSeconds = _textFieldWithLabel('seconds');
    await tester.ensureVisible(restMinutes);
    await tester.enterText(restMinutes, '2');
    await tester.pumpAndSettle();
    await tester.enterText(restSeconds, '15');
    await tester.pumpAndSettle();
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.timerDuration, 135000);

    await tester.enterText(restMinutes, 'abc');
    await tester.pumpAndSettle();
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.timerDuration, 15000);
    expect(tester.takeException(), isNull);

    final progressPosition = find.text('Progress bar position');
    await tester.ensureVisible(progressPosition);
    await tester.tap(find.text('Top'));
    await tester.pump(const Duration(milliseconds: 400));
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.progressPosition, 'top');
    await tester.tap(find.text('None'));
    await tester.pumpAndSettle();
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.progressPosition, 'none');

    final customRest = find.text('Linux E2E custom rest');
    await tester.ensureVisible(customRest);
    final customMinutes = _textFieldWithLabel('Minutes');
    final customSeconds = _textFieldWithLabel('Seconds');
    await tester.enterText(customMinutes, '2');
    await tester.pumpAndSettle();
    await tester.enterText(customSeconds, '10');
    await tester.pumpAndSettle();
    var row =
        await (app.db.gymSets.select()
              ..where((tbl) => tbl.name.equals('Linux E2E custom rest')))
            .getSingle();
    expect(row.restMs, 130000);

    await tester.tap(
      find.byTooltip('Remove custom timer (use global default)'),
    );
    await tester.pumpAndSettle();
    row =
        await (app.db.gymSets.select()
              ..where((tbl) => tbl.name.equals('Linux E2E custom rest')))
            .getSingle();
    expect(row.restMs, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Appearance settings persist every desktop-safe control', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(1000, 1000));
    await _openSettingsSection(tester, 'Appearance');

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    var settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.themeMode, 'ThemeMode.dark');

    for (final title in [
      'Pure black (AMOLED)',
      'System color scheme',
      'Show global progress',
      'Peek graph',
      'Curve line graphs',
    ]) {
      final tile = find.widgetWithText(ListTile, title);
      await tester.ensureVisible(tile);
      await tester.tap(tile);
      await tester.pumpAndSettle();
    }
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.themeMode, 'ThemeMode.amoled');
    expect(settings.systemColors, isTrue);
    expect(settings.showGlobalProgress, isFalse);
    expect(settings.peekGraph, isTrue);
    expect(settings.curveLines, isFalse);

    final smoothness = find.text('Curve smoothness');
    await tester.ensureVisible(smoothness);
    await tester.drag(find.byType(Slider).first, const Offset(120, 0));
    await tester.pumpAndSettle();
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.curveSmoothness, isNotNull);

    await tester.ensureVisible(find.text('Filled'));
    await tester.tap(find.text('Filled'));
    await tester.pumpAndSettle();
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.inputStyle, 'filled');
    await tester.tap(find.text('Line'));
    await tester.pumpAndSettle();
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.inputStyle, 'underline');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Formats and workout controls persist exhaustive values', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(1000, 1100));
    await _openSettingsSection(tester, 'Formats');

    for (final option in [
      'Kilograms (kg)',
      'Pounds (lb)',
      'Stone',
      'Last entry',
      'Stone',
    ]) {
      await tester.tap(_dropdownWithLabel('Strength unit'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(option).last);
      await tester.pumpAndSettle();
    }
    for (final option in [
      'Kilometers (km)',
      'Miles (mi)',
      'Meters (m)',
      'Last entry',
      'Kilocalories (kcal)',
    ]) {
      await tester.tap(_dropdownWithLabel('Cardio unit'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(option).last);
      await tester.pumpAndSettle();
    }
    await tester.tap(_dropdownWithLabel('Long date format'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('dd/MM/yy').last);
    await tester.pumpAndSettle();
    await tester.tap(_dropdownWithLabel('Short date format'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('M/d/yy').last);
    await tester.pumpAndSettle();

    var settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.strengthUnit, 'stone');
    expect(settings.cardioUnit, 'kcal');
    expect(settings.longDateFormat, 'dd/MM/yy');
    expect(settings.shortDateFormat, 'M/d/yy');

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Workouts'));
    await tester.pumpAndSettle();

    final initial = await (app.db.settings.select()..limit(1)).getSingle();
    for (final title in [
      'Group history',
      'Show units',
      'Show body weight',
      'Show categories',
      'Show notes',
      'Notifications',
      'Rep estimation',
      'Duration estimation',
      'Show graph X axis toggle',
      'Show graph limit',
      'Default time-based X axis',
    ]) {
      final tile = find.widgetWithText(ListTile, title);
      await tester.ensureVisible(tile);
      await tester.tap(tile);
      await tester.pumpAndSettle();
    }

    await tester.ensureVisible(_dropdownWithLabel('Default graph metric'));
    await tester.tap(_dropdownWithLabel('Default graph metric'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Distance (cardio)').last);
    await tester.pumpAndSettle();
    await tester.tap(_dropdownWithLabel('Default graph period'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Weekly').last);
    await tester.pumpAndSettle();
    await tester.tap(_dropdownWithLabel('Default graph limit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('50').last);
    await tester.pumpAndSettle();

    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.groupHistory, !initial.groupHistory);
    expect(settings.showUnits, !initial.showUnits);
    expect(settings.showBodyWeight, !initial.showBodyWeight);
    expect(settings.showCategories, !initial.showCategories);
    expect(settings.showNotes, !initial.showNotes);
    expect(settings.notifications, !initial.notifications);
    expect(settings.repEstimation, !initial.repEstimation);
    expect(settings.durationEstimation, !initial.durationEstimation);
    expect(settings.showGraphXAxis, !initial.showGraphXAxis);
    expect(settings.showGraphLimit, !initial.showGraphLimit);
    expect(
      settings.defaultGraphTimeBasedXAxis,
      !initial.defaultGraphTimeBasedXAxis,
    );
    expect(settings.defaultGraphMetric, 'distance');
    expect(settings.defaultGraphPeriod, 'week');
    expect(settings.defaultGraphLimit, 50);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await _tapTab(tester, 'HistoryPage');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    expect(_dropdownWithLabel('Unit'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Plan settings and tab safety persist through live app state', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(1000, 1000));
    await _openSettingsSection(tester, 'Plans');

    await tester.enterText(_textFieldWithLabel('Warmup sets'), '2');
    await tester.pumpAndSettle();
    await tester.enterText(
      _textFieldWithLabel('Sets per exercise (max: 20)'),
      '4',
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Count'));
    await tester.tap(find.text('Count'));
    await tester.pumpAndSettle();
    var settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.warmupSets, 2);
    expect(settings.maxSets, 4);
    expect(settings.planTrailing, 'PlanTrailing.count');
    await tester.tap(find.text('%'));
    await tester.pumpAndSettle();
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.planTrailing, 'PlanTrailing.percent');
    await tester.tap(find.text('Ratio'));
    await tester.pumpAndSettle();
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.planTrailing, 'PlanTrailing.ratio');
    await tester.tap(find.text('Reorder'));
    await tester.pumpAndSettle();
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.planTrailing, 'PlanTrailing.reorder');
    await tester.tap(find.text('None'));
    await tester.pumpAndSettle();
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.planTrailing, 'PlanTrailing.none');

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tabs'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Swipe between tabs'));
    await tester.pumpAndSettle();
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.scrollableTabs, isFalse);

    for (final title in ['History', 'Plans', 'Graphs', 'Timer']) {
      await tester.tap(find.widgetWithText(ListTile, title));
      await tester.pumpAndSettle();
    }
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.tabs, 'SettingsPage');
    await tester.tap(find.widgetWithText(ListTile, 'Settings'));
    await tester.pumpAndSettle();
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.tabs, 'SettingsPage');
    expect(find.text('You need at least one tab'), findsOneWidget);

    await tester.tap(find.widgetWithText(ListTile, 'History'));
    await tester.pumpAndSettle();
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.tabs, 'HistoryPage,SettingsPage');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Delete records cancel and confirm paths update isolated data', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(1000, 900));
    await app.db.gymSets.insertOne(
      GymSetsCompanion.insert(
        name: 'Linux E2E deletable graph',
        reps: 5,
        weight: 50,
        unit: 'kg',
        created: DateTime(2026, 9, 1, 12),
      ),
    );
    await _openSettingsSection(tester, 'Data management');
    await tester.tap(find.text('Delete records'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Graphs'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(
      await (app.db.gymSets.select()
            ..where((tbl) => tbl.name.equals('Linux E2E deletable graph')))
          .getSingleOrNull(),
      isNotNull,
    );

    await tester.tap(find.text('Delete records'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Graphs'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(
      await (app.db.gymSets.select()
            ..where((tbl) => tbl.name.equals('Linux E2E deletable graph')))
          .getSingleOrNull(),
      isNull,
    );

    await _openSettingsSection(tester, 'Data management');
    final plansBefore = await app.db.plans.select().get();
    expect(plansBefore, isNotEmpty);
    await tester.tap(find.text('Delete records'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Plans'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(await app.db.plans.select().get(), hasLength(plansBefore.length));

    await tester.tap(find.text('Delete records'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Plans'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(await app.db.plans.select().get(), isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Settings search reaches every settings section', (tester) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await _openSettings(tester);
    final search = find.byType(SearchBar);
    final cases = <String, String>{
      'system color scheme': 'System color scheme',
      'strength unit': 'Strength unit',
      'show notes': 'Show notes',
      'rest timers': 'Rest timers',
      'delete records': 'Delete records',
      'warmup sets': 'Warmup sets',
    };
    for (final entry in cases.entries) {
      await tester.enterText(search, entry.key);
      await tester.pumpAndSettle();
      expect(find.textContaining(entry.value), findsWidgets);
      expect(find.text('No settings found'), findsNothing);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('About and Whats New render on Linux', (tester) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await _openSettings(tester);
    await tester.tap(find.byIcon(Icons.info_outline_rounded));
    await tester.pumpAndSettle();
    expect(find.text('About'), findsOneWidget);
    for (final title in [
      'Donate',
      'Whats new?',
      'Version',
      'Author',
      'Privacy policy',
      'License',
      'Source code',
      'Leave a review',
      'Report a bug',
    ]) {
      expect(find.text(title), findsOneWidget);
    }
    await tester.tap(find.text('Whats new?'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text("What's new?"), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
