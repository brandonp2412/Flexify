import 'dart:async';

import 'package:drift/drift.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flex/crash_logger.dart';
import 'package:flex/database/database.dart';
import 'package:flex/database/failed_migrations_page.dart';
import 'package:flex/home_page.dart';
import 'package:flex/logging.dart';
import 'package:flex/l10n/generated/app_localizations.dart';
import 'package:flex/l10n/l10n.dart';
import 'package:flex/l10n/locale_preferences.dart';
import 'package:flex/timer/timer_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

final messengerKey = GlobalKey<ScaffoldMessengerState>();
String? _backupLocale;

class _NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const _NoAnimationPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => child;
}

PageTransitionsTheme _pageTransitionsTheme() {
  final desktop =
      !kIsWeb &&
      {
        TargetPlatform.linux,
        TargetPlatform.macOS,
        TargetPlatform.windows,
      }.contains(defaultTargetPlatform);
  if (!desktop) return const PageTransitionsTheme();

  const noAnimation = _NoAnimationPageTransitionsBuilder();
  return const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: noAnimation,
      TargetPlatform.fuchsia: noAnimation,
      TargetPlatform.iOS: noAnimation,
      TargetPlatform.linux: noAnimation,
      TargetPlatform.macOS: noAnimation,
      TargetPlatform.windows: noAnimation,
    },
  );
}

void _syncBackupLocalizations(AppLocalizations l10n) {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
  if (_backupLocale == l10n.localeName) return;
  _backupLocale = l10n.localeName;
  unawaited(
    androidChannel
        .invokeMethod<bool>('setBackupLocalizations', {
          'backupChannelName': l10n.backupChannelName,
          'backupChannelDescription': l10n.backupChannelDescription,
          'backupCompletedTitle': l10n.backupCompletedTitle,
          'backupFailurePathNotSet': l10n.backupFailurePathNotSet,
          'backupFailureDirectoryUnavailable':
              l10n.backupFailureDirectoryUnavailable,
          'backupFailureCreateFile': l10n.backupFailureCreateFile,
          'backupFailureAppFilesUnavailable':
              l10n.backupFailureAppFilesUnavailable,
          'backupFailureDatabaseMissing': l10n.backupFailureDatabaseMissing,
          'backupFailureOutputUnavailable': l10n.backupFailureOutputUnavailable,
          'backupFailureUnknown': l10n.backupFailureUnknown,
          'shareLabel': l10n.actionShare,
        })
        .then<void>(
          (_) {},
          onError: (Object error, StackTrace stackTrace) {
            _backupLocale = null;
            talker.handle(
              error,
              stackTrace,
              'Failed to sync backup localizations',
            );
          },
        ),
  );
}

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      talker.info('Starting Flex');
      await CrashLogger.install();

      Setting setting;

      try {
        setting = await (db.settings.select()..limit(1)).getSingle();
      } catch (error) {
        CrashLogger.instance?.record(
          error,
          StackTrace.current,
          context: 'database migration',
        );
        return runApp(FailedMigrationsPage(error: error));
      }

      talker.info('Loaded application settings');
      runApp(appProviders(setting));
    },
    (error, stack) =>
        CrashLogger.instance?.record(error, stack, context: 'zone'),
  );
}

AppDatabase db = AppDatabase.persistent();

/// Bumped whenever [db] is replaced with a new instance (e.g. after
/// importing a database), so widgets holding a `.watch()` stream tied to
/// the old instance know to rebuild it against the current one.
final ValueNotifier<int> dbVersion = ValueNotifier(0);

MethodChannel androidChannel = const MethodChannel(
  "com.presley.flexify/android",
);

Widget appProviders(Setting initialSettings) => ValueListenableBuilder<int>(
  valueListenable: dbVersion,
  builder: (context, version, child) => MultiProvider(
    key: ValueKey(version),
    providers: [
      StreamProvider<Setting>(
        initialData: initialSettings,
        create: (context) => db.watchSettings(),
      ),
      ChangeNotifierProxyProvider<Setting, TimerState>(
        create: (context) => TimerState(),
        update: (context, settings, previous) =>
            previous!..setKeepScreenOn(settings.keepScreenOn),
      ),
    ],
    child: const App(),
  ),
);

