import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  List<Changelog> changelogs = [];

  @override
  void initState() {
    super.initState();
    setChangelogs();
  }

  void setChangelogs() async {
    final logs = await getChangelogFiles(context);
    setState(() {
      changelogs = logs;
    });
  }

  Future<List<Changelog>> getChangelogFiles(BuildContext context) async {
    final manifest =
        await AssetManifest.loadFromAssetBundle(DefaultAssetBundle.of(context));

    final files = manifest
        .listAssets()
        .where((key) => key.startsWith('assets/changelogs/'))
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
        final content = await rootBundle.loadString(path);
        final filename = path.split('/').last.replaceAll('.txt', '');
        final timestamp = int.tryParse(filename);
        if (timestamp == null || filename.isEmpty) {
          print('Skipping invalid changelog file: $path');
          continue;
        }
        result.add(
          Changelog(
            name: filename,
            created: DateFormat.yMMMd().format(
              DateTime.fromMillisecondsSinceEpoch(timestamp * 1000),
            ),
            content: content,
          ),
        );
      } catch (e) {
        print('Error loading changelog file $path: $e');
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("What's new?"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => ListTile(
          title: Text(changelogs[index].created),
          subtitle: Text(changelogs[index].content),
        ),
        itemCount: changelogs.length,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.favorite_outline),
        onPressed: () async {
          const url = 'https://github.com/sponsors/brandonp2412';
          if (await canLaunchUrlString(url)) await launchUrlString(url);
        },
        label: const Text("Donate"),
      ),
    );
  }
}
