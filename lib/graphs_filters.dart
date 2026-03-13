import 'package:flexify/database/gym_sets.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class GraphsFilters extends StatefulWidget {
  final String? category;
  final Function(String?) setCategory;

  final GraphSort sort;
  final Function(GraphSort) setSort;

  const GraphsFilters({
    super.key,
    required this.category,
    required this.setCategory,
    required this.sort,
    required this.setSort,
  });

  @override
  createState() => _GraphsFiltersState();
}

class _GraphsFiltersState extends State<GraphsFilters> {
  int get count =>
      (widget.category != null ? 1 : 0) +
      (widget.sort != GraphSort.dateDesc ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    return Badge.count(
      count: count,
      isLabelVisible: count > 0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: StreamBuilder(
        stream: getCategoriesStream(),
        builder: (context, snapshot) {
          return PopupMenuButton(
            tooltip: "Filter",
            icon: const Icon(Icons.filter_list),
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: DropdownButtonFormField<GraphSort>(
                  decoration: const InputDecoration(labelText: 'Sort by'),
                  initialValue: widget.sort,
                  items: const [
                    DropdownMenuItem(
                      value: GraphSort.dateDesc,
                      child: Text('Date (newest)'),
                    ),
                    DropdownMenuItem(
                      value: GraphSort.dateAsc,
                      child: Text('Date (oldest)'),
                    ),
                    DropdownMenuItem(
                      value: GraphSort.name,
                      child: Text('Name'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    widget.setSort(value);
                    Navigator.pop(context);
                  },
                ),
              ),
              PopupMenuItem(
                enabled: false,
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Category'),
                  initialValue: widget.category,
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
                  leading: const Icon(Icons.clear),
                  title: const Text("Clear"),
                  onTap: () {
                    widget.setCategory(null);
                    widget.setSort(GraphSort.dateDesc);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
