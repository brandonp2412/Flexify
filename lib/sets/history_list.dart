import 'dart:io';

import 'package:flexify/database/database.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryList extends StatefulWidget {
  final List<GymSet> gymSets;

  final Function(int) onSelect;
  final Set<int> selected;
  final Function onNext;
  const HistoryList({
    super.key,
    required this.gymSets,
    required this.onSelect,
    required this.selected,
    required this.onNext,
  });

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  bool goingNext = false;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final showImages = context
        .select<SettingsState, bool>((settings) => settings.value.showImages);

    return ListView.builder(
      itemCount: widget.gymSets.length,
      controller: scrollController,
      itemBuilder: (context, index) {
        final gymSet = widget.gymSets[index];
        final previousGymSet = index > 0 ? widget.gymSets[index - 1] : null;

        final bool showDivider = previousGymSet != null &&
            !isSameDay(gymSet.created, previousGymSet.created);
        final minutes = gymSet.duration.floor();
        final seconds =
            ((gymSet.duration * 60) % 60).floor().toString().padLeft(2, '0');

        return Column(
          children: [
            if (showDivider) const Divider(),
            ListTile(
              leading: showImages && gymSet.image != null
                  ? Image.file(
                      File(gymSet.image!),
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    )
                  : null,
              title: Text(gymSet.name),
              subtitle: Selector<SettingsState, String>(
                selector: (context, settings) => settings.value.longDateFormat,
                builder: (context, value, child) => Text(
                  DateFormat(value).format(gymSet.created),
                ),
              ),
              trailing: Text(
                gymSet.cardio
                    ? "${toString(gymSet.distance)} ${gymSet.unit} / $minutes:$seconds"
                    : "${toString(gymSet.reps)} x ${toString(gymSet.weight)} ${gymSet.unit}",
                style: const TextStyle(fontSize: 16),
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
            ),
          ],
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