class App extends StatelessWidget {
  static final _lightScheme = ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
  );
  static final _darkScheme = ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.dark,
  );
  static const _popupMenuTheme = PopupMenuThemeData(
    menuPadding: EdgeInsets.zero,
  );

  static InputDecorationTheme _inputDecorationTheme(String inputStyle) {
    return switch (inputStyle) {
      'outlined' => const InputDecorationTheme(border: OutlineInputBorder()),
      'filled' => const InputDecorationTheme(filled: true),
      _ => const InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    };
  }

  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.select<Setting, bool>(
      (settings) => settings.systemColors,
    );
    final amoledDark = context.select<Setting, bool>(
      (settings) => settings.themeMode == 'ThemeMode.amoled',
    );
    final mode = context.select<Setting, ThemeMode>(
      (settings) => settings.themeMode == 'ThemeMode.amoled'
          ? ThemeMode.dark
          : ThemeMode.values.byName(
              settings.themeMode.replaceFirst('ThemeMode.', ''),
            ),
    );
    final inputStyle = context.select<Setting, String>(
      (settings) => settings.inputStyle,
    );
    final themeMode = context.select<Setting, String>(
      (settings) => settings.themeMode,
    );
    final localeOverride = context.select<Setting, String?>(
      (settings) => settings.localeOverride,
    );

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final brightness =
            themeMode == 'ThemeMode.dark' ||
                themeMode == 'ThemeMode.amoled' ||
                (themeMode == 'ThemeMode.system' &&
                    MediaQuery.of(context).platformBrightness ==
                        Brightness.dark)
            ? Brightness.dark
            : Brightness.light;

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarIconBrightness: brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
            systemNavigationBarIconBrightness: brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
          ),
        );

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: messengerKey,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          localeListResolutionCallback: resolveSystemLocale,
          locale: localeOverrideFromIdentifier(localeOverride),
          navigatorObservers: [UnfocusObserver()],
          builder: (context, child) {
            _syncBackupLocalizations(context.l10n);
            context.read<TimerState>().setNotificationLocalizations(
              upTitle: context.l10n.timerUp,
              openLabel: context.l10n.openNotification,
              stopLabel: context.l10n.actionStop,
              addMinuteLabel: context.l10n.addOneMinuteNotification,
              restTitle: context.l10n.restTimer,
              timerChannel: context.l10n.timerChannelName,
              timerDesc: context.l10n.timerChannelDescription,
              doneChannel: context.l10n.timerFinishedChannelName,
              doneDesc: context.l10n.timerFinishedChannelDescription,
              doneTitle: context.l10n.timerFinished,
              alarmUnavailable: context.l10n.exactAlarmRequestUnavailable,
            );
            return KeyboardUnfocusWrapper(
              child: child ?? const SizedBox.shrink(),
            );
          },
          onGenerateTitle: (context) => context.l10n.appTitle,
          theme: ThemeData(
            colorScheme: colors ? lightDynamic : _lightScheme,
            fontFamily: 'Manrope',
            useMaterial3: true,
            inputDecorationTheme: _inputDecorationTheme(inputStyle),
            popupMenuTheme: _popupMenuTheme,
            pageTransitionsTheme: _pageTransitionsTheme(),
          ),
          darkTheme: ThemeData(
            colorScheme: (colors ? darkDynamic : _darkScheme)?.copyWith(
              surface: amoledDark ? Colors.black : null,
            ),
            fontFamily: 'Manrope',
            useMaterial3: true,
            inputDecorationTheme: _inputDecorationTheme(inputStyle),
            popupMenuTheme: _popupMenuTheme,
            pageTransitionsTheme: _pageTransitionsTheme(),
          ),
          themeMode: mode,
          home: HomePage(),
        );
      },
    );
  }
}

class UnfocusObserver extends NavigatorObserver {
  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    super.didStartUserGesture(route, previousRoute);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

class KeyboardUnfocusWrapper extends StatefulWidget {
  final Widget child;
  const KeyboardUnfocusWrapper({super.key, required this.child});

  @override
  State<KeyboardUnfocusWrapper> createState() => _KeyboardUnfocusWrapperState();
}

class _KeyboardUnfocusWrapperState extends State<KeyboardUnfocusWrapper>
    with WidgetsBindingObserver {
  double _lastInset = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = WidgetsBinding
        .instance
        .platformDispatcher
        .views
        .first
        .viewInsets
        .bottom;
    if (_lastInset > 0.0 && bottomInset == 0.0) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    _lastInset = bottomInset;
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: {
        EditableTextTapOutsideIntent:
            CallbackAction<EditableTextTapOutsideIntent>(
              onInvoke: (intent) {
                intent.focusNode.unfocus();
                return null;
              },
            ),
      },
      child: widget.child,
    );
  }
}
