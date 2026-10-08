import 'package:flexify/database/exercise_key.dart';
import 'package:flutter/material.dart';

/// Autocomplete suggestions that show each exercise with its category, so the
/// same name in different categories can be told apart.
class ExerciseOptionsView extends StatelessWidget {
  const ExerciseOptionsView({
    super.key,
    required this.options,
    required this.onSelected,
  });

  final Iterable<ExerciseKey> options;
  final AutocompleteOnSelected<ExerciseKey> onSelected;

  @override
  Widget build(BuildContext context) {
    final highlightedIndex = AutocompleteHighlightedOption.of(context);

    return Material(
      elevation: 4,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 240),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: options.length,
          itemBuilder: (context, index) {
            final option = options.elementAt(index);
            final highlighted = index == highlightedIndex;
            return Builder(
              builder: (context) {
                if (highlighted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) Scrollable.ensureVisible(context);
                  });
                }
                return ListTile(
                  selected: highlighted,
                  title: Text(option.name),
                  subtitle: option.category == null
                      ? null
                      : Text(option.category!),
                  onTap: () => onSelected(option),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
