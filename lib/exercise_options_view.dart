import 'package:flexify/constants.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Autocomplete suggestions for exercises, showing each exercise's category
/// underneath its name so same-named exercises can be told apart.
class ExerciseOptionsView extends StatelessWidget {
  final Iterable<ExerciseKey> options;
  final AutocompleteOnSelected<ExerciseKey> onSelected;

  const ExerciseOptionsView({
    super.key,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Material(
        elevation: 4,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 280),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options.elementAt(index);
              return ListTile(
                title: Text(option.name),
                subtitle: option.name == bodyWeightExercise
                    ? null
                    : Text(categoryLabel(context.l10n, option.category)),
                onTap: () => onSelected(option),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Filters [options] to those whose name or category contains every word of
/// [query], ignoring case.
Iterable<ExerciseKey> filterExerciseOptions(
  Iterable<ExerciseKey> options,
  String query,
) {
  final terms = query.toLowerCase().split(' ').where((term) => term.isNotEmpty);
  return options.where((option) {
    final haystack = '${option.name} ${option.category ?? ''}'.toLowerCase();
    return terms.every(haystack.contains);
  });
}
