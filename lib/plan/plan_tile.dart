import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/plan/start_plan_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanTile extends StatefulWidget {
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
  State<PlanTile> createState() => _PlanTileState();
}

class _PlanTileState extends State<PlanTile> {
  late Stream<List<PlanExercise>> _exercisesStream;

  @override
  void initState() {
    super.initState();
    _exercisesStream = _getExercises();
  }

  Stream<List<PlanExercise>> _getExercises() {
    return (db.planExercises.select()
          ..where((tbl) => tbl.planId.equals(widget.plan.id))
          ..where((tbl) => tbl.enabled.equals(true))
          ..orderBy(
            [
              (u) =>
                  OrderingTerm(expression: u.sequence, mode: OrderingMode.asc),
            ],
          ))
        .watch();
  }

  @override
  Widget build(BuildContext context) {
    Widget title = const Text("Daily");
    if (widget.plan.title?.isNotEmpty == true) {
      final today = widget.plan.days.split(',').contains(widget.weekday);
      title = Text(
        widget.plan.title!,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: today ? FontWeight.bold : null,
              decoration: today ? TextDecoration.underline : null,
            ),
      );
    } else if (widget.plan.days.split(',').length < 7)
      title = RichText(text: TextSpan(children: _getChildren(context)));

    Widget? leading = SizedBox(
      height: 24,
      width: 24,
      child: Checkbox(
        value: widget.selected.contains(widget.plan.id),
        onChanged: (value) {
          widget.onSelect(widget.plan.id);
        },
      ),
    );

    if (widget.selected.isEmpty)
      leading = GestureDetector(
        onTap: () => widget.onSelect(widget.plan.id),
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              widget.plan.title?.isNotEmpty == true
                  ? widget.plan.title![0]
                  : widget.plan.days[0].toUpperCase(),
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: widget.selected.contains(widget.plan.id)
            ? Theme.of(context).colorScheme.primary.withValues(alpha: .08)
            : Colors.transparent,
        border: Border.all(
          color: widget.selected.contains(widget.plan.id)
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: ListTile(
        title: title,
        subtitle: StreamBuilder(
          stream: _exercisesStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.map((e) => e.exercise).join(', '));
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return const Text('Loading exercises...');
          },
        ),
        leading: leading,
        trailing: Builder(
          builder: (context) {
            final trailing = context.select<SettingsState, PlanTrailing>(
              (settings) => PlanTrailing.values.byName(
                settings.value.planTrailing.replaceFirst('PlanTrailing.', ''),
              ),
            );
            if (trailing == PlanTrailing.none) return const SizedBox();
            if (trailing == PlanTrailing.reorder &&
                defaultTargetPlatform == TargetPlatform.linux)
              return const SizedBox();
            else if (trailing == PlanTrailing.reorder &&
                defaultTargetPlatform == TargetPlatform.android)
              return ReorderableDragStartListener(
                index: widget.index,
                child: const Icon(Icons.drag_handle),
              );

            final state = context.watch<PlanState>();
            final idx = state.planCounts
                .indexWhere((element) => element.planId == widget.plan.id);
            PlanCount count;
            if (idx != -1)
              count = state.planCounts[idx];
            else
              return const SizedBox();

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
          if (widget.selected.isNotEmpty)
            return widget.onSelect(widget.plan.id);
          final state = context.read<PlanState>();
          await state.updateGymCounts(widget.plan.id);

          widget.navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) => StartPlanPage(
                plan: widget.plan,
              ),
            ),
          );
        },
        onLongPress: () {
          widget.onSelect(widget.plan.id);
        },
      ),
    );
  }

  List<InlineSpan> _getChildren(BuildContext context) {
    List<InlineSpan> result = [];

    final split = widget.plan.days.split(',');
    for (int index = 0; index < split.length; index++) {
      final day = split[index];
      result.add(
        TextSpan(
          text: day.trim(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight:
                    widget.weekday == day.trim() ? FontWeight.bold : null,
                decoration: widget.weekday == day.trim()
                    ? TextDecoration.underline
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
