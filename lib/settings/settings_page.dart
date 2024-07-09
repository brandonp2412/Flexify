import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flexify/about_page.dart';
import 'package:flexify/settings/settings_appearance.dart';
import 'package:flexify/settings/settings_data.dart';
import 'package:flexify/settings/settings_formats.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/settings/settings_timer.dart';
import 'package:flexify/settings/settings_workout.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsLine {
  final String key;
  final Widget widget;

  SettingsLine({required this.key, required this.widget});
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final searchController = TextEditingController();

  late var settings = context.read<SettingsState>();
  late final maxSetsController =
      TextEditingController(text: settings.maxSets.toString());
  late final minutesController =
      TextEditingController(text: settings.timerDuration.inMinutes.toString());
  late final secondsController = TextEditingController(
    text: (settings.timerDuration.inSeconds % 60).toString(),
  );

  AudioPlayer? player;

  @override
  void initState() {
    super.initState();

    if (platformSupportsTimer()) player = AudioPlayer();
  }

  @override
  void dispose() {
    searchController.dispose();
    maxSetsController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> filtered = [];
    final settings = context.watch<SettingsState>();
    if (searchController.text.isNotEmpty) {
      filtered.addAll(getAppearances(searchController.text, settings));
      filtered.addAll(getFormats(searchController.text, settings));
      filtered.addAll(
        getWorkouts(searchController.text, settings, maxSetsController),
      );
      if (player != null)
        filtered.addAll(
          getTimers(
            searchController.text,
            settings,
            minutesController,
            secondsController,
            player!,
          ),
        );
      filtered
          .addAll(getSettingsData(searchController.text, settings, context));
    }

    if (filtered.isEmpty)
      filtered = [
        const ListTile(
          title: Text("No settings found"),
        ),
      ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          if (!Platform.isIOS && !Platform.isMacOS)
            IconButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
              icon: const Icon(Icons.info_outline_rounded),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SearchBar(
              hintText: "Search...",
              controller: searchController,
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onChanged: (_) {
                setState(() {});
              },
              leading: const Icon(Icons.search),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: ListView(
                children: searchController.text.isNotEmpty
                    ? filtered
                    : [
                        ListTile(
                          leading: const Icon(Icons.color_lens),
                          title: const Text("Appearance"),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SettingsAppearance(),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.format_bold),
                          title: const Text("Formats"),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SettingsFormat(),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.fitness_center),
                          title: const Text("Workouts"),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SettingsWorkout(),
                            ),
                          ),
                        ),
                        if (platformSupportsTimer())
                          ListTile(
                            leading: const Icon(Icons.timer),
                            title: const Text("Timers"),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SettingsTimer(),
                              ),
                            ),
                          ),
                        ListTile(
                          leading: const Icon(Icons.storage),
                          title: const Text("Data management"),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SettingsData(),
                            ),
                          ),
                        ),
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
