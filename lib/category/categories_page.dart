import 'package:flexify/animated_fab.dart';
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/category/category_exercises_page.dart';
import 'package:flexify/database/categories.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/empty_state.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Lists workout categories. Opening one shows its exercises, where new
/// exercises are added.
///
/// As a home tab ([tabController] set) it keeps its own navigation stack so
/// opened pages stay inside the tab. Without a controller it is a standalone
/// management page.
class CategoriesPage extends StatefulWidget {
  final TabController? tabController;

  const CategoriesPage({super.key, this.tabController});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  @override
  bool get wantKeepAlive => widget.tabController != null;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final tabController = widget.tabController;
    if (tabController == null) return const _CategoriesList();

    return NavigatorPopHandler(
      onPopWithResult: (result) {
        if (_navKey.currentState!.canPop() == false) return;
        final tabs = context.read<SettingsState>().value.tabs.split(',');
        if (tabController.index == tabs.indexOf('CategoriesPage')) {
          _navKey.currentState!.pop();
        }
      },
      child: Navigator(
        key: _navKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
          settings: settings,
          builder: (context) => _CategoriesList(tabController: tabController),
        ),
      ),
    );
  }
}

class _CategoriesList extends StatefulWidget {
  final TabController? tabController;

  const _CategoriesList({this.tabController});

  @override
  State<_CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<_CategoriesList> {
  final _scroll = ScrollController();
  late Stream<List<CategorySummary>> _categories;
  late Stream<int> _uncategorized;

  bool get _isTab => widget.tabController != null;

  @override
  void initState() {
    super.initState();
    _createStreams();
    dbVersion.addListener(_onDatabaseChanged);
  }

  @override
  void dispose() {
    dbVersion.removeListener(_onDatabaseChanged);
    _scroll.dispose();
    super.dispose();
  }

  void _createStreams() {
    _categories = watchCategorySummaries();
    _uncategorized = watchUncategorizedExerciseCount();
  }

  void _onDatabaseChanged() {
    if (!mounted) return;
    setState(_createStreams);
  }

  void _open(String? category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategoryExercisesPage(
          category: category,
          tabController: widget.tabController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final desktop = isDesktopLayout(context);
    final bottomPadding = _isTab && !desktop ? bottomNavHeight + 72 : 96.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(_isTab ? l10n.navCategories : l10n.manageCategories),
        actions: [
          if (desktop)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: FilledButton.icon(
                onPressed: () => showCategoryEditor(context),
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.newCategory),
              ),
            ),
        ],
      ),
      body: StreamBuilder<List<CategorySummary>>(
        stream: _categories,
        builder: (context, snapshot) {
          final categories = snapshot.data ?? const <CategorySummary>[];
          return StreamBuilder<int>(
            stream: _uncategorized,
            builder: (context, uncategorizedSnapshot) {
              final uncategorized = uncategorizedSnapshot.data ?? 0;
              if (snapshot.hasData &&
                  categories.isEmpty &&
                  uncategorized == 0) {
                return AppEmptyState(
                  icon: Icons.category_outlined,
                  title: l10n.noCategories,
                  actionLabel: l10n.newCategory,
                  actionIcon: Icons.add_rounded,
                  onAction: () => showCategoryEditor(context),
                );
              }

              return ListView(
                controller: _scroll,
                padding: EdgeInsets.only(bottom: bottomPadding),
                children: [
                  for (final summary in categories)
                    ResponsiveContent(
                      child: ListTile(
                        leading: const Icon(Icons.label_outline_rounded),
                        title: Text(summary.category.name),
                        subtitle: Text(
                          l10n.categoryExerciseCount(summary.exerciseCount),
                        ),
                        onTap: () => _open(summary.category.name),
                        trailing: _CategoryMenu(
                          summary: summary,
                          categories: categories,
                        ),
                      ),
                    ),
                  if (uncategorized > 0)
                    ResponsiveContent(
                      child: ListTile(
                        leading: const Icon(Icons.label_off_outlined),
                        title: Text(l10n.uncategorized),
                        subtitle: Text(
                          l10n.categoryExerciseCount(uncategorized),
                        ),
                        onTap: () => _open(null),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: desktop
          ? null
          : AnimatedFab(
              onPressed: () => showCategoryEditor(context),
              label: Text(l10n.actionAdd),
              icon: const Icon(Icons.add),
              scroll: _scroll,
            ),
    );
  }
}

enum _CategoryAction { rename, merge, delete }

class _CategoryMenu extends StatelessWidget {
  final CategorySummary summary;
  final List<CategorySummary> categories;

  const _CategoryMenu({required this.summary, required this.categories});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopupMenuButton<_CategoryAction>(
      onSelected: (action) => switch (action) {
        _CategoryAction.rename => showCategoryEditor(
          context,
          category: summary.category,
        ),
        _CategoryAction.merge => _showMergeDialog(
          context,
          source: summary.category,
          categories: categories,
        ),
        _CategoryAction.delete => _showDeleteDialog(context, summary),
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
    );
  }
}

/// Asks for a category name, then creates a category or renames [category].
Future<void> showCategoryEditor(
  BuildContext context, {
  Category? category,
}) async {
  final name = await showDialog<String>(
    context: context,
    builder: (context) => _CategoryNameDialog(category: category),
  );
  if (name == null) return;
  if (category == null) {
    await createCategory(name);
  } else {
    await renameCategory(category, name);
  }
}

class _CategoryNameDialog extends StatefulWidget {
  final Category? category;

  const _CategoryNameDialog({this.category});

  @override
  State<_CategoryNameDialog> createState() => _CategoryNameDialogState();
}

class _CategoryNameDialogState extends State<_CategoryNameDialog> {
  late final _controller = TextEditingController(text: widget.category?.name);
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, _controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final renaming = widget.category != null;
    return AlertDialog(
      title: Text(renaming ? l10n.renameCategory : l10n.newCategory),
      content: Form(
        key: _formKey,
        child: TextFormField(
          autofocus: true,
          controller: _controller,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(labelText: l10n.categoryLabel),
          validator: (value) => value == null || value.trim().isEmpty
              ? l10n.categoryNameRequired
              : null,
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(renaming ? l10n.actionUpdate : l10n.actionAdd),
        ),
      ],
    );
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
