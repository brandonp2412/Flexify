import 'package:drift/drift.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/graphs_page.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/sets/history_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_page.dart';
import 'package:flexify/timer/timer_progress_widgets.dart';
import 'package:flexify/timer/timer_state.dart';
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

AppDatabase db = AppDatabase();

MethodChannel timerChannel = const MethodChannel("com.presley.flexify/timer");

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
    final showHistoryTab = context.select<SettingsState, bool>(
      (settings) => settings.value.showHistoryTab,
    );
    final showTimerTab = context
        .select<SettingsState, bool>((settings) => settings.value.showTimerTab);
    var length = 4;
    if (!showTimerTab) length--;
    if (!showHistoryTab) length--;

    return SafeArea(
      child: DefaultTabController(
        length: length,
        child: Scaffold(
          bottomSheet: showTimerTab ? const TimerProgressIndicator() : null,
          body: TabBarView(
            children: [
              if (showHistoryTab) const HistoryPage(),
              const PlansPage(),
              const GraphsPage(),
              if (showTimerTab) const TimerPage(),
            ],
          ),
          bottomNavigationBar: TabBar(
            tabs: [
              if (showHistoryTab)
                const Tab(
                  icon: Icon(Icons.history),
                  text: "History",
                ),
              const Tab(
                icon: Icon(Icons.calendar_today),
                text: "Plans",
              ),
              const Tab(
                icon: Icon(Icons.insights),
                text: "Graphs",
              ),
              if (showTimerTab)
                const Tab(
                  icon: Icon(Icons.timer_outlined),
                  text: "Timer",
                ),
            ],
          ),
        ),
      ),
    );
  }
}
