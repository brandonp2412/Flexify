import 'dart:convert';

import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

const _changelogCatalogByLocale = <String, String>{
  'de': 'de',
  'es': 'es',
  'fr': 'fr',
  'it': 'it',
  'ja': 'ja',
  'ko': 'ko',
  'nl': 'nl',
  'pl': 'pl',
  'pt': 'pt_BR',
  'pt-BR': 'pt_BR',
  'tr': 'tr',
  'zh': 'zh_CN',
  'zh-CN': 'zh_CN',
  'zh-TW': 'zh_TW',
};

Future<Map<String, String>> loadLocalizedChangelogCatalog(
  AssetBundle bundle,
  Set<String> assets,
  Locale locale,
) async {
  final catalogLocale =
      _changelogCatalogByLocale[locale.toLanguageTag()] ??
      _changelogCatalogByLocale[locale.languageCode];
  if (catalogLocale == null) return const {};

  final path = 'assets/changelogs/l10n/$catalogLocale.json';
  if (!assets.contains(path)) return const {};

  try {
    final data = await bundle.load(path);
    final content = utf8.decode(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    );
    final decoded = jsonDecode(content);
    if (decoded is! Map<String, dynamic>) return const {};
    return decoded.map((key, value) => MapEntry(key, value.toString()));
  } catch (error, stackTrace) {
    talker.handle(
      error,
      stackTrace,
      'Unable to load localized changelog catalog: $path',
    );
    return const {};
  }
}

class WhatsNew extends StatefulWidget {
  const WhatsNew({super.key});

  @override
  State<WhatsNew> createState() => _WhatsNewState();
}

class Changelog {
  final String name;
  final String content;
  final String created;

  Changelog({required this.name, required this.content, required this.created});
}

class _WhatsNewState extends State<WhatsNew> {
  List<Changelog> _changelogs = [];
  String? _loadedLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_loadedLocale == locale) return;
    _loadedLocale = locale;
    setChangelogs();
  }

  void setChangelogs() async {
    final logs = await getChangelogFiles(context);
    if (!mounted) return;
    setState(() {
      _changelogs = logs;
    });
  }

  Future<List<Changelog>> getChangelogFiles(BuildContext context) async {
    final locale = Localizations.localeOf(context);
    final localeTag = locale.toLanguageTag();
    final bundle = DefaultAssetBundle.of(context);
    final manifest = await AssetManifest.loadFromAssetBundle(bundle);
    final assets = manifest.listAssets().toSet();
    final localizedChangelogs = await loadLocalizedChangelogCatalog(
      bundle,
      assets,
      locale,
    );

    final files = assets
        .where(
          (key) => key.startsWith('assets/changelogs/') && key.endsWith('.txt'),
        )
        .toList();

    files.sort((a, b) {
      final aName = a.split('/').last.split('.').first;
      final bName = b.split('/').last.split('.').first;
      final aNum = int.tryParse(aName) ?? 0;
      final bNum = int.tryParse(bName) ?? 0;
      return bNum.compareTo(aNum);
    });

    final result = <Changelog>[];
    for (final path in files) {
      try {
        final filename = path.split('/').last.replaceAll('.txt', '');
        final timestamp = int.tryParse(filename);
        if (timestamp == null || filename.isEmpty) {
          talker.warning('Skipping invalid changelog asset: $path');
          continue;
        }

        final content =
            localizedChangelogs[filename] ?? await bundle.loadString(path);
        result.add(
          Changelog(
            name: filename,
            created: DateFormat.yMMMd(
              localeTag,
            ).format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)),
            content: content,
          ),
        );
      } catch (error, stackTrace) {
        talker.handle(
          error,
          stackTrace,
          'Unable to load changelog asset: $path',
        );
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.whatsNewTitle)),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 116),
        itemBuilder: (context, index) => ListTile(
          title: Text(_changelogs[index].created),
          subtitle: Text(_changelogs[index].content),
        ),
        itemCount: _changelogs.length,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.favorite_outline),
        onPressed: () async {
          const url = 'https://github.com/sponsors/brandonp2412';
          if (await canLaunchUrlString(url)) await launchUrlString(url);
        },
        label: Text(context.l10n.donate),
      ),
    );
  }
}
