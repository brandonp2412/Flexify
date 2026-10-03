import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/performed_sets.dart';
import 'package:flexify/home_page.dart';
import 'package:flexify/main.dart' as app;
import 'package:flexify/plan/plan_tile.dart';
import 'package:flexify/settings/settings_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/settings/workout_settings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/support/fixtures.dart';

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
      localeOverride: Value('en'),
    ),
  );

  final setting = await (database.settings.select()..limit(1)).getSingle();

  await tester.pumpWidget(app.appProviders(setting));
  await tester.pumpAndSettle();
  return setting;
}

Future<void> _tapAddAction(WidgetTester tester) async {
  for (final label in const ['Add set', 'New exercise', 'New plan', 'Add']) {
    final finder = find.text(label);
    if (finder.evaluate().isNotEmpty) {
      await tester.tap(finder.last);
      return;
    }
  }
  fail('No responsive add action found');
}

Future<void> _openGraphOptionsIfNeeded(WidgetTester tester) async {
  final options = find.byTooltip('Options');
  if (options.evaluate().isEmpty) return;
  await tester.tap(options);
  await tester.pumpAndSettle();
}

Future<void> _tapSaveAction(WidgetTester tester) async {
  for (final target in [
    find.text('Save set'),
    find.text('Save plan'),
    find.text('Save'),
    find.byIcon(Icons.save_rounded),
    find.byIcon(Icons.save),
  ]) {
    if (target.evaluate().isNotEmpty) {
      await tester.tap(target.last);
      return;
    }
  }
  fail('No responsive save action found');
}

Future<void> _secondaryTap(WidgetTester tester, Finder finder) async {
  final gesture = await tester.startGesture(
    tester.getCenter(finder),
    kind: PointerDeviceKind.mouse,
    buttons: kSecondaryMouseButton,
  );
  await gesture.up();
  await tester.pumpAndSettle();
}

void _expectBefore(WidgetTester tester, Finder before, Finder after) {
  final first = tester.getTopLeft(before);
  final second = tester.getTopLeft(after);
  if ((first.dy - second.dy).abs() < 1) {
    expect(first.dx, lessThan(second.dx));
  } else {
    expect(first.dy, lessThan(second.dy));
  }
}

