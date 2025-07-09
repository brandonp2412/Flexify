import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flexify/about_page.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/settings/appearance_settings.dart';
import 'package:flexify/settings/data_settings.dart';
import 'package:flexify/settings/format_settings.dart';
import 'package:flexify/settings/plan_settings.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/settings/tab_settings.dart';
import 'package:flexify/settings/timer_settings.dart';
import 'package:flexify/settings/workout_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final searchController = TextEditingController();

  late final Setting settings;
  late final TextEditingController maxSets;
  late final TextEditingController warmupSets;
  late final TextEditingController minutes;
  late final TextEditingController seconds;

  AudioPlayer? player;

  @override
  Widget build(BuildContext context) {
    List<Widget> filtered = [];
    final settings = context.watch<SettingsState>();
    if (searchController.text.isNotEmpty) {
      filtered.addAll(
        getAppearanceSettings(context, searchController.text, settings),
      );
      filtered.addAll(getFormatSettings(searchController.text, settings.value));
      filtered.addAll(
        getWorkoutSettings(
          searchController.text,
          settings.value,
        ),
      );
      if (player != null)
        filtered.addAll(
          getTimerSettings(
            searchController.text,
            settings.value,
            minutes,
            seconds,
            player!,
          ),
        );
      filtered
          .addAll(getDataSettings(searchController.text, settings, context));
      filtered.addAll(
        getPlanSettings(
          searchController.text,
          settings.value,
          maxSets,
          warmupSets,
        ),
      );
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
          if (!kIsWeb && !Platform.isIOS && !Platform.isMacOS)
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
                              builder: (context) => const AppearanceSettings(),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.storage),
                          title: const Text("Data management"),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const DataSettings(),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.format_bold),
                          title: const Text("Formats"),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const FormatSettings(),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: const Text("Plans"),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PlanSettings(),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.tab_sharp),
                          title: const Text("Tabs"),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const TabSettings(),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.timer),
                          title: const Text("Timers"),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const TimerSettings(),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.fitness_center),
                          title: const Text("Workouts"),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const WorkoutSettings(),
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

  @override
  void dispose() {
    searchController.dispose();
    maxSets.dispose();
    warmupSets.dispose();
    minutes.dispose();
    seconds.dispose();
    player?.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    settings = context.read<SettingsState>().value;
    maxSets = TextEditingController(text: settings.maxSets.toString());
    warmupSets = TextEditingController(text: settings.warmupSets?.toString());
    minutes = TextEditingController(
      text: Duration(milliseconds: settings.timerDuration).inMinutes.toString(),
    );
    seconds = TextEditingController(
      text: (Duration(milliseconds: settings.timerDuration).inSeconds % 60)
          .toString(),
    );
    
    // Only create AudioPlayer on supported platforms
    if (!kIsWeb) {
      try {
        player = AudioPlayer();
      } catch (e) {
        // Handle case where AudioPlayer creation fails
        print('Failed to create AudioPlayer: $e');
        player = null;
      }
    }
  }
}
