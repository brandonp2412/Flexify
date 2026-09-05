import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flexify/about_page.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/empty_state.dart';
import 'package:flexify/logging.dart';
import 'package:flexify/responsive.dart';
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
      filtered = [
        SizedBox(
          height: 360,
          child: AppEmptyState(
            icon: Icons.search_off_rounded,
            title: 'No settings found',
            message: 'Nothing matches “${_searchCtrl.text.trim()}”.',
            actionLabel: 'Clear search',
            actionIcon: Icons.close_rounded,
            onAction: () {
              _searchCtrl.clear();
              setState(() {});
            },
          ),
        ),
      ];

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
      body: ResponsiveContent(
        maxWidth: 1120,
        desktopPadding: const EdgeInsets.fromLTRB(32, 12, 32, 28),
        mobilePadding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            SearchBar(
              hintText: "Search...",
              controller: _searchCtrl,
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onChanged: (_) => setState(() {}),
              leading: const Icon(Icons.search),
            ),
            SizedBox(height: isDesktopLayout(context) ? 20 : 8),
            Expanded(
              child: _searchCtrl.text.isNotEmpty
                  ? ListView(
                      padding: EdgeInsets.only(
                        bottom: isDesktopLayout(context) ? 24 : 116,
                      ),
                      children: filtered,
                    )
                  : isDesktopLayout(context)
                  ? GridView.builder(
                      padding: const EdgeInsets.only(bottom: 24),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 4.0,
                          ),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final colors = Theme.of(context).colorScheme;
                        return Card(
                          color: colors.surfaceContainerLow,
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () => _openCategory(category.$4),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: colors.primaryContainer,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      category.$1,
                                      color: colors.onPrimaryContainer,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          category.$2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          category.$3,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: colors.onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right_rounded),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : ListView(
                      padding: const EdgeInsets.only(bottom: 116),
                      children: _categories
                          .map(
                            (category) => ListTile(
                              leading: Icon(category.$1),
                              title: Text(category.$2),
                              onTap: () => _openCategory(category.$4),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<(IconData, String, String, Widget)> get _categories => const [
    (
      Icons.color_lens_rounded,
      'Appearance',
      'Theme, colors and interface styling',
      AppearanceSettings(),
    ),
    (
      Icons.storage_rounded,
      'Data management',
      'Import, export and manage your workout data',
      DataSettings(),
    ),
    (
      Icons.format_bold_rounded,
      'Formats',
      'Dates, numbers and measurement formatting',
      FormatSettings(),
    ),
    (
      Icons.calendar_today_rounded,
      'Plans',
      'Defaults and behaviour for workout plans',
      PlanSettings(),
    ),
    (
      Icons.tab_rounded,
      'Tabs',
      'Choose and arrange primary navigation tabs',
      TabSettings(),
    ),
    (
      Icons.timer_rounded,
      'Timers',
      'Rest timer duration, sound and behaviour',
      TimerSettings(),
    ),
    (
      Icons.fitness_center_rounded,
      'Workouts',
      'Exercise tracking and workout preferences',
      WorkoutSettings(),
    ),
  ];

  void _openCategory(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
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
