import 'package:dynamic_color/dynamic_color.dart';
import 'package:flexify/database.dart';
import 'package:flexify/history_page.dart';
import 'package:flexify/graphs_page.dart';
import 'package:flexify/plan_state.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/timer_page.dart';
import 'package:flexify/timer_progress_widgets.dart';
import 'package:flexify/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'plans_page.dart';

late AppDatabase db;
late MethodChannel android;
late SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  android = const MethodChannel("com.presley.flexify/android");
  db = AppDatabase();
  final settings = SettingsState();

  runApp(appProviders(settings));
}

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
    final settings = context.watch<SettingsState>();

    final defaultTheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple);
    final defaultDark = ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    );

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MaterialApp(
        title: 'Flexify',
        theme: ThemeData(
          colorScheme: settings.systemColors ? lightDynamic : defaultTheme,
          fontFamily: 'Manrope',
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: settings.systemColors ? darkDynamic : defaultDark,
          fontFamily: 'Manrope',
          useMaterial3: true,
        ),
        themeMode: settings.themeMode,
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();
    var length = 4;
    if (settings.hideTimerTab) length--;
    if (settings.hideHistoryTab) length--;

    return DefaultTabController(
      length: length,
      child: Scaffold(
        bottomSheet:
            settings.hideTimerTab ? null : const TimerProgressIndicator(),
        body: SafeArea(
          child: TabBarView(
            children: [
              if (!settings.hideHistoryTab) const HistoryPage(),
              const PlansPage(),
              const GraphsPage(),
              if (!settings.hideTimerTab) const TimerPage(),
            ],
          ),
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            if (!settings.hideHistoryTab)
              const Tab(
                icon: Icon(Icons.history),
                text: "History",
              ),
            const Tab(
              icon: Icon(Icons.event),
              text: "Plans",
            ),
            const Tab(
              icon: Icon(Icons.insights),
              text: "Graphs",
            ),
            if (!settings.hideTimerTab)
              const Tab(
                icon: Icon(Icons.timer_outlined),
                text: "Timer",
              ),
          ],
        ),
      ),
    );
  }
}
