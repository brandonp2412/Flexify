import 'package:drift/drift.dart' hide Column;
import 'package:flexify/database/database.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabSettings extends StatefulWidget {
  const TabSettings({super.key});

  @override
  createState() => _TabSettingsState();
}

typedef TabSetting = ({String name, bool enabled});

class _TabSettingsState extends State<TabSettings> {
  List<TabSetting> _tabs = [
    (name: 'HistoryPage', enabled: false),
    (name: 'PlansPage', enabled: false),
    (name: 'GraphsPage', enabled: false),
    (name: 'TimerPage', enabled: false),
    (name: 'SettingsPage', enabled: false),
  ];

  @override
  void initState() {
    super.initState();
    final settings = context.read<Setting>();
    final tabSplit = settings.tabs.split(',');

    final enabled = tabSplit.map((tab) => (name: tab, enabled: true)).toList();
    final disabled = _tabs
        .where((tab) => !tabSplit.contains(tab.name))
        .toList();

    _tabs = enabled + disabled;
  }

  void setTab(String name, bool enabled) {
    if (!enabled && _tabs.where((tab) => tab.enabled == true).length == 1) {
      rootScaffoldMessenger.currentState!.showSnackBar(
        SnackBar(
          content: Text(context.l10n.atLeastOneTab),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          duration: const Duration(seconds: 4),
          persist: false,
        ),
      );
      return;
    }
    final index = _tabs.indexWhere((tappedTab) => tappedTab.name == name);
    setState(() {
      _tabs[index] = (name: name, enabled: enabled);
    });

    (db.settings.update().write(
      SettingsCompanion(
        tabs: Value(
          _tabs.where((tab) => tab.enabled).map((tab) => tab.name).join(','),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<Setting>();
    final labels = <String, (IconData, String)>{
      'HistoryPage': (Icons.history, context.l10n.navHistory),
      'PlansPage': (Icons.calendar_today_outlined, context.l10n.navPlans),
      'GraphsPage': (Icons.insights_rounded, context.l10n.navGraphs),
      'TimerPage': (Icons.timer_outlined, context.l10n.navTimer),
      'SettingsPage': (Icons.settings_outlined, context.l10n.navSettings),
    };

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(context.l10n.tabs)),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView(
              padding: const EdgeInsets.only(top: 12, bottom: 116),
              children: [
                Card(
                  margin: EdgeInsets.zero,
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  child: ListTile(
                    leading: const Icon(Icons.swipe),
                    title: Text(context.l10n.swipeBetweenTabs),
                    trailing: Switch(
                      value: settings.scrollableTabs,
                      onChanged: (value) => db.settings.update().write(
                        SettingsCompanion(scrollableTabs: Value(value)),
                      ),
                    ),
                    onTap: () => db.settings.update().write(
                      SettingsCompanion(
                        scrollableTabs: Value(!settings.scrollableTabs),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  margin: EdgeInsets.zero,
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  clipBehavior: Clip.antiAlias,
                  child: ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    buildDefaultDragHandles: false,
                    itemCount: _tabs.length,
                    onReorderItem: (oldIndex, newIndex) {
                      setState(() {
                        final moved = _tabs.removeAt(oldIndex);
                        _tabs.insert(newIndex, moved);
                      });
                      db.settings.update().write(
                        SettingsCompanion(
                          tabs: Value(
                            _tabs
                                .where((tab) => tab.enabled)
                                .map((tab) => tab.name)
                                .join(','),
                          ),
                        ),
                      );
                    },
                    itemBuilder: (context, index) {
                      final tab = _tabs[index];
                      final details = labels[tab.name];
                      if (details == null) {
                        return ListTile(
                          key: Key(tab.name),
                          title: Text(context.l10n.invalidTabSettings),
                        );
                      }
                      return ListTile(
                        key: Key(tab.name),
                        leading: Icon(details.$1),
                        title: Text(details.$2),
                        onTap: () => setTab(tab.name, !tab.enabled),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: tab.enabled,
                              onChanged: (value) => setTab(tab.name, value),
                            ),
                            const SizedBox(width: 12),
                            ReorderableDragStartListener(
                              index: index,
                              child: const Icon(Icons.drag_handle),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
