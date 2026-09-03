import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/plan/start_plan_page.dart';
import 'package:flexify/responsive.dart';
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
    dbVersion.addListener(_onDbChanged);
  }

  @override
  void dispose() {
    dbVersion.removeListener(_onDbChanged);
    super.dispose();
  }

  void _onDbChanged() {
    setState(() => _exercisesStream = _getExercises());
  }

  Stream<List<PlanExercise>> _getExercises() {
    return (db.planExercises.select()
          ..where((tbl) => tbl.planId.equals(widget.plan.id) & tbl.enabled)
          ..orderBy([
            (u) => OrderingTerm(expression: u.sequence, mode: OrderingMode.asc),
          ]))
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

    final showImages = context.select<SettingsState, bool>(
      (settings) => settings.value.showImages,
    );

    Widget? leading;

    if (showImages)
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

    final desktop = isDesktopLayout(context);
    final colors = Theme.of(context).colorScheme;
    final today = widget.plan.days.split(',').contains(widget.weekday);

    final tile = Material(
      color: widget.selected.contains(widget.plan.id)
          ? colors.primary.withValues(alpha: .18)
          : desktop
          ? colors.surfaceContainerLow
          : Colors.transparent,
      borderRadius: desktop ? BorderRadius.circular(16) : null,
      clipBehavior: desktop ? Clip.antiAlias : Clip.none,
      child: ListTile(
        contentPadding: desktop
            ? const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
            : null,
        title: Row(
          children: [
            Flexible(child: title),
            if (desktop && today) ...[
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Today',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: StreamBuilder(
            stream: _exercisesStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  snapshot.data!.map((e) => e.exercise).join('  •  '),
                  maxLines: desktop ? 2 : null,
                  overflow: desktop ? TextOverflow.ellipsis : null,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return const Text('Loading exercises...');
            },
          ),
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
            if (trailing == PlanTrailing.reorder && desktop) {
              return ReorderableDragStartListener(
                index: widget.index,
                child: Icon(
                  Icons.drag_indicator_rounded,
                  color: colors.onSurfaceVariant,
                ),
              );
            }
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
            final idx = state.planCounts.indexWhere(
              (element) => element.planId == widget.plan.id,
            );
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
              builder: (context) => StartPlanPage(plan: widget.plan),
            ),
          );
        },
        onLongPress: () => widget.onSelect(widget.plan.id),
      ),
    );

    if (!desktop) return tile;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: tile,
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
            fontWeight: widget.weekday == day.trim() ? FontWeight.bold : null,
            decoration: widget.weekday == day.trim()
                ? TextDecoration.underline
                : null,
          ),
        ),
      );
      if (index < split.length - 1)
        result.add(
          TextSpan(text: ", ", style: Theme.of(context).textTheme.bodyLarge),
        );
    }
    return result;
  }
}
