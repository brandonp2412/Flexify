import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/permissions_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  await mockTests();

  testWidgets('PermissionsPage', (WidgetTester tester) async {
    db = AppDatabase(executor: NativeDatabase.memory(), logStatements: false);
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: getTestProviders(settings),
        child: const MaterialApp(
          home: Scaffold(
            body: PermissionsPage(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Missing permissions'), findsOne);
    expect(find.byTooltip('Confirm'), findsOne);

    await db.close();
  });
}
