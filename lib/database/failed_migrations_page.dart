import 'package:flexify/delete_records_button.dart';
import 'package:flexify/export_data.dart';
import 'package:flexify/l10n/generated/app_localizations.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FailedMigrationsPage extends StatelessWidget {
  final Object error;

  const FailedMigrationsPage({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => context.l10n.appTitle,
      home: Builder(
        builder: (context) => Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(context.l10n.failedMigrations),
            leading: const Icon(Icons.error),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  title: Text(context.l10n.databaseMigrationFailureDescription),
                ),
                SizedBox(
                  height: 300,
                  child: SingleChildScrollView(
                    child: ListTile(
                      title: Text(context.l10n.errorMessageLabel),
                      subtitle: Text(error.toString()),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const ExportData(),
                DeleteRecordsButton(ctx: context),
                TextButton.icon(
                  onPressed: () async {
                    final url = Uri(
                      scheme: 'https',
                      host: 'github.com',
                      path: '/brandonp2412/Flexify/issues/new',
                      queryParameters: {
                        'title': context.l10n.failedMigrations,
                        'body': error.toString(),
                      },
                    ).toString();

                    if (await canLaunchUrlString(url))
                      await launchUrlString(url);
                  },
                  label: Text(context.l10n.createIssue),
                  icon: Image.asset(
                    "assets/github-mark.png",
                    height: 24,
                    width: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
