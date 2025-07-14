import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Filters extends StatefulWidget {
  final TextEditingController repsGtCtrl;
  final TextEditingController repsLtCtrl;
  final TextEditingController weightGtCtrl;
  final TextEditingController weightLtCtrl;
  final String? category;
  final Function(String?) setCategory;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?) setStart;
  final Function(DateTime?) setEnd;
  final Function setStream;

  const Filters({
    super.key,
    required this.repsGtCtrl,
    required this.repsLtCtrl,
    required this.weightGtCtrl,
    required this.weightLtCtrl,
    required this.setStart,
    required this.setEnd,
    required this.setStream,
    required this.startDate,
    required this.endDate,
    required this.category,
    required this.setCategory,
  });

  @override
  createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  int get filtersCount =>
      (widget.startDate != null ? 1 : 0) +
      (widget.endDate != null ? 1 : 0) +
      (widget.category != null ? 1 : 0) +
      (widget.weightGtCtrl.text.isNotEmpty ? 1 : 0) +
      (widget.weightLtCtrl.text.isNotEmpty ? 1 : 0) +
      (widget.repsLtCtrl.text.isNotEmpty ? 1 : 0) +
      (widget.repsGtCtrl.text.isNotEmpty ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    String? reps;
    if (widget.repsGtCtrl.text.isNotEmpty)
      reps = '> ${widget.repsGtCtrl.text} ';
    if (widget.repsLtCtrl.text.isNotEmpty)
      reps = '${reps ?? ''}< ${widget.repsLtCtrl.text}';

    String? weight;
    if (widget.weightGtCtrl.text.isNotEmpty)
      weight = '> ${widget.weightGtCtrl.text} ';
    if (widget.weightLtCtrl.text.isNotEmpty)
      weight = '${weight ?? ''}< ${widget.weightLtCtrl.text}';

    return Badge.count(
      count: filtersCount,
      isLabelVisible: filtersCount > 0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: StreamBuilder(
        stream: categoriesStream,
        builder: (context, snapshot) {
          return PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Category'),
                  value: widget.category,
                  items: snapshot.data
                      ?.map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    widget.setCategory(value);
                    Navigator.pop(context);
                  },
                ),
              ),
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
                          child: material.Column(
                            children: [
                              TextField(
                                onChanged: (value) => widget.setStream(),
                                controller: widget.repsGtCtrl,
                                decoration: const InputDecoration(
                                  labelText: "Greater than",
                                ),
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                              ),
                              TextField(
                                onChanged: (value) => widget.setStream(),
                                controller: widget.repsLtCtrl,
                                decoration: const InputDecoration(
                                  labelText: "Less than",
                                ),
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Clear'),
                            onPressed: () async {
                              widget.repsGtCtrl.text = '';
                              widget.repsLtCtrl.text = '';
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
                          child: material.Column(
                            children: [
                              TextField(
                                onChanged: (value) => widget.setStream(),
                                controller: widget.weightGtCtrl,
                                decoration: const InputDecoration(
                                  labelText: "Greater than",
                                ),
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                              ),
                              TextField(
                                onChanged: (value) => widget.setStream(),
                                controller: widget.weightLtCtrl,
                                decoration: const InputDecoration(
                                  labelText: "Less than",
                                ),
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Clear'),
                            onPressed: () async {
                              widget.weightGtCtrl.text = '';
                              widget.weightLtCtrl.text = '';
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
                    selector: (p0, settings) => settings.value.shortDateFormat,
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
                    if (pickedDate != null)
                      widget.setStart(pickedDate.toLocal());
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: const Text("End date"),
                  subtitle: Selector<SettingsState, String>(
                    selector: (p0, settings) => settings.value.shortDateFormat,
                    builder: (context, shortDateFormat, child) =>
                        widget.endDate != null
                            ? Text(
                                DateFormat(shortDateFormat)
                                    .format(widget.endDate!),
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
                  leading: const Icon(Icons.clear),
                  title: const Text("Clear"),
                  onTap: () async {
                    widget.repsGtCtrl.text = '';
                    widget.repsLtCtrl.text = '';
                    widget.weightGtCtrl.text = '';
                    widget.weightLtCtrl.text = '';
                    widget.setStart(null);
                    widget.setEnd(null);
                    widget.setCategory(null);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
            tooltip: "Filter",
            icon: const Icon(Icons.filter_list),
          );
        },
      ),
    );
  }
}
