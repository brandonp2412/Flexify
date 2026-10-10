import 'package:flutter/material.dart';

class GraphMetricChips<T> extends StatelessWidget {
  const GraphMetricChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<(T, String)> options;
  final Set<T> selected;
  final ValueChanged<Set<T>> onChanged;

  static List<Color> palette(ColorScheme colors) => [
    colors.primary,
    colors.tertiary,
    colors.secondary,
    colors.error,
    colors.inversePrimary,
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final palette = GraphMetricChips.palette(colors);
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (var index = 0; index < options.length; index++)
          FilterChip(
            key: ValueKey('graph-metric-${options[index].$1}'),
            label: Text(options[index].$2),
            avatar: CircleAvatar(
              radius: 5,
              backgroundColor: palette[index % palette.length],
            ),
            selected: selected.contains(options[index].$1),
            showCheckmark: false,
            selectedColor: colors.primaryContainer,
            onSelected: (enabled) {
              final next = {...selected};
              if (enabled) {
                next.add(options[index].$1);
              } else if (next.length > 1) {
                next.remove(options[index].$1);
              } else {
                return;
              }
              onChanged(next);
            },
          ),
      ],
    );
  }
}
