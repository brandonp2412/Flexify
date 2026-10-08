import 'package:drift/drift.dart' hide Column;
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/graphs_page.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plans_page.dart';
import 'package:flexify/plan/start_plan_page.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/sets/history_page.dart';
import 'package:flexify/settings/category_management_page.dart';
import 'package:flexify/settings/settings_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/settings/whats_new.dart';
import 'package:flexify/timer/timer_page.dart';
import 'package:flexify/timer/timer_progress_widgets.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flexify/utils.dart';
import 'package:flexify/platform_page_route.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _controller;
  late final PageController _desktopPageController;
  late final TimerState _timerState;
  final GlobalKey<PlansPageState> _plansPageKey = GlobalKey<PlansPageState>();

  @override
  void initState() {
    super.initState();

    final setting = context.read<SettingsState>().value.tabs;
    final tabs = setting.split(',');
    _controller = TabController(length: tabs.length, vsync: this);
    _desktopPageController = PageController();
    _timerState = context.read<TimerState>();
    _timerState.addListener(_handleTimerNotificationTarget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleTimerNotificationTarget();
    });

    final info = PackageInfo.fromPlatform();
    info.then((pkg) async {
      final buildNumber = int.tryParse(pkg.buildNumber);
      if (buildNumber == null) return;
      final settings = await (db.settings.select()..limit(1)).getSingle();
      final previousBuildNumber = settings.buildNumber;
      await db.settings.update().write(
        SettingsCompanion(buildNumber: Value(buildNumber)),
      );

      if (previousBuildNumber == null || buildNumber == previousBuildNumber) {
        return;
      }

      if (mounted)
        toast(
          context.l10n.newVersion(pkg.version),
          action: SnackBarAction(
            label: context.l10n.changes,
            onPressed: () => Navigator.of(
              context,
            ).push(FlexPageRoute(builder: (context) => const WhatsNew())),
          ),
        );
    });
  }

  void _selectDesktopTab(int index) {
    if (_controller.index != index) {
      _controller.index = index;
    }
    if (_desktopPageController.hasClients) {
      _desktopPageController.jumpToPage(index);
    }
  }

  Future<void> _handleTimerNotificationTarget() async {
    if (!mounted) return;
    final target = _timerState.consumeNotificationTarget();
    if (target == null) return;

    final navigator = Navigator.of(context);
    final tabs = context.read<SettingsState>().value.tabs.split(',');
    if (target == 'history' || target == 'timer') {
      final tab = target == 'history' ? 'HistoryPage' : 'TimerPage';
      final index = tabs.indexOf(tab);
      if (index >= 0 && index < _controller.length) {
        if (isDesktopLayout(context)) {
          _selectDesktopTab(index);
        } else {
          _controller.animateTo(index);
        }
      } else if (target == 'timer') {
        await navigator.push(
          FlexPageRoute(builder: (context) => const TimerPage()),
        );
      }
      return;
    }

    if (!target.startsWith('plan:')) return;
    final planId = int.tryParse(target.substring('plan:'.length));
    if (planId == null) return;
    final plan =
        await (db.plans.select()..where((row) => row.id.equals(planId)))
            .getSingleOrNull();
    if (plan == null || !mounted) return;

    final plansIndex = tabs.indexOf('PlansPage');
    if (plansIndex >= 0 && plansIndex < _controller.length) {
      if (isDesktopLayout(context)) {
        _selectDesktopTab(plansIndex);
      } else {
        _controller.animateTo(plansIndex);
      }
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;

      final plansPage = _plansPageKey.currentState;
      if (plansPage != null) {
        await plansPage.openPlanFromNotification(plan);
        return;
      }
    }

    await navigator.push(
      FlexPageRoute(
        settings: RouteSettings(name: 'start-plan:$planId'),
        builder: (context) => StartPlanPage(plan: plan),
      ),
    );
  }

  @override
  void dispose() {
    _timerState.removeListener(_handleTimerNotificationTarget);
    _controller.dispose();
    _desktopPageController.dispose();
    super.dispose();
  }

  void hideTab(BuildContext context, String tab) async {
    final state = context.read<SettingsState>();
    final tabs = state.value.tabs.split(',');

    if (tabs.length == 1) return toast(context.l10n.cannotHideAllTabs);

    final label = BottomNav.labelForTab(context, tab);
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(BottomNav.iconForTab(tab)),
                  const SizedBox(width: 12),
                  Text(
                    context.l10n.removeTabQuestion(label),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.restoreTabFromSettings,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(context.l10n.actionCancel),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(context.l10n.actionRemove),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed != true) return;

    tabs.remove(tab);
    await db.settings.update().write(
      SettingsCompanion(tabs: Value(tabs.join(','))),
    );
    if (context.mounted) toast(context.l10n.removedTab(label));
  }

  @override
  Widget build(BuildContext context) {
    final tabSettings = context.select<SettingsState, String>(
      (settings) => settings.value.tabs,
    );
    final tabs = tabSettings.split(',');
    final scrollableTabs = context.select<SettingsState, bool>(
      (settings) => settings.value.scrollableTabs,
    );

    if (tabs.length != _controller.length) {
      final index = _controller.index.clamp(0, tabs.length - 1);
      _controller.dispose();
      _controller = TabController(
        length: tabs.length,
        initialIndex: index,
        vsync: this,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _desktopPageController.hasClients) {
          _desktopPageController.jumpToPage(index);
        }
      });
    }

    final desktop = isDesktopLayout(context);
    final pages = tabs.map((tab) {
      if (tab == 'HistoryPage') {
        return HistoryPage(tabController: _controller);
      } else if (tab == 'PlansPage') {
        return PlansPage(key: _plansPageKey, tabController: _controller);
      } else if (tab == 'GraphsPage') {
        return GraphsPage(tabController: _controller);
      } else if (tab == 'TimerPage') {
        return TimerPage(tabController: _controller);
      } else if (tab == 'SettingsPage') {
        return const SettingsPage();
      } else if (tab == 'CategoriesPage') {
        return const CategoryManagementPage(asTab: true);
      } else {
        return ErrorWidget(context.l10n.tabContentError);
      }
    }).toList();

    final content = Stack(
      children: [
        if (desktop)
          PageView(
            controller: _desktopPageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              if (_controller.index != index) _controller.index = index;
            },
            children: pages,
          )
        else
          TabBarView(
            controller: _controller,
            physics: scrollableTabs
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            children: pages,
          ),
        if (!desktop && scrollableTabs) ...[
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 30,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragUpdate: (_) {},
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 30,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragUpdate: (_) {},
            ),
          ),
        ],
        if (!desktop)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder(
              valueListenable: _controller.animation!,
              builder: (context, value, child) {
                return BottomNav(
                  tabs: tabs,
                  currentIndex: value.round(),
                  onTap: _controller.animateTo,
                  onLongPress: hideTab,
                );
              },
            ),
          ),
        Consumer<SettingsState>(
          builder: (context, settings, child) => Positioned(
            top: settings.value.progressPosition == 'top' ? 8 : null,
            bottom: settings.value.progressPosition == 'bottom'
                ? (desktop ? 12 : 0)
                : null,
            left: desktop ? 24 : 48,
            right: desktop ? 24 : 48,
            child: settings.value.progressPosition != 'none'
                ? const TimerProgressIndicator()
                : const SizedBox(),
          ),
        ),
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: !desktop,
      body: SafeArea(
        child: desktop
            ? Row(
                children: [
                  ListenableBuilder(
                    listenable: _controller,
                    builder: (context, child) => DesktopNav(
                      tabs: tabs,
                      currentIndex: _controller.index.clamp(0, tabs.length - 1),
                      onTap: _selectDesktopTab,
                      onSecondaryTap: hideTab,
                    ),
                  ),
                  Expanded(child: content),
                ],
              )
            : content,
      ),
    );
  }
}
