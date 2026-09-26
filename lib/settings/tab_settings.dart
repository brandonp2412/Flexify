import 'package:drift/drift.dart' hide Column;
import 'package:flexify/database/database.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
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
    (name: 'CategoriesPage', enabled: false),
    (name: 'PlansPage', enabled: false),
    (name: 'GraphsPage', enabled: false),
    (name: 'TimerPage', enabled: false),
    (name: 'SettingsPage', enabled: false),
  ];

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsState>();
    final tabSplit = settings.value.tabs.split(',');

    final enabled = tabSplit.map((tab) => (name: tab, enabled: true)).toList();
    final disabled = _tabs
        .where((tab) => !tabSplit.contains(tab.name))
        .toList();

    _tabs = enabled + disabled;
  }

  void setTab(String name, bool enabled) {
    if (!enabled && _tabs.where((tab) => tab.enabled == true).length == 1)
      return toast(context.l10n.atLeastOneTab);
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
    final settings = context.watch<SettingsState>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(context.l10n.tabs)),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            ListTile(
              title: Row(
                children: [
                  const Icon(Icons.swipe),
                  SizedBox(width: 8),
                  Text(context.l10n.swipeBetweenTabs),
                ],
              ),
              onTap: () => db.settings.update().write(
                SettingsCompanion(
                  scrollableTabs: Value(!settings.value.scrollableTabs),
                ),
              ),
              leading: Switch(
                value: settings.value.scrollableTabs,
                onChanged: (value) {
                  db.settings.update().write(
                    SettingsCompanion(scrollableTabs: Value(value)),
                  );
                },
              ),
            ),
            Expanded(
              child: ReorderableListView.builder(
                padding: const EdgeInsets.only(bottom: 116),
                onReorderItem: (oldIndex, newIndex) {
                  final temp = _tabs[oldIndex];
                  setState(() {
                    _tabs.removeAt(oldIndex);
                    _tabs.insert(newIndex, temp);
                  });

                  (db.settings.update().write(
                    SettingsCompanion(
                      tabs: Value(
                        _tabs
                            .where((tab) => tab.enabled)
                            .map((tab) => tab.name)
                            .join(','),
                      ),
                    ),
                  ));
                },
                itemBuilder: (context, index) {
                  final tab = _tabs[index];
                  if (tab.name == 'HistoryPage') {
                    return ListTile(
                      key: Key(tab.name),
                      onTap: () => setTab(tab.name, !tab.enabled),
                      leading: Switch(
                        value: tab.enabled,
                        onChanged: (value) => setTab(tab.name, value),
                      ),
                      title: Row(
                        children: [
                          const Icon(Icons.history),
                          SizedBox(width: 8),
                          Text(context.l10n.navHistory),
                        ],
                      ),
                      trailing: ReorderableDragStartListener(
                        index: index,
                        child: const Icon(Icons.drag_handle),
                      ),
                    );
                  } else if (tab.name == 'CategoriesPage') {
                    return ListTile(
                      key: Key(tab.name),
                      onTap: () => setTab(tab.name, !tab.enabled),
                      leading: Switch(
                        value: tab.enabled,
                        onChanged: (value) => setTab(tab.name, value),
                      ),
                      title: Row(
                        children: [
                          const Icon(Icons.category_outlined),
                          SizedBox(width: 8),
                          Text(context.l10n.navCategories),
                        ],
                      ),
                      trailing: ReorderableDragStartListener(
                        index: index,
                        child: const Icon(Icons.drag_handle),
                      ),
                    );
                  } else if (tab.name == 'PlansPage') {
                    return ListTile(
                      key: Key(tab.name),
                      onTap: () => setTab(tab.name, !tab.enabled),
                      leading: Switch(
                        value: tab.enabled,
                        onChanged: (value) => setTab(tab.name, value),
                      ),
                      title: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined),
                          SizedBox(width: 8),
                          Text(context.l10n.navPlans),
                        ],
                      ),
                      trailing: ReorderableDragStartListener(
                        index: index,
                        child: const Icon(Icons.drag_handle),
                      ),
                    );
                  } else if (tab.name == 'GraphsPage') {
                    return ListTile(
                      key: Key(tab.name),
                      onTap: () => setTab(tab.name, !tab.enabled),
                      leading: Switch(
                        value: tab.enabled,
                        onChanged: (value) => setTab(tab.name, value),
                      ),
                      title: Row(
                        children: [
                          const Icon(Icons.insights_rounded),
                          SizedBox(width: 8),
                          Text(context.l10n.navGraphs),
                        ],
                      ),
                      trailing: ReorderableDragStartListener(
                        index: index,
                        child: const Icon(Icons.drag_handle),
                      ),
                    );
                  } else if (tab.name == 'TimerPage') {
                    return ListTile(
                      key: Key(tab.name),
                      onTap: () => setTab(tab.name, !tab.enabled),
                      leading: Switch(
                        value: tab.enabled,
                        onChanged: (value) => setTab(tab.name, value),
                      ),
                      title: Row(
                        children: [
                          const Icon(Icons.timer),
                          SizedBox(width: 8),
                          Text(context.l10n.navTimer),
                        ],
                      ),
                      trailing: ReorderableDragStartListener(
                        index: index,
                        child: const Icon(Icons.drag_handle),
                      ),
                    );
                  } else if (tab.name == 'SettingsPage') {
                    return ListTile(
                      key: Key(tab.name),
                      onTap: () => setTab(tab.name, !tab.enabled),
                      leading: Switch(
                        value: tab.enabled,
                        onChanged: (value) => setTab(tab.name, value),
                      ),
                      title: Row(
                        children: [
                          const Icon(Icons.settings),
                          SizedBox(width: 8),
                          Text(context.l10n.navSettings),
                        ],
                      ),
                      trailing: ReorderableDragStartListener(
                        index: index,
                        child: const Icon(Icons.drag_handle),
                      ),
                    );
                  } else
                    return ErrorWidget(context.l10n.invalidTabSettings);
                },
                itemCount: _tabs.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
