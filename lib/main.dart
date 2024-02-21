import 'package:flexify/database.dart';
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
      child: SafeArea(
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
          body: const TabBarView(children: [PlansPage(), Icon(Icons.insights)]),
          floatingActionButton: FloatingActionButton(
            onPressed: pressedFab,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
