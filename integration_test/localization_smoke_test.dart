import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/home_page.dart';
import 'package:flexify/l10n/generated/app_localizations.dart';
import 'package:flexify/main.dart' as app;
import 'package:flexify/plan/start_plan_page.dart';
import 'package:flexify/stepper_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/support/fixtures.dart';

Finder _textFieldWithLabel(String label) => find.descendant(
  of: find.byWidgetPredicate(
    (widget) => widget is StepperField && widget.labelText == label,
  ),
  matching: find.byType(EditableText),
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('renders CJK navigation with platform font fallback', (
    tester,
  ) async {
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
        explainedPermissions: Value(true),
        notificationPermissionRequested: Value(true),
        systemColors: Value(false),
        localeOverride: Value('ja'),
      ),
    );
    final initial = await (database.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(app.appProviders(initial));
    await tester.pumpAndSettle();

    const localeCases = <String, Locale>{
      'ja': Locale('ja'),
      'ko': Locale('ko'),
      'zh-CN': Locale('zh', 'CN'),
    };
    for (final entry in localeCases.entries) {
      if (entry.key != 'ja') {
        await database.settings.update().write(
          SettingsCompanion(localeOverride: Value(entry.key)),
        );
        await tester.pump();
        await tester.pump();
      }

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.locale, entry.value, reason: entry.key);
      final l10n = lookupAppLocalizations(entry.value);
      expect(find.text(l10n.navHistory), findsWidgets, reason: entry.key);
      expect(find.text(l10n.appTitle), findsWidgets, reason: entry.key);
      expect(tester.takeException(), isNull, reason: entry.key);
    }
  });

  testWidgets('switches locale and saves a non-English workout', (
    tester,
  ) async {
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
        explainedPermissions: Value(true),
        notificationPermissionRequested: Value(true),
        restTimers: Value(false),
        notifications: Value(false),
        systemColors: Value(false),
        localeOverride: Value('ja'),
      ),
    );
    final planId = await database.plans.insertOne(
      planFixture(title: 'User integration plan'),
    );
    const exercise = 'User integration press';
    await database.planExercises.insertOne(
      planExerciseFixture(planId: planId, exercise: exercise),
    );
    final plan =
        await (database.plans.select()..where((row) => row.id.equals(planId)))
            .getSingle();
    final initial = await (database.settings.select()..limit(1)).getSingle();

    await tester.pumpWidget(app.appProviders(initial));
    await tester.pumpAndSettle();
    MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
    expect(materialApp.locale, const Locale('ja'));

    await database.settings.update().write(
      const SettingsCompanion(localeOverride: Value('de')),
    );
    await tester.pump();
    await tester.pump();
    materialApp = tester.widget(find.byType(MaterialApp));
    expect(materialApp.locale, const Locale('de'));

    final context = tester.element(find.byType(HomePage));
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => StartPlanPage(plan: plan)));
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('de'));
    expect(find.textContaining(exercise), findsWidgets);
    await tester.enterText(_textFieldWithLabel(l10n.repsLabel), '5');
    await tester.enterText(
      _textFieldWithLabel(l10n.weightWithUnit('kg')),
      '50,5',
    );
    await tester.tap(find.text(l10n.saveSet));
    await tester.pumpAndSettle();

    final saved =
        await (database.gymSets.select()
              ..where((row) => row.name.equals(exercise))
              ..orderBy([(row) => OrderingTerm.desc(row.created)])
              ..limit(1))
            .getSingle();
    expect(saved.name, exercise);
    expect(saved.reps, 5);
    expect(saved.weight, 50.5);
    expect(tester.takeException(), isNull);
  });
}
