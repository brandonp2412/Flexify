import 'dart:io';

import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/sets/history_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryCollapsed extends StatefulWidget {
  final List<HistoryDay> historyDays;

  final Function(int) onSelect;
  final Set<int> selected;
  final Function onNext;
  const HistoryCollapsed({
    super.key,
    required this.historyDays,
    required this.onSelect,
    required this.selected,
    required this.onNext,
  });

  @override
  State<HistoryCollapsed> createState() => _HistoryCollapsedState();
}

class _HistoryCollapsedState extends State<HistoryCollapsed> {
  bool goingNext = false;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final showImages = context
        .select<SettingsState, bool>((settings) => settings.value.showImages);

    return ListView.builder(
      itemCount: widget.historyDays.length,
      padding: const EdgeInsets.only(bottom: 76),
      controller: scrollController,
      itemBuilder: (context, index) {
        final history = widget.historyDays[index];
        final previousHistory =
            index > 0 ? widget.historyDays[index - 1] : null;

        final bool showDivider = previousHistory != null &&
            !isSameDay(history.day, previousHistory.day);

        return Column(
          children: historyChildren(
            showDivider,
            previousHistory,
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
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
  }

  List<Widget> historyChildren(
    bool showDivider,
    HistoryDay? previousHistory,
    HistoryDay history,
    BuildContext context,
    bool showImages,
  ) {
    return [
      if (showDivider)
        Row(
          children: [
            const Expanded(child: Divider()),
            Selector<SettingsState, String>(
              selector: (context, settings) => settings.value.shortDateFormat,
              builder: (context, value, child) => Text(
                DateFormat(value).format(previousHistory!.day),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
      ExpansionTile(
        title: Text(history.name),
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

            return ListTile(
              leading: showImages && gymSet.image != null
                  ? Image.file(File(gymSet.image!))
                  : null,
              title: Text(
                gymSet.cardio
                    ? "$distance ${gymSet.unit} / $minutes:$seconds $incline"
                    : "$reps x $weight ${gymSet.unit}",
              ),
              subtitle: Selector<SettingsState, String>(
                selector: (context, settings) => settings.value.longDateFormat,
                builder: (context, value, child) => Text(
                  DateFormat(value).format(gymSet.created),
                ),
              ),
              selected: widget.selected.contains(gymSet.id),
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
    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    if (scrollController.position.pixels <
            scrollController.position.maxScrollExtent - 200 ||
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
