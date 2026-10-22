import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/utils.dart';
import 'package:flexify/platform_page_route.dart';
import 'package:flutter/material.dart';

/// Strong/Hevy-style strip of the sets already logged in the active workout
/// for the selected exercise.
class SessionSets extends StatefulWidget {
  final int exerciseId;
  final List<ExerciseSetView> sets;
  final int workoutId;
  final bool compact;
  final PreviousExerciseDay? previous;
  final ValueChanged<PreviousExerciseSet>? onPreviousSetTap;

  const SessionSets({
    super.key,
    required this.exerciseId,
    required this.sets,
    required this.workoutId,
    this.compact = false,
    this.previous,
    this.onPreviousSetTap,
  });

  @override
  State<SessionSets> createState() => _SessionSetsState();
}

class _SessionSetsState extends State<SessionSets> {
  final ScrollController _scrollController = ScrollController();
  int _lastSetCount = 0;

  @override
  void didUpdateWidget(SessionSets oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exerciseId != widget.exerciseId ||
        oldWidget.workoutId != widget.workoutId) {
      _lastSetCount = 0;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToNewest(int setCount) {
    if (setCount <= _lastSetCount) return;
    _lastSetCount = setCount;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final sets = widget.sets;
    if (sets.isNotEmpty) _scrollToNewest(sets.length);

    if (sets.isEmpty) {
      final previous = widget.previous;
      if (previous == null || previous.sets.isEmpty) {
        return const SizedBox.shrink();
      }
      return _buildPreviousChips(previous);
    }

    if (!widget.compact) return _buildChips(sets);

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: _buildChips(sets),
    );
  }

  Widget _buildPreviousChips(PreviousExerciseDay previous) {
    return SingleChildScrollView(
      key: const Key('previous-set-scroll'),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < previous.sets.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _SetChip(
                previousSet: previous.sets[i],
                onPreviousTap: widget.onPreviousSetTap,
                number: i + 1,
                best: false,
                repsFirst: widget.compact,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChips(List<ExerciseSetView> sets) {
    final best = _bestId(sets);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.compact) const SizedBox(height: 16.0),
        SingleChildScrollView(
          key: const Key('session-set-scroll'),
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              for (var i = 0; i < sets.length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _SetChip(
                    exerciseSet: sets[i],
                    number: i + 1,
                    best: sets[i].id == best,
                    repsFirst: widget.compact,
                  ),
                ),
              for (
                var i = sets.length;
                i < (widget.previous?.sets.length ?? 0);
                i++
              )
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _SetChip(
                    previousSet: widget.previous!.sets[i],
                    onPreviousTap: widget.onPreviousSetTap,
                    number: i + 1,
                    best: false,
                    repsFirst: widget.compact,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Id of the top set this session, using the measurement shown to the user.
  int? _bestId(List<ExerciseSetView> sets) {
    if (sets.length < 2) return null;
    final cardio = sets.first.cardio;
    final weightedCardio = cardio && _isWeightUnit(sets.first.unit);
    final best = sets.reduce((a, b) {
      if (!cardio) return b.weight > a.weight ? b : a;
      if (!weightedCardio) return b.distance > a.distance ? b : a;
      if (b.weight != a.weight) return b.weight > a.weight ? b : a;
      return b.duration > a.duration ? b : a;
    });
    final metric = weightedCardio
        ? best.weight
        : cardio
        ? best.distance
        : best.weight;
    if (metric <= 0) return null;
    return best.id;
  }

  bool _isWeightUnit(String unit) =>
      unit == 'kg' || unit == 'lb' || unit == 'stone';
}

class _SetChip extends StatelessWidget {
  final ExerciseSetView? exerciseSet;
  final PreviousExerciseSet? previousSet;
  final ValueChanged<PreviousExerciseSet>? onPreviousTap;
  final int number;
  final bool best;
  final bool repsFirst;

  const _SetChip({
    this.exerciseSet,
    this.previousSet,
    this.onPreviousTap,
    required this.number,
    required this.best,
    required this.repsFirst,
  });

  String _value(BuildContext context) {
    final set = exerciseSet;
    final previous = previousSet;
    final unitCode = set?.unit ?? previous!.unit;
    final unit = displayMeasurementUnit(context.l10n, unitCode);
    final cardio = set?.cardio ?? previous!.cardio;
    final weightValue = set?.weight ?? previous!.weight;
    if (cardio &&
        (unitCode == 'kg' || unitCode == 'lb' || unitCode == 'stone')) {
      final duration = set?.duration ?? previous!.duration;
      final minutes = duration.floor();
      final seconds = ((duration * 60) % 60).floor().toString().padLeft(2, '0');
      return "${formatDisplayNumber(context, weightValue)} $unit / $minutes:$seconds";
    }
    if (cardio) {
      final distance = set?.distance ?? previous!.distance;
      return "${formatDisplayNumber(context, distance)} $unit";
    }
    final weight = "${formatDisplayNumber(context, weightValue)} $unit";
    final reps = formatDisplayNumber(context, set?.reps ?? previous!.reps);
    return repsFirst ? "$reps × $weight" : "$weight × $reps";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentSet = exerciseSet;
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: currentSet != null
            ? () => Navigator.of(context).push(
                FlexPageRoute(
                  builder: (context) => EditSetPage(exerciseSet: currentSet),
                ),
              )
            : previousSet != null && onPreviousTap != null
            ? () => onPreviousTap!(previousSet!)
            : null,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                12,
                repsFirst ? 10 : 8,
                previousSet == null ? 12 : 30,
                repsFirst ? 10 : 8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.l10n.setNumber(number),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (best) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.star,
                          size: 12,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ],
                  ),
                  Text(_value(context), style: theme.textTheme.titleSmall),
                ],
              ),
            ),
            if (previousSet != null)
              Positioned(
                top: repsFirst ? 10 : 8,
                right: 10,
                child: Icon(
                  Icons.history_rounded,
                  size: 13,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