Future<void> _tapTab(WidgetTester tester, String tab) async {
  final label = BottomNav.labelForTab(
    tester.element(find.byType(HomePage)),
    tab,
  );
  final keyedTab = find.byKey(Key(tab));
  if (keyedTab.evaluate().isNotEmpty) {
    await tester.tap(keyedTab);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    return;
  }

  final textFinder = find.text(label);
  if (textFinder.evaluate().isNotEmpty) {
    await tester.tap(textFinder.last);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    return;
  }

  await tester.tap(find.byTooltip(label));
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

Future<void> _openSettings(WidgetTester tester) async {
  await _tapTab(tester, 'SettingsPage');
  expect(find.text('Settings'), findsWidgets);
}

Future<void> _openSettingsSection(WidgetTester tester, String section) async {
  await _openSettings(tester);
  final sectionFinder = find.descendant(
    of: find.byType(SettingsPage),
    matching: find.text(section),
  );
  if (sectionFinder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      sectionFinder,
      260,
      scrollable: find.byType(Scrollable).last,
    );
  } else {
    await tester.ensureVisible(sectionFinder);
  }
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

Future<PerformedSetView> _insertE2ESet({
  required String name,
  double reps = 5,
  double weight = 50,
  String unit = 'kg',
  required DateTime created,
  bool cardio = false,
  double duration = 0,
  double distance = 0,
  int? incline,
  String? category,
  int? planId,
  double bodyWeight = 0,
  int? restMs,
}) async {
  final inserted = await insertPerformedSetFixture(
    app.db,
    name,
    reps: reps,
    weight: weight,
    unit: unit,
    created: created,
    cardio: cardio,
    duration: duration,
    distance: distance,
    incline: incline,
    category: category,
    planId: planId,
    bodyWeight: bodyWeight,
  );
  if (restMs != null) {
    final exercise = await _exerciseNamed(name);
    await (app.db.exercises.update()
          ..where((row) => row.id.equals(exercise.id)))
        .write(ExercisesCompanion(defaultRestDurationMs: Value(restMs)));
    return (await getPerformedSetById(app.db, inserted.id))!;
  }
  return inserted;
}

Future<List<PerformedSetView>> _setsNamed(String name) =>
    getPerformedSetsForExercise(app.db, exerciseName: name);

Future<PerformedSetView> _singleSet(String name) async =>
    (await _setsNamed(name)).single;

Future<PerformedSetView?> _maybeSet(String name) async {
  final rows = await _setsNamed(name);
  return rows.isEmpty ? null : rows.single;
}

Future<List<PerformedSetView>> _setsMatching(String search) =>
    getPerformedSets(app.db, search: search);

Future<List<PerformedSetView>> _setsForPlan(int planId) async =>
    (await getPerformedSets(
      app.db,
    )).where((set) => set.planId == planId).toList(growable: false);

Future<Exercise> _exerciseNamed(String name) =>
    (app.db.exercises.select()..where((row) => row.name.equals(name)))
        .getSingle();

Future<Exercise?> _maybeExerciseNamed(String name) =>
    (app.db.exercises.select()..where((row) => row.name.equals(name)))
        .getSingleOrNull();

Future<String> _exerciseNameForId(int exerciseId) async =>
    (await (app.db.exercises.select()
              ..where((row) => row.id.equals(exerciseId)))
            .getSingle())
        .name;

Future<PlanExercise?> _planExerciseForName(int planId, String name) async {
  final exercise = await _exerciseNamed(name);
  return (app.db.planExercises.select()..where(
        (row) => row.planId.equals(planId) & row.exerciseId.equals(exercise.id),
      ))
      .getSingleOrNull();
}

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
    await _tapAddAction(tester);
    await tester.pumpAndSettle();

    expect(find.text('Search exercises...'), findsOneWidget);
    expect(find.textContaining('_exercises'), findsNothing);
    expect(find.textContaining('_days'), findsNothing);
  });

  testWidgets('Plans save validation uses human-readable copy', (tester) async {
    await _pumpIsolatedApp(tester);
    await _tapTab(tester, 'PlansPage');
    await _tapAddAction(tester);
    await tester.pumpAndSettle();
    await _tapSaveAction(tester);
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
    await _tapSaveAction(tester);
    await tester.pump();
    expect(find.text('Select exercises'), findsOneWidget);
  });

  testWidgets('History add flow uses body weight label', (tester) async {
    await _pumpIsolatedApp(tester);
    await _tapTab(tester, 'HistoryPage');
    await _tapAddAction(tester);
    await tester.pumpAndSettle();

    expect(find.textContaining('Body weight ('), findsOneWidget);
    expect(find.textContaining('Body _weight'), findsNothing);
  });

  testWidgets('History cardio switch preserves the selected unit', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester);
    await _tapTab(tester, 'HistoryPage');
    await _tapAddAction(tester);
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

  testWidgets('Graph add exercise cardio switch uses the cardio unit', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester);
    await _tapTab(tester, 'GraphsPage');
    await _tapAddAction(tester);
    await tester.pumpAndSettle();

    final cardioTile = find.widgetWithText(ListTile, 'Strength');
    final cardioSwitch = find.descendant(
      of: cardioTile,
      matching: find.byType(Switch),
    );
    await tester.tap(cardioSwitch);
    await tester.pumpAndSettle();

    expect(find.text('Kilometers (km)'), findsOneWidget);
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

    await tester.tap(find.widgetWithText(ListTile, 'Graphs'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Graphs'), findsOneWidget);

    await tester.tap(find.widgetWithText(ListTile, 'Graphs'));
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
    expect(find.text('Search plans...'), findsNothing);

    await _tapTab(tester, 'PlansPage');
    expect(find.text('Search plans...'), findsOneWidget);
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.scrollableTabs, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Tab drag reorder persists navigation order', (tester) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await _openSettingsSection(tester, 'Tabs');
    final historyTile = find.ancestor(
      of: find.text('History'),
      matching: find.byType(ListTile),
    );
    final historyHandle = find.descendant(
      of: historyTile,
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

  testWidgets('Desktop tab removal updates home navigation safely', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester);

    await _secondaryTap(tester, find.byKey(const Key('GraphsPage')));
    expect(find.text('Remove Graphs tab?'), findsOneWidget);
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(find.text('Graphs'), findsNothing);
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

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Settings')),
      findsOneWidget,
    );
    expect(find.text('Settings'), findsWidgets);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Timer')),
      findsOneWidget,
    );
    expect(find.text('Start stopwatch'), findsOneWidget);
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

    expect(find.text('Squat'), findsOneWidget);
    expect(find.text('Barbell bench press'), findsNothing);
    expect(find.text('No plans found'), findsNothing);
  });

  testWidgets('Plan search treats percent as literal text', (tester) async {
    await _pumpIsolatedApp(tester);
    await _tapTab(tester, 'PlansPage');

    await tester.enterText(find.byType(SearchBar), '%');
    await tester.pumpAndSettle();

    expect(find.text('No matching plans'), findsOneWidget);
  });

  testWidgets('Plan search treats underscore as literal text', (tester) async {
    await _pumpIsolatedApp(tester);
    await _tapTab(tester, 'PlansPage');

    await tester.enterText(find.byType(SearchBar), '_');
    await tester.pumpAndSettle();

    expect(find.text('No matching plans'), findsOneWidget);
  });

  testWidgets('Per-exercise working set input tolerates invalid text', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester);
    await _tapTab(tester, 'PlansPage');
    await tester.tap(find.text('New plan'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Settings').first);
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
    await _insertE2ESet(
      name: 'Barbell bench press',
      reps: 5,
      weight: 80,
      created: DateTime(2026, 9, 1, 10),
    );
    await tester.pumpAndSettle();
    await _tapTab(tester, 'GraphsPage');

    await tester.tap(find.text('Barbell bench press'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('History'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Graph desktop context, curve options, and history actions work',
    (tester) async {
      await _pumpIsolatedApp(tester);
      final now = DateTime(2026, 8, 30, 12);
      for (var index = 0; index < 2; index++) {
        await _insertE2ESet(
          name: 'Selection E2E',
          reps: (5 + index).toDouble(),
          weight: (50 + index).toDouble(),
          created: now.subtract(Duration(days: index)),
        );
      }
      await _tapTab(tester, 'GraphsPage');
      await tester.enterText(find.byType(SearchBar), 'Selection E2E');
      await tester.pumpAndSettle();

      final graphTile = find.widgetWithText(ListTile, 'Selection E2E');
      await _secondaryTap(tester, graphTile);
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      await tester.tap(graphTile);
      await tester.pumpAndSettle();
      await _openGraphOptionsIfNeeded(tester);
      expect(find.text('Curve line graphs'), findsOneWidget);
      expect(find.text('Curve smoothness'), findsOneWidget);
      await tester.tapAt(const Offset(8, 8));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('History'));
      await tester.pumpAndSettle();
      expect(find.text('5 x 50 kg'), findsOneWidget);
      expect(find.text('6 x 51 kg'), findsOneWidget);

      await _secondaryTap(tester, find.text('5 x 50 kg'));
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();

      expect(await _setsNamed('Selection E2E'), hasLength(1));
      expect(find.text('6 x 51 kg'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Graph sort, category filter, global progress, and hide work', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(899, 950));
    await app.db.settings.update().write(
      const SettingsCompanion(showGlobalProgress: Value(true)),
    );
    final now = DateTime.now();
    await _insertE2ESet(
      name: 'Linux E2E graph Zebra',
      reps: 5,
      weight: 60,
      created: now.subtract(const Duration(days: 2)),
      category: 'Linux Cat B',
    );
    await _insertE2ESet(
      name: 'Linux E2E graph Alpha',
      reps: 6,
      weight: 65,
      created: now.subtract(const Duration(days: 1)),
      category: 'Linux Cat A',
    );
    await _insertE2ESet(
      name: 'Linux E2E graph Beta',
      reps: 7,
      weight: 70,
      created: now,
      category: 'Linux Cat A',
    );
    await tester.pumpAndSettle();
    expect(
      (await (app.db.settings.select()..limit(1)).getSingle())
          .showGlobalProgress,
      isTrue,
    );
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
    _expectBefore(
      tester,
      find.text('Linux E2E graph Alpha'),
      find.text('Linux E2E graph Beta'),
    );
    _expectBefore(
      tester,
      find.text('Linux E2E graph Beta'),
      find.text('Linux E2E graph Zebra'),
    );

    await tester.tap(find.byTooltip('Filter'));
    await tester.pumpAndSettle();
    await tester.tap(_dropdownWithLabel('Sort by'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Date (newest)').last);
    await tester.pumpAndSettle();
    _expectBefore(
      tester,
      find.text('Linux E2E graph Beta'),
      find.text('Linux E2E graph Alpha'),
    );
    _expectBefore(
      tester,
      find.text('Linux E2E graph Alpha'),
      find.text('Linux E2E graph Zebra'),
    );

    await tester.tap(find.byTooltip('Filter'));
    await tester.pumpAndSettle();
    await tester.tap(_dropdownWithLabel('Sort by'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Date (oldest)').last);
    await tester.pumpAndSettle();
    _expectBefore(
      tester,
      find.text('Linux E2E graph Zebra'),
      find.text('Linux E2E graph Alpha'),
    );
    _expectBefore(
      tester,
      find.text('Linux E2E graph Alpha'),
      find.text('Linux E2E graph Beta'),
    );

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
    expect(
      (await (app.db.settings.select()..limit(1)).getSingle())
          .showGlobalProgress,
      isTrue,
    );
    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    expect(find.text('Global progress'), findsOneWidget);

    await _secondaryTap(tester, find.text('Global progress'));
    expect(find.text('Hide global progress'), findsOneWidget);
    await tester.tap(find.text('Hide global progress'));
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
    await _tapAddAction(tester);
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
    await _tapSaveAction(tester);
    await tester.pumpAndSettle();

    var row = await _singleSet('Linux E2E press');
    expect(row.reps, 8);
    expect(row.weight, 72.5);
    expect(row.bodyWeight, 81.2);
    expect(row.category, 'E2E Chest');
    expect(row.notes, 'Linux strength CRUD');
    expect(find.text('Linux E2E press'), findsOneWidget);

    await _tapTab(tester, 'GraphsPage');
    await tester.enterText(find.byType(SearchBar), 'Linux E2E press');
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ListTile, 'Linux E2E press'), findsOneWidget);

    await _tapTab(tester, 'HistoryPage');
    await tester.tap(find.widgetWithText(ListTile, 'Linux E2E press'));
    await tester.pumpAndSettle();
    await tester.enterText(find.bySemanticsLabel('Reps'), '9');
    await tester.enterText(find.bySemanticsLabel('Weight (kg)'), '77.5');
    await _tapSaveAction(tester);
    await tester.pumpAndSettle();

    row = await _singleSet('Linux E2E press');
    expect(row.reps, 9);
    expect(row.weight, 77.5);

    await tester.tap(find.widgetWithText(ListTile, 'Linux E2E press'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Delete set'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(await _maybeSet('Linux E2E press'), isNotNull);

    await tester.tap(find.byTooltip('Delete set'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(await _maybeSet('Linux E2E press'), isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('History cardio entry persists Linux-specific fields', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await _tapTab(tester, 'HistoryPage');
    await _tapAddAction(tester);
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
    await _tapSaveAction(tester);
    await tester.pumpAndSettle();

    final row = await _singleSet('Linux E2E run');
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
    await _tapSaveAction(tester);
    await tester.pumpAndSettle();

    final edited = await _singleSet('Linux E2E run');
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
    await _insertE2ESet(
      name: 'Linux E2E grouped',
      reps: 5,
      weight: 50,
      created: now.subtract(const Duration(hours: 1)),
    );
    await _insertE2ESet(
      name: 'Linux E2E grouped',
      reps: 6,
      weight: 52,
      created: now.subtract(const Duration(hours: 2)),
    );
    await _insertE2ESet(
      name: 'Linux E2E old',
      reps: 7,
      weight: 55,
      created: now.subtract(const Duration(days: 3)),
    );
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
    expect(_textFieldWithLabel('Name'), findsOneWidget);
    expect(
      tester.widget<TextField>(_textFieldWithLabel('Name')).controller!.text,
      'Linux E2E grouped',
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
    await _tapSaveAction(tester);
    await tester.pumpAndSettle();

    final rows = (await _setsNamed(
      'Barbell bench press',
    )).where((set) => set.planId == 1).toList();
    expect(rows, hasLength(1));
    expect(rows.single.reps, 6);
    expect(rows.single.weight, 83);
    expect(find.text('Set 1'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await _tapTab(tester, 'GraphsPage');
    await tester.enterText(find.byType(SearchBar), 'Barbell bench press');
    await tester.pumpAndSettle();
    expect(
      find.widgetWithText(ListTile, 'Barbell bench press'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Plan auto-advances and starts a new workout after exit', (
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
    final first = await _exerciseNameForId(exercises[0].exerciseId);
    final second = await _exerciseNameForId(exercises[1].exerciseId);

    await _tapTab(tester, 'PlansPage');
    await tester.tap(find.byType(PlanTile).first);
    await tester.pumpAndSettle();
    expect(find.text(first), findsWidgets);

    await tester.enterText(find.bySemanticsLabel('Reps'), '5');
    await tester.enterText(find.bySemanticsLabel('Weight (kg)'), '60');
    await _tapSaveAction(tester);
    await tester.pumpAndSettle();
    expect(find.text(second), findsWidgets);

    await tester.enterText(find.bySemanticsLabel('Reps'), '6');
    await tester.enterText(find.bySemanticsLabel('Weight (kg)'), '70');
    await _tapSaveAction(tester);
    await tester.pumpAndSettle();
    final logged = await _setsForPlan(plan.id);
    expect(logged.map((row) => row.name).toSet(), containsAll({first, second}));

    final finishedWorkout =
        await (app.db.workouts.select()..where(
              (row) => row.planId.equals(plan.id) & row.endedAt.isNull(),
            ))
            .getSingle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    final endedWorkout =
        await (app.db.workouts.select()
              ..where((row) => row.id.equals(finishedWorkout.id)))
            .getSingle();
    expect(endedWorkout.endedAt, isNotNull);

    await tester.tap(find.byType(PlanTile).first);
    await tester.pumpAndSettle();
    expect(find.text('Set 1'), findsNothing);
    final newWorkout =
        await (app.db.workouts.select()..where(
              (row) => row.planId.equals(plan.id) & row.endedAt.isNull(),
            ))
            .getSingle();
    expect(newWorkout.id, isNot(finishedWorkout.id));
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await _tapTab(tester, 'GraphsPage');
    await tester.enterText(find.byType(SearchBar), first);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ListTile, first), findsOneWidget);
    await tester.enterText(find.byType(SearchBar), second);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ListTile, second), findsOneWidget);
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
    final originalFirst = await _exerciseNameForId(exercises.first.exerciseId);
    final originalSecond = await _exerciseNameForId(exercises[1].exerciseId);

    await tester.tap(find.byType(PlanTile).first);
    await tester.pumpAndSettle();
    final firstHandle = find.descendant(
      of: find.byKey(Key(originalFirst)),
      matching: find.byIcon(Icons.drag_handle),
    );
    await tester.drag(firstHandle, const Offset(0, 70));
    await tester.pumpAndSettle();

    exercises =
        await (app.db.planExercises.select()
              ..where((tbl) => tbl.planId.equals(plan.id) & tbl.enabled)
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.sequence)]))
            .get();
    expect(
      await _exerciseNameForId(exercises.first.exerciseId),
      originalSecond,
    );
    expect(await _exerciseNameForId(exercises[1].exerciseId), originalFirst);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Timer stopwatch and countdown controls work on Linux', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(899, 700));
    await _tapTab(tester, 'TimerPage');

    expect(find.text('Start stopwatch'), findsOneWidget);
    await tester.tap(find.text('Start stopwatch'));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Pause'), findsOneWidget);
    expect(find.text('Restart'), findsOneWidget);

    await tester.tap(find.text('Pause'));
    await tester.pumpAndSettle();
    expect(find.text('Start stopwatch'), findsOneWidget);
    await tester.tap(find.text('Restart'));
    await tester.pumpAndSettle();
    expect(find.text('+1 minute'), findsOneWidget);

    await tester.tap(find.text('+1 minute'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Stop timer'), findsOneWidget);
    await tester.tap(find.text('Stop timer'));
    await tester.pumpAndSettle();
    expect(find.text('Start stopwatch'), findsOneWidget);
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
    final showImagesBefore = settings.showImages;
    await tester.ensureVisible(showImages);
    await tester.tap(showImages);
    await tester.pumpAndSettle();
    settings = await (app.db.settings.select()..limit(1)).getSingle();
    expect(settings.showImages, !showImagesBefore);

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
    expect(find.text('Backup'), findsOneWidget);
    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Import data'));
    await tester.pumpAndSettle();
    expect(find.text('Graphs'), findsOneWidget);
    expect(find.text('Plans'), findsOneWidget);
    expect(find.text('Backup'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Graphs zero-exercise state remains usable', (tester) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await app.db.exerciseSets.deleteAll();
    await tester.pumpAndSettle();
    await _tapTab(tester, 'GraphsPage');
    expect(find.text('Global progress'), findsNothing);
    expect(find.text('No graphs found'), findsNothing);
    expect(find.text('New exercise'), findsOneWidget);
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
    await tester.tap(
      find.widgetWithText(FilledButton, 'Add “Linux E2E new strength graph”'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Add exercise'), findsOneWidget);
    expect(find.bySemanticsLabel('Name'), findsOneWidget);
    await _tapSaveAction(tester);
    await tester.pumpAndSettle();

    var template = await _exerciseNamed('Linux E2E new strength graph');
    expect(template.kind, 'strength');
    expect(template.displayUnit, 'kg');
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
    await tester.tap(
      find.widgetWithText(FilledButton, 'Add “Linux E2E new cardio graph”'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Strength'));
    await tester.pumpAndSettle();
    await tester.tap(_dropdownWithLabel('Unit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Miles (mi)').last);
    await tester.pumpAndSettle();
    await _tapSaveAction(tester);
    await tester.pumpAndSettle();

    final template = await _exerciseNamed('Linux E2E new cardio graph');
    expect(template.kind, 'cardio');
    expect(template.displayUnit, 'mi');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Plan editor can create a weighted-cardio exercise', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(1000, 900));
    await _tapTab(tester, 'PlansPage');
    await tester.tap(find.text('New plan'));
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
    await tester.tap(
      find.widgetWithText(FilledButton, 'Add “Linux E2E weighted hang”'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Strength'));
    await tester.pumpAndSettle();
    expect(find.text('Kilometers (km)'), findsOneWidget);
    await tester.tap(_dropdownWithLabel('Unit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kilograms (kg)').last);
    await tester.pumpAndSettle();
    await _tapSaveAction(tester);
    await tester.pumpAndSettle();
    expect(
      find.widgetWithText(ListTile, 'Linux E2E weighted hang'),
      findsOneWidget,
    );
    await _tapSaveAction(tester);
    await tester.pumpAndSettle();

    final plan =
        await (app.db.plans.select()
              ..where((tbl) => tbl.title.equals('Linux E2E weighted plan')))
            .getSingle();
    expect(plan.days.split(',').toSet(), {'Monday', 'Wednesday'});
    final planExercise = (await _planExerciseForName(
      plan.id,
      'Linux E2E weighted hang',
    ))!;
    expect(planExercise.enabled, isTrue);
    final template = await _exerciseNamed('Linux E2E weighted hang');
    expect(template.kind, 'cardio');
    expect(template.displayUnit, 'kg');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Graph rename conflict cancel and confirm are safe', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await _insertE2ESet(
      name: 'Linux E2E rename source',
      reps: 5,
      weight: 50,
      created: DateTime(2026, 9, 1, 10),
    );
    await _insertE2ESet(
      name: 'Linux E2E rename target',
      reps: 6,
      weight: 60,
      created: DateTime(2026, 9, 1, 11),
    );
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
    expect(await _setsNamed('Linux E2E rename source'), hasLength(1));

    await tester.tap(find.text('Update'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Confirm'));
    await tester.pumpAndSettle();
    expect(await _setsNamed('Linux E2E rename source'), isEmpty);
    expect(await _setsNamed('Linux E2E rename target'), hasLength(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Graph desktop delete cancel and confirm work', (tester) async {
    await _pumpIsolatedApp(tester);
    await _insertE2ESet(
      name: 'Linux E2E selectable graph A',
      reps: 5,
      weight: 50,
      created: DateTime(2026, 9, 1, 10),
    );
    await _insertE2ESet(
      name: 'Linux E2E selectable graph B',
      reps: 6,
      weight: 60,
      created: DateTime(2026, 9, 1, 11),
    );
    await _tapTab(tester, 'GraphsPage');
    await tester.enterText(
      find.byType(SearchBar),
      'Linux E2E selectable graph',
    );
    await tester.pumpAndSettle();

    final graphA = find.widgetWithText(
      ListTile,
      'Linux E2E selectable graph A',
    );
    await _secondaryTap(tester, graphA);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(await _setsMatching('Linux E2E selectable graph'), hasLength(2));

    await _secondaryTap(
      tester,
      find.widgetWithText(ListTile, 'Linux E2E selectable graph B'),
    );
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(await _setsNamed('Linux E2E selectable graph A'), hasLength(1));
    expect(await _setsNamed('Linux E2E selectable graph B'), isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Graph bulk unit edit converts cardio distance', (tester) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await _insertE2ESet(
      name: 'Linux E2E cardio conversion',
      reps: 0,
      weight: 0,
      unit: 'km',
      created: DateTime(2026, 8, 31, 12),
      cardio: true,
      duration: 50,
      distance: 10,
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

    final row = await _singleSet('Linux E2E cardio conversion');
    expect(row.unit, 'mi');
    expect(row.distance, closeTo(6.21371, 0.0001));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Graph editor handles an unmanaged legacy category', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await _insertE2ESet(
      name: 'Linux E2E legacy category',
      reps: 5,
      weight: 100,
      created: DateTime(2026, 8, 31, 12),
      category: 'Legacy imported category',
    );
    await tester.pumpAndSettle();

    await _tapTab(tester, 'GraphsPage');
    await tester.enterText(find.byType(SearchBar), 'Linux E2E legacy category');
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(ListTile, 'Linux E2E legacy category'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();

    expect(find.text('Legacy imported category'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Graph bulk unit edit converts strength weight', (tester) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await app.db
        .into(app.db.categories)
        .insert(CategoriesCompanion.insert(name: 'Linux Original Category'));
    await app.db
        .into(app.db.categories)
        .insert(CategoriesCompanion.insert(name: 'Linux Target Category'));
    await _insertE2ESet(
      name: 'Linux E2E strength conversion',
      reps: 5,
      weight: 100,
      created: DateTime(2026, 8, 31, 12),
      category: 'Linux Original Category',
    );
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

    final row = await _singleSet('Linux E2E strength conversion');
    expect(row.unit, 'lb');
    expect(row.weight, closeTo(220.462262, 0.0001));
    expect(row.category, 'Linux Target Category');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Graph unit change preserves canonical historical loads', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await _insertE2ESet(
      name: 'Linux E2E unit presentation',
      reps: 5,
      weight: 100,
      created: DateTime(2026, 8, 31, 12),
    );
    await _insertE2ESet(
      name: 'Linux E2E unit presentation',
      reps: 5,
      weight: 110,
      created: DateTime(2026, 9, 1, 12),
    );
    final canonicalBefore =
        (await app.db.exerciseSets.select().get())
            .where((row) => row.loadKg == 100 || row.loadKg == 110)
            .map((row) => row.loadKg)
            .toList()
          ..sort();

    await _tapTab(tester, 'GraphsPage');
    await tester.enterText(
      find.byType(SearchBar),
      'Linux E2E unit presentation',
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(ListTile, 'Linux E2E unit presentation'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();
    await tester.tap(_dropdownWithLabel('Unit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Stone').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Update'));
    await tester.pumpAndSettle();

    final rows = await _setsNamed('Linux E2E unit presentation');
    expect(rows.map((row) => row.unit).toSet(), {'stone'});
    final canonicalAfter =
        (await app.db.exerciseSets.select().get())
            .where((row) => row.loadKg == 100 || row.loadKg == 110)
            .map((row) => row.loadKg)
            .toList()
          ..sort();
    expect(canonicalAfter, canonicalBefore);
    expect(tester.takeException(), isNull);
  });

  testWidgets('History empty state and validation paths are safe', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await _tapTab(tester, 'HistoryPage');
    expect(find.text('No entries yet'), findsOneWidget);

    await _tapAddAction(tester);
    await tester.pumpAndSettle();
    await _tapSaveAction(tester);
    await tester.pumpAndSettle();
    expect(find.text('Required'), findsWidgets);

    await tester.enterText(find.bySemanticsLabel('Name'), 'Invalid E2E set');
    await tester.enterText(find.bySemanticsLabel('Reps'), 'abc');
    await tester.enterText(find.bySemanticsLabel('Weight (kg)'), 'xyz');
    await _tapSaveAction(tester);
    await tester.pumpAndSettle();
    expect(find.text('Invalid number'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('History search and numeric/category filters work', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
    await _insertE2ESet(
      name: 'Linux E2E filter light',
      reps: 5,
      weight: 40,
      created: DateTime(2026, 8, 30, 12),
      category: 'E2E Light',
    );
    await _insertE2ESet(
      name: 'Linux E2E filter heavy',
      reps: 12,
      weight: 100,
      created: DateTime(2026, 9, 1, 12),
      category: 'E2E Heavy',
    );
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

  testWidgets('History desktop context edit and delete work', (tester) async {
    await _pumpIsolatedApp(tester);
    await _insertE2ESet(
      name: 'Linux E2E bulk A',
      reps: 5,
      weight: 50,
      created: DateTime(2026, 9, 1, 10),
    );
    await _insertE2ESet(
      name: 'Linux E2E bulk B',
      reps: 6,
      weight: 60,
      created: DateTime(2026, 9, 1, 11),
    );
    await tester.pumpAndSettle();
    await _tapTab(tester, 'HistoryPage');
    await tester.enterText(find.byType(SearchBar), 'Linux E2E bulk');
    await tester.pumpAndSettle();

    await _secondaryTap(tester, find.text('Linux E2E bulk A'));
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(_textFieldWithLabel('Reps'), '10');
    await _tapSaveAction(tester);
    await tester.pumpAndSettle();

    final edited = await _setsNamed('Linux E2E bulk A');
    expect(edited, hasLength(1));
    expect(edited.single.reps, 10);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Enter Weight saves canonical value without mutating old set snapshots',
    (tester) async {
      await _pumpIsolatedApp(tester, surfaceSize: const Size(900, 900));
      final baseline = await _insertE2ESet(
        name: 'Linux E2E bodyweight baseline',
        reps: 5,
        weight: 50,
        created: DateTime(2026, 9, 1, 9),
      );
      expect(baseline.bodyWeight, 0);
      await tester.pumpAndSettle();
      await _tapTab(tester, 'HistoryPage');
      await tester.tap(find.byTooltip('Show menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ListTile, 'Weight'));
      await tester.pumpAndSettle();
      expect(find.text('Enter Weight'), findsOneWidget);

      await _tapSaveAction(tester);
      await tester.pumpAndSettle();
      expect(find.text('Required'), findsOneWidget);
      await tester.enterText(_textFieldWithLabel('Weight'), '82');
      await tester.tap(_dropdownWithLabel('Unit'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pounds (lb)').last);
      await tester.pumpAndSettle();
      await _tapSaveAction(tester);
      await tester.pumpAndSettle();

      final weightRow =
          await (app.db.bodyWeights.select()
                ..orderBy([
                  (row) => OrderingTerm.desc(row.timestamp),
                  (row) => OrderingTerm.desc(row.id),
                ])
                ..limit(1))
              .getSingle();
      expect(weightRow.weightKg, closeTo(82 * 0.45359237, 0.0001));
      final unchanged = await getPerformedSetById(app.db, baseline.id);
      expect(unchanged, isNotNull);
      expect(unchanged!.bodyWeight, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Plan create, title/day search, edit, select-all and delete work',
    (tester) async {
      await _pumpIsolatedApp(tester, surfaceSize: const Size(899, 900));
      await _tapTab(tester, 'PlansPage');
      await tester.tap(find.text('New plan'));
      await tester.pumpAndSettle();
      await tester.enterText(
        _textFieldWithLabel('Title (optional)'),
        'Linux E2E custom plan',
      );
      await tester.tap(find.text('Mon'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(SearchBar), 'Linux E2E plan exercise');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add “Linux E2E plan exercise”').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save plan'));
      await tester.pumpAndSettle();

      var plan =
          await (app.db.plans.select()
                ..where((tbl) => tbl.title.equals('Linux E2E custom plan')))
              .getSingle();
      expect(plan.days, 'Monday');
      final createdPlanExercise = await _planExerciseForName(
        plan.id,
        'Linux E2E plan exercise',
      );
      expect(createdPlanExercise, isNotNull);
      expect(createdPlanExercise!.enabled, isTrue);

      final planSearch = find.byType(SearchBar);
      final customPlanTile = find.widgetWithText(
        PlanTile,
        'Linux E2E custom plan',
      );
      await tester.enterText(planSearch, 'Linux E2E custom plan');
      await tester.pumpAndSettle();
      expect(customPlanTile, findsOneWidget);
      await tester.enterText(planSearch, 'Monday');
      await tester.pumpAndSettle();
      expect(customPlanTile, findsOneWidget);
      await tester.enterText(planSearch, 'Linux E2E custom plan');
      await tester.pumpAndSettle();

      await _secondaryTap(tester, customPlanTile);
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
      await tester.tap(find.text('Save plan'));
      await tester.pumpAndSettle();

      plan =
          await (app.db.plans.select()..where((tbl) => tbl.id.equals(plan.id)))
              .getSingle();
      expect(plan.title, 'Linux E2E edited plan');
      expect(plan.days.split(',').toSet(), {'Monday', 'Tuesday'});

      final clearSelection = find.byTooltip('Clear selection');
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
      await tester.tap(find.byTooltip('Delete selected'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();
      expect(
        await (app.db.plans.select()..where((tbl) => tbl.id.equals(plan.id)))
            .getSingleOrNull(),
        isNotNull,
      );
      await tester.tap(find.byTooltip('Delete selected'));
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
    await _insertE2ESet(
      name: 'Linux E2E strength detail',
      reps: 5,
      weight: 80,
      created: DateTime(2026, 8, 31, 12),
    );
    await _insertE2ESet(
      name: 'Linux E2E strength detail',
      reps: 6,
      weight: 82,
      created: DateTime(2026, 9, 1, 12),
    );
    final timeAxisBefore = (await _exerciseNamed(
      'Linux E2E strength detail',
    )).graphTimeBasedXAxis;
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
    await _openGraphOptionsIfNeeded(tester);
    expect(find.text('Use time-based X axis'), findsOneWidget);
    final timeAxisSwitch = find.descendant(
      of: find
          .ancestor(
            of: find.text('Use time-based X axis'),
            matching: find.byType(Row),
          )
          .first,
      matching: find.byType(Switch),
    );
    await tester.tap(timeAxisSwitch);
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(timeAxisSwitch).value, !timeAxisBefore);
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
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    final pref = await _exerciseNamed('Linux E2E strength detail');
    expect(pref.graphMetric, 'volume');
    expect(pref.graphPeriod, 'month');
    expect(pref.graphTimeBasedXAxis, !timeAxisBefore);
    expect(pref.graphLimit, greaterThan(10));
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
    expect(await _maybeExerciseNamed('Linux E2E strength detail'), isNull);
    final renamedPref = await _exerciseNamed('Linux E2E strength renamed');
    expect(renamedPref.graphMetric, 'volume');
    expect(renamedPref.graphPeriod, 'month');
    expect(renamedPref.notes, 'Linux E2E graph notes');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Weighted cardio uses weight in History and Graphs', (
    tester,
  ) async {
    await _pumpIsolatedApp(tester, surfaceSize: const Size(1000, 900));
    await _tapTab(tester, 'HistoryPage');
    await _tapAddAction(tester);
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
    await _tapSaveAction(tester);
    await tester.pumpAndSettle();

    var row = await _singleSet('Linux E2E dead hang');
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

    row = await _singleSet('Linux E2E dead hang');
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
    await _insertE2ESet(
      name: 'Linux E2E cardio old',
      reps: 0,
      weight: 0,
      unit: 'km',
      created: DateTime(2026, 9, 1, 12),
      cardio: true,
      duration: 30,
      distance: 5,
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

    expect(await _maybeSet('Linux E2E cardio renamed'), isNotNull);
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

    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('Barbell bench press')),
        matching: find.byIcon(Icons.more_horiz_rounded),
      ),
    );
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

    var planExercise = (await _planExerciseForName(1, 'Barbell bench press'))!;
    expect(planExercise.warmupSets, 1);
    expect(planExercise.maxSets, 2);
    expect(planExercise.timers, isFalse);

    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('Squat')),
        matching: find.byIcon(Icons.more_horiz_rounded),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Swap'));
    await tester.pumpAndSettle();
    expect(find.text('Swap workout'), findsOneWidget);
    await tester.enterText(
      _textFieldWithLabel('Search exercises...'),
      'Arnold press',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Arnold press'));
    await tester.pumpAndSettle();

    expect(await _planExerciseForName(1, 'Squat'), isNull);
    expect(await _planExerciseForName(1, 'Arnold press'), isNotNull);
    expect(find.byKey(const Key('Arnold press')), findsOneWidget);

    await tester.enterText(find.bySemanticsLabel('Reps'), '5');
    await tester.enterText(find.bySemanticsLabel('Weight (kg)'), '50');
    await _tapSaveAction(tester);
    await tester.pumpAndSettle();
    expect(find.text('Set 1'), findsOneWidget);

    var logged = await _setsForPlan(1);
    expect(logged, hasLength(1));
    final loggedName = logged.single.name;

    await tester.tap(find.text('Set 1'));
    await tester.pumpAndSettle();
    await tester.enterText(find.bySemanticsLabel('Reps'), '7');
    await _tapSaveAction(tester);
    await tester.pumpAndSettle();
    logged = await _setsForPlan(1);
    expect(logged.single.reps, 7);

    await tester.tap(
      find.descendant(
        of: find.byKey(Key(loggedName)),
        matching: find.byIcon(Icons.more_horiz_rounded),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Undo'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
    await tester.tap(find.widgetWithText(ListTile, 'Undo'));
    await tester.pumpAndSettle();
    logged = await _setsForPlan(1);
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
    await _tapSaveAction(tester);
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
    await _insertE2ESet(
      name: 'Linux E2E custom rest',
      reps: 5,
      weight: 50,
      created: DateTime(2026, 9, 1, 12),
      restMs: 90000,
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
    final restSeconds = _textFieldWithLabel('Seconds').first;
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
    final customSeconds = _textFieldWithLabel('Seconds').last;
    await tester.enterText(customMinutes, '2');
    await tester.pumpAndSettle();
    await tester.enterText(customSeconds, '10');
    await tester.pumpAndSettle();
    var row = await _singleSet('Linux E2E custom rest');
    expect(row.restMs, 130000);

    await tester.tap(
      find.byTooltip('Remove custom timer (use global default)'),
    );
    await tester.pumpAndSettle();
    row = await _singleSet('Linux E2E custom rest');
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

    final appearanceBefore = settings;
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
    expect(settings.systemColors, !appearanceBefore.systemColors);
    expect(settings.showGlobalProgress, !appearanceBefore.showGlobalProgress);
    expect(settings.peekGraph, !appearanceBefore.peekGraph);
    expect(settings.curveLines, !appearanceBefore.curveLines);

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
    final workoutScrollable = find
        .descendant(
          of: find.byType(WorkoutSettings),
          matching: find.byType(Scrollable),
        )
        .first;
    for (final title in [
      'Group history',
      'Show units',
      'Show body weight',
      'Show categories',
      'Show notes',
      'Positive reinforcement',
      'Rep estimation',
      'Duration estimation',
      'Show graph X axis toggle',
      'Show graph limit',
      'Default time-based X axis',
    ]) {
      final tile = find.widgetWithText(ListTile, title);
      if (tile.evaluate().isEmpty) {
        await tester.scrollUntilVisible(
          tile,
          260,
          scrollable: workoutScrollable,
        );
      } else {
        await tester.ensureVisible(tile);
      }
      await tester.tap(tile);
      await tester.pumpAndSettle();
    }

    await tester.scrollUntilVisible(
      _dropdownWithLabel('Default graph metric'),
      260,
      scrollable: workoutScrollable,
    );
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
    await _tapAddAction(tester);
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
    await _insertE2ESet(
      name: 'Linux E2E deletable graph',
      reps: 5,
      weight: 50,
      created: DateTime(2026, 9, 1, 12),
    );
    await _openSettingsSection(tester, 'Data management');
    await tester.tap(find.text('Delete records'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Graphs'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(await _maybeSet('Linux E2E deletable graph'), isNotNull);

    await tester.tap(find.text('Delete records'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Graphs'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(await _maybeSet('Linux E2E deletable graph'), isNull);

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
    await tester.tap(find.byTooltip('About'));
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
    expect(tester.takeException(), isNull);
  });
}
