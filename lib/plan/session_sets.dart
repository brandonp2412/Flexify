import 'package:drift/drift.dart' hide Column;
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';

/// Strong/Hevy-style strip of the sets already logged this session for the
/// selected exercise.
///
/// "This session" matches the plan's set-count window (the last 24 hours of
/// non-hidden sets for this plan) so the chips stay in sync with the count
/// shown on the exercise tile. Tap a chip to edit that set; the strip refreshes
/// reactively as sets are saved or edited.
class SessionSets extends StatefulWidget {
  final String exercise;
  final int planId;

  const SessionSets({
    super.key,
    required this.exercise,
    required this.planId,
  });

  @override
  State<SessionSets> createState() => _SessionSetsState();
}

class _SessionSetsState extends State<SessionSets> {
  late Stream<List<GymSet>> stream;

  @override
  void initState() {
    super.initState();
    _watch();
  }

  @override
  void didUpdateWidget(SessionSets oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise != widget.exercise ||
        oldWidget.planId != widget.planId) _watch();
  }

  void _watch() {
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));
    stream = (db.gymSets.select()
          ..where(
            (tbl) =>
                tbl.name.equals(widget.exercise) &
                tbl.planId.equals(widget.planId) &
                tbl.hidden.equals(false) &
                tbl.created.isBiggerOrEqualValue(cutoff),
          )
          ..orderBy([
            (u) => OrderingTerm(expression: u.created, mode: OrderingMode.asc),
          ]))
        .watch();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        final sets = snapshot.data;

        return AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: sets == null || sets.isEmpty
              ? const SizedBox.shrink()
              : _buildChips(sets),
        );
      },
    );
  }

  Widget _buildChips(List<GymSet> sets) {
    final best = _bestId(sets);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < sets.length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _SetChip(
                    gymSet: sets[i],
                    number: i + 1,
                    best: sets[i].id == best,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Id of the top set this session: heaviest weight (strength) or furthest
  /// distance (cardio). Returns null when nothing stands out.
  int? _bestId(List<GymSet> sets) {
    if (sets.length < 2) return null;
    final cardio = sets.first.cardio;
    final best = sets.reduce(
      (a, b) =>
          (cardio ? b.distance > a.distance : b.weight > a.weight) ? b : a,
    );
    final metric = cardio ? best.distance : best.weight;
    if (metric <= 0) return null;
    return best.id;
  }
}

class _SetChip extends StatelessWidget {
  final GymSet gymSet;
  final int number;
  final bool best;

  const _SetChip({
    required this.gymSet,
    required this.number,
    required this.best,
  });

  String get _value {
    if (gymSet.cardio) return "${toString(gymSet.distance)} ${gymSet.unit}";
    return "${toString(gymSet.weight)} ${gymSet.unit} × ${toString(gymSet.reps)}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => EditSetPage(gymSet: gymSet)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Set $number",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (best) ...[
                    const SizedBox(width: 4.0),
                    Icon(
                      Icons.star,
                      size: 12,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ],
              ),
              Text(_value, style: theme.textTheme.titleSmall),
            ],
          ),
        ),
      ),
    );
  }
}
