import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flexify/settings/whats_new.dart';
import 'package:flexify/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('Donate stays above Android gesture navigation', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(360, 780),
            padding: EdgeInsets.only(bottom: 32),
          ),
          child: const WhatsNew(),
        ),
      ),
    );
    await tester.pump();

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.floatingActionButton, isNull);
    expect(scaffold.bottomNavigationBar, isA<SafeArea>());

    final donate = find.byType(FloatingActionButton);
    expect(donate, findsOneWidget);
    expect(tester.getBottomRight(donate).dy, lessThanOrEqualTo(780 - 32));
    expect(tester.takeException(), isNull);
  });
}
