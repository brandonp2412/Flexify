import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';

/// A tappable filled control that displays a labelled date, showing the
/// formatted value or a placeholder hint. Long-press clears the date.
///
/// Used by graph controls to pick a start/stop date range.
class GraphDateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final String hint;
  final VoidCallback onTap;
  final VoidCallback onClear;
  final bool showClearButton;
  final bool compact;

  const GraphDateField({
    super.key,
    required this.label,
    required this.value,
    required this.hint,
    required this.onTap,
    required this.onClear,
    this.showClearButton = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasValue = value != null;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      onLongPress: onClear,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 12,
          vertical: compact ? 7 : 10,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: compact ? 8 : 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasValue ? formatDisplayDate(context, value!, hint) : hint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: hasValue
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                      fontWeight: hasValue
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            if (showClearButton && hasValue) ...[
              const SizedBox(width: 4),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: context.l10n.actionClear,
                onPressed: onClear,
                icon: const Icon(Icons.close, size: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
