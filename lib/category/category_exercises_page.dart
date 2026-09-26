import 'package:flexify/animated_fab.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/empty_state.dart';
import 'package:flexify/graph/add_exercise_page.dart';
import 'package:flexify/graph/graph_tile.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Shows the exercises in [category], where null lists uncategorized ones.
///
/// New exercises are created here so they always start in a category.
class CategoryExercisesPage extends StatefulWidget {
  final String? category;
  final TabController? tabController;

  const CategoryExercisesPage({super.key, this.category, this.tabController});

  @override
  State<CategoryExercisesPage> createState() => _CategoryExercisesPageState();
}

class _CategoryExercisesPageState extends State<CategoryExercisesPage> {
  final _scroll = ScrollController();
  late Stream<List<GymSetsCompanion>> _exercises;

  @override
  void initState() {
    super.initState();
    _exercises = watchGraphs();
    dbVersion.addListener(_onDatabaseChanged);
  }

  @override
  void dispose() {
    dbVersion.removeListener(_onDatabaseChanged);
    _scroll.dispose();
    super.dispose();
  }

  void _onDatabaseChanged() {
    if (!mounted) return;
    setState(() => _exercises = watchGraphs());
  }

  Future<void> _addExercise() => Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => AddExercisePage(
        category: widget.category,
        tabController: widget.tabController,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final category = widget.category;
    final canAdd = category != null;
    final desktop = isDesktopLayout(context);
    final dateFormat = context.select<SettingsState, String>(
      (settings) => settings.value.longDateFormat,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(categoryLabel(l10n, category)),
        actions: [
          if (desktop && canAdd)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: FilledButton.icon(
                onPressed: _addExercise,
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.addExercise),
              ),
            ),
        ],
      ),
      body: StreamBuilder<List<GymSetsCompanion>>(
        stream: _exercises,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          final exercises =
              snapshot.data!
                  .where(
                    (exercise) =>
                        exercise.category.value == category &&
                        exercise.name.value != bodyWeightExercise,
                  )
                  .toList()
                ..sort(
                  (a, b) => a.name.value.toLowerCase().compareTo(
                    b.name.value.toLowerCase(),
                  ),
                );

          if (exercises.isEmpty) {
            return AppEmptyState(
              icon: Icons.fitness_center_rounded,
              title: l10n.noExercisesInCategory(categoryLabel(l10n, category)),
              message: canAdd ? l10n.addExerciseToCategory : null,
              actionLabel: canAdd ? l10n.addExercise : null,
              actionIcon: Icons.add_rounded,
              onAction: canAdd ? _addExercise : null,
            );
          }

          return ListView.builder(
            controller: _scroll,
            padding: EdgeInsets.only(bottom: desktop ? 32 : 160),
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              final created = exercise.created.value;
              return ResponsiveContent(
                child: ListTile(
                  leading: Icon(
                    exercise.cardio.value
                        ? Icons.sports_gymnastics
                        : Icons.fitness_center,
                  ),
                  title: Text(exercise.name.value),
                  subtitle: Text(
                    dateFormat == 'timeago'
                        ? formatRelativeTime(context, created)
                        : formatDisplayDate(context, created, dateFormat),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => openExerciseGraph(
                    Navigator.of(context),
                    name: exercise.name.value,
                    category: category,
                    unit: exercise.unit.value,
                    cardio: exercise.cardio.value,
                    tabCtrl: widget.tabController,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: desktop || !canAdd
          ? null
          : AnimatedFab(
              onPressed: _addExercise,
              label: Text(l10n.actionAdd),
              icon: const Icon(Icons.add),
              scroll: _scroll,
            ),
    );
  }
}
