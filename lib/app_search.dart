import 'package:flexify/selection_controller.dart';
import 'package:flexify/settings/settings_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/weight_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  });

  @override
  State<AppSearch> createState() => _AppSearchState();
}

class _AppSearchState extends State<AppSearch> {
  final TextEditingController ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sel = widget.controller;
    Widget trailingMain;

    if (sel.isNotEmpty) {
      trailingMain = IconButton(
        key: const ValueKey('deleteButton'),
        icon: const Icon(Icons.delete),
        tooltip: "Delete selected",
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirm Delete'),
                content: Text(
                  widget.confirmText ??
                      'Are you sure you want to delete ${sel.length} records? This action is not reversible.',
                ),
                actions: <Widget>[
                  TextButton.icon(
                    label: const Text('Cancel'),
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton.icon(
                    label: const Text('Delete'),
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

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: SearchBar(
        hintText: "Search...",
        controller: ctrl,
        padding: WidgetStateProperty.all(
          const EdgeInsets.only(right: 8.0),
        ),
        textCapitalization: TextCapitalization.sentences,
        onChanged: widget.onChange,
        leading: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: sel.isEmpty && ctrl.text.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 8.0),
                  child: Icon(Icons.search),
                )
              : IconButton(
                  onPressed: () {
                    widget.controller.clear();
                    ctrl.text = '';
                    widget.onChange('');
                  },
                  icon: const Icon(Icons.arrow_back),
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 8.0,
                  ),
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
                tooltip: "Show menu",
                onPressed: () async {
                  final RenderBox button =
                      context.findRenderObject() as RenderBox;
                  final RenderBox overlay = Navigator.of(context)
                      .overlay!
                      .context
                      .findRenderObject() as RenderBox;
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
                          title: const Text('Select all'),
                          onTap: () {
                            Navigator.pop(context);
                            widget.onSelectAll();
                          },
                        ),
                      ),
                      if (sel.isNotEmpty) ...[
                        PopupMenuItem(
                          child: ListTile(
                            leading: const Icon(Icons.edit),
                            title: const Text('Edit'),
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
                            title: const Text('Share'),
                            onTap: () async {
                              await widget.onShare();
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                      if (sel.isEmpty && showBodyWeight)
                        PopupMenuItem(
                          child: ListTile(
                            leading: const Icon(Icons.scale),
                            title: const Text('Weight'),
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
                            title: const Text('Settings'),
                            onTap: () async {
                              Navigator.pop(context);
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SettingsPage(),
                                ),
                              );
                              if (widget.onRefresh != null)
                                widget.onRefresh!();
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
    ctrl.dispose();
    super.dispose();
  }
}
