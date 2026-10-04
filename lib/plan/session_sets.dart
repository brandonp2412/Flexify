import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/utils.dart';
import 'package:flexify/platform_page_route.dart';
import 'package:flutter/material.dart';

/// Strong/Hevy-style strip of the sets already logged in the active workout
/// for the selected exercise.
class SessionSets extends StatefulWidget {
  final int exerciseId;
  final int workoutId;
  final bool compact;

  const SessionSets({
    super.key,
    required this.exerciseId,
    required this.workoutId,
    this.compact = false,
  });

  @override
  State<SessionSets> createState() => _SessionSetsState();
}

class _SessionSetsState extends State<SessionSets> {
  late Stream<List<ExerciseSetView>> _stream;
  final ScrollController _scrollController = ScrollController();
  int _lastSetCount = 0;

  @override
  void initState() {
    super.initState();
    _watch();
  }

  @override
  void didUpdateWidget(SessionSets oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exerciseId != widget.exerciseId ||
        oldWidget.workoutId != widget.workoutId) {
      _lastSetCount = 0;
      _watch();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _watch() {
    _stream = watchWorkoutExerciseSets(
      db,
      workoutId: widget.workoutId,
      exerciseId: widget.exerciseId,
    );
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
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        final sets = snapshot.data;
        if (sets != null && sets.isNotEmpty) _scrollToNewest(sets.length);

        if (sets == null || sets.isEmpty) return const SizedBox.shrink();

        if (!widget.compact) return _buildChips(sets);

        return AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: _buildChips(sets),
        );
      },
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
  final ExerciseSetView exerciseSet;
  final int number;
  final bool best;
  final bool repsFirst;

  const _SetChip({
    required this.exerciseSet,
    required this.number,
    required this.best,
    required this.repsFirst,
  });

  String _value(BuildContext context) {
    final unit = displayMeasurementUnit(context.l10n, exerciseSet.unit);
    if (exerciseSet.cardio &&
        (exerciseSet.unit == 'kg' ||
            exerciseSet.unit == 'lb' ||
            exerciseSet.unit == 'stone')) {
      final minutes = exerciseSet.duration.floor();
      final seconds = ((exerciseSet.duration * 60) % 60)
          .floor()
          .toString()
          .padLeft(2, '0');
      return "${formatDisplayNumber(context, exerciseSet.weight)} $unit / $minutes:$seconds";
    }
    if (exerciseSet.cardio) {
      return "${formatDisplayNumber(context, exerciseSet.distance)} $unit";
    }
    final weight = "${formatDisplayNumber(context, exerciseSet.weight)} $unit";
    final reps = formatDisplayNumber(context, exerciseSet.reps);
    return repsFirst ? "$reps × $weight" : "$weight × $reps";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push(
          FlexPageRoute(
            builder: (context) => EditSetPage(exerciseSet: exerciseSet),
          ),
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
                    context.l10n.setNumber(number),
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
              Text(_value(context), style: theme.textTheme.titleSmall),
            ],
          ),
        ),
      ),
    );
  }
}
