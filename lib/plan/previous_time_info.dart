import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Shows a card with every set from the last day this exercise was trained.
///
/// The sets come from [getPreviousExerciseDay], which ignores today so an
/// in-progress session never appears as the previous time.
Future<void> showPreviousTimeInfo(
  BuildContext context, {
  required int exerciseId,
  required String exerciseName,
}) async {
  final previous = await getPreviousExerciseDay(db, exerciseId: exerciseId);
  if (!context.mounted) return;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog.adaptive(
      title: Text(dialogContext.l10n.previousTimeInfo),
      content: previous == null
          ? Text(dialogContext.l10n.noPreviousSessions)
          : _PreviousTimeCard(exerciseName: exerciseName, previous: previous),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(dialogContext.l10n.actionClose),
        ),
      ],
    ),
  );
}

class _PreviousTimeCard extends StatelessWidget {
  const _PreviousTimeCard({required this.exerciseName, required this.previous});

  final String exerciseName;
  final PreviousExerciseDay previous;

  @override
  Widget build(BuildContext context) {
    final shortDateFormat = context.select<Setting, String>(
      (settings) => settings.shortDateFormat,
    );
    final count = formatDisplayNumber(
      context,
      previous.sets.length,
      maximumFractionDigits: 0,
    );

    return SizedBox(
      width: 320,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _dateHeader(context, shortDateFormat),
            for (var i = 0; i < previous.sets.length; i++)
              _setRow(context, previous.sets[i], i + 1),
            const SizedBox(height: 12),
            Text(
              '$exerciseName ($count)',
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateHeader(BuildContext context, String shortDateFormat) {
    final colors = Theme.of(context).colorScheme;
    final weekday = formatDisplayDate(context, previous.day, 'EEE');
    final date = formatDisplayDate(context, previous.day, shortDateFormat);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 16,
            color: colors.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$weekday, $date',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _setRow(
    BuildContext context,
    ExerciseSetView exerciseSet,
    int number,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(_setTitle(context, exerciseSet))),
          Text(
            context.l10n.setNumber(number),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _setTitle(BuildContext context, ExerciseSetView exerciseSet) {
    final minutes = exerciseSet.duration.floor();
    final seconds = ((exerciseSet.duration * 60) % 60)
        .floor()
        .toString()
        .padLeft(2, '0');
    final distance = formatDisplayNumber(context, exerciseSet.distance);
    final reps = formatDisplayNumber(context, exerciseSet.reps);
    final weight = formatDisplayNumber(context, exerciseSet.weight);
    final unit = displayMeasurementUnit(context.l10n, exerciseSet.unit);
    var incline = '';
    if (exerciseSet.incline != null && exerciseSet.incline! > 0) {
      incline =
          '@ ${formatDisplayPercent(context, exerciseSet.incline! / 100, maximumFractionDigits: 0)}';
    }

    if (exerciseSet.cardio &&
        const {'kg', 'lb', 'stone'}.contains(exerciseSet.unit)) {
      return "$weight $unit / $minutes:$seconds $incline";
    }
    if (exerciseSet.cardio &&
        const {'km', 'mi', 'kcal'}.contains(exerciseSet.unit)) {
      return "$distance $unit / $minutes:$seconds $incline";
    }
    return "$reps x $weight $unit";
  }
}
