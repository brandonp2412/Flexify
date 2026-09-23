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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: .45),
        ),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (unitValue != null && unitItems.isNotEmpty)
            SizedBox(
              width: 125,
              child: DropdownButtonFormField<String>(
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
            ),
          SizedBox(
            width: 155,
            child: GraphDateField(
              label: context.l10n.startDate,
              value: startDate,
              hint: shortDateFormat,
              onTap: onSelectStart,
              onClear: onClearStart,
              showClearButton: true,
              compact: true,
            ),
          ),
          SizedBox(
            width: 155,
            child: GraphDateField(
              label: context.l10n.stopDate,
              value: endDate,
              hint: shortDateFormat,
              onTap: onSelectEnd,
              onClear: onClearEnd,
              showClearButton: true,
              compact: true,
            ),
          ),
          SizedBox(
            width: 170,
            child: _LimitControl(
              limit: limit,
              maxLimit: maxLimit,
              onChanged: onLimitChanged,
              compact: true,
            ),
          ),
          if (timeBasedXAxis != null && onTimeBasedXAxisChanged != null)
            SizedBox(
              width: 185,
              child: _CompactSwitch(
                label: context.l10n.useTimeBasedXAxis,
                value: timeBasedXAxis!,
                onChanged: onTimeBasedXAxisChanged!,
              ),
            ),
          const SizedBox(width: 235, child: GraphCurveSettings(compact: true)),
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
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$limit',
            style: theme.textTheme.labelLarge?.copyWith(
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        label,
        SizedBox(
          height: 30,
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
    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.labelLarge),
        ),
        const SizedBox(width: 8),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
