import 'package:drift/drift.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/graphs_page.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/sets/history_page.dart';
import 'package:flexify/settings/settings_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_page.dart';
import 'package:flexify/timer/timer_progress_widgets.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'plan/plans_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await (db.settings.select()..limit(1)).getSingle();
  final setting = await (db.settings.select()..limit(1)).getSingle();
  final settings = SettingsState(setting);

  runApp(appProviders(settings));
}

AppDatabase db = AppDatabase(logStatements: kDebugMode);

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
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabsSetting = context
        .select<SettingsState, String>((settings) => settings.value.tabs);
    final tabs = tabsSetting.split(',');

    return SafeArea(
      child: DefaultTabController(
        length: tabs.length,
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
            tabs: tabs.map((tab) {
              if (tab == 'HistoryPage')
                return const Tab(
                  icon: Icon(Icons.history),
                  text: "History",
                );
              else if (tab == 'PlansPage')
                return const Tab(
                  icon: Icon(Icons.calendar_today),
                  text: "Plans",
                );
              else if (tab == 'GraphsPage')
                return const Tab(
                  icon: Icon(Icons.insights),
                  text: "Graphs",
                );
              else if (tab == 'TimerPage')
                return const Tab(
                  icon: Icon(Icons.timer_outlined),
                  text: "Timer",
                );
              else if (tab == 'SettingsPage')
                return const Tab(
                  icon: Icon(Icons.settings),
                  text: "Settings",
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
