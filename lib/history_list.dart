import 'package:flexify/database/database.dart';
import 'package:flexify/edit_set_page.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({
    super.key,
    required this.gymSets,
    required this.onSelect,
    required this.selected,
    required this.onNext,
  });

  final List<GymSet> gymSets;
  final Function(int) onSelect;
  final Set<int> selected;
  final Function onNext;

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  bool goingNext = false;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
  }

  void _scrollListener() {
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

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

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
              title: Text(gymSet.name),
              subtitle: Text(
                DateFormat(settings.longDateFormat).format(gymSet.created),
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
}
