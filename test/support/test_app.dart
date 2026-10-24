import 'package:drift/drift.dart';
import 'package:flex/database/database.dart';
import 'package:flex/l10n/generated/app_localizations.dart';
import 'package:flex/main.dart';
import 'package:flex/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../mock_tests.dart';

class FlexTestHarness {
  FlexTestHarness._({required this.database, required this.timerState});

  final AppDatabase database;
  final TimerState timerState;

  static Future<FlexTestHarness> create({TimerState? timerState}) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final database = testDb();
    db = database;

    return FlexTestHarness._(
      database: database,
      timerState: timerState ?? TimerState(),
    );
  }

  Future<void> pump(
    WidgetTester tester,
    Widget home, {
    TimerState? timerState,
    Size? surfaceSize,
    Locale? locale,
    TextScaler? textScaler,
  }) async {
    if (surfaceSize != null) {
      await tester.binding.setSurfaceSize(surfaceSize);
      addTearDown(() => tester.binding.setSurfaceSize(null));
    }

    final setting = await (database.settings.select()..limit(1)).getSingle();
    final effectiveTimerState = timerState ?? this.timerState;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          StreamProvider<Setting>(
            initialData: setting,
            create: (_) => database.watchSettings(),
          ),
          ChangeNotifierProvider.value(value: effectiveTimerState),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: messengerKey,
          locale: locale ?? const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: textScaler == null
              ? null
              : (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaler: textScaler),
                  child: child!,
                ),
          home: home,
        ),
      ),
    );
  }
}
