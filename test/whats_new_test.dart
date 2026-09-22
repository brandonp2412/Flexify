import 'dart:convert';

import 'package:flexify/l10n/generated/app_localizations.dart';
import 'package:flexify/settings/whats_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemoryAssetBundle extends CachingAssetBundle {
  _MemoryAssetBundle(this.assets);

  final Map<String, String> assets;

  @override
  Future<ByteData> load(String key) async {
    final bytes = Uint8List.fromList(utf8.encode(assets[key]!));
    return ByteData.sublistView(bytes);
  }
}

Future<String> _latestChangelogPath() async {
  final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  final changelogPaths =
      manifest
          .listAssets()
          .where(
            (asset) =>
                asset.startsWith('assets/changelogs/') &&
                asset.endsWith('.txt'),
          )
          .toList()
        ..sort((a, b) {
          final aTimestamp = int.parse(a.split('/').last.split('.').first);
          final bTimestamp = int.parse(b.split('/').last.split('.').first);
          return bTimestamp.compareTo(aTimestamp);
        });
  expect(changelogPaths, isNotEmpty);
  return changelogPaths.first;
}

void main() {
  testWidgets('WhatsNew renders bundled English changelogs', (tester) async {
    final latestPath = await _latestChangelogPath();
    final latestContent = await rootBundle.loadString(latestPath);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: WhatsNew(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("What's new?"), findsOneWidget);
    expect(find.text(latestContent), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test(
    'localized changelog loader selects the active language catalog',
    () async {
      const path = 'assets/changelogs/l10n/de.json';
      const translated = 'Lokalisierter Eintrag';
      final bundle = _MemoryAssetBundle({path: '{"123": "$translated"}'});
      final localized = await loadLocalizedChangelogCatalog(bundle, const {
        path,
      }, const Locale('de'));

      expect(localized, {'123': translated});

      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      expect(manifest.listAssets(), contains(path));
    },
  );
}
