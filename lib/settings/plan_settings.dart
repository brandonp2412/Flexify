import 'package:drift/drift.dart' hide Column;
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Widget> getPlanSettings(
  BuildContext context,
  String term,
  Setting settings,
  TextEditingController max,
  TextEditingController warmup,
) {
  final l10n = context.l10n;
  final normalizedTerm = term.trim().toLowerCase();
  bool matches(Iterable<String> values) =>
      values.join(' ').toLowerCase().contains(normalizedTerm);
  return [
    if (matches([l10n.warmupSets, l10n.warmupSetsDescription]))
      Padding(
        padding: kSettingsInputPadding,
        child: Tooltip(
          message: l10n.warmupSetsDescription,
          child: TextField(
            controller: warmup,
            decoration: InputDecoration(
              labelText: l10n.warmupSets,
              hintText: '0',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            onTap: () => selectAll(warmup),
            onChanged: (value) => db.settings.update().write(
              SettingsCompanion(warmupSets: Value(int.tryParse(value))),
            ),
          ),
        ),
      ),
    if (matches([l10n.setsPerExerciseMax, l10n.setsPerExerciseDescription]))
      Padding(
        padding: kSettingsInputPadding,
        child: Tooltip(
          message: l10n.setsPerExerciseDescription,
          child: TextField(
            controller: max,
            decoration: InputDecoration(labelText: l10n.setsPerExerciseMax),
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            onTap: () => selectAll(max),
            onChanged: (value) {
              final parsed = int.tryParse(value);
              if (parsed != null && parsed > 0 && parsed <= 20) {
                db.settings.update().write(
                  SettingsCompanion(maxSets: Value(parsed)),
                );
              }
            },
          ),
        ),
      ),
    if (matches([
      l10n.planTrailingDisplay,
      l10n.planTrailingDisplayDescription,
    ]))
      Tooltip(
        message: l10n.planTrailingDisplayDescription,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  l10n.planTrailingDisplay,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Builder(
                builder: (context) {
                  final current = PlanTrailing.values.byName(
                    settings.planTrailing.replaceFirst('PlanTrailing.', ''),
                  );
                  void save(PlanTrailing v) => db.settings.update().write(
                    SettingsCompanion(planTrailing: Value(v.toString())),
                  );
                  const progressOptions = {
                    PlanTrailing.count,
                    PlanTrailing.percent,
                    PlanTrailing.ratio,
                  };
                  const otherOptions = {
                    PlanTrailing.reorder,
                    PlanTrailing.none,
                  };
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SegmentedButton<PlanTrailing>(
                        emptySelectionAllowed: true,
                        selected: progressOptions.contains(current)
                            ? {current}
                            : {},
                        segments: [
                          ButtonSegment(
                            value: PlanTrailing.count,
                            label: Text(l10n.countLabel),
                            icon: const Icon(Icons.tag),
                          ),
                          const ButtonSegment(
                            value: PlanTrailing.percent,
                            label: Text('%'),
                            icon: Icon(Icons.percent),
                          ),
                          ButtonSegment(
                            value: PlanTrailing.ratio,
                            label: Text(l10n.ratioLabel),
                            icon: const Icon(Icons.format_list_numbered),
                          ),
                        ],
                        onSelectionChanged: (s) {
                          if (s.isNotEmpty) save(s.first);
                        },
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<PlanTrailing>(
                        emptySelectionAllowed: true,
                        selected: otherOptions.contains(current)
                            ? {current}
                            : {},
                        segments: [
                          ButtonSegment(
                            value: PlanTrailing.reorder,
                            label: Text(l10n.reorder),
                            icon: const Icon(Icons.menu),
                          ),
                          ButtonSegment(
                            value: PlanTrailing.none,
                            label: Text(l10n.none),
                            icon: const Icon(Icons.block),
                          ),
                        ],
                        onSelectionChanged: (s) {
                          if (s.isNotEmpty) save(s.first);
                        },
                      ),
                      const SizedBox(height: 8),
                      _PlanTrailingPreview(trailing: current),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
  ];
}

class PlanSettings extends StatefulWidget {
  const PlanSettings({super.key});

  @override
  State<PlanSettings> createState() => _PlanSettingsState();
}

class _PlanSettingsState extends State<PlanSettings> {
  late var _settings = context.read<SettingsState>().value;

  late final _max = TextEditingController(text: _settings.maxSets.toString());

  late final _warmup = TextEditingController(
    text: _settings.warmupSets?.toString(),
  );

  @override
  void dispose() {
    _max.dispose();
    _warmup.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _settings = context.watch<SettingsState>().value;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(context.l10n.navPlans)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 116),
          children: getPlanSettings(context, '', _settings, _max, _warmup),
        ),
      ),
    );
  }
}

/// A mock plan list tile previewing how [trailing] looks.
class _PlanTrailingPreview extends StatelessWidget {
  final PlanTrailing trailing;

  const _PlanTrailingPreview({required this.trailing});

  Widget _buildTrailing(BuildContext context) {
    return switch (trailing) {
      PlanTrailing.count => Text(
        formatDisplayNumber(context, 5, maximumFractionDigits: 0),
        style: const TextStyle(fontSize: 16),
      ),
      PlanTrailing.percent => Text(
        formatDisplayPercent(context, 5 / 6),
        style: const TextStyle(fontSize: 16),
      ),
      PlanTrailing.ratio => Text(
        '${formatDisplayNumber(context, 5, maximumFractionDigits: 0)} / ${formatDisplayNumber(context, 6, maximumFractionDigits: 0)}',
        style: const TextStyle(fontSize: 16),
      ),
      PlanTrailing.reorder => const Icon(Icons.drag_handle),
      PlanTrailing.none => const SizedBox(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            localizedWeekday(context.l10n, 'Monday', abbreviated: true),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ),
        title: Text(context.l10n.monday),
        subtitle: Text(context.l10n.examplePlanExercises),
        trailing: _buildTrailing(context),
      ),
    );
  }
}
