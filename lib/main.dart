import 'package:flexify/database.dart';
import 'package:flexify/graphs_page.dart';
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
    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (BuildContext context) {
          return SafeArea(
            child: Scaffold(
              appBar: TabBar(
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
                indicatorColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              body: TabBarView(
                controller: tabController,
                children: const [
                  PlansPage(),
                  GraphsPage(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
