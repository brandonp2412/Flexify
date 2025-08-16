import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/plan/start_plan_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanTile extends StatelessWidget {
  final Plan plan;

  final String weekday;
  final int index;
  final GlobalKey<NavigatorState> navigatorKey;
  final Function(int) onSelect;
  final Set<int> selected;
  const PlanTile({
    super.key,
    required this.plan,
    required this.weekday,
    required this.index,
    required this.navigatorKey,
    required this.onSelect,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    Widget title = const Text("Daily");
    if (plan.title?.isNotEmpty == true) {
      final today = plan.days.split(',').contains(weekday);
      title = Text(
        plan.title!,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: today ? FontWeight.bold : null,
              decoration: today ? TextDecoration.underline : null,
              color: selected.contains(plan.id)
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
      );
    } else if (plan.days.split(',').length < 7)
      title = RichText(text: TextSpan(children: getChildren(context)));

    Widget? leading = SizedBox(
      height: 24,
      width: 24,
      child: Checkbox(
        value: selected.contains(plan.id),
        onChanged: (value) {
          onSelect(plan.id);
        },
      ),
    );

    if (selected.isEmpty)
      leading = GestureDetector(
        onTap: () => onSelect(plan.id),
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              plan.title?.isNotEmpty == true
                  ? plan.title![0]
                  : plan.days[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
      );

    leading = AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: leading,
    );

    return ListTile(
      title: title,
      subtitle: Text(plan.exercises.split(',').join(', ')),
      leading: leading,
      selected: selected.contains(plan.id),
      trailing: Builder(
        builder: (context) {
          final trailing = context.select<SettingsState, PlanTrailing>(
            (settings) => PlanTrailing.values.byName(
              settings.value.planTrailing.replaceFirst('PlanTrailing.', ''),
            ),
          );
          if (trailing == PlanTrailing.none) return const SizedBox();

          if (trailing == PlanTrailing.reorder)
            return ReorderableDragStartListener(
              index: index,
              child: const Icon(Icons.drag_handle),
            );

          final state = context.watch<PlanState>();
          final count = state.planCounts
              .firstWhere((element) => element.planId == plan.id);

          if (trailing == PlanTrailing.count)
            return Text(
              "${count.total}",
              style: const TextStyle(fontSize: 16),
            );

          if (trailing == PlanTrailing.percent)
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
      ),
      onTap: () async {
        if (selected.isNotEmpty) return onSelect(plan.id);
        final state = context.read<PlanState>();
        await state.updateGymCounts(plan.id);

        navigatorKey.currentState!.push(
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

  List<InlineSpan> getChildren(BuildContext context) {
    List<InlineSpan> result = [];

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
                color: selected.contains(plan.id)
                    ? Theme.of(context).colorScheme.primary
                    : null,
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
}
