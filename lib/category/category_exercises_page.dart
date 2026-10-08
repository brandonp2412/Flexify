import 'package:flexify/constants.dart';
import 'package:flexify/database/categories.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/edit_graph_page.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/platform_page_route.dart';
import 'package:flutter/material.dart';

/// Lists the exercises in [category] and opens each one for editing.
class CategoryExercisesPage extends StatelessWidget {
  const CategoryExercisesPage({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: StreamBuilder<List<Exercise>>(
        stream: watchCategoryExercises(category),
        builder: (context, snapshot) {
          final exercises = snapshot.data ?? const [];
          if (exercises.isEmpty) {
            return Center(child: Text(context.l10n.noExercisesFound));
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 116),
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return ListTile(
                title: Text(exercise.name),
                subtitle: Text(
                  displayMeasurementUnit(context.l10n, exercise.displayUnit),
                ),
                onTap: () => Navigator.of(context).push(
                  FlexPageRoute(
                    builder: (_) => EditGraphPage(
                      exercise: (name: exercise.name, category: category.name),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
