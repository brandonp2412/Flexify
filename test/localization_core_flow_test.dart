import 'package:flexify/animated_fab.dart';
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/l10n/generated/app_localizations.dart';
import 'package:flexify/stepper_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

Future<void> _pumpNavigation(WidgetTester tester, Locale locale) async {
  final harness = await FlexifyTestHarness.create();
  await harness.pump(
    tester,
    Scaffold(
      body: const SizedBox.expand(),
      bottomNavigationBar: BottomNav(
        tabs: const [
          'HistoryPage',
          'PlansPage',
          'GraphsPage',
          'TimerPage',
          'SettingsPage',
        ],
        currentIndex: 4,
        onTap: (_) {},
      ),
    ),
    locale: locale,
    surfaceSize: const Size(320, 640),
    textScaler: const TextScaler.linear(1.5),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('core navigation renders German labels at narrow text scale', (
    tester,
  ) async {
    const locale = Locale('de');
    final l10n = lookupAppLocalizations(locale);

    await _pumpNavigation(tester, locale);

    expect(find.text(l10n.navSettings), findsOneWidget);
    expect(find.byTooltip(l10n.navHistory), findsOneWidget);
    expect(find.byTooltip(l10n.navPlans), findsOneWidget);
    expect(find.byTooltip(l10n.navGraphs), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics && widget.properties.label == l10n.navSettings,
      ),
      findsWidgets,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('localized save FAB fits narrow scaled workout layout', (
    tester,
  ) async {
    const locale = Locale('ja');
    final l10n = lookupAppLocalizations(locale);
    final harness = await FlexifyTestHarness.create();

    await harness.pump(
      tester,
      Scaffold(
        floatingActionButton: AnimatedFab(
          onPressed: () {},
          label: Text(l10n.actionSave),
          icon: const Icon(Icons.save),
          bottomPadding: 0,
        ),
      ),
      locale: locale,
      surfaceSize: const Size(320, 640),
      textScaler: const TextScaler.linear(1.5),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('localized stepper fits narrow scaled workout layout', (
    tester,
  ) async {
    const locale = Locale('ja');
    final l10n = lookupAppLocalizations(locale);
    final controller = TextEditingController(text: '50');
    addTearDown(controller.dispose);
    final harness = await FlexifyTestHarness.create();

    await harness.pump(
      tester,
      Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: StepperField(
            controller: controller,
            labelText: l10n.weightWithUnit('kg'),
            step: 2.5,
            suffixIcon: IconButton(
              tooltip: l10n.useBodyWeight,
              onPressed: () {},
              icon: const Icon(Icons.scale),
            ),
          ),
        ),
      ),
      locale: locale,
      surfaceSize: const Size(320, 640),
      textScaler: const TextScaler.linear(1.5),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('core navigation renders Japanese labels at narrow text scale', (
    tester,
  ) async {
    const locale = Locale('ja');
    final l10n = lookupAppLocalizations(locale);

    await _pumpNavigation(tester, locale);

    expect(find.text(l10n.navSettings), findsOneWidget);
    expect(find.byTooltip(l10n.navHistory), findsOneWidget);
    expect(find.byTooltip(l10n.navPlans), findsOneWidget);
    expect(find.byTooltip(l10n.navGraphs), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics && widget.properties.label == l10n.navSettings,
      ),
      findsWidgets,
    );
    expect(tester.takeException(), isNull);
  });
}
