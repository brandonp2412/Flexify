import 'package:drift/drift.dart';
import 'package:dynamic_color/dynamic_color.dart';
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
  WidgetsFlutterBinding.ensureInitialized();

  Setting setting;

  try {
    setting = await (db.settings.select()..limit(1)).getSingle();
  } catch (error) {
    return runApp(FailedMigrationsPage(error: error));
  }

  final state = SettingsState(setting);
  runApp(appProviders(state));
}

AppDatabase db = AppDatabase();

MethodChannel androidChannel =
    const MethodChannel("com.presley.flexify/android");

Widget appProviders(SettingsState state) => MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => state),
        ChangeNotifierProvider(create: (context) => TimerState()),
        ChangeNotifierProvider(create: (context) => PlanState()),
      ],
      child: App(),
    );

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.select<SettingsState, bool>(
      (settings) => settings.value.systemColors,
    );
    final mode = context.select<SettingsState, ThemeMode>(
      (settings) => ThemeMode.values
          .byName(settings.value.themeMode.replaceFirst('ThemeMode.', '')),
    );

    final light = ColorScheme.fromSeed(seedColor: Colors.deepPurple);
    final dark = ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    );

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final settings = context.watch<SettingsState>();
        final currentBrightness =
            settings.value.themeMode == 'ThemeMode.dark' ||
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
          scaffoldMessengerKey: rootScaffoldMessenger,
          title: 'Flexify',
          theme: ThemeData(
            colorScheme: colors ? lightDynamic : light,
            fontFamily: 'Manrope',
            useMaterial3: true,
            inputDecorationTheme: const InputDecorationTheme(
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: colors ? darkDynamic : dark,
            fontFamily: 'Manrope',
            useMaterial3: true,
            inputDecorationTheme: const InputDecorationTheme(
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          themeMode: mode,
          home: HomePage(),
        );
      },
    );
  }
}
