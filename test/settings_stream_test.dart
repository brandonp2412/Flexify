import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() {
  testWidgets('Drift settings row updates provider subscribers', (
    tester,
  ) async {
    await mockTests();
    final database = testDb();
    addTearDown(database.close);
    final initial = await database.settings.select().getSingle();

    await tester.pumpWidget(
      StreamProvider<Setting>(
        initialData: initial,
        create: (_) => database.watchSettings(),
        child: MaterialApp(
          home: Builder(
            builder: (context) => Text(
              context
                  .select<Setting, bool>((setting) => setting.showImages)
                  .toString(),
            ),
          ),
        ),
      ),
    );
    expect(find.text('false'), findsOneWidget);

    await database.settings.update().write(
      const SettingsCompanion(showImages: Value(true)),
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('true'), findsOneWidget);
  });
}
