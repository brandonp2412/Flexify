import 'package:flexify/graph/graph_curve_settings.dart';
import 'package:flexify/graph/graph_date_field.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flutter/material.dart';

class GraphOptionsControls extends StatelessWidget {
  final bool compact;
  final String shortDateFormat;
  final String? unitValue;
  final List<DropdownMenuItem<String>> unitItems;
  final ValueChanged<String>? onUnitChanged;
  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback onSelectStart;
  final VoidCallback onClearStart;
  final VoidCallback onSelectEnd;
  final VoidCallback onClearEnd;
  final int limit;
  final int maxLimit;
  final ValueChanged<int> onLimitChanged;
  final bool? timeBasedXAxis;
  final ValueChanged<bool>? onTimeBasedXAxisChanged;

  const GraphOptionsControls({
    super.key,
    required this.compact,
    required this.shortDateFormat,
    this.unitValue,
    this.unitItems = const [],
    this.onUnitChanged,
    required this.startDate,
    required this.endDate,
    required this.onSelectStart,
    required this.onClearStart,
    required this.onSelectEnd,
    required this.onClearEnd,
    required this.limit,
    required this.maxLimit,
    required this.onLimitChanged,
    this.timeBasedXAxis,
    this.onTimeBasedXAxisChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (!compact) return _mobileLayout(context);

    final colorScheme = Theme.of(context).colorScheme;
    final topControls = <Widget>[
      if (unitValue != null && unitItems.isNotEmpty)
        DropdownButtonFormField<String>(
          key: ValueKey(unitValue),
          initialValue: unitValue,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: context.l10n.unitLabel,
            isDense: true,
          ),
          items: unitItems,
          onChanged: (value) {
            if (value != null) onUnitChanged?.call(value);
          },
        ),
      GraphDateField(
        label: context.l10n.startDate,
        value: startDate,
        hint: shortDateFormat,
        onTap: onSelectStart,
        onClear: onClearStart,
        showClearButton: true,
        compact: true,
      ),
      GraphDateField(
        label: context.l10n.stopDate,
        value: endDate,
        hint: shortDateFormat,
        onTap: onSelectEnd,
        onClear: onClearEnd,
        showClearButton: true,
        compact: true,
      ),
      _LimitControl(
        limit: limit,
        maxLimit: maxLimit,
        onChanged: onLimitChanged,
        compact: true,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: .45),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var index = 0; index < topControls.length; index++) ...[
                if (index > 0) const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(height: 58, child: topControls[index]),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (timeBasedXAxis != null &&
                  onTimeBasedXAxisChanged != null) ...[
                Expanded(
                  flex: 2,
                  child: _CompactSwitch(
                    label: context.l10n.useTimeBasedXAxis,
                    value: timeBasedXAxis!,
                    onChanged: onTimeBasedXAxisChanged!,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                flex: timeBasedXAxis != null && onTimeBasedXAxisChanged != null
                    ? 5
                    : 1,
                child: const GraphCurveSettings(compact: true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mobileLayout(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget sectionLabel(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: theme.textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (unitValue != null && unitItems.isNotEmpty) ...[
          sectionLabel(context.l10n.unitLabel),
          DropdownButtonFormField<String>(
            key: ValueKey(unitValue),
            initialValue: unitValue,
            items: unitItems,
            onChanged: (value) {
              if (value != null) onUnitChanged?.call(value);
            },
          ),
          const SizedBox(height: 20),
        ],
        sectionLabel(context.l10n.dateRange),
        Row(
          children: [
            Expanded(
              child: GraphDateField(
                label: context.l10n.startDate,
                value: startDate,
                hint: shortDateFormat,
                onTap: onSelectStart,
                onClear: onClearStart,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GraphDateField(
                label: context.l10n.stopDate,
                value: endDate,
                hint: shortDateFormat,
                onTap: onSelectEnd,
                onClear: onClearEnd,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _LimitControl(
          limit: limit,
          maxLimit: maxLimit,
          onChanged: onLimitChanged,
        ),
        if (timeBasedXAxis != null && onTimeBasedXAxisChanged != null)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(context.l10n.useTimeBasedXAxis),
            value: timeBasedXAxis!,
            onChanged: onTimeBasedXAxisChanged,
          ),
        const GraphCurveSettings(),
      ],
    );
  }
}

class _LimitControl extends StatelessWidget {
  final int limit;
  final int maxLimit;
  final ValueChanged<int> onChanged;
  final bool compact;

  const _LimitControl({
    required this.limit,
    required this.maxLimit,
    required this.onChanged,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final label = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            context.l10n.dataPoints,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$limit',
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );

    final slider = Slider(
      value: limit.toDouble(),
      inactiveColor: colorScheme.primary.withValues(alpha: 0.24),
      min: 10,
      max: maxLimit.toDouble(),
      onChanged: (value) => onChanged(value.toInt()),
    );

    if (!compact) {
      return Column(mainAxisSize: MainAxisSize.min, children: [label, slider]);
    }

    return Container(
      height: 58,
      padding: const EdgeInsets.fromLTRB(12, 6, 8, 4),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          label,
          SizedBox(
            height: 24,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              ),
              child: slider,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CompactSwitch({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge,
            ),
          ),
          const SizedBox(width: 8),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
