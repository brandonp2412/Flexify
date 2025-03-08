import 'dart:convert';

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
    final newChangelogs = await getChangelogFiles(context);
    setState(() {
      changelogs = newChangelogs;
    });
  }

  Future<List<Changelog>> getChangelogFiles(BuildContext context) async {
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final manifestMap = json.decode(manifestContent) as Map<String, dynamic>;

    final changelogFiles = manifestMap.keys
        .where((key) => key.startsWith('assets/changelogs/'))
        .toList();

    // Sort by numeric filename
    changelogFiles.sort((a, b) {
      // Extract filename without extension
      final aName = a.split('/').last.split('.').first;
      final bName = b.split('/').last.split('.').first;

      // Parse to integers and compare
      final aNum = int.tryParse(aName) ?? 0;
      final bNum = int.tryParse(bName) ?? 0;
      return bNum.compareTo(aNum); // Descending order
    });

    // Load content for each file
    final result = await Future.wait(
      changelogFiles.map((path) async {
        final content = await rootBundle.loadString(path);
        final filename = path.split('/').last.replaceAll('.txt', '');
        return Changelog(
          name: filename,
          created: DateFormat.yMMMd().format(
            DateTime.fromMillisecondsSinceEpoch(int.parse(filename) * 1000),
          ),
          content: content,
        );
      }),
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("What's new?"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => ListTile(
          title: Text(changelogs[index].created),
          subtitle: Text(changelogs[index].content),
        ),
        itemCount: changelogs.length,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.favorite_outline),
        onPressed: () async {
          const url = 'https://github.com/sponsors/brandonp2412';
          if (await canLaunchUrlString(url)) await launchUrlString(url);
        },
        label: Text("Donate"),
      ),
    );
  }
}
