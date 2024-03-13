import 'dart:async';

import 'package:flexify/database.dart';
import 'package:flexify/graphs_page.dart';
import 'package:flexify/native_timer_wrapper.dart';
import 'package:flexify/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'plans_page.dart';

late AppDatabase database;
late MethodChannel android;

class AppState extends ChangeNotifier {
  Timer? _timer;
  String? selectedExercise;
  SharedPreferences? prefs;
  ThemeMode themeMode = ThemeMode.system;
  Duration timerDuration = const Duration(minutes: 3, seconds: 30);
  bool showReorder = true;
  bool restTimers = true;
  NativeTimerWrapper nativeTimer = NativeTimerWrapper.emptyTimer();

  AppState() {
    SharedPreferences.getInstance().then((value) {
      prefs = value;

      final theme = value.getString('themeMode');
      if (theme == "ThemeMode.system")
        themeMode = ThemeMode.system;
      else if (theme == "ThemeMode.light")
        themeMode = ThemeMode.light;
      else if (theme == "ThemeMode.dark") themeMode = ThemeMode.dark;

      final ms = value.getInt("timerDuration");
      if (ms != null) timerDuration = Duration(milliseconds: ms);

      showReorder = value.getBool("showReorder") ?? true;
      restTimers = value.getBool("restTimers") ?? true;

      notifyListeners();
    });
  }

  void setTimers(bool show) {
    restTimers = show;
    prefs?.setBool('restTimers', show);
    notifyListeners();
  }

  void setReorder(bool show) {
    showReorder = show;
    prefs?.setBool('showReorder', show);
    notifyListeners();
  }

  void setDuration(Duration duration) {
    timerDuration = duration;
    prefs?.setInt('timerDuration', duration.inMilliseconds);
    notifyListeners();
  }

  void setTheme(ThemeMode theme) {
    themeMode = theme;
    prefs?.setString('themeMode', theme.toString());
    notifyListeners();
  }

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

  void startTimer(String exercise) {
    final timer = nativeTimer.increaseDuration(timerDuration);
    updateTimer(timer);
    android.invokeMethod('timer',
        [timerDuration.inMilliseconds, exercise, timer.getTimeStamp()]);
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
    final appState = context.watch<AppState>();
    return MaterialApp(
      title: 'Flexify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: appState.themeMode,
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
      length: 3,
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            bottomSheet: Consumer<AppState>(builder: (context, value, child) {
              final duration = value.nativeTimer.getDuration();
              final elapsed = value.nativeTimer.getElapsed();

              return Visibility(
                visible: duration > Duration.zero,
                child: LinearProgressIndicator(
                  value: duration == Duration.zero
                      ? 0
                      : elapsed.inMilliseconds / duration.inMilliseconds,
                ),
              );
            }),
            body: SafeArea(
              child: TabBarView(
                controller: tabController,
                children: const [
                  PlansPage(),
                  GraphsPage(),
                  SettingsPage(),
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
                ),
                Tab(
                  icon: Icon(Icons.settings),
                  text: "Settings",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
