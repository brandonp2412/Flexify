import 'package:flexify/database.dart';
import 'package:flexify/graphs_page.dart';
import 'package:flexify/settings_page.dart';
import 'package:flexify/timer_progress_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'plans_page.dart';

late AppDatabase database;
late MethodChannel android;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = AppDatabase();
  android = const MethodChannel("com.presley.flexify/android");

  final settingsState = SettingsState();
  await settingsState.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => settingsState),
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => TimerState()),
      ],
      child: MaterialApp(
        title: 'Flexify',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark(),
        themeMode: settingsState.themeMode,
        home: const HomePage(),
      ),
    ),
  );
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();
    return MaterialApp(
      title: 'Flexify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: settings.themeMode,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.animation!.addListener(() {
      setState(() {
        currentIndex = tabController.index;
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomSheet: TimerProgressIndicator(),
        body: SafeArea(
          child: TabBarView(
            children:  [
              PlansPage(),
              GraphsPage(),
              SettingsPage(),
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
              icon: Icon(Icons.settings),
              text: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}
