import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/selection_controller.dart';
import 'package:flexify/settings/settings_page.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/weight_page.dart';
import 'package:flexify/platform_page_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Vertical space occupied by [AppSearch] when floated on top of a list: the
/// 56px search pill plus its 16px top padding. List views offset their content
/// by this amount so the first item clears the floating bar.
const double appSearchHeight = 72;

enum _AppSearchMenuAction {
  selectAll,
  clearSelection,
  edit,
  share,
  weight,
  settings,
}

class AppSearch extends StatefulWidget {
  final SelectionController controller;
  final ValueChanged<String> onChange;
  final VoidCallback onSelectAll;
  final Future<void> Function() onDelete;
  final Future<void> Function() onEdit;
  final Future<void> Function() onShare;
  final VoidCallback? onRefresh;
  final Widget? filter;
  final String? confirmText;
  final String? hintText;

  const AppSearch({
    super.key,
    required this.controller,
    required this.onChange,
    required this.onSelectAll,
    required this.onDelete,
    required this.onEdit,
    required this.onShare,
    this.onRefresh,
    this.filter,
    this.confirmText,
    this.hintText,
  });

  @override
  State<AppSearch> createState() => _AppSearchState();
}

class _AppSearchState extends State<AppSearch> {
  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _clearSelection() {
    widget.controller.clear();
    widget.onChange(_ctrl.text);
  }

  Future<void> _handleMenuAction(_AppSearchMenuAction? action) async {
    if (action == null || !mounted) return;

    switch (action) {
      case _AppSearchMenuAction.selectAll:
        widget.onSelectAll();
        break;
      case _AppSearchMenuAction.clearSelection:
        _clearSelection();
        break;
      case _AppSearchMenuAction.edit:
        await widget.onEdit();
        break;
      case _AppSearchMenuAction.share:
        await widget.onShare();
        break;
      case _AppSearchMenuAction.weight:
        await Navigator.of(
          context,
        ).push(FlexPageRoute(builder: (context) => const WeightPage()));
        break;
      case _AppSearchMenuAction.settings:
        await Navigator.of(
          context,
        ).push(FlexPageRoute(builder: (context) => const SettingsPage()));
        if (!mounted) return;
        widget.onRefresh?.call();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sel = widget.controller;
    Widget trailingMain;

    if (sel.isNotEmpty) {
      trailingMain = IconButton(
        key: const ValueKey('deleteButton'),
        icon: const Icon(Icons.delete),
        tooltip: context.l10n.deleteSelected,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(context.l10n.confirmDelete),
                content: Text(
                  widget.confirmText ??
                      context.l10n.deleteRecordsConfirmation(sel.length),
                ),
                actions: <Widget>[
                  TextButton.icon(
                    label: Text(context.l10n.actionCancel),
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton.icon(
                    label: Text(context.l10n.actionDelete),
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      Navigator.pop(context);
                      widget.onDelete();
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    } else if (widget.filter != null) {
      trailingMain = KeyedSubtree(
        key: const ValueKey('filterWidget'),
        child: widget.filter!,
      );
    } else {
      trailingMain = const SizedBox.shrink(key: ValueKey('emptyWidget'));
    }

    final searchPadding = isDesktopLayout(context)
        ? const EdgeInsets.fromLTRB(24, 16, 24, 0)
        : const EdgeInsets.fromLTRB(16, 16, 16, 0);

    return ResponsiveContent(
      maxWidth: 760,
      desktopPadding: EdgeInsets.zero,
      mobilePadding: EdgeInsets.zero,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _focusNode.requestFocus,
        child: Padding(
          padding: searchPadding,
          child: SearchBar(
            hintText: widget.hintText ?? context.l10n.searchHint,
            controller: _ctrl,
            focusNode: _focusNode,
            onTap: () => _focusNode.requestFocus(),
            padding: WidgetStateProperty.all(const EdgeInsets.only(right: 8.0)),
            textCapitalization: TextCapitalization.sentences,
            onChanged: widget.onChange,
            leading: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: sel.isEmpty && _ctrl.text.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 8.0),
                      child: Icon(Icons.search),
                    )
                  : IconButton(
                      tooltip: sel.isNotEmpty
                          ? context.l10n.clearSelection
                          : context.l10n.clearSearch,
                      onPressed: () {
                        if (sel.isNotEmpty) {
                          _clearSelection();
                          return;
                        }
                        _ctrl.clear();
                        widget.onChange('');
                      },
                      icon: const Icon(Icons.arrow_back),
                      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                    ),
            ),
            trailing: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: trailingMain,
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
              ),
              Badge.count(
                count: sel.length,
                isLabelVisible: sel.isNotEmpty,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Selector<Setting, bool>(
                  selector: (p0, settings) => settings.showBodyWeight,
                  builder: (context, showBodyWeight, child) => IconButton(
                    icon: const Icon(Icons.more_vert),
                    tooltip: context.l10n.showMenu,
                    onPressed: () async {
                      final RenderBox button =
                          context.findRenderObject() as RenderBox;
                      final RenderBox overlay =
                          Navigator.of(
                                context,
                              ).overlay!.context.findRenderObject()
                              as RenderBox;
                      final RelativeRect position = RelativeRect.fromRect(
                        Rect.fromPoints(
                          button.localToGlobal(Offset.zero, ancestor: overlay),
                          button.localToGlobal(
                            button.size.bottomRight(Offset.zero),
                            ancestor: overlay,
                          ),
                        ),
                        Offset.zero & overlay.size,
                      );

                      final action = await showMenu<_AppSearchMenuAction>(
                        context: context,
                        position: position,
                        items: [
                          PopupMenuItem(
                            value: _AppSearchMenuAction.selectAll,
                            child: ListTile(
                              leading: const Icon(Icons.done_all),
                              title: Text(context.l10n.selectAll),
                            ),
                          ),
                          if (sel.isNotEmpty) ...[
                            PopupMenuItem(
                              value: _AppSearchMenuAction.clearSelection,
                              child: ListTile(
                                leading: const Icon(Icons.clear_all),
                                title: Text(context.l10n.clearSelection),
                              ),
                            ),
                            PopupMenuItem(
                              value: _AppSearchMenuAction.edit,
                              child: ListTile(
                                leading: const Icon(Icons.edit),
                                title: Text(context.l10n.actionEdit),
                              ),
                            ),
                            PopupMenuItem(
                              value: _AppSearchMenuAction.share,
                              child: ListTile(
                                leading: const Icon(Icons.share),
                                title: Text(context.l10n.actionShare),
                              ),
                            ),
                          ],
                          if (sel.isEmpty)
                            PopupMenuItem(
                              value: _AppSearchMenuAction.weight,
                              child: ListTile(
                                leading: const Icon(Icons.scale),
                                title: Text(context.l10n.weightLabel),
                              ),
                            ),
                          if (sel.isEmpty)
                            PopupMenuItem(
                              value: _AppSearchMenuAction.settings,
                              child: ListTile(
                                leading: const Icon(Icons.settings),
                                title: Text(context.l10n.navSettings),
                              ),
                            ),
                        ],
                      );
                      await _handleMenuAction(action);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _ctrl.dispose();
    super.dispose();
  }
}
