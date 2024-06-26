import 'package:flexify/edit_set_page.dart';
import 'package:flexify/history_page.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryCollapsed extends StatefulWidget {
  const HistoryCollapsed({
    super.key,
    required this.historyDays,
    required this.onSelect,
    required this.selected,
    required this.onNext,
  });

  final List<HistoryDay> historyDays;
  final Function(int) onSelect;
  final Set<int> selected;
  final Function onNext;

  @override
  State<HistoryCollapsed> createState() => _HistoryCollapsedState();
}

class _HistoryCollapsedState extends State<HistoryCollapsed> {
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
    return ListView.builder(
      itemCount: widget.historyDays.length,
      controller: scrollController,
      itemBuilder: (context, index) {
        final history = widget.historyDays[index];
        final previousHistory =
            index > 0 ? widget.historyDays[index - 1] : null;

        final bool showDivider = previousHistory != null &&
            !isSameDay(history.day, previousHistory.day);

        return Column(
          children: [
            if (showDivider)
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Selector<SettingsState, String>(
                    selector: (p0, p1) => p1.shortDateFormat,
                    builder: (context, value, child) => Text(
                      DateFormat(value).format(previousHistory.day),
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
                  return ListTile(
                    title: Text(
                      gymSet.cardio
                          ? "${toString(gymSet.distance)} ${gymSet.unit} / $minutes:$seconds"
                          : "${toString(gymSet.reps)} x ${toString(gymSet.weight)} ${gymSet.unit}",
                    ),
                    subtitle: Selector<SettingsState, String>(
                      selector: (p0, p1) => p1.longDateFormat,
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
          ],
        );
      },
    );
  }
}
