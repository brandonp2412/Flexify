import 'package:flexify/database.dart';
import 'package:flexify/graphs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'plans_page.dart';

late AppDatabase database;
late MethodChannel android;

class AppState extends ChangeNotifier {
  String? selectedExercise;
  int? secondsLeft;
  int? secondsTotal;

  void selectExercise(String exercise) {
    selectedExercise = exercise;
    notifyListeners();
  }

  void updateSeconds(int left, int total) {
    secondsLeft = left;
    secondsTotal = total;
    notifyListeners();
  }
}

void main() {
  database = AppDatabase();
  android = const MethodChannel("com.presley.flexify/android");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
    create: (context) => AppState(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flexify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
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
    tabController = TabController(length: 2, vsync: this);
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
    android.setMethodCallHandler((call) async {
      if (call.method == 'tick') {
        int left = call.arguments[0];
        int total = call.arguments[1];
        Provider.of<AppState>(context, listen: false)
            .updateSeconds(left, total);
      }
    });

    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            bottomSheet: Consumer<AppState>(builder: (context, value, child) {
              final duration = value.secondsTotal ?? 0;
              final elapsed = duration - (value.secondsLeft ?? 0);

              return Visibility(
                visible: duration > 0,
                child: LinearProgressIndicator(
                    value: duration == 0 ? 0 : elapsed / duration),
              );
            }),
            body: SafeArea(
              child: TabBarView(
                controller: tabController,
                children: const [
                  PlansPage(),
                  GraphsPage(),
                ],
              ),
            ),
            bottomNavigationBar: TabBar(
              controller: tabController,
              tabs: const [
                Tab(
                  icon: Icon(Icons.event),
                  text: "Plans",
                ),
                Tab(
                  icon: Icon(Icons.insights),
                  text: "Graphs",
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
