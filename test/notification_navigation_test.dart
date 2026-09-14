import 'package:drift/drift.dart';
import 'package:flexify/plan/plans_page.dart';
import 'package:flexify/plan/start_plan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

class _PlansHost extends StatefulWidget {
  const _PlansHost();

  @override
  State<_PlansHost> createState() => _PlansHostState();
}

class _PlansHostState extends State<_PlansHost>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PlansPage(tabController: _controller);
}

void main() {
  testWidgets('plan notification reuses an open StartPlan route', (
    tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    addTearDown(harness.database.close);

    await harness.pump(tester, const _PlansHost());
    await tester.pump(const Duration(milliseconds: 300));

    final plan =
        await (harness.database.plans.select()
              ..where((row) => row.id.equals(1)))
            .getSingle();
    final plansState = tester.state<PlansPageState>(find.byType(PlansPage));

    plansState.navKey.currentState!.push(
      MaterialPageRoute(
        settings: const RouteSettings(name: 'start-plan:1'),
        builder: (context) => const Scaffold(body: Text('Existing workout')),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Existing workout'), findsOneWidget);
    expect(plansState.navKey.currentState!.canPop(), isTrue);

    plansState.openPlanFromNotification(plan);
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Existing workout'), findsOneWidget);
    expect(find.byType(StartPlanPage), findsNothing);
  });
}
