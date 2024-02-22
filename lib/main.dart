import 'package:drift/drift.dart';
import 'package:flexify/database.dart';
import 'package:flexify/edit_plan_page.dart';
import 'package:flutter/material.dart';

import 'plans_page.dart';

late AppDatabase database;

void main() {
  database = AppDatabase();
  runApp(const MyApp());
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
      home: const MyHomePage(title: 'Flexify'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  void pressedFab() {}

  void tappedNav(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context);
          return SafeArea(
            child: Scaffold(
              appBar: TabBar(
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
                indicatorColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              body: TabBarView(
                controller: tabController,
                children: const [
                  PlansPage(),
                  Icon(Icons.insights),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // Access the index of the current tab
                  final int currentIndex = tabController.index;
                  // Now you can do logic based on the current tab index
                  print("Current tab index: $currentIndex");
                  // Implement your logic here based on the current tab index
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditPlanPage(
                            plan: PlansCompanion(
                                days: Value(''), exercises: Value('')))),
                  );
                },
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            ),
          );
        },
      ),
    );
  }
}
