import 'package:flexify/database/categories.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Lets people create, rename, merge, and remove workout categories.
class CategoryManagementPage extends StatelessWidget {
  const CategoryManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.manageCategories)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCategoryEditor(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.newCategory),
      ),
      body: StreamBuilder<List<CategorySummary>>(
        stream: watchCategorySummaries(),
        builder: (context, snapshot) {
          final categories = snapshot.data ?? const [];
          if (categories.isEmpty) {
            return Center(child: Text(l10n.noCategories));
          }
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final summary = categories[index];
              return ListTile(
                title: Text(summary.category.name),
                subtitle: Text(l10n.categoryUsageCount(summary.usageCount)),
                trailing: PopupMenuButton<_CategoryAction>(
                  onSelected: (action) => switch (action) {
                    _CategoryAction.rename => _showCategoryEditor(
                      context,
                      category: summary.category,
                    ),
                    _CategoryAction.merge => _showMergeDialog(
                      context,
                      source: summary.category,
                      categories: categories,
                    ),
                    _CategoryAction.delete => _showDeleteDialog(
                      context,
                      summary,
                    ),
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: _CategoryAction.rename,
                      child: Text(l10n.renameCategory),
                    ),
                    PopupMenuItem(
                      value: _CategoryAction.merge,
                      child: Text(l10n.mergeCategory),
                    ),
                    PopupMenuItem(
                      value: _CategoryAction.delete,
                      child: Text(l10n.actionDelete),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showCategoryEditor(
    BuildContext context, {
    Category? category,
  }) async {
    final controller = TextEditingController(text: category?.name);
    final formKey = GlobalKey<FormState>();
    final l10n = context.l10n;
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? l10n.newCategory : l10n.renameCategory),
        content: Form(
          key: formKey,
          child: TextFormField(
            autofocus: true,
            controller: controller,
            decoration: InputDecoration(labelText: l10n.categoryLabel),
            validator: (value) => value == null || value.trim().isEmpty
                ? l10n.categoryNameRequired
                : null,
            onFieldSubmitted: (_) {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, controller.text.trim());
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: Text(category == null ? l10n.actionAdd : l10n.actionUpdate),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null) return;
    if (category == null) {
      await createCategory(name);
    } else {
      await renameCategory(category, name);
    }
  }

  Future<void> _showMergeDialog(
    BuildContext context, {
    required Category source,
    required List<CategorySummary> categories,
  }) async {
    final l10n = context.l10n;
    final targets = categories
        .map((summary) => summary.category)
        .where((category) => category.id != source.id)
        .toList();
    if (targets.isEmpty) return;
    final target = await showDialog<Category>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.mergeCategory),
        children: targets
            .map(
              (category) => SimpleDialogOption(
                onPressed: () => Navigator.pop(context, category),
                child: Text(category.name),
              ),
            )
            .toList(),
      ),
    );
    if (target != null) await mergeCategory(source, target);
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    CategorySummary summary,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.deleteCategoryConfirmation(summary.usageCount)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.actionDelete),
          ),
        ],
      ),
    );
    if (confirmed ?? false) await deleteCategory(summary.category);
  }
}

enum _CategoryAction { rename, merge, delete }
