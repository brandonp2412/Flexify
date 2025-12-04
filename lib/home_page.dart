import 'package:drift/drift.dart';
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/graphs_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plans_page.dart';
import 'package:flexify/sets/history_page.dart';
import 'package:flexify/settings/settings_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/settings/whats_new.dart';
import 'package:flexify/timer/timer_page.dart';
import 'package:flexify/timer/timer_progress_widgets.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();

    final setting = context.read<SettingsState>().value.tabs;
    final tabs = setting.split(',');
    controller = TabController(length: tabs.length, vsync: this);

    final info = PackageInfo.fromPlatform();
    info.then((pkg) async {
      final meta = await (db.metadata.select()..limit(1)).getSingleOrNull();
      if (meta == null)
        return db.metadata.insertOne(
          MetadataCompanion(buildNumber: Value(int.parse(pkg.buildNumber))),
        );
      else
        db.metadata.update().write(
              MetadataCompanion(
                buildNumber: Value(int.parse(pkg.buildNumber)),
              ),
            );

      if (int.parse(pkg.buildNumber) == meta.buildNumber) return null;

      if (mounted)
        toast(
          "New version ${pkg.version}",
          action: SnackBarAction(
            label: 'Changes',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const WhatsNew(),
              ),
            ),
          ),
        );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void hideTab(BuildContext context, String tab) {
    final state = context.read<SettingsState>();
    final old = state.value.tabs;
    var tabs = state.value.tabs.split(',');

    if (tabs.length == 1) return toast("Can't hide everything!");
    tabs.remove(tab);
    db.settings.update().write(
          SettingsCompanion(
            tabs: Value(tabs.join(',')),
          ),
        );
    toast(
      'Hid $tab',
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          db.settings.update().write(
                SettingsCompanion(
                  tabs: Value(old),
                ),
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final setting = context
        .select<SettingsState, String>((settings) => settings.value.tabs);
    final tabs = setting.split(',');
    final scrollableTabs = context.select<SettingsState, bool>(
      (settings) => settings.value.scrollableTabs,
    );

    if (tabs.length != controller.length) {
      controller.dispose();
      controller = TabController(length: tabs.length, vsync: this);
      if (controller.index >= tabs.length) controller.index = tabs.length - 1;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomSheet: tabs.contains('TimerPage')
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: const TimerProgressIndicator(),
            )
          : null,
      body: SafeArea(
        child: Stack(
          children: [
            TabBarView(
              controller: controller,
              physics: scrollableTabs
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              children: tabs.map((tab) {
                if (tab == 'HistoryPage')
                  return HistoryPage(tabController: controller);
                else if (tab == 'PlansPage')
                  return PlansPage(
                    tabController: controller,
                  );
                else if (tab == 'GraphsPage')
                  return GraphsPage(tabController: controller);
                else if (tab == 'TimerPage')
                  return const TimerPage();
                else if (tab == 'SettingsPage')
                  return const SettingsPage();
                else
                  return ErrorWidget("Couldn't build tab content.");
              }).toList(),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ValueListenableBuilder(
                valueListenable: controller.animation!,
                builder: (context, value, child) {
                  return BottomNav(
                    tabs: tabs,
                    currentIndex: value.round(),
                    onTap: (index) {
                      controller.animateTo(index);
                    },
                    onLongPress: hideTab,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
