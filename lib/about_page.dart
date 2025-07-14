import 'package:flexify/settings/whats_new.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final info = PackageInfo.fromPlatform();
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage('assets/ic_launcher.png'),
              height: 150,
            ),
          ),
          ListTile(
            title: const Text("Donate"),
            leading: const Icon(Icons.favorite_outline),
            subtitle: FutureBuilder(
              future: info,
              builder: (context, snapshot) =>
                  const Text("Help support this project"),
            ),
            onTap: () async {
              const url = 'https://github.com/sponsors/brandonp2412';
              if (await canLaunchUrlString(url)) await launchUrlString(url);
            },
          ),
          ListTile(
            title: const Text("Whats new?"),
            leading: const Icon(Icons.change_circle_outlined),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WhatsNew(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("Version"),
            subtitle: FutureBuilder(
              future: info,
              builder: (context, snapshot) =>
                  Text(snapshot.data?.version ?? "1.0.0"),
            ),
            onTap: () async {
              const url = 'https://github.com/brandonp2412/Flexify/releases';
              if (await canLaunchUrlString(url)) await launchUrlString(url);
            },
          ),
          ListTile(
            title: const Text("Author"),
            leading: const Icon(Icons.person),
            subtitle: FutureBuilder(
              future: info,
              builder: (context, snapshot) => const Text("Brandon Presley"),
            ),
            onTap: () async {
              const url = 'https://github.com/brandonp2412';
              if (await canLaunchUrlString(url)) await launchUrlString(url);
            },
          ),
          ListTile(
            title: const Text("License"),
            leading: const Icon(Icons.balance),
            subtitle: FutureBuilder(
              future: info,
              builder: (context, snapshot) => const Text("MIT"),
            ),
            onTap: () async {
              const url =
                  'https://github.com/brandonp2412/Flexify?tab=MIT-1-ov-file#readme';
              if (await canLaunchUrlString(url)) await launchUrlString(url);
            },
          ),
          ListTile(
            title: const Text("Source code"),
            leading: const Icon(Icons.code),
            subtitle: FutureBuilder(
              future: info,
              builder: (context, snapshot) =>
                  const Text("Check it out on GitHub"),
            ),
            onTap: () async {
              const url = 'https://github.com/brandonp2412/Flexify';
              if (await canLaunchUrlString(url)) await launchUrlString(url);
            },
          ),
        ],
      ),
    );
  }
}
