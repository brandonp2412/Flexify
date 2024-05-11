import 'package:flexify/database.dart';
import 'package:flexify/edit_gym_set.dart';
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
  bool _goingNext = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels <
            _scrollController.position.maxScrollExtent - 200 ||
        _goingNext) return;
    setState(() {
      _goingNext = true;
    });
    try {
      widget.onNext();
    } finally {
      setState(() {
        _goingNext = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    return ListView.builder(
      itemCount: widget.gymSets.length,
      controller: _scrollController,
      itemBuilder: (context, index) {
        final gymSet = widget.gymSets[index];
        final previousGymSet = index > 0 ? widget.gymSets[index - 1] : null;

        final bool showDivider = previousGymSet != null &&
            !isSameDay(gymSet.created, previousGymSet.created);

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
                    ? "${gymSet.distance}${gymSet.unit} / ${gymSet.duration}"
                    : "${gymSet.reps} x ${gymSet.weight} ${gymSet.unit}",
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
                      builder: (context) => EditGymSet(gymSet: gymSet),
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
