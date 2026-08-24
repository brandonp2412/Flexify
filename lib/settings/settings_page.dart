import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flexify/about_page.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/logging.dart';
import 'package:flexify/settings/appearance_settings.dart';
import 'package:flexify/settings/data_settings.dart';
import 'package:flexify/settings/format_settings.dart';
import 'package:flexify/settings/plan_settings.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/settings/tab_settings.dart';
import 'package:flexify/settings/timer_settings.dart';
import 'package:flexify/settings/workout_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin {
  final _searchCtrl = TextEditingController();

  late final Setting _settings;
  late final TextEditingController _maxSets;
  late final TextEditingController _warmupSets;
  late final TextEditingController _minutes;
  late final TextEditingController _seconds;

  AudioPlayer? _player;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Widget> filtered = [];
    final settings = context.watch<SettingsState>();
    if (_searchCtrl.text.isNotEmpty) {
      filtered.addAll(
        getAppearanceSettings(context, _searchCtrl.text, settings),
      );
      filtered.addAll(getFormatSettings(_searchCtrl.text, settings.value));
      filtered.addAll(
        getWorkoutSettings(context, _searchCtrl.text, settings.value),
      );
      if (_player != null)
        filtered.addAll(
          getTimerSettings(
            _searchCtrl.text,
            settings.value,
            _minutes,
            _seconds,
            _player!,
            context,
          ),
        );
      filtered.addAll(getDataSettings(_searchCtrl.text, settings, context));
      filtered.addAll(
        getPlanSettings(
          context,
          _searchCtrl.text,
          settings.value,
          _maxSets,
          _warmupSets,
        ),
      );
    }

    if (filtered.isEmpty)
      filtered = [const ListTile(title: Text("No _settings found"))];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          if (!kIsWeb && !Platform.isIOS && !Platform.isMacOS)
            IconButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AboutPage()),
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
              controller: _searchCtrl,
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onChanged: (_) {
                setState(() {});
              },
              leading: const Icon(Icons.search),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 116),
                children: _searchCtrl.text.isNotEmpty
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
    _searchCtrl.dispose();
    _maxSets.dispose();
    _warmupSets.dispose();
    _minutes.dispose();
    _seconds.dispose();
    _player?.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _settings = context.read<SettingsState>().value;
    _maxSets = TextEditingController(text: _settings.maxSets.toString());
    _warmupSets = TextEditingController(text: _settings.warmupSets?.toString());
    _minutes = TextEditingController(
      text: Duration(
        milliseconds: _settings.timerDuration,
      ).inMinutes.toString(),
    );
    _seconds = TextEditingController(
      text: (Duration(milliseconds: _settings.timerDuration).inSeconds % 60)
          .toString(),
    );

    if (!kIsWeb) {
      try {
        _player = AudioPlayer();
      } catch (error, stackTrace) {
        talker.handle(
          error,
          stackTrace,
          'Failed to create settings audio player',
        );
        _player = null;
      }
    }
  }
}
