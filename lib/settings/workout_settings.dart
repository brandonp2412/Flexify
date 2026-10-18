import 'package:drift/drift.dart' hide Column;
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/settings/category_management_page.dart';
import 'package:flexify/platform_page_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

({List<Widget> tracking, List<Widget> history, List<Widget> graphs})
getWorkoutSettingGroups(BuildContext context, String term, Setting settings) {
  final l10n = context.l10n;
  final normalizedTerm = term.trim().toLowerCase();
  bool matches(Iterable<String> values) =>
      values.join(' ').toLowerCase().contains(normalizedTerm);
  return (
    history: [
      if (matches([l10n.groupHistory, l10n.groupHistoryDescription]))
        Tooltip(
          message: l10n.groupHistoryDescription,
          child: ListTile(
            title: Text(l10n.groupHistory),
            subtitle: Text(l10n.groupHistoryDescription),
            leading: settings.groupHistory
                ? const Icon(Icons.view_agenda)
                : const Icon(Icons.view_agenda_outlined),
            onTap: () => db.settings.update().write(
              SettingsCompanion(groupHistory: Value(!settings.groupHistory)),
            ),
            trailing: Switch(
              value: settings.groupHistory,
              onChanged: (value) => db.settings.update().write(
                SettingsCompanion(groupHistory: Value(value)),
              ),
            ),
          ),
        ),
      if (matches([l10n.showUnits, l10n.showUnitsDescription]))
        Tooltip(
          message: l10n.showUnitsDescription,
          child: ListTile(
            title: Text(l10n.showUnits),
            subtitle: Text(l10n.showUnitsDescription),
            leading: settings.showUnits
                ? const Icon(Icons.scale)
                : const Icon(Icons.scale_outlined),
            onTap: () => db.settings.update().write(
              SettingsCompanion(showUnits: Value(!settings.showUnits)),
            ),
            trailing: Switch(
              value: settings.showUnits,
              onChanged: (value) => db.settings.update().write(
                SettingsCompanion(showUnits: Value(value)),
              ),
            ),
          ),
        ),
    ],
    tracking: [
      if (matches([l10n.showBodyWeight, l10n.showBodyWeightDescription]))
        Tooltip(
          message: l10n.showBodyWeightDescription,
          child: ListTile(
            title: Text(l10n.showBodyWeight),
            subtitle: Text(l10n.showBodyWeightDescription),
            leading: settings.showBodyWeight
                ? const Icon(Icons.monitor_weight)
                : const Icon(Icons.monitor_weight_outlined),
            onTap: () => db.settings.update().write(
              SettingsCompanion(
                showBodyWeight: Value(!settings.showBodyWeight),
              ),
            ),
            trailing: Switch(
              value: settings.showBodyWeight,
              onChanged: (value) => db.settings.update().write(
                SettingsCompanion(showBodyWeight: Value(value)),
              ),
            ),
          ),
        ),
      if (matches([l10n.showCategories, l10n.showCategoriesDescription]))
        Tooltip(
          message: l10n.showCategoriesDescription,
          child: ListTile(
            title: Text(l10n.showCategories),
            subtitle: Text(l10n.showCategoriesDescription),
            leading: settings.showCategories
                ? const Icon(Icons.category)
                : const Icon(Icons.category_outlined),
            onTap: () => db.settings.update().write(
              SettingsCompanion(
                showCategories: Value(!settings.showCategories),
              ),
            ),
            trailing: Switch(
              value: settings.showCategories,
              onChanged: (value) => db.settings.update().write(
                SettingsCompanion(showCategories: Value(value)),
              ),
            ),
          ),
        ),
      if (matches([l10n.manageCategories, l10n.manageCategoriesDescription]))
        ListTile(
          leading: const Icon(Icons.category),
          title: Text(l10n.manageCategories),
          subtitle: Text(l10n.manageCategoriesDescription),
          onTap: () => Navigator.of(
            context,
          ).push(FlexPageRoute(builder: (_) => const CategoryManagementPage())),
        ),
      if (matches([l10n.showNotes, l10n.showNotesDescription]))
        Tooltip(
          message: l10n.showNotesDescription,
          child: ListTile(
            title: Text(l10n.showNotes),
            subtitle: Text(l10n.showNotesDescription),
            leading: settings.showNotes
                ? const Icon(Icons.note_alt)
                : const Icon(Icons.note_alt_outlined),
            onTap: () => db.settings.update().write(
              SettingsCompanion(showNotes: Value(!settings.showNotes)),
            ),
            trailing: Switch(
              value: settings.showNotes,
              onChanged: (value) => db.settings.update().write(
                SettingsCompanion(showNotes: Value(value)),
              ),
            ),
          ),
        ),
      if (matches([
        l10n.positiveReinforcement,
        l10n.positiveNotificationsDescription,
      ]))
        Tooltip(
          message: l10n.positiveNotificationsDescription,
          child: ListTile(
            title: Text(l10n.positiveReinforcement),
            subtitle: Text(l10n.positiveNotificationsDescription),
            leading: const Icon(Icons.celebration_outlined),
            onTap: () {
              db.settings.update().write(
                SettingsCompanion(
                  notifications: Value(!settings.notifications),
                ),
              );
              if (!settings.notifications)
                messengerKey.currentState!.showSnackBar(
                  SnackBar(
                    content: Text(l10n.positiveMessagesEnabled),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    duration: const Duration(seconds: 4),
                    persist: false,
                  ),
                );
            },
            trailing: Switch(
              value: settings.notifications,
              onChanged: (value) => db.settings.update().write(
                SettingsCompanion(notifications: Value(value)),
              ),
            ),
          ),
        ),
      if (matches([
        l10n.durationEstimation,
        l10n.durationEstimationDescription,
      ]))
        Tooltip(
          message: l10n.durationEstimationDescription,
          child: ListTile(
            title: Text(l10n.durationEstimation),
            subtitle: Text(l10n.durationEstimationDescription),
            leading: settings.durationEstimation
                ? const Icon(Icons.schedule)
                : const Icon(Icons.schedule_outlined),
            onTap: () => db.settings.update().write(
              SettingsCompanion(
                durationEstimation: Value(!settings.durationEstimation),
              ),
            ),
            trailing: Switch(
              value: settings.durationEstimation,
              onChanged: (value) => db.settings.update().write(
                SettingsCompanion(durationEstimation: Value(value)),
              ),
            ),
          ),
        ),
    ],
    graphs: [
      if (matches([
        l10n.showGraphXAxisToggle,
        l10n.showGraphXAxisToggleDescription,
      ]))
        Tooltip(
          message: l10n.showGraphXAxisToggleDescription,
          child: ListTile(
            title: Text(l10n.showGraphXAxisToggle),
            subtitle: Text(l10n.showGraphXAxisToggleDescription),
            leading: settings.showGraphXAxis
                ? const Icon(Icons.show_chart)
                : const Icon(Icons.show_chart_outlined),
            onTap: () => db.settings.update().write(
              SettingsCompanion(
                showGraphXAxis: Value(!settings.showGraphXAxis),
              ),
            ),
            trailing: Switch(
              value: settings.showGraphXAxis,
              onChanged: (value) => db.settings.update().write(
                SettingsCompanion(showGraphXAxis: Value(value)),
              ),
            ),
          ),
        ),
      if (matches([l10n.showGraphLimit, l10n.showGraphLimitDescription]))
        Tooltip(
          message: l10n.showGraphLimitDescription,
          child: ListTile(
            title: Text(l10n.showGraphLimit),
            subtitle: Text(l10n.showGraphLimitDescription),
            leading: settings.showGraphLimit
                ? const Icon(Icons.tune)
                : const Icon(Icons.tune_outlined),
            onTap: () => db.settings.update().write(
              SettingsCompanion(
                showGraphLimit: Value(!settings.showGraphLimit),
              ),
            ),
            trailing: Switch(
              value: settings.showGraphLimit,
              onChanged: (value) => db.settings.update().write(
                SettingsCompanion(showGraphLimit: Value(value)),
              ),
            ),
          ),
        ),
      if (matches([
        l10n.defaultGraphMetric,
        l10n.bestWeight,
        l10n.bestReps,
        l10n.oneRepMax,
        l10n.volume,
        l10n.paceCardio,
        l10n.distanceCardio,
      ]))
        Padding(
          padding: settingsPadding,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: l10n.defaultGraphMetric),
            initialValue: settings.defaultGraphMetric,
            items: [
              DropdownMenuItem(
                value: 'bestWeight',
                child: Text(l10n.bestWeight),
              ),
              DropdownMenuItem(value: 'bestReps', child: Text(l10n.bestReps)),
              DropdownMenuItem(value: 'oneRepMax', child: Text(l10n.oneRepMax)),
              DropdownMenuItem(value: 'volume', child: Text(l10n.volume)),
              DropdownMenuItem(value: 'pace', child: Text(l10n.paceCardio)),
              DropdownMenuItem(
                value: 'distance',
                child: Text(l10n.distanceCardio),
              ),
            ],
            onChanged: (value) => db.settings.update().write(
              SettingsCompanion(defaultGraphMetric: Value(value!)),
            ),
          ),
        ),
      if (matches([
        l10n.defaultGraphPeriod,
        l10n.daily,
        l10n.weekly,
        l10n.monthly,
        l10n.yearly,
      ]))
        Padding(
          padding: settingsPadding,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: l10n.defaultGraphPeriod),
            initialValue: settings.defaultGraphPeriod,
            items: [
              DropdownMenuItem(value: 'day', child: Text(l10n.daily)),
              DropdownMenuItem(value: 'week', child: Text(l10n.weekly)),
              DropdownMenuItem(value: 'month', child: Text(l10n.monthly)),
              DropdownMenuItem(value: 'year', child: Text(l10n.yearly)),
            ],
            onChanged: (value) => db.settings.update().write(
              SettingsCompanion(defaultGraphPeriod: Value(value!)),
            ),
          ),
        ),
      if (matches([l10n.defaultGraphLimit]))
        Padding(
          padding: settingsPadding,
          child: DropdownButtonFormField<int>(
            decoration: InputDecoration(labelText: l10n.defaultGraphLimit),
            initialValue: settings.defaultGraphLimit,
            items: const [
              DropdownMenuItem(value: 10, child: Text("10")),
              DropdownMenuItem(value: 20, child: Text("20")),
              DropdownMenuItem(value: 30, child: Text("30")),
              DropdownMenuItem(value: 50, child: Text("50")),
              DropdownMenuItem(value: 100, child: Text("100")),
              DropdownMenuItem(value: 200, child: Text("200")),
            ],
            onChanged: (value) => db.settings.update().write(
              SettingsCompanion(defaultGraphLimit: Value(value!)),
            ),
          ),
        ),
      if (matches([
        l10n.defaultTimeBasedXAxis,
        l10n.defaultTimeBasedXAxisDescription,
      ]))
        Tooltip(
          message: l10n.defaultTimeBasedXAxisDescription,
          child: ListTile(
            title: Text(l10n.defaultTimeBasedXAxis),
            subtitle: Text(l10n.defaultTimeBasedXAxisDescription),
            leading: settings.defaultGraphTimeBasedXAxis
                ? const Icon(Icons.timeline)
                : const Icon(Icons.timeline_outlined),
            onTap: () => db.settings.update().write(
              SettingsCompanion(
                defaultGraphTimeBasedXAxis: Value(
                  !settings.defaultGraphTimeBasedXAxis,
                ),
              ),
            ),
            trailing: Switch(
              value: settings.defaultGraphTimeBasedXAxis,
              onChanged: (value) => db.settings.update().write(
                SettingsCompanion(defaultGraphTimeBasedXAxis: Value(value)),
              ),
            ),
          ),
        ),
    ],
  );
}

