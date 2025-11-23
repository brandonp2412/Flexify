import 'dart:io';

import 'package:flexify/database/database.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class HistoryList extends StatefulWidget {
  final List<GymSet> sets;
  final ScrollController scroll;
  final Function(int) onSelect;
  final Set<int> selected;
  final Function onNext;

  const HistoryList({
    super.key,
    required this.sets,
    required this.onSelect,
    required this.selected,
    required this.onNext,
    required this.scroll,
  });

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  bool goingNext = false;
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();
  List<GymSet> _current = [];

  @override
  void initState() {
    super.initState();
    widget.scroll.addListener(scrollListener);
    _current = List.from(widget.sets);
  }

  @override
  void didUpdateWidget(HistoryList oldWidget) {
    super.didUpdateWidget(oldWidget);

    final toRemove = _current
        .where(
          (oldSet) => !widget.sets.contains(oldSet),
        )
        .toList();

    for (var setToRemove in toRemove) {
      final index = _current.indexOf(setToRemove);
      if (index != -1) {
        final removedSet = _current.removeAt(index);
        _key.currentState?.removeItem(
          index,
          (context, animation) => _buildItem(
            removedSet,
            animation,
            index,
            context.read<SettingsState>().value.showImages,
          ),
          duration: const Duration(milliseconds: 300),
        );
      }
    }

    final toAdd = widget.sets
        .where(
          (newSet) => !_current.contains(newSet),
        )
        .toList();

    for (var setToAdd in toAdd) {
      final insertIndex = widget.sets.indexOf(setToAdd);
      if (insertIndex >= 0 && insertIndex <= _current.length) {
        _current.insert(insertIndex, setToAdd);
        _key.currentState?.insertItem(insertIndex, duration: Duration.zero);
      }
    }
  }

  Widget _buildItem(
    GymSet gymSet,
    Animation<double> animation,
    int index,
    bool showImages,
  ) {
    final offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: const Offset(0.0, 0.0),
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(animation);

    final sizeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(animation);

    return SizeTransition(
      sizeFactor: sizeAnimation,
      child: FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: offsetAnimation,
          child: _buildListItem(gymSet, index, showImages),
        ),
      ),
    );
  }

  Widget _buildListItem(GymSet gymSet, int index, bool showImages) {
    final previousGymSet =
        index > 0 ? _current.elementAtOrNull(index - 1) : null;
    final bool showDivider = previousGymSet != null &&
        !isSameDay(gymSet.created, previousGymSet.created);

    final minutes = gymSet.duration.floor();
    final seconds =
        ((gymSet.duration * 60) % 60).floor().toString().padLeft(2, '0');
    final distance = toString(gymSet.distance);
    final reps = toString(gymSet.reps);
    final weight = toString(gymSet.weight);
    String incline = '';
    if (gymSet.incline != null && gymSet.incline! > 0) {
      incline = '@ ${gymSet.incline}%';
    }

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
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
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
              gymSet.name.isNotEmpty ? gymSet.name[0].toUpperCase() : '?',
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

    String trailing = "$reps x $weight ${gymSet.unit}";
    if (gymSet.cardio &&
        (gymSet.unit == 'kg' || gymSet.unit == 'lb' || gymSet.unit == 'stone'))
      trailing = "$weight ${gymSet.unit} / $minutes:$seconds $incline";
    else if (gymSet.cardio &&
        (gymSet.unit == 'km' || gymSet.unit == 'mi' || gymSet.unit == 'kcal'))
      trailing = "$distance ${gymSet.unit} / $minutes:$seconds $incline";

    return Column(
      children: [
        if (showDivider)
          Row(
            children: [
              const Expanded(child: Divider()),
              const Icon(Icons.today),
              const SizedBox(width: 4),
              Selector<SettingsState, String>(
                selector: (context, settings) => settings.value.shortDateFormat,
                builder: (context, value, child) => Text(
                  DateFormat(value).format(previousGymSet.created),
                ),
              ),
              const SizedBox(width: 4),
              const Expanded(child: Divider()),
            ],
          ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: widget.selected.contains(gymSet.id)
                ? Theme.of(context).colorScheme.primary.withValues(alpha: .08)
                : Colors.transparent,
            border: Border.all(
              color: widget.selected.contains(gymSet.id)
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: ListTile(
            leading: leading,
            title: Text(gymSet.name),
            subtitle: Selector<SettingsState, String>(
              selector: (context, settings) => settings.value.longDateFormat,
              builder: (context, dateFormat, child) => Text(
                dateFormat == 'timeago'
                    ? timeago.format(gymSet.created)
                    : DateFormat(dateFormat).format(gymSet.created),
              ),
            ),
            trailing: Text(
              trailing,
              style: const TextStyle(fontSize: 16),
            ),
            onLongPress: () => widget.onSelect(gymSet.id),
            onTap: () {
              if (widget.selected.isNotEmpty) {
                widget.onSelect(gymSet.id);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditSetPage(gymSet: gymSet),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final showImages = context
        .select<SettingsState, bool>((settings) => settings.value.showImages);

    return AnimatedList(
      key: _key,
      initialItemCount: _current.length,
      padding: const EdgeInsets.only(bottom: 96, top: 8),
      controller: widget.scroll,
      itemBuilder: (context, index, animation) {
        return _buildItem(_current[index], animation, index, showImages);
      },
    );
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

  @override
  void dispose() {
    widget.scroll.removeListener(scrollListener);
    super.dispose();
  }
}
