import 'package:flexify/constants.dart';
import 'package:flutter/material.dart';

class GraphsFilters extends StatefulWidget {
  final String? category;
  final Function(String?) setCategory;

  const GraphsFilters({
    super.key,
    required this.category,
    required this.setCategory,
  });

  @override
  createState() => _GraphsFiltersState();
}

class _GraphsFiltersState extends State<GraphsFilters> {
  int get filtersCount => (widget.category != null ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    return Badge.count(
      count: filtersCount,
      isLabelVisible: filtersCount > 0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            child: DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'Category'),
              value: widget.category,
              items: categories
                  .map(
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
              leading: const Icon(Icons.clear_all),
              title: const Text("Clear"),
              onTap: () async {
                widget.setCategory(null);
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
