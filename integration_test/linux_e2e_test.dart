import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/home_page.dart';
import 'package:flexify/main.dart' as app;
import 'package:flexify/plan/plan_tile.dart';
import 'package:flexify/settings/settings_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/support/fixtures.dart';

const _allTabs = 'HistoryPage,PlansPage,GraphsPage,TimerPage,SettingsPage';

Future<Setting> _pumpIsolatedApp(
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

Future<ExerciseSetView> _insertE2ESet({
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
  final inserted = await insertExerciseSetFixture(
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
    return (await getExerciseSetById(app.db, inserted.id))!;
  }
  return inserted;
}

Future<List<ExerciseSetView>> _setsNamed(String name) =>
    getExerciseSetsForExercise(app.db, exerciseName: name);

Future<ExerciseSetView> _singleSet(String name) async =>
    (await _setsNamed(name)).single;

Future<ExerciseSetView?> _maybeSet(String name) async {
  final rows = await _setsNamed(name);
  return rows.isEmpty ? null : rows.single;
}

Future<List<ExerciseSetView>> _setsForPlan(int planId) async =>
    (await getExerciseSets(
      app.db,
    )).where((set) => set.planId == planId).toList(growable: false);

Future<Exercise> _exerciseNamed(String name) =>
    (app.db.exercises.select()..where((row) => row.name.equals(name)))
        .getSingle();

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
    final originalOrder = exercises.map((entry) => entry.id).toList();
    final originalFirst = await _exerciseNameForId(exercises.first.exerciseId);

    await tester.tap(find.byType(PlanTile).first);
    await tester.pumpAndSettle();
    final firstHandle = find.descendant(
      of: find.byKey(Key(originalFirst)),
      matching: find.byIcon(Icons.drag_handle),
    );
    await tester.drag(firstHandle, const Offset(0, 150));
    await tester.pumpAndSettle();

    exercises =
        await (app.db.planExercises.select()
              ..where((tbl) => tbl.planId.equals(plan.id) & tbl.enabled)
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.sequence)]))
            .get();
    final newOrder = exercises.map((entry) => entry.id).toList();
    expect(newOrder, isNot(equals(originalOrder)));
    expect(newOrder.toSet(), originalOrder.toSet());
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

  testWidgets('Enter Weight saves value without mutating old set snapshots', (
    tester,
  ) async {
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
    final unchanged = await getExerciseSetById(app.db, baseline.id);
    expect(unchanged, isNotNull);
    expect(unchanged!.bodyWeight, 0);
    expect(tester.takeException(), isNull);
  });

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
}
