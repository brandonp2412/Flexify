import 'dart:async';

import 'package:flexify/database.dart';
import 'package:flexify/graphs_page.dart';
import 'package:flexify/native_timer_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'plans_page.dart';

late AppDatabase database;
late MethodChannel android;

class AppState extends ChangeNotifier {
  Timer? _timer;
  String? selectedExercise;
  NativeTimerWrapper nativeTimer = NativeTimerWrapper.emptyTimer();

  void selectExercise(String exercise) {
    selectedExercise = exercise;
    notifyListeners();
  }

  void addOneMinute() {
    final newTimer = nativeTimer.increaseDuration(
      const Duration(minutes: 1),
    );
    updateTimer(newTimer);
    android.invokeMethod('add', [newTimer.getTimeStamp()]);
  }

  void stopTimer() {
    updateTimer(NativeTimerWrapper.emptyTimer());
    android.invokeMethod('stop');
  }

  void startTimer(String exercise, Duration duration) {
    final timer = nativeTimer.increaseDuration(duration);
    updateTimer(timer);
    android.invokeMethod(
        'timer', [duration.inMilliseconds, exercise, timer.getTimeStamp()]);
  }

  void updateTimer(NativeTimerWrapper newTimer) {
    final wasRunning = _timer?.isActive ?? false;
    nativeTimer = newTimer;
    if (nativeTimer.isRunning() && !wasRunning) {
      _timer?.cancel();
      _timer = Timer.periodic(
        const Duration(milliseconds: 20),
        (timer) {
          if (nativeTimer.update()) _timer?.cancel();
          notifyListeners();
        },
      );
    }
    notifyListeners();
  }
}

void main() {
  database = AppDatabase();
  android = const MethodChannel("com.presley.flexify/android");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
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
        final newTimer = NativeTimerWrapper(
          Duration(milliseconds: call.arguments[0]),
          Duration(milliseconds: call.arguments[1]),
          DateTime.fromMillisecondsSinceEpoch(call.arguments[2], isUtc: true),
          NativeTimerState.values[call.arguments[3] as int],
        );

        Provider.of<AppState>(
          context,
          listen: false,
        ).updateTimer(newTimer);
      }
    });

    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            bottomSheet: Consumer<AppState>(builder: (context, value, child) {
              final duration = value.nativeTimer.getDuration();
              final elapsed = value.nativeTimer.getElapsed();

              return Visibility(
                visible: duration > Duration.zero,
                child: LinearProgressIndicator(
                  value: duration == Duration.zero ? 0 : elapsed.inMilliseconds / duration.inMilliseconds,
                ),
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
