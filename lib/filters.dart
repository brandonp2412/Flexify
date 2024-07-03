import 'package:flexify/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Filters extends StatefulWidget {
  const Filters({
    super.key,
    required this.repsGtController,
    required this.repsLtController,
    required this.weightGtController,
    required this.weightLtController,
    required this.setStart,
    required this.setEnd,
    required this.setStream,
    this.startDate,
    this.endDate,
  });

  final TextEditingController repsGtController;
  final TextEditingController repsLtController;
  final TextEditingController weightGtController;
  final TextEditingController weightLtController;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?) setStart;
  final Function(DateTime?) setEnd;
  final Function setStream;

  @override
  createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  int get filtersCount =>
      (widget.startDate != null ? 1 : 0) +
      (widget.endDate != null ? 1 : 0) +
      (widget.weightGtController.text.isNotEmpty ? 1 : 0) +
      (widget.weightLtController.text.isNotEmpty ? 1 : 0) +
      (widget.repsLtController.text.isNotEmpty ? 1 : 0) +
      (widget.repsGtController.text.isNotEmpty ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    return Badge.count(
      count: filtersCount,
      isLabelVisible: filtersCount > 0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            child: TextField(
              controller: widget.repsGtController,
              onSubmitted: (value) {
                widget.setStream();
                Navigator.pop(context);
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                label: Row(
                  children: [
                    Text("Reps"),
                    Icon(Icons.arrow_right),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuItem(
            child: TextField(
              controller: widget.repsLtController,
              onSubmitted: (value) {
                widget.setStream();
                Navigator.pop(context);
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                label: Row(
                  children: [
                    Text("Reps"),
                    Icon(Icons.arrow_left),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuItem(
            child: TextField(
              controller: widget.weightGtController,
              onSubmitted: (value) {
                widget.setStream();
                Navigator.pop(context);
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                label: Row(
                  children: [
                    Text("Weight"),
                    Icon(Icons.arrow_right),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuItem(
            child: TextField(
              controller: widget.weightLtController,
              onSubmitted: (value) {
                widget.setStream();
                Navigator.pop(context);
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                label: Row(
                  children: [
                    Text("Weight"),
                    Icon(Icons.arrow_left),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text("Start date"),
              onLongPress: () {
                widget.setStart(null);
                Navigator.pop(context);
              },
              subtitle: Selector<SettingsState, String>(
                selector: (p0, p1) => p1.shortDateFormat,
                builder: (context, shortDateFormat, child) =>
                    widget.startDate != null
                        ? Text(
                            DateFormat(shortDateFormat)
                                .format(widget.startDate!),
                          )
                        : Text(shortDateFormat),
              ),
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: widget.startDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) widget.setStart(pickedDate.toLocal());
                if (context.mounted) Navigator.pop(context);
              },
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text("End date"),
              subtitle: Selector<SettingsState, String>(
                selector: (p0, p1) => p1.shortDateFormat,
                builder: (context, shortDateFormat, child) =>
                    widget.endDate != null
                        ? Text(
                            DateFormat(shortDateFormat).format(widget.endDate!),
                          )
                        : Text(shortDateFormat),
              ),
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: widget.endDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) widget.setEnd(pickedDate.toLocal());
                if (context.mounted) Navigator.pop(context);
              },
              onLongPress: () {
                widget.setEnd(null);
                Navigator.pop(context);
              },
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.clear_all),
              title: const Text("Clear"),
              onTap: () async {
                widget.repsGtController.text = '';
                widget.repsLtController.text = '';
                widget.weightGtController.text = '';
                widget.weightLtController.text = '';
                widget.setStart(null);
                widget.setEnd(null);
                Navigator.pop(context);
              },
            ),
          ),
        ],
        tooltip: "Filter",
        icon: const Icon(Icons.filter_list),
      ),
    );
  }
}
