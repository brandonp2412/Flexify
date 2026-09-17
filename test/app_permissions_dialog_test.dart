import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flexify/app_permissions_dialog.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/l10n/generated/app_localizations.dart';
import 'package:flexify/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tests.dart';

void main() {
  testWidgets('renders app access dialog', (tester) async {
    await mockTests();
    app.db = testDb();
    await app.db.settings.update().write(
      const SettingsCompanion(
        restTimers: Value(true),
        notifications: Value(true),
      ),
    );
    final settings = await (app.db.settings.select()..limit(1)).getSingle();

    const permissionChannel = MethodChannel(
      'flutter.baseflow.com/permissions/methods',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(permissionChannel, (call) async {
          if (call.method == 'checkPermissionStatus') return 0;
          return null;
        });

    await tester.binding.setSurfaceSize(const Size(412, 915));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () {
                  unawaited(
                    showAppPermissionsDialog(context, settings: settings),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('App access'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Background activity'), findsOneWidget);
    expect(find.text('Exact alarms'), findsOneWidget);
    expect(find.text('Allow'), findsNWidgets(3));
    expect(find.byType(CheckboxListTile), findsNothing);
    expect(tester.takeException(), null);
  });
}
