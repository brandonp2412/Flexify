import 'package:dynamic_color/dynamic_color.dart';
import 'package:flexify/database.dart';
import 'package:flexify/graphs_page.dart';
import 'package:flexify/timer_page.dart';
import 'package:flexify/timer_progress_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'plans_page.dart';

late AppDatabase db;
late MethodChannel android;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  db = AppDatabase();
  android = const MethodChannel("com.presley.flexify/android");

  final settingsState = SettingsState();
  await settingsState.init();

  runApp(appProviders(settingsState));
}

Widget appProviders(SettingsState settingsState) => MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => settingsState),
        ChangeNotifierProvider(create: (context) => TimerState()),
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
        seedColor: Colors.deepPurple, brightness: Brightness.dark);

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
    return const DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomSheet: TimerProgressIndicator(),
        body: SafeArea(
          child: TabBarView(
            children: [
              PlansPage(),
              GraphsPage(),
              TimerPage(),
            ],
          ),
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.event),
              text: "Plans",
            ),
            Tab(
              icon: Icon(Icons.insights),
              text: "Graphs",
            ),
            Tab(
              icon: Icon(Icons.timer_outlined),
              text: "Timer",
            ),
          ],
        ),
      ),
    );
  }
}
