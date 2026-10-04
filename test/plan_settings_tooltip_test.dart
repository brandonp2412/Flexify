import 'package:flexify/l10n/generated/app_localizations.dart';
import 'package:flexify/settings/plan_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('plan trailing tooltip does not wrap the plan preview', (
    tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    const locale = Locale('en');
    final l10n = lookupAppLocalizations(locale);

    await harness.pump(
      tester,
      const PlanSettings(),
      locale: locale,
      surfaceSize: const Size(1200, 800),
    );
    await tester.pumpAndSettle();

    final tooltip = find.byTooltip(l10n.planTrailingDisplayDescription);
    expect(tooltip, findsOneWidget);
    expect(find.text(l10n.examplePlanExercises), findsOneWidget);
    expect(
      find.descendant(
        of: tooltip,
        matching: find.text(l10n.examplePlanExercises),
      ),
      findsNothing,
    );
  });
}
