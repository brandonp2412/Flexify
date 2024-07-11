import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/plan/plans_list.dart';
import 'package:flexify/plan/start_plan_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanTile extends StatelessWidget {
  const PlanTile({
    super.key,
    required this.plan,
    required this.weekday,
    required this.index,
    required this.navigatorKey,
    required this.onSelect,
    required this.selected,
    required this.countStream,
  });

  final Plan plan;
  final String weekday;
  final int index;
  final GlobalKey<NavigatorState> navigatorKey;
  final Function(int) onSelect;
  final Set<int> selected;
  final Stream<List<Count>> countStream;

  List<InlineSpan> getChildren(BuildContext context) {
    List<InlineSpan> result = [];

    var color = Theme.of(context).textTheme.bodyLarge!.color;
    if (selected.contains(plan.id))
      color = Theme.of(context).colorScheme.primary;

    final split = plan.days.split(',');
    for (int index = 0; index < split.length; index++) {
      final day = split[index];
      result.add(
        TextSpan(
          text: day.trim(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: weekday == day.trim() ? FontWeight.bold : null,
                decoration:
                    weekday == day.trim() ? TextDecoration.underline : null,
                color: color,
              ),
        ),
      );
      if (index < split.length - 1)
        result.add(
          TextSpan(
            text: ", ",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Widget title = const Text("Daily");
    if (plan.title?.isNotEmpty == true)
      title = Text(plan.title!);
    else if (plan.days.split(',').length < 7)
      title = RichText(text: TextSpan(children: getChildren(context)));

    return ListTile(
      title: title,
      subtitle: Text(plan.exercises.split(',').join(', ')),
      trailing: Builder(
        builder: (context) {
          final planTrailing = context.select<SettingsState, PlanTrailing>(
            (value) => value.planTrailing,
          );
          if (planTrailing == PlanTrailing.none) return const SizedBox();

          if (planTrailing == PlanTrailing.reorder)
            return ReorderableDragStartListener(
              index: index,
              child: const Icon(Icons.drag_handle),
            );

          return StreamBuilder(
            stream: countStream,
            builder: (context, snapshot) {
              if (snapshot.data == null ||
                  snapshot.data!.isEmpty ||
                  snapshot.hasError) return const SizedBox();

              final count =
                  snapshot.data?.firstWhere((d) => d.planId == plan.id);
              if (count == null) return const SizedBox();

              if (planTrailing == PlanTrailing.count)
                return Text(
                  "${count.total}",
                  style: const TextStyle(fontSize: 16),
                );

              if (planTrailing == PlanTrailing.percent)
                return Text(
                  "${((count.total) / count.maxSets * 100).toStringAsFixed(2)}%",
                  style: const TextStyle(fontSize: 16),
                );
              else
                return Text(
                  "${count.total} / ${count.maxSets}",
                  style: const TextStyle(fontSize: 16),
                );
            },
          );
        },
      ),
      selected: selected.contains(plan.id),
      onTap: () async {
        if (selected.isNotEmpty) return onSelect(plan.id);

        await navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => StartPlanPage(
              plan: plan,
            ),
          ),
        );
      },
      onLongPress: () {
        onSelect(plan.id);
      },
    );
  }
}
