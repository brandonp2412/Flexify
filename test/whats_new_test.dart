import 'package:flexify/settings/whats_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('WhatsNew renders bundled changelogs', (tester) async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final changelogPaths =
        manifest
            .listAssets()
            .where((asset) => asset.startsWith('assets/changelogs/'))
            .toList()
          ..sort((a, b) {
            final aTimestamp = int.parse(a.split('/').last.split('.').first);
            final bTimestamp = int.parse(b.split('/').last.split('.').first);
            return bTimestamp.compareTo(aTimestamp);
          });

    expect(changelogPaths, isNotEmpty);
    final latestContent = await rootBundle.loadString(changelogPaths.first);

    await tester.pumpWidget(const MaterialApp(home: WhatsNew()));
    await tester.pumpAndSettle();

    expect(find.text("What's new?"), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets);
    expect(find.text(latestContent), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
