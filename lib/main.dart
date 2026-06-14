import 'dart:async';

import 'package:drift/drift.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flexify/crash_logger.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/failed_migrations_page.dart';
import 'package:flexify/home_page.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

final rootScaffoldMessenger = GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await CrashLogger.install();

      Setting setting;

      try {
        setting = await (db.settings.select()..limit(1)).getSingle();
      } catch (error) {
        return runApp(FailedMigrationsPage(error: error));
      }

      final state = SettingsState(setting);
      runApp(appProviders(state));
    },
    (error, stack) =>
        CrashLogger.instance?.record(error, stack, context: 'zone'),
  );
}

AppDatabase db = AppDatabase();

MethodChannel androidChannel =
    const MethodChannel("com.presley.flexify/android");

Widget appProviders(SettingsState state) => MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => state),
        ChangeNotifierProxyProvider<SettingsState, TimerState>(
          create: (context) => TimerState(),
          update: (context, settings, previous) =>
              previous!..setKeepScreenOn(settings.value.keepScreenOn),
        ),
        ChangeNotifierProvider(create: (context) => PlanState()),
      ],
      child: App(),
    );

class App extends StatelessWidget {
  static final _lightScheme =
      ColorScheme.fromSeed(seedColor: Colors.deepPurple);
  static final _darkScheme = ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.dark,
  );

  static InputDecorationTheme _inputDecorationTheme(String inputStyle) {
    return switch (inputStyle) {
      'outlined' => const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      'filled' => const InputDecorationTheme(
          filled: true,
        ),
      _ => const InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
    };
  }

  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.select<SettingsState, bool>(
      (settings) => settings.value.systemColors,
    );
    final amoledDark = context.select<SettingsState, bool>(
      (settings) => settings.value.themeMode == 'ThemeMode.amoled',
    );
    final mode = context.select<SettingsState, ThemeMode>(
      (settings) => settings.value.themeMode == 'ThemeMode.amoled'
          ? ThemeMode.dark
          : ThemeMode.values.byName(
              settings.value.themeMode.replaceFirst('ThemeMode.', ''),
            ),
    );
    final inputStyle = context.select<SettingsState, String>(
      (settings) => settings.value.inputStyle,
    );

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final settings = context.watch<SettingsState>();
        final currentBrightness =
            settings.value.themeMode == 'ThemeMode.dark' ||
                    settings.value.themeMode == 'ThemeMode.amoled' ||
                    (settings.value.themeMode == 'ThemeMode.system' &&
                        MediaQuery.of(context).platformBrightness ==
                            Brightness.dark)
                ? Brightness.dark
                : Brightness.light;

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarIconBrightness: currentBrightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
            systemNavigationBarIconBrightness:
                currentBrightness == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark,
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
          ),
        );

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: rootScaffoldMessenger,
          title: 'Flexify',
          theme: ThemeData(
            colorScheme: colors ? lightDynamic : _lightScheme,
            fontFamily: 'Manrope',
            useMaterial3: true,
            inputDecorationTheme: _inputDecorationTheme(inputStyle),
          ),
          darkTheme: ThemeData(
            colorScheme: (colors ? darkDynamic : _darkScheme)
                ?.copyWith(surface: amoledDark ? Colors.black : null),
            fontFamily: 'Manrope',
            useMaterial3: true,
            inputDecorationTheme: _inputDecorationTheme(inputStyle),
          ),
          themeMode: mode,
          home: HomePage(),
        );
      },
    );
  }
}
