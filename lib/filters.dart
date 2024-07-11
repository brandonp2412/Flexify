import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Filters extends StatefulWidget {
  final TextEditingController repsGtController;

  final TextEditingController repsLtController;
  final TextEditingController weightGtController;
  final TextEditingController weightLtController;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?) setStart;
  final Function(DateTime?) setEnd;
  final Function setStream;
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
    String? reps;
    if (widget.repsGtController.text.isNotEmpty)
      reps = '> ${widget.repsGtController.text} ';
    if (widget.repsLtController.text.isNotEmpty)
      reps = '${reps ?? ''}< ${widget.repsLtController.text}';

    String? weight;
    if (widget.weightGtController.text.isNotEmpty)
      weight = '> ${widget.weightGtController.text} ';
    if (widget.weightLtController.text.isNotEmpty)
      weight = '${weight ?? ''}< ${widget.weightLtController.text}';

    return Badge.count(
      count: filtersCount,
      isLabelVisible: filtersCount > 0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.repeat),
              title: const Text('Reps'),
              subtitle: reps != null ? Text(reps) : null,
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Reps filter"),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            onChanged: (value) => widget.setStream(),
                            controller: widget.repsGtController,
                            decoration: const InputDecoration(
                              labelText: "Greater than",
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          TextField(
                            onChanged: (value) => widget.setStream(),
                            controller: widget.repsLtController,
                            decoration:
                                const InputDecoration(labelText: "Less than"),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Clear'),
                        onPressed: () async {
                          widget.repsGtController.text = '';
                          widget.repsLtController.text = '';
                          widget.setStream();
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.scale),
              title: const Text('Weight'),
              subtitle: weight != null ? Text(weight) : null,
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Weight filter"),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            onChanged: (value) => widget.setStream(),
                            controller: widget.weightGtController,
                            decoration: const InputDecoration(
                              labelText: "Greater than",
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          TextField(
                            onChanged: (value) => widget.setStream(),
                            controller: widget.weightLtController,
                            decoration:
                                const InputDecoration(labelText: "Less than"),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Clear'),
                        onPressed: () async {
                          widget.weightGtController.text = '';
                          widget.weightLtController.text = '';
                          widget.setStream();
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
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
                Navigator.pop(context);
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: widget.startDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) widget.setStart(pickedDate.toLocal());
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
                Navigator.pop(context);
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: widget.endDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) widget.setEnd(pickedDate.toLocal());
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
