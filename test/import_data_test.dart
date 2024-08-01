import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/import_data.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  testWidgets('ImportData', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(executor: NativeDatabase.memory(), logStatements: false);
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: getTestProviders(settings),
        child: MaterialApp(
          home: Builder(
            builder: (context) => ImportData(
              pageContext: context,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Import data'));
    await tester.pumpAndSettle();
    expect(find.text('Graphs'), findsOne);
    expect(find.text('Plans'), findsOne);
    expect(find.text('Database'), findsOne);

    await db.close();
  });
}
