import 'dart:io';

import 'package:flexify/app_search.dart';
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/foundation.dart' show listEquals;
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
  bool _goingNext = false;
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
    if (!listEquals(oldWidget.sets, widget.sets)) {
      setState(() {
        _current = List.from(widget.sets);
      });
    }
  }

  Widget _buildListItem(GymSet gymSet, int index, bool showImages) {
    final previousGymSet = index > 0
        ? _current.elementAtOrNull(index - 1)
        : null;
    final bool showDivider =
        previousGymSet != null &&
        !isSameDay(gymSet.created, previousGymSet.created);

    final minutes = gymSet.duration.floor();
    final seconds = ((gymSet.duration * 60) % 60).floor().toString().padLeft(
      2,
      '0',
    );
    final distance = toString(gymSet.distance);
    final reps = toString(gymSet.reps);
    final weight = toString(gymSet.weight);
    String incline = '';
    if (gymSet.incline != null && gymSet.incline! > 0) {
      incline = '@ ${gymSet.incline}%';
    }

    Widget? leading;

    if (showImages && gymSet.image != null) {
      leading = GestureDetector(
        onTap: () => widget.onSelect(gymSet.id),
        child: Image.file(
          File(gymSet.image!),
          cacheWidth: 64,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
      );
    } else if (showImages) {
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
          Container(
            color:
                (widget.selected.contains(gymSet.id) &&
                    widget.selected.contains(previousGymSet.id))
                ? Theme.of(context).colorScheme.primary.withValues(alpha: .18)
                : Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Expanded(child: Divider()),
                  const Icon(Icons.today),
                  const SizedBox(width: 4),
                  Selector<SettingsState, String>(
                    selector: (context, settings) =>
                        settings.value.shortDateFormat,
                    builder: (context, value, child) =>
                        Text(DateFormat(value).format(previousGymSet.created)),
                  ),
                  const SizedBox(width: 4),
                  const Expanded(child: Divider()),
                ],
              ),
            ),
          ),
        Builder(
          builder: (context) {
            final desktop = isDesktopLayout(context);
            final colors = Theme.of(context).colorScheme;
            final tile = Material(
              color: widget.selected.contains(gymSet.id)
                  ? colors.primary.withValues(alpha: .18)
                  : desktop
                  ? colors.surfaceContainerLow
                  : Colors.transparent,
              borderRadius: desktop ? BorderRadius.circular(16) : null,
              clipBehavior: desktop ? Clip.antiAlias : Clip.none,
              child: ListTile(
                contentPadding: desktop
                    ? const EdgeInsets.symmetric(horizontal: 20, vertical: 9)
                    : null,
                leading: leading,
                title: Text(
                  gymSet.name,
                  style: desktop
                      ? Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        )
                      : null,
                ),
                subtitle: Selector<SettingsState, String>(
                  selector: (context, settings) =>
                      settings.value.longDateFormat,
                  builder: (context, dateFormat, child) => Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      dateFormat == 'timeago'
                          ? timeago.format(gymSet.created)
                          : DateFormat(dateFormat).format(gymSet.created),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                trailing: Text(
                  trailing,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                onLongPress: () => widget.onSelect(gymSet.id),
                onTap: () {
                  if (widget.selected.isNotEmpty) {
                    widget.onSelect(gymSet.id);
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditSetPage(gymSet: gymSet),
                      ),
                    );
                  }
                },
              ),
            );
            if (!desktop) return tile;
            return ResponsiveContent(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 5,
                ),
                child: tile,
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final showImages = context.select<SettingsState, bool>(
      (settings) => settings.value.showImages,
    );

    return ListView.builder(
      padding: EdgeInsets.only(
        bottom: isDesktopLayout(context) ? 32 : bottomNavHeight,
        top: appSearchHeight + 8,
      ),
      controller: widget.scroll,
      itemCount: _current.length,
      itemBuilder: (context, index) {
        return _buildListItem(_current[index], index, showImages);
      },
    );
  }

  void scrollListener() {
    if (widget.scroll.position.pixels <
            widget.scroll.position.maxScrollExtent - 200 ||
        _goingNext)
      return;
    _goingNext = true;
    widget.onNext();
    setState(() {
      _goingNext = false;
    });
  }

  @override
  void dispose() {
    widget.scroll.removeListener(scrollListener);
    super.dispose();
  }
}