List<Widget> getWorkoutSettings(
  BuildContext context,
  String term,
  Setting settings,
) {
  final groups = getWorkoutSettingGroups(context, term, settings);
  return [...groups.tracking, ...groups.history, ...groups.graphs];
}

class WorkoutSettings extends StatefulWidget {
  const WorkoutSettings({super.key});

  @override
  State<WorkoutSettings> createState() => _WorkoutSettingsState();
}

class _WorkoutSettingsState extends State<WorkoutSettings> {
  late var _settings = context.read<Setting>();

  @override
  Widget build(BuildContext context) {
    _settings = context.watch<Setting>();
    final settings = getWorkoutSettingGroups(context, '', _settings);

    Widget section(
      String? title,
      List<Widget> children, {
      bool collapsed = false,
    }) {
      final rows = <Widget>[
        for (var index = 0; index < children.length; index++) ...[
          children[index],
        ],
      ];
      final content = collapsed
          ? ExpansionTile(
              title: Text(title!),
              initiallyExpanded: false,
              children: rows,
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ...rows,
              ],
            );

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        clipBehavior: Clip.antiAlias,
        child: content,
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(context.l10n.workouts)),
      body: ResponsiveSettingsList(
        grouped: false,
        children: [
          section(null, settings.tracking),
          section(context.l10n.navHistory, settings.history),
          section(context.l10n.navGraphs, settings.graphs, collapsed: true),
        ],
      ),
    );
  }
}
