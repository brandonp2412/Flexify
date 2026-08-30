import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart' as app;
import 'package:flexify/settings/settings_state.dart';
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
}
