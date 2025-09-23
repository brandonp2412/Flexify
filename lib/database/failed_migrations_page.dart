import 'package:flexify/delete_records_button.dart';
import 'package:flexify/export_data.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FailedMigrationsPage extends StatelessWidget {
  final Object error;

  const FailedMigrationsPage({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Failed migrations"),
          leading: const Icon(Icons.error),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const ListTile(
                title: Text(
                  "Something went wrong when creating/upgrading your database. Usually this can be fixed by deleting & re-creating your records.",
                ),
              ),
              SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  child: ListTile(
                    title: const Text("Error message:"),
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
                      'title': 'Failed migrations',
                      'body': error.toString(),
                    },
                  ).toString();

                  if (await canLaunchUrlString(url)) await launchUrlString(url);
                },
                label: const Text("Create issue"),
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
    );
  }
}
