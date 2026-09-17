import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/selection_controller.dart';
import 'package:flexify/settings/settings_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/weight_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Vertical space occupied by [AppSearch] when floated on top of a list: the
/// 56px search pill plus its 16px top padding. List views offset their content
/// by this amount so the first item clears the floating bar.
const double appSearchHeight = 72;

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

  void _clearSelection() {
    widget.controller.clear();
    widget.onChange(_ctrl.text);
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

    return ResponsiveContent(
      maxWidth: 760,
      desktopPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      mobilePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SearchBar(
        hintText: widget.hintText ?? context.l10n.searchHint,
        controller: _ctrl,
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
            child: Selector<SettingsState, bool>(
              selector: (p0, settings) => settings.value.showBodyWeight,
              builder: (context, showBodyWeight, child) => IconButton(
                icon: const Icon(Icons.more_vert),
                tooltip: context.l10n.showMenu,
                onPressed: () async {
                  final RenderBox button =
                      context.findRenderObject() as RenderBox;
                  final RenderBox overlay =
                      Navigator.of(context).overlay!.context.findRenderObject()
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

                  await showMenu(
                    context: context,
                    position: position,
                    items: [
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(Icons.done_all),
                          title: Text(context.l10n.selectAll),
                          onTap: () {
                            Navigator.pop(context);
                            widget.onSelectAll();
                          },
                        ),
                      ),
                      if (sel.isNotEmpty) ...[
                        PopupMenuItem(
                          child: ListTile(
                            leading: const Icon(Icons.clear_all),
                            title: Text(context.l10n.clearSelection),
                            onTap: () {
                              Navigator.pop(context);
                              _clearSelection();
                            },
                          ),
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            leading: const Icon(Icons.edit),
                            title: Text(context.l10n.actionEdit),
                            onTap: () async {
                              await widget.onEdit();
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            leading: const Icon(Icons.share),
                            title: Text(context.l10n.actionShare),
                            onTap: () async {
                              await widget.onShare();
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                      if (sel.isEmpty)
                        PopupMenuItem(
                          child: ListTile(
                            leading: const Icon(Icons.scale),
                            title: Text(context.l10n.weightLabel),
                            onTap: () async {
                              Navigator.pop(context);
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const WeightPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      if (sel.isEmpty)
                        PopupMenuItem(
                          child: ListTile(
                            leading: const Icon(Icons.settings),
                            title: Text(context.l10n.navSettings),
                            onTap: () async {
                              Navigator.pop(context);
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SettingsPage(),
                                ),
                              );
                              if (widget.onRefresh != null) widget.onRefresh!();
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}
