import 'dart:io';

import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/sets/history_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class HistoryCollapsed extends StatefulWidget {
  final List<HistoryDay> days;
  final ScrollController scroll;
  final Function(int) onSelect;
  final Set<int> selected;
  final Function onNext;
  const HistoryCollapsed({
    super.key,
    required this.days,
    required this.onSelect,
    required this.selected,
    required this.onNext,
    required this.scroll,
  });

  @override
  State<HistoryCollapsed> createState() => _HistoryCollapsedState();
}

class _HistoryCollapsedState extends State<HistoryCollapsed> {
  bool goingNext = false;

  @override
  Widget build(BuildContext context) {
    final showImages = context
        .select<SettingsState, bool>((settings) => settings.value.showImages);

    return ListView.builder(
      itemCount: widget.days.length,
      padding: const EdgeInsets.only(bottom: 76),
      controller: widget.scroll,
      itemBuilder: (context, index) {
        final history = widget.days[index];
        final prev = index > 0 ? widget.days[index - 1] : null;

        final bool showDivider =
            prev != null && !isSameDay(history.day, prev.day);

        return Column(
          children: historyChildren(
            showDivider,
            prev,
            history,
            context,
            showImages,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.scroll.removeListener(scrollListener);
  }

  List<Widget> historyChildren(
    bool showDivider,
    HistoryDay? prev,
    HistoryDay history,
    BuildContext context,
    bool showImages,
  ) {
    return [
      if (showDivider)
        Row(
          children: [
            const Expanded(child: Divider()),
            const Icon(Icons.today),
            const SizedBox(width: 4),
            Selector<SettingsState, String>(
              selector: (context, settings) => settings.value.shortDateFormat,
              builder: (context, value, child) => Text(
                DateFormat(value).format(prev!.day),
              ),
            ),
            const SizedBox(width: 4),
            const Expanded(child: Divider()),
          ],
        ),
      ExpansionTile(
        title: Text("${history.name} (${history.gymSets.length})"),
        shape: const Border.symmetric(),
        children: history.gymSets.map(
          (gymSet) {
            final minutes = gymSet.duration.floor();
            final seconds = ((gymSet.duration * 60) % 60)
                .floor()
                .toString()
                .padLeft(2, '0');
            final distance = toString(gymSet.distance);
            final reps = toString(gymSet.reps);
            final weight = toString(gymSet.weight);
            String incline = '';
            if (gymSet.incline != null && gymSet.incline! > 0)
              incline = '@ ${gymSet.incline}%';

            Widget? leading = SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: widget.selected.contains(gymSet.id),
                onChanged: (value) {
                  widget.onSelect(gymSet.id);
                },
              ),
            );

            if (widget.selected.isEmpty && showImages && gymSet.image != null) {
              leading = GestureDetector(
                onTap: () => widget.onSelect(gymSet.id),
                child: Image.file(
                  File(gymSet.image!),
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
              );
            } else if (widget.selected.isEmpty) {
              leading = GestureDetector(
                onTap: () => widget.onSelect(gymSet.id),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      gymSet.name.isNotEmpty
                          ? gymSet.name[0].toUpperCase()
                          : '?',
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
            }

            leading = AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: leading,
            );

            return ListTile(
              leading: leading,
              title: Text(
                gymSet.cardio
                    ? "$distance ${gymSet.unit} / $minutes:$seconds $incline"
                    : "$reps x $weight ${gymSet.unit}",
              ),
              selected: widget.selected.contains(gymSet.id),
              subtitle: Selector<SettingsState, String>(
                selector: (context, settings) => settings.value.longDateFormat,
                builder: (context, dateFormat, child) => Text(
                  dateFormat == 'timeago'
                      ? timeago.format(gymSet.created)
                      : DateFormat(dateFormat).format(gymSet.created),
                ),
              ),
              onLongPress: () {
                widget.onSelect(gymSet.id);
              },
              onTap: () {
                if (widget.selected.isNotEmpty)
                  widget.onSelect(gymSet.id);
                else
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditSetPage(gymSet: gymSet),
                    ),
                  );
              },
            );
          },
        ).toList(),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    widget.scroll.addListener(scrollListener);
  }

  void scrollListener() {
    if (widget.scroll.position.pixels <
            widget.scroll.position.maxScrollExtent - 200 ||
        goingNext) return;
    setState(() {
      goingNext = true;
    });
    try {
      widget.onNext();
    } finally {
      setState(() {
        goingNext = false;
      });
    }
  }
}
