import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/settings/whats_new.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final info = PackageInfo.fromPlatform();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(context.l10n.aboutTitle)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 116),
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage('assets/ic_launcher.png'),
              height: 150,
            ),
          ),
          ListTile(
            title: Text(context.l10n.donate),
            leading: const Icon(Icons.favorite_outline),
            subtitle: FutureBuilder(
              future: info,
              builder: (context, snapshot) =>
                  Text(context.l10n.helpSupportProject),
            ),
            onTap: () async {
              const url = 'https://github.com/sponsors/brandonp2412';
              await launchUrlString(url);
            },
          ),
          ListTile(
            title: Text(context.l10n.whatsNewAbout),
            subtitle: Text(context.l10n.seeReleaseNotes),
            leading: const Icon(Icons.change_circle_outlined),
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => const WhatsNew())),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(context.l10n.versionLabel),
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
            title: Text(context.l10n.authorLabel),
            leading: const Icon(Icons.person),
            subtitle: FutureBuilder(
              future: info,
              builder: (context, snapshot) => const Text("Brandon Dick"),
            ),
            onTap: () async {
              const url = 'https://github.com/brandonp2412';
              if (await canLaunchUrlString(url)) await launchUrlString(url);
            },
          ),
          ListTile(
            title: Text(context.l10n.privacyPolicy),
            leading: const Icon(Icons.privacy_tip_outlined),
            subtitle: Text(context.l10n.privacyPolicyDescription),
            onTap: () async {
              const url =
                  'https://brandonp2412.github.io/Flexify/privacy-policy.html';
              if (await canLaunchUrlString(url)) await launchUrlString(url);
            },
          ),
          ListTile(
            title: Text(context.l10n.licenseLabel),
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
            title: Text(context.l10n.sourceCode),
            leading: const Icon(Icons.code),
            subtitle: FutureBuilder(
              future: info,
              builder: (context, snapshot) =>
                  Text(context.l10n.sourceCodeDescription),
            ),
            onTap: () async {
              const url = 'https://github.com/brandonp2412/Flexify';
              if (await canLaunchUrlString(url)) await launchUrlString(url);
            },
          ),
          ListTile(
            title: Text(context.l10n.leaveReview),
            leading: const Icon(Icons.reviews_outlined),
            subtitle: Text(context.l10n.leaveReviewDescription),
            onTap: () async {
              const url =
                  'https://play.google.com/store/apps/details?id=com.presley.flexify';
              if (await canLaunchUrlString(url)) await launchUrlString(url);
            },
          ),
          ListTile(
            title: Text(context.l10n.reportBug),
            leading: const Icon(Icons.bug_report),
            subtitle: Text(context.l10n.reportBugDescription),
            onTap: () async {
              final version = (await info).version;
              final url =
                  'https://github.com/brandonp2412/Flexify/issues/new?labels=Bug&body=App version: $version';
              if (await canLaunchUrlString(url)) await launchUrlString(url);
            },
          ),
        ],
      ),
    );
  }
}
