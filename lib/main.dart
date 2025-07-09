import 'package:drift/drift.dart';
import 'package:dynamic_color/dynamic_color.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Setting setting;

  try {
    setting = await (db.settings.select()..limit(1)).getSingle();
  } catch (error) {
    return runApp(FailedMigrationsPage(error: error));
  }

  final settings = SettingsState(setting);
  runApp(appProviders(settings));
}

AppDatabase db = AppDatabase();

MethodChannel androidChannel =
    const MethodChannel("com.presley.flexify/android");

Widget appProviders(SettingsState settingsState) => MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => settingsState),
        ChangeNotifierProvider(create: (context) => TimerState()),
        ChangeNotifierProvider(create: (context) => PlanState()),
      ],
      child: const App(),
    );

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final systemColors = context.select<SettingsState, bool>(
      (settings) => settings.value.systemColors,
    );
    final themeMode = context.select<SettingsState, ThemeMode>(
      (settings) => ThemeMode.values
          .byName(settings.value.themeMode.replaceFirst('ThemeMode.', '')),
    );

    final defaultTheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple);
    final defaultDark = ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    );

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MaterialApp(
        title: 'Flexify',
        theme: ThemeData(
          colorScheme: systemColors ? lightDynamic : defaultTheme,
          fontFamily: 'Manrope',
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: systemColors ? darkDynamic : defaultDark,
          fontFamily: 'Manrope',
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
        themeMode: themeMode,
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final packageInfo = PackageInfo.fromPlatform();
    packageInfo.then((info) async {
      final metadata = await (db.metadata.select()..limit(1)).getSingleOrNull();
      if (metadata == null)
        db.metadata.insertOne(
          MetadataCompanion(buildNumber: Value(int.parse(info.buildNumber))),
        );
      else
        db.metadata.update().write(
              MetadataCompanion(
                buildNumber: Value(int.parse(info.buildNumber)),
              ),
            );

      if (int.parse(info.buildNumber) == metadata?.buildNumber) return null;

      if (mounted)
        toast(
          context,
          "New version ${info.version}",
          SnackBarAction(
            label: 'See whats new',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WhatsNew(),
              ),
            ),
          ),
        );
    });
  }

  void hideTab(BuildContext context, String tab) {
    final settings = context.read<SettingsState>();
    final oldTabs = settings.value.tabs;
    var tabs = settings.value.tabs.split(',');

    if (tabs.length == 1) return toast(context, "Can't hide everything!");

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
                  tabs: Value(oldTabs),
                ),
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabsSetting = context
        .select<SettingsState, String>((settings) => settings.value.tabs);
    final tabs = tabsSetting.split(',');

    return DefaultTabController(
      length: tabs.length,
      child: SafeArea(
        child: Scaffold(
          bottomSheet: tabs.contains('TimerPage')
              ? const TimerProgressIndicator()
              : null,
          body: TabBarView(
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
          bottomNavigationBar: TabBar(
            dividerColor: Theme.of(context).colorScheme.surface,
            tabs: tabs.map((tab) {
              if (tab == 'HistoryPage')
                return GestureDetector(
                  onLongPress: () => hideTab(context, 'HistoryPage'),
                  child: const Tab(
                    icon: Icon(Icons.history),
                    text: "History",
                  ),
                );
              else if (tab == 'PlansPage')
                return GestureDetector(
                  onLongPress: () => hideTab(context, 'PlansPage'),
                  child: const Tab(
                    icon: Icon(Icons.calendar_today),
                    text: "Plans",
                  ),
                );
              else if (tab == 'GraphsPage')
                return GestureDetector(
                  onLongPress: () => hideTab(context, 'GraphsPage'),
                  child: const Tab(
                    icon: Icon(Icons.insights),
                    text: "Graphs",
                  ),
                );
              else if (tab == 'TimerPage')
                return GestureDetector(
                  onLongPress: () => hideTab(context, 'TimerPage'),
                  child: const Tab(
                    icon: Icon(Icons.timer_outlined),
                    text: "Timer",
                  ),
                );
              else if (tab == 'SettingsPage')
                return GestureDetector(
                  onLongPress: () => hideTab(context, 'SettingsPage'),
                  child: const Tab(
                    icon: Icon(Icons.settings),
                    text: "Settings",
                  ),
                );
              else
                return ErrorWidget("Couldn't build tab bottom bar.");
            }).toList(),
          ),
        ),
      ),
    );
  }
}
