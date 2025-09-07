import 'package:drift/drift.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/failed_migrations_page.dart';
import 'package:flexify/graph/graphs_page.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/sets/history_page.dart';
import 'package:flexify/settings/settings_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/settings/whats_new.dart';
import 'package:flexify/timer/timer_page.dart';
import 'package:flexify/timer/timer_progress_widgets.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'plan/plans_page.dart';

Future<void> main({bool hideChangelog = false}) async {
  WidgetsFlutterBinding.ensureInitialized();

  Setting setting;

  try {
    setting = await (db.settings.select()..limit(1)).getSingle();
  } catch (error) {
    return runApp(FailedMigrationsPage(error: error));
  }

  final state = SettingsState(setting);
  runApp(appProviders(state, hideChangelog: hideChangelog));
}

AppDatabase db = AppDatabase();

MethodChannel androidChannel =
    const MethodChannel("com.presley.flexify/android");

Widget appProviders(SettingsState state, {required bool hideChangelog}) =>
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => state),
        ChangeNotifierProvider(create: (context) => TimerState()),
        ChangeNotifierProvider(create: (context) => PlanState()),
      ],
      child: App(hideChangelog: hideChangelog),
    );

class App extends StatelessWidget {
  final bool hideChangelog;
  const App({super.key, required this.hideChangelog});

  @override
  Widget build(BuildContext context) {
    final colors = context.select<SettingsState, bool>(
      (settings) => settings.value.systemColors,
    );
    final mode = context.select<SettingsState, ThemeMode>(
      (settings) => ThemeMode.values
          .byName(settings.value.themeMode.replaceFirst('ThemeMode.', '')),
    );

    final light = ColorScheme.fromSeed(seedColor: Colors.deepPurple);
    final dark = ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    );

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final settings = context.watch<SettingsState>();
        final currentBrightness =
            settings.value.themeMode == 'ThemeMode.dark' ||
                    (settings.value.themeMode == 'ThemeMode.system' &&
                        MediaQuery.of(context).platformBrightness ==
                            Brightness.dark)
                ? Brightness.dark
                : Brightness.light;

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarIconBrightness: currentBrightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
            systemNavigationBarIconBrightness:
                currentBrightness == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark,
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
          ),
        );

        return MaterialApp(
          title: 'Flexify',
          theme: ThemeData(
            colorScheme: colors ? lightDynamic : light,
            fontFamily: 'Manrope',
            useMaterial3: true,
            inputDecorationTheme: const InputDecorationTheme(
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: colors ? darkDynamic : dark,
            fontFamily: 'Manrope',
            useMaterial3: true,
            inputDecorationTheme: const InputDecorationTheme(
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          themeMode: mode,
          home: HomePage(hideChangelog: hideChangelog),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  final bool hideChangelog;
  const HomePage({super.key, required this.hideChangelog});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController controller;
  int index = 0;

  void listener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  void initState() {
    super.initState();

    final setting = context.read<SettingsState>().value.tabs;
    final tabs = setting.split(',');
    controller = TabController(length: tabs.length, vsync: this);
    controller.addListener(listener);

    if (widget.hideChangelog) return;

    final info = PackageInfo.fromPlatform();
    info.then((pkg) async {
      final meta = await (db.metadata.select()..limit(1)).getSingleOrNull();
      if (meta == null)
        db.metadata.insertOne(
          MetadataCompanion(buildNumber: Value(int.parse(pkg.buildNumber))),
        );
      else
        db.metadata.update().write(
              MetadataCompanion(
                buildNumber: Value(int.parse(pkg.buildNumber)),
              ),
            );

      if (int.parse(pkg.buildNumber) == meta?.buildNumber) return null;

      if (mounted)
        toast(
          context,
          "New version ${pkg.version}",
          SnackBarAction(
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
    controller.removeListener(listener);
    controller.dispose();
    super.dispose();
  }

  void hideTab(BuildContext context, String tab) {
    final state = context.read<SettingsState>();
    final old = state.value.tabs;
    var tabs = state.value.tabs.split(',');

    if (tabs.length == 1) return toast(context, "Can't hide everything!");
    controller.removeListener(listener);
    controller.dispose();
    controller = TabController(length: tabs.length - 1, vsync: this);
    controller.addListener(listener);

    tabs.remove(tab);
    db.settings.update().write(
          SettingsCompanion(
            tabs: Value(tabs.join(',')),
          ),
        );
    toast(
      context,
      'Hid $tab',
      SnackBarAction(
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

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomSheet:
          tabs.contains('TimerPage') ? const TimerProgressIndicator() : null,
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
                  return const HistoryPage();
                else if (tab == 'PlansPage')
                  return const PlansPage();
                else if (tab == 'GraphsPage')
                  return const GraphsPage();
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
              child: BottomNav(
                tabs: tabs,
                currentIndex: index,
                onTap: (index) {
                  controller.animateTo(index);
                  setState(() {
                    this.index = index;
                  });
                },
                onLongPress: hideTab,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
